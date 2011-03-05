package Cleavages::Schema::FileRating;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("file_rating");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    default_value => "nextval('file_rating_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "created",
  {
    data_type => "timestamp with time zone",
    default_value => "now()",
    is_nullable => 0,
    size => 8,
  },
  "file_id",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "rating",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "ip_addr",
  {
    data_type => "inet",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("file_rating_pkey", ["id"]);
__PACKAGE__->belongs_to("file_id", "Cleavages::Schema::File", { id => "file_id" });


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-01-15 20:37:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lEdNoRbFHgn6o1JJ8oP4KA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
