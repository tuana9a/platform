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


def read_metadata(folder: str) -> dict:
    metadata_path = os.path.join(folder, ".metadata.yml")
    if not os.path.isfile(metadata_path):
        return {}

    with open(metadata_path, "r") as f:
        metadata = yaml.safe_load(f) or {}

    return metadata


def generate_workflow(folder: str, worflow_filepath: str, opts={}) -> str | None:
    path_pattern_dir = f"{folder}/**"

    on_section = {}

    if opts.get("workflow_dispatch", True):
        on_section["workflow_dispatch"] = None

    ignore_paths = opts.get("ignore_paths", [])
    if opts.get("push", True):
        on_section["push"] = {
            "paths": [
                path_pattern_dir,
                worflow_filepath,
            ]
            + list(map(lambda x: f"!{x}", ignore_paths)),
            "branches": ["rock-n-roll"],
        }

    skeleton = {
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

    if not skeleton.get("on"):
        print(
            f"Warning: {folder} has no triggers under 'on'", file=sys.stderr
        )

    result = yaml.dump(skeleton, sort_keys=False, default_flow_style=False)
    return result


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
            print(f"Skipping (folder seen): {line}", file=sys.stderr)
            continue
        seen.add(folder)

        metadata = read_metadata(folder)
        project_prefix = read_terraform_prefix(folder)

        if project_prefix is None:
            print(
                f"Skipping (no prefix found in terraform.tf): {folder}", file=sys.stderr
            )
            continue

        workflow_filename = project_prefix + "-tfaa.yml"
        worflow_filepath = os.path.join(".github", "workflows", workflow_filename)
        opts = metadata.get("tfaa", {})

        content = generate_workflow(folder, worflow_filepath, opts)
        if content is None:
            print(f"Skipping (no .metadata.yml): {folder}", file=sys.stderr)
            continue

        os.makedirs(os.path.dirname(worflow_filepath), exist_ok=True)
        with open(worflow_filepath, "w") as f:
            f.write(content)

        print(f"{folder} -> {worflow_filepath}")


if __name__ == "__main__":
    main()
