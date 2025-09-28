#!/bin/env python3

import json
import yaml
import sys

with open(sys.argv[1], "r") as f:
    data = json.loads(f.read())
    output = yaml.dump(data, default_flow_style=False)
    print(output)
