confint_ztor <- function(ma_obj) {
  ci <- confint(ma_obj)
  grad_transf.ztor <- function(z) 1/cosh(z)^2
  mean_es <- predict(ma_obj)$pred[1]
  vt <- ma_obj$vt * grad_transf.ztor(mean_es)^2
  ci$random[1,] <- ci$random[1,] * grad_transf.ztor(mean_es)^2
  ci$random[2,][ci$random[1,] >= 0] <- sqrt(ci$random[1,][ci$random[1,] >= 0])
  ci$random[2,][ci$random[1,] < 0]  <- NA
  ci$random[3,] <- 100 * ci$random[1,] / (ci$random[1,] + vt)
  ci$random[4,] <- ci$random[1,] / vt + 1
  return(ci)
}

create_newmods <- function(ma_obj, data = "grid", verbose = FALSE, ...) {
  if (!is.data.frame(data) && !identical(data, "grid")) {
    stop("`data` must either be 'grid' or a data frame.")
  }
  mod_data <- insight::get_data(ma_obj, verbose = verbose)
  if (!is.null(ma_obj$formula.yi)) {
    mod_formula <- formula(ma_obj, type = "yi")
  } else {
    mod_formula <- formula(ma_obj, type = "mods")
    mod_formula[[3]] <- mod_formula[[2]]
    mod_formula[[2]] <- ma_obj$call$yi
  }
  mod_terms <- stats::delete.response(terms(mod_formula, data = mod_data))
  dummy_mod <- lm(mod_formula, data = mod_data)
  mod_xlev <- dummy_mod$xlev
  mod_contrasts <- dummy_mod$contrasts
  if (identical(data, "grid")) {
    mod_frame <- modelbased::visualisation_matrix(
      model.frame(mod_terms, data = mod_data, xlev = mod_xlev)
    )
  } else {
    mod_frame <- model.frame(mod_terms, data = data, xlev = mod_xlev)
  }
  mod_matrix <- model.matrix(mod_terms, mod_frame, contrasts.arg = mod_contrasts)[,-1, drop = FALSE]
  mod_matrix <- mod_matrix[,intersect(colnames(mod_matrix), colnames(ma_obj$X)), drop = FALSE]
  attr(mod_matrix, "model") <- mod_frame
  return(mod_matrix)
}

get_tau_ci <- function(ma_obj) {
  as.data.frame(confint(ma_obj)$random)[2,] |>
    setNames(c("tau", "tau.ci.lb", "tau.ci.ub"))
}

clean_rma_predictions <- function(x, data = NULL) {
  predictions <- dplyr::select(as.data.frame(x), -any_of(c("cr.lb", "cr.ub")))
  rownames(predictions) <- NULL
  if (!is.null(data)) {
    if (is.matrix(data)) {
      cbind(attr(data, "model"), predictions)
    } else {
      cbind(data, predictions)
    }
  } else {
    predictions
  }
}
