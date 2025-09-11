# Install and load required packages
if (!require("ARTool")) install.packages("ARTool")
if (!require("emmeans")) install.packages("emmeans")
library(ARTool)
library(emmeans)

lead_200_0h <- c(42.70850363, 46.59109487, 34.25815799, 34.25815799, 33.27935348, 33.81611725, 22.54407816, 58.23886859, 48.53239049, 36.39929287, 29.11943429, 19.4129562, 34.62851646, 45.29689779)
lead_200_1h <- c(83.82600592, 50.47587454, 28.65846356, 0, 52.5967096, 12.77348662, 15.96685827, 7.708138476, 20.95650148, 41.91300296, 36.0541961, 89.41440632, 53.95696933, 98.77172791, 95.00280671, 74.51200527, 80.85345252)
lead_200_4h <- c(37.4134662, 16.49246673, 10.4006547, 37.4134662, 6.012878496, 16.03434266, 13.74372228, 17.10329883, 0, 0, 5.497488911, 0, 25.09723198, 12.28162416, 8.017171328, 8.949400553)
lead_200_24h <- c(16.08111391, 21.9401244, 15.72375582, 20.07287977, 38.04134473, 22.82480684, 26.2062597, 0, 14.74102108, 0, 18.86850699, 30.76387009, 36.28559036, 36.28559036, 51.27311681, 35.89118177)

lead_100_0h <- c(50.36875121, 49.04325776, 66.55870696, 63.87488813, 40.63176878, 31.76665559, 46.59109487, 18.9614921, 37.06109819, 26.472213, 60.39586372, 46.59109487)
lead_100_1h <- c(173.0601413, 175.2039043, 115.1549172, 131.491774, 120.8302788, 92.68566509, 62.09333772, 62.09333772, 120.8302788, 135.2981148, 193.3284461, 210.7625292)
lead_100_4h <- c(96.20605594, 111.9488651, 71.04447208, 51.69280618, 89.79231888, 85.51649417, 94.5182304, 80.46324679, 110.5346175, 123.9989165, 96.20605594, 99.90628886, 106.0230004)
lead_100_24h <- c(85.17034404, 100.0602643, 69.36951098, 111.7214229, 101.9919297, 81.32977149, 119.9970839, 148.3612444, 121.8591076, 108.4939152, 84.90828144, 99.30793151, 84.55227187)

lead_50_0h <- c(84.854045, 73.28303887, 94.83687383, 113.9958382, 123.1155053, 64.4890742, 83.75204442, 62.81403331, 57.57953054, 109.9245583, 109.9245583, 122.9263878)
lead_50_1h <- c(67.93959346, 93.32361738, 71.36511918, 45.49526348, 60.6603513, 83.00890178, 129.6876476, 158.9719551, 84.3970105, 83.00890178, 126.3757319, 65.71538058, 97.05656208, 97.05656208, 121.3207026, 94.36054647)
lead_50_4h <- c(86.31103122, 79.49700244, 52.67186008, 50.10250105, 70.1625157, 83.07436755, 62.65541526, 69.04882498, 71.84810167, 58.78481045, 54.92520169, 60.41772186, 78.54303841, 57.90031678, 49.22925485, 60.41772186)
lead_50_24h <- c(116.8722137, 99.95649858, 80.52051274, 90.86954416, 76.02325244, 90.15684186, 99.95649858, 80.66664798, 89.24687373, 74.0418508, 126.4755696, 170.7590184, 122.3957125, 142.2457864, 109.7561553)

lead_10_0h <- c(66.62094442, 73.28303887, 62.81403331, 57.57953054, 87.93964664, 87.93964664, 73.28303887, 85.49687868, 54.96227915, 97.71071849, 99.93141664, 161.9940859, 161.9940859)
lead_10_1h <- c(85.93549768, 54.38514254, 50.55029275, 53.52383938, 83.19133893, 85.63814301, 68.24289521, 64.22860726, 92.77465493, 113.7381587, 101.1005855, 113.7381587)
lead_10_4h <- c(93.37284287, 96.66835497, 120.8354437, 126.5895125, 56.10217029, 73.36437654, 75.52215232, 73.23360225, 56.64161424, 58.94411888, 60.41772186, 69.41610596, 64.27417219, 80.55696247)
lead_10_24h <- c(95.79164447, 106.3367006, 111.5793473, 92.98278938, 142.1603535, 151.0453756, 113.676018, 92.26753715, 163.5651795, 108.2862068, 134.6352838, 116.2284867, 109.043453)

# Combine your data into a data frame
values <- c(
  lead_200_0h, lead_200_1h, lead_200_4h, lead_200_24h,
  lead_100_0h, lead_100_1h, lead_100_4h, lead_100_24h,
  lead_50_0h, lead_50_1h, lead_50_4h, lead_50_24h,
  lead_10_0h, lead_10_1h, lead_10_4h, lead_10_24h
)

concentration <- factor(rep(c("100", "50", "25", "5"),
                            times = c(length(lead_200_0h) + length(lead_200_1h) + length(lead_200_4h) + length(lead_200_24h),
                                      length(lead_100_0h) + length(lead_100_1h) + length(lead_100_4h) + length(lead_100_24h),
                                      length(lead_50_0h) + length(lead_50_1h) + length(lead_50_4h) + length(lead_50_24h),
                                      length(lead_10_0h) + length(lead_10_1h) + length(lead_10_4h) + length(lead_10_24h)
                            )))

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

df <- data.frame(value = values, concentration = concentration, timepoint = timepoint)

# Fit ART model
art_model <- art(value ~ concentration * timepoint, data = df)

# Run ANOVA and save results in an object
anova_results <- anova(art_model)
print(anova_results)

# Convert ANOVA results summary to a data frame
anova_df <- as.data.frame(anova_results)

# Save ANOVA table as CSV
write.csv(anova_df, "lead_ART_ANOVA.csv", row.names = TRUE)

# Extract p-values for the tested effects
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
            "lead_concentration_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect for concentration; skipping pairwise comparisons.")
}

# 2. Pairwise comparisons for timepoint
if (!is.na(p_values["timepoint"]) && p_values["timepoint"] <= alpha) {
  time_emm <- emmeans(artlm(art_model, "timepoint"), pairwise ~ timepoint, adjust = "holm")
  print(time_emm$contrasts)
  write.csv(as.data.frame(time_emm$contrasts),
            "lead_timepoint_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect for timepoint; skipping pairwise comparisons.")
}

# 3. Pairwise comparisons for interaction
if (!is.na(p_values["interaction"]) && p_values["interaction"] <= alpha) {
  inter_emm <- emmeans(artlm(art_model, "concentration:timepoint"),
                       pairwise ~ concentration * timepoint, adjust = "holm")
  print(inter_emm$contrasts)
  write.csv(as.data.frame(inter_emm$contrasts),
            "lead_interaction_emmeans.csv", row.names = FALSE)
} else {
  message("No significant interaction effect; skipping pairwise comparisons.")
}