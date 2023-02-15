resource "random_password" "grafana" {
    length = 24
}

#------------------
resource "kubernetes_secret" "grafana" {
  metadata {
    name = "grafana-auth"
  }

  data = {
    username = "admin"
    password = random_password.grafana.result
  }

  type = "kubernetes.io/grafana-auth"
}

resource "kubernetes_secret" "gongo" {
  metadata {
    name = "gongo-secret"
    namespace = local.namespace_name_gongo
  }

  data = {
    dbPassword = "postgresSuperUserPsw"
    databaseName= "final_project"
    dbUserName: "bigdata"
    dbHostName : "mypostgres.sql.svc.cluster.local"
  }

  type = "Opaque"
}

resource "kubernetes_secret" "gongo_image" {
  metadata {
    name = "regcred"
    namespace = local.namespace_name_gongo
  }

 type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = local.docker-info
  }
}