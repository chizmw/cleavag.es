package Cleavages;
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;

use Cleavages::Version;  our $VERSION = $Cleavages::VERSION;

use Catalyst::Runtime '5.70';
use Catalyst::Log::Log4perl;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root 
#                 directory

use parent qw/Catalyst/;
use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    StackTrace
    I18N
    FillInForm

    Session
    Session::Store::DBIC
    Session::State::Cookie

    Authentication

    Upload::Image::Magick
    Upload::Image::Magick::Thumbnail
    Upload::Digest
    Upload::MIME
    Images
/;

#our $VERSION = '0.01';
VERSION_MADNESS: {
    use version;
    my $vstring = version->new($VERSION)->normal;
    __PACKAGE__->config(
        version => $vstring
    );
}


# Configure the application. 
#
# Note that settings in cleavages.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with a external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( name => 'Cleavages' );

# Start the application
__PACKAGE__->setup();

# use log4perl
__PACKAGE__->log(
    Catalyst::Log::Log4perl->new(
        __PACKAGE__->config->{log4perl_conf}
    )
);

# a helper to localise text
sub i18nise {
    my ($c, $msgid, $msgargs) = @_;
$c->log->info( join '', @{ $c->languages } );
$c->log->info( $c->localize("DummyString") );


    return $c->localize(
        $msgid,
        $msgargs
    );
}

# do we have a logged-in user?
sub is_logged_in {
    my ($c) = @_;

    if ($c->user) {
        return 1;
    }
    return 0;
}


=head1 NAME

Cleavages - Catalyst based application

=head1 SYNOPSIS

    script/cleavages_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Cleavages::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Chisel Wright,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
