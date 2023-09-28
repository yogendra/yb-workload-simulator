
module "app-intel"{
  source = "github.com/yogendra/terraform-modules//yugabyte/infra/aws/app-box"
  tags = local.tags
  prefix = var.name
  app-name = "wls-intel"
  hostname = "wls-intel-aws-ug"
  aws-subnet-id = var.subnets[0]
  aws-security-group-ids = var.app-sg
  aws-keypair-name = var.keypair-name
  aws-machine-type = "t3.large"
  aws-instance-profile = ""
  arch = "amd64"
  files = [
    {
      path = "/opt/yugabyte/config/application.yaml"
      content = base64encode(yamlencode(local.wls-intel-config))
      encoding = "b64"
    }
  ]
  startup-commands = [
    "docker run -v /opt/yugabyte/config:/opt/yugabyte/config:ro  --restart=always --pull=always -d --name x86-app --hostname x86-app -p 80:8080  yogendra/yb-workload-simu-app"
  ]
}



module "app-arm"{
  source = "github.com/yogendra/terraform-modules//yugabyte/infra/aws/app-box"
  tags = local.tags
  prefix = var.name
  app-name = "wls-arm"
  hostname = "wls-arm-aws-ug"
  aws-subnet-id = var.subnets[0]
  aws-security-group-ids = var.app-sg
  aws-keypair-name = var.keypair-name
  aws-machine-type = "t3.large"
  aws-instance-profile = ""
  arch = "amd64"
  files = [
    {
      path = "/opt/yugabyte/config/application.yaml"
      content = base64encode(yamlencode(local.wls-arm-config))
      encoding = "b64"
    }
  ]
  startup-commands = [
    "docker run -v /opt/yugabyte/config:/opt/yugabyte/config:ro  --restart=always --pull=always -d --name x86-app --hostname x86-app -p 80:8080  yogendra/yb-workload-simu-app"
  ]
}

