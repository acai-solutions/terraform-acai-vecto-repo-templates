# ACAI Solutions
# Copyright (C) 2025 ACAI GmbH
#
# This file is part of ACAI VECTO. Visit https://www.acai.gmbh or https://docs.acai.gmbh for more information.
# 
# Proprietary and Confidential - Licensed under ACAI Rahmen-Lizenzvertrag + Order Form (Subscription required)
# For full license text, see LICENSE file in repository root.
#
# For commercial licensing, contact: contact@acai.gmbh


# ---------------------------------------------------------------------------------------------------------------------
# ¦ VERSIONS
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.3.9"
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ azure-pipelines.yml
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" "azure_pipelines_yaml" {
  template = file("${path.module}/templates/azure-pipelines.yaml.tftpl")
  vars = {
    tf_version      = regex("\\d+\\.\\d+\\.\\d+", var.pipeline_settings.tf_version)
    release_branch  = var.global_settings.ado_repo_release_branch
    variable_groups = jsonencode([for entry in var.global_settings.ado_repo_access_via_pat : entry.variable_group_name])
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ azure-pipelines-templates/10_terraform_preparation.yml
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" "terraform_preparation_yml" {
  template = file("${path.module}/templates/azure-pipelines-templates/10_terraform_preparation.yaml.tftpl")
  vars = {
    ado_agent_pool_name            = var.global_settings.ado_agent_pool_name
    ado_oidc_service_endpoint_name = var.global_settings.ado_oidc_service_endpoint_name
    aws_default_region             = var.global_settings.aws_default_region
    aws_execution_role_arn         = var.pipeline_settings.pipeline_principal_arn
    ado_project_name               = var.global_settings.ado_project_name
    pat_repo_access                = jsonencode([for entry in var.global_settings.ado_repo_access_via_pat : entry.repo_access])
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ azure-pipelines-templates/20_terraform_approval_apply.yml
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" "terraform_approval_apply_yml" {
  template = file("${path.module}/templates/azure-pipelines-templates/20_terraform_approval_apply.yaml.tftpl")
  vars = {
    ado_agent_pool_name            = var.global_settings.ado_agent_pool_name
    ado_oidc_service_endpoint_name = var.global_settings.ado_oidc_service_endpoint_name
    aws_default_region             = var.global_settings.aws_default_region
    aws_execution_role_arn         = var.pipeline_settings.pipeline_principal_arn
    ado_project_name               = var.global_settings.ado_project_name
    pat_repo_access                = jsonencode([for entry in var.global_settings.ado_repo_access_via_pat : entry.repo_access])
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ terraform/backend.tf
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" "backend_tf" {
  template = file("${path.module}/templates/terraform/backend.tf.tftpl")
  vars = {
    tf_state_bucket_region = var.global_settings.aws_tf_state_bucket_region
    tf_state_bucket_name   = var.global_settings.aws_tf_state_bucket_name
    tf_state_filename      = var.pipeline_settings.tf_state_file_name
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ terraform/main.tf
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" "main_tf" {
  template = file("${path.module}/templates/terraform/main.tf.tftpl")
  vars = {
    tf_version = var.pipeline_settings.tf_version
  }
}

locals {
  pipeline_repo_content = {
    "azure-pipelines.yaml"                                       = data.template_file.azure_pipelines_yaml.rendered
    "azure-pipelines-templates/10_terraform_preparation.yaml"    = data.template_file.terraform_preparation_yml.rendered
    "azure-pipelines-templates/20_terraform_approval_apply.yaml" = data.template_file.terraform_approval_apply_yml.rendered
    "terraform/backend.tf"                                       = data.template_file.backend_tf.rendered
    "terraform/main.tf"                                          = data.template_file.main_tf.rendered
    "terraform/provider.tf"                                      = var.pipeline_settings.rendered_provider_tf
    "terraform/variables.tf"                                     = file("${path.module}/templates/terraform/variables.tf")
  }
}
