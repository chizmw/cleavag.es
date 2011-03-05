package Cleavages;
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;

# derived from mst suggestion on #catalyst
use version; our $VERSION = qv(0.0.9)->numify;

package Cleavages::Version;

our $VERSION = $Cleavages::VERSION;

1;


=head1 NAME

Cleavages::Version - The Cleavages project-wide version number

=head1 SYNOPSIS

    package Cleavages::Whatever;

    # Must be on one line so MakeMaker can parse it.
    use Cleavages::Version;  our $VERSION = $Cleavages::VERSION;

=head1 DESCRIPTION

Because of the problems coordinating revision numbers in a distributed
version control system and across a directory full of Perl modules, this
module provides a central location for the project's release number.

=head1 IDEA FROM

This idea was taken from L<SVK>

=cut

1;
