# # generated by gen_node_pool_spot.py
# resource "google_container_node_pool" "node_pool_spot_e2_medium" {
#   name     = "${google_container_cluster.zero.name}-e2-medium"
#   location = google_container_cluster.zero.location
#   cluster  = google_container_cluster.zero.name

#   autoscaling {
#     total_min_node_count = 0
#     total_max_node_count = 2
#   }

#   network_config {
#     enable_private_nodes = true
#   }

#   node_config {
#     spot         = true
#     machine_type = "e2-medium"
#     disk_size_gb = 20
#   }
# }

# # generated by gen_node_pool_spot.py
# resource "google_container_node_pool" "node_pool_spot_e2_highcpu_2" {
#   name     = "${google_container_cluster.zero.name}-e2-highcpu-2"
#   location = google_container_cluster.zero.location
#   cluster  = google_container_cluster.zero.name

#   autoscaling {
#     total_min_node_count = 0
#     total_max_node_count = 2
#   }

#   network_config {
#     enable_private_nodes = true
#   }

#   node_config {
#     spot         = true
#     machine_type = "e2-highcpu-2"
#     disk_size_gb = 20
#   }
# }

# # generated by gen_node_pool_spot.py
# resource "google_container_node_pool" "node_pool_spot_e2_highcpu_4" {
#   name     = "${google_container_cluster.zero.name}-e2-highcpu-4"
#   location = google_container_cluster.zero.location
#   cluster  = google_container_cluster.zero.name

#   autoscaling {
#     total_min_node_count = 0
#     total_max_node_count = 2
#   }

#   network_config {
#     enable_private_nodes = true
#   }

#   node_config {
#     spot         = true
#     machine_type = "e2-highcpu-4"
#     disk_size_gb = 20
#   }
# }

