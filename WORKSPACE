workspace(name = "com_benchsci_rules_kustomize")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@//:workspace.bzl", "download_gcloud_deps", "download_kustomize_deps")

download_kustomize_deps()

download_gcloud_deps()

http_archive(
    name = "io_bazel_stardoc",
    sha256 = "6d07d18c15abb0f6d393adbd6075cd661a2219faab56a9517741f0fc755f6f3c",
    strip_prefix = "stardoc-0.4.0",
    urls = ["https://github.com/bazelbuild/stardoc/archive/refs/tags/0.4.0.tar.gz"],
)

load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")

stardoc_repositories()
