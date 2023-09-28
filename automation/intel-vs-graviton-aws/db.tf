module "db-intel-first" {
  source = "github.com/yogendra/terraform-modules//yugabyte/infra/aws/yugabytedb-node"
  config = merge(local.default-intel-config, {
    hostname  = "${var.name}-db-intel-n1"
  })
}

module "db-intel-rest" {
  count  = local.nodes - 1
  source = "github.com/yogendra/terraform-modules//yugabyte/infra/aws/yugabytedb-node"
  config = merge(local.default-intel-config, {
    hostname    = "${var.name}-db-intel-n${count.index + 2}"
    join-master = module.db-intel-first.vm-private-ip
    aws-subnet-id          = var.subnets[count.index + 1]
  })
}




module "db-arm-first" {
  source = "github.com/yogendra/terraform-modules//yugabyte/infra/aws/yugabytedb-node"
  config = merge(local.default-arm-config, {
    hostname = "${var.name}-db-arm-n1"
  })
}

module "db-arm-rest" {
  count  = local.nodes - 1
  source = "github.com/yogendra/terraform-modules//yugabyte/infra/aws/yugabytedb-node"
  config = merge(local.default-arm-config, {
    hostname    = "${var.name}-db-arm-n${count.index + 2}"
    join-master = module.db-arm-first.vm-private-ip
    aws-subnet-id          = var.subnets[count.index + 1]
  })
}



locals {
  db-intel-nodes = concat([module.db-intel-first], module.db-intel-rest[*])
  db-arm-nodes = concat([module.db-arm-first], module.db-arm-rest[*])
}


