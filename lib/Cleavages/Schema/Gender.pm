package Cleavages::Schema::Gender;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("gender");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    default_value => "nextval('gender_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "name",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 0,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("gender_pkey", ["id"]);
__PACKAGE__->add_unique_constraint("gender_name_key", ["name"]);
__PACKAGE__->has_many(
  "files",
  "Cleavages::Schema::File",
  { "foreign.gender" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-02-06 22:22:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JqjAx1ZMyNPW4stNlNYO1Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
