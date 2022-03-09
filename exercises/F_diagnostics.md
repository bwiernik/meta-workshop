# Exercise F

Use the `metafor::dat.bangertdrowns2004` dataset in metafor. 
This dataset contains results from 48 studies on the 
effectiveness of writing to learn interventions on academic achievement.
See `?metafor::dat.bangertdrowns2004` for details.

The dataset already contains computed `yi` and `vi` values, so no need for `escalc()`.

Fit a random effects model to these data.

  1. Create a leave-1-out forest plot.
     Does leaving out any study substantially change the results?
     
  2. Compute influence statistics for this model.
     Examine a table of values and plots of the values.
     Do any cases appear highly influential?
  
  3. Refit your model removing any influential cases.
     How do results change?
     
  4. Examine the distribution of standardized residuals.
     Do these appear to be normally distributed?
     
  5. Examine the distribution of estimated random effects.
     Do these appear to be normally distributed?
     
Fit a mixed effects model to the full dataset including length of treatment as
a moderator. 

  6. Examine the distribution of standardized residuals and 
     estimated random effects for this moderated model.
     Do these appear to be normally distributed?
     
  7. Does length appear to be linearly related to the outcome measure?
  
  8. Compute influence statistics for this model.
     Do any of the meta-regression coefficients change substantially when
     one case is removed?
     
  9. Remove any influential cases and re-estimate the mixed effects model
     How do results change?
     
