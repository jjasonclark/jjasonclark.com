.PHONY: dockerbuild
dockerbuild:
	docker build -t jjasonclark/jjasonclark.com:latest .

.PHONY: dockerhub
dockerhub: dockerbuild
	docker push jjasonclark/jjasonclark.com:latest

.PHONY: hugo
hugo:
	hugo --cleanDestinationDir -d public
