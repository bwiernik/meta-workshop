library(tidyverse)
library(metafor)

dat_mg <- filter(dat.egger2001, study != "Bertschat", study != "ISIS-4")

dat_mg <- escalc(
  data = dat_mg,
  measure = "RR",
  ai = ai, n1i = n1i,
  ci = ci, n2i = n2i,
  add = .5, to = "if0all"
) |>
  mutate(
    slab = paste(study, year, sep = ", ")
  )

mod_mg <- rma(
  yi ~ 1, vi = vi, data = dat_mg, method = "REML", test = "knha", slab = slab)
mod_mg

# Leave-1-Out diagnostics
mod_loo <- leave1out(mod_mg)

mod_loo

range(mod_loo$estimate)
range(sqrt(mod_loo$tau2))

par(mfrow = c(2, 1)) # stack 2 metafor plots on top of each other -- 2 rows, 1 column
hist(mod_loo$estimate, xlab = "mean", main = "Histogram of LOO mean estimates")
hist(sqrt(mod_loo$tau2), xlab = "tau", main = "Histogram of LOO tau estimates")

plot(mod_loo$estimate, type = "l",
     xlab = "Study", ylab = "LOO mean estimate")
plot(sqrt(mod_loo$tau2), type = "l",
     xlab = "Study", ylab = "LOO tau estimate")

par(mfrow = c(1, 1))
with(mod_loo,
     forest(
       x = estimate,
       ci.lb = ci.lb, ci.ub = ci.ub,
       refline = predict(mod_mg)$pred, slab = mod_mg$slab,
       top = 0
     )
)

# Influence diagnostics
mod_infl <- influence(mod_mg)

mod_infl

plot(mod_infl)

dat_mg <- mutate(dat_mg, wt = weights(mod_mg))
dat_mg[13, "wt"] <- median(dat_mg$wt)

mod_mg_sensitivy <- rma(
  yi = yi, vi = vi, data = dat_mg, weights = wt, test =
)

# Normality assumption

## Residuals
qqnorm(mod_mg)

## Random effects
qqnorm(ranef(mod_mg)$pred)
qqline(ranef(mod_mg)$pred)


# Linearity and homogeneity assumptions

dat_bcg <- escalc(
  data = dat.bcg,
  measure = "RR",
  ai = tpos, bi = tneg, ci = cpos, di = cneg
) |>
  mutate(label = paste(author, year, sep = ", "))

mod_bcg_lat <- rma(
  yi = yi ~ 1 + ablat,
  vi = vi,
  slab = label,
  method = "REML", test = "knha",
  data = dat_bcg
)


# Linearity

qplot(
  x = fitted(mod_bcg_lat), y = residuals(mod_bcg_lat, type = "rstudent")
) +
  labs(
    x = "Predicted values", y = "Standardized residuals"
  ) +
  theme_bw() +
  geom_hline(yintercept = 0) +
  geom_smooth()

# Homogeneity of residuals
qplot(
  x = fitted(mod_bcg_lat), y = sqrt(abs(residuals(mod_bcg_lat, type = "rstudent")))
) +
  labs(
    x = "Predicted values", y = "sqrt( | Std. residuals | )"
  ) +
  theme_bw() +
  geom_smooth()

# Homogeneity of random effects
qplot(
  x = fitted(mod_bcg_lat), y = sqrt(abs(ranef(mod_bcg_lat)$pred))
) +
  labs(
    x = "Predicted values", y = "sqrt( | Random effects | )"
  ) +
  theme_bw() +
  geom_smooth()

