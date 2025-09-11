# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define lead 100 mg/L data vectors
lead_100_0h <- c(44.11764706, 52.94117647, 61.76470588)
lead_100_1h <- c(48.64864865, 60.81081081, 72.97297297, 69.72972973, 64.86486486, 93.24324324)
lead_100_4h <- c(83.72093023, 76.74418605, 83.72093023, 113.7209302, 111.627907, 111.627907)
lead_100_24h <- c(101.3513514, 73.47972973, 81.08108108, 95.77702703, 65.87837838, 119.5945946)

# Combine into one vector and create grouping factor
values <- c(lead_100_0h, lead_100_1h, lead_100_4h, lead_100_24h)
groups <- factor(c(
  rep("0.1h", length(lead_100_0h)),
  rep("1.5h", length(lead_100_1h)),
  rep("4h", length(lead_100_4h)),
  rep("24h", length(lead_100_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "lead_50mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "lead_50mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
