package Cleavages::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

extends 'Catalyst::Controller::reCAPTCHA';

sub user_base : Chained('/language') PathPart('user') CaptureArgs(0) {
    # do nothing for now
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Cleavages::Controller::User in User.');
}

sub signup : Chained('user_base') PathPart('signup') Args(0) {
    my ($self, $c) = @_;
    
    # deal with form submissions
    if (
        defined $c->request->method()
            and $c->request->method() eq 'POST'
    ) {
        $c->forward('user_signup');
    }

    # get a reCAPTCHA to use in the form
    if ($c->config->{recaptcha}{enabled}) {
        $c->forward('captcha_get');
    }

    # fall through and show the signup page
    return;
}


__PACKAGE__->meta->make_immutable;

1;
