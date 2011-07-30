# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Base class for pod_example script.';
author 'Michal Špaček <skim@cpan.org>';
install_script 'bin/pod_example';
license 'bsd';
name 'App-Pod-Example';
requires 'Class::Utils' => 0.01;
requires 'English' => 0;
requires 'Error::Pure' => 0.01;
requires 'Pod::Example' => 0.01;
requires 'Readonly' => 0;
resources 'repository' => {
	'url' => 'git://github.com/tupinek/App-Pod-Example',
	'web' => 'https://github.com/tupinek/App-Pod-Example',
	'type' => 'git',
};
test_requires 'English' => 0;
test_requires 'File::Object' => 0.01;
test_requires 'Test::More' => 0;
test_requires 'Test::Output' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.02';

# Run.
WriteAll();
