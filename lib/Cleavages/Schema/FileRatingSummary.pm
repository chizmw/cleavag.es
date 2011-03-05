package Cleavages::Schema::FileRatingSummary;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("file_rating_summary");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    default_value => "nextval('file_rating_summary_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "file_md5",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
  "current_rating",
  { data_type => "real", default_value => 0, is_nullable => 0, size => 4 },
  "votes_made",
  { data_type => "integer", default_value => 1, is_nullable => 0, size => 4 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("file_rating_summary_pkey", ["id"]);
__PACKAGE__->add_unique_constraint("file_rating_summary_file_md5_key", ["file_md5"]);
__PACKAGE__->has_many(
  "files",
  "Cleavages::Schema::File",
  { "foreign.rating_summary" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-01-15 20:37:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:inCoYo8EP4R8ZNOHMqSF1w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
