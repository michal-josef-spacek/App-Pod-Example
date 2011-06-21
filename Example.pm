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

	# Print.
	$self->{'print'} = undef;

	# Run.
	$self->{'run'} = 1;

	# Interactive.
	$self->{'int'} = 0;

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
	if ($self->{'run'}) {
		eval $code;	
		if ($EVAL_ERROR) {
			err 'Error in eval', 'Eval error', $EVAL_ERROR;
		}
	} elsif ($self->{'print'}) {
		print $code."\n";
	} else {
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
