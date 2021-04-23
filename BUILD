package(default_visibility = ["//visibility:public"])

sh_library(
    name = "fixgolden",
    srcs = ["fixgolden.sh"],
)

filegroup(
    name = "exec",
    srcs = ["exec.sh"],
)

filegroup(
    name = "execpwd",
    srcs = ["execpwd.sh"],
)

sh_binary(
    name = "kustomize",
    srcs = [":execpwd"],
    args = ["$(location @kustomize//:file)"],
    data = ["@kustomize//:file"],
)

sh_binary(
    name = "kubectl_bin",
    srcs = select({
        "@bazel_tools//src/conditions:linux_x86_64": ["@kubectl_linux//file"],
        "@bazel_tools//src/conditions:darwin": ["@kubectl_darwin//file"],
    }),
)

sh_binary(
    name = "kubectl",
    srcs = [":execpwd"],
    args = ["$(location :kubectl_bin)"],
    data = [":kubectl_bin"],
)

sh_binary(
    name = "gcloud",
    srcs = [":execpwd"],
    args = ["$(location @gcloud)"],
    data = ["@gcloud"],
)

# Exported for documentation (see //tools:docs).
exports_files(["defs.bzl"])
