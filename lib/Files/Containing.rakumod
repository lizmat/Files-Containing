use hyperize:ver<0.0.2>:auth<zef:lizmat>;
use paths:ver<10.0.4>:auth<zef:lizmat>;
use Lines::Containing:ver<0.0.3>:auth<zef:lizmat>;

my sub is-simple-Callable($needle) {
    Callable.ACCEPTS($needle) && !Regex.ACCEPTS($needle)
}

my proto sub files-containing(|) is export {*}
my multi sub files-containing(
  Any:D   $needle,
  Str:D   $root?,
  List() :$extensions,
         :$include-dot-files,
         :$file is copy,
         :$dir,
         *%_
) {
    without $file {
        my @exts := $extensions // ();
        my $ext  := @exts[0];

        $file = $include-dot-files
          ?? $ext
            ?? @exts == 1
              ?? *.ends-with($ext)
              !! *.ends-with(any(@exts))
            !! True
          !! $ext
            ?? @exts == 1
              ?? { .ends-with($ext)       && !.starts-with(".") }
              !! { .ends-with(any(@exts)) && !.starts-with(".") }
            !! !*.starts-with(".")
    }
    files-containing($needle, paths($root, :$file, :$dir), |%_)
}
my multi sub files-containing(
  Any:D  $needle,
         @files,
        :i($ignorecase),
        :m($ignoremark),
        :$offset,
        :$files-only,
        :$batch,
        :$degree,
) {

    @files.&hyperize($batch, $degree).map: $files-only
      ?? is-simple-Callable($needle)
        ?? -> IO() $io { $io if $needle($io.slurp) }
        !! -> IO() $io { $io if try $io.slurp.contains($needle) }
      !! -> IO() $io {
                with try lines-containing(
                  $io, $needle, :$ignorecase, :$ignoremark,
                  :p, :offset($offset // 0)
                ) -> @pairs {
                    $io => @pairs.Slip if @pairs.elems;
                }
            }
}

=begin pod

=head1 NAME

Files-Containing - Search for strings in files

=head1 SYNOPSIS

=begin code :lang<raku>

use Files-Containing;

.say for files-containing("foo", :files-only)

for files-containing("foo") {
    say .key.relative;
    for .value {
        say .key ~ ': ' ~ .value;  # linenr: line
    }
}

=end code

=head1 DESCRIPTION

Files-Containing exports a single subroutine C<files-containing> which
produces a list of files and/or locations in those files given a certain
path specification and needle.

=head1 EXPORTED SUBROUTINES

=head2 files-containing

The C<files-containing> subroutine returns either a list of filenames
(when the C<:files-only> named argument is specified) or a list of pairs,
of which the key is the filename, and the value is a list of pairs, in
which the key is the linenumber and the value is the line in which the
needle was found.

=head3 Positional Arguments

=head4 needle

The first positional argument is the  needle to search for.  This can either
be a C<Str>, a C<Regex> or a C<Callable>.

=head4 files or directory

The second positional argument is optional.  If not specified, or specified
with an undefined value, then it will assume to search from the current
directory.

It can be specified with a list of files to be searched.  Or it can be a
scalar value indicating the directory that should be searched for recursively.

=head3 Named Arguments

=head4 :batch

The C<:batch> named argument to be passed to the hypering logic for
parallel searching.  It determines the number of files that will be
processed per thread at a time.  Defaults to whatever the default of
C<hyper> is.

=head4 :degree

The C<:degree> named argument to be passed to the hypering logic for
parallel searching.  It determines the maximum number of threads that
will be used to do the processing.  Defaults to whatever the default of
C<hyper> is.

=head4 :dir

The C<:dir> named argument to be passed to the
L<paths|https://raku.land/zef:lizmat/paths> subroutine.  By default will
look in all directories, except the ones that start with a period.

Ignored if a list of files was specified as the second positional argument.

=head4 :extensions

The C<:extensions> named argument indicates the extensions of the files that
should be searched.

Ignored if a C<:file> named argument was specified.  Defaults to all
extensions.

=head4 :file

The C<:file> named argument to be passed to the
L<paths|https://raku.land/zef:lizmat/paths> subroutine.  Ignored if a list
of files was specified as the second positional argument.

=head4 :files-only

The C<:files-only> named argument to be passed determines whether only
filename should be returned, rather than a list of pairs, in which the
key is the filename, and the value is a list of filenumber / line pairs.

=head4 :include-dot-files

The C<:include-dot-files> named argument is a boolean indicating whether
filenames that start with a period should be included.

Ignored if a C<:file> named argument was specified.  Defaults to C<False>,
indicating to B<not> include filenames that start with a period.

=head4 :i or :ignorecase

The C<:i> (or C<:ignorecase>) named argument indicates whether searches
should be done without regard to case.  Ignored if the needle is B<not>
a C<Str>.

=head4 :i or :ignoremark

The C<:m> (or C<:ignoremark>) named argument indicates whether searches
should be done by only looking at the base characters, without regard to
any additional accents.  Ignored if the needle is B<not> a C<Str>.

=head4 :offset

The C<:offset> named argument indicates the value of the first line number
in a file.  It defaults to B<0>.  Ignored if the C<:files-only> named argument
has been specified with a true value.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Files-Containing .
Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a
L<small sponsorship|https://github.com/sponsors/lizmat/>  would mean a great
deal to me!

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
