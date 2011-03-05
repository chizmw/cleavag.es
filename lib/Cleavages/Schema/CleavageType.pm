package Cleavages::Schema::CleavageType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("cleavage_type");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    default_value => "nextval('cleavage_type_id_seq'::regclass)",
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
__PACKAGE__->add_unique_constraint("cleavage_type_name_key", ["name"]);
__PACKAGE__->add_unique_constraint("cleavage_type_pkey", ["id"]);
__PACKAGE__->has_many(
  "files",
  "Cleavages::Schema::File",
  { "foreign.cleavage_type" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-01-10 23:36:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VA14xXtB59gNAB1jeJ1MAQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
