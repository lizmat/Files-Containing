use hyperize:ver<0.0.2>:auth<zef:lizmat>;
use paths:ver<10.0.3>:auth<zef:lizmat>;
use Lines::Containing:ver<0.0.2>:auth<zef:lizmat>;

my sub is-simple-Callable($needle) {
    Callable.ACCEPTS($needle) && !Regex.ACCEPTS($needle)
}

my proto sub files-containing(|) is export {*}
my multi sub files-containing(
  Any:D   $needle,
  Str:D   $root = ".",
  List() :$extensions,
         :$include-dot-files,
         :$file is copy,
         :$dir  is copy,
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
    $dir = True without $dir;

    files-containing($needle, paths($root, :$file, :$dir), |%_)
}
my multi sub files-containing(
  Any:D  $needle,
         @files,
        :i($ignorecase),
        :m($ignoremark),
        :$offset = 0,
        :$files-only,
        :$batch,
        :$degree,
) {

    @files.&hyperize($batch, $degree).map: $files-only
      ?? is-simple-Callable($needle)
        ?? -> IO() $io { $io if $needle($io.slurp) }
        !! -> IO() $io { $io if $io.slurp.contains($needle) }
      !! -> IO() $io {
                with try lines-containing(
                  $io, $needle, :$ignorecase, :$ignoremark, :p, :$offset
                ) -> @pairs {
                    $io => @pairs.Slip if @pairs.elems;
                }
            }
}

for files-containing('method hyper', '../../rakudo', :offset(1), :extensions<pm6>).sort(*.key.Str) {
    if $_ ~~ Pair {
        say .key.relative;
        say sprintf("%3d", .key) ~ ": " ~ .value for .value;
        say "";
    }
    else {
        .say;
    }
}

=begin pod

=head1 NAME

Files-Containing - Search for strings in files

=head1 SYNOPSIS

=begin code :lang<raku>

use Files-Containing;

=end code

=head1 DESCRIPTION

Files-Containing is ...

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
