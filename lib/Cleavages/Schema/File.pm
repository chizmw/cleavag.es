package Cleavages::Schema::File;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("file");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    default_value => "nextval('file_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "md5_hex",
  {
    data_type => "character",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "filename",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "filepath",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "mime_type",
  {
    data_type => "character varying",
    default_value => undef,
    is_nullable => 0,
    size => 50,
  },
  "gender",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "cleavage_type",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "cleavage_relation",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "uploaded_by",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "uploaded",
  {
    data_type => "timestamp with time zone",
    default_value => "now()",
    is_nullable => 0,
    size => 8,
  },
  "rating_summary",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
  "thumbnail",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "remain_anonymous",
  {
    data_type => "boolean",
    default_value => "false",
    is_nullable => 0,
    size => 1,
  },
  "verified_permission",
  {
    data_type => "boolean",
    default_value => "false",
    is_nullable => 0,
    size => 1,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("file_md5_hex_key", ["md5_hex"]);
__PACKAGE__->add_unique_constraint("file_filepath_key", ["filepath"]);
__PACKAGE__->add_unique_constraint("file_pkey", ["id"]);
__PACKAGE__->belongs_to("gender", "Cleavages::Schema::Gender", { id => "gender" });
__PACKAGE__->belongs_to(
  "cleavage_relation",
  "Cleavages::Schema::CleavageRelation",
  { id => "cleavage_relation" },
);
__PACKAGE__->belongs_to(
  "uploaded_by",
  "Cleavages::Schema::Person",
  { id => "uploaded_by" },
);
__PACKAGE__->belongs_to(
  "cleavage_type",
  "Cleavages::Schema::CleavageType",
  { id => "cleavage_type" },
);
__PACKAGE__->belongs_to(
  "rating_summary",
  "Cleavages::Schema::FileRatingSummary",
  { id => "rating_summary" },
);
__PACKAGE__->has_many(
  "file_ratings",
  "Cleavages::Schema::FileRating",
  { "foreign.file_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-01-19 08:59:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tUUB1sE/6GKiX6GvHUolIg

__PACKAGE__->resultset_class('Cleavages::ResultSet::File');

__PACKAGE__->belongs_to(
  "ratingSummary",
  "Cleavages::Schema::FileRatingSummary",
  { id => "rating_summary" },
);

1;
