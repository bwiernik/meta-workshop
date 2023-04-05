# install the development version of metafor
# remotes::install_github("wviechtb/metafor")

library(tidyverse)
library(metafor)

# Multilevel meta-analyses

## School calendar data
dat_school <- dat.konstantopoulos2011

## Standard RE model
mod_school_re <- rma(
  yi = yi ~ 1, vi = vi,
  data = dat_school,
  method = "REML", test = "knha"
)
mod_school_re

# install.packages("clubSandwich")

## Robust model
mod_school_robust <- robust(
  mod_school_re,
  cluster = district,
  clubSandwich = TRUE
)
mod_school_robust


## Multilevel model
mod_school_ml <- rma.mv(
  yi = yi ~ 1,
  V = vi,
  random = ~ 1 | district / school,
  data = dat_school,
  method = "REML",
  test = "t",
  slab = study
)
mod_school_ml

forest(
  mod_school_ml,
  ilab = select(dat_school, district, school),
  ilab.xpos = c(-2.5, -1.5),
  header = TRUE,
  top = 1, cex = .75
)
text(x = c(-2.5, -1.5), y = 58, labels = c("District", "School"), font = 2, cex = .75)

# Multivariate meta-analyses

## Periodontal disease data
dat_teeth <- dat.berkey1998

## Compute within-sample variance-covariance matrix

### If all correlations among outcomes are known
V <- vcalc(
  data = dat_teeth,
  vi = 1,
  cluster = author,
  rvars = c(v1i, v2i)
)

### If some correlation information is missing
V <- vcalc(
  data = dat_teeth,
  vi = vi,
  cluster = author,
  type = outcome, rho = .5
)

  # Basic options with vcalc()
  #
  # - rvars = columns giving the full correlation matrix for the multiple outcomes
  #
  # - obs = column indicating the measure used for different measures of the same concept
  # - type = column indicating the construct/concept being measured
  # - rho = assumed correlation(s) for outcomes measured at the same time
  #     - Can be a single number (e.g., .50) or a whole matrix with row
  #       and column names
  #       rho = .5
  #       rho = psychmeta::reshape_vec2mat(
  #               cov = c(.5, .3, .4),
  #               var_names = c("A", "B", "C"),
  #               by_row = FALSE
  #             )
  #     - if both obs and type are provided, should be a list() giving
  #       first the correlations among observations of the same type, then
  #       second the correlations among different types
  #
  # - time1 = column indicating the time measures were taken
  # - phi = correlation among measures of the same variable at different times
  #   - can be a single number or a matrix like rho

## Use the known information

V <- vcalc(
  data = dat_teeth,
  vi = 1,
  cluster=author,
  rvars=c(v1i, v2i)
)

## Specify the model
mod_teeth_mv <- rma.mv(
  yi = yi ~ 0 + outcome,
  V = V,
  random = ~ outcome | author,
  struct = "UN",
  data = dat_teeth
)
mod_teeth_mv

anova(mod_teeth_mv, L = c(1, -1))

## rcalc()

rcalc(
  x = rxyi ~ x_name + y_name | sample_id,
  ni = n,
  rtoz = TRUE,
  data = psychmeta::data_r_meas_multi
)

