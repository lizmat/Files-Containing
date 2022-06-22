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
```

DESCRIPTION
===========

Files-Containing exports a single subroutine `files-containing` which produces a list of files and/or locations in those files given a certain path specification and needle.

EXPORTED SUBROUTINES
====================

files-containing
----------------

The `files-containing` subroutine returns either a list of filenames (when the `:files-only` named argument is specified) or a list of pairs, of which the key is the filename, and the value is a list of pairs, in which the key is the linenumber and the value is the line in which the needle was found.

### Positional Arguments

#### needle

The first positional argument is the needle to search for. This can either be a `Str`, a `Regex` or a `Callable`. If given a `Callable`, this implies the `:files-only` named argument to be set.

#### files or directory

The second positional argument is optional. If not specified, or specified with an undefined value, then it will assume to search from the current directory.

It can be specified with a list of files to be searched. Or it can be a scalar value indicating the directory that should be searched for recursively.

### Named Arguments

#### :batch

The `:batch` named argument to be passed to the hypering logic for parallel searching. It determines the number of files that will be processed per thread at a time. Defaults to whatever the default of `hyper` is.

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

#### :include-dot-files

The `:include-dot-files` named argument is a boolean indicating whether filenames that start with a period should be included.

Ignored if a `:file` named argument was specified. Defaults to `False`, indicating to **not** include filenames that start with a period.

#### :i or :ignorecase

The `:i` (or `:ignorecase`) named argument indicates whether searches should be done without regard to case. Ignored if the needle is **not** a `Str`.

#### :m or :ignoremark

The `:m` (or `:ignoremark`) named argument indicates whether searches should be done by only looking at the base characters, without regard to any additional accents. Ignored if the needle is **not** a `Str`.

#### :offset

The `:offset` named argument indicates the value of the first line number in a file. It defaults to **0**. Ignored if the `:files-only` named argument has been specified with a true value.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Files-Containing . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

