# Normality tests

# Developed with the help of AI (Claude.Ai and Perplexity)

import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats
import pingouin as pg
from scipy.stats import kstest, shapiro, anderson

# Add correct data to be tested (one Q-Q plot per sample)
nickel_10_24h = [107.6689973, 121.4533721, 109.7133454, 119.8162688, 128.8141825, 57.12324749, 93.34073843, 115.1043065, 156.7738501, 132.6152568, 120.121039, 87.43383706, 68.36223096, 77.71896628, 102.6506142]

# Alternative
fig, ax = plt.subplots()
pg.qqplot(nickel_10_24h, dist='norm', ax=ax, confidence=.95)

# Set axis limits to the calculated percentiles
ax.set_xlim([-2, 2])
ax.set_ylim([-2, 2])

plt.title('Q-Q Plot (95% Confidence Interval)')
plt.show()

# More normality tests

# Kolmogorov-Smirnov test for one sample compared to a normal distribution
# The null hypothesis is that the data follows a specific distribution (e.g., normal distribution)
# Rejecting the null hypothesis means that the data is NOT normally distributed
#ks_stat, ks_p = kstest(lead_200_0h, 'norm')
#print(f"Kolmogorov-Smirnov test:\n  Statistic = {ks_stat:.4f}, p-value = {ks_p:.4f}")

# Shapiro-Wilk test 
# The null hypothesis is that the data comes from a normally distributed population
shapiro_stat, shapiro_p = shapiro(nickel_10_24h)
print(f"Shapiro-Wilk test:\n  Statistic = {shapiro_stat:.4f}, p-value = {shapiro_p:.4f}")
