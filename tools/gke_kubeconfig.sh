#!/bin/bash
# Copyright 2021 BenchSci Analytics Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Create a kubeconfig file suitable for use with the kubeconfig() macro.  The
# resulting config contains no secret material and are suitable to check into
# version control directly (certificate data embedded in the configurations are
# not private keys).
set -euxo pipefail

# Set "container/use_application_default_credentials" property via environment
# variable since we don't want to mutate the user's settings silently.

# See:
#   https://cloud.google.com/sdk/gcloud/reference/container/clusters/get-credentials
#   https://cloud.google.com/sdk/docs/properties
export CLOUDSDK_CONTAINER_USE_APPLICATION_DEFAULT_CREDENTIALS="true"

target="${1}" && shift
gcloud="${1}" && shift

# Remaining arguments are passed to "gcloud ... get-credentials".

# Set KUBECONFIG to the staging area for the config files (gcloud SDK reads
# this value to determine where to write).
export KUBECONFIG=$( mktemp )
echo "# AUTOGENERATED BY gke_kubeconfig.sh DO NOT EDIT BY HAND" > "${target}"
echo "# ARGS: $@" >> "${target}"
"$gcloud" container clusters get-credentials "$@"
cat "${KUBECONFIG}" >> "${target}"
rm "${KUBECONFIG}"

# Write a BUILD file to include kubeconfig and location if it doesn't exist
# already.
build=$( dirname "${target}" )/BUILD
if [ -f "${build}" ]; then
  echo "BUILD file ${build} already exists, not overwriting."
else
  cat << 'EOF' > "${build}"
load("@com_benchsci_rules_kustomize//:defs.bzl", "kubeconfig")

kubeconfig()
EOF
fi
