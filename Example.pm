package App::Pod::Example;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use English qw(-no_match_vars);
use Error::Pure qw(err);
use Module::Info;
use Pod::Abstract;
use Readonly;

# Constants.
Readonly::Scalar my $DASH => q{-};
Readonly::Scalar my $HASH => q{#};
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Debug.
	$self->{'debug'} = 1;

	# Interactive.
	$self->{'interactive'} = 0;

	# Print.
	$self->{'print'} = 0;

	# Run.
	$self->{'run'} = 1;

	# Process params.
	set_params($self, @params);

	# Object.
	return $self;
}

# Run.
sub run {
	my ($self, $file_or_module, $section) = @_;

	# Module file.
	my $file;
	if (-r $file_or_module) {
		$file = $file_or_module;

	# Module.
	} else {
		$file = Module::Info->new_from_module($file_or_module)->file;
	}

	# Get pod.
	my $pod_abstract = Pod::Abstract->load_file($file);

	# Get section pod.
	my ($code) = _get_content($pod_abstract, $section);

	# Print.
	if ($self->{'print'}) {
		if ($self->{'debug'}) {
			_debug('Example source');
		}
		print $code."\n";
	}

	# Run.
	if ($self->{'run'}) {
		if ($self->{'debug'}) {
			_debug('Example output');
		}
		eval $code;	
		if ($EVAL_ERROR) {
			err 'Error in eval', 'Eval error', $EVAL_ERROR;
		}
	}

	# No action.
	if (! $self->{'print'} && ! $self->{'run'}) {
		err 'Cannot process any action.';
	}

	return;
}

sub _debug {
	my $text = shift;
	print $HASH, $DASH x 80, "\n";
	print $HASH, $SPACE, $text."\n";
	print $HASH, $DASH x 80, "\n";
	return;
}

sub _get_content {
	my ($pod_abstract, $section) = @_;
	my @sections = $pod_abstract->select('/head1[@heading =~ {'.
		$section.'\d*}]');
	my @ret;
	foreach my $section (@sections) {

		# Remove #cut.
		my @cut = $section->select("//#cut");
		foreach my $cut (@cut) {
			$cut->detach;
		}

		# Get pod.
		my @child = $section->children;
		push @ret, _remove_spaces($child[0]->pod);
	}
	return @ret;
}

sub _remove_spaces {
	my $string = shift;
	my @lines = split /\n/, $string;

	# Get number of spaces in begin.
	my $max = 0;
	foreach my $line (@lines) {
		if (! length $line) {
			next;
		}
		my $spaces = $line =~ m/^(\ *)/ms;
		if ($max == 0 || length $spaces < $max) {
			$max = length $spaces;
		}
	}

	# Remove spaces.
	if ($max > 0) {
		foreach my $line (@lines) {
			if (! length $line) {
				next;
			}
			$line = substr $line, $max;
		}
	}

	# Return string.
	return join "\n", @lines;
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

=item * C<interactive>

 Interactive flag. If set to 0, then use first example.
 XXX Not used now.
 Default value is 0.

=item * C<print>

 Print flag. It means print of example.
 Default value is 0.

=item * C<run>

 Run flag. It means run of example.
 Default value is 1.

=back

=item C<run($file_or_module, $section)>

 Run method.
 $file_or_module - File with pod doc or perl module.
 $section - Pod section with example.

=back

=head1 ERRORS

 Mine:
         TODO

 From Class::Utils::set_params():
         Unknown parameter '%s'.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use App::Pod::Example;

 # Run.
 # TODO
 App::Pod::Example->new->run;

=head1 DEPENDENCIES

L<Class::Utils(3pm)>,
L<English(3pm)>,
L<Error::Pure(3pm)>,
L<Module::Info(3pm)>,
L<Pod::Abstract(3pm)>,
L<Readonly(3pm)>.

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
