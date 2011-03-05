#!/usr/bin/perl
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;

# load the module that provides all of the common test functionality
use FindBin qw($Bin);
use lib $Bin;
use SchemaTest;

my $schematest = SchemaTest->new(
    {
        dsn         => 'dbi:Pg:dbname=cleavages',
        username    => 'cleavages',
        namespace   => 'Cleavages::Schema',
        moniker     => 'FileRatingSummary',
    }
);
$schematest->methods(
    {
        columns => [
            qw<
                id
                file_md5
                current_rating
                votes_made
            >
        ],

        relations => [
            qw<
                files
            >
        ],

        custom => [
            qw<
            >
        ],

        resultsets => [
            qw<
            >
        ],
    }
);

$schematest->run_tests();
