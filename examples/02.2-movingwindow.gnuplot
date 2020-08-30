#!/usr/bin/gnuplot

set term qt persist
set xrange [0:1000]
set yrange [0:7]
set grid
plot 'examples/02-movingwindow.dat' using 1:3 title 'True sigma' with lines, 'examples/02-movingwindow.dat' using 1:4 title 'MAD' with lines, 'examples/02-movingwindow.dat' using 1:5 title 'IQR' with lines, 'examples/02-movingwindow.dat' using 1:6 title 'Sₙ' with lines, 'examples/02-movingwindow.dat' using 1:7 title 'Qₙ' with lines, 'examples/02-movingwindow.dat' using 1:8 title 'sigma' with lines
