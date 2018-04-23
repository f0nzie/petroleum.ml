# here we discover that the `md` files are the flag that allows the builds
.PHONY: all
all: mds

mds: results/machine_learning.md results/artificial_intelligence.md

# using ezknitr::ezknit to redirect outputs
results/%.md : doc/RMD/%.Rmd
	R --slave -e "ezknitr::ezknit('$<', \
	              fig_dir = './figures/$*/', \
	              out_dir = '$(@D)', \
	              keep_html = FALSE, \
	              verbose = TRUE \
	              )"


# remove all csv files from the data folder
tidy : 
	rm -f data/*.csv
	rm -f results/*.md
	rm -f /doc/*.pdf
	rm -f /doc/*.tex
	rm -rf results/figures