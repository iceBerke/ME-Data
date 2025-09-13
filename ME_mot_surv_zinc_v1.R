# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define zinc 10 mg/L data vectors
zinc_10_1h <- c(22.4278729, 0, 0, 0, 9.868264075, 9.488715457, 10.72637399, 
                0, 10.72637399, 10.27944175, 0, 0)

zinc_10_4h <- c(0, 30.15730157, 0, 0, 18.55833943, 0, 7.539325392, 
                0, 0, 0, 8.319255605, 10.05243386, 20.10486771)

zinc_10_24h <- c(0, 0, 0, 0, 30.30965791, 12.12386316, 9.30939493, 
                 4.827093667, 14.21798498, 15.03825335, 0, 0)

# Combine into one vector
values <- c(zinc_10_1h, zinc_10_4h, zinc_10_24h)

# Create grouping factor
groups <- factor(c(
  rep("1.5h", length(zinc_10_1h)),
  rep("4h", length(zinc_10_4h)),
  rep("24h", length(zinc_10_24h))
), levels = c("1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output
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
