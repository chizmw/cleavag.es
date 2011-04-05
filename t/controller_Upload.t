use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Cleavages';
use Cleavages::Controller::Upload;

ok( request('/upload')->is_success, 'Request should succeed' );
done_testing();
