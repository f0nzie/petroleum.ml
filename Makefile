# here we discover that the `md` files are the flag that allows the builds
.PHONY: all
all: README.md mds

mds: results/machine_learning.md results/artificial_intelligence.md \
	results/text_mining_pe.md

README.md : README.Rmd
	Rscript  -e 'rmarkdown::render("$<")'

# using ezknitr::ezknit to redirect outputs
results/%.md : doc/RMD/%.Rmd
	Rscript -e "ezknitr::ezknit('$<', \
	              fig_dir = './figures/$*/', \
	              out_dir = '$(@D)', \
	              keep_html = FALSE, \
	              verbose = TRUE \
	              )"



# remove all csv files from the data folder
clean :
	rm -f data/*.csv
	rm -f results/*.md
	rm -rf results/figures
	rm -f doc/*.pdf
	rm -f doc/*.tex
	rm -f README.md


