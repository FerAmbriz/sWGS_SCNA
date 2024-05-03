import pandas as pd
import sys

df = pd.read_csv(sys.argv[1], sep = '\t')
df = df[df['call']!='NEUT'].set_index('chrom')

df.to_csv(sys.argv[2], sep='\t')
