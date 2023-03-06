# Exercise E

Use the `metadat::dat.hackshaw1998` dataset in metadat. 
This dataset contains results from 37 studies on the 
risk of lung cancer due to environmental tobacco smoke (ETS) exposure.
See `?metadat::dat.hackshaw1998` for details.

The dataset already contains log **odds** ratios (`yi`) and variances (`vi`)
so no need for `escalc()`.

The log odds ratios were computed so that values greater than 0 indicate 
an increased risk of cancer in exposed women compared to women not 
exposed to ETS from their spouse.

Fit a random effects model to these data.

  1. Compute and interpret the mean odds ratio, the 95% confidence interval
     for the mean, and the 95% prediction interval for true outcomes.
     
  2. Create a funnel plot for these data. 
     Does the plot suggest potential for publiccation bias?
     What sort of studies appear to be missing (if any)? 
     (i.e., what size of effects would those missing studies have?)
     
  3. Estimate PET and PEESE regression tests. 
     Make a funnel plot with regression lines from these models.
     What do these tests suggest? 
     What is our best estimate for a "bias-free" mean effect based on these models?
     
  4. Conduct a cumulative meta-analysis and plot the results.
     What does this plot suggest?
     Compute the WAAP estimate of the meta-analysis model.
     
  5. Fit selection models (eithe logistic, or step, or both if possible).
     If you fit a step model, think about appropriate p value thresholds.
     Think about the possible direction of the selection; 
       what should the 'alternative' argument be set to?)
     Do these models suggest a possible selection effect?
