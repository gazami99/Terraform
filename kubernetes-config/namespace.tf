resource "kubernetes_namespace" "monitoring" {
	metadata {
		name = local.namespace_name_monitoring

		labels = {

			# istio-ingress configuration
      		istio-injection = "enabled"
			kiali-enabled = true
        }
	}
}

resource "kubernetes_namespace" "sql" {
	metadata {
		name = local.namespace_name_sql

		labels = {

			# istio-ingress configuration
      		# istio-injection = "enabled"
			# kiali-enabled = true
        }
	}
}

resource "kubernetes_namespace" "gongo" {
	metadata {
		name = local.namespace_name_gongo

		labels = {

			# istio-ingress configuration
      		istio-injection = "enabled"
			kiali-enabled = true
			name		  = "prometheus"
        }
	}
}

resource "null_resource" "name_space" {

	depends_on = [
	  kubernetes_namespace.monitoring,
	  kubernetes_namespace.sql,
	  kubernetes_namespace.gongo
	]
}