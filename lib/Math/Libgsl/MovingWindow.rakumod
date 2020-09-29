unit class Math::Libgsl::MovingWindow:ver<0.0.2>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::MovingWindow;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use Math::Libgsl::Exception;
use Math::Libgsl::Vector;
use NativeCall;

has gsl_movstat_workspace $.w;

multi method new(Int :$samples!, |c)
{
  fail X::Libgsl.new: errno => GSL_FAILURE, error => 'Please use either "samples" or both "before" and "after"'
    if (c<before>:exists) || (c<after>:exists);
  self.bless(:$samples);
}
multi method new(Int :$before!, Int :$after!, |c)
{
  fail X::Libgsl.new: errno => GSL_FAILURE, error => 'Please use either "samples" or both "before" and "after"'
    if c<samples>:exists;
  self.bless(:$before, :$after);
}

submethod BUILD(Int :$samples?, Int :$before?, Int :$after?) {
  with $before {
    $!w = gsl_movstat_alloc2($before, $after);
  } orwith $samples {
    $!w = gsl_movstat_alloc($samples);
  } else {
    fail X::Libgsl.new: errno => GSL_FAILURE, error => 'Please use either "samples" or both "before" and "after"';
  }
}

submethod DESTROY {
  gsl_movstat_free($!w);
}

method mean(Math::Libgsl::Vector $x!, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector) {
  my Math::Libgsl::Vector $y;
  with $inplace {
    $y := $x;
  } else {
    $y .= new: $x.vector.size;
  }
  my $ret = gsl_movstat_mean($endtype, $x.vector, $y.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute the mean" if $ret ≠ GSL_SUCCESS;
  return $y;
}

method variance(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector) {
  my Math::Libgsl::Vector $y;
  with $inplace {
    $y := $x;
  } else {
    $y .= new: $x.vector.size;
  }
  my $ret = gsl_movstat_variance($endtype, $x.vector, $y.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute the variance" if $ret ≠ GSL_SUCCESS;
  return $y;
}

method sd(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector) {
  my Math::Libgsl::Vector $y;
  with $inplace {
    $y := $x;
  } else {
    $y .= new: $x.vector.size;
  }
  my $ret = gsl_movstat_sd($endtype, $x.vector, $y.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute the standard deviation" if $ret ≠ GSL_SUCCESS;
  return $y;
}

method min(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector) {
  my Math::Libgsl::Vector $y;
  with $inplace {
    $y := $x;
  } else {
    $y .= new: $x.vector.size;
  }
  my $ret = gsl_movstat_min($endtype, $x.vector, $y.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute the min" if $ret ≠ GSL_SUCCESS;
  return $y;
}

method max(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector) {
  my Math::Libgsl::Vector $y;
  with $inplace {
    $y := $x;
  } else {
    $y .= new: $x.vector.size;
  }
  my $ret = gsl_movstat_max($endtype, $x.vector, $y.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute the max" if $ret ≠ GSL_SUCCESS;
  return $y;
}

method minmax(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> List) {
  my Math::Libgsl::Vector $ymin .= new: $x.vector.size;
  my Math::Libgsl::Vector $ymax .= new: $x.vector.size;
  my $ret = gsl_movstat_minmax($endtype, $x.vector, $ymin.vector, $ymax.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute the minmax" if $ret ≠ GSL_SUCCESS;
  return $ymin, $ymax;
}

method sum(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector) {
  my Math::Libgsl::Vector $y;
  with $inplace {
    $y := $x;
  } else {
    $y .= new: $x.vector.size;
  }
  my $ret = gsl_movstat_sum($endtype, $x.vector, $y.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute the sum" if $ret ≠ GSL_SUCCESS;
  return $y;
}

method median(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector) {
  my Math::Libgsl::Vector $y;
  with $inplace {
    $y := $x;
  } else {
    $y .= new: $x.vector.size;
  }
  my $ret = gsl_movstat_median($endtype, $x.vector, $y.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute the median" if $ret ≠ GSL_SUCCESS;
  return $y;
}

method mad0(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> List) {
  my Math::Libgsl::Vector $xmedian .= new: $x.vector.size;
  my Math::Libgsl::Vector $xmad    .= new: $x.vector.size;
  my $ret = gsl_movstat_mad0($endtype, $x.vector, $xmedian.vector, $xmad.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute mad0" if $ret ≠ GSL_SUCCESS;
  return $xmedian, $xmad;
}

method mad(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> List) {
  my Math::Libgsl::Vector $xmedian .= new: $x.vector.size;
  my Math::Libgsl::Vector $xmad    .= new: $x.vector.size;
  my $ret = gsl_movstat_mad($endtype, $x.vector, $xmedian.vector, $xmad.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute mad" if $ret ≠ GSL_SUCCESS;
  return $xmedian, $xmad;
}

method qqr(Math::Libgsl::Vector $x, Num() $quantile, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> Math::Libgsl::Vector) {
  my Math::Libgsl::Vector $xqqr .= new: $x.vector.size;
  my num64 $q = $quantile;
  my $ret = gsl_movstat_qqr($endtype, $x.vector, $q, $xqqr.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute the qqr" if $ret ≠ GSL_SUCCESS;
  return $xqqr;
}

method Sn(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> Math::Libgsl::Vector) {
  my Math::Libgsl::Vector $xscale .= new: $x.vector.size;
  my $ret = gsl_movstat_Sn($endtype, $x.vector, $xscale.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute Sn" if $ret ≠ GSL_SUCCESS;
  return $xscale;
}

method Qn(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> Math::Libgsl::Vector) {
  my Math::Libgsl::Vector $xscale .= new: $x.vector.size;
  my $ret = gsl_movstat_Qn($endtype, $x.vector, $xscale.vector, $!w);
  fail X::Libgsl.new: errno => $ret, error => "Can't compute Qn" if $ret ≠ GSL_SUCCESS;
  return $xscale;
}

=begin pod

![Moving mean, minimum and maximum](examples/01-movingwindow.svg)

=head1 NAME

Math::Libgsl::MovingWindow - An interface to libgsl, the Gnu Scientific Library - Moving Window Statistics

=head1 SYNOPSIS

=begin code :lang<raku>

use Math::Libgsl::Vector;
use Math::Libgsl::MovingWindow;

my Math::Libgsl::Vector $x .= new: 1000;
$x.scanf('data.dat');
my Math::Libgsl::MovingWindow $mw .= new: :10samples;
my Math::Libgsl::Vector $res = $mw.mean($x);
$res[^$res.vector.size]».put;

=end code

=head1 DESCRIPTION

Math::Libgsl::MovingWindow is an interface to the Moving Window Statistics functions of libgsl, the Gnu Scientific Library.

This class creates a window around a sample which is used to calculate various local statistical properties of an input data stream. The window is then slid forward by one sample to process the next data point and so on.

=head3 new(Int :$samples!)
=head3 new(Int :$before!, Int :$after!)

The constructor accepts one or two named arguments.
If just the B<samples> argument is provided then a workspace is allocated for computing symmetric, centered moving statistics with the specified window length.
When both B<sbefore> and B<after> arguments are provided then the window has B<before> samples before the current sample and B<after> samples after.

In all the following methods the user must specify how to construct the windows near the end points. Every method allows for a B<$endtype> argument, which defaults to B<GSL_MOVSTAT_END_PADZERO>.
The symbolic names for this argument are listed in the Math::Libgsl::Constants module as follows:

=item B<GSL_MOVSTAT_END_PADZERO>: inserts zeros into the window near the signal end points
=item B<GSL_MOVSTAT_END_PADVALUE>: pads the window with the first and last sample in the input signal
=item B<GSL_MOVSTAT_END_TRUNCATE>: no padding is performed: the windows are truncated as the end points are approached

=head3 mean(Math::Libgsl::Vector $x!, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving window mean of the input vector B<$x>, returning a Math::Libgsl::Vector of the same length as the input one.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
The boolean named argument B<:$inplace> directs the method to compute the mean in-place.
If an error occurs during the computation this method returns a failure object.

=head3 variance(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving variance of the input vector B<$x>, returning a Math::Libgsl::Vector of the same length as the input one.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
The boolean named argument B<:$inplace> directs the method to compute the variance in-place.
If an error occurs during the computation this method returns a failure object.

=head3 sd(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving standard deviation of the input vector B<$x>, returning a Math::Libgsl::Vector of the same length as the input one.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
The boolean named argument B<:$inplace> directs the method to compute the standard deviation in-place.
If an error occurs during the computation this method returns a failure object.

=head3 min(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving minimum of the input vector B<$x>, returning a Math::Libgsl::Vector of the same length as the input one.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
The boolean named argument B<:$inplace> directs the method to compute the minimum in-place.
If an error occurs during the computation this method returns a failure object.

=head3 max(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving maximum of the input vector B<$x>, returning a Math::Libgsl::Vector of the same length as the input one.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
The boolean named argument B<:$inplace> directs the method to compute the maximum in-place.
If an error occurs during the computation this method returns a failure object.

=head3 minmax(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> List)

This method computes the moving minimum and maximum of the input vector B<$x>, returning a List of two Math::Libgsl::Vector objects of the same length as the input one.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
If an error occurs during the computation this method returns a failure object.

=head3 sum(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving sum of the input vector B<$x>, returning a Math::Libgsl::Vector of the same length as the input one.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
The boolean named argument B<:$inplace> directs the method to compute the sum in-place.
If an error occurs during the computation this method returns a failure object.

=head3 median(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving median of the input vector B<$x>, returning a Math::Libgsl::Vector of the same length as the input one.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
The boolean named argument B<:$inplace> directs the method to compute the median in-place.
If an error occurs during the computation this method returns a failure object.

=head3 mad0(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> List)
=head3 mad(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> List)

This method computes the moving Median Absolute Deviation (MAD) of the input vector B<$x>, returning a List of two Math::Libgsl::Vector objects of the same length as the input one: the median and the MAD.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
If an error occurs during the computation this method returns a failure object.
The mad0 method does not include the scale factor of 1.4826.

=head3 qqr(Math::Libgsl::Vector $x, Num() $quantile, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> Math::Libgsl::Vector)

This method computes the moving q-quantile range (QQR) of the input vector B<$x>, returning a Math::Libgsl::Vector of the same length as the input one.
The B<$quantile> argument must be between 0 and 0.5.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
If an error occurs during the computation this method returns a failure object.

=head3 Sn(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> Math::Libgsl::Vector)

This method computes the moving Sₙ statistics of the input vector B<$x>, returning a Math::Libgsl::Vector of the same length as the input one.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
If an error occurs during the computation this method returns a failure object.

=head3 Qn(Math::Libgsl::Vector $x, Int :$endtype? = GSL_MOVSTAT_END_PADZERO --> Math::Libgsl::Vector)

This method computes the moving Qₙ statistics of the input vector B<$x>, returning a Math::Libgsl::Vector of the same length as the input one.
The B<$endtype> is optional and defaults to GSL_MOVSTAT_END_PADZERO.
If an error occurs during the computation this method returns a failure object.

=head1 C Library Documentation

For more details on libgsl see L<https://www.gnu.org/software/gsl/>.
The excellent C Library manual is available here L<https://www.gnu.org/software/gsl/doc/html/index.html>, or here L<https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf> in PDF format.

=head1 Prerequisites

This module requires the libgsl library to be installed. Please follow the instructions below based on your platform:

=head2 Debian Linux and Ubuntu 20.04

=begin code
sudo apt install libgsl23 libgsl-dev libgslcblas0
=end code

That command will install libgslcblas0 as well, since it's used by the GSL.

=head2 Ubuntu 18.04

libgsl23 and libgslcblas0 have a missing symbol on Ubuntu 18.04.
I solved the issue installing the Debian Buster version of those three libraries:

=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb>
=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb>
=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb>

=head1 Installation

To install it using zef (a module management tool):

=begin code
$ zef install Math::Libgsl::MovingWindow
=end code

=head1 AUTHOR

Fernando Santagata <nando.santagata@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Fernando Santagata

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
