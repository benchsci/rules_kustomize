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

def kubeconfig():
    """Macro for genrule target named "kubeconfig" intended to uniquely identify a Kubernetes cluster.

    This macro creates two rules: "kubeconfig" and "kubectl".  The latter is a
    convenience run rule that invokes kubectl with the sibling configuration.

    These rules are meant to be set in the `cfg` parameter of the `apply` rule
    documented below.
    """

    # kubectl has a nasty habbit of re-writing the kubeconfig in the source
    # tree. Clone the contents into a generated file so the source tree isn't
    # mutated.
    native.genrule(
        name = "kubeconfig",
        srcs = ["kubeconfig.yaml"],
        outs = ["kubeconfig_copy.yaml"],
        cmd = "cat '$(location :kubeconfig.yaml)' > $@",
        # This visibility is intended to prevent accidental usage outside this
        # package and subpackages.  DO NOT CHANGE.
        visibility = [":__subpackages__"],
    )

    native.sh_binary(
        name = "kubectl",
        srcs = ["@com_benchsci_rules_kustomize//:exec"],
        data = [
            ":kubeconfig",
            "@com_benchsci_rules_kustomize//:kubectl_bin",
        ],
        args = [
            "$(location @com_benchsci_rules_kustomize//:kubectl_bin)",
            "--kubeconfig=$(location :kubeconfig)",
        ],
        visibility = [":__subpackages__"],
    )

def _base_cmd(cfg, src, namespace, tags, subcmd, *extra_args):
    args = [
        "$(location @com_benchsci_rules_kustomize//:kubectl_bin)",
        "--kubeconfig=$(location {})".format(cfg),
        subcmd,
        "-f=$(location {})".format(src),
    ]
    if namespace != None:
        args += ["--namespace=" + namespace]

    args += list(extra_args)

    return dict(
        srcs = ["@com_benchsci_rules_kustomize//:exec"],
        data = [
            "@com_benchsci_rules_kustomize//:kubectl_bin",
            cfg,
            src,
        ],
        tags = tags,
        args = args,
    )

def apply(name, src, cfg, namespace = None, tags = None):
    """Performs a dry-run `apply` via `kubectl` against a resource file.

    This is intended to be combined with the output of a `kustomization` rule
    though `src` can reference any file accepted by `kubectl apply`.  This
    macro defines two additional rules:

    * `<name>.run` actually performs the apply.
    * `<name>.diff` outputs the diff against the existing configuration.

    See:

    * https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply
    * https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#diff

    Args:
      name: A unique name for this rule.
      src: A label.
      cfg: A label referencing a kubeconfig file pointing to desired target
        cluster.
      namespace: Optionally restrict operations to a specific namespace in the
        cluster defined by `cfg`.
      tags: Sets tags on the rule.  The `requires-network` tag must be among
        the tags.
    """
    if tags == None:
        tags = ["requires-network"]
    if "requires-network" not in tags:
        fail("Apply target tags must contain 'requires-network'.")

    native.sh_binary(name = name, **_base_cmd(cfg, src, namespace, tags, "apply", "--server-dry-run"))
    native.sh_binary(name = name + ".run", **_base_cmd(cfg, src, namespace, tags, "apply"))
    native.sh_binary(name = name + ".diff", **_base_cmd(cfg, src, namespace, tags, "diff"))

def kustomization(
        name,
        srcs,
        out,
        golden = None,
        visibility = None,
        autofix = True,
        plugin_dir = None,
        tags = ["block-network"]):
    """Builds a kustomization defined by the input srcs.

    The output is a YAML multi-doc comprised of all the resources defined by
    the customization.  This macro will create additional rules with the
    following suffixes:

    * `<name>.autofix` is a run target generated if `golden` is set.  It synchronizes the output of
    * `<name>.golden` is a test target generated if `golden` is set.

    See:

    * https://kubectl.docs.kubernetes.io/references/kustomize/glossary/#kustomization
    * https://kubectl.docs.kubernetes.io/references/kustomize/glossary/#kustomization-root

    Args:
      name: A unique name for this rule.
      srcs: Source inputs to run `kustomize build` against.  These are any
        valid Bazel labels representing.

        Note that the Bazel glob() function can be used to specify which source
        files to include and which to exclude, e.g.
        `glob(["*.yaml"], exclude=["golden.yaml"])`.
      out: The name of the output file.
      golden: Identify a file containing the expected output of the build.
        Defining this parameter creates a test rule named `.golden` that
        verifies the output is identical to the contents of the named file.
        Golden files are a materialized view of resources and can be useful if
        your kustomizations have many transitive dependencies.
      autofix: Toggle creation of a `.autofix` rule if `golden` is also set.
      plugin_dir: TODO
      visibility: The visibility of this rule.
      tags: Sets tags on the rule.  The `block-network` tag is strongly
        recommended (but not enforced) to ensure hermeticity and
        reproducibility.
    """
    kwargs = {}
    if visibility:
        kwargs["visibility"] = visibility

    native.filegroup(
        name = name + ".srcs",
        srcs = srcs,
        **kwargs
    )

    # Used only to be able to generate a path to the file below.
    native.filegroup(
        name = name + ".main",
        srcs = ["kustomization.yaml"],
        visibility = ["//visibility:private"],
    )

    build_cmd = [
        "./$(location @kustomize//:file) ",
        "build",
        # This can be dangerous, but Bazel forces us to be explicit in
        # defining dependencies and we use the "block-network" tag below to
        # disallow fetches.
        "--load_restrictor=none",
    ]
    if plugin_dir:
        build_cmd = ["KUSTOMIZE_PLUGIN_HOME=$$( realpath {} )".format(plugin_dir)] + build_cmd + ["--enable_alpha_plugins"]

    native.genrule(
        name = name,
        srcs = [
            ":" + name + ".srcs",
            ":" + name + ".main",
        ],
        outs = [out],
        cmd = " ".join(build_cmd + [
            "$$( dirname '$(location :{}.main)' )".format(name),
            "> \"$@\"",
        ]),
        # Ideally we'd use something like:
        #
        #   kbin = "{}//:kustomize".format(native.repository_name())
        #
        # See https://github.com/bazelbuild/bazel/issues/4092
        tools = ["@kustomize//:file"],
        tags = tags,
        **kwargs
    )

    if golden != None:
        if autofix:
            native.sh_binary(
                name = name + ".autofix",
                srcs = ["@com_benchsci_rules_kustomize//:fixgolden"],
                data = [":" + name],
                args = ["$(location :{})".format(name), golden],
                visibility = ["//visibility:private"],
            )
        native.sh_test(
            name = name + ".golden",
            srcs = ["@com_benchsci_rules_kustomize//:exec"],
            data = [":" + name, golden],
            args = [
                "diff",
                "$(location :{})".format(name),
                "$(location {})".format(golden),
            ],
            visibility = ["//visibility:private"],
        )
