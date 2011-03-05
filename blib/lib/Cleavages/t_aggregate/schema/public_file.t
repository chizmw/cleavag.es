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
        moniker     => 'File',
    }
);
$schematest->methods(
    {
        columns => [
            qw<
                id
                md5_hex
                filename
                filepath
                mime_type
                gender
                cleavage_type
                cleavage_relation
                uploaded
                rating_summary
                thumbnail
                remain_anonymous
                verified_permission
            >
        ],

        relations => [
            qw<
                gender
                cleavage_relation
                uploaded_by
                cleavage_type
                rating_summary
                file_ratings
            >
        ],

        custom => [
            qw<
            >
        ],

        resultsets => [
            qw<
                add_rating
                most_recent
                random_file
                top_rated
            >
        ],
    }
);

$schematest->run_tests();
