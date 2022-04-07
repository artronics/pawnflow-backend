.SILENT:

ENVIRONMENT=dev

-include .env

TERRAFORM_OPT=-chdir=terraform
TERRAFORM_STATE=-backend-config="key=backend/${ENVIRONMENT}"
TERRAFORM_VARS=-var=\"environment=$(ENVIRONMENT)\"

export AWS_SECRET_ACCESS_KEY = $(aws_secret_access_key)
export AWS_ACCESS_KEY_ID = $(aws_access_key_id)


init:
	terraform $(TERRAFORM_OPT) init $(TERRAFORM_STATE) $(TERRAFORM_VARS)

plan:
	terraform $(TERRAFORM_OPT) plan

apply:
	 AWS_PROFILE=jalal terraform $(TERRAFORM_OPT) apply -auto-approve

build:
	$(MAKE) -C pawnflow

build-aws:
	$(MAKE) -C pawnflow

run:
	$(MAKE) -C pawnflow

clean:
	rm -rf build terraform/build
