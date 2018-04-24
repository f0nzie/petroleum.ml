---
title: "Text Mining for Petroleum Engineering"
output:
  html_document:
    df_print: paged
    toc: yes
  html_notebook:
    toc: yes
  pdf_document:
    toc: yes
editor_options:
  chunk_output_type: inline
---




<img src="images/cover.jpg" title="plot of chunk cover" alt="plot of chunk cover" width="800px" style="display: block; margin: auto;" />

Last week I was talking with a colleague about some projects that could be deployed using R, and then the topic of well **technical potential** came up. I got hooked by the subject, and then decided to explore it a little bit more.

What is not better if going to [OnePetro](https://www.onepetro.org/) and search for papers on **technical potential**. I did and found 132 papers matching the term. Well, I was not going to purchase those 132 papers, you know. I had to reduce that number to an essential minimum. How?

That is the topic of today's article. And for that purpose, we will be using [text mining](https://en.wikipedia.org/wiki/Text_mining).

## The Toolbox

I will be using the following ingredients for this recipe. :)

* The R package for text mining [tm](https://cran.r-project.org/web/packages/tm/index.html)

* My R package [petro.One](https://cran.r-project.org/web/packages/petro.One/index.html)

* [RStudio](https://www.rstudio.com/)

* The graphics R package [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html)

All of these tools are open source and free. Never has been more true saying "free ride" for studying, learning and using state-of-the-art software than today. You will just have to invest some of your time.


## How many papers are there?

Let's find out how many papers contain the term **technical potential**. Here is the code in R:


```r
library(petro.One)

my_url <- make_search_url(query = "technical potential", 
                           how = "all")
num_papers <- get_papers_count(my_url)
# [1] 132
```

What the package `petro.One` does is connecting with `OnePetro` and submit the text **technical potential** to the website, specifying that we want papers that only have those two words together with the parameter `how`. We could read the number of papers from the object `num_papers`.

We read the titles of the papers, and the rest of the metadata, and put that in a dataframe `df`. So, we get 132 papers as it is shown below.


```r
df <- read_multidoc(my_url)
write.csv(df, file.path(rprojroot::find_rstudio_root_file(), "data", "tp-papers.csv"), row.names = FALSE)
df
```

```
# A tibble: 134 x 6
   title_data            paper_id   source  type    year author1_data     
   <chr>                 <chr>      <chr>   <chr>  <int> <chr>            
 1 Reserve Technical Po… "        … "     … "    …  2014 Ruslan, M.,      
 2 Technical Potential:… "        … "     … "    …  2017 Gupta, Vipin Pra…
 3 Using Business Intel… "        … "     … "    …  2017 Haris Hamzah, M,…
 4 Managed Pressure Dri… "        … "     … "    …  2013 Sridharan, Prem …
 5 Optimizing Number of… "        … "     … "    …  2015 Guk, Vyacheslav,…
 6 Intelligent Automati… "        … "     … "    …  2014 Zubarev, Victor,…
 7 The Models of Sea Wa… "        … "     … "    …  2012 Chizhiumov, Serg…
 8 The First Subsea Com… "        … "     … "    …  2013 Mahadi, K., PETR…
 9 Staying Ahead throug… "        … "     … "    …  2017 Baghdadi, F., PE…
10 Optimization of Surf… "        … "     … "    …  2017 Lotfollahi, Moha…
# ... with 124 more rows
```


## How many papers with "technical" and "potential"
We assume that the papers with stronger **technical potential** content are those that have in the title those words. We will look at papers in the title.



```r
df$title <- tolower(df$title_data)
# df[grep("technical potential", df$title), c("title_data", "paper_id")]
df[grep("technical potential", df$title), ]
```

```
# A tibble: 3 x 7
  title_data       paper_id  source  type    year author1_data  title     
  <chr>            <chr>     <chr>   <chr>  <int> <chr>         <chr>     
1 Reserve Technic… "       … "     … "    …  2014 Ruslan, M.,   reserve t…
2 Technical Poten… "       … "     … "    …  2017 Gupta, Vipin… technical…
3 Technical Poten… "       … "     … "    …  1982 Quong, Rolan… technical…
```

There are 3 papers that have `technical potential` in their title.

At this point, we could do two things:

* retrieve the papers that have `technical potential` in the title
* perform an additional 1-word and 2-word terms analysis on the 134 that match our query.

We will do first a text mining of the papers that gave a match on the title.



* What grep does is finding a word pattern in the column title of the dataframe `df`. There are 3 papers that match that pattern.


```r
df[grep("technical potential", df$title), c("source", "paper_id")]
```

```
# A tibble: 3 x 2
  source           paper_id              
  <chr>            <chr>                 
1 "          SPE " "          169835-MS "
2 "          SPE " "          187429-MS "
3 "          SPE " "          9469-PA "  
```

These three papers are our best candidates, from the 132 papers that matched our initial query. Next is finding which of the three papers is the one richer in **technical potential** content and focus our attention to it.

What we will do is reading inside the papers, the PDF files.


## Data Mining the PDF files
Once the papers have been downloaded, we will verify that they are in our working directory:


```r
# papers to analyze under data/papers
# provide the full path for the next function
files <- list.files(path = file.path(rprojroot::find_rstudio_root_file(), 
                                     "/data/papers"), 
                    pattern = ".pdf$", 
                    full.names = TRUE)
files
```

```
[1] "/home/superuser/github-oilgains/petroleum.ml//data/papers/gupta2017.pdf" 
[2] "/home/superuser/github-oilgains/petroleum.ml//data/papers/quong1982.pdf" 
[3] "/home/superuser/github-oilgains/petroleum.ml//data/papers/ruslan2014.pdf"
```

That gives us three PDF files. Pay attention to the object files. We will use it to create the mining corpus in a moment.

## Read the PDF files and inspect the corpus

The following operation is reading the papers that are in PDF format. `R` has a way to read PDF files through the function `readPDF` of the package `tm`.



```r
library(tm)
if (!require(pdftools)) install.packages("pdftools")

Rpdf <- readPDF(control = list(text = "-layout"))
papers <- Corpus(URISource(files), 
                   readerControl = list(reader = Rpdf))
papers <- tm_map(papers, content_transformer(function(x) iconv(enc2utf8(x), 
                                                                 sub = "byte")))

inspect(papers)

# one-word terms in gupta2017 paper
papers.tdm <- TermDocumentMatrix(papers, 
                                    control = list(removePunctuation = TRUE, 
                                                   stopwords = TRUE,
                                                   removeNumbers = TRUE,
                                                   tolower = TRUE
                                                   #stemming = TRUE
                                                   ))
inspect(papers.tdm)
```

```
<<VCorpus>>
Metadata:  corpus specific: 0, document level (indexed): 0
Content:  documents: 3

[[1]]
<<PlainTextDocument>>
Metadata:  7
Content:  chars: 57572

[[2]]
<<PlainTextDocument>>
Metadata:  7
Content:  chars: 49884

[[3]]
<<PlainTextDocument>>
Metadata:  7
Content:  chars: 27163

<<TermDocumentMatrix (terms: 2609, documents: 3)>>
Non-/sparse entries: 3374/4453
Sparsity           : 57%
Maximal term length: 46
Weighting          : term frequency (tf)
Sample             :
             Docs
Terms         gupta2017.pdf quong1982.pdf ruslan2014.pdf
  data                   90            10             11
  field                  30             0             23
  fields                 48             0              5
  forecast               72             0              0
  forecasting            67             0              0
  potential              61             7             47
  process                30            18              3
  production             89             7             28
  technical              55             5             40
  well                   45             7             10
```

The `papers` object is the *corpus*. The object `papers.tdm` is the *term document matrix*.

The table at the bottom is the *term document matrix*. A matrix where the rows are the terms and the columns are the counts of those terms for each paper.

Observe that each of the PDF files has an identifier like this `[[1]]`, `[[2]]` and `[[3]]`. Take a look at the number of characters each document contains.

Now, let's get the number of words or terms


```r
# how many terms per paper
sapply(papers, function(x) length(termFreq(x)) )
```

```
 gupta2017.pdf  quong1982.pdf ruslan2014.pdf 
          1939           1703           1058 
```


Now, a summary table of our initial findings:

                 
    Docs        gupta2017.pdf quong1982.pdf ruslan2014.pdf
    Num Chars      58230           50343        27492
    Terms           2274            1878         1207
    

We can see that the document with more content is `gupta2017`, the second `quong1982`, and the third, `ruslan2014`. But we will find something interesting later.


## Find the most frequent terms in the papers

Now that the papers corpus has been converted to a term document matrix, we could continue with finding the most frequent terms:


```r
# findFreqTerms(papers.tdm, lowfreq = 50, highfreq = Inf)
findMostFreqTerms(papers.tdm)
```

```
$gupta2017.pdf
       data  production    forecast forecasting   potential   technical 
         90          89          72          67          61          55 

$quong1982.pdf
     brine   pressure solubility  injection        gas  stripping 
        44         41         34         28         27         26 

$ruslan2014.pdf
 potential   reserves  technical production      field       will 
        47         45         40         28         23         21 
```

What is happening here is that even though "technical potential" is in the title of  `quong1982`, the paper is not strong in technical potential, per se. The other two papers are stronger.

Observe the frequency of the terms. What is happening here is that even though "technical potential" is found in the title of the paper quong1982, the paper is not rich in technical potential terms. The other two papers are stronger. We will put aside `quong1982` and analyze `gupta2017` and `ruslan2014`.

Just to be sure, one more time let's find the score of all the papers given the terms "technical" and "potential".


```r
tm_term_score(papers.tdm, "technical")
tm_term_score(papers.tdm, "potential")
```

```
 gupta2017.pdf  quong1982.pdf ruslan2014.pdf 
            55              5             40 
 gupta2017.pdf  quong1982.pdf ruslan2014.pdf 
            61              7             47 
```

Well, that confirms our initial analysis; `quong1982` is not the best candidate paper for studying "technical potential".


## Term frequency analysis for the first paper
What we do here is building a dataframe of terms vs. frequency at which each occur.


```r
library(tibble)

# frequency analysis of gupta2017
# theFile <- "gupta2017.pdf"
theFile <- files[1]
paper <- Corpus(URISource(theFile), 
                   readerControl = list(reader = Rpdf))
paper <- tm_map(paper, content_transformer(function(x) iconv(enc2utf8(x), 
                                                                 sub = "byte")))

paper.tdm <- TermDocumentMatrix(paper, 
                                    control = list(removePunctuation = TRUE, 
                                                   stopwords = TRUE,
                                                   removeNumbers = TRUE,
                                                   tolower = TRUE
                                                   #stemming = TRUE
                                                   ))
findFreqTerms(paper.tdm, lowfreq = 50, highfreq = Inf)
findMostFreqTerms(paper.tdm)

tdm.matrix <- as.matrix(paper.tdm)
tdm.rs <- sort(rowSums(tdm.matrix), decreasing = TRUE)
tdm.df1 <- tibble(word = names(tdm.rs), freq = tdm.rs)
tdm.df1
```

```
[1] "data"        "forecast"    "forecasting" "potential"   "production" 
[6] "technical"  
$gupta2017.pdf
       data  production    forecast forecasting   potential   technical 
         90          89          72          67          61          55 

# A tibble: 1,442 x 2
   word         freq
   <chr>       <dbl>
 1 data          90.
 2 production    89.
 3 forecast      72.
 4 forecasting   67.
 5 potential     61.
 6 technical     55.
 7 model         49.
 8 fields        48.
 9 well          45.
10 based         39.
# ... with 1,432 more rows
```

# Term freqency analysis for the second paper
Now, for the second paper:


```r
# frequency analysis of ruslan2014
# theFile <- "ruslan2014.pdf"
theFile <- files[3]
paper <- Corpus(URISource(theFile), 
                   readerControl = list(reader = Rpdf))
paper <- tm_map(paper, content_transformer(function(x) iconv(enc2utf8(x), 
                                                                 sub = "byte")))

paper.tdm <- TermDocumentMatrix(paper, 
                                    control = list(removePunctuation = TRUE, 
                                                   stopwords = TRUE,
                                                   tolower = TRUE,
                                                   removeNumbers = TRUE
                                                   #stemming = TRUE
                                                   ))
findFreqTerms(paper.tdm, lowfreq = 50, highfreq = Inf)
findMostFreqTerms(paper.tdm)

tdm.matrix <- as.matrix(paper.tdm)
tdm.rs <- sort(rowSums(tdm.matrix), decreasing = TRUE)
tdm.df2 <- tibble(word = names(tdm.rs), freq = tdm.rs)
tdm.df2
```

```
character(0)
$ruslan2014.pdf
 potential   reserves  technical production      field       will 
        47         45         40         28         23         21 

# A tibble: 809 x 2
   word        freq
   <chr>      <dbl>
 1 potential    47.
 2 reserves     45.
 3 technical    40.
 4 production   28.
 5 field        23.
 6 will         21.
 7 resources    19.
 8 management   18.
 9 mature       18.
10 proved       17.
# ... with 799 more rows
```

We can see some differences between the two: such as the total number of terms or words, the frequency for each term, and that the terms and frequency differ in both documents.

To finish, let's plot terms vs frequency for both papers:


```r
library(ggplot2)
p1 <- ggplot(subset(tdm.df1, freq > 30), aes(x=word, y=freq)) + 
    geom_bar(stat = "identity", width = 0.8) + 
    xlab("Terms") + ylab("Count") + ggtitle("gupta2017") +
    coord_flip()

p2 <- ggplot(subset(tdm.df2, freq > 30), aes(x=reorder(word, freq), y=freq)) + 
    geom_bar(stat = "identity", width = 0.2) + 
    xlab("Terms") + ylab("Count") + ggtitle("ruslan2014") +
    coord_flip()

require("gridExtra")
grid.arrange(arrangeGrob(p1, p2))
```

<img src="./figures/text_mining_pe///unnamed-chunk-11-1.png" title="plot of chunk unnamed-chunk-11" alt="plot of chunk unnamed-chunk-11" style="display: block; margin: auto;" />

## Conclusion

* We rapidly determined, in our study for the term "technical potential", which papers are the best candidates.

* We used text mining, composed a document corpus and a term document matrix, to take that decision, and narrow down from 132 to 3 papers that search and the acquisition of those papers.

* From the three selected papers, we were able to put aside one because the other two papers were even richer in the content we were looking for.

This doesn't mean that we should discard reading the other 130 papers; but doing a deeper analysis of all the papers requires purchasing and downloading all of them. If this option is viable, we may find that other papers may contain interesting content for the subject of our research. In the case of our study for reasons of time and budget we came up rapidly to only those two papers.

## References
* [Article in LinkedIn](https://www.linkedin.com/pulse/text-mining-petroleum-engineering-modern-techniques-paper-reyes/)

* [GitHub repository](https://github.com/f0nzie/Well.Technical.Potential)

