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

# Part 2: Sampling Noise in an Infinite Superpopulation

## Objective

In Part 2, we look at how regression results behave when we keep randomly generating new samples from an infinite population. Each time, we draw a new dataset of a specific sample size, simulate the regression, and observe how the estimates change with larger and larger samples.

---

## Data Generation and Simulation

Each simulated dataset follows the same logic as in Part 1:
- 50% of observations are assigned to a treatment group
- Control group has a mean of 100
- Treatment group has a mean of 110
- Standard deviation = 10

The true treatment effect is again 10.

For each of the 26 different sample sizes, we:
- Randomly generated 500 datasets
- Ran a regression of `dep_var` on `treatment`
- Stored the beta estimate, standard error (SEM), and 95% confidence intervals

Sample sizes included both powers of 2 and powers of 10:
- Powers of 2 from 4 to 2,097,152
- N = 10, 100, 1,000, 10,000, 100,000, and 1,000,000

---

## Summary Table

<details>
<summary>Click to view full summary table</summary>


| N       | Beta     | SEM      | CI Lower   | CI Upper   |
|---------|----------|----------|------------|------------|
| 4       | 10.85    | 9.86     | -31.56     | 53.26      |
| 8       | 9.75     | 7.45     | -8.48      | 27.98      |
| 10      | 10.41    | 6.49     | -4.55      | 25.38      |
| 16      | 10.20    | 5.20     | -0.94      | 21.34      |
| 32      | 9.74     | 3.57     | 2.46       | 17.03      |
| 64      | 9.83     | 2.52     | 4.79       | 14.87      |
| 100     | 10.01    | 2.00     | 6.04       | 13.98      |
| 128     | 9.96     | 1.77     | 6.47       | 13.46      |
| 256     | 9.92     | 1.25     | 7.47       | 12.38      |
| 512     | 10.00    | 0.89     | 8.26       | 11.74      |
| 1000    | 10.01    | 0.63     | 8.77       | 11.25      |
| 1024    | 9.98     | 0.63     | 8.75       | 11.20      |
| 2048    | 9.98     | 0.44     | 9.11       | 10.84      |
| 4096    | 9.99     | 0.31     | 9.38       | 10.61      |
| 8192    | 9.99     | 0.22     | 9.56       | 10.42      |
| 10000   | 9.99     | 0.20     | 9.60       | 10.38      |
| 16384   | 10.00    | 0.16     | 9.69       | 10.30      |
| 32768   | 10.00    | 0.11     | 9.78       | 10.21      |
| 65536   | 10.00    | 0.08     | 9.85       | 10.15      |
| 100000  | 10.00    | 0.06     | 9.88       | 10.13      |
| 131072  | 10.00    | 0.06     | 9.89       | 10.11      |
| 262144  | 10.00    | 0.04     | 9.93       | 10.08      |
| 524288  | 9.99     | 0.03     | 9.95       | 10.05      |
| 1000000 | 10.00    | 0.02     | 9.96       | 10.04      |
| 1048576 | 10.00    | 0.02     | 9.96       | 10.04      |
| 2097152 | 10.00    | 0.01     | 9.97       | 10.03      |


</details>


---

## Graph of Beta Estimates and Confidence Intervals

The graph below shows how the estimated beta values (blue bars) and their 95% confidence intervals (gray lines) behave as sample size increases:

[Click here to view the Part 2 Graph (PDF)]((part2_graph.pdf)


---

## Interpretation

When the sample size is very small, like N = 4 or 8, the regression results are very unreliable. In some cases, the estimates are either missing or exactly zero. This happens because the sample is too small, and sometimes the treatment and control groups don’t have enough variation to run a proper regression. That’s why I replaced beta = 0 with missing (.) to clean the data.

As the sample size gets larger:
- The beta estimates move closer to the true effect (around 10)
- The standard error (SEM) becomes smaller
- The confidence intervals get tighter and more stable

By the time the sample size reaches 1,000 or more, the estimates are very accurate. The beta values stay close to 10, and the confidence intervals are very narrow. For very large samples like N = 100,000 or more, the results barely change at all — they are very consistent and precise.

This shows that:
- Small samples can give messy or random results
- Big samples help us get closer to the true effect
- Drawing new data each time from an infinite population gives more flexibility than using a fixed dataset (like in Part 1)

---
## Stata Code Used

<details>
<summary>Click to expand full Part 1 & 2 code</summary>

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

PART2

clear
capture program drop infinite_regression
program define infinite_regression, rclass
    args N

    clear
    set obs `N'

    gen rand = runiform()
    gen treatment = (rand < 0.5)

    local m1 = 100
    local m2 = 110
    local sd = 10

    gen dep_var = rnormal(`m1', `sd') if treatment == 0
    replace dep_var = rnormal(`m2', `sd') if treatment == 1

    regress dep_var treatment

    mat a = r(table)

    return scalar N = `N'
    return scalar beta = a[1,1]
    return scalar sem = a[2,1]
    return scalar p_value = a[4,1]
    return scalar ci_lower = a[5,1]
    return scalar ci_upper = a[6,1]
end

* Run simulations
clear
set more off
set seed 2025

local reps 500
local powers2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576 2097152
local powers10 10 100 1000 10000 100000 1000000
local all_N `powers2' `powers10'

foreach N of local all_N {
    simulate N=r(N) beta=r(beta) sem=r(sem) p_value=r(p_value) ///
        ci_lower=r(ci_lower) ci_upper=r(ci_upper), reps(`reps') nodots: ///
        infinite_regression `N'

    save "part2_sim_results_`N'.dta", replace
}

* Combine and summarize
clear
use "part2_sim_results_4.dta", clear
foreach N in 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576 2097152 10 100 1000 10000 100000 1000000 {
    append using "part2_sim_results_`N'.dta"
}
save "sim_results_all_part2.dta", replace

collapse (mean) beta sem ci_lower ci_upper, by(N)
rename beta beta_part2
rename sem sem_part2
rename ci_lower ci_lower_part2
rename ci_upper ci_upper_part2

save part2_summary.dta, replace
export excel using "part2_summary.xlsx", firstrow(variables) replace

* Generate graph
label define Nlbl ///
    1 "4" 2 "8" 3 "16" 4 "32" 5 "64" 6 "128" 7 "256" 8 "512" 9 "1024" ///
    10 "2048" 11 "4096" 12 "8192" 13 "16384" 14 "32768" 15 "65536" ///
    16 "131072" 17 "262144" 18 "524288" 19 "1048576" 20 "2097152" ///
    21 "10" 22 "100" 23 "1000" 24 "10000" 25 "100000" 26 "1000000"

gen x = _n
label values x Nlbl

twoway ///
    (rcap ci_upper ci_lower x, color(gs8)) ///
    (bar beta x, barwidth(0.5) color(blue)), ///
    title("Beta Estimates with 95% CI by Sample Size (N)") ///
    xtitle("Sample Size N") ytitle("Beta Estimate") ///
    xlabel(1(1)26, valuelabel angle(45)) ///
    legend(off)

