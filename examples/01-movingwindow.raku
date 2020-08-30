#!/usr/bin/env raku

# See "GNU Scientific Library" manual Chapter 23 Moving Window Statistics, Paragraph 23.12.1

use Math::Libgsl::Vector;
use Math::Libgsl::Random;
use Math::Libgsl::RandomDistribution;
use Math::Libgsl::Constants;
use Math::Libgsl::MovingWindow;

constant $N = 500;
constant $K = 11;

my Math::Libgsl::MovingWindow $w .= new: :samples($K);
my Math::Libgsl::Vector       $x .= new: $N;
my Math::Libgsl::Random       $r .= new;

$x[$_] = cos(4 * π * $_ / $N) * gaussian($r, .1) for ^$N;

my $xmean = $w.mean($x, GSL_MOVSTAT_END_PADVALUE);
my ($xmin, $xmax) = $w.minmax($x, GSL_MOVSTAT_END_PADVALUE);

say "$x[$_] $xmean[$_] $xmin[$_] $xmax[$_]" for ^$N;
