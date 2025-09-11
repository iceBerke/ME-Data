# Install and load required packages
if (!require("ARTool")) install.packages("ARTool")
if (!require("emmeans")) install.packages("emmeans")
library(ARTool)
library(emmeans)

# Your nickel data
nickel_50_0h <- c(146.2412805, 117.2893343, 140.1639945, 83.0954596,
                  135.8196611, 115.7442054, 104.810606, 130.2831527,
                  90.7478042, 101.8045065, 45.02162025, 70.68554031,
                  43.40407701, 45.22225136)

nickel_50_1h <- c(33.43701837, 59.338934, 33.43701837, 49.21804105,
                  60.09626274, 35.26918376, 36.95670451, 56.67799526,
                  51.77344779, 32.03851189, 37.95553436, 27.09366118,
                  26.33165196, 33.33120502, 23.19504878)

nickel_50_4h <- c(52.27232816, 51.85965188, 72.79733837, 64.31080373,
                  55.19044357, 34.45221629, 34.80376951, 30.31795033,
                  44.21367757, 42.65512493, 49.21745184, 49.21745184,
                  47.04509534, 41.41796493, 82.49782403)

nickel_50_24h <- c(17.57638384, 20.27451294, 25.34314118, 34.71901573,
                   18.4903558, 23.48876499, 4.567775643, 26.66878241,
                   13.3343912, 38.95440127, 37.68414906, 21.90800451,
                   15.27287098, 32.55344332, 36.4941233)

nickel_10_0h <- c(142.1270757, 105.0504473, 101.3228507, 123.273484,
                  144.0095535, 83.31587196, 92.9292418, 142.6866311,
                  71.34331556, 111.7607181, 79.54437158, 90.01381461)

nickel_10_1h <- c(73.75812875, 53.81651496, 67.14046716, 50.92126079,
                  80.24884408, 107.7760639, 108.5183232, 102.1948308,
                  70.89290913, 71.18849072, 92.50241009, 65.62405474,
                  97.69424497, 102.1948308, 117.5318371, 90.37926747)

nickel_10_4h <- c(65.53692271, 91.96867779, 68.90443257, 71.55460306,
                  115.2867043, 81.77040546, 120.8324107, 94.74359479,
                  90.55140033, 91.68734979, 123.4667661, 120.0371337,
                  96.20118855, 111.9333609, 114.9348527)

nickel_10_24h <- c(107.6689973, 121.4533721, 109.7133454, 119.8162688,
                   128.8141825, 57.12324749, 93.34073843, 115.1043065,
                   156.7738501, 132.6152568, 120.121039, 87.43383706,
                   68.36223096, 77.71896628, 102.6506142)

# Combine your data into a data frame
values <- c(
  nickel_50_0h, nickel_50_1h, nickel_50_4h, nickel_50_24h,
  nickel_10_0h, nickel_10_1h, nickel_10_4h, nickel_10_24h
)

concentration <- factor(rep(c("25", "5"),
                            times = c(length(nickel_50_0h) + length(nickel_50_1h) + length(nickel_50_4h) + length(nickel_50_24h),
                                      length(nickel_10_0h) + length(nickel_10_1h) + length(nickel_10_4h) + length(nickel_10_24h))),
                        levels = c("5", "25"))

timepoint <- factor(c(
  rep("0.1h", length(nickel_50_0h)),
  rep("1.5h", length(nickel_50_1h)),
  rep("4h", length(nickel_50_4h)),
  rep("24h", length(nickel_50_24h)),
  rep("0.1h", length(nickel_10_0h)),
  rep("1.5h", length(nickel_10_1h)),
  rep("4h", length(nickel_10_4h)),
  rep("24h", length(nickel_10_24h))
), levels = c("0.1h", "1.5h", "4h", "24h"))

df <- data.frame(value = values, concentration = concentration, timepoint = timepoint)

# Fit ART model
art_model <- art(value ~ concentration * timepoint, data = df)

# Run ANOVA and save results
anova_results <- anova(art_model)
print(anova_results)

anova_df <- as.data.frame(anova_results)
write.csv(anova_df, "nickel_ART_ANOVA.csv", row.names = TRUE)

# Extract p-values for effects
p_values <- c(
  concentration = anova_results["concentration", "Pr(>F)"],
  timepoint     = anova_results["timepoint", "Pr(>F)"],
  interaction   = anova_results["concentration:timepoint", "Pr(>F)"]
)
print(p_values)

alpha <- 0.05
# 1. Pairwise concentration comparisons
if (!is.na(p_values["concentration"]) && p_values["concentration"] <= alpha) {
  conc_emm <- emmeans(artlm(art_model, "concentration"), pairwise ~ concentration, adjust = "holm")
  print(conc_emm$contrasts)
  write.csv(as.data.frame(conc_emm$contrasts), "nickel_concentration_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect for concentration; skipping pairwise comparisons.")
}

# 2. Pairwise timepoint comparisons
if (!is.na(p_values["timepoint"]) && p_values["timepoint"] <= alpha) {
  time_emm <- emmeans(artlm(art_model, "timepoint"), pairwise ~ timepoint, adjust = "holm")
  print(time_emm$contrasts)
  write.csv(as.data.frame(time_emm$contrasts), "nickel_timepoint_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect for timepoint; skipping pairwise comparisons.")
}

# 3. Pairwise interaction comparisons
if (!is.na(p_values["interaction"]) && p_values["interaction"] <= alpha) {
  inter_emm <- emmeans(artlm(art_model, "concentration:timepoint"), pairwise ~ concentration * timepoint, adjust = "holm")
  print(inter_emm$contrasts)
  write.csv(as.data.frame(inter_emm$contrasts), "nickel_interaction_emmeans.csv", row.names = FALSE)
} else {
  message("No significant interaction effect; skipping pairwise comparisons.")
}
