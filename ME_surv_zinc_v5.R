# Install and load required packages
if (!require("ARTool")) install.packages("ARTool")
if (!require("emmeans")) install.packages("emmeans")
library(ARTool)
library(emmeans)

# Input zinc data
zinc_200_0h <- c(80, 77.14285714, 80)
zinc_200_1h <- c(23.63636364, 10.36363636, 29.09090909, 14.18181818, 41.81818182, 16.90909091)
zinc_200_4h <- c(3.75, 5.0625, 5.25)
zinc_200_24h <- c(0.205882353, 0.138235294, 0.333333333, 0.168627451, 0.019607843, 0.076470588)
zinc_100_0h <- c(69.45812808, 56.15763547, 106.4039409)
zinc_100_1h <- c(59.39086294, 42.63959391, 36.54822335)
zinc_100_4h <- c(6.072874494, 4.129554656, 14.57489879, 5.829959514, 17.00404858, 5.222672065)
zinc_100_24h <- c(0, 0.10543131, 0.095846645, 0.153354633, 0.191693291, 0.067092652)
zinc_50_0h <- c(97.53694581, 66.50246305, 59.11330049)
zinc_50_1h <- c(35.02538071, 33.50253807, 42.63959391)
zinc_50_4h <- c(10.93117409, 6.923076923, 21.86234818, 12.63157895, 8.502024291, 6.315789474)
zinc_50_24h <- c(0.479233227, 0.095846645, 0.431309904, 0.095846645, 0.383386581)
zinc_10_0h <- c(111.4285714, 151.4285714, 154.2857143)
zinc_10_1h <- c(80, 30.18181818, 80, 35.63636364, 45.45454545, 36)
zinc_10_4h <- c(75, 34.875, 82.5, 40.875)
zinc_10_24h <- c(65.68627451, 91.17647059, 73.52941176)

# Combine all data into vectors
values <- c(
  zinc_200_0h, zinc_200_1h, zinc_200_4h, zinc_200_24h,
  zinc_100_0h, zinc_100_1h, zinc_100_4h, zinc_100_24h,
  zinc_50_0h, zinc_50_1h, zinc_50_4h, zinc_50_24h,
  zinc_10_0h, zinc_10_1h, zinc_10_4h, zinc_10_24h
)

concentration <- factor(rep(c("100", "50", "25", "5"),
                            times = c(length(zinc_200_0h) + length(zinc_200_1h) + length(zinc_200_4h) + length(zinc_200_24h),
                                      length(zinc_100_0h) + length(zinc_100_1h) + length(zinc_100_4h) + length(zinc_100_24h),
                                      length(zinc_50_0h) + length(zinc_50_1h) + length(zinc_50_4h) + length(zinc_50_24h),
                                      length(zinc_10_0h) + length(zinc_10_1h) + length(zinc_10_4h) + length(zinc_10_24h)
                            )))
                        
timepoint <- factor(c(
                          rep("0.1h", length(zinc_200_0h)),
                          rep("1.5h", length(zinc_200_1h)),
                          rep("4h", length(zinc_200_4h)),
                          rep("24h", length(zinc_200_24h)),
                          rep("0.1h", length(zinc_100_0h)),
                          rep("1.5h", length(zinc_100_1h)),
                          rep("4h", length(zinc_100_4h)),
                          rep("24h", length(zinc_100_24h)),
                          rep("0.1h", length(zinc_50_0h)),
                          rep("1.5h", length(zinc_50_1h)),
                          rep("4h", length(zinc_50_4h)),
                          rep("24h", length(zinc_50_24h)),
                          rep("0.1h", length(zinc_10_0h)),
                          rep("1.5h", length(zinc_10_1h)),
                          rep("4h", length(zinc_10_4h)),
                          rep("24h", length(zinc_10_24h))
))
                        
# Create data frame
df <- data.frame(value = values, concentration = concentration, timepoint = timepoint)
                      
# Fit ART model
art_model <- art(value ~ concentration * timepoint, data = df)
                      
# Run ANOVA & print
anova_results <- anova(art_model)
print(anova_results)
                        
# Save ANOVA results CSV
anova_df <- as.data.frame(anova_results)
write.csv(anova_df, "zinc_ART_ANOVA.csv", row.names = TRUE)
                      
# Extract p-values
p_values <- c(
                          concentration = anova_results["concentration", "Pr(>F)"],
                          timepoint     = anova_results["timepoint", "Pr(>F)"],
                          interaction   = anova_results["concentration:timepoint", "Pr(>F)"]
)
print(p_values)
                        
# Set significance threshold
alpha <- 0.05
                      
# Pairwise comparisons for concentration
if (!is.na(p_values["concentration"]) && p_values["concentration"] <= alpha) {
                          conc_emm <- emmeans(artlm(art_model, "concentration"), pairwise ~ concentration, adjust = "holm")
                          print(conc_emm$contrasts)
                          write.csv(as.data.frame(conc_emm$contrasts), "zinc_concentration_emmeans.csv", row.names = FALSE)
} else {
                          message("No significant effect for concentration; skipping pairwise comparisons.")
}
                        
# Pairwise comparisons for timepoint
if (!is.na(p_values["timepoint"]) && p_values["timepoint"] <= alpha) {
                         time_emm <- emmeans(artlm(art_model, "timepoint"), pairwise ~ timepoint, adjust = "holm")
                          print(time_emm$contrasts)
                          write.csv(as.data.frame(time_emm$contrasts), "zinc_timepoint_emmeans.csv", row.names = FALSE)
} else {
                          message("No significant effect for timepoint; skipping pairwise comparisons.")
}
                        
# Pairwise comparisons for interaction
if (!is.na(p_values["interaction"]) && p_values["interaction"] <= alpha) {
                          inter_emm <- emmeans(artlm(art_model, "concentration:timepoint"),
                                               pairwise ~ concentration * timepoint, adjust = "holm")
                          print(inter_emm$contrasts)
                          write.csv(as.data.frame(inter_emm$contrasts), "zinc_interaction_emmeans.csv", row.names = FALSE)
} else {
                          message("No significant interaction effect; skipping pairwise comparisons.")
}
                        