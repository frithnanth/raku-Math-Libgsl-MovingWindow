#!/usr/bin/gnuplot

set term qt persist
set xrange [0:1000]
set yrange [-20:20]
set grid
plot 'examples/02-movingwindow.dat' using 1:2 title 'x(t)' with lines
