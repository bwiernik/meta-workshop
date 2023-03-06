# Exercise B

Use the `metadat::dat.normand1999` dataset in metafor. 
This dataset contains results from 9 studies on length of 
hospital stay in days for stroke patients who receive
either specialized care or routine care.
See `?metadat::dat.normand1999` for details.
      
1. Make a new dataset with **standardized mean differences**, but compute the
   sampling error variance for studies by using the **average effect size** 
   across the included studies by adding the argument `vtype = "AV"` to your 
   `escalc()` call. 
   
   A. Make a forest plot of these data. Include study labels.
   
   B. Fit random-effects, fixed-effects, and equal-effects meta-analyses 
      using these data. Interpret the results for each model appropriately.
   
   C. Make a forest plot of your random-effects model results.
      Include study labels and a prediction interval on this plot.
      
2. Make a dataset with **raw mean differences** (`measure = "MD"`).

   A. Fit a random-effects meta-analysis using these data and interpret 
      the results.
    
   B. What are benefits and limitations of using raw versus standardized effect
      sizes in research?
      

Use the `metadat::dat.crede2010` dataset in metafor. 
This dataset contains results from 97 studies on the 
association between study time and college course performance.
See `?metadat::dat.crede2010` for details.

3. Make a dataset with **unbiased correlations** as the effect size.
   Use the average effect size to compute sampling error variances.
   Include only rows where `criterion` is equal to `"grade"`.
   
   A. Fit a random effects model to these data and interpret the results.
   
   B. Compute a confidence interval for the mean and a prediction interval
      for individual studies. Interpret these.

4. Make a dataset with **z-transformed correlations** as the effect size.
   Include only rows where `criterion` is equal to `"grade"`.
   
   A. Fit a random effects model to these data.
      Compute a confidence interval for the mean and a prediction interval
      for individual studies for **correlations** by back-transforming.
      