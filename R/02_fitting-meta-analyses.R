library(metafor)  # for fitting meta-analyses
library(tidyverse) # for dplyr

dat <- escalc(
  data = dat.bcg,
  measure = "RR", # log risk ratio
  # measure = "OR", # log odds ratio
  ai = tpos, bi = tneg, ci = cpos, di = cneg
) |>
  mutate(label = paste(author, year, sep = ", "))

# Forest plots of data
forest(dat$yi, vi = dat$vi)

with(dat,
  forest(yi, vi = vi, slab = label, header = TRUE)
)

# Equal effects model
m_ee <- rma(
  yi = yi ~ 1, # yi = formula for meta-regression model
  # yi = yi,   #   Can omit the ~ 1 if just an intercept
  vi = vi,     # vi = variable holidng sampling variance
  # sei = sqrt(vi),  # alternatives to vi
  # weights = ni,
  data = dat,   # data = dataset for the model
  method = "EE", # method = type of model / tau estimator
  test = "t" # default is test = "z"
)
m_ee

# Fixed effects model
m_fe <- rma(
  yi = yi ~ 1,
  # yi = yi,   # Can omit the ~ 1 if just an intercept
  vi = vi,
  # sei = sqrt(vi),
  # weights = ni,
  data = dat,
  method = "FE",
  test = "t"
)

# Random effects model
m_re <- rma(
  yi = yi ~ 1,
  # yi = yi,   # Can omit the ~ 1 if just an intercept
  vi = vi,
  # sei = sqrt(vi),
  # weights = wt,
  data = dat,
  method = "REML",  # REML is default, so you can omit if desired
  test = "knha"     # knha = t with some bias correction related to tau
)

## with sample-size weights
m_re_nwt <- rma(
  yi = yi ~ 1,
  # yi = yi,   # Can omit the ~ 1 if just an intercept
  vi = vi,
  # sei = sqrt(vi),
  weights = n,
  data = dat,
  method = "REML",  # REML is default, so you can omit if desired
  test = "knha"
)

m_re
predict(m_re)

predict(m_re, transf = exp)

# use update() to refit the model and add the `slab` argument
m_re <- update(m_re, slab = label)
forest(m_re, header = TRUE, addpred = TRUE)

forest(m_re, header = TRUE, addpred = TRUE, transf = exp)

