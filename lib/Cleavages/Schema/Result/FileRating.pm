package Cleavages::Schema::Result::FileRating;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Cleavages::Schema::Result::FileRating

=cut

__PACKAGE__->table("file_rating");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'file_rating_id_seq'

=head2 created

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 file_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 rating

  data_type: 'integer'
  is_nullable: 0

=head2 ip_addr

  data_type: 'inet'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "file_rating_id_seq",
  },
  "created",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "file_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "rating",
  { data_type => "integer", is_nullable => 0 },
  "ip_addr",
  { data_type => "inet", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 file

Type: belongs_to

Related object: L<Cleavages::Schema::Result::File>

=cut

__PACKAGE__->belongs_to(
  "file",
  "Cleavages::Schema::Result::File",
  { id => "file_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-04-04 18:08:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JIJXtIzc8xFB8Iq4vdG/BQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
