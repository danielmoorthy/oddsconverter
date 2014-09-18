package OddsConverter;

use strict;
use Carp;
use POSIX;
use Data::Dumper;

=head1 NAME

OddsConverter

=head1 SYNOPSIS

    my $oc = OddsConverter->new(probability => 0.5);
    print $oc->decimal_odds;    # '2.00' (always to 2 decimal places)
    print $oc->roi;             # '100%' (always whole numbers or 'Inf.')
    $oc->display_result;        # Displays the OddsConverter results to stdout

=cut

=head1 DESCRIPTION

Favoured in continental Europe, Australia, New Zealand and Canada, decimal odds differ from fractional odds in that the bettor must first part with their stake in order to make a bet, the figure quoted is the winning amount that would be paid out to the bettor. Therefore, the decimal odds of an outcome are equivalent to the decimal value of the fractional odds plus one. Thus even odds 1/1 are quoted in decimal odds as 2. The 4/1 fractional odds discussed above are quoted as 5, while the 1/4 odds are quoted as 1.25. This is considered to be ideal for parlay betting, because the odds to be paid out are simply the product of the odds for each outcome wagered on. Decimal odds are also favoured by betting exchanges because they are the easiest to work with for trading.

Decimal odds are also known as European odds, or continental odds in the UK.

=cut


# Some Class Constants
$OddsConverter::MIN_PROBABILITY = 0;
$OddsConverter::MAX_PROBABILITY = 1;
$OddsConverter::MIN_DECIMAL_ODDS = 1;
$OddsConverter::MIN_ROI = 0;

=head1 FUNCTIONS

=over

=item B<new()>

=over

Create a new instance of OddsConverter

=back

=over

=item B<Instance arguments>

NOTE: Specify any one of the below arguments.

=over

=item I<probability>  =E<gt> values between 0 to 1

=item I<decimal_odds> =E<gt> values greater than 0

=item I<roi>          =E<gt> values greater than 0

=back

Example:
 
  my $oc = OddsConverter->new( 'probability' => 0.2 );
  my $oc = OddsConverter->new( 'decimal_odds' => 15.35 );
  my $oc = OddsConverter->new( 'roi' => 325 );

=back

=back

=over

=item B<display_result()>

=over

Displays the output of OddsConverter result to STDOUT

=back

=over

Example:

  $oc->display_result();

=back

=over 

Console Output:

==================================================
             Odds Converter Results

==================================================

   Probability  => 0.20
   Decimal Odds => 5.00
   ROI          => 400%
==================================================

=back

=back

=cut

sub new
{
   my ($proto, %inhash) = @_;
   my ($self,  $class);

   $class = ref($proto) || $proto;
   $self  = {};
   bless($self, $class);

   $self->_initialise(%inhash);

   return $self;
}

sub _initialise
{
   my ($self, %inhash) = @_;

   if (exists($inhash{'probability'})) {
      $self->{'probability'} = $inhash{'probability'};
      return $self->_invoke_probability();
   } elsif (exists($inhash{'decimal_odds'})) {
      $self->{'decimal_odds'} = $inhash{'decimal_odds'};
      return $self->_invoke_decimal_odds();
   } elsif (exists($inhash{'roi'})) {
      $self->{'roi'} = $inhash{'roi'};
      return $self->_invoke_roi();
   }
}

sub AUTOLOAD
{
   my $self = shift;

   my ($fname) = our $AUTOLOAD =~ /::(\w+)$/;

   return $self->_format_probability()  if ($fname eq 'probability');
   return $self->_format_decimal_odds() if ($fname eq 'decimal_odds');
   return $self->_format_roi()          if ($fname eq 'roi');
}

sub display_result
{
   my $self = shift;

   print "=" x 50, "\n";
   print "             Odds Converter Results\n";
   print "=" x 50, "\n";
   print "   Probability  => ", $self->probability, "\n";
   print "   Decimal Odds => ", $self->decimal_odds, "\n";
   print "   ROI          => ", $self->roi, "\n";
   print "=" x 50, "\n";

   return;
}

sub _format_decimal_odds
{
   my $self = shift;

   if ($self->{'decimal_odds'}  =~ /^[0-9]*\.?[0-9]*$/) {
      $self->{'decimal_odds'} = sprintf("%.2f", $self->{'decimal_odds'});
   }
   return $self->{'decimal_odds'};
}

sub _format_probability
{
   my $self = shift;

   if ($self->{'probability'} =~ /^[0-9]*\.?[0-9]*$/) {
       $self->{'probability'} = sprintf("%.2f",$self->{'probability'});
   }
   return $self->{'probability'};
}

sub _format_roi
{
   my $self = shift;

   if ($self->{'roi'} =~ /^[0-9]*\.?[0-9]*$/) {
       $self->{'roi'} = ceil($self->{'roi'}) . '%';
   }
   return $self->{'roi'};
}

sub _invoke_decimal_odds
{
   my $self = shift;

   ## Input Validation
   if ($self->{'decimal_odds'} !~ /^[0-9]*\.?[0-9]*$/) {
      croak " No non-numeric decimal odds";
   } elsif ($self->{'decimal_odds'} < $OddsConverter::MIN_DECIMAL_ODDS) {
      croak "No decimal odds should be < $OddsConverter::MIN_DECIMAL_ODDS";
   }

   $self->{'decimal_odds_oper'} = $self->{'decimal_odds'};

   ## Business Logic
   $self->{'probability'} = $OddsConverter::MAX_PROBABILITY/$self->{'decimal_odds_oper'};
   $self->{'roi'}         = ($self->{'decimal_odds_oper'} - 1) * 100;
}

sub _invoke_roi
{
   my $self = shift;

   ## Input Validation
   if ($self->{'roi'} !~ /^[0-9]*\.?[0-9]*$/) {
      croak " No non-numeric rois";
   } elsif ($self->{'roi'} < $OddsConverter::MIN_ROI) {
      croak "No negative rois";
   }

   $self->{'roi_oper'} = $self->{'roi'};

   ## Business Logic
   $self->{'decimal_odds'} = ($self->{'roi_oper'}/100) + 1;
   $self->{'probability'}  = $OddsConverter::MAX_PROBABILITY/$self->{'decimal_odds'};
}

sub _invoke_probability
{
   my $self = shift;

   ## Input Validation
   if ($self->{'probability'} !~ /^[0-9]*\.?[0-9]*$/) {
      croak " No non-numeric probabilities";
   } elsif ($self->{'probability'} < $OddsConverter::MIN_PROBABILITY) {
      croak "No negative probabilities";
   } elsif ($self->{'probability'} > $OddsConverter::MAX_PROBABILITY) {
      croak "No probabilities > $OddsConverter::MAX_PROBABILITY";
   }

   $self->{'probability_oper'} = $self->{'probability'};

   ## Business Logic
   if ($self->{'probability_oper'} == $OddsConverter::MIN_PROBABILITY) {
      $self->{'decimal_odds'} = 'Inf.';
      $self->{'roi'}          = 'Inf.';
   } elsif ($self->{'probability_oper'} == $OddsConverter::MAX_PROBABILITY) {
      $self->{'decimal_odds'} = 1;
      $self->{'roi'}          = 0;
   } else {
      $self->{'decimal_odds'} = ($OddsConverter::MAX_PROBABILITY/$self->{'probability_oper'});
      $self->{'roi'}          = ($self->{'decimal_odds'} - 1) * 100;
   }
}

=head1 COPYRIGHT AND LICENSE

Some Copyright information here.
=cut

1;
