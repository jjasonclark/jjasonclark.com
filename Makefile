PWD=$(shell pwd)

.PHONY: hugo
hugo:
	docker run --rm -v $(PWD):/src jjasonclark.com:latest

.PHONY: docker
docker:
	docker build . -t jjasonclark.com:latest

.PHONY: drafts
drafts:
	docker run --rm -v $(PWD):/src jjasonclark.com:latest /bin/hugo --cleanDestinationDir -d public -D

.PHONY: awsdeploy
awsdeploy:
	aws s3 sync public/ s3://jjasonclark.com --delete --profile jjasonclark.com
