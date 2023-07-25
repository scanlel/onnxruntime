#!/bin/bash

set -e

ROOT_DIR=$(pwd)
IOS_POD_STAGING_PATH="/Users/sleloglu/projects/fork_onnxruntime/build/ios_pod_staging"
ONNXPOD_PATH="/Users/sleloglu/projects/fork_onnxruntime/build/ios_pod_staging/onnxruntime-training-c"
C_POD="onnxruntime-training-c"
OBJC_POD="onnxruntime-training-objc"
SCRIPT_PATH="tools/ci_build/github/apple/build_and_assemble_ios_pods.py"
CONFIG_PATH="/Users/sleloglu/projects/onnx-mobile-demo/onnx-runtime-build-ios"
ONNXAPP_PATH="/Users/sleloglu/projects/onnx-mobile-demo/OnnxTesterApp"
ONNXPOD_PATH="onnx-fixed"

python3 $SCRIPT_PATH \
  --variant Training \
  --include-ops-by-config $CONFIG_PATH/required_operators.config \
  --build-settings-file $CONFIG_PATH/build_settings_with_exceptions.json \
  -b=--path_to_protoc_exe=/opt/homebrew/opt/protobuf@21/bin/protoc

open $IOS_POD_STAGING_PATH

rm -rf "$ONNXAPP_PATH/$ONNXPOD_PATH/$C_POD"
rm -rf "$ONNXAPP_PATH/$ONNXPOD_PATH/$OBJC_POD"

cp -R $IOS_POD_STAGING_PATH/$C_POD "$ONNXAPP_PATH/$ONNXPOD_PATH"
cp -R $IOS_POD_STAGING_PATH/$OBJC_POD "$ONNXAPP_PATH/$ONNXPOD_PATH"

cd "$ONNXAPP_PATH"

pod install

open "$ONNXAPP_PATH/OnnxTesterApp.xcworkspace"

cd $ROOT_DIR
