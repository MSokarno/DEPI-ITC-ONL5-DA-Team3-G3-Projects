# Accepted Loans — Data Cleaning Guide

## Input and output
- Input: `data/Sampled/sample_accepted_2007_to_2018Q4.csv`
- Cleaned dataset: `data/Cleaned/accepted_cleaned.csv`
- Reports and charts: `docs/Data Cleaning/Accepted/`

## What this notebook does
1. Profiles the dataset, data types, duplicate rows, missing values, and memory usage.
2. Produces missing-value, co-missingness, outlier, category-consistency, issue-overlap, redundant-column, and date-timeline diagnostics.
3. Removes columns whose missing-value percentage is strictly greater than the lower of the dataset-wide average column missingness and 39%.
4. Applies only the additional rules explicitly listed in `APPROVED_RULES` (none are enabled by default).
5. Exports the cleaned CSV, cleaning log, before/after comparison, validation results, and missingness-based column-removal report.

## Important interpretation
- The raw sampled CSV is never overwritten.
- No missing values are imputed.
- The automatic removal rule applies to columns, not records.
- A column exactly at the cutoff is retained; only columns above the cutoff are removed.
- Review the removal report before analysis so that removed fields are understood.
