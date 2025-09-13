# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define nickel 100 mg/L new data vectors
nickel_100_1h <- c(29.55502688, 24.65127803, 35.54246767, 33.24940524, 
                   23.49245727, 31.23428977, 43.17200262, 11.24178937, 
                   17.73301613, 28.27795782, 38.98748227, 49.25837814, 
                   33.31657576, 42.41693673)

nickel_100_4h <- c(0, 0, 0, 0, 0, 83.15314686, 43.13960251, 0, 0, 0, 
                   55.16891474, 0)

nickel_100_24h <- c(76.21145676, 52.78074999, 0, 0, 18.61786729, 0, 
                    0, 0, 0, 18.12139083, 0, 0)

# Combine all values into one vector
values <- c(nickel_100_1h, nickel_100_4h, nickel_100_24h)

# Create grouping factor
groups <- factor(c(
  rep("1.5h", length(nickel_100_1h)),
  rep("4h", length(nickel_100_4h)),
  rep("24h", length(nickel_100_24h))
), levels = c("1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal–Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output (rounded)
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "nickel_50mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  
  # Round and save Dunn’s test results
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "nickel_50mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
