#!/bin/bash

exec R -e "rmarkdown::render('report.Rmd',output_file='output.pdf')"
