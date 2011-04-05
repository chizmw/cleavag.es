package Cleavages::Controller::Upload;
use Moose;
    extends 'Catalyst::Controller::Validation::DFV',
            'Cleavages::ControllerBase::FormValidation';
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

my %dfv_profile_for = (
    cleavage => {
        required => [qw<
            cleavage_type
            cleavage_relation
            gender
            verified_permission
        >],

        optional => [qw<
            remain_anonymous
            attribution_url
        >],

        filters => 'trim',
    },
);

sub upload_base : Chained('/language') PathPart('upload') CaptureArgs(0) {
    my ($self, $c) = @_;
    return;
}

sub cleavage : Chained('upload_base') PathPart('cleavage') Args(0) {
    my ( $self, $c ) = @_;

    # as we can be the 'victim' of a forward() we specify the template
    $c->stash->{template} = 'upload/cleavage';

    # send away intruders!
    if ( not $c->user ) {
        # set the post login page to be back here
        $c->session->{after_login} = $c->uri_for( $c->action );
        # give them a reason
        $c->session->{login_reason} = q{LOGIN TO UPLOAD};
        # throw the user at the login page
        $c->response->redirect( $c->uri_for('/user/login') );
        $c->detach;
    }

    if (
        $c->request->method eq 'POST'
            and
        $c->request->uploads
    ) {
        $c->forward('form_check', [$dfv_profile_for{cleavage}]);

        # if all's well with the form submission
        if ($c->stash->{validation}->success) {
            $c->log->debug(
                keys %{$c->request->uploads}
            );

            # get the uploaded file [information] and make sure we have
            # something to work with
            my $cleavage_upload = $c->request->uploads->{cleavage_file};
            if (not defined $cleavage_upload) {
                $c->forward(
                    'add_form_invalid',
                    ['cleavage_file', 'cleavage-file-missing']
                );
                return;
            }

            # get information about the uploaded file
            my $file_info = $c->forward('_file_info', [$cleavage_upload]);

            # make sure we only accept certain filetypes
            my @allowed_mimetypes = qw<
                image/jpeg
                image/gif
                image/png
            >;
            my $mt = $cleavage_upload->mimetype;
            if (not grep { m{^$mt$}xms } @allowed_mimetypes) {
                $c->forward(
                    'add_form_invalid',
                    ['cleavage_file', 'cleavage-wrong-mimetype']
                );
                return;
            }

            # make sure the image isn't "too big"
            if ($cleavage_upload->is_image) {
                my $max_side = $c->config->{image_longest_side} || 640;
                $c->log->debug(" width : " . $cleavage_upload->width);
                $c->log->debug("height : " . $cleavage_upload->height);
                if (
                    ($cleavage_upload->width > $max_side)
                        or
                    ($cleavage_upload->height > $max_side)
                ) {
                    $c->forward(
                        'add_form_invalid',
                        ['cleavage_file', 'image-too-large']
                    );
                    return;
                }
            }


            # store the file locally
            $c->model('FS::Cleavage')->splat(
                $file_info->{filepath},
                $cleavage_upload->slurp,
            );

            # do some thumbnail prep
            my $thumbnail = $cleavage_upload->thumbnail(
                {
                    density => '120x120',
                    format => $cleavage_upload->extension,
                    quality => 100
                }
            );
            # store the thumbnail locally
            $c->model('FS::Cleavage')->splat(
                $file_info->{thumbnail},
                $thumbnail->ImageToBlob($cleavage_upload->extension),
            );

            $c->log->info( ref $thumbnail );

            # store the file information in the database
            # add the new event in a transaction
            my $new_file;
            eval {
                my $schema = $c->model('Cleavages::File')->result_source->schema;
                $schema->txn_do(
                    sub { $new_file = $c->forward('_txn_add_file', [$file_info]) }
                );
            };
            # deal with any errors
            if ($@) { # Transaction failed
                die "TRANSACTION FAILED: $@";
            }

            # redirect the user to the file they just uploaded
            # XXX alter this later when we know what to do
            $c->response->redirect(
                $c->uri_for(
                    qq{/cleavage/rate/$file_info->{file_md5}}
                )
            );
            return;
        }
        # otherwise DFV voodoo kicks in
    }

    return;
}

sub _file_info : Private{
    my ($self, $c, $uploaded_file) = @_;
    my %file_info;

    # mess about to get a filename for local storage
    # grab the file
    my $file = $uploaded_file->slurp;

    # get a digest for the file
    $file_info{file_md5} = $uploaded_file->digest( 'MD5' )->hexdigest;

    # split for a a/ab/abc path based on the file name
    my @dir_path = ($file_info{file_md5} =~ m{\A(((.).).)});

    # give the uploaded file a name
    $file_info{filename} = $file_info{file_md5} . q{.} . $uploaded_file->extension;

    # and have the full path to the file
    $file_info{filepath} = Path::Class::File->new(
        reverse(@dir_path),
        $file_info{filename}
    );

    # and have the full path to the file
    $file_info{thumbnail} = Path::Class::File->new(
        'thumb',
        reverse(@dir_path),
        $file_info{filename}
    );

    # store the upload object so we can pass it around
    $file_info{upload} = $uploaded_file;

    return \%file_info;
}

__PACKAGE__->meta->make_immutable;

1;
