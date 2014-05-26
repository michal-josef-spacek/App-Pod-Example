# Pragmas.
use strict;
use warnings;

# Modules.
use App::Pod::Example;
use English qw(-no_match_vars);
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 6;
use Test::NoWarnings;

# Test.
eval {
	App::Pod::Example->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n", 'Bad parameter \'\'.');
clean();

# Test.
eval {
	App::Pod::Example->new(
		'something' => 'value',
	);
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n",
	'Bad parameter \'something\'.');
clean();

# Test.
eval {
	App::Pod::Example->new(
		'print' => 0,
		'run' => 0,
	);
};
is($EVAL_ERROR, "Cannot process any action.\n", 'No action.');
clean();

# Test.
my $obj = App::Pod::Example->new(
	'print' => 1,
	'run' => 0,
);
isa_ok($obj, 'App::Pod::Example');

# Test.
$obj = App::Pod::Example->new;
isa_ok($obj, 'App::Pod::Example');
