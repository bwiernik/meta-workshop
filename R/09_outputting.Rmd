---
title: "Meta-Analysis Example"
author: "Brenton M. Wiernik"
output: word_document
---

```{r setup, include=FALSE, echo=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(metafor)
library(knitr)
library(tidyverse)
```

Regualr text!

```{r}
# dat <- read_csv(file.path("data", "data_sheet.csv"))
```

```{r}
dat_bcg <- escalc(
  data = dat.bcg,
  measure = "RR",
  ai = tpos, bi = tneg, ci = cpos, di = cneg
) |>
  mutate(label = paste(author, year, sep = ", "))

mod_bcg_re <- rma(
  yi = yi ~ 1,
  vi = vi,
  slab = label,
  method = "REML", test = "knha",
  data = dat_bcg
)

predict(mod_bcg_re) |> 
  write_csv(file = "ma_results.csv")

predict(mod_bcg_re) |> 
  kable(digits = 2)
```

```{r}
forest(mod_bcg_re)
```

```{r}
funnel(mod_bcg_re)
```





