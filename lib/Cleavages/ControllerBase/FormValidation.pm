package Cleavages::ControllerBase::FormValidation;
# vim: ts=8 sts=4 et sw=4 sr sta
use Moose;

BEGIN { extends 'Catalyst::Controller'; }

sub check_unique_username :Private {
    my ($self, $c, $username_field) = @_;
    my ($count);

    # if we haven't checked the form yet, we can't add to the results
    if (not defined $c->stash->{validation}) {
        carp('form must be validated first');
        return;
    }

    # see how many matches we have for the value in the (supplied) username
    # field
    $count = $c->model('Cleavages::Person')->count(
        { username => $c->stash->{validation}->valid($username_field) || undef }
    );

    # set a validation error if we've already got one
    if ($count > 0) {
        $c->forward(
            'add_form_invalid',
            [ $username_field, q{username-not-unique} ]
        );
    }

    return;
}

1;
__END__
