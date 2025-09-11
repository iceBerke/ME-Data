# Install and load required packages
if (!require("ARTool")) install.packages("ARTool")
if (!require("emmeans")) install.packages("emmeans")
library(ARTool)
library(emmeans)

# Input copper data
copper_200_0h <- c(67.84452297, 65.72438163, 91.16607774)
copper_200_1h <- c(0.286956522, 0.074782609, 0.347826087, 0.237391304, 0.27826087, 0.082608696)
copper_200_4h <- c(0.002616279, 0.005755814, 0.005232558, 0.004011628, 0.003488372, 0.001569767)
copper_200_24h <- c(0, 0, 0, 0, 0, 0)
copper_100_0h <- c(128.9156627, 75.90361446, 122.8915663)
copper_100_1h <- c(14.57746479, 16.47887324, 10.14084507)
copper_100_4h <- c(5.271929825, 5.263157895, 5.552631579)
copper_100_24h <- c(0.28125, 0.45, 1.03125, 0.609375, 0.4375, 0.45625)
copper_50_0h <- c(80.72289157, 121.686747, 91.56626506)
copper_50_1h <- c(59.15492958, 25.24647887, 63.38028169, 24.82394366, 63.38028169, 17.11267606)
copper_50_4h <- c(23.59649123, 21.14035088, 21.84210526)
copper_50_24h <- c(8.75, 11.5625, 13.75)
copper_10_0h <- c(90.10600707, 87.98586572, 103.8869258)
copper_10_1h <- c(93.91304348, 88.69565217, 100.8695652)
copper_10_4h <- c(95.05813953, 109.8837209, 107.2674419)
copper_10_24h <- c(90.26086957, 83.47826087, 83.47826087, 151.3043478, 97.04347826, 83.47826087)

# Combine data into vectors
values <- c(
  copper_200_0h, copper_200_1h, copper_200_4h, copper_200_24h,
  copper_100_0h, copper_100_1h, copper_100_4h, copper_100_24h,
  copper_50_0h, copper_50_1h, copper_50_4h, copper_50_24h,
  copper_10_0h, copper_10_1h, copper_10_4h, copper_10_24h
)

concentration <- factor(rep(c("100", "50", "25", "5"),
                            times = c(length(copper_200_0h) + length(copper_200_1h) + length(copper_200_4h) + length(copper_200_24h),
                                      length(copper_100_0h) + length(copper_100_1h) + length(copper_100_4h) + length(copper_100_24h),
                                      length(copper_50_0h) + length(copper_50_1h) + length(copper_50_4h) + length(copper_50_24h),
                                      length(copper_10_0h) + length(copper_10_1h) + length(copper_10_4h) + length(copper_10_24h)
                            )))

timepoint <- factor(c(
  rep("0.1h", length(copper_200_0h)),
  rep("1.5h", length(copper_200_1h)),
  rep("4h", length(copper_200_4h)),
  rep("24h", length(copper_200_24h)),
  rep("0.1h", length(copper_100_0h)),
  rep("1.5h", length(copper_100_1h)),
  rep("4h", length(copper_100_4h)),
  rep("24h", length(copper_100_24h)),
  rep("0.1h", length(copper_50_0h)),
  rep("1.5h", length(copper_50_1h)),
  rep("4h", length(copper_50_4h)),
  rep("24h", length(copper_50_24h)),
  rep("0.1h", length(copper_10_0h)),
  rep("1.5h", length(copper_10_1h)),
  rep("4h", length(copper_10_4h)),
  rep("24h", length(copper_10_24h))
))

df <- data.frame(value = values, concentration = concentration, timepoint = timepoint)

# Fit ART model
art_model <- art(value ~ concentration * timepoint, data = df)

# Run ANOVA and save results
anova_results <- anova(art_model)
print(anova_results)

# Save ANOVA results CSV
anova_df <- as.data.frame(anova_results)
write.csv(anova_df, "copper_ART_ANOVA.csv", row.names = TRUE)

# Extract p-values
p_values <- c(
  concentration = anova_results["concentration", "Pr(>F)"],
  timepoint     = anova_results["timepoint", "Pr(>F)"],
  interaction   = anova_results["concentration:timepoint", "Pr(>F)"]
)
print(p_values)

# Significance threshold
alpha <- 0.05

# Pairwise comparisons for concentration
if (!is.na(p_values["concentration"]) && p_values["concentration"] <= alpha) {
  conc_emm <- emmeans(artlm(art_model, "concentration"), pairwise ~ concentration, adjust = "holm")
  print(conc_emm$contrasts)
  write.csv(as.data.frame(conc_emm$contrasts),
            "copper_concentration_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect for concentration; skipping pairwise comparisons.")
}

# Pairwise comparisons for timepoint
if (!is.na(p_values["timepoint"]) && p_values["timepoint"] <= alpha) {
  time_emm <- emmeans(artlm(art_model, "timepoint"), pairwise ~ timepoint, adjust = "holm")
  print(time_emm$contrasts)
  write.csv(as.data.frame(time_emm$contrasts),
            "copper_timepoint_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect for timepoint; skipping pairwise comparisons.")
}

# Pairwise comparisons for interaction
if (!is.na(p_values["interaction"]) && p_values["interaction"] <= alpha) {
  inter_emm <- emmeans(artlm(art_model, "concentration:timepoint"),
                       pairwise ~ concentration * timepoint, adjust = "holm")
  print(inter_emm$contrasts)
  write.csv(as.data.frame(inter_emm$contrasts),
            "copper_interaction_emmeans.csv", row.names = FALSE)
} else {
  message("No significant interaction effect; skipping pairwise comparisons.")
}
