resource "helm_release" "istio-base" {
    
    chart      = "base"
    name       = "istio-base"
    namespace  = local.namespace
    repository = "https://istio-release.storage.googleapis.com/charts"
    version    = "~> 1.16.1"
    
}