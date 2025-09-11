# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define lead 200 mg/L data vectors
lead_200_0h <- c(21.95121951, 36.58536585, 51.2195122)
lead_200_1h <- c(11.14285714, 1.714285714, 0.857142857)
lead_200_4h <- c(11.70731707, 10.24390244, 5.12195122)
lead_200_24h <- c(1.006289308, 4.27672956, 1.194968553, 4, 0.566037736, 3.660377358)

# Combine into one vector and create grouping factor
values <- c(lead_200_0h, lead_200_1h, lead_200_4h, lead_200_24h)
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

# Save Kruskal–Wallis output rounded to 20 digits
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
