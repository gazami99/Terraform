locals {

    namespace                 = "monitoring"

    storageClassName          =  var.storageClass_name


    alertmanager_storageSize  = "10Gi"

    prometheus_storageSize    = "10Gi"

    grafana_storageSize       = "10Gi"

}