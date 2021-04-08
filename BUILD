package(default_visibility = ["//visibility:public"])

sh_library(
    name = "fixgolden",
    srcs = ["fixgolden.sh"],
)

filegroup(
    name = "exec",
    srcs = ["exec.sh"],
)

sh_binary(
    name = "kustomize",
    srcs = ["@kustomize//:file"],
)

sh_binary(
    name = "kubectl",
    srcs = select({
        "@bazel_tools//src/conditions:linux_x86_64": ["@kubectl_linux//file"],
        "@bazel_tools//src/conditions:darwin": ["@kubectl_darwin//file"],
    }),
)

sh_binary(
    name = "gcloud",
    srcs = ["@gcloud"],
)

# Exported for documentation (see //tools:docs).
exports_files(["defs.bzl"])
