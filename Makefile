.PHONY: hugo
hugo:
	docker-compose run --rm app /usr/bin/hugo --cleanDestinationDir -d public

.PHONY: drafts
drafts:
	docker-compose run --rm app /usr/bin/hugo --cleanDestinationDir -d public -D

.PHONY: serve
serve:
	docker-compose run --rm --service-ports app /usr/bin/hugo serve --cleanDestinationDir -d public -D --watch --bind 0.0.0.0

.PHONY: awsdeploy
awsdeploy:
	aws s3 sync public/ s3://jjasonclark.com --delete --profile jjasonclark.com
