# LendingClub Data Cleaning — Quick Guide

## Folder structure
- Source samples are read from `FinalProject/data/Sampled`.
- Cleaned CSV files are written to `FinalProject/data/Cleaned`.
- Diagnostics, charts, quality reports, cleaning logs, and this guide are written to `FinalProject/docs/Data Cleaning`.

## Accepted loans notebook
- Reads `sample_accepted_2007_to_2018Q4.csv`.
- Profiles data types, missingness, duplicates, outliers, category inconsistencies, overlapping issues, redundant columns, and issue-date timelines.
- Applies the high-missingness column-removal rule.
- Applies any extra cleaning only when explicitly added to `APPROVED_RULES` (the list is empty by default).
- Exports `accepted_cleaned.csv`, comparison/validation tables, a cleaning log, and the column-removal report.

## Rejected loans notebook
- Reads `sample_rejected_2007_to_2018Q4.csv`.
- Profiles missingness/co-missingness, outliers, category variants, redundant columns, and monthly/yearly issue timelines.
- Trims repeated/outer whitespace, parses application dates, converts DTI and selected numeric fields, uppercases state codes, and keeps ZIP codes as text.
- Adds review flags for selected unusual/missing values.
- Applies the high-missingness column-removal rule.
- Exports `rejected_cleaned.csv`, an Excel quality report, cleaning log, summary, and the column-removal report.

## Column-removal rule
For each source dataset, calculate each original column's missing-value percentage and the average of those percentages across all original columns. The cutoff is:

`min(average column missingness, 39%)`

A column is removed only when its missing percentage is **strictly greater** than the cutoff. A column exactly at the cutoff remains. The report records each column's missing percentage, the calculated average, the applied cutoff, and whether the column was removed.

## Safeguards
- Neither notebook overwrites the sampled source CSV.
- Missing values are not filled or imputed.
- The rule removes columns, not rows.
- Unusual values and duplicates are reported/flagged rather than silently deleted.
- Inspect the column-removal report and cleaning log before using the cleaned data downstream.
