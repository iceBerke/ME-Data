# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define copper 50 mg/L data vectors
copper_50_0h <- c(80.72289157, 121.686747, 91.56626506)
copper_50_1h <- c(59.15492958, 25.24647887, 63.38028169, 24.82394366, 63.38028169, 17.11267606)
copper_50_4h <- c(23.59649123, 21.14035088, 21.84210526)
copper_50_24h <- c(8.75, 11.5625, 13.75)

# Combine into one vector and create grouping factor
values <- c(copper_50_0h, copper_50_1h, copper_50_4h, copper_50_24h)
groups <- factor(c(
  rep("0.1h", length(copper_50_0h)),
  rep("1.5h", length(copper_50_1h)),
  rep("4h", length(copper_50_4h)),
  rep("24h", length(copper_50_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "copper_25mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "copper_25mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
