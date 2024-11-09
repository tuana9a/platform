#!/usr/bin/env python3

import os
import json
import requests
import argparse


def main():
    vault_addr = "https://vault.tuana9a.com"
    path = "kv/platform/ansible-vault"
    vault_token = os.getenv("VAULT_TOKEN")
    if not vault_token:
        with open(f"{os.getenv('HOME')}/.vault-token") as f:
            vault_token = f.read().strip()
    url = f"{vault_addr}/v1/{path}"
    headers = {"X-Vault-Token": vault_token,
               "Content-Type": "application/json"}
    response = requests.get(url, headers=headers)
    if response.status_code >= 200 and response.status_code < 300:
        print(response.json()["data"]["password"])
        return
    print(f"Failed to get {path}: {response.status_code} - {response.text}")


if __name__ == "__main__":
    main()
