# Rejected Loans — Data Cleaning Guide

## Input and output
- Input: `data/Sampled/sample_rejected_2007_to_2018Q4.csv`
- Cleaned dataset: `data/Cleaned/rejected_cleaned.csv`
- Reports and charts: `docs/Data Cleaning/Rejected/50K_Sample/`

## What this notebook does
1. Profiles missing values and co-missingness.
2. Checks numeric outliers and domain-review conditions.
3. Identifies inconsistent category labels and potentially redundant columns.
4. Builds monthly and yearly issue timelines using Application Date.
5. Trims and normalizes whitespace in text fields while preserving capitalization.
6. Converts Application Date to datetime.
7. Converts Debt-To-Income Ratio to numeric after removing percent signs and commas.
8. Converts Amount Requested, Risk_Score, and Policy Code to numeric.
9. Converts State codes to uppercase and keeps Zip Code as text.
10. Adds review flags for selected suspicious or missing values.
11. Removes source columns whose missing-value percentage is strictly greater than the lower of the average column missingness and 39%.
12. Exports the cleaned CSV, quality workbook, cleaning log, summary, and column-removal report.

## Important interpretation
- The sampled source CSV is never overwritten.
- Missing values are not imputed.
- Duplicate rows and unusual numeric values are reported/flagged, not automatically deleted.
- The column-removal cutoff is calculated from the original input columns; columns exactly at the cutoff are retained.
- Review the column-removal report and cleaning log before using the output for analysis.
