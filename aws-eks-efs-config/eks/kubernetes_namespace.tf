resource "kubernetes_namespace" "istio-system" {
	metadata {
		name = local.namespace_name_istio-system

        labels = {

            kiali-enabled = true
        }
	}
}

resource "kubernetes_namespace" "external-dns" {
	metadata {
		name = local.namespace_name_external-dns
	}
}

resource "kubernetes_namespace" "istio-gateway" {

	metadata {
		name = "istio-gateway"

        labels = {

			# istio-ingress configuration
      		istio-injection = "enabled"
            kiali-enabled = true
        }
	}
}



resource "null_resource" "namespace_depends" {

    depends_on = [
        kubernetes_namespace.istio-system,
        kubernetes_namespace.external-dns,
        kubernetes_namespace.istio-gateway,
    ]
}