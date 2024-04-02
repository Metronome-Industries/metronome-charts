#!/bin/sh

set -e

fatal() {
    echo ${1}
    exit 1
}

if [[ -z "${GITHUB_TOKEN}" ]] ; then
    fatal "Missing GITHUB_TOKEN env variable"
fi
rm -rf .cr-release-packages || true
rm index.yaml || true

git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"

cr package ./aws-load-balancer-controller
cr upload --owner Metronome-Industries --git-repo metronome-charts --packages-with-index --token $GITHUB_TOKEN --push --skip-existing
cr index --owner Metronome-Industries --git-repo metronome-charts  --packages-with-index --index-path . --token $GITHUB_TOKEN --push