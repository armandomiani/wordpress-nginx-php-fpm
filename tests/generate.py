import sys

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load the data
input_file = sys.argv[1]
df = pd.read_csv(input_file, sep="\t", comment="#")

# Create the plot
plt.figure(figsize=(12, 6))
sns.lineplot(x=range(len(df)), y=df["ttime"], marker="o", linestyle="-", label="Total Response Time (ms)")

# Customize the plot
plt.title("Apache Bench Response Times")
plt.xlabel("Request Number")
plt.ylabel("Response Time (ms)")
plt.grid(True)
plt.legend()

# Save & show the plot
output_file = 'benchmark.png'
print(f'Chart generated at: {output_file}')
plt.savefig(output_file)
