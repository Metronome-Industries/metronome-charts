#!/bin/sh

set -e

fatal() {
    echo ${1}
    exit 1
}

if [[ -z "$1" ]]; then
    fatal "USAGE: release.sh [chart-name]"
fi

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

version=`yq eval '.version' ./${1}/Chart.yaml`
version=${1}-${version}
git tag ${version}
git push origin ${version}

helm package ./${1}
git checkout gh-pages
git pull origin gh-pages
git add *.tgz
helm repo index ./
git add index.yaml
git commit -m "pushing helm chart for ${version}"
git push origin gh-pages
