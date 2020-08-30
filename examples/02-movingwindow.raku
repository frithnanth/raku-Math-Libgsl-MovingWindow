#!/usr/bin/env raku

# See "GNU Scientific Library" manual Chapter 23 Moving Window Statistics, Paragraph 23.12.2

use Math::Libgsl::Vector;
use Math::Libgsl::Random;
use Math::Libgsl::RandomDistribution;
use Math::Libgsl::Constants;
use Math::Libgsl::MovingWindow;

constant $N = 1000;
constant @sigma = 1, 5, 1, 3, 5;
constant @N_sigma = 200, 450, 600, 850, 1000;
constant $K = 41;

my Math::Libgsl::Vector       $x .= new: $N;
my Math::Libgsl::MovingWindow $w .= new: :samples($K);
my Math::Libgsl::Random       $r .= new;
my $idx = 0;

for ^$N -> $i {
  my $gi = gaussian($r, @sigma[$idx]);
  my $u  = $r.get-uniform;
  my $outlier = ($u < .01) ?? 15 * $gi.sign !! 0;
  $x[$i] = $gi + $outlier;
  ++$idx if $i ≡ @N_sigma[$idx] - 1;
}

my ($xmedian, $xmad) = $w.mad($x, GSL_MOVSTAT_END_TRUNCATE);
my $xiqr = $w.qqr($x, .25, GSL_MOVSTAT_END_TRUNCATE);
my $xSn = $w.Sn($x, GSL_MOVSTAT_END_TRUNCATE);
my $xQn = $w.Qn($x, GSL_MOVSTAT_END_TRUNCATE);
my $xsd = $w.sd($x, GSL_MOVSTAT_END_TRUNCATE);

$xiqr.scale(.7413);

$idx = 0;
for ^$N -> $i {
  say "$i $x[$i] @sigma[$idx] $xmad[$i] $xiqr[$i] $xSn[$i] $xQn[$i] $xsd[$i]";
  ++$idx if $i ≡ @N_sigma[$idx] - 1;
}
