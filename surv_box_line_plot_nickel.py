import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

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

# Standard Errors

se_nickel_200_0h = [22.33964271, 33.13713669, 23.08429747]
se_nickel_200_1h = [1.394389315, 1.324231363, 1.789027801]
se_nickel_200_4h = [0.413976255, 0.308215898, 0.416997979]
se_nickel_200_24h = [0.21]

se_nickel_100_0h = [15.54171048, 12.21134395, 14.18489448]
se_nickel_100_1h = [7.08398307, 6.950323012, 5.279572288]
se_nickel_100_4h = [1.019883443, 0.55630006, 0.525394501]
se_nickel_100_24h = [14.50701261, 6.839020231, 9.325936679, 6.908101244, 14.85241767, 4.662968339]

se_nickel_50_0h = [9.497711957, 11.5946094, 15.41836357]
se_nickel_50_1h = [7.752283359, 8.621073736, 6.549342838]
se_nickel_50_4h = [2.688783623, 2.75059474, 0.896261208]
se_nickel_50_24h = [22.45132904, 12.88360882, 21.41511386, 14.36885059, 25.21456954, 13.57441894]

se_nickel_10_0h = [29.78619029, 32.02015456, 34.62644621]
se_nickel_10_1h = [6.928097857, 6.928097857, 7.541979945]
se_nickel_10_4h = [2.628900304, 2.628900304, 2.175641631]
se_nickel_10_24h = [9.94]


times = np.array([0.1, 1.5, 4, 24])

# Means calculated 
means = {
    '100 mg/L': [
        np.mean(nickel_200_0h),
        np.mean(nickel_200_1h),
        np.mean(nickel_200_4h),
        np.mean(nickel_200_24h),
    ],
    '50 mg/L': [
        np.mean(nickel_100_0h),
        np.mean(nickel_100_1h),
        np.mean(nickel_100_4h),
        np.mean(nickel_100_24h),
    ],
    '25 mg/L': [
        np.mean(nickel_50_0h),
        np.mean(nickel_50_1h),
        np.mean(nickel_50_4h),
        np.mean(nickel_50_24h),
    ],
    '5 mg/L': [
        np.mean(nickel_10_0h),
        np.mean(nickel_10_1h),
        np.mean(nickel_10_4h),
        np.mean(nickel_10_24h),
    ]
}

def combined_se(se_list):
    se_array = np.array(se_list)
    n = len(se_array)
    return np.sqrt(np.sum(se_array**2)) / n

ses = {
    '100 mg/L': [
        combined_se(se_nickel_200_0h),
        combined_se(se_nickel_200_1h),
        combined_se(se_nickel_200_4h),
        combined_se(se_nickel_200_24h),
    ],
    '50 mg/L': [
        combined_se(se_nickel_100_0h),
        combined_se(se_nickel_100_1h),
        combined_se(se_nickel_100_4h),
        combined_se(se_nickel_100_24h),
    ],
    '25 mg/L': [
        combined_se(se_nickel_50_0h),
        combined_se(se_nickel_50_1h),
        combined_se(se_nickel_50_4h),
        combined_se(se_nickel_50_24h),
    ],
    '5 mg/L': [
        combined_se(se_nickel_10_0h),
        combined_se(se_nickel_10_1h),
        combined_se(se_nickel_10_4h),
        combined_se(se_nickel_10_24h),
    ],
}

# Calculate medians
medians = {
    '100 mg/L': [
        np.median(nickel_200_0h),
        np.median(nickel_200_1h),
        np.median(nickel_200_4h),
        np.median(nickel_200_24h),
    ],
    '50 mg/L': [
        np.median(nickel_100_0h),
        np.median(nickel_100_1h),
        np.median(nickel_100_4h),
        np.median(nickel_100_24h),
    ],
    '25 mg/L': [
        np.median(nickel_50_0h),
        np.median(nickel_50_1h),
        np.median(nickel_50_4h),
        np.median(nickel_50_24h),
    ],
    '5 mg/L': [
        np.median(nickel_10_0h),
        np.median(nickel_10_1h),
        np.median(nickel_10_4h),
        np.median(nickel_10_24h),
    ],
}

#print(medians)

# Save data
output_dir = Path(r"C:\Users\asus\OneDrive\Documents\MEBiom\TU\ME_part2\Plots\Survivability_Plots")  # Change this to your desired folder path
output_dir.mkdir(parents=True, exist_ok=True)  # Create directory if it doesn't exist

output_filename = "nickel_survivability_summary_6decimals.txt"
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
                     alpha=0.3, color=colors[group])

plt.title('Fraction of surviving cells in nickel chloride relative to control', fontsize=20)
plt.xlabel('Time (hours)', fontsize=18)
plt.ylabel('Percentage of surviving cells relative to control (%)', fontsize=18)
plt.xticks(times, ['0.1h', '1.5h', '4h', '24h'], fontsize=14)
plt.yticks(fontsize=14)
plt.legend(title='Nickel Chloride Group')
plt.grid(True)
plt.show()
