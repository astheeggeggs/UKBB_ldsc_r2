import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import umap

corr = pd.read_csv('../inputs/input_to_UMAP_corr.tsv', header=None).values

standard_embedding_2d = umap.UMAP(random_state=42).fit_transform(corr)
standard_embedding_3d = umap.UMAP(random_state=42, n_components=3).fit_transform(corr)

pd.DataFrame(standard_embedding_2d).to_csv('../inputs/UMAP_output_rg_2d.csv')
pd.DataFrame(standard_embedding_3d).to_csv('../inputs/UMAP_output_rg_3d.csv')
