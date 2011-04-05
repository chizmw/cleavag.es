package Cleavages::DFV;
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;

use Perl6::Export::Attrs;

sub constraint_confirm_equal :Export( :constraints ) {
    my ($attrs, $constraint_name) = @_;
    my ($first, $second);

    if ($attrs->{fields}) {
        ($first, $second) = @{ $attrs->{fields} };
    }

    return sub {
        my $dfv = shift;
        $dfv->name_this($constraint_name || 'constraint_confirm_equal');
        my $data = $dfv->get_filtered_data();

        return ( $data->{$first} eq $data->{$second} );
    }
}

sub constraint_in_range :Export( :constraints ) {
    my ($attrs, $constraint_name) = @_;
    my ($first, $second);

    if ($attrs->{fields}) {
        ($first, $second) = @{ $attrs->{fields} };
    }

    return sub {
        my $dfv = shift;
        warn "constraint_in_range()";
        $dfv->name_this($constraint_name || 'constraint_in_range');
        my $data = $dfv->get_filtered_data();
        my $rating = $data->{cleavage_rating};

        if (not defined $rating) {
            return;
        }

        return (
            ($rating >= $first)
                and
            ($rating <= $second)
        );
    }
}

1;
__END__
