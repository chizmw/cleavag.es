#!/usr/bin/perl
use strict;
use warnings;

use File::MimeInfo::Magic;

my $mime_type = File::MimeInfo::Magic::mimetype(
	$ARGV[0] || q{root/static/images/mystery_head.jpg}
);

print $mime_type, "\n";
