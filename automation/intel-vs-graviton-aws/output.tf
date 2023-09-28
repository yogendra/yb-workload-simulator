# output "app-intel" {
#   value = module.app-intel
# }

# output "app-arm" {
#   value = module.app-arm
# }

# output "db-arm" {
#   value = local.db-arm-nodes
# }

# output "db-intel" {
#   value = local.db-intel-nodes
# }

output "information"{
  value = <<EOF
ARM
  DB: ${join(",",local.db-arm-nodes.*.vm-private-ip)}
      http://${local.db-arm-nodes[0].vm-private-ip}:15433
      http://${local.db-arm-nodes[0].vm-private-ip}:7000

  APP: http://${module.app-arm.vm-private-ip}
Intel
  DB: ${join(",",local.db-intel-nodes.*.vm-private-ip)}
      http://${local.db-intel-nodes[0].vm-private-ip}:15433
      http://${local.db-intel-nodes[0].vm-private-ip}:7000

  APP: http://${module.app-intel.vm-private-ip}
EOF
}
