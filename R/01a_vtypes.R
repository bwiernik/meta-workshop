library(metafor)

# Different sampling error variance formulas available for each
# effect size metric are described in the help for `escalc()`.
# Search for your effect size measure to see the options.

?escalc

# eg., for `measure "SMD"`, available options are:
#   - LS : large-sample equation, using sample-specific effect size estimates
#   - AV : large-sample equation, using mean effect size across samples
#
#   - LS2, UB : minor adjustments to LS, relatively rarely used
#
#   My recommendation: Use AV for best results

escalc(
  data = dat.normand1999,
  measure = "SMD",
  vtype = "LS",
  m1i = m1i, sd1i = sd1i, n1i = n1i,
  m2i = m2i, sd2i = sd2i, n2i = n2i
) |>
  head()

escalc(
  data = dat.normand1999,
  measure = "SMD",
  vtype = "AV",
  m1i = m1i, sd1i = sd1i, n1i = n1i,
  m2i = m2i, sd2i = sd2i, n2i = n2i
) |>
  head()

escalc(
  data = dat.normand1999,
  measure = "SMD",
  vtype = "LS2",
  m1i = m1i, sd1i = sd1i, n1i = n1i,
  m2i = m2i, sd2i = sd2i, n2i = n2i
) |>
  head()

escalc(
  data = dat.normand1999,
  measure = "SMD",
  vtype = "UB",
  m1i = m1i, sd1i = sd1i, n1i = n1i,
  m2i = m2i, sd2i = sd2i, n2i = n2i
) |>
  head()


# eg., for `measure "UCOR"`, available options are:
#   - LS : large-sample equation, using sample-specific effect size estimates
#   - AV : large-sample equation, using mean effect size across samples
#
#   - UB : minor adjustments to LS, relatively rarely used
#
#   My recommendation: Use AV for best results


# You might get an error indicating you need to install the 'gsl' package.
#   If so, run:
#   install.packages("gsl")
escalc(
  data = dat.mcdaniel1994,
  measure = "UCOR",
  vtype = "LS",
  ri = ri,
  ni = ni
) |>
  head() # show just the first 6 rows

escalc(
  data = dat.mcdaniel1994,
  measure = "UCOR",
  vtype = "UB",
  ri = ri,
  ni = ni
) |>
  head() # show just the first 6 rows

escalc(
  data = dat.mcdaniel1994,
  measure = "UCOR",
  vtype = "AV",
  ri = ri,
  ni = ni
) |>
  head() # show just the first 6 rows


