locals {

    namespace                 = "monitoring"

    storageClassName          = "efs-sc"


    alertmanager_storageSize  = "10Gi"

    prometheus_storageSize    = "10Gi"

    grafana_storageSize       = "10Gi"

}