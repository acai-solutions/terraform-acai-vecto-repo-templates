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
# ¦ LOCALS
# ---------------------------------------------------------------------------------------------------------------------
locals {
  pipelines_settings = {
    global_settings = {
      ado_repo_release_branch        = "release"
      ado_agent_pool_name            = "Default"
      ado_oidc_service_endpoint_name = "OIDC-Endpoint"
      aws_tf_state_bucket_name       = "my-tf-state-bucket"
      aws_tf_state_bucket_region     = "eu-central-1"
      tf_version                     = "1.6.0"
    }
    pipelines = [
      {
        pipeline_name          = "pipeline-1"
        pipeline_principal_arn = "arn:aws:iam::123456789012:role/pipeline-1"
        tf_state_file_name     = "pipeline-1.tfstate"
        tf_version             = "1.6.0"
        rendered_provider_tf   = "provider \"aws\" { region = \"eu-central-1\" }"
      },
      {
        pipeline_name          = "pipeline-2"
        pipeline_principal_arn = "arn:aws:iam::234567890123:role/pipeline-2"
        tf_state_file_name     = "pipeline-2.tfstate"
        tf_version             = "1.5.7"
        rendered_provider_tf   = "provider \"aws\" { region = \"us-east-1\" }"
      },
      {
        pipeline_name          = "pipeline-3"
        pipeline_principal_arn = "arn:aws:iam::345678901234:role/pipeline-3"
        tf_state_file_name     = "pipeline-3.tfstate"
        tf_version             = "1.5.2"
        rendered_provider_tf   = "provider \"aws\" { region = \"us-west-1\" }"
      }
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ MODULE
# ---------------------------------------------------------------------------------------------------------------------
module "example_complete" {
  source = "../../ado-oidc"
  ado_pipeline_repos_settings = {
    global_settings = local.pipelines_settings.global_settings
    pipelines_input = local.pipelines_settings.pipelines
  }
}
