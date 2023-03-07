library(metafor) # for escalc()
library(tidyverse) # for dplyr and ggplot2 functions

# See documentation for escalc() with:
?escalc

# Studies on the Length of Hospital Stay of Stroke Patients
dat_stroke <- escalc(
  data = dat.normand1999,
  measure = "SMD",
  # measure = "SMDH", # heterogeneous group SDs
  # measure = "SMD1", # control-group SD (sd2i); needs development version of metafor
  # vtype = "LS", # large-sample variance approximation (default)
  vtype = "AV", # compute variance using N-weighted average SMD across studies
  m1i = m1i, sd1i = sd1i, n1i = n1i,
  m2i = m2i, sd2i = sd2i, n2i = n2i
)
dat_stroke

dat_stroke_sd <- escalc(
  data = dat.normand1999,
  measure = "VR", # log-SD ratio
  # measure = "CVR", # log coefficient of variation ratio
  m1i = m1i, sd1i = sd1i, n1i = n1i,
  m2i = m2i, sd2i = sd2i, n2i = n2i
)
dat_stroke_sd

# Studies on the Relationship between Class Attendance and Grades in College Students
dat_attend <- escalc(
  data = dat.crede2010,
  measure = "ZCOR", # Fisher z-transformed correlations
  # measure = "UCOR", # unbiased raw correlations
  # vtype = "LS", # large-sample variance approximation (default)
  # vtype = "AV", # compute variance using N-weighted average correlation across studies
  ri = ri, ni = ni
)
dat_attend

# Studies on the Effectiveness of the BCG Vaccine Against Tuberculosis
dat_vaccine <- escalc(
  data = dat.bcg,
  measure = "RR", # log risk ratio
  # measure = "OR", # log odds ratio
  ai = tpos, bi = tneg, ci = cpos, di = cneg
)
dat_vaccine


# Constructing CIs for Stroke data
dat_stroke <- mutate(
  dat_stroke,
  ci.lb = yi - qnorm(.975) * sqrt(vi),
  ci.ub = yi + qnorm(.975) * sqrt(vi),
)
dat_stroke

# prettier printing
as_tibble(dat_stroke)


# Constructing CIs for Attendance data
dat_attend <- mutate(
  dat_attend,
  cor = transf.ztor(yi),
  ci.lb = transf.ztor(yi - qnorm(.975) * sqrt(vi)),
  ci.ub = transf.ztor(yi + qnorm(.975) * sqrt(vi))
)
as_tibble(dat_attend)


# Constructing CIs for Vaccine data
dat_vaccine <- mutate(
  dat_vaccine,
  rr = exp(yi),
  ci.lb = exp(yi - qnorm(.975) * sqrt(vi)),
  ci.ub = exp(yi + qnorm(.975) * sqrt(vi)),
)
as_tibble(dat_vaccine)


# Converting from t test statistics to d
d_from_t <- psychmeta::convert_es(
  es = 4.106,
  df1 = 30,
  n1 = 19,
  n2 = 13,
  input_es = "t",
  output_es = "d"
)
d_from_t

d_from_t$d
d_from_t$var_e

