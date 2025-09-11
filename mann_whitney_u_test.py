from scipy.stats import mannwhitneyu
import numpy as np

# Sample data (replace with your datasets)
nickel_200_0h = [57.17488308, 49.35300277, 59.41161477, 37.20819432, 90.60594845, 59.94096354, 84.01642492, 76.28849905, 47.75539901, 49.50967897, 35.12511008, 44.89219596, 27.21736279, 30.47706369]
nickel_200_1h = [4.819502837, 0, 7.599985242, 0, 0, 0, 0, 3.710790916, 0, 0, 5.099344937, 0]

# Check for ties 
# Tied values correspond to observations that are equal, within the same sample/group or within different samples/groups
combined = np.concatenate([nickel_200_0h, nickel_200_1h])
print(combined)
unique, counts = np.unique(combined, return_counts=True)
print(unique)
print(counts)
tie_exists = any(counts > 1)

# Method selection logic
if tie_exists:
    print("Ties detected. Using asymptotic method with continuity correction.")
    method_1 = 'asymptotic'
    use_continuity_1 = True
else:
    print("No ties detected. Using exact method for precise results.")
    # Ideal for small sample sizes (<8-10)
    # Issue is computational power
    method_1 = 'exact'
    use_continuity_1 = False  # No effect for exact method

# Perform the test
group1_statistic, p_value = mannwhitneyu(
    nickel_200_0h, nickel_200_1h,
    alternative='two-sided',
    method=method_1,
    use_continuity=use_continuity_1
)

n_group1, n_group2 = len(nickel_200_0h), len(nickel_200_1h)
group2_statistic = (n_group1 * n_group2) - group1_statistic

print(f"\nU statistic for nickel 100 mg/L (0.1h): {group1_statistic}")
print(f"U statistic for nickel 100 mg/L (1h): {group2_statistic}")
print(f"P-value: {p_value:.10f}")
