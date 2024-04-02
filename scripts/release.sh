#!/bin/sh

set -e

fatal() {
    echo ${1}
    exit 1
}

if [[ -z "${GITHUB_TOKEN}" ]] ; then
    fatal "Missing GITHUB_TOKEN env variable"
fi
if [[ -z "${USER}" ]] ; then
    fatal "USER not set"
fi
rm *.tgz || true
rm index.yaml || true


git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"
git config --global user.email "${USER}@metronome.com"
git config --global user.name "${USER}"
git fetch --tags

version=`yq eval '.version' ./aws-load-balancer-controller/Chart.yaml`
version=aws-load-balancer-controller-${version}
git tag ${version}
git push origin ${version}

helm package ./aws-load-balancer-controller
git checkout gh-pages
git pull origin gh-pages
git add *.tgz
helm repo index ./
git add index.yaml
git commit -m "pushing helm chart for ${version}"
git push origin gh-pages
