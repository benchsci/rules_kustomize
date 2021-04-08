load("@com_benchsci_rules_kustomize//:defs.bzl", "kustomization")

def namespace(name, srcs, out, golden = "golden.yaml", visibility = None, transformers = None):
    kwargs = {"autofix": False}
    if transformers:
        kwargs.update({
            # FIXME: this is likely broken (and also needs to be relative to
            # workspace root?
            "plugin_dir": "./gke/kustomize/plugin",
        })
        srcs = list(srcs) + list(transformers)

    kustomization(name, srcs, out, golden, visibility, **kwargs)

    if not golden:
        return

    out_hash = "{}.hash".format(out)
    golden_hash = "{}.hash".format(golden)

    native.genrule(
        name = name + ".hash",
        srcs = [":" + name],
        outs = [out_hash],
        cmd = "out=($$(shasum \"$(location :{0})\")); echo $${{out[0]}} > \"$@\"".format(name),
    )

    native.sh_test(
        name = name + ".golden_hash",
        srcs = ["@com_benchsci_rules_kustomize//:exec"],
        data = [":" + name + ".hash", golden_hash],
        args = [
            "diff",
            "$(location :{}.hash)".format(name),
            "$(location {})".format(golden_hash),
        ],
    )
    native.exports_files(
        [golden, golden_hash],
        visibility = ["//gke:__pkg__"],
    )

    native.sh_binary(
        name = name + ".autofix",
        srcs = ["@com_benchsci_rules_kustomize//:fixgolden"],
        data = [":" + name, ":" + name + ".hash"],
        args = [
            "$(location :{})".format(name),
            golden,
            "$(location :{}.hash)".format(name),
            golden_hash,
        ],
    )
