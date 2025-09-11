# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define your zinc_10 data vectors
zinc_10_0h <- c(62.09083827, 70.30874333, 52.85113019, 50.59253488, 88.93219022, 86.23727537, 64.03117696, 74.70303979, 72.72676889, 81.30943106, 43.17811167, 40.65471553)
zinc_10_1h <- c(11.48578945, 0, 0, 0, 5.05374736, 4.859372461, 5.493203652, 0, 5.493203652, 5.264320166, 0, 0)
zinc_10_4h <- c(0, 17.58547648, 0, 0, 10.82183168, 0, 4.396369119, 0, 0, 0, 4.851165925, 5.861825493, 11.72365099)
zinc_10_24h <- c(0, 0, 0, 0, 23.27702487, 9.310809947, 7.149371923, 3.707081738, 10.91904076, 11.54898541, 0, 0)

# Combine data and create timepoint factor
values <- c(zinc_10_0h, zinc_10_1h, zinc_10_4h, zinc_10_24h)
groups <- factor(c(
  rep("0.1h", length(zinc_10_0h)),
  rep("1.5h", length(zinc_10_1h)),
  rep("4h", length(zinc_10_4h)),
  rep("24h", length(zinc_10_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

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
