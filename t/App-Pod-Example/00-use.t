# Pragmas.
use strict;
use warnings;

# Modules.
use Test::More 'tests' => 2;

BEGIN {

	# Test.
	use_ok('App::Pod::Example');
}

# Test.
require_ok('App::Pod::Example');