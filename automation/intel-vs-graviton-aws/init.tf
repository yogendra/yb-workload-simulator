terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
  default_tags {
    tags = local.tags
  }
}
locals {
  nodes = 3
  tags = {
    yb_owner = "yrampuria"
    yb_dept  = "sales"
    yb_env   = "sandbox"
    yb_task  = "test yugabytedb-nodes single region"
  }
  yb-config = {
    "ysql_port" = "5433"
  }
  master-gflags = {
    enable_ysql = "true"
  }
  tserver-gflags = {
    ysql_enable_auth         = "false"
    pg_yb_session_timeout_ms = "1200000"
    ysql_max_connections     = "400"
  }
  yb-params = {
    ui = "true"
  }

  default-config = {
    aws-keypair-name       = var.keypair-name
    aws-security-group-ids = var.db-sg
    aws-subnet-id          = var.subnets[0]
    tags                   = local.tags
    yugabyted-parameters   = local.yb-params
    yugabyted-config       = local.yb-config
    master-gflags          = local.master-gflags
    tserver-gflags         = local.tserver-gflags
    replication-factor     = 3
    fault-tolerance        = "zone"
  }

  default-arm-config = merge(local.default-config, {
    arch                   = "arm64"
    aws-machine-type       = "t4g.2xlarge"
    cluster-name           = "yb-demo-arm"
  })
  default-intel-config = merge(local.default-config, {
    arch                   = "x86_64"
    aws-machine-type       = "t3.2xlarge"
    cluster-name           = "yb-demo-intel"
  })

  wls-intel-config = {
    spring = {
      application = {
        name = "YugabyteDB Intel Demo"
      }
      datasource = {
        hikari = {
          username = "yugabyte"
          password = ""
          data-source-properties = {
            serverName = local.db-intel-nodes[0].vm-private-ip
            databaseName = "yugabyte"
            topologyKeys = "aws.ap-southeast-1.*"
            additionalEndpoints = join(",",formatlist("%s:5433",local.db-intel-nodes[*].vm-private-ip))
          }
        }
      }
    }
    security = {
      require-ssl = false
    }
    server = {
      ssl = {
        enabled-protocols = "TLSv1.2"
        enabled = "false"
        key-store-type = "PKCS12"
        protocol = "TLS"
      }
    }
  }

  wls-arm-config = {
    spring = {
      application = {
        name = "YugabyteDB ARM Demo"
      }
      datasource = {
        hikari = {
          username = "yugabyte"
          password = ""
          data-source-properties = {
            serverName = local.db-intel-nodes[0].vm-private-ip
            databaseName = "yugabyte"
            topologyKeys = "aws.ap-southeast-1.*"
            additionalEndpoints = join(",",formatlist("%s:5433",local.db-arm-nodes[*].vm-private-ip))
          }
        }
      }
    }
    security = {
      require-ssl = false
    }
    server = {
      ssl = {
        enabled-protocols = "TLSv1.2"
        enabled = "false"
        key-store-type = "PKCS12"
        protocol = "TLS"
      }
    }
  }
}
