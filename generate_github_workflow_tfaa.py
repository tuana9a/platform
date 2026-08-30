#!/usr/bin/env python3
import sys
import os
import yaml


def to_workflow_file_name(folder: str) -> str:
    return folder.replace("/", "-") + "-tfaa"


def build_skeleton(folder: str, opts: dict) -> dict:
    path_pattern_dir = f"{folder}/**"
    path_pattern_workflow = f".github/workflows/{to_workflow_file_name(folder)}*"

    on_section = {}

    if opts.get("workflow_dispatch", True):
        on_section["workflow_dispatch"] = None

    if opts.get("push", True):
        on_section["push"] = {
            "paths": [path_pattern_dir, path_pattern_workflow],
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
                    "runs-on": "self-hosted-0",
                    "WORKING_DIR": folder,
                    "login-vault-in-cluster-sa": True
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


def generate_workflow(folder: str, metadata={}) -> str | None:
    opts = metadata.get("github_workflow_opts") or {}
    if not isinstance(opts, dict):
        print(
            f"Warning: github_workflow_opts in {folder} is not a dict, ignoring",
            file=sys.stderr,
        )
        opts = {}

    skeleton = build_skeleton(folder, opts)

    github_workflow = metadata.get("github_workflow")
    if github_workflow:
        skeleton = deep_merge(skeleton, github_workflow)

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
        content = generate_workflow(folder, metadata)
        if content is None:
            print(f"Skipping (no .metadata.yml): {folder}", file=sys.stderr)
            continue

        workflow_filename = to_workflow_file_name(folder) + ".yml"
        output_path = os.path.join(".github", "workflows", workflow_filename)

        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        with open(output_path, "w") as f:
            f.write(content)

        print(f"{folder} -> {output_path}")


if __name__ == "__main__":
    main()
