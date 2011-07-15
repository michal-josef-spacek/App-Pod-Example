# Pragmas.
use strict;
use warnings;

# Modules.
use App::Pod::Example;
use Test::More 'tests' => 1;

# Test.
is($App::Pod::Example::VERSION, 0.01, 'Version.');
