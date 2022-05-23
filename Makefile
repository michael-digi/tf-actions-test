TERRAFORM_VERSION := 1.1.7
REGION := us-east-2
AWS_PROFILE := gck
TERRAFORM := docker run --rm -it -e AWS_PROFILE=${AWS_PROFILE} -e AWS_REGION=${REGION} -v ~/.aws:/root/.aws -v ${PWD}:/data -w /data hashicorp/terraform:${TERRAFORM_VERSION}

# Quick terraform dot folder cleanup.
cleanup:
	sudo rm -rf .terraform

# Initialize your terraform project.
init: cleanup
	${TERRAFORM} init \
	    -backend=true \
	    -backend-config="bucket=run-terraform-state" \
	    -backend-config="key=terraform.tfstate" \
	    -backend-config="region=${REGION}" \
	    -backend-config="profile=${AWS_PROFILE}" \
	    -force-copy

# Format terraform.
fmt:
	${TERRAFORM} fmt

# Run a terraform plan against the .tf files.
plan: fmt init
	${TERRAFORM} plan \
		-out=.terraform/terraform.tfplan

# Apply the terraform changes from the plan.
apply:
	${TERRAFORM} apply .terraform/terraform.tfplan

pull:
	AWS_PROFILE=gck aws ecr get-login-password | docker login --username AWS --password-stdin 314694303532.dkr.ecr.us-west-2.amazonaws.com
		docker pull 314694303532.dkr.ecr.us-west-2.amazonaws.com/gck_web:latest
