resource "kubernetes_namespace" "monitoring" {
	metadata {
		name = local.namespace_monitoring_name
	}
}

resource "kubernetes_namespace" "istio-system" {
	metadata {
		name = local.namespace_istio-system_name
	}
}

resource "kubernetes_namespace" "istio-ingress" {
	metadata {

		labels = {

			# istio-ingress configuration

      		istio-injection = "enabled"
    	}
		
		name = local.namespace_istio-ingress_name
	}
}

