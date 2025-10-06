#!/bin/sh
set -e 

CHART_TO_TEST="."
if [ -d tests/chart ]
then
  CHART_TO_TEST="tests/chart"
fi

# Define the default -f argument
DEFAULT_FILE_ARG="-f 'tests/**/*-tests.yaml' -f 'tests/**/*-test.yaml' -f 'tests/**/*_test.yaml'"

# Initialize variables
PROVIDED_ARGS=""
HAS_FILE_ARG=0  # Flag to check if -f is present

# Parse provided arguments
for ARG in "$@"; do
  if [ "$ARG" = "-f" ]; then
    HAS_FILE_ARG=1
  fi
  PROVIDED_ARGS="$PROVIDED_ARGS $ARG"
done

# Add the default -f argument if none is found
if [ $HAS_FILE_ARG -eq 0 ]; then
  PROVIDED_ARGS="$PROVIDED_ARGS $DEFAULT_FILE_ARG"
fi



# On Windows, copy mounted directory to native FS for performance
cp -R /src/* /apps
cd /apps
eval "helm unittest $CHART_TO_TEST $PROVIDED_ARGS"

# Copy snapshot data back to mounted directory
rm -rf /src/tests/__snapshot__
cp -R /apps/tests/__snapshot__ /src/tests/

# Install yq quietly (Alpine)
apk add --no-cache yq > /dev/null

extract_snapshots_to_dir() {
  local SNAPSHOT_FILE=$1
  local OUTPUT_DIR=$2

  # Prepare temp directory for extracted manifests
  rm -rf /tmp/manifests
  mkdir -p /tmp/manifests

  # Create directories for each kind
  yq '.["manifest should match snapshot"] | to_entries | map(.value | from_yaml) | map("/tmp/manifests" + "/" + .kind) | .[]' "$SNAPSHOT_FILE" | xargs -I{} mkdir -p "{}"

  # Extract and write manifests with path /tmp/manifests/<Kind>/<metadata.name>
  yq '.["manifest should match snapshot"] | to_entries | map(.value | from_yaml) | .[]' "$SNAPSHOT_FILE" -s '"/tmp/manifests" + "/" + .kind + "/" + .metadata.name'

  # Clean and copy extracted manifests to output directory
  rm -rf "/src/$OUTPUT_DIR"
  mkdir -p "/src/$OUTPUT_DIR"
  cp -R /tmp/manifests/* "/src/$OUTPUT_DIR"
}


# Define snapshot file and output directory
extract_snapshots_to_dir "tests/__snapshot__/deployment_e2e_test.yaml.snap" "docs/snippets/manifests/deployment"
extract_snapshots_to_dir "tests/__snapshot__/statefulset_e2e_test.yaml.snap" "docs/snippets/manifests/statefulset"
