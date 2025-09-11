# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define nickel 50 mg/L data vectors
nickel_50_0h <- c(78.57142857, 95.91836735, 127.5510204)
nickel_50_1h <- c(103.880597, 115.5223881, 87.76119403)
nickel_50_4h <- c(61.55660377, 62.97169811, 20.51886792)
nickel_50_24h <- c(60.9375, 34.96875, 58.125, 39, 68.4375, 36.84375)

# Combine into one vector and create grouping factor
values <- c(nickel_50_0h, nickel_50_1h, nickel_50_4h, nickel_50_24h)
groups <- factor(c(
  rep("0.1h", length(nickel_50_0h)),
  rep("1.5h", length(nickel_50_1h)),
  rep("4h", length(nickel_50_4h)),
  rep("24h", length(nickel_50_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "nickel_25mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "nickel_25mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
