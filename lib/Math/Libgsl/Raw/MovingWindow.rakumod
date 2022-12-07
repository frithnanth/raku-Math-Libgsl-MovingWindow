use v6;

unit module Math::Libgsl::Raw::MovingWindow:ver<0.0.4>:auth<zef:FRITH>;

use Math::Libgsl::Raw::Matrix :ALL;
use NativeCall;

sub LIB {
  run('/sbin/ldconfig', '-p', :chomp, :out)
    .out
    .slurp(:close)
    .split("\n")
    .grep(/^ \s+ libgsl\.so\. \d+ /)
    .sort
    .head
    .comb(/\S+/)
    .head;
}

class gsl_movstat_workspace is repr('CStruct') is export {
  has size_t          $.H;
  has size_t          $.J;
  has size_t          $.K;
  has Pointer[num64]  $.work;
  has Pointer[void]   $.state;
  has size_t          $.state_size;
}

class gsl_movstat_function is repr('CStruct') is export {
  has Pointer $.function;
  has Pointer[void]  $.params;
}

class gsl_movstat_accum is repr('CStruct') is export {
  has Pointer[void]   $.size;
  has Pointer[void]   $.init;
  has Pointer[void]   $.insert;
  has Pointer[void]   $.delete;
  has Pointer[void]   $.get;
}

sub gsl_movstat_alloc(size_t $K --> gsl_movstat_workspace) is native(LIB) is export { * }
sub gsl_movstat_alloc2(size_t $K, size_t $J --> gsl_movstat_workspace) is native(LIB) is export { * }
sub gsl_movstat_free(gsl_movstat_workspace $w) is native(LIB) is export { * }
sub gsl_movstat_mean(int32 $endtype, gsl_vector $x, gsl_vector $y, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_variance(int32 $endtype, gsl_vector $x, gsl_vector $y, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_sd(int32 $endtype, gsl_vector $x, gsl_vector $y, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_min(int32 $endtype, gsl_vector $x, gsl_vector $y, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_max(int32 $endtype, gsl_vector $x, gsl_vector $y, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_minmax(int32 $endtype, gsl_vector $x, gsl_vector $ymin, gsl_vector $ymax, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_sum(int32 $endtype, gsl_vector $x, gsl_vector $y, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_median(int32 $endtype, gsl_vector $x, gsl_vector $y, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_mad0(int32 $endtype, gsl_vector $x, gsl_vector $xmedian, gsl_vector $xmad, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_mad(int32 $endtype, gsl_vector $x, gsl_vector $xmedian, gsl_vector $xmad, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_qqr(int32 $endtype, gsl_vector $x, num64 $q, gsl_vector $xqqr, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_Sn(int32 $endtype, gsl_vector $x, gsl_vector $xscale, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
sub gsl_movstat_Qn(int32 $endtype, gsl_vector $x, gsl_vector $xscale, gsl_movstat_workspace $w --> int32) is native(LIB) is export { * }
