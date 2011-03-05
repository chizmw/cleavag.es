package Cleavages::Controller::User;
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;
use parent 'Catalyst::Controller';

use Cleavages::DFV qw< :constraints >;
use Digest::MD5 qw< md5_hex >;
use Data::FormValidator::Constraints qw(:closures);

use base 'Catalyst::Controller::reCAPTCHA';
use base 'Catalyst::Controller::Validation::DFV';
use base 'Cleavages::ControllerBase::FormValidation';

my %dfv_profile_for = (
    login => {
        required => [qw<
            username
            password
        >],

        filters => 'trim',
    },

    signup => {
        required => [qw<
            new_first_name
            new_last_name
            new_username
            new_email_address
            new_password
            new_password_confirm
        >],

        constraint_methods => {
            new_email_address   => email(),

            new_password_confirm =>
                constraint_confirm_equal(
                    { fields => [qw/new_password new_password_confirm/] },
                    'passwords-do-not-match',
                ),
        },

        filters => 'trim',
    },
);


sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Cleavages::Controller::User in User.');
}

sub base : Chained('/language') PathPart('user') CaptureArgs(0) { 
}

sub login : Chained('base') PathPart('login') Args(0) {
    my ($self, $c) = @_;

    # logged-in? no need to login again...
    if ($c->is_logged_in()) {
        $c->detach('/app_root');
    }

    # a reason why we're here?
    $c->stash->{login_reason} =
        delete $c->session->{login_reason};

    # store somewhere to go after login (if we don't already have somewhere to
    # go)
    $c->session->{after_login} ||= (
           $c->request->referer()
        || $c->uri_for( $c->config->{default_uri} )
    );
    $c->log->debug( 'After Login We Will Go To: ' . $c->session->{after_login} );

    # deal with form submissions
    if (
        defined $c->request->method()
            and $c->request->method() eq 'POST'
    ) {
        $c->forward('form_check', [$dfv_profile_for{login}]);

        if ($c->stash->{validation}->success) {
            my $login_ok = $c->authenticate(
                {
                    username => $c->request->body_parameters->{username},
                    password => $c->request->body_parameters->{password},
                    status => [ 'registered', 'loggedin', 'active']
                }
            );

            if ($login_ok) {
                # send them back to where they came from
                if ($c->session->{after_login}) {
                    $c->response->redirect(
                        delete($c->session->{after_login})
                    );
                    $c->detach;
                }

                # otherwise just show the default page
                $c->detach('/app_root');
            }
        }
    }

    #$c->forward('signup');
    $c->stash->{template} = q{user/signup};

    return;
}

sub logout : Chained('base') PathPart('logout') Args(0) {
    my ($self, $c) = @_;

    # session logout, and remove information we've stashed
    $c->logout;
    #delete $c->session->{'authed_user'};
    #$c->set_authed_user( undef );

    # redisplay the page we were on, or just do the 'default' action
    my $base    = $c->request->base();
    my $action  = $c->action();

    # redirect to where we were referred from, unless our referer is our action
    if ( $c->request->referer() =~ m{\A$base}xms and $c->request->referer() !~ m{$action\z}xms) {
        $c->response->redirect( $c->request->referer() );
        return;
    }
    else {
        #$c->response->redirect( $c->uri_for($c->config()->{default_uri}) );
        $c->detach('/app_root');
    }

    return;
}


sub signup : Local {
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

sub user_signup :Private {
    my ($self, $c) = @_;

    # check the form for errors
    $c->forward('form_check', [$dfv_profile_for{signup}]);

    # if the captcha is enabled
    if ($c->config->{recaptcha}{enabled}) {
        # check the captcha
        $c->forward('captcha_check');
        # deal with any errors
        if ($c->stash->{recaptcha_error}) {
            # add to form validation failures
            $c->forward(
                'add_form_invalid',
                [ 'recaptcha', $c->stash->{recaptcha_error} ]
            );
        }
    }

    # check to see if the username has already been used
    $c->forward('check_unique_username', ['new_username']);

    # if we didn't have any errors, create the new account
    if ($c->stash->{validation}->success) {
        # add the new user in a transaction
        eval {
            #$c->stash->{schema}->txn_do(
            my $schema = $c->model('Cleavages::Person')->result_source->schema;
            $schema->txn_do(
                sub { $self->_txn_add_user($c) }
            );
        };
        # deal with any errors
        if ($@) {                                   # Transacrion failed
            die "something terrible has happened!"  #
                if ($@ =~ m{Rollback failed});      # Rollback failed

            # publish the txn error
            my $error = $@;
            $error =~ s/(?:called\s+)?at\s+.+?line\s+\d+/__FILEINFO__/xmsg;
            $c->log->error( $error );
            $c->stash->{error}{message} =
                qq{Database transaction failed: $error};
            return;
        }

        $c->response->redirect( $c->uri_for($c->config->{default_uri}) );
        return;
    }

    return;
}

sub _txn_add_user {
    my ($self, $c) = @_;
    my $results = $c->stash->{validation};

    # create the new user
    my $new_auth = $c->model('Cleavages::Person')
        ->create(
            {
                username            => $results->valid('new_username'),
                password            => md5_hex($results->valid('new_password')),
                first_name          => $results->valid('new_first_name'),
                last_name           => $results->valid('new_last_name'),
                email               => $results->valid('new_email_address'),
            }
        )
    ;
    return;
}

1;
__END__

=head1 NAME

Cleavages::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 index 

=head1 AUTHOR

Chisel Wright

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
