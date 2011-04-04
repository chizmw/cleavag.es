use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Cleavages';
use Cleavages::Controller::Cleavage;

ok( request('/cleavage')->is_success, 'Request should succeed' );
done_testing();
