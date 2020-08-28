[![Actions Status](https://github.com/frithnanth/raku-Math-Libgsl-MovingWindow/workflows/test/badge.svg)](https://github.com/frithnanth/raku-Math-Libgsl-MovingWindow/actions) [![Build Status](https://travis-ci.org/frithnanth/raku-Math-Libgsl-MovingWindow.svg?branch=master)](https://travis-ci.org/frithnanth/raku-Math-Libgsl-MovingWindow)

NAME
====

Math::Libgsl::MovingWindow - An interface to libgsl, the Gnu Scientific Library - Moving Window Statistics

SYNOPSIS
========

```raku
use Math::Libgsl::Vector;
use Math::Libgsl::MovingWindow;

my Math::Libgsl::Vector $x .= new: 1000;
$x.scanf('data.dat');
my Math::Libgsl::MovingWindow $mw .= new: :10samples;
my Math::Libgsl::Vector $res = $mw.mean($x);
$res[^$res.vector.size]».put;
```

DESCRIPTION
===========

Math::Libgsl::MovingWindow is an interface to the Moving Window Statistics functions of libgsl, the Gnu Scientific Library.

This class creates a window around a sample which is used to calculate various local statistical properties of an input data stream. The window is then slid forward by one sample to process the next data point and so on.

### new(Int :$samples!)

### new(Int :$before!, Int :$after!)

The constructor accepts one or two named arguments. If just the **samples** argument is provided then a workspace is allocated for computing symmetric, centered moving statistics with the specified window length. When both **sbefore** and **after** arguments are provided then the window has **before** samples before the current sample and **after** samples after.

In all the following methods the user must specify how to construct the windows near the end points. Every method allows for a **$endtype** argument, which defaults to **GSL_MOVSTAT_END_PADZERO**. The symbolic names for this argument are listed in the Math::Libgsl::Constants module as follows:

  * **GSL_MOVSTAT_END_PADZERO**: inserts zeros into the window near the signal end points

  * **GSL_MOVSTAT_END_PADVALUE**: pads the window with the first and last sample in the input signal

  * **GSL_MOVSTAT_END_TRUNCATE**: no padding is performed: the windows are truncated as the end points are approached

### mean(Math::Libgsl::Vector $x!, Int $endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving window mean of the input vector **$x**, returning a Math::Libgsl::Vector of the same length as the input one. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. The boolean named argument **:$inplace** directs the method to compute the mean in-place. If an error occurs during the computation this method returns a failure object.

### variance(Math::Libgsl::Vector $x, Int $endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving variance of the input vector **$x**, returning a Math::Libgsl::Vector of the same length as the input one. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. The boolean named argument **:$inplace** directs the method to compute the variance in-place. If an error occurs during the computation this method returns a failure object.

### sd(Math::Libgsl::Vector $x, Int $endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving standard deviation of the input vector **$x**, returning a Math::Libgsl::Vector of the same length as the input one. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. The boolean named argument **:$inplace** directs the method to compute the standard deviation in-place. If an error occurs during the computation this method returns a failure object.

### min(Math::Libgsl::Vector $x, Int $endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving minimum of the input vector **$x**, returning a Math::Libgsl::Vector of the same length as the input one. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. The boolean named argument **:$inplace** directs the method to compute the minimum in-place. If an error occurs during the computation this method returns a failure object.

### max(Math::Libgsl::Vector $x, Int $endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving maximum of the input vector **$x**, returning a Math::Libgsl::Vector of the same length as the input one. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. The boolean named argument **:$inplace** directs the method to compute the maximum in-place. If an error occurs during the computation this method returns a failure object.

### minmax(Math::Libgsl::Vector $x, Int $endtype? = GSL_MOVSTAT_END_PADZERO --> List)

This method computes the moving minimum and maximum of the input vector **$x**, returning a List of two Math::Libgsl::Vector objects of the same length as the input one. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. If an error occurs during the computation this method returns a failure object.

### sum(Math::Libgsl::Vector $x, Int $endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving sum of the input vector **$x**, returning a Math::Libgsl::Vector of the same length as the input one. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. The boolean named argument **:$inplace** directs the method to compute the sum in-place. If an error occurs during the computation this method returns a failure object.

### median(Math::Libgsl::Vector $x, Int $endtype? = GSL_MOVSTAT_END_PADZERO, Bool :$inplace? --> Math::Libgsl::Vector)

This method computes the moving median of the input vector **$x**, returning a Math::Libgsl::Vector of the same length as the input one. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. The boolean named argument **:$inplace** directs the method to compute the median in-place. If an error occurs during the computation this method returns a failure object.

### mad0(Math::Libgsl::Vector $x, Int $endtype? = GSL_MOVSTAT_END_PADZERO --> List)

### mad(Math::Libgsl::Vector $x, Int $endtype? = GSL_MOVSTAT_END_PADZERO --> List)

This method computes the moving Median Absolute Deviation (MAD) of the input vector **$x**, returning a List of two Math::Libgsl::Vector objects of the same length as the input one: the median and the MAD. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. If an error occurs during the computation this method returns a failure object. The mad0 method does not include the scale factor of 1.4826.

### qqr(Math::Libgsl::Vector $x, Num() $quantile, Int $endtype? = GSL_MOVSTAT_END_PADZERO --> Math::Libgsl::Vector)

This method computes the moving q-quantile range (QQR) of the input vector **$x**, returning a Math::Libgsl::Vector of the same length as the input one. The **$quantile** argument must be between 0 and 0.5. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. If an error occurs during the computation this method returns a failure object.

### Sn(Math::Libgsl::Vector $x, Int $endtype? = GSL_MOVSTAT_END_PADZERO --> Math::Libgsl::Vector)

This method computes the moving Sₙ statistics of the input vector **$x**, returning a Math::Libgsl::Vector of the same length as the input one. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. If an error occurs during the computation this method returns a failure object.

### Qn(Math::Libgsl::Vector $x, Int $endtype? = GSL_MOVSTAT_END_PADZERO --> Math::Libgsl::Vector)

This method computes the moving Qₙ statistics of the input vector **$x**, returning a Math::Libgsl::Vector of the same length as the input one. The **$endtype** is optional and defaults to GSL_MOVSTAT_END_PADZERO. If an error occurs during the computation this method returns a failure object.

C Library Documentation
=======================

For more details on libgsl see [https://www.gnu.org/software/gsl/](https://www.gnu.org/software/gsl/). The excellent C Library manual is available here [https://www.gnu.org/software/gsl/doc/html/index.html](https://www.gnu.org/software/gsl/doc/html/index.html), or here [https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf](https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf) in PDF format.

Prerequisites
=============

This module requires the libgsl library to be installed. Please follow the instructions below based on your platform:

Debian Linux and Ubuntu 20.04
-----------------------------

    sudo apt install libgsl23 libgsl-dev libgslcblas0

That command will install libgslcblas0 as well, since it's used by the GSL.

Ubuntu 18.04
------------

libgsl23 and libgslcblas0 have a missing symbol on Ubuntu 18.04. I solved the issue installing the Debian Buster version of those three libraries:

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb)

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb)

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb)

Installation
============

To install it using zef (a module management tool):

    $ zef install Math::Libgsl::MovingWindow

AUTHOR
======

Fernando Santagata <nando.santagata@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Fernando Santagata

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

