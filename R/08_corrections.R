library(psychmeta)

# For a detailed walkthrough of using psychmeta to meta-analyze
# correlations, see:
vignette("ma_r", package = "psychmeta")

dat_r <- data_r_meas_multi

# Compute corrected effect sizes individually
# (e.g., for use with metafor)

dat_c <- with(dat_r,
  correct_r(
    correction = "meas",   # see ?correct_r for details
    rxyi = rxyi,
    rxx = rxxi,
    ryy = ryyi,
    n = n
  )
)$correlations$rtp

head(dat_c)

dat_c <- cbind(
  dat_r, ri = dat_c$value, ni = dat_c$n_effective
)

dat_c <- escalc(
  measure = "ZCOR",
  ri = ri, ni = ni,
  data = dat_c
)

head(dat_c)

# Individual corrections meta-analysis
ma_ic <- ma_r(
  data = dat_r,
  rxyi = rxyi,
  n = n,
  rxx = rxxi, ryy = ryyi,
  ma_method = "ic",
  wt_type = "REML", # default is sample size
  construct_x = x_name,
  construct_y = y_name,
  facet_x = NULL, facet_y = NULL, # specify these to indicate constructe subtypes
  moderators = moderator,
  cat_moderators = c(TRUE),
  sample_id = sample_id
)

summary(ma_ic)
# prediction intervals not yet available

# get data for further examination with metafor
dat_corrected <- get_escalc(ma_ic)[[1]]$individual_correction$true_score

## See the vignette above for other details

## variance method is always HSk`
## measure is always UCOR

## Correcting for range restriction
ma_r(
  data = data_r_bvirr,
  rxyi = rxyi,
  n = n,
  rxx = rxxi, ryy = ryyi,
  ux = ux, uy = uy,
  indirect_rr_x = TRUE, indirect_rr_y = TRUE,
  ma_method = "ic",
  wt_type = "REML" # default is sample size
)

## Artefact distribution example

dat_ability <- data_r_gonzalezmule_2014 |>
  mutate(year = str_extract("\\d{4}"))

mod_ability <- ma_r(
  data = dat_ability,
  rxyi = rxyi,
  n = n,
  rxx = rxxi, ryy = ryyi,
  ux = "ux",
  ma_method = "ad",
  wt_type = "REML", # default is sample size
  construct_x = x_name,
  construct_y = y_name,
  facet_x = NULL, facet_y = NULL, # specify these to indicate constructe subtypes
  moderators = c("Rating source", "Complexity", "Year"),
  cat_moderators = c(TRUE, TRUE, FALSE),
  sample_id = Study
)

# get data for further examination with metafor
dat_corrected <- get_escalc(mod_ability)[[1]]$artifact_distribution$true_score

