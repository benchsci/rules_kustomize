# rules_kustomize

The rules define a collection of Bazel macros for working with
[kustomize](https://kustomize.io/).  These rules are intentionally lightweight
and intended to be composable with other Kubernetes related rules.

The rules are tested against Bazel 5.4 and supported on the following host
platforms:

* Linux, macOS
* amd64, arm64

Patches to support additional platforms are welcome.

# Setup

After setup, see the [examples](./examples/) directory and the [API documentation](./docs/defs.md).

```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")


http_archive(
    name = "com_benchsci_rules_kustomize",
    sha256 = "7c2308991352d534c4ad3d9a0e37eee402ccb8a7c96eeb718c18c52f81c45fb1",
    strip_prefix = "rules_kustomize-4b979472aae1953799a616e45a10748acafcd982",
    urls = ["https://github.com/benchsci/rules_kustomize/archive/4b979472aae1953799a616e45a10748acafcd982.zip"],
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
helper functions in [workspace.bzl](./workspace.bzl) (e.g. the body of the
`download_kustomize_deps` function)

# Additional tools:

The underlying tools that the macros use are exposed as `run` commands::

    bazel run @com_benchsci_rules_kustomize//:kubectl
    bazel run @com_benchsci_rules_kustomize//:kustomize
    bazel run @com_benchsci_rules_kustomize//:gcloud

You can alias these tools into your own Bazel repository via
[`alias`](https://docs.bazel.build/versions/master/be/general.html#alias).  For
example:

    alias(
        name = "kubectl",
        actual = "@com_benchsci_rules_kustomize//:kubectl",
    )
