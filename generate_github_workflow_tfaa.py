#!/usr/bin/env python3
import sys
import os
import yaml
import re


def to_workflow_file_name(folder: str) -> str:
    return folder.replace("/", "-") + "-tfaa"


def read_terraform_prefix(folder: str) -> str | None:
    """
    Read terraform.tf in `folder` and extract the backend "gcs" prefix value.
    Returns None if the file doesn't exist or no prefix is found.
    """
    tf_path = os.path.join(folder, "terraform.tf")
    if not os.path.isfile(tf_path):
        return None

    with open(tf_path, "r") as f:
        content = f.read()

    match = re.search(r'prefix\s*=\s*"([^"]+)"', content)
    if not match:
        return None

    return match.group(1)


def build_skeleton(folder: str, project_prefix: str, opts: dict) -> dict:
    path_pattern_dir = f"{folder}/**"
    path_pattern_workflow = f".github/workflows/{to_workflow_file_name(folder)}*"

    on_section = {}

    if opts.get("workflow_dispatch", True):
        on_section["workflow_dispatch"] = None

    ignore_paths = opts.get("ignore_paths", [])
    if opts.get("push", True):
        on_section["push"] = {
            "paths": [
                path_pattern_dir,
                f"{project_prefix}-tfaa*",
            ]
            + list(map(lambda x: f"!{x}", ignore_paths)),
            "branches": ["rock-n-roll"],
        }

    return {
        "name": folder,
        "on": on_section,
        "jobs": {
            "main": {
                "permissions": {
                    "contents": "read",
                    "id-token": "write",
                },
                "uses": "./.github/workflows/tfaa.yml",
                "with": {
                    "runs-on": opts.get("runs-on", "self-hosted-0"),
                    "WORKING_DIR": folder,
                    "login-vault": "in-cluster-sa",
                },
                "secrets": "inherit",
            }
        },
    }


def deep_merge(base, override):
    """
    Merge `override` into `base`.
    - dict + dict  -> recursively merged, override wins on conflicting scalar/type keys
    - list + list  -> override items appended to base
    - anything else -> override replaces base
    """
    if isinstance(base, dict) and isinstance(override, dict):
        result = dict(base)
        for key, val in override.items():
            if key in result:
                result[key] = deep_merge(result[key], val)
            else:
                result[key] = val
        return result

    if isinstance(base, list) and isinstance(override, list):
        return base + override

    # scalars, mismatched types, or override introducing a new value: overwrite
    return override


def read_metadata(folder: str) -> dict:
    metadata_path = os.path.join(folder, ".metadata.yml")
    if not os.path.isfile(metadata_path):
        return {}

    with open(metadata_path, "r") as f:
        metadata = yaml.safe_load(f) or {}

    return metadata


def generate_workflow(folder: str, project_prefix: str, metadata={}) -> str | None:
    opts = metadata.get("tfaa") or {}
    if not isinstance(opts, dict):
        print(
            f"Warning: tfaa in {folder} is not a dict, ignoring",
            file=sys.stderr,
        )
        opts = {}

    skeleton = build_skeleton(folder, project_prefix, opts)

    if not skeleton.get("on"):
        print(
            f"Warning: {folder} has no triggers under 'on' after merge", file=sys.stderr
        )

    body = yaml.dump(skeleton, sort_keys=False, default_flow_style=False)
    return body


def main():
    seen = set()
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue

        folder = os.path.dirname(line)
        if not folder:
            print(f"Skipping (no folder): {line}", file=sys.stderr)
            continue

        if folder in seen:
            continue
        seen.add(folder)

        metadata = read_metadata(folder)

        project_prefix = read_terraform_prefix(folder)
        if project_prefix is None:
            print(
                f"Skipping (no prefix found in terraform.tf): {folder}", file=sys.stderr
            )
            continue

        content = generate_workflow(folder, project_prefix, metadata)
        if content is None:
            print(f"Skipping (no .metadata.yml): {folder}", file=sys.stderr)
            continue

        workflow_filename = project_prefix + "-tfaa.yml"
        output_path = os.path.join(".github", "workflows", workflow_filename)

        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        with open(output_path, "w") as f:
            f.write(content)

        print(f"{folder} -> {output_path}")


if __name__ == "__main__":
    main()
