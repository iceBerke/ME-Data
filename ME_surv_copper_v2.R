# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define copper 100 mg/L data vectors
copper_100_0h <- c(128.9156627, 75.90361446, 122.8915663)
copper_100_1h <- c(14.57746479, 16.47887324, 10.14084507)
copper_100_4h <- c(5.271929825, 5.263157895, 5.552631579)
copper_100_24h <- c(0.28125, 0.45, 1.03125, 0.609375, 0.4375, 0.45625)

# Combine into one vector and create grouping factor
values <- c(copper_100_0h, copper_100_1h, copper_100_4h, copper_100_24h)
groups <- factor(c(
  rep("0.1h", length(copper_100_0h)),
  rep("1.5h", length(copper_100_1h)),
  rep("4h", length(copper_100_4h)),
  rep("24h", length(copper_100_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "copper_50mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "copper_50mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
