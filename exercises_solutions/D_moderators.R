# Meta-regression - continuous moderators
dat_g <- dat.bangertdrowns2004 |>
  mutate(
    grade = factor(
      grade,
      levels = 1:4,
      labels = c("Elementary", "Middle", "High school", "College")
    )
  ) |>
  drop_na(grade, length)

mod_length <- rma(
  yi = yi ~ 1 + length,
  vi = vi,
  slab = paste(author, year),
  method = "REML", test = "knha",
  data = dat_g
)

newmods <- create_newmods(
  mod_length,
  data = data.frame(length = c(1, 4, 10, 15, 24))
)

predict_length <- predict(mod_length, newmods = newmods) |>
  clean_rma_predictions(data = newmods)

predict_length


mod_lengthGrade <- rma(
  yi = yi ~ 1 + length * grade,
  vi = vi,
  slab = paste(author, year),
  method = "REML", test = "knha",
  data = dat_g
)

newmods <- create_newmods(
  mod_lengthGrade,
  data = expand_grid(
    length = c(1, 4, 10, 15, 24),
    grade = levels(dat_g$grade)
  )
)

predict_lengthGrade <- predict(mod_lengthGrade, newmods = newmods) |>
  clean_rma_predictions(data = newmods)

predict_lengthGrade


# Subgroup analysis - categorical variables
mod_elementary <- rma(
  yi = yi ~ 1,
  vi = vi,
  slab = paste(author, year),
  method = "REML", test = "knha",
  data = filter(dat_g, grade == "Elementary")
)

mod_highschool <- rma(
  yi = yi ~ 1,
  vi = vi,
  slab = paste(author, year),
  method = "REML", test = "knha",
  data = filter(dat_g, grade == "High school")
)

predict(mod_elementary)
confint(mod_elementary)

predict(mod_highschool)
confint(mod_highschool)

## Automating the subgroup modeling
mods_grade <- dat_g |>
  arrange(grade) |>
  group_by(grade) |>
  nest() |>
  mutate(
    meta = list(rma(
      yi = yi ~ 1,
      vi = vi,
      slab = paste(author, year),
      method = "REML", test = "knha",
      data = data
    ))
  ) |>
  mutate(
    meta = setNames(meta, grade),
    k = map(meta, \(ma) ma$k),
    predict = map(meta, \(ma) clean_rma_predictions(predict(ma))),
    tau = map(meta, \(ma) get_tau_ci(ma))
  ) |>
  ungroup() |>
  tidyr::unnest(cols = c(k, predict, tau))

