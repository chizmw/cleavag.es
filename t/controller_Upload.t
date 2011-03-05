use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Cleavages' }
BEGIN { use_ok 'Cleavages::Controller::Upload' }

ok( request('/upload')->is_success, 'Request should succeed' );


