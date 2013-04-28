#!/usr/bin/env perl

# Pragmas.
use strict;
use warnings;

# Modules.
use App::Pod::Example;

# Run.
App::Pod::Example->new(
        'enumerate' => 1,
        'print' => 1,
        'run' => 1,
)->run('Pod::Example');