#!/usr/bin/perl

BEGIN {
    push (@INC,"../lib/");
}

use strict;
use Data::Dumper;
use OddsConverter;

# Instance by probability
my $Obj1 = OddsConverter->new('probability' => 0.75);
print "For probability [", $Obj1->probability, "]\n";
print "   >>>>> The decimal_odds is >", $Obj1->decimal_odds,  "<\n";
print "   >>>>> The roi          is >", $Obj1->roi,  "<\n";
$Obj1->display_result();
print "*" x 80, "\n";

# Instance by decimal_odds
my $Obj2 = OddsConverter->new('decimal_odds' => 4.3805);
print "For decimal_odds [", $Obj2->decimal_odds, "]\n";
print "   >>>>> The probability is >", $Obj2->probability,  "<\n";
print "   >>>>> The roi         is >", $Obj2->roi,  "<\n";
$Obj2->display_result();
print "*" x 80, "\n";

# Instance by roi
my $Obj3 = OddsConverter->new('roi' => 225);
print "For roi [", $Obj3->roi, "]\n";
print "   >>>>> The probability  is >", $Obj3->probability,  "<\n";
print "   >>>>> The decimal_odds is >", $Obj3->decimal_odds,  "<\n";
$Obj3->display_result();
print "*" x 80, "\n";
