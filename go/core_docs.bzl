"""
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
  [Defines and stamping]: #defines-and-stamping
  [Embedding]: #embedding
  [Cross compilation]: #cross-compilation
  [Platform-specific dependencies]: #platform-specific-dependencies


# Core Go rules

## Contents
- [Introduction](#introduction)
- [Rules](#rules)
  - [go_binary](#go_binary)
  - [go_library](#go_library)
  - [go_path](#go_path)
  - [go_source](#go_source)
  - [go_test](#go_test)
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

"""

load("private/rules/library.bzl", _go_library = "go_library")
load("private/rules/binary.bzl", _go_binary = "go_binary")
load("private/rules/test.bzl", _go_test = "go_test")
load("private/rules/source.bzl", _go_source = "go_source")
load("private/tools/path.bzl", _go_path = "go_path")

go_library = _go_library
go_binary = _go_binary
go_test = _go_test
go_source = _go_source
go_path = _go_path
