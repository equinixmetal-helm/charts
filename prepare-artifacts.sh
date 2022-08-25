#!/bin/bash

set -euo pipefail

cd "$(dirname ${0})"
CWD=$(pwd)


if [[ $# -lt 1 ]] ; then
	echo "usage: ${0} <chart name>" 1>&2
	exit 1
fi

CHART="$(echo ${1} | tr '[:upper:]' '[:lower:]')"
CHART_DIR="../${CHART}"
CHART_VALUES="${CHART_DIR}/values.yaml"
CHART_YAML="${CHART_DIR}/Chart.yaml"


if [[ ! -e "${CHART_VALUES}" ]] || [[ ! -e "${CHART_YAML}" ]] || [[ ! -d "${CHART_DIR}" ]]; then
	echo "Did you specify a Chart repository path correctly?"
	echo "command: ${0} ${1}"
	exit 1
fi

VERSION="$(awk '/version:/ { print $2; exit; } ' ${CHART_YAML})"
CHART_NAME="$(awk '/name:/ { print $2; exit; } ' ${CHART_YAML})"


if [[ -z "${VERSION}" ]]; then
    echo "Failed to parse ${CHART} version from ${CHART_YAML}"
	exit 1
fi

if [[ "${CHART_NAME}" != "${CHART}" ]]; then
    echo The Chart name should match the repo name
	exit 1
fi 

if [[ "$(uname)" == "Darwin" ]]; then
    DATE_CMD="gdate"
    SED_CMD="gsed"
else
    DATE_CMD="date"
    SED_CMD="sed"
fi

# ensure dependency charts are up to date
pushd "${CHART_DIR}"
helm dep up
popd

# package chart to tarball
pushd ..
helm package --destination "${CWD}"  "${CHART}"
popd

# update index
helm repo index . --merge index.yaml
git add index.yaml ${CHART}-${VERSION}.tgz
git commit -s -m "Add ${CHART}-${VERSION}@$(cd "${CHART_DIR}"; git rev-parse HEAD) ⎈"

# fix the dates in the index
linesWithDate=($(git blame index.yaml --date=iso-strict | awk '/created/ { print $5; }' | sed 's/)$//'))

# lines with the date were overwritten. Take an adjacent line for real date.
dates=($(git blame index.yaml --date=iso-strict | grep -A 1 created | grep -v created | awk '{ print $4 }'))

for i in ${!linesWithDate[@]}; do
    if ! "${DATE_CMD}" --date ${dates[$i]} >/dev/null; then
        echo "unclean git tree, stash all changes before running this script." >&2
        exit 1
    fi

    "${SED_CMD}" -i "${linesWithDate[$i]}s/\"[^\"]*\"/\"${dates[$i]}\"/" index.yaml
done

# commit the updated dates
git add index.yaml
git commit --amend --no-edit
