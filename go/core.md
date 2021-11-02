<!-- Generated with Stardoc: http://skydoc.bazel.build -->


  ["Make variable"]: https://docs.bazel.build/versions/master/be/make-variables.html
  [Bourne shell tokenization]: https://docs.bazel.build/versions/master/be/common-definitions.html#sh-tokenization
  [Gazelle]: https://github.com/bazelbuild/bazel-gazelle
  [GoArchive]: providers.rst#GoArchive
  [GoLibrary]: providers.rst#GoLibrary
  [GoPath]: providers.rst#GoPath
  [GoSource]: providers.rst#GoSource
  [build constraints]: https://golang.org/pkg/go/build/#hdr-Build_Constraints
  [cc_library deps]: https://docs.bazel.build/versions/master/be/c-cpp.html#cc_library.deps
  [cgo]: http://golang.org/cmd/cgo/
  [config_setting]: https://docs.bazel.build/versions/master/be/general.html#config_setting
  [data dependencies]: https://docs.bazel.build/versions/master/build-ref.html#data
  [goarch]: modes.rst#goarch
  [goos]: modes.rst#goos
  [mode attributes]: modes.rst#mode-attributes
  [nogo]: nogo.rst#nogo
  [pure]: modes.rst#pure
  [race]: modes.rst#race
  [msan]: modes.rst#msan
  [select]: https://docs.bazel.build/versions/master/be/functions.html#select
  [shard_count]: https://docs.bazel.build/versions/master/be/common-definitions.html#test.shard_count
  [static]: modes.rst#static
  [test_arg]: https://docs.bazel.build/versions/master/user-manual.html#flag--test_arg
  [test_filter]: https://docs.bazel.build/versions/master/user-manual.html#flag--test_filter
  [test_env]: https://docs.bazel.build/versions/master/user-manual.html#flag--test_env
  [write a CROSSTOOL file]: https://github.com/bazelbuild/bazel/wiki/Yet-Another-CROSSTOOL-Writing-Tutorial
  [bazel]: https://pkg.go.dev/github.com/bazelbuild/rules_go/go/tools/bazel?tab=doc
  [go_library]: #go_library
  [go_binary]: #go_binary
  [go_test]: #go_test

# Core Go rules

## Contents
- [Introduction](#introduction)
- [Rules](#rules)
  - [go_library](#go_library)
  - [go_binary](#go_binary)
  - [go_test](#go_test)
  - [go_source](#go_source)
  - [go_path](#go_path)
- [Defines and stamping](#defines-and-stamping)
- [Embedding](#embedding)
- [Cross compilation](#cross-compilation)
  - [Platform-specific dependencies](#platform-specific-dependencies)

## Additional resources
- ["Make variable"]
- [Bourne shell tokenization]
- [Gazelle]
- [GoArchive]
- [GoLibrary]
- [GoPath]
- [GoSource]
- [build constraints]:
- [cc_library deps]
- [cgo]
- [config_setting]
- [data dependencies]
- [goarch]
- [goos]
- [mode attributes]
- [nogo]
- [pure]
- [race]
- [msan]
- [select]:
- [shard_count]
- [static]
- [test_arg]
- [test_filter]
- [test_env]
- [write a CROSSTOOL file]
- [bazel]


------------------------------------------------------------------------

Introduction
------------

Three core rules may be used to build most projects: [go_library], [go_binary],
and [go_test].

[go_library] builds a single package. It has a list of source files
(specified with `srcs`) and may depend on other packages (with `deps`).
Each [go_library] has an `importpath`, which is the name used to import it
in Go source files.

[go_binary] also builds a single `main` package and links it into an
executable. It may embed the content of a [go_library] using the `embed`
attribute. Embedded sources are compiled together in the same package.
Binaries can be built for alternative platforms and configurations by setting
`goos`, `goarch`, and other attributes.

[go_test] builds a test executable. Like tests produced by `go test`, this
consists of three packages: an internal test package compiled together with
the library being tested (specified with `embed`), an external test package
compiled separately, and a generated test main package.


Rules
-----





<a id="#go_binary"></a>

### go_binary

<pre>
go_binary(<a href="#go_binary-name">name</a>, <a href="#go_binary-basename">basename</a>, <a href="#go_binary-cdeps">cdeps</a>, <a href="#go_binary-cgo">cgo</a>, <a href="#go_binary-clinkopts">clinkopts</a>, <a href="#go_binary-copts">copts</a>, <a href="#go_binary-cppopts">cppopts</a>, <a href="#go_binary-cxxopts">cxxopts</a>, <a href="#go_binary-data">data</a>, <a href="#go_binary-deps">deps</a>, <a href="#go_binary-embed">embed</a>,
          <a href="#go_binary-embedsrcs">embedsrcs</a>, <a href="#go_binary-gc_goopts">gc_goopts</a>, <a href="#go_binary-gc_linkopts">gc_linkopts</a>, <a href="#go_binary-importpath">importpath</a>, <a href="#go_binary-out">out</a>, <a href="#go_binary-srcs">srcs</a>, <a href="#go_binary-x_defs">x_defs</a>)
</pre>



#### **Attributes**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="go_binary-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="go_binary-basename"></a>basename |  -   | String | optional | "" |
| <a id="go_binary-cdeps"></a>cdeps |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_binary-cgo"></a>cgo |  -   | Boolean | optional | False |
| <a id="go_binary-clinkopts"></a>clinkopts |  -   | List of strings | optional | [] |
| <a id="go_binary-copts"></a>copts |  -   | List of strings | optional | [] |
| <a id="go_binary-cppopts"></a>cppopts |  -   | List of strings | optional | [] |
| <a id="go_binary-cxxopts"></a>cxxopts |  -   | List of strings | optional | [] |
| <a id="go_binary-data"></a>data |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_binary-deps"></a>deps |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_binary-embed"></a>embed |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_binary-embedsrcs"></a>embedsrcs |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_binary-gc_goopts"></a>gc_goopts |  -   | List of strings | optional | [] |
| <a id="go_binary-gc_linkopts"></a>gc_linkopts |  -   | List of strings | optional | [] |
| <a id="go_binary-importpath"></a>importpath |  -   | String | optional | "" |
| <a id="go_binary-out"></a>out |  -   | String | optional | "" |
| <a id="go_binary-srcs"></a>srcs |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_binary-x_defs"></a>x_defs |  -   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional | {} |




<a id="#go_library"></a>

### go_library

<pre>
go_library(<a href="#go_library-name">name</a>, <a href="#go_library-cdeps">cdeps</a>, <a href="#go_library-cgo">cgo</a>, <a href="#go_library-clinkopts">clinkopts</a>, <a href="#go_library-copts">copts</a>, <a href="#go_library-cppopts">cppopts</a>, <a href="#go_library-cxxopts">cxxopts</a>, <a href="#go_library-data">data</a>, <a href="#go_library-deps">deps</a>, <a href="#go_library-embed">embed</a>, <a href="#go_library-embedsrcs">embedsrcs</a>,
           <a href="#go_library-gc_goopts">gc_goopts</a>, <a href="#go_library-importmap">importmap</a>, <a href="#go_library-importpath">importpath</a>, <a href="#go_library-importpath_aliases">importpath_aliases</a>, <a href="#go_library-srcs">srcs</a>, <a href="#go_library-x_defs">x_defs</a>)
</pre>



#### **Attributes**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="go_library-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="go_library-cdeps"></a>cdeps |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_library-cgo"></a>cgo |  -   | Boolean | optional | False |
| <a id="go_library-clinkopts"></a>clinkopts |  -   | List of strings | optional | [] |
| <a id="go_library-copts"></a>copts |  -   | List of strings | optional | [] |
| <a id="go_library-cppopts"></a>cppopts |  -   | List of strings | optional | [] |
| <a id="go_library-cxxopts"></a>cxxopts |  -   | List of strings | optional | [] |
| <a id="go_library-data"></a>data |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_library-deps"></a>deps |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_library-embed"></a>embed |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_library-embedsrcs"></a>embedsrcs |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_library-gc_goopts"></a>gc_goopts |  -   | List of strings | optional | [] |
| <a id="go_library-importmap"></a>importmap |  -   | String | optional | "" |
| <a id="go_library-importpath"></a>importpath |  -   | String | optional | "" |
| <a id="go_library-importpath_aliases"></a>importpath_aliases |  -   | List of strings | optional | [] |
| <a id="go_library-srcs"></a>srcs |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_library-x_defs"></a>x_defs |  -   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional | {} |




<a id="#go_path"></a>

### go_path

<pre>
go_path(<a href="#go_path-name">name</a>, <a href="#go_path-data">data</a>, <a href="#go_path-deps">deps</a>, <a href="#go_path-include_data">include_data</a>, <a href="#go_path-include_pkg">include_pkg</a>, <a href="#go_path-include_transitive">include_transitive</a>, <a href="#go_path-mode">mode</a>)
</pre>



#### **Attributes**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="go_path-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="go_path-data"></a>data |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_path-deps"></a>deps |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_path-include_data"></a>include_data |  -   | Boolean | optional | True |
| <a id="go_path-include_pkg"></a>include_pkg |  -   | Boolean | optional | False |
| <a id="go_path-include_transitive"></a>include_transitive |  -   | Boolean | optional | True |
| <a id="go_path-mode"></a>mode |  -   | String | optional | "copy" |




<a id="#go_source"></a>

### go_source

<pre>
go_source(<a href="#go_source-name">name</a>, <a href="#go_source-data">data</a>, <a href="#go_source-deps">deps</a>, <a href="#go_source-embed">embed</a>, <a href="#go_source-gc_goopts">gc_goopts</a>, <a href="#go_source-srcs">srcs</a>)
</pre>



#### **Attributes**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="go_source-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="go_source-data"></a>data |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_source-deps"></a>deps |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_source-embed"></a>embed |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_source-gc_goopts"></a>gc_goopts |  -   | List of strings | optional | [] |
| <a id="go_source-srcs"></a>srcs |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |




<a id="#go_test"></a>

### go_test

<pre>
go_test(<a href="#go_test-name">name</a>, <a href="#go_test-cdeps">cdeps</a>, <a href="#go_test-cgo">cgo</a>, <a href="#go_test-clinkopts">clinkopts</a>, <a href="#go_test-copts">copts</a>, <a href="#go_test-cppopts">cppopts</a>, <a href="#go_test-cxxopts">cxxopts</a>, <a href="#go_test-data">data</a>, <a href="#go_test-deps">deps</a>, <a href="#go_test-embed">embed</a>, <a href="#go_test-embedsrcs">embedsrcs</a>,
        <a href="#go_test-gc_goopts">gc_goopts</a>, <a href="#go_test-gc_linkopts">gc_linkopts</a>, <a href="#go_test-importpath">importpath</a>, <a href="#go_test-linkmode">linkmode</a>, <a href="#go_test-rundir">rundir</a>, <a href="#go_test-srcs">srcs</a>, <a href="#go_test-x_defs">x_defs</a>)
</pre>



#### **Attributes**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="go_test-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="go_test-cdeps"></a>cdeps |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_test-cgo"></a>cgo |  -   | Boolean | optional | False |
| <a id="go_test-clinkopts"></a>clinkopts |  -   | List of strings | optional | [] |
| <a id="go_test-copts"></a>copts |  -   | List of strings | optional | [] |
| <a id="go_test-cppopts"></a>cppopts |  -   | List of strings | optional | [] |
| <a id="go_test-cxxopts"></a>cxxopts |  -   | List of strings | optional | [] |
| <a id="go_test-data"></a>data |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_test-deps"></a>deps |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_test-embed"></a>embed |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_test-embedsrcs"></a>embedsrcs |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_test-gc_goopts"></a>gc_goopts |  -   | List of strings | optional | [] |
| <a id="go_test-gc_linkopts"></a>gc_linkopts |  -   | List of strings | optional | [] |
| <a id="go_test-importpath"></a>importpath |  -   | String | optional | "" |
| <a id="go_test-linkmode"></a>linkmode |  -   | String | optional | "normal" |
| <a id="go_test-rundir"></a>rundir |  -   | String | optional | "" |
| <a id="go_test-srcs"></a>srcs |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="go_test-x_defs"></a>x_defs |  -   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional | {} |


## Defines and stamping

In order to provide build time information to go code without data files, we
support the concept of stamping.

Stamping asks the linker to substitute the value of a global variable with a
string determined at link time. Stamping only happens when linking a binary, not
when compiling a package. This means that changing a value results only in
re-linking, not re-compilation and thus does not cause cascading changes.

Link values are set in the `x_defs` attribute of any Go rule. This is a
map of string to string, where keys are the names of variables to substitute,
and values are the string to use. Keys may be names of variables in the package
being compiled, or they may be fully qualified names of variables in another
package.

These mappings are collected up across the entire transitive dependencies of a
binary. This means you can set a value using `x_defs` in a
`go_library`, and any binary that links that library will be stamped with that
value. You can also override stamp values from libraries using `x_defs`
on the `go_binary` rule if needed. The `--[no]stamp` option controls whether
stamping of workspace variables is enabled.

**Example**

Suppose we have a small library that contains the current version.

``` go
package version

var Version = "redacted"
```

We can set the version in the `go_library` rule for this library.

``` bzl
go_library(
    name = "version",
    srcs = ["version.go"],
    importpath = "example.com/repo/version",
    x_defs = {"Version": "0.9"},
)
```

Binaries that depend on this library may also set this value.

``` bzl
go_binary(
    name = "cmd",
    srcs = ["main.go"],
    deps = ["//version"],
    x_defs = {"example.com/repo/version.Version": "0.9"},
)
```

## Stamping with the workspace status script

You can use values produced by the workspace status command in your link stamp.
To use this functionality, write a script that prints key-value pairs, separated
by spaces, one per line. For example:

``` bash
#!/usr/bin/env bash

echo STABLE_GIT_COMMIT $(git rev-parse HEAD)
```

**NOTE:** keys that start with `STABLE_` will trigger a re-link when they change.
Other keys will NOT trigger a re-link.

You can reference these in `x_defs` using curly braces.

``` bzl
go_binary(
    name = "cmd",
    srcs = ["main.go"],
    deps = ["//version"],
    x_defs = {"example.com/repo/version.Version": "{STABLE_GIT_COMMIT}"},
)
```

You can build using the status script using the `--workspace_status_command`
argument on the command line:

``` bash
$ bazel build --stamp --workspace_status_command=./status.sh //:cmd
```

## Embedding

The sources, dependencies, and data of a `go_library` may be *embedded*
within another `go_library`, `go_binary`, or `go_test` using the `embed`
attribute. The embedding package will be compiled into a single archive
file. The embedded package may still be compiled as a separate target.

A minimal example of embedding is below. In this example, the command `bazel
build :foo_and_bar` will compile `foo.go` and `bar.go` into a single
archive. `bazel build :bar` will compile only `bar.go`. Both libraries must
have the same `importpath`.

.. code:: bzl

    go_library(
        name = "foo_and_bar",
        srcs = ["foo.go"],
        embed = [":bar"],
        importpath = "example.com/foo",
    )

    go_library(
        name = "bar",
        srcs = ["bar.go"],
        importpath = "example.com/foo",
    )

Embedding is most frequently used for tests and binaries. Go supports two
different kinds of tests. *Internal tests* (e.g., `package foo`) are compiled
into the same archive as the library under test and can reference unexported
definitions in that library. *External tests* (e.g., `package foo_test`) are
compiled into separate archives and may depend on exported definitions from the
internal test archive.

In order to compile the internal test archive, we *embed* the `go_library`
under test into a `go_test` that contains the test sources. The `go_test`
rule can automatically distinguish internal and external test sources, so they
can be listed together in `srcs`. The `go_library` under test does not
contain test sources. Other `go_binary` and `go_library` targets can depend
on it or embed it.

``` bzl
go_library(
    name = "foo_lib",
    srcs = ["foo.go"],
    importpath = "example.com/foo",
)

go_binary(
    name = "foo",
    embed = [":foo_lib"],
)

go_test(
    name = "go_default_test",
    srcs = [
        "foo_external_test.go",
        "foo_internal_test.go",
    ],
    embed = [":foo_lib"],
)
```

Embedding may also be used to add extra sources sources to a
`go_proto_library`.

.. code:: bzl

    proto_library(
        name = "foo_proto",
        srcs = ["foo.proto"],
    )

    go_proto_library(
        name = "foo_go_proto",
        importpath = "example.com/foo",
        proto = ":foo_proto",
    )

    go_library(
        name = "foo",
        srcs = ["extra.go"],
        embed = [":foo_go_proto"],
        importpath = "example.com/foo",
    )

## Cross compilation

rules_go can cross-compile Go projects to any platform the Go toolchain
supports. The simplest way to do this is by setting the `--platforms` flag on
the command line.

``` bash
$ bazel build --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64 //my/project
```

You can replace `linux_amd64` in the example above with any valid
GOOS / GOARCH pair. To list all platforms, run this command:

``` bash
$ bazel query 'kind(platform, @io_bazel_rules_go//go/toolchain:all)'
```

By default, cross-compilation will cause Go targets to be built in "pure mode",
which disables cgo; cgo files will not be compiled, and C/C++ dependencies will
not be compiled or linked.

Cross-compiling cgo code is possible, but not fully supported. You will need to
[write a CROSSTOOL file] that describes your C/C++ toolchain. You'll need to
ensure it works by building `cc_binary` and `cc_library` targets with the
`--cpu` command line flag set. Then, to build a mixed Go / C / C++ project,
add `pure = "off"` to your `go_binary` target and run Bazel with `--cpu`
and `--platforms`.

## Platform-specific dependencies

When cross-compiling, you may have some platform-specific sources and
dependencies. Source files from all platforms can be mixed freely in a single
`srcs` list. Source files are filtered using [build constraints] (filename
suffixes and `+build` tags) before being passed to the compiler.

Platform-specific dependencies are another story. For example, if you are
building a binary for Linux, and it has dependency that should only be built
when targeting Windows, you will need to filter it out using Bazel [select]
expressions:

``` bzl
go_binary(
    name = "cmd",
    srcs = [
        "foo_linux.go",
        "foo_windows.go",
    ],
    deps = [
        # platform agnostic dependencies
        "//bar",
    ] + select({
        # OS-specific dependencies
        "@io_bazel_rules_go//go/platform:linux": [
            "//baz_linux",
        ],
        "@io_bazel_rules_go//go/platform:windows": [
            "//quux_windows",
        ],
        "//conditions:default": [],
    }),
)
```

`select` accepts a dictionary argument. The keys are labels that reference [config_setting] rules.
The values are lists of labels. Exactly one of these
lists will be selected, depending on the target configuration. rules_go has
pre-declared `config_setting` rules for each OS, architecture, and
OS-architecture pair. For a full list, run this command:

``` bash
$ bazel query 'kind(config_setting, @io_bazel_rules_go//go/platform:all)'
```

[Gazelle] will generate dependencies in this format automatically.