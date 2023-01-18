resource "helm_release" "istio-base" {
    
    chart      = "istiod"
    name       = "istiod"
    namespace  = local.namespace
    repository = "https://istio-release.storage.googleapis.com/charts"
    version    = "~> 1.16.1"
    
}