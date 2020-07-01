---
output: rmarkdown::github_document
---

# caselaw

The goal of caselaw is to provide an opinionated and tidy R package to make it easy to access the Harvard [Case Law Project](https://case.law).

## Installation

The development version of this package can be installed through:

```r
devtools::install_github("slopp/caselaw")
```

## Example

To access case metadata based on a search term or a variety of fields:

```{r}
library(caselaw)
cl_get_cases(name_abbreviation = "Roe v. Wade")
```

|id |name |name_abbreviation |decision_date |jurisdiction_id |jurisdiction |court|court_id |
|:--------|:--------|:----|:-------------|:---------------|:------------|:---|:--------|
|5525368  | ... |Roe v. Wade       |1970-06-17    |39              |us           |United States District Court for the Northern District of Texas |9170     |

To access case opinions:

```{r}
cl_get_case_opinions("11957048")
```


|case_id  |judges |attorneys |head_matter |author|text|type|
|:--------|:--|:----|:---|:-----|:-----|:-----------|
|11957048 |Blackmun, J., delivered the opinion...|Sarah Weddington reargued ...|ROE et al. v. WADE, ...|Mr. Justice Blackmun| This Texas federal appeal... |majority    |
