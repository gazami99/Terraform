module "sql" {

    source = "./sql"

    storageClass_name = var.storageClass_name
  
}


module "monitoring" {

    source = "./monitoring"

    storageClass_name = var.storageClass_name

    depends_on = [
      module.sql
    ]
  
}