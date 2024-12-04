#!/usr/bin/env python3

import os
import json
import requests
import argparse


def load_vault_token(args):
    if args:
        if args.vault_token:
            return args.vault_token
        if args.vault_token_file:
            with open(args.vault_token_file) as f:
                return f.read().strip()

    if os.getenv("VAULT_TOKEN"):
        return os.getenv("VAULT_TOKEN")


def put(args):
    vault_addr = args.vault_addr

    if args.vault_token:
        vault_token = args.vault_token
    elif os.getenv("VAULT_TOKEN"):
        vault_token = os.getenv("VAULT_TOKEN")
    elif args.vault_token_file:
        with open(args.vault_token_file) as f:
            vault_token = f.read().strip()

    with open(args.secrets_file, "r") as f:
        secrets = json.load(f)

    for path in secrets:
        secret_data = secrets.get(path)
        headers = {"X-Vault-Token": vault_token,
                   "Content-Type": "application/json"}
        response = requests.post(
            f"{vault_addr}/v1/{path}", headers=headers, json=secret_data)
        if response.status_code >= 200 and response.status_code < 300:
            print(f"OK put {path}")
        else:
            print(
                f"FUCK put {path} - {response.status_code} - {response.text}")


def delete(args):
    vault_addr = args.vault_addr

    if args.vault_token:
        vault_token = args.vault_token
    elif os.getenv("VAULT_TOKEN"):
        vault_token = os.getenv("VAULT_TOKEN")
    elif args.vault_token_file:
        with open(args.vault_token_file) as f:
            vault_token = f.read().strip()

    with open(args.secrets_file, "r") as f:
        secrets = json.load(f)

    for path in secrets:
        response = requests.delete(f"{vault_addr}/v1/{path}",
                                   headers={"X-Vault-Token": vault_token,
                                            "Content-Type": "application/json"})
        if response.status_code >= 200 and response.status_code < 300:
            print(f"OK del {path}")
        else:
            print(
                f"FUCK del {path} - {response.status_code} - {response.text}")


# Set up argument parser
parser = argparse.ArgumentParser(description="vault.py")

# Define arguments
parser.add_argument(
    "--vault-addr",
    type=str,
    default=os.getenv("VAULT_ADDR", "https://vault.tuana9a.com"),
    help="The Vault address (default: https://vault.tuana9a.com)",
)

parser.add_argument(
    "--vault-token",
    type=str,
    help="The Vault token (if not provided, it will be read from VAULT_TOKEN_FILE)",
)

parser.add_argument(
    "--vault-token-file",
    type=str,
    help="The file containing the Vault token (if --vault_token is not provided)",
    default=f"{os.getenv('HOME')}/.vault-token",
)

sub_parser = parser.add_subparsers(required=True)

put_parser = sub_parser.add_parser("put")
put_parser.add_argument(
    "--secrets-file",
    type=str,
    default=os.getenv("SECRETS_FILE", "secrets.json"),
    help="The path to the secrets file (default: secrets.json)",
)
put_parser.set_defaults(func=put)

delete_parser = sub_parser.add_parser("delete", aliases=["del"])
delete_parser.add_argument(
    "--secrets-file",
    type=str,
    default=os.getenv("SECRETS_FILE", "secrets.json"),
    help="The path to the secrets file (default: secrets.json)",
)
delete_parser.set_defaults(func=delete)


def main():

    # Parse arguments
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
