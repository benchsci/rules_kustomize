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
            "darwin_arm64": "3c1e8b95cef4ff6e52d5f4b8c65b8d9d06b75f42d1cb40986c1d67729d82411a",
            "linux": "701e3c4bfa14e4c520d481fdf7131f902531bfc002cb5062dcf31263a09c70c9",
            "linux_arm64": "65665b39297cc73c13918f05bbe8450d17556f0acd16242a339271e14861df67",
        },
        url = {
            "darwin": "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.7/kustomize_v4.5.7_darwin_amd64.tar.gz",
            "darwin_arm64": "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.7/kustomize_v4.5.7_darwin_arm64.tar.gz",
            "linux": "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.7/kustomize_v4.5.7_linux_amd64.tar.gz",
            "linux_arm64": "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.7/kustomize_v4.5.7_linux_arm64.tar.gz",
        },
    )

    http_file(
        name = "kubectl_darwin",
        executable = True,
        sha256 = "bb04d9450d9c9fa120956c5cc7c8dfaa700297038ff9c941741e730b02bbd1f3",
        urls = ["https://storage.googleapis.com/kubernetes-release/release/v1.29.2/bin/darwin/amd64/kubectl"],
    )
    http_file(
        name = "kubectl_darwin_arm64",
        executable = True,
        sha256 = "ce030f86625df96560402573d86d4e6f4b8b956ca3e3b9df57cb8ccf2b9a540c",
        urls = ["https://storage.googleapis.com/kubernetes-release/release/v1.29.2/bin/darwin/arm64/kubectl"],
    )
    http_file(
        name = "kubectl_linux",
        executable = True,
        sha256 = "7816d067740f47f949be826ac76943167b7b3a38c4f0c18b902fffa8779a5afa",
        urls = ["https://storage.googleapis.com/kubernetes-release/release/v1.29.2/bin/linux/amd64/kubectl"],
    )
    http_file(
        name = "kubectl_linux_arm64",
        executable = True,
        sha256 = "3507ecb4224cf05ae2151a98d4932253624e7762159936d5347b19fe037655ca",
        urls = ["https://storage.googleapis.com/kubernetes-release/release/v1.29.2/bin/linux/arm64/kubectl"],
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
            "darwin": "26db63460c7f71c7154c753fcb01030d1a509a3fade20f7ab0241f74e7986ec3",
            "darwin_arm64": "331b6a1f48c8e76f1a0ebfc25b290a944af9f3dae42a22704b297fc496518375",
            "linux": "de3525b315d7ea3c3696eba466ddd97313ccad45f6f684bcdd9224374baa6c08",
            "linux_arm64": "ce382528da5f5d5daf84f63ec4289ed60069e78f0cd8d9fa11c46ae5993854ea",
        },
        url = {
            "darwin": "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-410.0.0-darwin-x86_64.tar.gz",
            "darwin_arm64": "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-410.0.0-darwin-arm.tar.gz",
            "linux": "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-410.0.0-linux-x86_64.tar.gz",
            "linux_arm64": "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-410.0.0-linux-arm.tar.gz",
        },
    )
