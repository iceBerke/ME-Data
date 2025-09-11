# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define copper data vectors
copper_50_0h <- c(10.67220549, 0, 0, 0, 0, 0, 0, 0, 6.209850562, 5.302793738, 0, 0, 0, 0, 4.596902364)
copper_50_1h <- c(0, 0, 0, 0, 5.649741761, 0, 0, 0, 13.59294305, 17.60111856, 10.34839634, 9.112083505, 9.360594873, 5.122713612, 0, 0, 0, 4.638132595)
copper_50_4h <- c(0, 8.424261201, 10.2129742, 0, 0, 0, 0, 0, 0, 0, 5.56378445, 5.250331805, 0, 0, 2.444416775)

# Combine data and create factor variable for timepoints
values <- c(copper_50_0h, copper_50_1h, copper_50_4h)
timepoints <- factor(c(
  rep("0.1h", length(copper_50_0h)),
  rep("1.5h", length(copper_50_1h)),
  rep("4h", length(copper_50_4h))
), levels = c("0.1h", "1.5h", "4h"))

# Build dataframe
df <- data.frame(timepoint = timepoints, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal-Wallis output rounded to 20 digits
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
