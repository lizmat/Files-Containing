[![Actions Status](https://github.com/lizmat/Files-Containing/actions/workflows/test.yml/badge.svg)](https://github.com/lizmat/Files-Containing/actions)

NAME
====

Files-Containing - Search for strings in files

SYNOPSIS
========

```raku
use Files-Containing;

.say for files-containing("foo", :files-only)

for files-containing("foo") {
    say .key.relative;
    for .value {
        say .key ~ ': ' ~ .value;  # linenr: line
    }
}

for files-containing("foo", :count-only) {
    say .key.relative ~ ': ' ~  .value;
}
```

DESCRIPTION
===========

Files-Containing exports a single subroutine `files-containing` which produces a list of files and/or locations in those files given a certain path specification and needle.

EXPORTED SUBROUTINES
====================

files-containing
----------------

The `files-containing` subroutine returns either a list of filenames (when the `:files-only` named argument is specified) or a list of pairs, of which the key is the filename, and the value is a list of pairs, in which the key is the linenumber and the value is the line in which the needle was found.

RE-EXPORTED SUBROUTINES
=======================

hyperize
========

As provided by the `hyperize` module that is used by this module.

lines-containing
================

As provided by the `Lines::Containing` module that is used by this module.

paths
=====

As provided by the `paths` module that is used by this module.

### Positional Arguments

#### needle

The first positional argument is the needle to search for. This can either be a `Str`, a `Regex` or a `Callable`. See the documentation of the [Lines::Containing](https://raku.land/zef:lizmat/Lines::Containing) module for the exact semantics of each possible needle.

#### files or directory

The second positional argument is optional. If not specified, or specified with an undefined value, then it will assume to search from the current directory.

It can be specified with a list of files to be searched. Or it can be a scalar value indicating the directory that should be searched for recursively. If it is a scalar value and it is an existing file, then only that file will be searched.

### Named Arguments

#### :batch

The `:batch` named argument to be passed to the hypering logic for parallel searching. It determines the number of files that will be processed per thread at a time. Defaults to whatever the default of `hyper` is.

#### :count-only

The `count-only` named argument to be passed to the `lines-containing|https://raku.land/zef:lizmat/lines-containing` subroutine, which will only return a count of matched lines if specified with a `True` value. `False` by default.

#### :degree

The `:degree` named argument to be passed to the hypering logic for parallel searching. It determines the maximum number of threads that will be used to do the processing. Defaults to whatever the default of `hyper` is.

#### :dir

The `:dir` named argument to be passed to the [paths](https://raku.land/zef:lizmat/paths) subroutine. By default will look in all directories, except the ones that start with a period.

Ignored if a list of files was specified as the second positional argument.

#### :extensions

The `:extensions` named argument indicates the extensions of the files that should be searched.

Ignored if a `:file` named argument was specified. Defaults to all extensions.

#### :file

The `:file` named argument to be passed to the [paths](https://raku.land/zef:lizmat/paths) subroutine. Ignored if a list of files was specified as the second positional argument.

#### :files-only

The `:files-only` named argument determines whether only the filename should be returned, rather than a list of pairs, in which the key is the filename, and the value is a list of filenumber / line pairs.

#### :follow-symlinks

The `:follow-symlinks` named argument to be passed to the [paths](https://raku.land/zef:lizmat/paths) subroutine. Ignored if a list of files was specified as the second positional argument.

#### :i or :ignorecase

The `:i` (or `:ignorecase`) named argument indicates whether searches should be done without regard to case. Ignored if the needle is **not** a `Str`.

#### :include-dot-files

The `:include-dot-files` named argument is a boolean indicating whether filenames that start with a period should be included.

Ignored if a `:file` named argument was specified. Defaults to `False`, indicating to **not** include filenames that start with a period.

#### :invert-match

The `:invert-match` named argument is a boolean indicating whether to produce files / lines that did **NOT** match (if a true value is specified). Default is `False`, so that only matching files / lines will be produced.

#### :m or :ignoremark

The `:m` (or `:ignoremark`) named argument indicates whether searches should be done by only looking at the base characters, without regard to any additional accents. Ignored if the needle is **not** a `Str`.

#### :max-count=N

The `:max-count` named argument indicates the maximum number of lines that should be reported per file. Defaults to `Any`, indicating that all possible lines will be produced. Ignored if `:files-only` is specified with a true value.

#### :offset=N

The `:offset` named argument indicates the value of the first line number in a file. It defaults to **0**. Ignored if the `:files-only` named argument has been specified with a true value.

#### :sort

The `:sort` named argument indicates whether the list of files obtained from the [paths](https://raku.land/zef:lizmat/paths) subroutine should be sorted. Ignored if a list of files was specified as the second positional argument. Can either be a `Bool`, or a `Callable` to be used by the sort routine to sort.

#### :type=words|starts-with|ends-with|contains

Only makes sense if the needle is a `Cool` object. With `words` specified, will look for needle as a word in a line, with `starts-with` will look for the needle at the beginning of a line, with `ends-with` will look for the needle at the end of a line, with `contains` will look for the needle at any position in a line. Which is the default.

has-word
--------

The `has-word` subroutine, as provided by the version of [has-word](https://raku.land/zef:lizmat/has-word) that is used.

paths
-----

The `paths` subroutine, as provided by the version of [paths](https://raku.land/zef:lizmat/paths) that is used.

lines-containing
----------------

The `lines-containing` subroutine, as provided by the version of [lines-containing](https://raku.land/zef:lizmat/Lines::Containing) that is used.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Files-Containing . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

