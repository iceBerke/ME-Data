# Install and load required packages
if (!require("ARTool")) install.packages("ARTool")
if (!require("emmeans")) install.packages("emmeans")
library(ARTool)
library(emmeans)

# Input nickel data
nickel_200_0h <- c(107.1428571, 158.9285714, 110.7142857)
nickel_200_1h <- c(21.88073394, 20.77981651, 28.0733945)
nickel_200_4h <- c(16.5060241, 12.28915663, 16.62650602)
nickel_200_24h <- c(1.636363636, 0.927272727, 2.090909091, 0.931818182, 1.954545455, 1.1)
nickel_100_0h <- c(128.5714286, 101.0204082, 117.3469388)
nickel_100_1h <- c(94.92537313, 93.13432836, 70.74626866)
nickel_100_4h <- c(23.3490566, 12.73584906, 12.02830189)
nickel_100_24h <- c(39.375, 18.5625, 25.3125, 18.75, 40.3125, 12.65625)
nickel_50_0h <- c(78.57142857, 95.91836735, 127.5510204)
nickel_50_1h <- c(103.880597, 115.5223881, 87.76119403)
nickel_50_4h <- c(61.55660377, 62.97169811, 20.51886792)
nickel_50_24h <- c(60.9375, 34.96875, 58.125, 39, 68.4375, 36.84375)
nickel_10_0h <- c(142.8571429, 153.5714286, 166.0714286)
nickel_10_1h <- c(108.7155963, 108.7155963, 118.3486239)
nickel_10_4h <- c(104.8192771, 104.8192771, 86.74698795)
nickel_10_24h <- c(95.45454545, 90.90909091, 63.63636364)

# Combine your data into a data frame
values <- c(
  nickel_200_0h, nickel_200_1h, nickel_200_4h, nickel_200_24h,
  nickel_100_0h, nickel_100_1h, nickel_100_4h, nickel_100_24h,
  nickel_50_0h, nickel_50_1h, nickel_50_4h, nickel_50_24h,
  nickel_10_0h, nickel_10_1h, nickel_10_4h, nickel_10_24h
)

concentration <- factor(rep(c("100", "50", "25", "5"),
                            times = c(length(nickel_200_0h) + length(nickel_200_1h) + length(nickel_200_4h) + length(nickel_200_24h),
                                      length(nickel_100_0h) + length(nickel_100_1h) + length(nickel_100_4h) + length(nickel_100_24h),
                                      length(nickel_50_0h) + length(nickel_50_1h) + length(nickel_50_4h) + length(nickel_50_24h),
                                      length(nickel_10_0h) + length(nickel_10_1h) + length(nickel_10_4h) + length(nickel_10_24h)
                            )))

timepoint <- factor(c(
  rep("0.1h", length(nickel_200_0h)),
  rep("1.5h", length(nickel_200_1h)),
  rep("4h", length(nickel_200_4h)),
  rep("24h", length(nickel_200_24h)),
  rep("0.1h", length(nickel_100_0h)),
  rep("1.5h", length(nickel_100_1h)),
  rep("4h", length(nickel_100_4h)),
  rep("24h", length(nickel_100_24h)),
  rep("0.1h", length(nickel_50_0h)),
  rep("1.5h", length(nickel_50_1h)),
  rep("4h", length(nickel_50_4h)),
  rep("24h", length(nickel_50_24h)),
  rep("0.1h", length(nickel_10_0h)),
  rep("1.5h", length(nickel_10_1h)),
  rep("4h", length(nickel_10_4h)),
  rep("24h", length(nickel_10_24h))
))

df <- data.frame(value = values, concentration = concentration, timepoint = timepoint)

# Fit ART model
art_model <- art(value ~ concentration * timepoint, data = df)

# Run ANOVA and save results in an object
anova_results <- anova(art_model)
print(anova_results)

# Convert ANOVA results to a data frame and save as CSV
anova_df <- as.data.frame(anova_results)
write.csv(anova_df, "nickel_ART_ANOVA.csv", row.names = TRUE)

# Extract p-values for effects
p_values <- c(
  concentration = anova_results["concentration", "Pr(>F)"],
  timepoint     = anova_results["timepoint", "Pr(>F)"],
  interaction   = anova_results["concentration:timepoint", "Pr(>F)"]
)
print(p_values)

# Set significance threshold
alpha <- 0.05

# 1. Pairwise comparisons for concentration
if (!is.na(p_values["concentration"]) && p_values["concentration"] <= alpha) {
  conc_emm <- emmeans(artlm(art_model, "concentration"), pairwise ~ concentration, adjust = "holm")
  print(conc_emm$contrasts)
  write.csv(as.data.frame(conc_emm$contrasts),
            "nickel_concentration_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect for concentration; skipping pairwise comparisons.")
}

# 2. Pairwise comparisons for timepoint
if (!is.na(p_values["timepoint"]) && p_values["timepoint"] <= alpha) {
  time_emm <- emmeans(artlm(art_model, "timepoint"), pairwise ~ timepoint, adjust = "holm")
  print(time_emm$contrasts)
  write.csv(as.data.frame(time_emm$contrasts),
            "nickel_timepoint_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect for timepoint; skipping pairwise comparisons.")
}

# 3. Pairwise comparisons for interaction
if (!is.na(p_values["interaction"]) && p_values["interaction"] <= alpha) {
  inter_emm <- emmeans(artlm(art_model, "concentration:timepoint"),
                       pairwise ~ concentration * timepoint, adjust = "holm")
  print(inter_emm$contrasts)
  write.csv(as.data.frame(inter_emm$contrasts),
            "nickel_interaction_emmeans.csv", row.names = FALSE)
} else {
  message("No significant interaction effect; skipping pairwise comparisons.")
}
