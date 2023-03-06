# Exercise D

Use the `metadat::dat.bangertdrowns2004` dataset in metadat. 
This dataset contains results from 48 studies on the 
effectiveness of writing to learn interventions on academic achievement.
See `?metadat::dat.bangertdrowns2004` for details.

The dataset already contains computed `yi` and `vi` values, so no need for `escalc()`.

1. Fit a mixed effects model using these data with `length` as a continuous predictor.
   Use the `"REML"` estimator for tau.
   
   A. Is length of treatment related to treatment effectiveness? How so?
   
   B. What does the intercept mean in this model?
      
   C. Interpret R^2, F (or QM), and QE for this model.
   
   D. Compute a confidence interval for the mean and a prediction interval
      for individual true outcomes. Interpret these.
      
   E. Compute a confidence interval for tau and interpret it.
      
   F. Create a forest plot for these results.
      What do the grey diamonds for each study mean here?
      
2. Compare effectiveness for different grade levels.

  A. Convert `grade` to a factor variable and relabel the levels from `1:4`, to
     `c("Elementary", "Middle", "High school", "College")`.
     
  B. Fit a meta-regression model with `grade` as a predictor. 
     What are the estimated mean outcomes for each grade level?
     What is tau?
     
  C. Fit separate subgroup models for the Elementary and High School studies.
     How do results of these models differ from the results from the meta-regression?
     
  D. Fit a location-scale meta-regression model `grade` as a predictor. 
     How do results of these models differ from the results (B) and (C)?
      