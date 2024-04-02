.PHONY: release
release:
	docker run -it -v `pwd`:`pwd` \
		--workdir `pwd` -e GITHUB_TOKEN -e USER \
		--entrypoint ./scripts/release.sh \
		alpine/helm:3.14.3
