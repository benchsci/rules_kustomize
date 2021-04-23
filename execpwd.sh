#!/bin/sh
# Copyright 2021 Benchsci Analytics Inc.
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

# See https://github.com/bazelbuild/bazel/issues/3325
if [ -z "${BUILD_WORKING_DIRECTORY-}" ]; then
  echo "error BUILD_WORKING_DIRECTORY not set"
  exit 1
fi

cmd="$( pwd )/${1}"
cd "${BUILD_WORKING_DIRECTORY}"
shift

exec "${cmd}" "$@"
