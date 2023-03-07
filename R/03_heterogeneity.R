library(tidyverse)
library(metafor)

dat <- dat.mcdaniel1994 |>
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

dat <- escalc(
  measure = "ZCOR",
  ri = ri,
  ni = ni,
  data = dat
) |>
  drop_na(struct, type)


# tau estimators
mod_hs <- rma(
  yi = yi ~ 1,
  vi = vi,
  slab = study,
  method = "HS", test = "knha",
  data = dat
)
mod_hs

# confidence interval for tau, etc.
confint(mod_hs)

mod_hsk <- rma(
  yi = yi ~ 1,
  vi = vi,
  slab = study,
  method = "HSk", test = "knha",
  data = dat
)
confint(mod_hsk)

mod_dl <- rma(
  yi = yi ~ 1,
  vi = vi,
  slab = study,
  method = "DL", test = "knha",
  data = dat
)
confint(mod_dl)

mod_reml <- rma(
  yi = yi ~ 1,
  vi = vi,
  slab = study,
  method = "REML", test = "knha",
  data = dat
)
confint(mod_reml)


# Prediction intervals

## z-metric
predict(mod_reml)

## correlation metric
predict(mod_reml, transf = transf.ztor)

## slightly more accurate back transformation
predict(mod_reml, transf = transf.ztor.int, targs = list(tau2 = mod_reml$tau2, lower = -4, upper = 4))


# BLUPs
blup_z_reml <- blup(mod_reml)
head(blup_z_reml)

blup_r_reml <- blup(mod_reml, transf = transf.ztor)
head(blup_r_reml)

# compare observed effect sizes
par(mfrow = c(2, 1))
with(head(dat),
     forest(x = yi, vi = vi, header = TRUE, refline = predict(mod_reml)$pred, main = "Observed")
)
with(head(blup_z_reml),
  forest(x = pred, sei = se, header = TRUE, refline = predict(mod_reml)$pred, main = "BLUP")
)
par(mfrow = c(1, 1))


# BLUP forest plot
dat_plot <- cbind(
  select(dat, c(study, ni, ri)),
  as.data.frame(blup_r_reml)
)

ggplot(dat_plot) +
  aes(y = study) +
  geom_errorbarh(aes(xmin = pi.lb, xmax = pi.ub), color = "darkblue") +
  geom_point(aes(x = pred), shape = 18, color = "darkblue") +
  geom_point(aes(x = ri), shape = 16, color = "darkorange") +
  scale_size_continuous(range = c(1, 10)) +
  see::theme_modern() +
  labs(
    x = "Correlation", y = "Study"
  )

# BLUP shrinkage plot
dat_plot <- data.frame(
  Study = rep(dat$study, times = 2),
  N = rep(dat$ni, times = 2),
  Estimate = factor(
    c(rep("yi", times = nrow(dat)), rep("BLUP", times = nrow(dat))),
    levels = c("yi", "BLUP")
  ),
  Correlation = c(dat$ri, blup_r_reml$pred)
)

ggplot(dat_plot) +
  aes(x = Estimate, y = Correlation, group = Study) +
  geom_line(aes(alpha = N)) +
  geom_point(aes(size = N), shape = "+") +
  scale_size_continuous(range = c(1, 10)) +
  see::theme_modern()

