import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

# Data

zinc_50_0h = [7.114575218, 2.371525073, 0, 6.32406686, 0, 0, 0, 0, 35.57287609, 13.79796406, 14.68815529, 33.0483494]
zinc_50_1h = [0]
zinc_50_4h = [0]
zinc_50_24h = [0]

zinc_10_0h = [62.09083827, 70.30874333, 52.85113019, 50.59253488, 88.93219022, 86.23727537, 64.03117696, 74.70303979, 72.72676889, 81.30943106, 43.17811167, 40.65471553]
zinc_10_1h = [11.48578945, 0, 0, 0, 5.05374736, 4.859372461, 5.493203652, 0, 5.493203652, 5.264320166, 0, 0]
zinc_10_4h = [0, 17.58547648, 0, 0, 10.82183168, 0, 4.396369119, 0, 0, 0, 4.851165925, 5.861825493, 11.72365099]
zinc_10_24h = [0, 0, 0, 0, 23.27702487, 9.310809947, 7.149371923, 3.707081738, 10.91904076, 11.54898541, 0, 0]

# Standard Errors

se_zinc_50_0h = [0.353617306, 0.117872435, 0, 0.314326494, 0, 0, 0, 0, 1.768086528, 0.68580326, 0.730048631, 1.64260942]
se_zinc_50_1h = [0]
se_zinc_50_4h = [0]
se_zinc_50_24h = [0]

se_zinc_10_0h = [3.086114668, 3.494571021, 2.626871414, 2.514611952, 4.420216321, 4.286270372, 3.182555751, 3.71298171, 3.61475468, 4.041340636, 2.146091235, 2.020670318]
se_zinc_10_1h = [1.025031206, 0, 0, 0, 0.451013731, 0.433667049, 0.490232316, 0, 0.490232316, 0.469805969, 0, 0]
se_zinc_10_4h = [0, 0.975758599, 0, 0, 0.60046683, 0, 0.24393965, 0, 0, 0, 0.269174786, 0.325252866, 0.650505733]
se_zinc_10_24h = [0, 0, 0, 0, 1.460614029, 0.584245612, 0.448617166, 0.232616308, 0.685160763, 0.724689268, 0, 0]

times = np.array([0.1, 1.5, 4, 24])

# Means calculated 
means = {
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
output_dir = Path(r"C:\Users\asus\OneDrive\Documents\MEBiom\TU\ME_part2\Plots\Motility_Plots")  # Change this to your desired folder path
output_dir.mkdir(parents=True, exist_ok=True)  # Create directory if it doesn't exist

output_filename = "zinc_motility_summary.txt"
output_path = output_dir / output_filename

with open(output_path, 'w') as f:
    f.write(f"{'Concentration':<16}{'Time(h)':<16}{'Mean':<16}{'SE':<16}{'Median'}\n")
    for conc in means:
        for t_idx, t in enumerate(times):
            f.write(f"{conc:<15}\t{t:<10}\t{means[conc][t_idx]:<10.2f}\t{ses[conc][t_idx]:<10.2f}\t{medians[conc][t_idx]:.2f}\n")

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

plt.title('Fraction of motile cells in zinc chloride relative to control', fontsize=20)
plt.xlabel('Time (hours)', fontsize=18)
plt.ylabel('Percentage of motile cells relative to control (%)', fontsize=18)
plt.xticks(times, ['0.1h', '1.5h', '4h', '24h'], fontsize=14)
plt.yticks(fontsize=14)
plt.legend(title='Zinc Chloride Group')
plt.grid(True)
plt.show()
