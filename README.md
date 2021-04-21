# rules_kustomize

The rules define a collection of Bazel macros for working with
[kustomize](https://kustomize.io/).  These rules are intentionally lightweight
and intended to be composable with other Kubernetes related rules.

The rules are tested and supported on the following host platforms:

* Linux, macOS
* amd64

Patches to support additional platforms are welcome.

# Setup

After setup, see the [examples](./examples/) directory and the [API documentation](./docs/defs.md).

```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "com_benchsci_rules_kustomize",
    sha256 = "402b48489fdf3bb2ac52c64c2ce9d8031e4a8f105675dac4a6dfb5c23e1623e2",
    strip_prefix = "rules_kustomize-6cec90b4c8ae8e9d7eccd3c3b4d7780effff03a8",
    urls = ["https://github.com/benchsci/rules_kustomize/archive/6cec90b4c8ae8e9d7eccd3c3b4d7780effff03a8.zip"],
)

load("@com_benchsci_rules_kustomize//:workspace.bzl", "download_kustomize_deps")

download_kustomize_deps()

# Optional for some handy GKE related utilities.
load("@com_benchsci_rules_kustomize//:workspace.bzl", "download_gcloud_deps")

download_gcloud_deps()
```

These rules make a best-effort attempt to track the stable releases of its
dependencies.  If you need to lock to different versions you can specify them
explictly in your WORKSPACE file by copying and modifying the contents of the
helper functions in [workspace.bzl](./workspace.bzl), for example:

```bzl
http_archive_by_os(
    name = "kustomize",
    build_file_content = """package(default_visibility = ["//visibility:public"])\nfilegroup(\nname = "file",\nsrcs = ["kustomize"]\n)""",
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
```

# Additional tools:

The underlying tools that the macros use are exposed as `run` commands::

    bazel run @com_benchsci_rules_kustomize//:kubectl
    bazel run @com_benchsci_rules_kustomize//:kustomize
    bazel run @com_benchsci_rules_kustomize//:gcloud

You can alias these tools into your own Bazel repository via
[`alias`](https://docs.bazel.build/versions/master/be/general.html#alias).  For
example:

    alias(
        name = "kubectl"
        actual = "@com_benchsci_rules_kustomize//:kubectl",
    )
