library(tidyverse)
library(metafor)

# Load helper functions to facilitate predictions
source("ma_helper_functions.R")

# Meta-regression - continuous moderators

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

mod_bcg_re
predict(mod_bcg_re, transf = exp)

# Somewhat more accurate back-transformation
predict(mod_bcg_re, transf = transf.exp.int, targs = list(tau2 = mod_bcg_re$tau2))

# add latitude as a predictor

mod_bcg_lat <- rma(
  yi = yi ~ 1 + ablat,
  vi = vi,
  slab = label,
  method = "REML", test = "knha",
  data = dat_bcg
)

mod_bcg_lat
mod_bcg_re$tau2

# Forest plot
forest(mod_bcg_lat)

# Predictions

## Original data
predict(mod_bcg_lat, transf = exp) |>
  clean_rma_predictions(data = select(dat_bcg, label, ablat)) |>
  arrange(ablat) |>
  as_tibble()


## Specific moderator values

# create_newmods() is a helper function contained in the "ma_helper_functions.R" file
#   - Be sure to source() this file or copy the function into your script!
newmods <- create_newmods(
  mod_bcg_lat,
  data = data.frame(ablat = c(10, 30, 50))
)

predict(mod_bcg_lat, newmods = newmods, transf = exp) |>
  clean_rma_predictions(data = newmods) |>
  arrange(-ablat) |>
  as_tibble() # prettier printing

# if the data argument is omitted, create_newmods() will pick a range of values
#   from the data. This can be useful for plotting
create_newmods(
  mod_bcg_lat
)

# bubble/scatter plots

## log(RR)
regplot(
  mod_bcg_lat,
  pi = TRUE,
  refline = 0,
  label = c(7, 12),
  xlab="Absolute Latitude"
)

## RR
regplot(
  mod_bcg_lat,
  pi = TRUE,
  transf = exp, refline = 1,
  label = c(7, 12),
  xlab="Absolute Latitude"
)

# Meta-regression -- categorical moderators

dat_interview <- dat.mcdaniel1994 |>
  mutate(
    struct = factor(
      struct,
      levels = c("u", "s"),
      labels = c("Unstructured", "Structured")
    ),
    type = factor(
      type,
      levels = c("j", "p", "s"),
      labels = c("Job-related", "Psychological", "Situational")
    )
  )

# You might get an error indicating you need to install the 'gsl' package.
#   If so, run:
#   install.packages("gsl")
dat_interview <- escalc(
  measure = "ZCOR",
  ri = ri,
  ni = ni,
  vtype = "AV",
  data = dat_interview
) |>
  drop_na(struct, type)


mod_interview_re <- rma(
  yi = yi ~ 1,
  vi = vi,
  slab = study,
  method = "REML", test = "knha",
  data = dat_interview
)
mod_interview_re

mod_interview_struct <- rma(
  yi = yi ~ 1 + struct,
  vi = vi,
  slab = study,
  method = "REML", test = "knha",
  data = dat_interview
)
mod_interview_struct


newmods <- create_newmods(mod_interview_struct)

predict(mod_interview_struct, newmods = newmods) |>
  clean_rma_predictions(data = newmods) |>
  as_tibble()


# Interaction between categorical moderators
mod_interview_structType <- rma(
  yi = yi ~ 1 + struct * type,
  vi = vi,
  slab = study,
  method = "REML", test = "knha",
  data = dat_interview
)
mod_interview_structType

newmods <- create_newmods(mod_interview_structType)

predict_structType <- predict(mod_interview_structType, newmods = newmods) |>
  clean_rma_predictions(data = newmods) |>
  as_tibble()

predict_structType

## Add sample size information
dat_interview |>
  group_by(struct, type) |>
  summarize(N = sum(ni), k = n()) |>
  ungroup() |>
  tidyr::complete(struct, type) |>
  full_join(predict_structType)
