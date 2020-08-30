#!/usr/bin/env perl6

use Test;
use NativeCall;
use lib 'lib';
use Math::Libgsl::Raw::Matrix :ALL;
use Math::Libgsl::Raw::Random;
use Math::Libgsl::Raw::MovingWindow;
use Math::Libgsl::Constants;

sub random-vector(gsl_vector $x)
{
  my gsl_rng $r = mgsl_rng_setup(DEFAULT);
  for ^$x.size -> $i {
    gsl_vector_set($x, $i, 2e0 * gsl_rng_uniform($r) - 1e0);
  }
  gsl_rng_free($r);
}

my constant $size = 1000;
my $*TOLERANCE = 10⁻¹²;

my gsl_movstat_workspace $w1 = gsl_movstat_alloc(10);
isa-ok $w1, Math::Libgsl::Raw::MovingWindow::gsl_movstat_workspace, 'create workspace with 1 argument';
lives-ok { gsl_movstat_free($w1) }, 'free workspace';

my gsl_movstat_workspace $w2 = gsl_movstat_alloc2(3, 3);
isa-ok $w2, Math::Libgsl::Raw::MovingWindow::gsl_movstat_workspace, 'create workspace with 2 arguments';

my gsl_vector $x = gsl_vector_alloc($size);
my gsl_vector $y = gsl_vector_alloc($size);
random-vector($x);

gsl_movstat_mean(GSL_MOVSTAT_END_PADZERO, $x, $y, $w2);
ok ([&&] ((gather take gsl_vector_get($y, $_) for ^5)
    Z≅
    (0.1121344318879502, 0.03546487267262169, 0.031171619626028192, 0.16187932149374057, 0.08889749127307106)
   )), 'moving mean';

gsl_movstat_variance(GSL_MOVSTAT_END_PADZERO, $x, $y, $w2);
ok ([&&] ((gather take gsl_vector_get($y, $_) for ^5)
    Z≅
    (0.39240711007756207, 0.45361502000279574, 0.45409931672436415, 0.5641839748992395, 0.4588320075230943)
   )), 'moving variance';

gsl_movstat_sd(GSL_MOVSTAT_END_PADZERO, $x, $y, $w2);
ok ([&&] ((gather take gsl_vector_get($y, $_) for ^5)
    Z≅
    (0.6264240656915745, 0.6735094802620047, 0.6738689165738128, 0.751121810959607, 0.6773713955601419)
   )), 'moving standard deviation';

gsl_movstat_min(GSL_MOVSTAT_END_PADZERO, $x, $y, $w2);
ok ([&&] ((gather take gsl_vector_get($y, $_) for ^5)
    Z≅
    (-0.6741802492178977 xx 5)
   )), 'moving min';

gsl_movstat_max(GSL_MOVSTAT_END_PADZERO, $x, $y, $w2);
ok ([&&] ((gather take gsl_vector_get($y, $_) for ^5)
    Z≅
    (|(0.999483497813344 xx 4), 0.9149539130739868)
   )), 'moving max';

my gsl_vector $ymin    = gsl_vector_alloc($size);
my gsl_vector $ymax    = gsl_vector_alloc($size);

gsl_movstat_minmax(GSL_MOVSTAT_END_PADZERO, $x, $ymin, $ymax, $w2);
ok ([&&] ((gather { take gsl_vector_get($ymin, $_) for ^5; take gsl_vector_get($ymax, $_) for ^5 })
    Z≅
    (|(-0.6741802492178977 xx 5), |(0.999483497813344 xx 4), 0.9149539130739868)
   )), 'moving minmax';

gsl_movstat_sum(GSL_MOVSTAT_END_PADZERO, $x, $y, $w2);
ok ([&&] ((gather take gsl_vector_get($y, $_) for ^5)
    Z≅
    (0.7849410232156515, 0.24825410870835185, 0.21820133738219738, 1.1331552504561841, 0.6222824389114976)
   )), 'moving sum';

gsl_movstat_median(GSL_MOVSTAT_END_PADZERO, $x, $y, $w2);
ok ([&&] ((gather take gsl_vector_get($y, $_) for ^5)
    Z≅
    (0, 0, |(-0.03005277132615447 xx 3))
   )), 'moving median';

my gsl_vector $xmedian = gsl_vector_alloc($size);
my gsl_vector $xmad    = gsl_vector_alloc($size);

gsl_movstat_mad0(GSL_MOVSTAT_END_PADZERO, $x, $xmedian, $xmad, $w2);
ok ([&&] ((gather { take gsl_vector_get($xmedian, $_) for ^5; take gsl_vector_get($xmad, $_) for ^5 })
    Z≅
    (0, 0, |(-0.03005277132615447 xx 3), 0.43476438941434026, 0.5366869145072997, 0.5066341431811452, 0.6441274778917432, 0.5186634575948119)
   )), 'moving mad0';

gsl_movstat_mad(GSL_MOVSTAT_END_PADZERO, $x, $xmedian, $xmad, $w2);
ok ([&&] ((gather { take gsl_vector_get($xmedian, $_) for ^5; take gsl_vector_get($xmad, $_) for ^5 })
    Z≅
    (0, 0, |(-0.03005277132615447 xx 3), 0.6445826482729343, 0.7956932100914489, 0.7511369046510507, 0.9549848277227165, 0.7689715928878544)
   )), 'moving mad';

my gsl_vector $xqqr = gsl_vector_alloc($size);
my num64 $q = .25e0;

gsl_movstat_qqr(GSL_MOVSTAT_END_PADZERO, $x, $q, $xqqr, $w2);
ok ([&&] ((gather take gsl_vector_get($xqqr, $_) for ^5)
    Z≅
    (0.6645832767244428, 0.9329267339780927, 0.9329267339780927, 1.390403690515086, 1.1772320771124214)
   )), 'moving qqr';

gsl_movstat_Sn(GSL_MOVSTAT_END_PADZERO, $x, $y, $w2);
ok ([&&] ((gather take gsl_vector_get($y, $_) for ^5)
    Z≅
    (0.6211630129570195, 0.7667832714612038, 0.7667832714612038, 0.9202873433001642, 0.741032531354032)
   )), 'moving Sn';

gsl_movstat_Qn(GSL_MOVSTAT_END_PADZERO, $x, $y, $w2);
ok ([&&] ((gather take gsl_vector_get($y, $_) for ^5)
    Z≅
    (0.8285439127794839, 0.8285439127794839, 0.7712714191008243, 0.456262191874358, 0.7733293410107154)
   )), 'moving Qn';

gsl_movstat_free($w2);
gsl_vector_free($x);
gsl_vector_free($y);
gsl_vector_free($ymin);
gsl_vector_free($ymax);
gsl_vector_free($xmedian);
gsl_vector_free($xmad);
gsl_vector_free($xqqr);

done-testing;
