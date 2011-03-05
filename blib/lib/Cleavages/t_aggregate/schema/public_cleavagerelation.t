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
        moniker     => 'CleavageRelation',
    }
);
$schematest->methods(
    {
        columns => [
            qw<
                id
                name
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
