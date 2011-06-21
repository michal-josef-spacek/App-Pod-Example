package App::Pod::Example;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use English qw(-no_match_vars);
use Error::Pure qw(err);
use Pod::Abstract;

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;
	my $self = bless {}, $class;

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
	my ($self, $file, $section) = @_;
	my $pod_abstract = Pod::Abstract->load_file($file);
	my $code = _get_content($pod_abstract, $section);
	if ($self->{'print'}) {
		print $code."\n";
	}
	if ($self->{'run'}) {
		eval $code;	
		if ($EVAL_ERROR) {
			err 'Error in eval', 'Eval error', $EVAL_ERROR;
		}
	}
	if (! $self->{'print'} && ! $self->{'run'}) {
		err 'Cannot process any action.';
	}
	return;
}

sub _get_content {
	my ($pod_abstract, $section) = @_;
	my @sections = $pod_abstract->select('/head1[@heading =~ {'.
		$section.'\d*}]');
	my $ret;
	foreach my $section (@sections) {

		# Remove #cut.
		my @cut = $section->select("//#cut");
		foreach my $cut (@cut) {
			$cut->detach;
		}

		# Get pod.
		# XXX
		$ret .= $section->pod;
	}
	return $ret;
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
 $app->run($file, $section);

=head1 METHODS

=over 8

=item C<new(%parameters)>

 Constructor.

=over 8

=item * C<interactive>

 TODO
 Default value is 0.

=item * C<print>

 TODO
 Default value is 0.

=item * C<run>

 TODO
 Default value is 1.

=back

=item C<run($file, $section)>

TODO

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
 App::Pod::Example->new->run();

=head1 DEPENDENCIES

L<Class::Utils(3pm)>,
L<English(3pm)>,
L<Error::Pure(3pm)>,
L<Pod::Abstract(3pm)>.

=head1 SEE ALSO

TODO

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
