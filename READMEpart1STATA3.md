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
