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
# ¦ PROVISION AWS-SIDE PER PIPELINE
# ---------------------------------------------------------------------------------------------------------------------
module "pipeline_repo_content" {
  for_each = {
    for pipeline in var.ado_pipeline_repos_settings.pipelines_input : 
    pipeline.pipeline_name => pipeline
  }
  source = "./pipeline-repo"

  global_settings   = var.ado_pipeline_repos_settings.global_settings
  pipeline_settings = each.value
}