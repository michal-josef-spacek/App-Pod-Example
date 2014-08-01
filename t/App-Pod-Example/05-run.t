# Pragmas.
use strict;
use warnings;

# Modules.
use App::Pod::Example;
use English qw(-no_match_vars);
use File::Object;
use IO::CaptureOutput qw(capture);
use Test::More 'tests' => 19;
use Test::NoWarnings;
use Test::Warn;
use Test::Output;

# Modules dir.
my $modules_dir = File::Object->new->up->dir('modules');

# Test.
my $obj = App::Pod::Example->new(
	'debug' => 0,
);
my $right_ret = <<'END';
Foo.
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex1.pm')->s);
		return;
	},
	$right_ret,
	'Example with simple run().',
);

# Test.
$obj = App::Pod::Example->new;
$right_ret = <<'END';
#-------------------------------------------------------------------------------
# Example output
#-------------------------------------------------------------------------------
Foo.
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex1.pm')->s);
		return;
	},
	$right_ret,
	'Example with simple run().',
);

# Test.
$right_ret = <<'END';
#-------------------------------------------------------------------------------
# Example output
#-------------------------------------------------------------------------------
END
my ($stderr, $stdout);
capture sub {
	$obj->run($modules_dir->file('Ex2.pm')->s);
	return;
} => \$stdout, \$stderr;
is($stdout, $right_ret, 'Header on example with die().');
like($stderr, qr{^Error\. at .* line 6\.$}, 'Example with die().');

# Test.
($stderr, $stdout) = (undef, undef);
capture sub {
	$obj->run($modules_dir->file('Ex3.pm')->s);
	return;
} => \$stdout, \$stderr;
is($stdout, $right_ret, 'Header on example with Carp::croak().');
like($stderr, qr{^Error\. at .* line 9\.$}, 'Example with Carp::croak().');

# Test.
($stderr, $stdout) = (undef, undef);
capture sub {
	$obj->run($modules_dir->file('Ex4.pm')->s);
	return;
} => \$stdout, \$stderr;
is($stdout, $right_ret, 'Header on example with Error::Pure::Die::err().');
like($stderr, qr{^Error\. at .* line 9\.$},
	'Example with Error::Pure::Die::err().');

# Test.
$right_ret = <<'END';
#-------------------------------------------------------------------------------
# Example output
#-------------------------------------------------------------------------------
Foo.
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex5.pm')->s);
		return;
	},
	$right_ret,
	'Example as EXAMPLE1.',
);

# Test.
$right_ret = <<'END';
#-------------------------------------------------------------------------------
# Example output
#-------------------------------------------------------------------------------
Foo.
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex5.pm')->s, 1);
		return;
	},
	$right_ret,
	'Example as EXAMPLE1 with explicit example number.',
);

# Test.
$right_ret = <<'END';
#-------------------------------------------------------------------------------
# Example output
#-------------------------------------------------------------------------------
Bar.
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex5.pm')->s, 2);
		return;
	},
	$right_ret,
	'Example EXAMPLE2 with explicit example number.',
);

# Test.
$right_ret = <<'END';
#-------------------------------------------------------------------------------
# Example output
#-------------------------------------------------------------------------------
Argument #0: 
Argument #1: 
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex6.pm')->s, 'EXAMPLE', undef,
			'Foo');
		return;
	},
	$right_ret,
	'Example Ex6 EXAMPLE with arguments - bad run() calling.',
);

# Test.
$right_ret = <<'END';
#-------------------------------------------------------------------------------
# Example output
#-------------------------------------------------------------------------------
Argument #0: 
Argument #1: 
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex6.pm')->s, 'EXAMPLE', undef,
			[]);
		return;
	},
	$right_ret,
	'Example Ex6 EXAMPLE with arguments - arguments as blank array.',
);

# Test.
$right_ret = <<'END';
#-------------------------------------------------------------------------------
# Example output
#-------------------------------------------------------------------------------
Argument #0: Foo
Argument #1: Bar
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex6.pm')->s, 'EXAMPLE', undef,
			['Foo', 'Bar']);
		return;
	},
	$right_ret,
	'Example Ex6 EXAMPLE with arguments - two arguments.',
);

# Test.
$obj = App::Pod::Example->new(
	'print' => 1,
	'run' => 0,
);
$right_ret = <<'END';
#-------------------------------------------------------------------------------
# Example source
#-------------------------------------------------------------------------------
# Pragmas.
use strict;
use warnings;

# Print foo.
print "Foo.\n";
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex1.pm')->s);
		return;
	},
	$right_ret,
	'Example with simple print().',
);

# Test.
$obj = App::Pod::Example->new(
	'debug' => 0,
	'print' => 1,
	'run' => 0,
);
$right_ret = <<'END';
# Pragmas.
use strict;
use warnings;

# Print foo.
print "Foo.\n";
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex1.pm')->s);
		return;
	},
	$right_ret,
	'Example with simple print() without debug.',
);

# Test.
$right_ret = <<'END';
No code.
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex1.pm')->s, 100);
		return;
	},
	$right_ret,
	'No code.',
);

# Test.
$obj = App::Pod::Example->new(
	'debug' => 0,
	'enumerate' => 1,
	'print' => 1,
	'run' => 0,
);
$right_ret = <<'END';
1: # Pragmas.
2: use strict;
3: use warnings;
4: 
5: # Print foo.
6: print "Foo.\n";
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex1.pm')->s);
		return;
	},
	$right_ret,
	'Example with simple print() without debug and with '.
		'enumerating lines.',
);
