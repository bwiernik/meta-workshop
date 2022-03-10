library(metafor)
library(tidyverse)

# Datasets

## Magnesium - Heart Attack

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

dat_mg <- dat_mg |>
  mutate(
    weight = weights(mod_mg),
    sei = sqrt(vi)
  )

## Conscientiousness data

dat_consc <- data.frame(
  id = paste("Study", seq_len(113)),
  ni = c(55L,173L,150L,146L,147L,139L,109L,
         128L,261L,162L,121L,254L,106L,249L,114L,180L,94L,160L,
         201L,107L,174L,250L,630L,126L,154L,154L,130L,177L,
         158L,212L,73L,71L,101L,81L,168L,223L,135L,422L,121L,
         130L,152L,80L,96L,102L,104L,124L,574L,122L,131L,514L,
         338L,94L,395L,315L,105L,238L,188L,154L,145L,195L,99L,
         179L,251L,90L,40L,121L,222L,146L,133L,123L,207L,115L,
         226L,444L,223L,284L,43L,999L,146L,200L,144L,92L,146L,
         65L,125L,210L,143L,143L,129L,105L,157L,187L,39L,203L,
         64L,177L,197L,508L,163L,91L,78L,145L,106L,94L,136L,
         144L,120L,97L,69L,41L,136L,79L,20L),
  ri = c(0.14,0.09,0.29,0.25,0.26,0.27,0.25,
         0.11,0.13,0.21,0.23,0.14,0.19,0.18,0.23,0.08,0.34,0.08,
         0.2,-0.07,0.05,0.23,0.14,0.12,0.14,0.19,0.06,0.2,
         0.06,0.1,0.17,0.25,-0.08,0.18,0.01,0.24,0.3,0.12,0.13,
         0.29,0.09,0.08,0.23,0.1,0.31,0.24,0,0.29,0.11,0.07,
         0.24,-0.01,-0.1,0.11,0.13,0.19,0.19,0.3,0.27,0.29,0.26,
         0.15,0.14,0.24,0.29,0.29,0.21,0.27,0.23,-0.07,0.19,
         0.34,-0.01,0.11,0.25,0.06,0.02,0.08,0.24,0.25,0.15,
         0.01,0.2,-0.17,0.3,0.08,0.17,0.21,-0.01,0.33,0.15,-0.09,
         0.32,0.16,-0.11,0.34,-0.01,0.22,0.05,0.12,0.19,0.24,
         0.4,0.08,0.31,0.34,-0.03,0.09,0.13,0.17,0.19,0.21,
         0.51)
)

dat_consc <- escalc(
  data = dat_consc,
  measure = "ZCOR",
  ri = ri, ni = ni
)

mod_consc <- rma(yi = yi ~ 1, vi = vi, data = dat_consc, method = "REML", test = "knha", slab = id)

dat_consc <- dat_consc |>
  mutate(
    weight = weights(mod_consc),
    sei = sqrt(vi)
  )

# Funnel plot asymmetry

# Funnel plot
funnel(mod_mg) # with 95% CI around _mean effect size_
funnel(mod_mg, addtau2 = TRUE) # with 95% PI for individual true outcomes

## PET
pet <- regtest(mod_mg, predictor = "sei")
pet

rma(
  yi = yi ~ sei,
  vi = vi,
  data = dat_mg,
  method = "REML",
  test = "knha"
)

## PEESE
peese <- regtest(mod_mg, predictor = "vi")
peese

### Adding PET and PEESE regression lines to funnel plot

funnel(mod_mg, refline = 0) # centering funnel plot at 0
se <- seq(from = 0, to = max(dat_mg$sei) * 1.05, length.out = 100)
lines(x = coef(pet$fit)[1] + coef(pet$fit)[2] * se, y = se, lwd = 2, col = "darkblue")
lines(x = coef(peese$fit)[1] + coef(peese$fit)[2] * se^2, y = se, lwd = 2, lty = "dashed", col = "darkgreen")
abline(v = predict(mod_mg)$pred, lwd = 2)


## Trim and Fill
taf <- trimfill(mod_mg)
  ## specify side = "left" or side = "right" to control
  ##   which side censorship is expected on

taf
funnel(taf)


# Cumulative meta-analysis

## Magnesium
update(mod_mg, data = arrange(dat_mg, vi)) |>
  cumul()

update(mod_mg, data = arrange(dat_mg, vi)) |>
  cumul() |>
  forest()

## Conscientiousness
update(mod_consc, data = arrange(dat_consc, vi)) |>
  cumul() |>
  forest(top = 0)

## WAAP
estimate_power <- function(vi = NULL, sei = NULL, es, alpha = .05) {
  if (is.null(sei)) {
    if (is.null(vi)) stop("Either `vi` or `sei` must be supplied.")
    sei <- sqrt(vi)
  }
  q_alpha <- qnorm(alpha / 2, lower.tail = FALSE)
  pnorm(abs(es) / sei - q_alpha)
}

rma(yi ~ 1, vi = vi,
    data = filter(dat_mg, estimate_power(vi = vi, es = predict(mod_mg)$pred) >= .80),
    method = "REML", test = "knha")

rma(yi ~ 1, vi = vi,
    data = filter(dat_consc, estimate_power(vi = vi, es = predict(mod_consc)$pred) >= .80),
    method = "REML", test = "knha")



# Fail-safe N

## How many null-effect studies to raise the FE model p > .05?
with(dat_mg, fsn(yi, vi, type = "Rosenberg"))

## How many null-effect studies to reduce weighted mean effect below threshold?
##   - Must specify relevant target minimally-relevant effect size!
with(dat_mg, fsn(yi, vi, type = "Orwin", weighted = TRUE, target = log(.90)))


# p-value based methods

## contour-enhanced funnel plot
funnel(mod_mg,
       level=c(90, 95, 99),
       shade=c("white", "gray55", "gray75"),
       refline=0, legend=TRUE)

## p-uniform
with(dat_mg,
  puniform::puniform(yi = yi, vi = vi, side = "left")
)
  ## side = "left" or side = "right" to indicate which side of the
  ##   funnel plot the effects are on (not censored)


# Selection model
sel_logit <- selmodel(mod_mg, type = "logistic", alternative = "less")
  # alternative = "less" (left) or "greater" (right) to indicate which side
  # of the funnel plot the effects are on (not censored), or "two.sided" for either
sel_logit
plot(sel_logit)

## Using conscientiousness data

sel_logit <- selmodel(mod_consc, type = "logistic", alternative = "greater")
# alternative = "less" (left) or "greater" (right) to indicate which side
# of the funnel plot the effects are on (not censored), or "two.sided" for either
sel_logit
plot(sel_logit)

sel_step1 <- selmodel(mod_consc, type = "stepfun", steps = c(.05), alternative = "greater")
sel_step1
plot(sel_step1)

sel_step2 <- selmodel(mod_consc, type = "stepfun", steps = c(.01, .05), alternative = "greater")
sel_step2
plot(sel_step2)

