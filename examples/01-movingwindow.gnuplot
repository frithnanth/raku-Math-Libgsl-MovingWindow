#!/usr/bin/gnuplot

set term qt persist
set xrange [0:500]
set yrange [-0.5:0.5]
set grid
plot 'examples/01-movingwindow.dat' using 1 title 'Original signal' with lines, 'examples/01-movingwindow.dat' using 2 title 'Moving mean' with lines, 'examples/01-movingwindow.dat' using 3 title 'Moving minimum' with lines, 'examples/01-movingwindow.dat' using 4 title 'Moving maximum' with lines
