import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

# Data

zinc_200_0h = [80, 77.14285714, 80]
zinc_200_1h = [23.63636364, 10.36363636, 29.09090909, 14.18181818, 41.81818182, 16.90909091]
zinc_200_4h = [3.75, 5.0625, 5.25]
zinc_200_24h = [0.205882353, 0.138235294, 0.333333333, 0.168627451, 0.019607843, 0.076470588]

zinc_100_0h = [69.45812808, 56.15763547, 106.4039409]
zinc_100_1h = [59.39086294, 42.63959391, 36.54822335]
zinc_100_4h = [6.072874494, 4.129554656, 14.57489879, 5.829959514, 17.00404858, 5.222672065]
zinc_100_24h = [0, 0.10543131, 0.095846645, 0.153354633, 0.191693291, 0.067092652]

zinc_50_0h = [97.53694581, 66.50246305, 59.11330049]
zinc_50_1h = [35.02538071, 33.50253807, 42.63959391]
zinc_50_4h = [10.93117409, 6.923076923, 21.86234818, 12.63157895, 8.502024291, 6.315789474]
zinc_50_24h = [0.479233227, 0.095846645, 0.431309904, 0.095846645, 0.383386581]

zinc_10_0h = [111.4285714, 151.4285714, 154.2857143]
zinc_10_1h = [80, 30.18181818, 80, 35.63636364, 45.45454545, 36]
zinc_10_4h = [75, 34.875, 82.5, 40.875]
zinc_10_24h = [65.68627451, 91.17647059, 73.52941176]

# Standard Errors

se_zinc_200_0h = [2.639315516, 2.545054248, 2.639315516]
se_zinc_200_1h = [0.859504132, 0.376859504, 1.05785124, 0.515702479, 1.520661157, 0.614876033]
se_zinc_200_4h = [0.583118217, 0.787209593, 0.816365504]
se_zinc_200_24h = [0.021265737, 0.014278423, 0.034430241, 0.017417651, 0.002025308, 0.007898702]

se_zinc_100_0h = [0.684316533, 0.553277197, 1.048314689]
se_zinc_100_1h = [5.434944204, 3.902011223, 3.344581049]
se_zinc_100_4h = [0.299108125, 0.203393525, 0.7178595, 0.2871438, 0.83750275, 0.257232987]
se_zinc_100_24h = [0, 0.00299391, 0.002721737, 0.004354779, 0.005443474, 0.001905216]

se_zinc_50_0h = [0.960955131, 0.65519668, 0.582397049]
se_zinc_50_1h = [3.205223505, 3.065865961, 3.902011223]
se_zinc_50_4h = [0.538394625, 0.340983262, 1.07678925, 0.6221449, 0.418751375, 0.31107245]
se_zinc_50_24h = [0.013608684, 0.002721737, 0.012247816, 0.002721737, 0.010886947]

se_zinc_10_0h = [3.676189469, 4.995847227, 5.090108496]
se_zinc_10_1h = [2.909090909, 1.097520661, 2.909090909, 1.295867769, 1.652892562, 1.309090909]
se_zinc_10_4h = [11.66236435, 5.422999422, 12.82860078, 6.35598857]
se_zinc_10_24h = [6.78478279, 9.417683574, 7.594906108]


times = np.array([0.1, 1.5, 4, 24])

# Means calculated 
means = {
    '100 mg/L': [
        np.mean(zinc_200_0h),
        np.mean(zinc_200_1h),
        np.mean(zinc_200_4h),
        np.mean(zinc_200_24h),
    ],
    '50 mg/L': [
        np.mean(zinc_100_0h),
        np.mean(zinc_100_1h),
        np.mean(zinc_100_4h),
        np.mean(zinc_100_24h),
    ],
    '25 mg/L': [
        np.mean(zinc_50_0h),
        np.mean(zinc_50_1h),
        np.mean(zinc_50_4h),
        np.mean(zinc_50_24h),
    ],
    '5 mg/L': [
        np.mean(zinc_10_0h),
        np.mean(zinc_10_1h),
        np.mean(zinc_10_4h),
        np.mean(zinc_10_24h),
    ]
}

def combined_se(se_list):
    se_array = np.array(se_list)
    n = len(se_array)
    return np.sqrt(np.sum(se_array**2)) / n

ses = {
    '100 mg/L': [
        combined_se(se_zinc_200_0h),
        combined_se(se_zinc_200_1h),
        combined_se(se_zinc_200_4h),
        combined_se(se_zinc_200_24h),
    ],
    '50 mg/L': [
        combined_se(se_zinc_100_0h),
        combined_se(se_zinc_100_1h),
        combined_se(se_zinc_100_4h),
        combined_se(se_zinc_100_24h),
    ],
    '25 mg/L': [
        combined_se(se_zinc_50_0h),
        combined_se(se_zinc_50_1h),
        combined_se(se_zinc_50_4h),
        combined_se(se_zinc_50_24h),
    ],
    '5 mg/L': [
        combined_se(se_zinc_10_0h),
        combined_se(se_zinc_10_1h),
        combined_se(se_zinc_10_4h),
        combined_se(se_zinc_10_24h),
    ],
}

# Calculate medians
medians = {
    '100 mg/L': [
        np.median(zinc_200_0h),
        np.median(zinc_200_1h),
        np.median(zinc_200_4h),
        np.median(zinc_200_24h),
    ],
    '50 mg/L': [
        np.median(zinc_100_0h),
        np.median(zinc_100_1h),
        np.median(zinc_100_4h),
        np.median(zinc_100_24h),
    ],
    '25 mg/L': [
        np.median(zinc_50_0h),
        np.median(zinc_50_1h),
        np.median(zinc_50_4h),
        np.median(zinc_50_24h),
    ],
    '5 mg/L': [
        np.median(zinc_10_0h),
        np.median(zinc_10_1h),
        np.median(zinc_10_4h),
        np.median(zinc_10_24h),
    ],
}

#print(medians)

# Save data
output_dir = Path(r"C:\Users\asus\OneDrive\Documents\MEBiom\TU\ME_part2\Plots\Survivability_Plots")  # Change this to your desired folder path
output_dir.mkdir(parents=True, exist_ok=True)  # Create directory if it doesn't exist

output_filename = "zinc_survivability_summary_6decimals.txt"
output_path = output_dir / output_filename

with open(output_path, 'w') as f:
    f.write(f"{'Concentration':<16}{'Time(h)':<16}{'Mean':<16}{'SE':<16}{'Median'}\n")
    for conc in means:
        for t_idx, t in enumerate(times):
            f.write(f"{conc:<15}\t{t:<10}\t{means[conc][t_idx]:<10.6f}\t{ses[conc][t_idx]:<10.6f}\t{medians[conc][t_idx]:.6f}\n")

print(f"File saved at: {output_path.resolve()}")

# Plot data
colors = {
    '100 mg/L': 'blue',
    '50 mg/L': 'green',
    '25 mg/L': 'red',
    '5 mg/L': 'gold',
}

plt.figure(figsize=(14, 8))

for group in means:
    mean_vals = np.array(means[group])
    ci_margins = 1.96 * np.array(ses[group])  # 95% CI margins
    
    plt.plot(times, mean_vals, marker='o', label=group, color=colors[group])
    plt.fill_between(times, mean_vals - ci_margins, mean_vals + ci_margins, 
                     alpha=0.5, color=colors[group])

plt.title('Fraction of surviving cells in zinc chloride relative to control', fontsize=20)
plt.xlabel('Time (hours)', fontsize=18)
plt.ylabel('Percentage of surviving cells relative to control (%)', fontsize=18)
plt.xticks(times, ['0.1h', '1.5h', '4h', '24h'], fontsize=14)
plt.yticks(fontsize=14)
plt.legend(title='Zinc Chloride Group')
plt.grid(True)
plt.show()
