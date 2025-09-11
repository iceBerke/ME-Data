# Equal variances tests

# Developed with the help of AI (Claude.Ai and Perplexity)

from scipy.stats import bartlett
import scipy.stats as stats
import numpy as np

# Data

nickel_200_0h = [107.1428571, 158.9285714, 110.7142857]
nickel_200_1h = [21.88073394, 20.77981651, 28.0733945]
nickel_200_4h = [16.5060241, 12.28915663, 16.62650602]
nickel_200_24h = [1.636363636, 0.927272727, 2.090909091, 0.931818182, 1.954545455, 1.1]

nickel_100_0h = [128.5714286, 101.0204082, 117.3469388]
nickel_100_1h = [94.92537313, 93.13432836, 70.74626866]
nickel_100_4h = [23.3490566, 12.73584906, 12.02830189]
nickel_100_24h = [39.375, 18.5625, 25.3125, 18.75, 40.3125, 12.65625]

nickel_50_0h = [78.57142857, 95.91836735, 127.5510204]
nickel_50_1h = [103.880597, 115.5223881, 87.76119403]
nickel_50_4h = [61.55660377, 62.97169811, 20.51886792]
nickel_50_24h = [60.9375, 34.96875, 58.125, 39, 68.4375, 36.84375]

nickel_10_0h = [142.8571429, 153.5714286, 166.0714286]
nickel_10_1h = [108.7155963, 108.7155963, 118.3486239]
nickel_10_4h = [104.8192771, 104.8192771, 86.74698795]
nickel_10_24h = [95.45454545, 90.90909091, 63.63636364]

# Perform Bartlett's test
#statistic, p_value = bartlett(nickel_10_0h, nickel_10_1h, nickel_10_4h, nickel_10_24h)

#print(f"Bartlett's test statistic: {statistic:.4f}")
#print(f"p-value: {p_value:.4f}")

#if p_value > 0.05:
#    print("The variances are not significantly different (fail to reject H0).")
#else:
#    print("The variances are significantly different (reject H0).")

# Levene's test (default is center='median', recommended for skewed data)
statistic_2, p_value_2 = stats.levene(nickel_200_0h, nickel_200_1h, nickel_200_4h, nickel_200_24h, 
                                      nickel_100_0h, nickel_100_1h, nickel_100_4h, nickel_100_24h, 
                                      nickel_50_0h, nickel_50_1h, nickel_50_4h, nickel_50_24h, 
                                      nickel_10_0h, nickel_10_1h, nickel_10_4h, nickel_10_24h, center='median')

#nickel_200_0h, nickel_200_1h, nickel_200_4h, nickel_200_24h
#nickel_100_0h, nickel_100_1h, nickel_100_4h, nickel_100_24h
#nickel_50_0h, nickel_50_1h, nickel_50_4h, nickel_50_24h

print(f"Levene's test statistic: {statistic_2:.6f}")
print(f"p-value: {p_value_2:.6f}")

if p_value_2 > 0.05:
    print("The variances are not significantly different (fail to reject H0).")
else:
    print("The variances are significantly different (reject H0).")
