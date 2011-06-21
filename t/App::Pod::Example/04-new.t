# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use App::Pod::Example;
use Test::More 'tests' => 3;

# Test.
eval {
	App::Pod::Example->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

# Test.
eval {
	App::Pod::Example->new(
		'something' => 'value',
	);
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

# Test.
my $obj = App::Pod::Example->new;
isa_ok($obj, 'App::Pod::Example');
