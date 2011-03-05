#!/usr/bin/perl
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;

use FindBin qw($Bin);
use Test::More tests => 3;

BEGIN {
    use_ok('File::MimeInfo::Magic');
}

my $mime_type;

$mime_type = File::MimeInfo::Magic::mimetype(
    $Bin . q{../root/static/images/mystery_head.jpg}
);
is($mime_type, q{image/jpeg});

$mime_type = File::MimeInfo::Magic::mimetype(
    $Bin . q{../root/static/images/catalyst_logo.png}
);
is($mime_type, q{image/png});
