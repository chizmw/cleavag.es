package Cleavages::Schema::Result::File;

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

Cleavages::Schema::Result::File

=cut

__PACKAGE__->table("file");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'file_id_seq'

=head2 md5_hex

  data_type: 'char'
  is_nullable: 0
  size: 32

=head2 filename

  data_type: 'text'
  is_nullable: 0

=head2 filepath

  data_type: 'text'
  is_nullable: 0

=head2 mime_type

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 uploaded_by

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 uploaded

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 gender

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 cleavage_type

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 cleavage_relation

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 rating_summary

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 thumbnail

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "file_id_seq",
  },
  "md5_hex",
  { data_type => "char", is_nullable => 0, size => 32 },
  "filename",
  { data_type => "text", is_nullable => 0 },
  "filepath",
  { data_type => "text", is_nullable => 0 },
  "mime_type",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "uploaded_by",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "uploaded",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "gender",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "cleavage_type",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "cleavage_relation",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "rating_summary",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "thumbnail",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("file_md5_hex_key", ["md5_hex"]);
__PACKAGE__->add_unique_constraint("file_filepath_key", ["filepath"]);

=head1 RELATIONS

=head2 gender

Type: belongs_to

Related object: L<Cleavages::Schema::Result::Gender>

=cut

__PACKAGE__->belongs_to(
  "gender",
  "Cleavages::Schema::Result::Gender",
  { id => "gender" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 cleavage_type

Type: belongs_to

Related object: L<Cleavages::Schema::Result::CleavageType>

=cut

__PACKAGE__->belongs_to(
  "cleavage_type",
  "Cleavages::Schema::Result::CleavageType",
  { id => "cleavage_type" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 cleavage_relation

Type: belongs_to

Related object: L<Cleavages::Schema::Result::CleavageRelation>

=cut

__PACKAGE__->belongs_to(
  "cleavage_relation",
  "Cleavages::Schema::Result::CleavageRelation",
  { id => "cleavage_relation" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 uploaded_by

Type: belongs_to

Related object: L<Cleavages::Schema::Result::Person>

=cut

__PACKAGE__->belongs_to(
  "uploaded_by",
  "Cleavages::Schema::Result::Person",
  { id => "uploaded_by" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 rating_summary

Type: belongs_to

Related object: L<Cleavages::Schema::Result::FileRatingSummary>

=cut

__PACKAGE__->belongs_to(
  "rating_summary",
  "Cleavages::Schema::Result::FileRatingSummary",
  { id => "rating_summary" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 file_ratings

Type: has_many

Related object: L<Cleavages::Schema::Result::FileRating>

=cut

__PACKAGE__->has_many(
  "file_ratings",
  "Cleavages::Schema::Result::FileRating",
  { "foreign.file_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-04-04 18:08:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ti+Fpw/8IiiVYl3TBo3WMw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
