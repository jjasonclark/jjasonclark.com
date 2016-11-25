.PHONY: dockerbuild
dockerbuild:
	docker build -t jjasonclark/jjasonclark.com:latest .

.PHONY: dockerhub
dockerhub: dockerbuild
	docker push jjasonclark/jjasonclark.com:latest

.PHONY: hugo
hugo:
	hugo --cleanDestinationDir -d public

.PHONY awsdeploy
awsdeploy:
	aws s3 sync public/ s3://jjasonclark.com --delete --profile jjasonclark.com
