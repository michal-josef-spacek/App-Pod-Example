# Pragmas.
use strict;
use warnings;

# Modules.
use App::Pod::Example;
use English qw(-no_match_vars);
use File::Object;
use Test::More 'tests' => 13;
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
Cannot process example right, because die.
END
stdout_is(
	sub {
		eval {
			$obj->run($modules_dir->file('Ex2.pm')->s);
		};
		print $EVAL_ERROR;
		return;
	},
	$right_ret,
	'Example with die().',
);

# Test.
$right_ret = <<'END';
#-------------------------------------------------------------------------------
# Example output
#-------------------------------------------------------------------------------
Cannot process example right, because die.
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex3.pm')->s);
		return;
	},
	$right_ret,
	'Example with Carp::croak().',
);

# Test.
$right_ret = <<'END';
#-------------------------------------------------------------------------------
# Example output
#-------------------------------------------------------------------------------
Cannot process example right, because die.
END
stdout_is(
	sub {
		$obj->run($modules_dir->file('Ex4.pm')->s);
		return;
	},
	$right_ret,
	'Example with Error::Pure::Die::err().',
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
