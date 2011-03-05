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
        moniker     => 'Sessions',
    }
);
$schematest->methods(
    {
        columns => [
            qw<
                id
                session_data
                expires
                created
            >
        ],

        relations => [
            qw<
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
