# Exercise A

Use the `metafor::dat.curtis1998` dataset in metafor. 
This dataset contains results from 27 studies on the
effects of CO2 levels on wood plant mass. 
See `?metafor::dat.curtis1998` for details.
   
1. Make a dataset with **standardized mean differences** (`measure = "SMD"`)
   as the effect size. Use the **sample effect size estimate** to compute
   the sampling error variance.
   
   A. Construct confidence intervals for each effect size using a normal distribution.
   
   B. Why might using the sample effect size estimate to compute sampling error
      variance be a problem?
    
      
2. Make a new dataset with **standardized mean differences**, but compute the
   sampling error variance for studies by using the **average effect size** 
   across the included studies. 
   
   A. Construct confidence intervals for each effect size using a normal distribtion.
   

Use the `metafor::dat.bornmann2007` dataset in metafor. 
This dataset contains results from 66 studies on gender differences in 
grant awards across different fields. 
See `?metafor::dat.bornmann2007` for details.

3. Make a dataset with **log risk ratios** as the effect size.

4. Make a dataset with **log odds ratios** as the effect size.


Use the `metafor::dat.cohen1981` dataset in metafor. 
This dataset contains results from 20 studies on correlations
between teacher ratings of student aptitude and student performance.
See `?metafor::dat.cohen1981` for details.

5. Make a dataset with **unbiased correlation** as the effect size.
   Use the average effect size to compute the sampling error variances.

6. Make a dataset with **z-transformed correlation** as the effect size.
   Compute 95% confidence intervals for each study using a normal
   distribution, then back-transform to the correlation metric.
