# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define copper 50 mg/L data vectors
copper_50_0h <- c(10.89089822, 0, 0, 0, 0, 0, 0, 0, 6.337101598, 
                  5.411457544, 0, 0, 0, 0, 4.691101183)

copper_50_1h <- c(0, 0, 0, 0, 13.3933778, 0, 0, 0, 32.22367134, 
                  41.72552314, 24.5320915, 21.60126641, 22.19039185, 
                  12.14399554, 0, 0, 0, 10.99523921)

copper_50_4h <- c(0, 37.95912162, 46.01893511, 0, 0, 0, 0, 0, 0, 
                  0, 25.07001689, 23.65762157, 0, 0, 11.01436808)

# Combine into one vector
values <- c(copper_50_0h, copper_50_1h, copper_50_4h)

# Create grouping factor
groups <- factor(c(
  rep("0.1h", length(copper_50_0h)),
  rep("1.5h", length(copper_50_1h)),
  rep("4h", length(copper_50_4h))
), levels = c("0.1h", "1.5h", "4h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output
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
