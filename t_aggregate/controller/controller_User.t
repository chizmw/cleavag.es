use strict;
use warnings;
use Test::More tests => 6;

BEGIN { use_ok 'Catalyst::Test', 'Cleavages' }
BEGIN { use_ok 'Cleavages::Controller::User' }

ok( request('/user')->is_success, 'Request should succeed' );


ok( request('/user/login')->is_success,     '/user/login should succeed' );
ok( request('/user/logout')->is_redirect,   '/user/logout should redirect' );
ok( request('/user/signup')->is_success,    '/user/signup should succeed' );
