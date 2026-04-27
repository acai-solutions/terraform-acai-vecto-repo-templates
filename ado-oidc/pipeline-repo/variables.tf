# ACAI Solutions
# Copyright (C) 2025 ACAI GmbH
#
# This file is part of ACAI VECTO. Visit https://www.acai.gmbh or https://docs.acai.gmbh for more information.
# 
# Proprietary and Confidential - Licensed under ACAI Rahmen-Lizenzvertrag + Order Form (Subscription required)
# For full license text, see LICENSE file in repository root.
#
# For commercial licensing, contact: contact@acai.gmbh



variable "global_settings" {
  description = "Settings for ADO pipeline repository."
  type = object({
    ado_repo_release_branch        = string
    ado_agent_pool_name            = string
    ado_oidc_service_endpoint_name = string
    ado_project_name               = string
    ado_repo_access_via_pat = list(object({
      variable_group_name = string
      repo_access = object({
        repo_domain       = string
        pat_variable_name = string
      })
    }))
    aws_tf_state_bucket_region     = string
    aws_tf_state_bucket_name       = string
    aws_default_region             = string    
  })
}

variable "pipeline_settings" {
  description = "Settings for ADO pipeline repository."
  type = object({
    pipeline_name          = string
    pipeline_principal_arn = string
    tf_state_file_name     = string
    tf_version             = string
    rendered_provider_tf   = string
  })
}
