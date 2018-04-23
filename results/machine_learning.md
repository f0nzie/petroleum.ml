---
title: "machine learning"
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

Getting papers on `machine learning` by an arbitrary discipline.
These disciplnes are flexible, and can be modified by any user.


```r
library(petro.One)

major <- c("machine learning")
minor <- c("reservoir", "production")
           # "logging", "completion", "intervention",
           # "drilling", "geology", "seismic", "petrophysics", "geophysics", 
           # "economics", "metering", "pvt", "offshore")

# the returning data structure is a a list
# the list contains two dataframes: one for the keywords and a second for the papers
prod.li <- join_keywords(major, minor, get_papers = TRUE, sleep = 3)
```

```
##   1   763 'machine+learning'AND'reservoir'                             
##   2   828 'machine+learning'AND'production'
```

```r
prod.li
```

```
## $keywords
## # A tibble: 2 x 5
##   Var1             Var2       paper_count sf        url                   
##   <chr>            <chr>            <dbl> <chr>     <chr>                 
## 1 machine learning reservoir         763. 'machine… "https://www.onepetro…
## 2 machine learning production        828. 'machine… "https://www.onepetro…
## 
## $papers
## # A tibble: 1,303 x 7
##    title_data      paper_id  source  type    year author1_data    keyword 
##    <chr>           <chr>     <chr>   <chr>  <int> <chr>           <chr>   
##  1 Potential Pitf… "       … "     … "    …  2014 Harris, Cole, … 'machin…
##  2 Mooring Integr… "       … "     … "    …  2017 Prislin, Igor,… 'machin…
##  3 Data Driven Pr… "       … "     … "    …  2016 Cao, Q., Schlu… 'machin…
##  4 Predicting ESP… "       … "     … "    …  2017 Sneed, Jessamy… 'machin…
##  5 Smart Conditio… "       … "     … "    …  2017 Bangert, Patri… 'machin…
##  6 Using Machine … "       … "     … "    …  2018 Snøtun, Håkon,… 'machin…
##  7 Advanced Machi… "       … "     … "    …  2014 Subrahmanya, N… 'machin…
##  8 Selection of E… "       … "     … "    …  2002 Alvarado, Vlad… 'machin…
##  9 A Machine Lear… "       … "     … "    …  1991 Brown, J.P., U… 'machin…
## 10 Predicting and… "       … "     … "    …  2017 Bangert, Patri… 'machin…
## # ... with 1,293 more rows
```

Using `rprojroot::find_rstudio_root_file()` to get the root folder of the project. Then we write the `csv` to the `data` folder.


```r
# write dataframes to csv
# readr::write_csv(prod.li$keywords, "ml-keywords.csv")
# readr::write_csv(prod.li$papers,   "ml-papers.csv")

write.csv(prod.li$keywords, file.path(rprojroot::find_rstudio_root_file(), "data", "ml-keywords.csv"))
write.csv(prod.li$papers,   file.path(rprojroot::find_rstudio_root_file(), "data", "ml-papers.csv"))
```


