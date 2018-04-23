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

```r
prod.li
```

```
## $keywords
## # A tibble: 2 x 5
##   Var1                    Var2       paper_count sf       url             
##   <chr>                   <chr>            <dbl> <chr>    <chr>           
## 1 artificial intelligence reservoir        1665. 'artifi… "https://www.on…
## 2 artificial intelligence production       1901. 'artifi… "https://www.on…
## 
## $papers
## # A tibble: 2,985 x 7
##    title_data       paper_id  source  type    year author1_data   keyword 
##    <chr>            <chr>     <chr>   <chr>  <int> <chr>          <chr>   
##  1 Production Moni… "       … "     … "    …  2012 Olivares Vela… 'artifi…
##  2 Profiling Downh… "       … "     … "    …  2015 AlAjmi, Moham… 'artifi…
##  3 Artificial Inte… "       … "     … "    …  2014 Shahkarami, A… 'artifi…
##  4 Cross-Industry … "       … "     … "    …  2011 Piovesan, Car… 'artifi…
##  5 Multilateral We… "       … "     … "    …  2017 Buhulaigah, A… 'artifi…
##  6 Multilateral We… "       … "     … "    …  2016 Al-Mashhad, A… 'artifi…
##  7 Artificial Inte… "       … "     … "    …  1992 Guo, Yi, Cent… 'artifi…
##  8 Well Log Data I… "       … "     … "    …  1986 Wu, X., Insti… 'artifi…
##  9 How Artificial … "       … "     … "    …  2002 Weiss, Willia… 'artifi…
## 10 Integration of … "       … "     … "    …  2016 Ma, Zhiwei, U… 'artifi…
## # ... with 2,975 more rows
```


```r
# write dataframes to csv
# write.csv(prod.li$keywords, file = "data/ai-keywords.csv")
# write.csv(prod.li$papers,   file = "data/ai-papers.csv")

write.csv(prod.li$keywords, file.path(rprojroot::find_rstudio_root_file(), "data", "ai-keywords.csv"))
write.csv(prod.li$keywords, file.path(rprojroot::find_rstudio_root_file(), "data", "ai-papers.csv"))
```


