#!/usr/bin/env python3

instance_type_list = [
    "e2-small",
    "e2-medium",
    "e2-highcpu-2",
    "e2-highcpu-4",
]

tmpl = """# generated by gen_node_pool_spot.py
resource "google_container_node_pool" "spot_{{instance_type_snake_case}}" {
  name     = "spot-{{instance_type_kebab_case}}"
  location = google_container_cluster.zero.location
  cluster  = google_container_cluster.zero.name

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = 5
  }

  network_config {
    enable_private_nodes = true
  }

  node_config {
    spot         = true
    machine_type = "{{instance_type}}"
    disk_size_gb = 20
  }
}
"""

contents = []

for x in instance_type_list:
    instance_type = x
    instance_type_kebab_case = x
    instance_type_snake_case = x.replace("-", "_")
    contents.append(tmpl.replace("{{instance_type}}", instance_type)
                        .replace("{{instance_type_kebab_case}}", instance_type_kebab_case)
                        .replace("{{instance_type_snake_case}}", instance_type_snake_case))

with open("node_pool_spot.tf", "w") as fuck:
    fuck.write("\n".join(contents))