"""
# Go Protocol buffers

rules_go provides rules that generate Go packages from .proto files. These
packages can be imported like regular Go libraries.

## Contents
TODO: add anchors and missing links
- [Overview](#overview)
- [Avoiding conflicts](#avoiding-conflicts)
  - [Option 1: Use go_proto_library exclusively]()
  - [Option 2: Use pre-generated .pb.go files]()
  - [A note on vendored .proto files]()
- [API]()
  - [go_proto_library]()
  - [go_proto_compiler]()
- [Predefined plugins]()
  - [Providers]()
- [GoProtoCompiler]()
- [Dependencies]()

## Additional resources
TODO: add missing links
- [proto_library]
- [default Go plugin]
- [common plugins]
- [Go providers]
- [GoLibrary]
- [GoSource]
- [GoArchive]
- [Gazelle]
- [Make variable substitution]
- [Bourne shell tokenization]
- [gogoprotobuf]
- [compiler.bzl]
- [bazelbuild/bazel#3867]

------------------------------------------------------------------------

## Overview

Protocol buffers are built with the three rules below. `go_proto_library` and
`go_proto_compiler` may be loaded from `@io_bazel_rules_go//proto:def.bzl`.

* [proto_library]: This is a Bazel built-in rule. It lists a set of .proto
  files in its `srcs` attribute and lists other `proto_library` dependencies
  in its `deps` attribute. `proto_library` rules may be referenced by
  language-specific code generation rules like `java_proto_library` and
  `go_proto_library`.
* [go_proto_library]: Generates Go code from .proto files using one or more
  proto plugins, then builds that code into a Go library. `go_proto_library`
  references `proto_library` sources via the `proto` attribute. They may
  reference other `go_proto_library` and `go_library` dependencies via the
  `deps` attributes.  `go_proto_library` rules can be depended on or
  embedded directly by `go_library` and `go_binary`.
* [go_proto_compiler]: Defines a protoc plugin. By default,
  `go_proto_library` generates Go code with the [default Go plugin], but
  other plugins can be used by setting the `compilers` attribute. A few
  [common plugins] are provided in `@io_bazel_rules_go//proto`.

The `go_proto_compiler` rule produces a [GoProtoCompiler] provider. If you
need a greater degree of customization (for example, if you don't want to use
protoc), you can implement a compatible rule that returns one of these.

The `go_proto_library` rule produces the normal set of [Go providers]. This
makes it compatible with other Go rules for use in `deps` and `embed`
attributes.

## Avoiding conflicts

When linking programs that depend on protos, care must be taken to ensure that
the same proto isn't registered by more than one package. This may happen if
you depend on a `go_proto_library` and a vendored `go_library` generated
from the same .proto files. You may see compile-time, link-time, or run-time
errors as a result of this.

There are two main ways to avoid conflicts.

### Option 1: Use go_proto_library exclusively

You can avoid proto conflicts by using `go_proto_library` to generate code
at build time and avoiding `go_library` rules based on pre-generated .pb.go
files.

Gazelle generates rules in this mode by default. When .proto files are present,
it will generate `go_proto_library` rules and `go_library` rules that embed
them (which are safe to use). Gazelle will automatically exclude .pb.go files
that correspond to .proto files. If you have .proto files belonging to multiple
packages in the same directory, add the following directives to your
root build file:

``` bzl
# gazelle:proto package
# gazelle:proto_group go_package
```

rules_go provides `go_proto_library` rules for commonly used proto libraries.
The Well Known Types can be found in the `@io_bazel_rules_go//proto/wkt`
package. There are implicit dependencies of `go_proto_library` rules
that use the default compiler, so they don't need to be written
explicitly in `deps`. You can also find rules for Google APIs and gRPC in
`@go_googleapis//`. You can list these rules with the commands:

``` bash
$ bazel query 'kind(go_proto_library, @io_bazel_rules_go//proto/wkt:all)'
$ bazel query 'kind(go_proto_library, @go_googleapis//...)'
```

Some commonly used Go libraries, such as `github.com/golang/protobuf/ptypes`,
depend on the Well Known Types. In order to avoid conflicts when using these
libraries, separate versions of these libraries are provided with
`go_proto_library` dependencies. Gazelle resolves imports of these libraries
automatically. For example, it will resolve `ptypes` as
`@com_github_golang_protobuf//ptypes:go_default_library_gen`.

### Option 2: Use pre-generated .pb.go files

You can also avoid conflicts by generating .pb.go files ahead of time and using
those exclusively instead of using `go_proto_library`. This may be a better
option for established Go projects that also need to build with `go build`.

Gazelle can generate rules for projects built in this mode. Add the following
comment to your root build file:

``` bzl
# gazelle:proto disable_global
```

This prevents Gazelle from generating `go_proto_library` rules. .pb.go files
won't be excluded, and all special cases for imports (such as `ptypes`) are
disabled.

If you have `go_repository` rules in your `WORKSPACE` file that may
have protos, you'll also need to add
`build_file_proto_mode = "disable_global"` to those as well.

``` bzl
go_repository(
    name = "com_example_some_project",
    importpath = "example.com/some/project",
    tag = "v0.1.2",
    build_file_proto_mode = "disable_global",
)
```

### A note on vendored .proto files

Bazel can only handle imports in .proto files that are relative to a repository
root directory. This means, for example, if you import `"foo/bar/baz.proto"`,
that file must be in the directory `foo/bar`, not
`vendor/example.com/repo/foo/bar`.

If you have proto files that don't conform to this convention, follow the
instructions for using pre-generated .pb.go files above.

The Bazel tracking issue for supporting this is [bazelbuild/bazel#3867].

## API

"""

load("proto/def.bzl", _go_proto_library = "go_proto_library")
load("proto/compiler.bzl", _go_proto_compiler = "go_proto_compiler", _go_proto_compiler_provider = "GoProtoCompiler")

go_proto_library = _go_proto_library
go_proto_compiler = _go_proto_compiler
go_proto_compiler_provider = _go_proto_compiler_provider
