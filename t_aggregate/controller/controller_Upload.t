use strict;
use warnings;
use Test::More tests => 4;

BEGIN { use_ok 'Catalyst::Test', 'Cleavages' }
BEGIN { use_ok 'Cleavages::Controller::Upload' }

ok( request('/upload')->is_success, 'Request should succeed' );

# as we're not [yet] logged in, this should redirect
ok( request('/upload/cleavage')->is_redirect,   '/cleavage/upload should redirect' );
