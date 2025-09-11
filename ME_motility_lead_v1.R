# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define your lead data vectors
lead_10_0h <- c(66.62094442, 73.28303887, 62.81403331, 57.57953054, 
                87.93964664, 87.93964664, 73.28303887, 85.49687868, 
                54.96227915, 97.71071849, 99.93141664, 161.9940859, 
                161.9940859)

lead_10_1h <- c(85.93549768, 54.38514254, 50.55029275, 53.52383938, 
                83.19133893, 85.63814301, 68.24289521, 64.22860726, 
                92.77465493, 113.7381587, 101.1005855, 113.7381587)

lead_10_4h <- c(93.37284287, 96.66835497, 120.8354437, 126.5895125, 
                56.10217029, 73.36437654, 75.52215232, 73.23360225, 
                56.64161424, 58.94411888, 60.41772186, 69.41610596, 
                64.27417219, 80.55696247)

lead_10_24h <- c(95.79164447, 106.3367006, 111.5793473, 92.98278938, 
                 142.1603535, 151.0453756, 113.676018, 92.26753715, 
                 163.5651795, 108.2862068, 134.6352838, 116.2284867, 
                 109.043453)

# Combine into one vector
values <- c(lead_10_0h, lead_10_1h, lead_10_4h, lead_10_24h)

# Create grouping factor
groups <- factor(c(
  rep("0.1h", length(lead_10_0h)),
  rep("1.5h", length(lead_10_1h)),
  rep("4h", length(lead_10_4h)),
  rep("24h", length(lead_10_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "lead_5mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "lead_5mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
