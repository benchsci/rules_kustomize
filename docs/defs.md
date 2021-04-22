<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#apply"></a>

## apply

<pre>
apply(<a href="#apply-name">name</a>, <a href="#apply-src">src</a>, <a href="#apply-cfg">cfg</a>, <a href="#apply-namespace">namespace</a>, <a href="#apply-tags">tags</a>)
</pre>

Performs a dry-run `apply` via `kubectl` against a resource file.

This is intended to be combined with the output of a `kustomization` rule
though `src` can reference any file accepted by `kubectl apply`.  This
macro defines two additional rules:

* `<name>.run` actually performs the apply.
* `<name>.diff` outputs the diff against the existing configuration.

See:

* https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply
* https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#diff


**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  A unique name for this rule.   |  none |
| src |  A label.   |  none |
| cfg |  A label referencing a kubeconfig file pointing to desired target   cluster.   |  none |
| namespace |  Optionally restrict operations to a specific namespace in the   cluster defined by <code>cfg</code>.   |  <code>None</code> |
| tags |  Sets tags on the rule.  The <code>requires-network</code> tag must be among   the tags.   |  <code>None</code> |


<a name="#kubeconfig"></a>

## kubeconfig

<pre>
kubeconfig()
</pre>

Macro for genrule target named "kubeconfig" intended to uniquely identify a Kubernetes cluster.

This macro creates two rules: "kubeconfig" and "kubectl".  The latter is a
convenience run rule that invokes kubectl with the sibling configuration.

These rules are meant to be set in the `cfg` parameter of the `apply` rule
documented below.

**PARAMETERS**



<a name="#kustomization"></a>

## kustomization

<pre>
kustomization(<a href="#kustomization-name">name</a>, <a href="#kustomization-srcs">srcs</a>, <a href="#kustomization-out">out</a>, <a href="#kustomization-golden">golden</a>, <a href="#kustomization-visibility">visibility</a>, <a href="#kustomization-autofix">autofix</a>, <a href="#kustomization-plugin_dir">plugin_dir</a>, <a href="#kustomization-tags">tags</a>)
</pre>

Builds a kustomization defined by the input srcs.

The output is a YAML multi-doc comprised of all the resources defined by
the customization.  This macro will create additional rules with the
following suffixes:

* `<name>.autofix` is a run target generated if `golden` is set.  It synchronizes the output of
* `<name>.golden` is a test target generated if `golden` is set.

See:

* https://kubectl.docs.kubernetes.io/references/kustomize/glossary/#kustomization
* https://kubectl.docs.kubernetes.io/references/kustomize/glossary/#kustomization-root


**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  A unique name for this rule.   |  none |
| srcs |  Source inputs to run <code>kustomize build</code> against.  These are any   valid Bazel labels representing.<br><br>  Note that the Bazel glob() function can be used to specify which source   files to include and which to exclude, e.g.   <code>glob(["*.yaml"], exclude=["golden.yaml"])</code>.   |  none |
| out |  The name of the output file.   |  none |
| golden |  Identify a file containing the expected output of the build.   Defining this parameter creates a test rule named <code>.golden</code> that   verifies the output is identical to the contents of the named file.   Golden files are a materialized view of resources and can be useful if   your kustomizations have many transitive dependencies.   |  <code>None</code> |
| visibility |  The visibility of this rule.   |  <code>None</code> |
| autofix |  Toggle creation of a <code>.autofix</code> rule if <code>golden</code> is also set.   |  <code>True</code> |
| plugin_dir |  TODO   |  <code>None</code> |
| tags |  Sets tags on the rule.  The <code>block-network</code> tag is strongly   recommended (but not enforced) to ensure hermeticity and   reproducibility.   |  <code>["block-network"]</code> |


