#!/usr/bin/env perl

# Pragmas.
use strict;
use warnings;

# Modules.
use App::Pod::Example;

# Run.
App::Pod::Example->new(
        'print' => 1,
        'run' => 1,
)->run('Pod::Example');