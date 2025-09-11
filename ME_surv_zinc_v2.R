# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define zinc 100 mg/L data vectors
zinc_100_0h <- c(69.45812808, 56.15763547, 106.4039409)
zinc_100_1h <- c(59.39086294, 42.63959391, 36.54822335)
zinc_100_4h <- c(6.072874494, 4.129554656, 14.57489879, 5.829959514, 17.00404858, 5.222672065)
zinc_100_24h <- c(0, 0.10543131, 0.095846645, 0.153354633, 0.191693291, 0.067092652)

# Combine into one vector and create grouping factor
values <- c(zinc_100_0h, zinc_100_1h, zinc_100_4h, zinc_100_24h)
groups <- factor(c(
  rep("0.1h", length(zinc_100_0h)),
  rep("1.5h", length(zinc_100_1h)),
  rep("4h", length(zinc_100_4h)),
  rep("24h", length(zinc_100_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "zinc_50mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "zinc_50mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}