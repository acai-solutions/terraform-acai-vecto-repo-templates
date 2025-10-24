variable "ado_pipeline_repos_settings" {
  description = "Settings for ADO pipeline repositories."
  type = object({
    global_settings = object({
      ado_repo_release_branch        = string
      ado_agent_pool_name            = string
      ado_oidc_service_endpoint_name = string
      aws_tf_state_bucket_region     = string
      aws_tf_state_bucket_name       = string
      aws_default_region             = optional(string, "eu-central-1")
    })
    pipelines_input = list(object({
      pipeline_name          = string
      pipeline_principal_arn = string
      tf_state_file_name     = string
      tf_version             = string
      rendered_provider_tf   = string
    }))
  })
}
