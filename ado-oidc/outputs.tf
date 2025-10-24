output "pipeline_repos_rendered" {
  value = [
    for p in module.pipeline_repo_content : {
      pipeline_name = p.pipeline_name
      repo_content  = p.pipeline_repo_content
    }
  ]
}