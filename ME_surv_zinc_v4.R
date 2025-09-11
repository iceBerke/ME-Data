# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define zinc 10 mg/L data vectors
zinc_10_0h <- c(111.4285714, 151.4285714, 154.2857143)
zinc_10_1h <- c(80, 30.18181818, 80, 35.63636364, 45.45454545, 36)
zinc_10_4h <- c(75, 34.875, 82.5, 40.875)
zinc_10_24h <- c(65.68627451, 91.17647059, 73.52941176)

# Combine into one vector and create grouping factor
values <- c(zinc_10_0h, zinc_10_1h, zinc_10_4h, zinc_10_24h)
groups <- factor(c(
  rep("0.1h", length(zinc_10_0h)),
  rep("1.5h", length(zinc_10_1h)),
  rep("4h", length(zinc_10_4h)),
  rep("24h", length(zinc_10_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "zinc_5mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "zinc_5mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
