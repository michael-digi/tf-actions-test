output "ecr_repository_urls" {
  value       = values(aws_ecr_repository.repos)[*].repository_url
  description = "A list of urls of the repositories that were created."
}
