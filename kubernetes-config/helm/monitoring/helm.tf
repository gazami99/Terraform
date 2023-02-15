# # ### ref https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

# # ### a collection of Grafana, Prometheus, Prometheus Operator fitting with k8s
resource "helm_release" "kube_prometheus_stack" {

	chart            = "kube-prometheus-stack"
	name             = "kube-prometheus-stack"
	namespace        = "monitoring"
	repository       = "https://prometheus-community.github.io/helm-charts"
	version          = "~> 43.2.1"
    create_namespace = true

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

resource "helm_release" "kiali" {

    chart            = "kiali-operator"
    name             = "kiali-operator"
    namespace        = "kiali-operator"
    repository       = "https://kiali.org/helm-charts"
    create_namespace = true

    timeout = 100

    values = [
        templatefile("${path.module}/templates/kiali-operator-value.yaml", {

            cr_create    = true
            cr_namespace = local.namespace 
        })
    ]

    depends_on = [
      helm_release.kube_prometheus_stack
    ]
}


# update later
# resource "helm_release" "jaeger" {

#     chart      = "jaeger-operator"
#     name       = "jaeger"
#     namespace  = local.namespace
#     repository = "https://jaegertracing.github.io/helm-charts"
#     version    = "~> 2.39.0"

#     values = [
#         templatefile("${path.module}/templates/jaeger-operator-value.yaml", {
#         })
#     ]
# }

resource "helm_release" "argocd" {

    chart      = "argo-cd"
    name       = "argocd"
    namespace  = local.namespace
    repository = "https://argoproj.github.io/argo-helm"
    version    = "~> 5.16.0"

        values = [
        templatefile("${path.module}/templates/argocd-value.yaml", {

            cr_create    = true
            cr_namespace = local.namespace 
        })
    ]

    depends_on = [
      helm_release.kiali
    ]
}

resource "null_resource" "helm_after" {

    depends_on = [
      helm_release.kiali,
      helm_release.argocd,
    ]
}

