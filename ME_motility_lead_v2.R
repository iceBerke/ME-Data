# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define your lead_200 data vectors
lead_200_0h <- c(42.70850363, 46.59109487, 34.25815799, 34.25815799, 
                 33.27935348, 33.81611725, 22.54407816, 58.23886859, 
                 48.53239049, 36.39929287, 29.11943429, 19.4129562, 
                 34.62851646, 45.29689779)

lead_200_1h <- c(83.82600592, 50.47587454, 28.65846356, 0, 52.5967096, 
                 12.77348662, 15.96685827, 7.708138476, 20.95650148, 
                 41.91300296, 36.0541961, 89.41440632, 53.95696933, 
                 98.77172791, 95.00280671, 74.51200527, 80.85345252)

lead_200_4h <- c(37.4134662, 16.49246673, 10.4006547, 37.4134662, 
                 6.012878496, 16.03434266, 13.74372228, 17.10329883, 
                 0, 0, 5.497488911, 0, 25.09723198, 12.28162416, 
                 8.017171328, 8.949400553)

lead_200_24h <- c(16.08111391, 21.9401244, 15.72375582, 20.07287977, 
                  38.04134473, 22.82480684, 26.2062597, 0, 14.74102108, 
                  0, 18.86850699, 30.76387009, 36.28559036, 36.28559036, 
                  51.27311681, 35.89118177)

# Combine into one vector
values <- c(lead_200_0h, lead_200_1h, lead_200_4h, lead_200_24h)

# Create grouping factor
groups <- factor(c(
  rep("0.1h", length(lead_200_0h)),
  rep("1.5h", length(lead_200_1h)),
  rep("4h", length(lead_200_4h)),
  rep("24h", length(lead_200_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis result
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "lead_100mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "lead_100mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
