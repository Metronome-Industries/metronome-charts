.PHONY: release
release:
	docker run -it -v `pwd`/scripts/release.sh:/workdir/release.sh \
		--workdir /workdir -e GITHUB_TOKEN -e USER \
		--entrypoint /workdir/release.sh \
		quay.io/helmpack/chart-releaser:v1.6.1
