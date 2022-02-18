resource "kubernetes_secret" "rds-secret-test-tf" {
  metadata {
    name = "weather-app-secret"
    namespace = "test"
  }

  data = {
    dbuser = module.db["${var.rds-test-name}"].db_instance_username
    userpass = module.db["${var.rds-test-name}"].db_master_password
    dbname = module.db["${var.rds-test-name}"].db_instance_name
    weatherdb = module.db["${var.rds-test-name}"].db_instance_endpoint
    clientid = "${var.client-id}"
  }  
}

resource "kubernetes_secret" "rds-secret-prod-tf" {
  metadata {
    name = "weather-app-secret"
    namespace = "prod"
  }

  data = {
    dbuser = module.db["${var.rds-prod-name}"].db_instance_username
    userpass = module.db["${var.rds-prod-name}"].db_master_password
    dbname = module.db["${var.rds-prod-name}"].db_instance_name
    weatherdb = module.db["${var.rds-prod-name}"].db_instance_endpoint
    clientid = "${var.client-id}"
  }
}

resource "kubernetes_secret" "ecr-secret" {
  metadata {
    name = "ecr-secret"
    namespace = "devops"
  }

  data = {
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }

  type = "kubernetes.io/basic-auth"  
}

resource "kubernetes_secret" "ecr-vars-tf" {
  metadata {
    name = "ecr-vars"
    namespace = "devops"
  }

  data = {
    endpoint = data.aws_ecr_authorization_token.token.proxy_endpoint
    url = data.aws_ecr_repository.ecr-data.repository_url
  }
}

