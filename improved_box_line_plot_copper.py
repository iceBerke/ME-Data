import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

# Data

# Copper 200 showed no motility at any of the timepoints analysed

copper_100_0h = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
copper_100_1h = [16.20879509, 18.12060169, 0, 0, 0, 21.75811163, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4.166883643, 0]
copper_100_4h = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
copper_100_24h = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

copper_50_0h = [10.67220549, 0, 0, 0, 0, 0, 0, 0, 6.209850562, 5.302793738, 0, 0, 0, 0, 4.596902364]
copper_50_1h = [0, 0, 0, 0, 5.649741761, 0, 0, 0, 13.59294305, 17.60111856, 10.34839634, 9.112083505, 9.360594873, 5.122713612, 0, 0, 0, 4.638132595]
copper_50_4h = [0, 8.424261201, 10.2129742, 0, 0, 0, 0, 0, 0, 0, 5.56378445, 5.250331805, 0, 0, 2.444416775]
copper_50_24h = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

copper_10_0h = [90.6141394, 103.5984825, 134.3503435, 117.9871607, 73.74197542, 82.23347562, 96.04984939, 99.49187603, 87.00729167, 91.47319198, 73.41423331, 64.35663309, 102.9706129, 103.2387656, 83.99086014]
copper_10_1h = [58.50371796, 88.43752211, 71.01140938, 79.20503354, 42.60684563, 81.60518607, 103.7647339, 120.1276342, 72.80462679, 47.16024898, 75.30605158, 57.42113965, 52.59043894, 45.9330306, 71.67684427, 55.58247968]
copper_10_4h = [102.1815845, 135.2028449, 104.6938504, 92.76392691, 96.1996279, 101.6655159, 78.82436471, 58.18904322, 76.95970232, 102.3299963, 87.44071117, 13.80642808]
copper_10_24h = [31.6701946, 20.47395039, 0, 6.774626518, 34.50543107, 15.87673209, 12.28437024, 24.41422009, 38.8893178, 47.67197713, 9.608566819, 11.40047282, 2.914310056, 19.69059925, 8.475679028]

# Standard Errors

se_copper_100_0h = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
se_copper_100_1h = [1.798014796, 2.010088336, 0, 0, 0, 2.413591291, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.462225502, 0]
se_copper_100_4h = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
se_copper_100_24h = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

se_copper_50_0h = [0.532245573, 0, 0, 0, 0, 0, 0, 0, 0.309698448, 0.264461596, 0, 0, 0, 0, 0.229257292]
se_copper_50_1h = [0, 0, 0, 0, 0.455994335, 0, 0, 0, 1.097095282, 1.420597737, 0.835225805, 0.735442191, 0.755499706, 0.41345755, 0, 0, 0, 0.374346701]
se_copper_50_4h = [0, 0.636654613, 0.771834702, 0, 0, 0, 0, 0, 0, 0, 0.420477114, 0.396788262, 0, 0, 0.184734207]
se_copper_50_24h = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

se_copper_10_0h = [4.519119749, 5.166676543, 6.700337219, 5.884270507, 3.677669067, 4.101158232, 4.790210161, 4.961871346, 4.339238586, 4.561962528, 3.661323871, 3.209602095, 5.135363351, 5.148736693, 4.188802734]
se_copper_10_1h = [4.72187316, 7.13784998, 5.731377077, 6.392689817, 3.438826246, 6.58640769, 8.374919218, 9.695579556, 5.876108822, 3.806334395, 6.078000445, 4.634497561, 4.244608561, 3.707284801, 5.785084761, 4.486098117]
se_copper_10_4h = [7.722264959, 10.21781172, 7.912126793, 7.01053547, 7.270184932, 7.683263621, 5.95706783, 4.397575276, 5.816147945, 7.73348103, 6.608239081, 1.043406171]
se_copper_10_24h = [2.342476892, 1.514349889, 0, 0.501083314, 2.552184347, 1.174317951, 0.908609934, 1.805790811, 2.876437276, 3.526044163, 0.710694899, 0.843232714, 0.21555611, 1.456409546, 0.626901177]

# 
times = np.array([0.1, 1.5, 4, 24])

# Means calculated 
means = {
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
output_dir = Path(r"C:\Users\asus\OneDrive\Documents\MEBiom\TU\ME_part2\Plots\Motility_Plots")  # Change this to your desired folder path
output_dir.mkdir(parents=True, exist_ok=True)  # Create directory if it doesn't exist

output_filename = "copper_motility_summary.txt"
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
                     alpha=0.3, color=colors[group])

plt.title('Fraction of motile cells in copper chloride relative to control', fontsize=20)
plt.xlabel('Time (hours)', fontsize=18)
plt.ylabel('Percentage of motile cells relative to control (%)', fontsize=18)
plt.xticks(times, ['0.1h', '1.5h', '4h', '24h'], fontsize=14)
plt.yticks(fontsize=14)
plt.legend(title='Copper Chloride Group')
plt.grid(True)
plt.show()
