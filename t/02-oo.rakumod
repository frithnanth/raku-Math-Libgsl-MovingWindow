#!/usr/bin/env perl6

use Test;
use Math::Libgsl::Vector;
use Math::Libgsl::Random;
use Math::Libgsl::Constants;
use lib 'lib';
use Math::Libgsl::MovingWindow;

sub random-vector(Math::Libgsl::Vector $x)
{
  my Math::Libgsl::Random $r .= new;
  for ^$x.vector.size -> $i {
    $x[$i] = 2 * $r.get-uniform - 1;
  }
}

my constant $size = 1000;
my $*TOLERANCE = 10⁻¹²;

my Math::Libgsl::MovingWindow $mw;
throws-like { $mw = Math::Libgsl::MovingWindow.new: :10before }, X::AdHoc, message => /'Cannot unbox'/, 'fail with wrong arguments';
throws-like { $mw = Math::Libgsl::MovingWindow.new: :10before, :10after, :10samples }, X::TypeCheck::Assignment, message => /'Please use either'/, 'fail with wrong arguments';

my Math::Libgsl::MovingWindow $mw1 .= new: :10samples;
isa-ok $mw1, Math::Libgsl::MovingWindow, 'init with 1 parameter';

my Math::Libgsl::MovingWindow $mw2 .= new: :3before, :3after;
isa-ok $mw2, Math::Libgsl::MovingWindow, 'init with 2 parameters';

my Math::Libgsl::Vector $x .= new: $size;
random-vector($x);

my $res = $mw2.mean($x);
ok ([&&] ($res[^5]
    Z≅
    (0.1121344318879502, 0.03546487267262169, 0.031171619626028192, 0.16187932149374057, 0.08889749127307106)
   )), 'moving mean';

$res = $mw2.mean($x, GSL_MOVSTAT_END_TRUNCATE);
ok ([&&] ($res[^5]
    Z≅
    (0.19623525580391288, 0.049650821741670376, 0.036366889563699566, 0.1618793214937406, 0.08889749127307109)
   )), 'moving mean with end truncation';

my Math::Libgsl::Vector $y .= new: $size;
$y.copy($x);
$mw2.mean($y, :inplace);
ok ([&&] ($y[^5]
    Z≅
    (0.1121344318879502, 0.03546487267262169, 0.031171619626028192, 0.16187932149374057, 0.08889749127307106)
   )), 'in-place moving mean';

$res = $mw2.variance($x);
ok ([&&] ($res[^5]
    Z≅
    (0.39240711007756207, 0.45361502000279574, 0.45409931672436415, 0.5641839748992395, 0.4588320075230943)
   )), 'moving variance';

$y.copy($x);
$mw2.variance($y, :inplace);
ok ([&&] ($y[^5]
    Z≅
    (0.39240711007756207, 0.45361502000279574, 0.45409931672436415, 0.5641839748992395, 0.4588320075230943)
   )), 'in-place moving variance';

$res = $mw2.sd($x);
ok ([&&] ($res[^5]
    Z≅
    (0.6264240656915745, 0.6735094802620047, 0.6738689165738128, 0.751121810959607, 0.6773713955601419)
   )), 'moving standard deviation';

$y.copy($x);
$mw2.sd($y, :inplace);
ok ([&&] ($y[^5]
    Z≅
    (0.6264240656915745, 0.6735094802620047, 0.6738689165738128, 0.751121810959607, 0.6773713955601419)
   )), 'in-place moving standard deviation';

$res = $mw2.min($x);
ok ([&&] ($res[^5]
    Z≅
    (-0.6741802492178977 xx 5)
   )), 'moving min';

$y.copy($x);
$mw2.min($y, :inplace);
ok ([&&] ($y[^5]
    Z≅
    (-0.6741802492178977 xx 5)
   )), 'in-place moving min';

$res = $mw2.max($x);
ok ([&&] ($res[^5]
    Z≅
    (|(0.999483497813344 xx 4), 0.9149539130739868)
   )), 'moving max';

$y.copy($x);
$mw2.max($y, :inplace);
ok ([&&] ($y[^5]
    Z≅
    (|(0.999483497813344 xx 4), 0.9149539130739868)
   )), 'in-place moving max';

my ($resmin, $resmax) = $mw2.minmax($x);
ok ([&&] (|$resmin[^5], |$resmax[^5]
    Z≅
    (|(-0.6741802492178977 xx 5), |(0.999483497813344 xx 4), 0.9149539130739868)
   )), 'moving minmax';

$res = $mw2.sum($x);
ok ([&&] ($res[^5]
    Z≅
    (0.7849410232156515, 0.24825410870835185, 0.21820133738219738, 1.1331552504561841, 0.6222824389114976)
   )), 'moving sum';

$y.copy($x);
$mw2.sum($y, :inplace);
ok ([&&] ($y[^5]
    Z≅
    (0.7849410232156515, 0.24825410870835185, 0.21820133738219738, 1.1331552504561841, 0.6222824389114976)
   )), 'in-place moving sum';

$res = $mw2.median($x);
ok ([&&] ($res[^5]
    Z≅
    (0, 0, |(-0.03005277132615447 xx 3))
   )), 'moving median';

$y.copy($x);
$mw2.median($y, :inplace);
ok ([&&] ($y[^5]
    Z≅
    (0, 0, |(-0.03005277132615447 xx 3))
   )), 'in-place moving median';

my ($xmedian, $xmad) = $mw2.mad0($x);
ok ([&&] (|$xmedian[^5], |$xmad[^5]
    Z≅
    (0, 0, |(-0.03005277132615447 xx 3), 0.43476438941434026, 0.5366869145072997, 0.5066341431811452, 0.6441274778917432, 0.5186634575948119)
   )), 'moving mad0';

($xmedian, $xmad) = $mw2.mad($x);
ok ([&&] (|$xmedian[^5], |$xmad[^5]
    Z≅
    (0, 0, |(-0.03005277132615447 xx 3), 0.6445826482729343, 0.7956932100914489, 0.7511369046510507, 0.9549848277227165, 0.7689715928878544)
   )), 'moving mad';

$res = $mw2.qqr($x, .25);
ok ([&&] ($res[^5]
    Z≅
    (0.6645832767244428, 0.9329267339780927, 0.9329267339780927, 1.390403690515086, 1.1772320771124214)
   )), 'moving qqr';

$res = $mw2.Sn($x);
ok ([&&] ($res[^5]
    Z≅
    (0.6211630129570195, 0.7667832714612038, 0.7667832714612038, 0.9202873433001642, 0.741032531354032)
   )), 'moving Sn';

$res = $mw2.Qn($x);
ok ([&&] ($res[^5]
    Z≅
    (0.8285439127794839, 0.8285439127794839, 0.7712714191008243, 0.456262191874358, 0.7733293410107154)
   )), 'moving Qn';

done-testing;
