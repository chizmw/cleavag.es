use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Cleavages' }
BEGIN { use_ok 'Cleavages::Controller::Cleavage' }

ok( request('/cleavage')->is_success, 'Request should succeed' );


