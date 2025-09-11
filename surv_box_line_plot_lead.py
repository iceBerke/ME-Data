import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

# Data

lead_200_0h = [21.95121951, 36.58536585, 51.2195122]
lead_200_1h = [11.14285714, 1.714285714, 0.857142857]
lead_200_4h = [11.70731707, 10.24390244, 5.12195122]
lead_200_24h = [1.006289308, 4.27672956, 1.194968553, 4, 0.566037736, 3.660377358]

lead_100_0h = [44.11764706, 52.94117647, 61.76470588]
lead_100_1h = [48.64864865, 60.81081081, 72.97297297, 69.72972973, 64.86486486, 93.24324324]
lead_100_4h = [83.72093023, 76.74418605, 83.72093023, 113.7209302, 111.627907, 111.627907]
lead_100_24h = [101.3513514, 73.47972973, 81.08108108, 95.77702703, 65.87837838, 119.5945946]

lead_50_0h = [61.76470588, 123.5294118, 52.94117647]
lead_50_1h = [113.5135135, 83.51351351, 72.97297297, 74.59459459, 81.08108108, 84.32432432]
lead_50_4h = [111.627907, 109.5348837, 118.6046512, 97.6744186, 111.627907, 103.9534884]
lead_50_24h = [86.14864865, 99.32432432, 167.2297297, 109.9662162, 106.4189189, 108.9527027]

lead_10_0h = [95.12195122, 43.90243902, 80.48780488, 76.82926829, 36.58536585, 52.68292683]
lead_10_1h = [92.57142857, 111.4285714, 72.85714286, 120, 99.42857143]
lead_10_4h = [117.0731707, 100.9756098, 139.0243902, 98.7804878, 124.3902439, 100.2439024]
lead_10_24h = [158.490566, 133.3333333, 144.0251572]

# Standard Errors

se_lead_200_0h = [2.141582391, 3.569303986, 4.99702558]
se_lead_200_1h = [2.546938776, 0.391836735, 0.195918367]
se_lead_200_4h = [3.744878634, 3.276768805, 1.638384402]
se_lead_200_24h = [0.11743979, 0.499119109, 0.139459751, 0.466823167, 0.066059882, 0.427187238]

se_lead_100_0h = [5.190311419, 6.228373702, 7.266435986]
se_lead_100_1h = [6.957417619, 8.696772023, 10.43612643, 9.972298587, 9.276556825, 13.33505044]
se_lead_100_4h = [3.893996755, 3.569497025, 3.893996755, 5.289345592, 5.191995673, 5.191995673]
se_lead_100_24h = [6.660600666, 4.828935483, 5.328480533, 6.294267629, 4.329390433, 7.859508786]

se_lead_50_0h = [7.266435986, 14.53287197, 6.228373702]
se_lead_50_1h = [16.23397444, 11.94356691, 10.43612643, 10.66804035, 11.59569603, 12.05952387]
se_lead_50_4h = [5.191995673, 5.094645754, 5.516495403, 4.542996214, 5.191995673, 4.835045971]
se_lead_50_24h = [5.661510566, 6.527388653, 10.9899911, 7.226751723, 6.993630699, 7.160145716]

se_lead_10_0h = [9.280190363, 4.283164783, 7.852468769, 7.49553837, 3.569303986, 5.139797739]
se_lead_10_1h = [21.15918367, 25.46938776, 16.65306122, 27.42857143, 22.72653061]
se_lead_10_4h = [37.44878634, 32.29957822, 44.47043378, 31.59741347, 39.78933548, 32.0655233]
se_lead_10_24h = [18.49676699, 15.56077223, 16.80857]


times = np.array([0.1, 1.5, 4, 24])

# Means calculated 
means = {
    '100 mg/L': [
        np.mean(lead_200_0h),
        np.mean(lead_200_1h),
        np.mean(lead_200_4h),
        np.mean(lead_200_24h),
    ],
    '50 mg/L': [
        np.mean(lead_100_0h),
        np.mean(lead_100_1h),
        np.mean(lead_100_4h),
        np.mean(lead_100_24h),
    ],
    '25 mg/L': [
        np.mean(lead_50_0h),
        np.mean(lead_50_1h),
        np.mean(lead_50_4h),
        np.mean(lead_50_24h),
    ],
    '5 mg/L': [
        np.mean(lead_10_0h),
        np.mean(lead_10_1h),
        np.mean(lead_10_4h),
        np.mean(lead_10_24h),
    ]
}

def combined_se(se_list):
    se_array = np.array(se_list)
    n = len(se_array)
    return np.sqrt(np.sum(se_array**2)) / n

ses = {
    '100 mg/L': [
        combined_se(se_lead_200_0h),
        combined_se(se_lead_200_1h),
        combined_se(se_lead_200_4h),
        combined_se(se_lead_200_24h),
    ],
    '50 mg/L': [
        combined_se(se_lead_100_0h),
        combined_se(se_lead_100_1h),
        combined_se(se_lead_100_4h),
        combined_se(se_lead_100_24h),
    ],
    '25 mg/L': [
        combined_se(se_lead_50_0h),
        combined_se(se_lead_50_1h),
        combined_se(se_lead_50_4h),
        combined_se(se_lead_50_24h),
    ],
    '5 mg/L': [
        combined_se(se_lead_10_0h),
        combined_se(se_lead_10_1h),
        combined_se(se_lead_10_4h),
        combined_se(se_lead_10_24h),
    ],
}

# Calculate medians
medians = {
    '100 mg/L': [
        np.median(lead_200_0h),
        np.median(lead_200_1h),
        np.median(lead_200_4h),
        np.median(lead_200_24h),
    ],
    '50 mg/L': [
        np.median(lead_100_0h),
        np.median(lead_100_1h),
        np.median(lead_100_4h),
        np.median(lead_100_24h),
    ],
    '25 mg/L': [
        np.median(lead_50_0h),
        np.median(lead_50_1h),
        np.median(lead_50_4h),
        np.median(lead_50_24h),
    ],
    '5 mg/L': [
        np.median(lead_10_0h),
        np.median(lead_10_1h),
        np.median(lead_10_4h),
        np.median(lead_10_24h),
    ],
}

#print(medians)

# Save data
output_dir = Path(r"C:\Users\asus\OneDrive\Documents\MEBiom\TU\ME_part2\Plots\Survivability_Plots")  # Change this to your desired folder path
output_dir.mkdir(parents=True, exist_ok=True)  # Create directory if it doesn't exist

output_filename = "lead_survivability_summary_6decimals.txt"
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

plt.title('Fraction of surviving cells in lead chloride relative to control', fontsize=20)
plt.xlabel('Time (hours)', fontsize=18)
plt.ylabel('Percentage of surviving cells relative to control (%)', fontsize=18)
plt.xticks(times, ['0.1h', '1.5h', '4h', '24h'], fontsize=14)
plt.yticks(fontsize=14)
plt.legend(title='Lead Chloride Group')
plt.grid(True)
plt.show()
