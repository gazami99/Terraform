resource "helm_release" "local_config_monitoring" {
    
    chart      = "${path.module}/templates/charts/config-monitoring"
    name       = "config-monitoring"
    namespace  = local.namespace

    depends_on = [
      null_resource.helm_after
    ]
}