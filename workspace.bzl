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

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load(":archive.bzl", "http_archive_by_os")

def download_kustomize_deps():
    http_archive_by_os(
        name = "kustomize",
        build_file_content = """package(default_visibility = ["//visibility:public"])
filegroup(
    name = "file",
    srcs = ["kustomize"],
) """,
        sha256 = {
            "darwin": "297289cc0699056be91050507fbbd3dbc3050ae20d64eb7965a3da3a8abaa87a",
            "linux": "0aeca6a054183bd8e7c29307875c8162aba6d2d4e170d3e7751aa78660237126",
        },
        url = {
            "darwin": "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.6.1/kustomize_v3.6.1_darwin_amd64.tar.gz",
            "linux": "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.6.1/kustomize_v3.6.1_linux_amd64.tar.gz",
        },
    )

    http_file(
        name = "kubectl_darwin",
        executable = True,
        sha256 = "4d43205b0fcfc3655e964ab8b84415355cdcf18fe0e700c326be96a68d4b474a",
        urls = ["https://storage.googleapis.com/kubernetes-release/release/v1.17.14/bin/darwin/amd64/kubectl"],
    )

    http_file(
        name = "kubectl_linux",
        executable = True,
        sha256 = "1fea666b5c8f733b400610e3e7413df488ac329b3a50fcf78af34778911ee5ff",
        urls = ["https://storage.googleapis.com/kubernetes-release/release/v1.17.14/bin/linux/amd64/kubectl"],
    )

def download_gcloud_deps():
    http_archive_by_os(
        name = "gcloud",
        # Need to flush lines to create proper indentation
        build_file_content = """package(default_visibility = ["//visibility:public"])\nexports_files(["gcloud", "gsutil", "bq"])""",
        patch_cmds = [
            "ln -s google-cloud-sdk/bin/gcloud gcloud",
            "ln -s google-cloud-sdk/bin/gsutil gsutil",
            "ln -s google-cloud-sdk/bin/bq bq",
        ],
        sha256 = {
            "darwin": "e6c0c8c7f360be118c9416e7d990d0c92c73a2894cb75219e73bd703b73812d1",
            "linux": "04835064bd1b015ad1f6797f2df5f7d8c47522b3d47d7c283d0b8b46c970309d",
        },
        url = {
            "darwin": "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-337.0.0-darwin-x86_64-bundled-python.tar.gz",
            "linux": "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-337.0.0-linux-x86_64.tar.gz",
        },
    )
