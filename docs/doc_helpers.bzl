load("@io_bazel_stardoc//stardoc:stardoc.bzl", "stardoc")
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@bazel_skylib//rules:diff_test.bzl", "diff_test")

def stardoc_with_diff_test(
        bzl_library_target,
        out_label,
        rule_template = "//stardoc:templates/markdown_tables/rule.vm",
        name = None):

    out_file = out_label.replace("//", "").replace(":", "/")

    # Generate MD from .bzl
    stardoc(
        name = out_file.replace("/", "_").replace(".md", "-docgen"),
        out = out_file.replace(".md", "-docgen.md"),
        input = bzl_library_target + ".bzl",
        rule_template = rule_template,
        deps = [bzl_library_target],
    )

    # Ensure that the generated MD has been updated in the local source tree
    diff_test(
        name = out_file.replace("/", "_").replace(".md", "-difftest"),
        failure_message = "Please run \"bazel run //docs:update\"",
        # Source file
        file1 = out_label,
        # Output from stardoc rule above
        file2 = out_file.replace(".md", "-docgen.md"),
    )

def update_docs(name = "update"):
    content = ["#!/usr/bin/env bash", "cd ${BUILD_WORKSPACE_DIRECTORY}"]
    data = []
    for r in native.existing_rules().values():
        if r["kind"] == "stardoc":
            doc_gen = r["out"]
            if doc_gen.startswith(":"):
                doc_gen = doc_gen[1:]
            doc_dest = doc_gen.replace("-docgen.md", ".md")
            data.append(doc_gen)
            content.append("cp -fv bazel-bin/docs/{0} {1}".format(doc_gen, doc_dest))

    update_script = name + ".sh"
    write_file(
        name = "gen_" + name,
        out = update_script,
        content = content,
    )

    native.sh_binary(
        name = name,
        srcs = [update_script],
        data = data,
    )
