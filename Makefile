BASE_PATH = $(PWD)

.PHONY: dockerbuild
dockerbuild: dockerbuild
	docker build -t jjasonclark/jjasonclark.com:latest .

.PHONY: dockerhub
dockerhub: dockerbuild
	docker push jjasonclark/jjasonclark.com:latest
