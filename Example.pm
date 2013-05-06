package App::Pod::Example;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use English qw(-no_match_vars);
use Error::Pure qw(err);
use Pod::Example qw(get);
use Readonly;

# Constants.
Readonly::Scalar my $DASH => q{-};
Readonly::Scalar my $HASH => q{#};
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = 0.07;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Debug.
	$self->{'debug'} = 1;

	# Enumerate lines.
	$self->{'enumerate'} = 0;

	# Print.
	$self->{'print'} = 0;

	# Run.
	$self->{'run'} = 1;

	# Process params.
	set_params($self, @params);

	# No action.
	if (! $self->{'print'} && ! $self->{'run'}) {
		err 'Cannot process any action.';
	}

	# Object.
	return $self;
}

# Run.
sub run {
	my ($self, $file_or_module, $section, $number_of_example) = @_;

	# Get example code.
	my $code = get($file_or_module, $section, $number_of_example);

	# No code.
	if (! defined $code) {
		print "No code.\n";
		return;
	}

	# Print.
	if ($self->{'print'}) {
		if ($self->{'debug'}) {
			_debug('Example source');
		}
		if ($self->{'enumerate'}) {
			my @lines = split "\n", $code;
			my $count = 1;
			foreach my $line (@lines) {
				print $count.': '.$line."\n";
				$count++;
			}
		} else {
			print $code."\n";
		}
	}

	# Run.
	if ($self->{'run'}) {
		if ($self->{'debug'}) {
			_debug('Example output');
		}
		eval $code;	
		if ($EVAL_ERROR) {
			print "Cannot process example right, because die.\n";
		}
	}

	return;
}

sub _debug {
	my $text = shift;
	print $HASH, $DASH x 79, "\n";
	print $HASH, $SPACE, $text."\n";
	print $HASH, $DASH x 79, "\n";
	return;
}

1;


__END__

=pod

=encoding utf8

=head1 NAME

App::Pod::Example - Base class for pod_example script.

=head1 SYNOPSIS

 use App::Pod::Example;
 my $app = App::Pod::Example->new(%parameters);
 $app->run($file_or_module, $section);

=head1 METHODS

=over 8

=item C<new(%parameters)>

 Constructor.

=over 8

=item * C<debug>

 Debug flag. It means print debug messages.
 Default value is 1.

=item * C<enumerate>

 Enumerate lines in print output.
 Default value is 0.

=item * C<print>

 Print flag. It means print of example.
 Default value is 0.

=item * C<run>

 Run flag. It means run of example.
 Default value is 1.

=back

=item C<run($file_or_module, $section, $number_of_example)>

 Run method.
 $file_or_module - File with pod doc or perl module.
 $section - Pod section with example. Default value is 'EXAMPLE'.
 $number_of_example - Number of example. Default value is 1.

=back

=head1 ERRORS

 new():
         Cannot process any action.
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE

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

=head1 CAVEATS

Examples with die() cannot process, because returns bad results.

=head1 DEPENDENCIES

L<Class::Utils>,
L<English>,
L<Error::Pure>,
L<Pod::Example>,
L<Readonly>.

=head1 REPOSITORY

L<https://github.com/tupinek/App-Pod-Example>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.07

=cut
