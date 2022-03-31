#!/bin/perl

use warnings;
use strict;

use Math::Complex ;

# 0.5141324	-5.605	4.3225824	-158.844	0.0542982	-121.948  0.4245234	95.503

# From datasheet, input match for optimum NF, as a refelction coefficient
my($gammaInput)=cplxe(0.213, rads(-50.857));

# From datasheet, S parameters in mag, angle form, *not* dB angle form!
my($s11) = cplxe(0.51, rads(-5.6));     # Looking into input
my($s21) = cplxe(4.3, rads(-158.8));    # Fwd gain
my($s12) = cplxe(0.054, rads(-121.9));  # reverse gain
my($s22) = cplxe(0.424, rads(95.5));    # Looking into output



# Base impedance, normally 50 ohms, resisitive.
my($z0) = Math::Complex->make(50,0);

my($zIn)= gammaToImpedance($gammaInput,$z0);

$zIn->display_format('cartesian');
print "Input match: $zIn \n";

my($gammaOutput) = ~($s22 + (($s21*$gammaInput*$s12)/(1-$s11*$gammaInput)));
$gammaOutput->display_format('polar');

print "Ouptut gamma: ".$gammaOutput->rho."/".degrees($gammaOutput->theta())." degrees\n";

my($zOut) = gammaToImpedance($gammaOutput,$z0);
$zOut->display_format('cartesian');
print "Output match: $zOut \n";

# Helpers

sub gammaToImpedance{
  my($gamma,$z)=@_;
  return $z*((1+$gamma)/(1-$gamma));
}

sub rads{
  my ($degrees) = shift;
  return $degrees * pi/180;
}

sub degrees{
  my ($rads) = shift;
  return 180 *$rads/ pi;
}