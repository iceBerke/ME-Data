# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define zinc 200 mg/L data vectors
zinc_200_0h <- c(80, 77.14285714, 80)
zinc_200_1h <- c(23.63636364, 10.36363636, 29.09090909, 14.18181818, 41.81818182, 16.90909091)
zinc_200_4h <- c(3.75, 5.0625, 5.25)
zinc_200_24h <- c(0.205882353, 0.138235294, 0.333333333, 0.168627451, 0.019607843, 0.076470588)

# Combine into one vector and create grouping factor
values <- c(zinc_200_0h, zinc_200_1h, zinc_200_4h, zinc_200_24h)
groups <- factor(c(
  rep("0.1h", length(zinc_200_0h)),
  rep("1.5h", length(zinc_200_1h)),
  rep("4h", length(zinc_200_4h)),
  rep("24h", length(zinc_200_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "zinc_100mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "zinc_100mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
