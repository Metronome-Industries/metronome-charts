.PHONY: release
release:
	docker run -it -v `pwd`:`pwd` \
		--workdir `pwd` -e GITHUB_TOKEN \
		--entrypoint scripts/release.sh quay.io/helmpack/chart-releaser:v1.6.1
