import numpy as np
from scipy import stats

# Sample data
lead_50_0h = [106.8532419, 92.28234524, 119.4242115, 143.5503148, 155.03434, 81.20846381, 105.4655374, 79.09915306, 72.50755697, 138.4235179, 138.4235179, 154.796192]
lead_50_1h = [79.92893348, 109.792491, 83.95896374, 53.52383938, 71.36511918, 97.6575315, 152.5737031, 187.0258296, 99.29060059, 97.6575315, 148.6773316, 77.31221244, 114.1841907, 114.1841907, 142.7302384, 111.0124076]

# Perform independent two-sample t-test
# Small sample sizes (<30) and unknown variance (only calculated from the data collected)

# Standard t-test (assumes equal variances), two-sided
t_stat_1, p_value_1 = stats.ttest_ind(lead_50_0h, lead_50_1h, alternative='two-sided', equal_var=True)
print("Standard t-test (equal variances):")
print("  t-statistic:", t_stat_1)
print("  p-value:", p_value_1)

# Welch's t-test (does NOT assume equal variances), two-sided
t_stat_2, p_value_2 = stats.ttest_ind(group1, group2, alternative='two-sided', equal_var=False)
print("\nWelch's t-test (unequal variances):")
print("  t-statistic:", t_stat_2)
print("  p-value:", p_value_2)
