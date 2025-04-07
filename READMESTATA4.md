## Part 1: Power Calculations for Two-Group Experimental Design

In this section, we simulate a basic two-group experimental design to understand how treatment effects, attrition, and group imbalances affect power and required sample size.

We begin by generating a normally distributed outcome variable `Y` for 1,000 individuals with mean 0 and standard deviation 1. Then, we randomly assign the first 500 individuals to a treatment group and the rest to a control group. A treatment effect of 0.1 standard deviations is added only for the treated group, creating a new variable `Y_treat`.

Using Stata's `power twomeans` command, we calculate that a total sample size of approximately **3,142** individuals is needed to detect a treatment effect of 0.1 standard deviations with **80% power**, assuming equal group sizes and no attrition.

However, when accounting for a **15% expected attrition rate**, we adjust the sample size using the formula:

adjusted_n = 3142 / (1 - 0.15)


This gives us a revised required sample size of approximately **3,697 individuals**.

Finally, we explore how **unequal treatment assignment** affects the required sample size. When only **30% of the sample receives treatment** (`nratio(0.3)`), we find that the required sample increases to **4,424 individuals**, with **3,403 in control** and **1,021 in treatment**. This adjustment compensates for the reduced efficiency caused by the group size imbalance (control-to-treatment ratio ≈ 2.33).

This exercise highlights how **attrition** and **unequal treatment allocation** can increase the necessary sample size to maintain statistical power.

## Part 2: Power Calculations with Clustered Data
In Part 2, we simulate a clustered experimental design where schools are the unit of treatment and students are the observed units. Because students within the same school tend to be more similar to each other, we account for intra-class correlation (ICC), which we set at 0.3. We generate math scores by combining a school-level effect and individual random noise. Schools are randomly assigned to treatment or control groups, and a random treatment effect is applied to the treated schools.

We then examine how the design effect—which adjusts required sample size to account for clustering—increases with cluster size. Using the formula Design Effect = 1 + (m - 1) * ICC, we show that larger clusters require a larger total sample size to maintain statistical power. Based on practical considerations, we recommend using cluster sizes between 16 and 32 students per school.

Next, we calculate how many schools are needed to detect a 0.2 standard deviation (SD) treatment effect with 80% power. Using a cluster size of 15 students and ICC of 0.3, we find that around 1,090 schools are needed. Finally, we adjust for the case where only 70% of schools actually take up the treatment, which dilutes the effect size to 0.14 SD. Recalculating for this smaller effect, we find that approximately 557 schools would be needed to maintain 80% power.

This part highlights how clustering and imperfect treatment uptake both increase the required sample size, and why it’s important to adjust for these factors when planning an experiment.

## Part 3 – De-biasing a Parameter Estimate Using Controls
**Objective**
This exercise investigates how adding covariates and fixed effects influences the bias and variance of treatment effect estimates in regression models. The goal is to observe how different model specifications converge to the 'true' parameter as sample size increases.

**1. Data Generation Process**
- Strata Setup:
  - 5 strata (groups) were created with 200 students each, yielding 1000 observations.

- Covariates:
  - x1: Confounder affecting both treatment and outcome.
  - x2: Affects the outcome only.
  - x3: Affects treatment only.

- Treatment Assignment:
  - Treatment was assigned probabilistically based on a logistic model using x1 and x3.

- Outcome (Y):
  - The outcome was a function of:
    - True treatment effect: 0.5
    - x1, x2, and random noise
    - No effect from x3 on outcome

**2. Regression Models Estimated & Simulation**  
To assess how controlling for different covariates affects the accuracy of the treatment estimate, I ran five different regression models:

1. A naive model with treatment only.
2. A model controlling for the confounder x1.
3. A model including x1 and x2.
4. A model with x1, x2, and x3.
5. A model including all covariates plus fixed effects for strata.

I simulated these models across increasing sample sizes (from 100 to 2000) and repeated each setting 500 times. For each model, I collected the estimated treatment effect (beta) in every iteration. I then computed the average beta and standard deviation across simulations to understand the bias and variability of the estimates.

**3. Key Findings**
### Table 1: Mean Beta Estimates Across Models and Sample Sizes

| Sample Size (N) | Model 1 | Model 2 | Model 3 | Model 4 | Model 5 |
|-----------------|---------|---------|---------|---------|---------|
| 100             | 0.6984  | 0.5232  | 0.5203  | 0.5258  | 0.5039  |
| 250             | 0.6833  | 0.5209  | 0.5084  | 0.5127  | 0.5027  |
| 500             | 0.6760  | 0.5299  | 0.5053  | 0.5033  | 0.5034  |
| 1000            | 0.6698  | 0.4961  | 0.4981  | 0.4971  | 0.4987  |
| 2000            | 0.6792  | 0.5058  | 0.5040  | 0.5053  | 0.5040  |

Table 1 shows the mean estimated treatment effect (i.e., the average beta coefficient on the treatment variable) across 300 simulation runs for each model and sample size. As the sample size increases from 100 to 2000, the treatment effect estimates from Models 2 to 5 get closer to the true effect of 0.5, which was set during the data generation process. This means that controlling for confounders and including fixed effects improves the accuracy of our estimate. Model 1, which only includes the treatment variable and no controls, consistently overestimates the treatment effect because it fails to account for omitted variable bias. In contrast, the later models (especially Model 5, which includes fixed effects for strata) provide more reliable and accurate estimates.


### Table 2: Standard Deviation of Beta Estimates Across Models and Sample Sizes

| Sample Size (N) | Model 1 | Model 2 | Model 3 | Model 4 | Model 5 |
|-----------------|---------|---------|---------|---------|---------|
| 100             | 0.274   | 0.2574  | 0.2475  | 0.264   | 0.2275  |
| 250             | 0.1563  | 0.1478  | 0.1384  | 0.1483  | 0.132   |
| 500             | 0.1172  | 0.1092  | 0.1094  | 0.1094  | 0.0999  |
| 1000            | 0.0839  | 0.0797  | 0.0766  | 0.0806  | 0.0697  |
| 2000            | 0.0568  | 0.0541  | 0.0522  | 0.0551  | 0.0489  |

Table 2 presents the standard deviation of the treatment effect estimates for each model at different sample sizes. This tells us how much the estimates vary across the 300 simulations. A smaller standard deviation means the model produces more consistent and stable estimates. As the sample size increases, the standard deviation decreases across all models, which reflects greater precision with more data. Models that include relevant covariates (Models 2 to 5) generally show lower variability than Model 1, with Model 5 performing the best. This demonstrates the importance of using controls and fixed effects to reduce noise and increase the reliability of our estimated treatment effect.

<img width="871" alt="Screenshot 2025-04-06 at 9 22 51 PM" src="https://github.com/user-attachments/assets/c9a1b2b3-5cd9-4793-9542-60c0672c7bfe" />

This graph shows how the average estimate of the treatment effect (beta) changes with different sample sizes for each of the five models. The horizontal dashed line represents the "true" beta value, which is 0.5. Model 1, shown in blue, consistently overestimates the treatment effect because it does not control for any covariates, it’s a naive model. As more covariates and fixed effects are added in Models 2 through 5, the estimates move closer to the true value of 0.5, especially as the sample size increases. This tells us that including important control variables and accounting for group-level effects improves the accuracy of our treatment effect estimate. Overall, Model 5 performs the best, staying very close to the true value across all sample sizes.

<img width="509" alt="Screenshot 2025-04-06 at 11 08 26 PM" src="https://github.com/user-attachments/assets/ab336301-bf1d-492a-bcc8-ef3de9a3fbb3" />

This graph shows how the standard deviation (SD) of the beta estimate for treatment changes with increasing sample size across five different models. The SD tells us how much variation there is in the estimated treatment effect across different simulation runs. As we can see, all the lines slope downward, which means that as the sample size increases, the estimates become more stable and less spread out. In simple terms, bigger sample sizes give us more consistent estimates. Among all models, Model 5 (in purple), which includes strata fixed effects, shows the lowest standard deviation, especially as sample size grows. This tells us that adding proper controls and fixed effects not only helps with bias (as we saw earlier) but also makes our estimates more precise. Model 1 (blue), which uses no controls, has the highest SD, making it the least reliable. Overall, this graph supports the idea that better model specifications and larger samples lead to more dependable results.

<img width="869" alt="Screenshot 2025-04-06 at 11 28 13 PM" src="https://github.com/user-attachments/assets/2ed605b5-f6a4-4821-b3ca-7b8aa5069c50" />

Model 1, which only includes the treatment variable, shows the widest spread and the highest estimates, meaning it tends to overestimate the true effect and has more variability. As we move to Model 2, Model 3, and so on, more control variables and fixed effects are added, which help reduce bias and improve accuracy. Model 5, which includes all covariates and strata fixed effects, shows the tightest box centered around the true value, indicating the most accurate and consistent estimates.


These findings highlight the importance of controlling for confounders and using fixed effects in clustered data to get accurate treatment effect estimates. The graphs comparing the mean and standard deviation of treatment effects across models and sample sizes clearly illustrated the convergence of well-specified models to the true parameter value.





