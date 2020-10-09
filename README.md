---
output: rmarkdown::github_document
---

# caselaw

The goal of the caselaw R package is to provide an opinionated and tidy R package to make it easy to access the Harvard [Case Law Project](https://case.law).

## Installation

The development version of this package can be installed through:

```r
devtools::install_github("slopp/caselaw")
```

## Use

The main functions in the package are `cl_get_` functions, where you can retrieve courts, cases, opinions, and more.

As an example, we can retrieve all the cases with a matching name abbreviation:

```{r}
library(caselaw)
cl_get_cases(name_abbreviation = "Roe v. Wade")
```

|id |name |name_abbreviation |decision_date |jurisdiction_id |jurisdiction |court|court_id |
|:--------|:--------|:----|:-------------|:---------------|:------------|:---|:--------|
|5525368  | ... |Roe v. Wade       |1970-06-17    |39              |us           |United States District Court for the Northern District of Texas |9170     |

It is possible to filter the returned cases by a variety of attributes, see `?cl_get_cases`. You can also limit the number of requests using `limit`, which is useful in some scenarios to save time and prevent API abuse.

To access opinions, you must specify a case ID. The result is a tidy data frame with one row per opinion. The full text of the opinion is included in the `text` column. 

```{r}
cl_get_case_opinions("11957048")
```


|case_id  |judges |attorneys |head_matter |author|text|type|
|:--------|:--|:----|:---|:-----|:-----|:-----------|
|11957048 |Blackmun, J., delivered the opinion...|Sarah Weddington reargued ...|ROE et al. v. WADE, ...|Mr. Justice Blackmun| This Texas federal appeal... |majority    |

Many packages exist for further analysis of this text data, see `tidytext` for examples. We also provide a brief example analysis in the package vignette.

## API Keys

The Case Law API is publicly accessible, but some capabilities are limited unless you register for an account and receive an API key. The details are covered extensively on the Case Law website. Once you have an API key, simply set an environment variable and it will be automatically used:

```
Sys.setenv(CASE_LAW_API_KEY="YOUR_API_KEY")
```

We recommend adding the environment variable to a R environment file so it is automatically available in your session.
