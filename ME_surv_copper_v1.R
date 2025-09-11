# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define copper 200 mg/L data vectors
copper_200_0h <- c(67.84452297, 65.72438163, 91.16607774)
copper_200_1h <- c(0.286956522, 0.074782609, 0.347826087, 0.237391304, 0.27826087, 0.082608696)
copper_200_4h <- c(0.002616279, 0.005755814, 0.005232558, 0.004011628, 0.003488372, 0.001569767)
copper_200_24h <- c(0, 0, 0, 0, 0, 0)

# Combine into one vector and create grouping factor
values <- c(copper_200_0h, copper_200_1h, copper_200_4h, copper_200_24h)
groups <- factor(c(
  rep("0.1h", length(copper_200_0h)),
  rep("1.5h", length(copper_200_1h)),
  rep("4h", length(copper_200_4h)),
  rep("24h", length(copper_200_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output rounded to 20 digits
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "copper_100mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "copper_100mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
