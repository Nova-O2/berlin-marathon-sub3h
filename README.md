# Pacing Variability, Not Half-Marathon Speed, Distinguishes Sub-3-Hour Success from Failure

A cluster analysis of 9,585 runners at the Berlin Marathon (1999–2025).

## Authors

- **Aldo Seffrin** — Nova O2 Sports Science, São José dos Campos, Brazil
- **Elias Villiger** — University of Zurich, Switzerland
- **Marília dos Santos Andrade** — UNIFESP, Brazil
- **Beat Knechtle** — University of Zurich, Switzerland

## Status

- **Phase:** Analysis (notebooks complete, manuscript pending)
- **Journal:** TBD
- **Data:** Berlin Marathon 1999–2025 (shared dataset, 880,779 raw records)

## Key Finding

**The Pacing Execution Paradox:** Among 9,585 runners who reached the half-marathon at identical sub-3h pace (~1:28:05), those who failed (finish >3:05) had 3.8× higher pacing variability (CV 11.5% vs 3.0%). K-Means clustering (k=2, validated by silhouette) reveals two archetypes: "Positive Split / Fade" (98.3% success rate) and "Metabolic Crash" (71.3% failure rate). Pacing CV alone predicts failure with AUC = 0.965.

## Sample

- 834,168 clean records → 9,585 in analytical cohort
- Success: 7,710 runners (finish 2:58:00–2:59:59)
- Failure: 1,875 runners (same HM pace, finish >3:05:00)
- Natural experiment: HM controlled by "Golden Window" design

## Analyses

| Notebook | Content |
|----------|---------|
| `CLEANING` | Raw CSV → clean parquet (880,779 → 834,168, documented exclusions) |
| `COHORT_DEFINITION` | Success/Failure groups via Golden Window, sensitivity analysis |
| `DESCRIPTIVES` | Table 1 (participant characteristics), Table 2 (segment paces) |
| `CLUSTERING` | K-Means (k=2 validated), cross-tabulation cluster × outcome |
| `PREDICTION` | Logistic regression (AUC 0.998), Random Forest, ROC for CV threshold |
| `FIGURES` | 5 publication-quality TIFF figures (600 DPI) |

## Figures

1. **Figure 1 — Pacing Profiles:** Mean pace per segment by cluster (with SD bands)
2. **Figure 2 — Cluster × Outcome:** Grouped bar chart (success/failure rate per archetype)
3. **Figure 3 — CV by Outcome:** Violin plot of pacing variability
4. **Figure 4 — Start vs Finish:** Scatter with even-split diagonal
5. **Figure 5 — Segment Divergence:** Paired line plot, all 9 segments significant

## Pending

- [x] Data cleaning and feature engineering
- [x] Cohort definition and validation
- [x] Descriptive statistics and tables
- [x] Clustering analysis
- [x] Predictive modeling
- [x] Publication figures
- [ ] Write manuscript (Introduction, Results, Discussion)
- [ ] Define target journal
- [ ] Co-author review

## Structure

```
data/           # Original CSV + clean parquet + cohort CSVs
notebooks/      # 6 Jupyter notebooks (full pipeline)
figures/        # 5 publication-ready TIFF figures
manuscript/     # Markdown SSOT + BibTeX + tables
```

## Tech

- Python 3.12+
- pandas, numpy, scipy, matplotlib, seaborn, statsmodels, scikit-learn, pyarrow
- Data: CSV (raw, semicolon separator) → Parquet (clean)
