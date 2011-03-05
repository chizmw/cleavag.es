package Cleavages::Schema::Sessions;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("sessions");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "character",
    default_value => undef,
    is_nullable => 0,
    size => 72,
  },
  "session_data",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "expires",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
  "created",
  {
    data_type => "timestamp with time zone",
    default_value => "now()",
    is_nullable => 0,
    size => 8,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("sessions_pkey", ["id"]);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-01-19 08:59:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EkIYMELHGA2weEU4nvdEMQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
