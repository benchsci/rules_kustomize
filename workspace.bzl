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
            "darwin": "6fd57e78ed0c06b5bdd82750c5dc6d0f992a7b926d114fe94be46d7a7e32b63a",
            "linux": "701e3c4bfa14e4c520d481fdf7131f902531bfc002cb5062dcf31263a09c70c9",
            "linux_arm64": "65665b39297cc73c13918f05bbe8450d17556f0acd16242a339271e14861df67",
        },
        url = {
            "darwin": "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.7/kustomize_v4.5.7_darwin_amd64.tar.gz",
            "linux": "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.7/kustomize_v4.5.7_linux_amd64.tar.gz",
            "linux_arm64": "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.7/kustomize_v4.5.7_linux_arm64.tar.gz",
        },
    )

    http_file(
        name = "kubectl_darwin",
        executable = True,
        sha256 = "add0c291629809c03f09fd1fd1e29cc3ec19bef6c7e47766bfd2638b7d25d5cb",
        urls = ["https://storage.googleapis.com/kubernetes-release/release/v1.19.11/bin/darwin/amd64/kubectl"],
    )
    http_file(
        name = "kubectl_linux",
        executable = True,
        sha256 = "10b3bb2526b47f52be9f39cee6e42f8b30acc5b415e7bb7b446500bb41a6fd03",
        urls = ["https://storage.googleapis.com/kubernetes-release/release/v1.19.11/bin/linux/amd64/kubectl"],
    )
    http_file(
        name = "kubectl_linux_arm64",
        executable = True,
        sha256 = "4eadbeabc8b8584d923d54648bd19eb869ac9b7150c8f41cd217c937f49c718b",
        urls = ["https://storage.googleapis.com/kubernetes-release/release/v1.19.11/bin/linux/arm64/kubectl"],
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
