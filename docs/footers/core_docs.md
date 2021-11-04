## Examples

### go_library
``` bzl
go_library(
    name = "foo",
    srcs = [
        "foo.go",
        "bar.go",
    ],
    deps = [
        "//tools",
        "@org_golang_x_utils//stuff",
    ],
    importpath = "github.com/example/project/foo",
    visibility = ["//visibility:public"],
)
```

### go_test

To write an internal test, reference the library being tested with the :param:`embed`
instead of :param:`deps`. This will compile the test sources into the same package as the library
sources.

#### Internal test example

This builds a test that can use the internal interface of the package being tested.

In the normal go toolchain this would be the kind of tests formed by adding writing
`<file>_test.go` files in the same package.

It references the library being tested with `embed`.


``` bzl
go_library(
    name = "lib",
    srcs = ["lib.go"],
)

go_test(
    name = "lib_test",
    srcs = ["lib_test.go"],
    embed = [":lib"],
)
```

#### External test example

This builds a test that can only use the public interface(s) of the packages being tested.

In the normal go toolchain this would be the kind of tests formed by adding an `<name>_test`
package.

It references the library(s) being tested with `deps`.

``` bzl
go_library(
    name = "lib",
    srcs = ["lib.go"],
)

go_test(
    name = "lib_xtest",
    srcs = ["lib_x_test.go"],
    deps = [":lib"],
)
```

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

### go_library

``` bzl
go_library(
    name = "foo",
    srcs = [
        "foo.go",
        "bar.go",
    ],
    deps = [
        "//tools",
        "@org_golang_x_utils//stuff",
    ],
    importpath = "github.com/example/project/foo",
    visibility = ["//visibility:public"],
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

***Note:*** keys that start with `STABLE_` will trigger a re-link when they change.
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

``` bzl
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
```

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

``` bzl
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
```

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
  [go_path]: #go_path
  [go_source]: #go_source
  [go_test]: #go_test
  [Examples]: #examples
  [go_library]: #go_library-1
  [go_test]: #go_test-1    
  [Defines and stamping]: #defines-and-stamping
  [Embedding]: #embedding
  [Cross compilation]: #cross-compilation
  [Platform-specific dependencies]: #platform-specific-dependencies