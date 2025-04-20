#!/usr/bin/env python3

import os
import json
import requests
import argparse


def _get_vault_token(args=None):
    if os.getenv("VAULT_TOKEN"):
        return os.getenv("VAULT_TOKEN")
    if args:
        if args.vault_token:
            return args.vault_token
        if args.vault_token_file:
            with open(args.vault_token_file) as f:
                return f.read().strip()
    raise Exception("can not get vault token")


def put_secrets(args):
    vault_addr = args.vault_addr
    vault_token = _get_vault_token(args)

    with open(args.secrets_file, "r") as f:
        secrets = json.load(f)
        for path in secrets:
            data = secrets.get(path)
            response = requests.post(
                f"{vault_addr}/v1/{path}",
                headers={
                    "X-Vault-Token": vault_token,
                    "Content-Type": "application/json",
                },
                json=data,
            )
            joke = (
                "OK"
                if response.status_code >= 200 and response.status_code < 300
                else "FUCK"
            )
            print(f"{joke} - {response.status_code} - POST {path} - {response.text}")


def delete_secrets(args):
    vault_addr = args.vault_addr
    vault_token = _get_vault_token(args)

    with open(args.secrets_file, "r") as f:
        secrets = json.load(f)
        for path in secrets:
            response = requests.delete(
                f"{vault_addr}/v1/{path}",
                headers={
                    "X-Vault-Token": vault_token,
                    "Content-Type": "application/json",
                },
            )
            joke = (
                "OK"
                if response.status_code >= 200 and response.status_code < 300
                else "FUCK"
            )
            print(f"{joke} - {response.status_code} - DELETE {path} - {response.text}")


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
put_parser.set_defaults(func=put_secrets)

delete_parser = sub_parser.add_parser("delete", aliases=["del"])
delete_parser.add_argument(
    "--secrets-file",
    type=str,
    default=os.getenv("SECRETS_FILE", "secrets.json"),
    help="The path to the secrets file (default: secrets.json)",
)
delete_parser.set_defaults(func=delete_secrets)


def main():
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
