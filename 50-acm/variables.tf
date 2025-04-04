variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        project = "expense"
        environment = "dev"
        terraform = "true"
    }
}

variable "backend_tags" {
    default = {}
}

variable "domain_name" {
    default = "lakshman.site"
}

variable "zone_id" {
    default = "Z07172932DMBUP1VNKM3L"
}