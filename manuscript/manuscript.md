# Introduction

<!-- One sentence per line for clean git diffs -->
<!-- TODO: write Introduction after Methods and Results are finalized -->

# Methods

## Study Design and Data Source

This study employed a retrospective observational design leveraging a large-scale dataset to analyze pacing strategies and performance resilience among sub-3-hour marathon runners.
Data were extracted from the official BMW Berlin Marathon Results Archive, covering a 27-year period from 1999 to 2025.
The Berlin Marathon was selected as the primary data source due to its status as a World Athletics Platinum Label Road Race and a World Marathon Major.
Its predominantly flat course profile (elevation gain < 20 m) and historically consistent environmental conditions minimize the confounding effects of topography on pacing behavior, establishing an ideal setting for investigating the physiological and strategic dynamics of endurance running [@weiss2024; @weiss2022].
The initial data extraction yielded a master dataset of *n* = 880,779 finishers recorded via electronic transponder timing systems (chip timing).
Given that the data were obtained from a publicly accessible repository and analyzed in an anonymized format, this study was exempt from Institutional Review Board (IRB) approval, in accordance with standard ethical guidelines for the use of public secondary data.

## Data Pre-processing and Normalization

Prior to statistical analysis, the raw data underwent a systematic pre-processing and normalization procedure to ensure consistency across the 27-year longitudinal archive.
Categorical variables, specifically gender, were harmonized from various archival formats---including distinct German and English terminologies used in earlier editions of the race---into a standardized binary classification (M/F).
Temporal variables, originally recorded in string format (HH:MM:SS), were converted into continuous numeric values (total seconds) to facilitate the mathematical computation of derived pacing metrics.
Records with a value of 00:00:00 were treated as missing data.
To ensure analytical rigor and physiological validity, the dataset was filtered to exclude biologically implausible performances (< 1:59:00) and recreational walking efforts exceeding the official event time limit (> 6:15:00).
Additionally, records containing missing values for any of the nine split checkpoints (5 km through 40 km) or the half-marathon and net finish time were removed via listwise deletion.
A monotonicity check was applied to verify that split times were strictly increasing for each runner; records failing this check were excluded.
Finally, runners with any segment pace outside the physiologically plausible range of 2.5--10.0 min/km were removed.
The sequential exclusion process was as follows: missing net finish time (*n* = 2), missing half-marathon split (*n* = 699), implausible finish times (*n* = 7,408), missing any split checkpoint (*n* = 16,062), non-monotonic splits (*n* = 57), and extreme segment paces (*n* = 22,383).
Consequently, 46,611 records (5.3% of the initial sample) were excluded, resulting in a complete-case dataset of 834,168 finishers for the subsequent analysis.

## Participants and Cohort Selection

From the valid dataset, we established two groups using a quasi-experimental matching design based on half-marathon split times.
The Success Group was defined as runners who broke the sub-3-hour barrier within a narrow window of 2:58:00 to 2:59:59 (*n* = 7,710).
This range was selected to capture "barrier breakers" running at their physiological limit, deliberately excluding faster runners for whom a sub-3-hour finish might represent a sub-maximal effort.
To identify a comparable Failure Group, we calculated the mean half-marathon split of the Success Group (1:28:05 ± 2:01).
This mean ± 30 seconds---termed the "Golden Window" (1:27:35 to 1:28:35)---was then applied as an inclusion filter for the entire cohort.
Runners who passed the halfway mark within this window but finished with a net time exceeding 3:05:00 were classified into the Failure Group (*n* = 1,875).
This design ensured that all analyzed subjects possessed comparable baseline capacity at the half-marathon point, attributing the divergence in final outcome exclusively to pacing execution in the second half.
Runners finishing in the "grey zone" (3:00:00--3:04:59; *n* = 1,562) were excluded to maximize the contrast between success and metabolic collapse.
Following these criteria, the final analytical cohort consisted of *n* = 9,585 runners.

## Operational Definitions and Outcome Measures

To characterize pacing behavior throughout the race, raw temporal splits were converted into segment paces (expressed in minutes per kilometer) for nine sequential intervals: 0--5 km, 5--10 km, 10--15 km, 15--20 km, 20--25 km, 25--30 km, 30--35 km, 35--40 km, and the final 2.195 km segment (40 km--Finish).
This granular segmentation allowed for the detection of specific strategic phases, including the initial start strategy, the mid-race steady state, and the critical "metabolic wall" typically encountered after the 30 km mark [@hearris2018].

Pacing variability---serving as a proxy for execution discipline and metabolic stability---was quantified for each runner using the Coefficient of Variation (CV) across the nine segments.
The CV was calculated according to the formula *CV = (σ / μ) × 100*, where *σ* represents the standard deviation of the runner's segment paces and *μ* represents their mean race pace.
Lower CV values denote a more isokinetic ("metronomic") energy distribution, while higher values indicate chaotic pacing behaviors associated with significant positive splits and deceleration.

The primary outcome measure was defined as a binary variable: "Success" (finishing within the 2:58:00--2:59:59 barrier-breaking window) versus "Failure" (metabolic collapse resulting in a finish time > 3:05:00 despite identical half-marathon fitness).

## Pacing Phenotyping via Unsupervised Learning

To identify distinct pacing archetypes without the bias of pre-defined categories (such as "positive split" or "negative split"), we employed K-Means clustering, an unsupervised machine learning algorithm [@pedregosa2011].
Crucially, to ensure the algorithm clustered runners based on strategic execution rather than absolute velocity, the feature set was normalized: each of the nine segment paces was expressed as a percentage of the runner's individual mean race pace, rather than in absolute units (min/km).
This transformation allowed the model to group runners based on the relative trajectory of their effort distribution, treating a 3:00 min/km runner and a 4:00 min/km runner identically if they followed the same strategic pattern.
Critically, the clustering was applied to both groups combined (*n* = 9,585), enabling direct comparison of archetype distributions between outcomes.

The optimal number of clusters was determined empirically using the silhouette score [@rousseeuw1987], computed for *k* = 2 through *k* = 8.
The silhouette score quantifies how similar each data point is to its own cluster compared to other clusters, with values ranging from --1 (misclassified) to +1 (well-clustered).
The value of *k* yielding the highest mean silhouette score was selected as optimal.
To ensure reproducibility, a fixed random seed was set prior to initialization (random_state = 42).
Each resulting cluster was then analyzed and labeled according to its centroid's pacing profile.

## Statistical Analysis

Descriptive statistics were computed to characterize the cohort.
Given the non-normal distribution of pacing variables, continuous data are presented as means and standard deviations, with inferential comparisons performed using the Mann-Whitney U test.
Effect sizes were quantified using the rank-biserial correlation (*r*), calculated as *r* = 1 -- (2U / n~1~n~2~), where values of 0.1, 0.3, and 0.5 are interpreted as small, medium, and large effects, respectively.
For the segment-by-segment pacing analysis, Bonferroni correction was applied to account for multiple comparisons across nine segments (adjusted significance threshold: *p* < 0.0056).
The association between pacing archetype and race outcome was evaluated using the Chi-squared (χ²) test of independence.

To quantify the predictive power of pacing metrics, a multivariate logistic regression model was fitted using maximum likelihood estimation to predict the binary race outcome (Success vs. Failure).
Predictor variables included pacing CV, starting pace (0--5 km), late-race pace (35--40 km), finishing pace (40 km--Finish), the absolute pace change from start to finish, the late-race collapse magnitude (pace change from 25--30 km to 40 km--Finish), and the ratio of mean second-half pace to mean first-half pace.
Odds Ratios (OR) with 95% confidence intervals were extracted to determine the relative risk associated with each predictor.
Model discrimination was assessed using the area under the receiver operating characteristic curve (AUC-ROC).
To complement the parametric model, a Random Forest classifier (100 trees, balanced class weights) was trained on the same feature set, with permutation importance computed to rank predictors by their contribution to classification accuracy.

Finally, to assess the clinical utility of pacing CV as a standalone screening metric, a univariate ROC analysis was performed.
The optimal classification threshold was identified using Youden's J index (maximizing the sum of sensitivity and specificity minus one).

All data processing, statistical inference, machine learning implementation, and visualization were performed using the Python programming language (version 3.12).
Key computational libraries included Pandas and NumPy for data manipulation [@mckinney2010], SciPy for statistical testing [@virtanen2020], Scikit-learn for clustering algorithms and predictive modeling [@pedregosa2011], and Matplotlib and Seaborn for the generation of publication-quality figures.
To promote reproducibility and adhere to open science principles, the complete analytical code, datasets, and supplementary figures are available in a public repository [ANONYMOUS GITHUB LINK --- blinded for peer review].

# Results

## Participant Characteristics

The final analytical cohort comprised *n* = 9,585 runners, including 7,710 in the Success Group and 1,875 in the Failure Group.
As summarized in **Table 1**, the demographic distribution was predominantly male in both groups (Success: 94.5%; Failure: 97.5%).
The most prevalent age categories were 35--39 and 40--44 years in both groups.

[INSERT TABLE 1 HERE]

The quasi-experimental matching was validated by the near-identical half-marathon times between groups: Success runners passed the halfway mark at 1:28:05 (± 2:01), while Failure runners recorded 1:28:08 (± 0:17), a difference of only 3 seconds.
Despite this equivalent baseline fitness, finish times diverged dramatically: Success runners completed the marathon in 2:58:59 (± 0:33), whereas Failure runners finished in 3:12:34 (± 7:59), a gap of 13 minutes and 35 seconds (*p* < 0.001, *r* = 1.000).
Pacing variability was 3.8 times higher in the Failure Group (CV: 11.52% ± 5.05%) compared to the Success Group (CV: 3.02% ± 2.75%; *p* < 0.001, *r* = 0.929).

## Segment-by-Segment Pacing Analysis

All nine race segments showed statistically significant pace differences between groups after Bonferroni correction (*p* < 0.001 for all segments; adjusted threshold: *p* < 0.0056).
As detailed in **Table 2**, the pacing trajectories revealed a distinctive crossover pattern.

[INSERT TABLE 2 HERE]

In the early segments (0--15 km), Failure runners were paradoxically *faster* than Success runners, with small negative effect sizes (0--5 km: *r* = --0.292; 5--10 km: *r* = --0.275; 10--15 km: *r* = --0.132).
The crossover occurred at the 15--20 km segment, where Failure runners began to decelerate relative to their successful counterparts (*r* = 0.253).
From this point, the divergence escalated progressively through the second half of the race.
Effect sizes increased from *r* = 0.664 at 20--25 km to *r* = 0.865 at 25--30 km, reaching *r* = 0.948 at 30--35 km.
The largest absolute pace difference was observed at 35--40 km, where Failure runners averaged 5.49 ± 0.70 min/km compared to 4.43 ± 0.23 min/km in the Success Group---a gap of 1.06 min/km (*r* = 0.966).
The final segment (40--42.2 km) maintained a similarly large effect (*r* = 0.931), with Failure runners averaging 5.29 ± 0.68 min/km versus 4.33 ± 0.27 min/km.

[INSERT FIGURE 5 HERE]

## Pacing Archetypes

The silhouette analysis identified *k* = 2 as the optimal number of clusters (silhouette score = 0.44), consistently outperforming higher values of *k* (k = 3: 0.40; k = 4: 0.36; k = 5: 0.33).
The two resulting archetypes, derived from the shape-normalized pace profiles of 9,585 runners, were characterized as follows:

**Archetype 1 --- Positive Split / Fade** (*n* = 7,127; 74.3%): Runners in this cluster exhibited a controlled, gradual deceleration pattern.
Mean starting pace was 4.20 min/km, with a modest increase to 4.28 min/km by the end of the race, representing a pace change of +3.2%.
The within-runner pacing CV was 1.48%, indicating high execution discipline.

**Archetype 2 --- Metabolic Crash** (*n* = 2,458; 25.7%): Runners in this cluster displayed a dramatic late-race collapse.
Mean starting pace was 4.09 min/km---faster than Archetype 1---but deteriorated sharply to 5.20 min/km, representing a pace change of +29.1%.
The within-runner pacing CV was 11.07%, indicating highly variable and unstable pacing execution.

[INSERT FIGURE 1 HERE]

The cross-tabulation of archetype membership and race outcome revealed a highly significant association (χ² = 5,614.33, df = 1, *p* < 0.001).
Among Positive Split / Fade runners, 98.3% achieved sub-3-hour success and only 1.7% failed.
In stark contrast, among Metabolic Crash runners, 71.3% failed to break the 3-hour barrier, with only 28.7% succeeding despite their aggressive early pace.

[INSERT FIGURE 2 HERE]

## Predictive Modeling

The multivariate logistic regression model demonstrated near-perfect discrimination between Success and Failure outcomes (pseudo-R² = 0.959; AUC-ROC = 0.998).
Among the predictors evaluated, the ratio of second-half to first-half mean pace and the pace at 35--40 km were identified as the strongest contributors.

The Random Forest classifier confirmed these findings through permutation importance analysis, ranking the second-half to first-half pace ratio as the dominant predictor (importance = 0.116 ± 0.002), followed by pace at 35--40 km (0.011 ± 0.0003) and starting pace at 0--5 km (0.007 ± 0.0003).

To assess the clinical utility of a single, easily computed metric, a univariate ROC analysis was performed for pacing CV as a standalone predictor of failure.
Pacing CV alone achieved an AUC of 0.965, indicating excellent discriminative ability.
The optimal classification threshold, identified via Youden's J index, was a CV of 5.65%.
At this threshold, the model correctly identified 99.0% of all runners who failed (sensitivity), while correctly classifying 88.0% of successful runners (specificity), yielding an overall accuracy of 90.1%.

[INSERT FIGURE 3 HERE]

[INSERT FIGURE 4 HERE]

# Discussion

The primary aim of this study was to determine whether pacing execution, independent of aerobic fitness, distinguishes runners who achieve a sub-3-hour marathon from those who fail despite equivalent half-marathon capacity.
Our analysis of 9,585 runners confirms that pacing variability---not half-marathon speed---is the critical determinant of success at the sub-3-hour barrier.
Despite near-identical half-marathon split times (1:28:05 vs. 1:28:08), the Failure Group exhibited 3.8 times greater pacing variability and a 13-minute-35-second finish time deficit, demonstrating that the capacity to break 3 hours was present in both groups but was squandered through poor pacing execution.
This finding extends previous large-scale analyses of marathon pacing collapse.
Smyth et al. [@smyth2021], analyzing over 4 million race records, reported that 28% of male runners "hit the wall," with fast starts identified as especially injurious to performance.
Similarly, a recent systematic review confirmed that positive pacing strategies dominate marathon competitions, occurring in approximately 77% of races analyzed [@sha2024].
However, these prior studies could not disentangle the effects of aerobic fitness from pacing strategy, as faster runners naturally exhibit more even pacing.
The "Golden Window" design employed here overcomes this limitation by matching groups on half-marathon capacity, thereby isolating pacing execution as the sole variable of interest.

Perhaps the most counterintuitive finding is that Failure runners were paradoxically *faster* than their successful counterparts during the first 15 km of the race.
This "fast start paradox" is the hallmark of the "fly and die" strategy: an aggressive initial pace that feels sustainable in the early kilometers but carries an unsustainable metabolic cost.
The crossover point at 15--20 km---approximately the halfway mark---represents the inflection at which the consequences of excessive early glycogen utilization begin to manifest.
Rapoport [@rapoport2010], using a computational metabolic model, demonstrated that running pace above the lactate threshold depletes glycogen stores at an exponentially faster rate, effectively setting a "metabolic time bomb" that detonates in the final third of the race.
As Burke et al. [@burke2025] aptly described, the marathon is "the race within a race"---a contest not merely of speed but of energy management over 42.195 km.

The dramatic and progressive pace collapse observed after the 30 km mark (effect sizes escalating from *r* = 0.948 at 30--35 km to *r* = 0.966 at 35--40 km) is consistent with the classical physiological model of glycogen depletion [@hearris2018].
The transition from carbohydrate-dependent to lipid-dependent metabolism, which occurs upon glycogen exhaustion, necessitates a reduction in sustainable power output of approximately 15--25% due to the lower rate of ATP resynthesis from fatty acid oxidation [@rapoport2010].
The Metabolic Crash archetype identified in our cluster analysis exhibited a mean pace deterioration of 29.1%---a magnitude consistent with near-complete glycogen depletion.
The 1.06 min/km pace difference at 35--40 km between groups represents the physiological signature of this metabolic catastrophe: runners who started too fast effectively exhausted their glycogen reserves before reaching the finish line.

While physiology explains *when* the collapse occurs, it does not fully explain *why* these runners selected an unsustainable initial pace.
The psychobiological model of endurance performance [@marcora2014] posits that perceived exertion---rather than peripheral physiological limits---is the primary mediator of pacing decisions.
Under this framework, runners continuously evaluate their effort perception against the expected demands of the remaining distance and adjust pace accordingly.
However, the anticipatory regulation system described by St Clair Gibson et al. [@stclairgibson2006] and Tucker et al. [@tucker2009] can be overridden by motivational and competitive pressures, leading to pacing decisions that exceed the body's metabolic capacity.
The sub-3-hour barrier carries immense psychological significance for recreational and sub-elite runners, creating a high-pressure decision environment that may promote overconfidence and risk-taking behavior [@konings2018].
Notably, the Failure Group in our study was 97.5% male, compared to 94.5% in the Success Group, consistent with well-documented gender differences in competitive risk-taking [@niederle2007] and with our recent analysis of 873,334 Berlin Marathon finishers showing that male runners are twice as likely to experience catastrophic deceleration compared to female runners [@seffrin2026].

From a practical standpoint, the identification of a pacing CV threshold of 5.65% as a highly accurate predictor of failure (AUC = 0.965; sensitivity 99.0%; specificity 88.0%) has direct implications for coaching and race-day strategy.
Previous work by Santos-Lozano et al. [@santos-lozano2014] established that lower pacing variability is associated with superior marathon performance, with top runners maintaining a CV of approximately 7--8% across all segments.
More recently, Díaz et al. [@diaz2024] validated the CV as a robust metric for evaluating pacing behavior in long-distance running.
Our findings extend these observations by providing a specific, data-driven threshold that distinguishes success from failure at the sub-3-hour barrier.
This threshold is simple to compute from standard GPS watch data and could be integrated into real-time pacing alerts, enabling runners and coaches to detect and correct excessive variability before the metabolic damage becomes irreversible.

## Practical Applications

These findings carry several implications for coaches, athletes, and technology developers.
First, for runners targeting the sub-3-hour barrier, the data unequivocally demonstrate that the capacity is already present at the halfway mark---the critical gap is execution, not fitness.
Training programs should therefore dedicate specific sessions to pacing discipline, including race-pace tempo runs with strict segment targets and negative-split long runs.
Second, the CV threshold of 5.65% offers a concrete, actionable metric: coaches can analyze past race data to identify athletes prone to pacing collapse and design targeted interventions.
Third, modern GPS-enabled wearables are capable of computing segment-by-segment pacing variability in real time; integrating a CV-based alert system could provide runners with an early warning of impending metabolic failure, allowing corrective action before the point of no return.
Finally, given the psychological pressure associated with time barriers, mental preparation strategies---such as pre-race commitment to conservative first-half targets and cognitive reappraisal techniques for managing competitive impulses---should be incorporated into holistic race preparation.

## Limitations

Several limitations should be acknowledged.
First, while the dataset is extensive, it relies on split times and net finish times without direct physiological measures (e.g., heart rate, blood lactate, or muscle glycogen levels), precluding a definitive causal link between pacing decline and specific metabolic events.
Second, although the Berlin Marathon course is flat and conditions are relatively consistent, weather variations across the 27-year study period may have influenced aggregate pacing strategies; however, the large sample size mitigates the impact of individual anomalous years.
Third, the operational definitions employed---including the Golden Window bandwidth of ±30 seconds and the Failure cutoff of >3:05:00---represent analytical choices that, while validated through sensitivity analyses, may influence group composition.
Fourth, the K-Means algorithm with *k* = 2 provides a parsimonious but potentially simplified representation of the pacing strategy spectrum; finer-grained clustering may reveal additional subtypes that were not captured in the present analysis.
Fifth, the cohort was predominantly male (94--97%), limiting the generalizability of findings to female marathon runners.
Finally, the retrospective observational design precludes causal inference; prospective interventional studies are needed to confirm whether pacing-focused coaching interventions can reduce failure rates at the sub-3-hour barrier.

# Conclusion

This study provides compelling evidence that pacing discipline, not aerobic fitness, is the primary determinant of success at the sub-3-hour marathon barrier.
By leveraging a quasi-experimental "Golden Window" design that matched 9,585 runners on half-marathon capacity, we demonstrated that the divergence between success and failure originates entirely in pacing execution during the second half of the race.
Two distinct pacing archetypes emerged: a controlled Positive Split pattern associated with a 98.3% success rate, and a Metabolic Crash pattern---characterized by an aggressive start and catastrophic late-race collapse---associated with a 71.3% failure rate.

The identification of a pacing CV threshold of 5.65% as a single-metric predictor with 96.5% discriminative accuracy offers a practical, data-driven tool for coaches and athletes.
This threshold is computable from standard GPS data and could be operationalized as a real-time pacing alert, providing runners with actionable feedback before metabolic failure becomes irreversible.

Future research should validate this threshold across different marathon courses and environmental conditions, investigate the efficacy of CV-based real-time feedback interventions in prospective trials, and explore the psychological mechanisms---particularly the role of time-barrier pressure and competitive overconfidence---that drive the adoption of unsustainable pacing strategies in sub-elite marathon runners.

# Figure Legends

**Figure 1.** Mean pace profiles (min/km) across nine race segments for each pacing archetype.
Shaded bands represent ± 1 SD.

**Figure 2.** Distribution of race outcomes (Success vs. Failure) within each pacing archetype.

**Figure 3.** Pacing variability (CV) distributions for Success and Failure groups.

**Figure 4.** Start pace (0--5 km) versus finish pace (40 km--Finish) for each runner, colored by outcome.
The diagonal represents even-split pacing.

**Figure 5.** Segment-by-segment pacing comparison between Success and Failure groups.
All nine segments were significantly different after Bonferroni correction (*p* < 0.001).
Shaded area highlights the progressive divergence in the second half.

# References
