load("@com_benchsci_rules_kustomize//:defs.bzl", "kustomization")
load("@bazel_tools//tools/build_rules:test_rules.bzl", "file_test")

kustomization(
    name = "prod",
    srcs = [
        "kustomization.yaml",
        "//base/echoapp",
    ],
    out = "prod-b.yaml",
    golden = "golden.yaml",
)

golden = """apiVersion: v1
kind: Pod
metadata:
  labels:
    cluster: b
  name: echo
  namespace: prod
spec:
  containers:
  - image: k8s.gcr.io/echoserver:1.4
    name: echo
"""

file_test(
    name = "parallel_test",
    content = golden,
    file = ":prod",
)
