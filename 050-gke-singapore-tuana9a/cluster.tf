# # NOTE: at first all pods will be pending, it will wait until real workload from us
# resource "google_container_cluster" "zero" {
#   name       = "zero"
#   location   = "asia-southeast1-a"
#   network    = data.google_compute_network.zero.name
#   subnetwork = data.google_compute_subnetwork.zero_singapore.name

#   # We can't create a cluster with no node pool defined, but we want to only use
#   # separately managed node pools. So we create the smallest possible default
#   # node pool and immediately delete it.
#   remove_default_node_pool = true
#   initial_node_count       = 1

#   deletion_protection = false

#   cluster_autoscaling {
#     autoscaling_profile = "OPTIMIZE_UTILIZATION"
#   }
# }
