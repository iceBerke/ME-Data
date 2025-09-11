# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define nickel 200 mg/L data vectors
nickel_200_0h <- c(107.1428571, 158.9285714, 110.7142857)
nickel_200_1h <- c(21.88073394, 20.77981651, 28.0733945)
nickel_200_4h <- c(16.5060241, 12.28915663, 16.62650602)
nickel_200_24h <- c(1.636363636, 0.927272727, 2.090909091, 0.931818182, 1.954545455, 1.1)

# Combine into one vector and create grouping factor
values <- c(nickel_200_0h, nickel_200_1h, nickel_200_4h, nickel_200_24h)
groups <- factor(c(
  rep("0.1h", length(nickel_200_0h)),
  rep("1.5h", length(nickel_200_1h)),
  rep("4h", length(nickel_200_4h)),
  rep("24h", length(nickel_200_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "nickel_100mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "nickel_100mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
