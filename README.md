# Pacing Variability, Not Half-Marathon Speed, Distinguishes Sub-3-Hour Success from Failure

A cluster analysis of 9,585 runners at the Berlin Marathon (1999–2025).

## Authors

- **Aldo Seffrin** — Nova O2 Sports Science, São José dos Campos, Brazil
- **Elias Villiger** — University of Zurich, Switzerland
- **Marília dos Santos Andrade** — UNIFESP, Brazil
- **Thomas Rosemann** — University of Zurich, Switzerland
- **Katja Weiss** — University of Zurich, Switzerland
- **Daniel Ferreira** — Nova O2 Sports Science, São José dos Campos, Brazil
- **Beat Knechtle** — University of Zurich, Switzerland

## Status

- **Phase:** Submitted
- **Journal:** Sports Medicine
- **Data:** Berlin Marathon 1999–2025 (880,779 raw records)

## Key Finding

**The Pacing Execution Paradox:** Among 9,585 runners who reached the half-marathon at identical sub-3h pace (~1:28:05), those who failed (finish >3:05) had 3.8x higher pacing variability (CV 11.5% vs 3.0%). K-Means clustering (k=2) identified two archetypes: "Positive Split / Fade" (98.3% success rate) and "Metabolic Crash" (71.3% failure rate). Pacing CV alone predicted failure with AUC = 0.965.

## Reproduction

Download the dataset from Zenodo (https://doi.org/10.5281/zenodo.19342683) and place in `data/`. See [`data/README.md`](data/README.md) for details.

```bash
pip install -r requirements.txt
```

Run notebooks in order:

```
CLEANING → COHORT_DEFINITION → DESCRIPTIVES → CLUSTERING → PREDICTION → FIGURES
```

## Structure

```
data/                          # Dataset (download from Zenodo)
├── README.md                  # Reproduction instructions

notebooks/
├── CLEANING.ipynb             # Raw CSV → clean parquet
├── COHORT_DEFINITION.ipynb    # Golden Window matching → cohorts
├── DESCRIPTIVES.ipynb         # Table 1 & Table 2
├── CLUSTERING.ipynb           # K-Means pacing archetypes
├── PREDICTION.ipynb           # Logistic regression, Random Forest, ROC
└── FIGURES.ipynb              # Publication figures (TIFF 600 DPI)

figures/
├── Figure_1_Pacing_Profiles.tiff
├── Figure_2_Cluster_Outcome.tiff
├── Figure_3_CV_by_Outcome.tiff
├── Figure_4_Start_vs_Finish.tiff
├── Figure_5_Segment_Divergence.tiff
└── supplementary/
    ├── Supp_1_Clustering_Validation.tiff
    └── Supp_2_ROC_Pacing_CV.tiff
```

## License

MIT — Copyright (c) 2026 Nova O2 Sports Science
