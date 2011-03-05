# IMPORTANT: if you delete this file your app will not work as
# expected.  you have been warned
use inc::Module::Install;

name        'Cleavages';
version     '0.0.11';
all_from    'lib/Cleavages.pm';

requires 'Catalyst::Runtime' => '5.7015';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'parent';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats

requires (
    'Catalyst::Plugin::Authentication'              => '0.100091',
    'Catalyst::Plugin::ConfigLoader'                => 0,
    'Catalyst::Plugin::FillInForm'                  => 0,
    'Catalyst::Plugin::Images'                      => 0,
    'Catalyst::Plugin::I18N'                        => 0,
    'Catalyst::Plugin::Session'                     => 0,
    'Catalyst::Plugin::Session::State::Cookie'      => 0,
    'Catalyst::Plugin::Session::Store::FastMmap'    => 0,
    'Catalyst::Plugin::StackTrace'                  => 0,
    'Catalyst::Plugin::Static::Simple'              => 0,
    'Catalyst::Plugin::Upload::Digest'              => '0.02',
    'Catalyst::Plugin::Upload::Image::Magick'       => 0,
    'Catalyst::Plugin::Upload::MIME'                => '0.01',

    'Catalyst::Authentication::Store::DBIx::Class'  => 0,
    'Catalyst::Controller::reCAPTCHA'               => 0,
    'Catalyst::Controller::Validation::DFV'         => '0.0.2',
    'Catalyst::Log::Log4perl'                       => 0,
    'Catalyst::Model::DBIC::Schema'                 => 0,
    'Catalyst::Model::File'                         => 0,
    'Catalyst::View::TT'                            => 0,
    'DBIx::Class'                                   => 0,
    'Data::FormValidator::Constraints'              => 0,
    'Digest::MD5'                                   => 0,
    'Path::Class'                                   => 0,
    'Perl6::Export::Attrs'                          => 0,
    'Template::Plugin::Gravatar'                    => 0,
    'version'                                       => 0,
);

build_requires (
    'Test::Aggregate'                               => 0,
    'Test::More'                                    => 0,
    'File::MimeInfo::Magic'                         => 0,
    'Test::DBIx::Class::Schema'                     => 0,
);

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
