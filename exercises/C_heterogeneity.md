# Exercise C

Use the `metafor::dat.bangertdrowns2004` dataset in metafor. 
This dataset contains results from 48 studies on the 
effectiveness of writing to learn interventions on academic achievement.
See `?metafor::dat.bangertdrowns2004` for details.

The dataset already contains computed `yi` and `vi` values, so no need for `escalc()`.

Fit a random effects model using these data.
Use either the `"HSk"` or `"DL"` estimator for tau. 
Then, fit a second model using the `"REML"` estimator for tau.
   
   A. Compare the estimate of tau for the two models.
   
   B. Interpret the results of the REML model, including the regression
      coefficients and tau.
      
   C. Compute a confidence interval for the mean and a prediction interval
      for individual true outcomes. Interpret these.
      
   D. Compute a confidence interval for tau and interpret it.
      Also interpret tau^2, I^2, and H^2.
      
   E. Create a forest plot for these results.
      Be sure to include a prediction interval.
      
   F. Compute BLUPs from this model. 
      What do these values mean?   
      Which studies will be adjusted the most?
