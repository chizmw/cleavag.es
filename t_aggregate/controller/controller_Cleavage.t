use strict;
use warnings;
use Test::More tests => 8;

BEGIN { use_ok 'Catalyst::Test', 'Cleavages' }
BEGIN { use_ok 'Cleavages::Controller::Cleavage' }

ok( request('/cleavage')->is_success,           '/cleavage should succeed' );

ok( request('/cleavage/none')->is_success,      '/cleavage/none should succeed' );
ok( request('/cleavage/random')->is_success,    '/cleavage/random should succeed' );
ok( request('/cleavage/rate')->is_success,      '/cleavage/rate should succeed' );
ok( request('/cleavage/top')->is_success,       '/cleavage/top should succeed' );

# as we're not [yet] logged in, this should redirect
ok( request('/cleavage/upload')->is_redirect,   '/cleavage/upload should redirect' );
