package Cleavages::ResultSet::File;
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

sub add_rating {
    my ($resultset, $argref) = @_;
    my $schema = $resultset->result_source()->schema();

    # get the file
    my $file = $resultset->find(
        { md5_hex   => $argref->{file} },
        { key       => 'file_md5_hex_key' },
    );

    # don't do anything if we can't find the file
    if (not $file) {
        warn "$argref->{file}: no such file; can't add rating ($argref->{rating})";
        return;
    }

    # get the file's summary record
    my $summary = $file->rating_summary;

    # add our latest vote
    $schema->resultset('FileRating')->create(
        {
            file_id             => $file->id,
            rating              => $argref->{rating},
            ip_addr             => $argref->{ip_addr},
            #rated_by => 1, # XXX
        }
    );

    # if we don't have a summary, create one with the current rating and ONE
    # count
    if (not defined $summary) {
        # create the new related record
        my $rating_summary = $file->create_related(
            rating_summary => {
                id              => \'DEFAULT',
                file_md5        => $file->md5_hex,
                current_rating  => $argref->{rating},
                votes_made      => 1,
            }
        );
        # store the id of the new record 
        # XXX do we really need to do this?!
        $file->update(
            {
                rating_summary => $rating_summary->id,
            }
        );
    }

    # we do have a summary; use some maffs to update the current_rating
    else {
        # calculate the new values
        my $rs = $schema->resultset('FileRating')->search(
            {
                file_id         => $file->id,
            },
            {
                select => [ {AVG => 'rating'} , { COUNT => 'rating' } ],
                as     => [qw/ average count /],
            }
        );
        # get teh (first and only) record
        my $new_summary = $rs->first;

        # update the summary
        $summary->update(
            {
                current_rating  => $new_summary->get_column('average'),
                votes_made      => $new_summary->get_column('count'),
            }
        );
    }

    return;
}

sub most_recent {
    my ($resultset) = @_;

    my $most_recent = $resultset->search(
        {},
        {
            order_by    => 'uploaded DESC',
            rows        => 1,
        }
    )->first();

    return $most_recent;
}

sub random_file {
    my ($resultset) = @_;

    my $random = $resultset->search(
        {},
        {
            order_by    => \'RANDOM()',
            rows        => 1,
        },
    )->first;

    return $random;
}

sub top_rated {
    my ($resultset) = @_;

    return $resultset->search(
        {},
        {
            join        => qw< rating_summary >,
            order_by    => 'rating_summary.current_rating DESC',
            rows        => 1,
        },
    )->first;
}

1;
