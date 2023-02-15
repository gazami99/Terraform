resource "helm_release" "local_kubegres" {
    
    chart            = "${path.module}/templates/charts/kubegres"
    name             = "kubegres"
    namespace        = "kubegres"
    create_namespace = true
}

resource "helm_release" "local_config_sql" {
    
    chart      = "${path.module}/templates/charts/config-sql"
    name       = "config-sql"
    namespace  = local.namespace

    values = [
    	templatefile("${path.module}/templates/config-sql-values.yaml", {

          gid = local.gid
          uid = local.uid
        }
      )
    ]

    depends_on = [
      helm_release.local_kubegres
    ]
}