package Cleavages::Controller::User;
use Moose;
    extends 'Catalyst::Controller::reCAPTCHA',
            'Catalyst::Controller::Validation::DFV',
            'Cleavages::ControllerBase::FormValidation';
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

# for password hashing
# TODO: check and see if we still need this with newer plugins/DBIC
use Digest::MD5 qw< md5_hex >;

# form validation modules
use Cleavages::DFV qw(:constraints);
use Data::FormValidator::Constraints qw(:closures);
# form validation data
our %dfv_profile_for = (
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
            new_email_address => email(),

            new_password_confirm =>
                constraint_confirm_equal(
                    { fields => [qw/new_password new_password_confirm/] },
                    'passwords-do-not-match',
                ),
        },

        filters => 'trim',
    },
);

sub user_base : Chained('/language') PathPart('user') CaptureArgs(0) {
    # do nothing for now
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Cleavages::Controller::User in User.');
}

# display the signup page
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

# process a signup request
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
            my $schema = $c->model('Cleavages::Person')->result_source->schema;
            $schema->txn_do(
                sub { $self->_txn_add_user($c) }
            );
        };
        # deal with any errors
        if ($@) { # Transaction failed
            die "something terrible has happened!" #
                if ($@ =~ m{Rollback failed}); # Rollback failed

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
        ->create({
            username    => $results->valid('new_username'),
            password    => md5_hex($results->valid('new_password')),
            first_name  => $results->valid('new_first_name'),
            last_name   => $results->valid('new_last_name'),
            email       => $results->valid('new_email_address'),
        })
    ;
    return;
}


__PACKAGE__->meta->make_immutable;

1;
