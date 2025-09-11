# Install and load required packages
if (!require("ARTool")) install.packages("ARTool")
if (!require("emmeans")) install.packages("emmeans")
library(ARTool)
library(emmeans)

# Input lead data
lead_200_0h <- c(21.95121951, 36.58536585, 51.2195122)
lead_200_1h <- c(11.14285714, 1.714285714, 0.857142857)
lead_200_4h <- c(11.70731707, 10.24390244, 5.12195122)
lead_200_24h <- c(1.006289308, 4.27672956, 1.194968553, 4, 0.566037736, 3.660377358)
lead_100_0h <- c(44.11764706, 52.94117647, 61.76470588)
lead_100_1h <- c(48.64864865, 60.81081081, 72.97297297, 69.72972973, 64.86486486, 93.24324324)
lead_100_4h <- c(83.72093023, 76.74418605, 83.72093023, 113.7209302, 111.627907, 111.627907)
lead_100_24h <- c(101.3513514, 73.47972973, 81.08108108, 95.77702703, 65.87837838, 119.5945946)
lead_50_0h <- c(61.76470588, 123.5294118, 52.94117647)
lead_50_1h <- c(113.5135135, 83.51351351, 72.97297297, 74.59459459, 81.08108108, 84.32432432)
lead_50_4h <- c(111.627907, 109.5348837, 118.6046512, 97.6744186, 111.627907, 103.9534884)
lead_50_24h <- c(86.14864865, 99.32432432, 167.2297297, 109.9662162, 106.4189189, 108.9527027)
lead_10_0h <- c(95.12195122, 43.90243902, 80.48780488, 76.82926829, 36.58536585, 52.68292683)
lead_10_1h <- c(92.57142857, 111.4285714, 72.85714286, 120, 99.42857143)
lead_10_4h <- c(117.0731707, 100.9756098, 139.0243902, 98.7804878, 124.3902439, 100.2439024)
lead_10_24h <- c(158.490566, 133.3333333, 144.0251572)

# Combine data vectors
values <- c(
  lead_200_0h, lead_200_1h, lead_200_4h, lead_200_24h,
  lead_100_0h, lead_100_1h, lead_100_4h, lead_100_24h,
  lead_50_0h, lead_50_1h, lead_50_4h, lead_50_24h,
  lead_10_0h, lead_10_1h, lead_10_4h, lead_10_24h
)

# Construct factors
concentration <- factor(rep(c("100", "50", "25", "5"),
                            times = c(length(lead_200_0h) + length(lead_200_1h) + length(lead_200_4h) + length(lead_200_24h),
                                      length(lead_100_0h) + length(lead_100_1h) + length(lead_100_4h) + length(lead_100_24h),
                                      length(lead_50_0h) + length(lead_50_1h) + length(lead_50_4h) + length(lead_50_24h),
                                      length(lead_10_0h) + length(lead_10_1h) + length(lead_10_4h) + length(lead_10_24h))))

timepoint <- factor(c(
  rep("0.1h", length(lead_200_0h)),
  rep("1.5h", length(lead_200_1h)),
  rep("4h", length(lead_200_4h)),
  rep("24h", length(lead_200_24h)),
  rep("0.1h", length(lead_100_0h)),
  rep("1.5h", length(lead_100_1h)),
  rep("4h", length(lead_100_4h)),
  rep("24h", length(lead_100_24h)),
  rep("0.1h", length(lead_50_0h)),
  rep("1.5h", length(lead_50_1h)),
  rep("4h", length(lead_50_4h)),
  rep("24h", length(lead_50_24h)),
  rep("0.1h", length(lead_10_0h)),
  rep("1.5h", length(lead_10_1h)),
  rep("4h", length(lead_10_4h)),
  rep("24h", length(lead_10_24h))
))

# Create data frame
df <- data.frame(value = values, concentration = concentration, timepoint = timepoint)

# Fit ART model
art_model <- art(value ~ concentration * timepoint, data = df)

# Run ANOVA and print results
anova_results <- anova(art_model)
print(anova_results)

# Save ANOVA table as CSV
anova_df <- as.data.frame(anova_results)
write.csv(anova_df, "lead_final_ART_ANOVA.csv", row.names = TRUE)

# Extract p-values
p_values <- c(
  concentration = anova_results["concentration", "Pr(>F)"],
  timepoint = anova_results["timepoint", "Pr(>F)"],
  interaction = anova_results["concentration:timepoint", "Pr(>F)"]
)
print(p_values)

# Set alpha
alpha <- 0.05

# Pairwise tests for concentration
if (!is.na(p_values["concentration"]) && p_values["concentration"] <= alpha) {
  conc_emm <- emmeans(artlm(art_model, "concentration"), pairwise ~ concentration, adjust = "holm")
  print(conc_emm$contrasts)
  write.csv(as.data.frame(conc_emm$contrasts), "lead_final_concentration_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect of concentration; skipping pairwise tests.")
}

# Pairwise tests for timepoint
if (!is.na(p_values["timepoint"]) && p_values["timepoint"] <= alpha) {
  time_emm <- emmeans(artlm(art_model, "timepoint"), pairwise ~ timepoint, adjust = "holm")
  print(time_emm$contrasts)
  write.csv(as.data.frame(time_emm$contrasts), "lead_final_timepoint_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect of timepoint; skipping pairwise tests.")
}

# Pairwise tests for interaction
if (!is.na(p_values["interaction"]) && p_values["interaction"] <= alpha) {
  inter_emm <- emmeans(artlm(art_model, "concentration:timepoint"),
                       pairwise ~ concentration * timepoint, adjust = "holm")
  print(inter_emm$contrasts)
  write.csv(as.data.frame(inter_emm$contrasts), "lead_final_interaction_emmeans.csv", row.names = FALSE)
} else {
  message("No significant interaction effect; skipping pairwise tests.")
}
