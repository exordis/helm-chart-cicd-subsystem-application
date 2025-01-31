#!/bin/sh
set -e 

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


# Define snapshot file and output directory
SNAPSHOT_FILE="tests/__snapshot__/e2e_test.yaml.snap"
OUTPUT_DIR="docs/snippets/manifests"

# on windows fs access to directory mounted as folder is too slow
# copying to native FS executing there  
cp -R /src/* /apps 
cd /apps 
eval "helm unittest . $PROVIDED_ARGS"


# Get snapshot data back to mounted directory
rm -rf /src/tests/__snapshot__ 
cp -R /apps/tests/__snapshot__ /src/tests/

# Extract snapshot manifests as snippets
apk add --no-cache yq > /dev/null

# Ensure output directory exists
rm -rf /tmp/manifests
mkdir -p /tmp/manifests

yq '.["manifest should match snapshot"] | to_entries | map(.value | from_yaml) | map("/tmp/manifests" + "/" + .kind) | .[]' "$SNAPSHOT_FILE" | xargs -I{} mkdir -p "{}"
yq '.["manifest should match snapshot"] | to_entries | map(.value | from_yaml) | .[]' "$SNAPSHOT_FILE" -s '"/tmp/manifests" + "/" + .kind + "/" + .metadata.name'

rm -rf "/src/$OUTPUT_DIR"
mkdir -p "/src/$OUTPUT_DIR"
cp -R /tmp/manifests/* "/src/$OUTPUT_DIR"