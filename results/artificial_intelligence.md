---
title: "artificial intelligence"
output:
  pdf_document:
    toc: yes
  html_notebook:
    toc: yes
  html_document:
    df_print: paged
    toc: yes
editor_options:
  chunk_output_type: inline
---



```r
library(petro.One)

major <- c("artificial intelligence")
minor <- c("reservoir", "production")
           # , "logging", "completion", "intervention",
           # "drilling", "geology", "seismic", "petrophysics", "geophysics", 
           # "economics", "metering", "pvt", "offshore")

# the returning data structure is a a list
# the list contains two dataframes: one for the keywords and a second for the papers
prod.li <- join_keywords(major, minor, get_papers = TRUE, sleep = 3)
```

```
##   1  1665 'artificial+intelligence'AND'reservoir'                      
##   2  1901 'artificial+intelligence'AND'production'
```

```
## Error in open.connection(x, "rb"): HTTP error 500.
```

```r
prod.li
```

```
## Error in eval(expr, envir, enclos): object 'prod.li' not found
```


```r
# write dataframes to csv
# write.csv(prod.li$keywords, file = "data/ai-keywords.csv")
# write.csv(prod.li$papers,   file = "data/ai-papers.csv")

write.csv(prod.li$keywords, file.path(rprojroot::find_rstudio_root_file(), "data", "ai-keywords.csv"), row.names = FALSE)
```

```
## Error in is.data.frame(x): object 'prod.li' not found
```

```r
write.csv(prod.li$keywords, file.path(rprojroot::find_rstudio_root_file(), "data", "ai-papers.csv"), row.names = FALSE)
```

```
## Error in is.data.frame(x): object 'prod.li' not found
```


