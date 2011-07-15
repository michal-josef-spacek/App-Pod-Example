# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use App::Pod::Example;
use Test::More 'tests' => 4;

# Test.
eval {
	App::Pod::Example->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n", 'Bad parameter \'\'.');

# Test.
eval {
	App::Pod::Example->new(
		'something' => 'value',
	);
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n",
	'Bad parameter \'something\'.');

# Test.
eval {
	App::Pod::Example->new(
		'print' => 0,
		'run' => 0,
	);
};
is($EVAL_ERROR, "Cannot process any action.\n", 'No action.');

# Test.
my $obj = App::Pod::Example->new;
isa_ok($obj, 'App::Pod::Example');
