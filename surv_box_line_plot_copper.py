import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

# Data
copper_200_0h = [67.84452297, 65.72438163, 91.16607774]
copper_200_1h = [0.286956522, 0.074782609, 0.347826087, 0.237391304, 0.27826087, 0.082608696]
copper_200_4h = [0.002616279, 0.005755814, 0.005232558, 0.004011628, 0.003488372, 0.001569767]
copper_200_24h = [0, 0, 0, 0, 0, 0]

copper_100_0h = [128.9156627, 75.90361446, 122.8915663]
copper_100_1h = [14.57746479, 16.47887324, 10.14084507]
copper_100_4h = [5.271929825, 5.263157895, 5.552631579]
copper_100_24h = [0.28125, 0.45, 1.03125, 0.609375, 0.4375, 0.45625]

copper_50_0h = [80.72289157, 121.686747, 91.56626506]
copper_50_1h = [59.15492958, 25.24647887, 63.38028169, 24.82394366, 63.38028169, 17.11267606]
copper_50_4h = [23.59649123, 21.14035088, 21.84210526]
copper_50_24h = [8.75, 11.5625, 13.75]

copper_10_0h = [90.10600707, 87.98586572, 103.8869258]
copper_10_1h = [93.91304348, 88.69565217, 100.8695652]
copper_10_4h = [95.05813953, 109.8837209, 107.2674419]
copper_10_24h = [90.26086957, 83.47826087, 83.47826087, 151.3043478, 97.04347826, 83.47826087]

# Standard Errors

se_copper_200_0h = [4.09656437, 3.968546733, 5.504758372]
se_copper_200_1h = [0.010388655, 0.002707346, 0.012592309, 0.008594251, 0.010073847, 0.002990673]
se_copper_200_4h = [7.60546E-05, 0.00016732, 0.000152109, 0.000116617, 0.000101406, 4.56328E-05]
se_copper_200_24h = [0, 0, 0, 0, 0, 0]

se_copper_100_0h = [0.896740874, 0.527987617, 0.854837095]
se_copper_100_1h = [1.358040372, 1.535176073, 0.944723737]
se_copper_100_4h = [0.453892559, 0.45313733, 0.478059884]
se_copper_100_24h = [0.116046693, 0.185674709, 0.425504542, 0.251434502, 0.180517078, 0.188253525]

se_copper_50_0h = [0.561510641, 0.846456339, 0.636937443]
se_copper_50_1h = [5.510888468, 2.351968471, 5.904523358, 2.312604982, 5.904523358, 1.594221307]
se_copper_50_4h = [2.031565698, 1.82010161, 1.880519921]
se_copper_50_24h = [3.610341569, 4.770808502, 5.673393894]

se_copper_10_0h = [5.440749554, 5.312731917, 6.272864191]
se_copper_10_1h = [3.399923296, 3.211038668, 3.651769466]
se_copper_10_4h = [2.76331801, 3.194294213, 3.118239589]
se_copper_10_24h = [6.230560092, 5.762367715, 5.762367715, 10.44429148, 6.698752469, 5.762367715]

# 
times = np.array([0.1, 1.5, 4, 24])

# Means calculated 
means = {
    '100 mg/L': [
        np.mean(copper_200_0h),
        np.mean(copper_200_1h),
        np.mean(copper_200_4h),
        np.mean(copper_200_24h),
    ],
    '50 mg/L': [
        np.mean(copper_100_0h),
        np.mean(copper_100_1h),
        np.mean(copper_100_4h),
        np.mean(copper_100_24h),
    ],
    '25 mg/L': [
        np.mean(copper_50_0h),
        np.mean(copper_50_1h),
        np.mean(copper_50_4h),
        np.mean(copper_50_24h),
    ],
    '5 mg/L': [
        np.mean(copper_10_0h),
        np.mean(copper_10_1h),
        np.mean(copper_10_4h),
        np.mean(copper_10_24h),
    ]
}

def combined_se(se_list):
    se_array = np.array(se_list)
    n = len(se_array)
    return np.sqrt(np.sum(se_array**2)) / n

ses = {
    '100 mg/L': [
        combined_se(se_copper_200_0h),
        combined_se(se_copper_200_1h),
        combined_se(se_copper_200_4h),
        combined_se(se_copper_200_24h),
    ],
    '50 mg/L': [
        combined_se(se_copper_100_0h),
        combined_se(se_copper_100_1h),
        combined_se(se_copper_100_4h),
        combined_se(se_copper_100_24h),
    ],
    '25 mg/L': [
        combined_se(se_copper_50_0h),
        combined_se(se_copper_50_1h),
        combined_se(se_copper_50_4h),
        combined_se(se_copper_50_24h),
    ],
    '5 mg/L': [
        combined_se(se_copper_10_0h),
        combined_se(se_copper_10_1h),
        combined_se(se_copper_10_4h),
        combined_se(se_copper_10_24h),
    ],
}

# Calculate medians
medians = {
    '100 mg/L': [
        np.median(copper_200_0h),
        np.median(copper_200_1h),
        np.median(copper_200_4h),
        np.median(copper_200_24h),
    ],
    '50 mg/L': [
        np.median(copper_100_0h),
        np.median(copper_100_1h),
        np.median(copper_100_4h),
        np.median(copper_100_24h),
    ],
    '25 mg/L': [
        np.median(copper_50_0h),
        np.median(copper_50_1h),
        np.median(copper_50_4h),
        np.median(copper_50_24h),
    ],
    '5 mg/L': [
        np.median(copper_10_0h),
        np.median(copper_10_1h),
        np.median(copper_10_4h),
        np.median(copper_10_24h),
    ],
}

#print(medians)

# Save data
output_dir = Path(r"C:\Users\asus\OneDrive\Documents\MEBiom\TU\ME_part2\Plots\Survivability_Plots")  # Change this to your desired folder path
output_dir.mkdir(parents=True, exist_ok=True)  # Create directory if it doesn't exist

output_filename = "copper_survivability_summary_6decimals.txt"
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

plt.title('Fraction of surviving cells in copper chloride relative to control', fontsize=20)
plt.xlabel('Time (hours)', fontsize=18)
plt.ylabel('Percentage of surviving cells relative to control (%)', fontsize=18)
plt.xticks(times, ['0.1h', '1.5h', '4h', '24h'], fontsize=14)
plt.yticks(fontsize=14)
plt.legend(title='Copper Chloride Group')
plt.grid(True)
plt.show()
