# Rejected Loans - Data Cleaning Guide

## Input and outputs
- Input: `data/Sampled/sample_rejected_2007_to_2018Q4.csv`
- Flagged, initially cleaned dataset: `data/Cleaned/Sample/rejected_flagged.csv`
- Main cleaned dataset: `data/Cleaned/Sample/rejected_cleaned.csv`
- Extreme DTI investigation dataset: `data/Cleaned/Sample/rejected_extreme_dti.csv`
- Charts: `docs/Data Cleaning/Sample/Rejected/Before_Cleaning/` and `After_Cleaning/`
- Diagnostic tables: `docs/Data Cleaning/Sample/Rejected/Diagnostic_Tables/`
- Reports: `docs/Data Cleaning/Sample/Rejected/Reports/`

## Dataset definitions
1. `rejected_flagged.csv` contains all rows after the notebook's initial type/text normalization and includes review flags. It retains `Policy Code`.
2. `rejected_cleaned.csv` starts from the flagged dataset and removes rows with non-positive Amount Requested, missing Loan Title, missing Risk_Score, negative DTI, or missing Employment Length. It also excludes extreme upper-tail DTI outliers and drops `Policy Code`.
3. `rejected_extreme_dti.csv` contains only rows that pass the other approved row rules and have DTI strictly above the IQR upper bound. It contains no normal, missing, or negative DTI values and drops `Policy Code`.

## DTI outlier rule
- Negative DTI values are treated as invalid/domain violations and are excluded before calculating the upper-tail IQR threshold.
- Q1 and Q3 are calculated from non-null, non-negative DTI values.
- IQR = Q3 - Q1.
- Upper bound = Q3 + 1.5 x IQR.
- A DTI value is extreme only when it is strictly greater than this upper bound.
- The same calculated upper bound is used for `Flag_DTI_Extreme` and for separating the two analytical datasets.
- If there are fewer than four valid non-negative DTI values, the threshold is unavailable and no values are classified as extreme.

## Other cleaning decisions
- `Policy Code` and the nine `Flag_*` review columns remain in the flagged dataset for traceability, but are removed from the main and extreme DTI datasets.
- DTI nulls are retained in the main cleaned dataset because no DTI-null removal rule was approved.
- No missing values are imputed and no duplicate rows are deleted.
- No automatic column deletion is performed from the global missingness percentage. The notebook reports missingness, while column removal follows explicitly approved rules only.
- The raw source CSV is never overwritten.
