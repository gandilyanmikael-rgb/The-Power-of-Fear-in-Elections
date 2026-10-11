# The Power of Fear: Fear of Crime and Vote Choice in Maryland's 2024 U.S. Senate Race

Does fear of becoming a crime victim shape how people vote?

This project uses a **500-respondent YouGov survey of Maryland voters** to test whether respondents' fear of being robbed predicts their vote choice in the **2024 U.S. Senate race between Angela Alsobrooks (D) and Larry Hogan (R)**. It uses a **survey-weighted logistic regression** that controls for urban residence and gender.

*Final project for GVPT320: Advanced Empirical Research, University of Maryland, Spring 2025.*

---

## Key Findings

- **More fear, less support for Alsobrooks.** With controls for urban residence and gender, respondents who rated their own chance of being robbed as higher were less likely to support Alsobrooks (b = −0.011). Each 10-point increase in expected likelihood of robbery reduces the odds of an Alsobrooks vote by about **11%**.
- **The effect is large across the full range of fear.** For urban women, the predicted probability of an Alsobrooks vote falls from **76%** at no fear of robbery to **50%** at maximum fear. For non-urban men, it falls from **54%** to **28%**.
- **Residence and gender matter as well.** Urban residents and women were more likely to support Alsobrooks at every level of fear.

| Group | Predicted Alsobrooks vote (no fear) | Predicted Alsobrooks vote (maximum fear) |
|---|---|---|
| Urban women | 76% | 50% |
| Urban men | 66% | 39% |
| Non-urban women | 65% | 38% |
| Non-urban men | 54% | 28% |

## Variables

| Role | Variable | Survey item | Coding |
|---|---|---|---|
| **Dependent** | Alsobrooks vote | `Question2`: Senate vote choice | 1 = Alsobrooks, 0 = any other choice |
| **Independent** | Fear of robbery | `Question21`: respondent's estimated chance of being robbed | 0–100 scale; "don't know" responses excluded |
| **Control** | Urban | `urbanicity2`: type of area lived in | 1 = big or smaller city, 0 = suburb, small town or rural area |
| **Control** | Female | `gender` | 1 = female, 0 = male |

All descriptive statistics and models use YouGov's survey weights (`weight`).

## Methods

1. **Descriptive statistics.** Weighted frequencies, means, medians and modes for each variable, plus a histogram of fear of robbery (Figure 1).
2. **Handling missing urbanicity data.** 120 respondents were not asked the urbanicity question. Their values were imputed by random assignment so that 30.89% were coded as urban, using a fixed seed (`123`) so the results can be reproduced.
3. **Bivariate model.** A survey-weighted logistic regression of Alsobrooks vote on fear of robbery alone.
4. **Multivariate model.** The same model with the urban and female controls added. Results are reported as coefficients and odds ratios with confidence intervals.
5. **Predicted probabilities.** The probability of an Alsobrooks vote across the full 0–100 fear scale for each combination of residence and gender (Figure 2).

## Figures Produced

1. Histogram of robbery expectations
2. Probability of an Alsobrooks vote by fear of robbery, controlling for residence and gender

## Repository Contents

```
├── README.md
└── power_of_fear_analysis.R    # Variable coding, descriptive statistics, regression models, figures
```

**The survey data is not included.** The data comes from a YouGov survey (`UNMD0007`) fielded for the University of Maryland, and it includes respondent-level details such as ZIP code and birth year.

## How to Run

1. **Install R** and the required packages:

   ```r
   install.packages(c("poliscidata", "survey"))
   ```

2. **Place the survey file** `UNMD0007_OUTPUT_strings.csv` in the same folder as the script.

3. **Run the script:**

   ```r
   source("power_of_fear_analysis.R")
   ```

## Limitations

- **Imputed urbanicity.** About a quarter of respondents weren't asked where they live, so their urban status was assigned at random. That adds noise to the urban control, and the exact estimates depend on the random seed.
- **Single-state survey.** The results describe Maryland voters in one election and may not generalize to other states or races.
- **Correlation, not causation.** Fear of crime may itself be shaped by partisanship or media consumption, and those variables aren't in the model.
- **Excluded responses.** Respondents who answered "don't know" on the fear question were dropped from the regression.

## Author

**Mikael Gandilyan**, M.S. Applied Political Analytics, University of Maryland
[LinkedIn](https://www.linkedin.com/in/mikael-gandilyan)
