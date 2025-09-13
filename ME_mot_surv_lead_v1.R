# Install and load required packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")
library(rstatix)
library(dplyr)

# Define lead 200 mg/L data vectors
lead_200_0h <- c(116.7365766, 127.3489926, 93.63896518, 93.63896518, 90.96356618, 
                 92.43072047, 61.62048031, 159.1862408, 132.6552007, 99.49140051, 
                 79.59312041, 53.06208027, 94.65127832, 123.8115206)

lead_200_1h <- c(1833.69388, 1104.159755, 626.9038905, 0, 1150.553022, 279.4200197, 
                 349.2750247, 168.6155292, 458.4234699, 916.8469398, 788.6855396, 
                 1955.940138, 1180.308704, 2160.631548, 2078.186397, 1629.950115, 1768.669274)

lead_200_4h <- c(414.5816525, 182.7543611, 115.250498, 414.5816525, 66.62919415, 
                 177.6778511, 152.2953009, 189.5230411, 0, 0, 60.91812036, 0, 
                 278.1044625, 136.0936732, 88.83892553, 99.16903315)

lead_200_24h <- c(656.1754777, 895.2471634, 641.5938004, 819.0559155, 1552.243066, 
                  931.3458393, 1069.323001, 0, 601.4941879, 0, 769.9125605, 
                  1255.292218, 1480.601078, 1480.601078, 2092.153697, 1464.507588)

# Combine all values into one vector
values <- c(lead_200_0h, lead_200_1h, lead_200_4h, lead_200_24h)

# Create grouping factor
groups <- factor(c(
  rep("0.1h", length(lead_200_0h)),
  rep("1.5h", length(lead_200_1h)),
  rep("4h", length(lead_200_4h)),
  rep("24h", length(lead_200_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

# Build dataframe
df <- data.frame(timepoint = groups, value = values)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ timepoint)
print(kw_test)

# Save Kruskal–Wallis output (rounded)
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "lead_100mgL_kruskal_wallis_result.csv", row.names = FALSE)

# Dunn's posthoc test if KW is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ timepoint, p.adjust.method = "holm")
  print(dunn_results)
  
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "lead_100mgL_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis is NOT significant (p > 0.05), skipping posthoc.\n")
}
