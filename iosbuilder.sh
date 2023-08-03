#!/bin/bash

set -e

# function to parse command line arguments
parse_args() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -dest) DEST_PATH="$2"; shift 2;;
            -req_ops_config) REQUIRED_OPS_CONFIG="$2"; shift 2;;
            -build_settings) BUILD_SETTINGS_JSON="$2"; shift 2;;
            *)
                echo "Unknown argument: $1"
                exit 1
                ;;
        esac
    done
}

parse_args "$@"

ROOT_DIR=$(pwd)
IOS_POD_STAGING_PATH="$ROOT_DIR/build/ios_pod_staging"
C_POD="onnxruntime-training-c"
OBJC_POD="onnxruntime-training-objc"
SCRIPT_PATH="tools/ci_build/github/apple/build_and_assemble_ios_pods.py"

python3 $SCRIPT_PATH \
  --variant Training \
  --include-ops-by-config $REQUIRED_OPS_CONFIG \
  --build-settings-file $BUILD_SETTINGS_JSON \
  -b=--path_to_protoc_exe=/opt/homebrew/opt/protobuf@21/bin/protoc

open $IOS_POD_STAGING_PATH

if [ -d "$DEST_PATH/$C_POD" ]; then
  rm -rf "$DEST_PATH/$C_POD"
fi

if [ -d "$DEST_PATH/$OBJC_POD" ]; then
  rm -rf "$DEST_PATH/$OBJC_POD"
fi

cp -R $IOS_POD_STAGING_PATH/$C_POD "$DEST_PATH"
cp -R $IOS_POD_STAGING_PATH/$OBJC_POD "$DEST_PATH"
