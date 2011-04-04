package Cleavages::Schema::Result::FileRatingSummary;

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

Cleavages::Schema::Result::FileRatingSummary

=cut

__PACKAGE__->table("file_rating_summary");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'file_rating_summary_id_seq'

=head2 file_md5

  data_type: 'text'
  is_nullable: 0

=head2 current_rating

  data_type: 'real'
  default_value: 0
  is_nullable: 0

=head2 votes_made

  data_type: 'integer'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "file_rating_summary_id_seq",
  },
  "file_md5",
  { data_type => "text", is_nullable => 0 },
  "current_rating",
  { data_type => "real", default_value => 0, is_nullable => 0 },
  "votes_made",
  { data_type => "integer", default_value => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("file_rating_summary_file_md5_key", ["file_md5"]);

=head1 RELATIONS

=head2 files

Type: has_many

Related object: L<Cleavages::Schema::Result::File>

=cut

__PACKAGE__->has_many(
  "files",
  "Cleavages::Schema::Result::File",
  { "foreign.rating_summary" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-04-04 18:08:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CkX0PyLMlwZD7VtrRC0dZg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
