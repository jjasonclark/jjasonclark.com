PWD=$(shell pwd)
NAME=jason-blog
DOMAIN=jjasonclark.com
OUT_PATH=$(abspath $(PWD)/public)
CACHE=public, max-age=3600

.PHONY: hugo
hugo:
	docker run --rm -v $(PWD):/src $(DOMAIN):latest

.PHONY: hugonative
hugonative:
	hugo --cleanDestinationDir -d $(OUT_PATH)

.PHONY: docker
docker:
	docker build . -t $(DOMAIN):latest

.PHONY: drafts
drafts:
	docker run --rm -v $(PWD):/src $(DOMAIN):latest /bin/hugo --cleanDestinationDir -d $(OUT_PATH) -D

.PHONY: awsdeploy
awsdeploy:
	aws s3 sync $(OUT_PATH)/ s3://$(DOMAIN) --delete --cache-control "$(CACHE)"

.PHONY: awsinit
awsinit:
	aws cloudformation create-stack --stack-name $(NAME)-terraform --template-body file://terraform/backend.yml --parameters ParameterKey=AppPrefix,ParameterValue=$(NAME)

.PHONY: tfinit
tfinit:
	cd terraform && terraform init

.PHONY: tfapply
tfapply:
	cd terraform && terraform apply
