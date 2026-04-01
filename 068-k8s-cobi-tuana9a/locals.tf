locals {
  cluster = {
    # construct cluster from inventory.yml
    # mostly keeping their own original value
    # adding just deriviated fields
    for vmip, vm in yamldecode(file("./inventory.yml"))["k8s_cluster"]["hosts"] :
    vm["nodename"] => merge(vm, {
      address        = "${vmip}/24"
      network_device = vm["pve_network_device"]
    })
  }
}
