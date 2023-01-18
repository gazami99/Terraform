# ### ref https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

# ### a collection of Grafana, Prometheus, Prometheus Operator fitting with k8s
resource "helm_release" "kube_prometheus_stack" {

	chart      = "kube-prometheus-stack"
	name       = "kube-prometheus-stack"
	namespace  =  local.namespace
	repository = "https://prometheus-community.github.io/helm-charts"
	version    = "~> 43.2.1"

    values = [
        templatefile("${path.module}/templates/prometheus-stack-value.yaml", {

        prometheus_pvc_storageClassName   = local.storageClassName
        prometheus_pvc_storageSize        = local.prometheus_storageSize

        alertmanager_pvc_storageClassName = local.storageClassName
        alertmanager_pvc_storageSize      = local.alertmanager_storageSize

        grafana_pvc_storageClassName      = local.storageClassName
        grafana_pvc_storageSize           = local.grafana_storageSize
    })
  ]

}
