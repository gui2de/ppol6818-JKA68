# Part 1: Sampling Noise in a Fixed Population

## Objective

This part looks at how random sampling affects regression results in a fixed population. We take many random samples of different sizes and run regressions on each one. By doing this, we see how the size of the sample changes the accuracy of the estimated effect (beta), how much it varies (SEM), and how wide the confidence intervals are.

---

## Data Generation Process

A fixed population of 10,000 individuals was created with a binary treatment variable (`treatment`) randomly assigned (50/50 split). The dependent variable (`dep_var`) was drawn from a normal distribution:
- Mean = 100 for control group
- Mean = 110 for treated group
- Standard deviation = 10 for both groups

This simulates a true treatment effect of 10 units.

---

## Simulation and Analysis

A Stata program was written to:
1. Randomly draw a sample of size N from the fixed population.
2. Run a regression of `dep_var` on `treatment`.
3. Return key regression statistics: beta, SEM, p-value, and 95% confidence intervals.

Simulations were repeated **500 times each** for sample sizes:
- N = 10
- N = 100
- N = 1,000
- N = 10,000

---

## Results Table

| Sample Size (N) | Mean Beta | Mean SEM | Mean CI Lower | Mean CI Upper |
|-----------------|-----------|----------|----------------|----------------|
| 10              | 9.38      | 6.53     | -5.67          | 24.47          |
| 100             | 9.69      | 1.99     | 5.73           | 13.65          |
| 1,000           | 9.90      | 0.63     | 8.66           | 11.14          |
| 10,000          | 9.91      | 0.20     | 9.52           | 10.30          |

---

## Histogram of Beta Estimates

[View Beta Estimates Graph (PDF)](beta_estimates_graph.pdf)
As sample size increases:
- Beta estimates become more tightly centered around 10
- SEM and confidence intervals shrink
- Distribution appears more normal and narrow

## Interpretation

When we take small samples (like N = 10 or N = 100), the beta estimates from the regression vary a lot. The results can be quite far from the true effect of 10, and the confidence intervals are wide. This means the estimates are not very reliable — the regression is affected by sampling noise.

As the sample size increases (N = 1,000), the estimates get closer to 10, and the standard error becomes smaller. The confidence intervals also start to narrow, making the estimates more stable.

### What Happens When N = 10,000?

When we use a large sample size like N = 10,000, the beta estimates become very consistent. The graph shows that almost all the estimates fall within a very narrow range, tightly clustered around the true value of 10.
This means:
- The regression is very precise
- The standard error is very low
- The confidence interval is very tight

Because the sample is so large, there's very little randomness or noise, so we can be much more confident that the estimated effect is close to the true effect.

This happens because large samples reduce randomness and give us more accurate estimates of the true effect.

---
---

## Stata Code Used

Below is the full Stata code used to generate the fixed population, run simulations, and graph results.

<details>
<summary>Click to expand full code</summary>

```stata
*--------------------------------------------------*
* Step 1: Create a fixed population and save it   *
*--------------------------------------------------*
clear
set seed 12345  
set obs 10000   

gen rand = runiform()
gen treatment = (rand < 0.5)

local m1 = 100   // mean for control
local m2 = 110   // mean for treatment
local sd = 10    // same standard deviation for both

gen dep_var = rnormal(`m1', `sd') if treatment == 0
replace dep_var = rnormal(`m2', `sd') if treatment == 1

save "fixed_population.dta", replace

*--------------------------------------------------*
* Step 2: Define a program to sample and regress  *
*--------------------------------------------------*
capture program drop sample_regression
program define sample_regression, rclass
    args N  

    use "fixed_population.dta", clear  
    sample `N', count  

    regress dep_var treatment
	
    mat a = r(table)

    return scalar N = `N'
    return scalar beta = a[1,1]  // Coefficient of treatment
    return scalar sem = a[2,1]   // Standard Error
    return scalar p_value = a[4,1]  // P-value
    return scalar ci_lower = a[5,1]
    return scalar ci_upper = a[6,1]
end

* Testing the program
sample_regression 100
return list

*--------------------------------------------------*
* Step 3: Run simulations for different N values  *
*--------------------------------------------------*
clear
set seed 12345

local reps 500
local N_list 10 100 1000 10000

foreach N in `N_list' {
    display "Running simulations for sample size: `N'"

    simulate N=r(N) beta=r(beta) sem=r(sem) p_value=r(p_value) ///
        ci_lower=r(ci_lower) ci_upper=r(ci_upper), reps(`reps'): ///
        sample_regression `N'

    save "sim_results_`N'.dta", replace  
}

*--------------------------------------------------*
* Step 4: Combine, summarize, and graph results   *
*--------------------------------------------------*
clear
set more off

use "sim_results_10.dta", clear
append using "sim_results_100.dta"
append using "sim_results_1000.dta"
append using "sim_results_10000.dta"

save "sim_results_all.dta", replace

use "sim_results_all.dta", clear 

collapse (mean) beta sem ci_lower ci_upper, by(N)
list  

rename beta beta_part1
rename sem sem_part1
rename ci_lower ci_lower_part1
rename ci_upper ci_upper_part1

* Save the summary
save part1_summary.dta, replace
	
* N = 10
use "sim_results_10.dta", clear
histogram beta, bin(30) normal ///
    title("N = 10") xtitle("Beta") name(h10, replace)

* N = 100
use "sim_results_100.dta", clear
histogram beta, bin(30) normal ///
    title("N = 100") xtitle("Beta") name(h100, replace)

* N = 1000
use "sim_results_1000.dta", clear
histogram beta, bin(30) normal ///
    title("N = 1000") xtitle("Beta") name(h1000, replace)

* N = 10000
use "sim_results_10000.dta", clear
histogram beta, bin(30) normal ///
    title("N = 10000") xtitle("Beta") name(h10000, replace)
	
graph combine h10 h100 h1000 h10000, ///
    title("Beta Estimates Across Different Sample Sizes") ///
    cols(2)

save "final_results.dta", replace
