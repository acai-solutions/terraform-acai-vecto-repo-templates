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