# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define copper 10 mg/L data vectors
copper_10_0h <- c(90.10600707, 87.98586572, 103.8869258)
copper_10_1h <- c(93.91304348, 88.69565217, 100.8695652)
copper_10_4h <- c(95.05813953, 109.8837209, 107.2674419)
copper_10_24h <- c(90.26086957, 83.47826087, 83.47826087, 151.3043478, 97.04347826, 83.47826087)

# Combine into one vector and create grouping factor
values <- c(copper_10_0h, copper_10_1h, copper_10_4h, copper_10_24h)
groups <- factor(c(
  rep("0.1h", length(copper_10_0h)),
  rep("1.5h", length(copper_10_1h)),
  rep("4h", length(copper_10_4h)),
  rep("24h", length(copper_10_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "copper_5mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "copper_5mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
