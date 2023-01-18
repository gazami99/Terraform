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
