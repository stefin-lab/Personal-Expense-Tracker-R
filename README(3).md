# Personal Expense Tracker and Budget Analyzer Using R

## Project Overview
This project uses R to read personal expenses from a CSV file and generate a simple spending and budget report. It demonstrates CSV file handling, conditional statements, functions/aggregation, arithmetic operations, and loops/record processing concepts.

## Features
- Reads expense transactions from `data/expenses.csv`.
- Calculates total expenses and average transaction amount.
- Groups expenses by category and calculates each category's percentage of total spending.
- Accepts a monthly budget from the user (default: Rs. 5,000).
- Reports remaining budget and whether spending is within or over budget.
- Identifies the largest individual transaction.
- Exports detailed and summary reports as CSV files.

## Project Structure
```text
Personal-Expense-Tracker-R/
├── app.R
├── README.md
├── .gitignore
└── data/
    └── expenses.csv
```

After running the app, it also creates:
- `data/analyzed_expenses.csv`
- `data/budget_summary.csv`

## Requirements
- R (version 4.0 or later recommended)
- No additional R packages are required.

## How to Run
1. Download or clone this repository.
2. Open the project folder in RStudio, or open a terminal in the project folder.
3. Make sure `data/expenses.csv` exists. If it does not, `app.R` creates a sample file automatically.
4. Run the following command in the R console:
   ```r
   source("app.R")
   ```
5. Enter your monthly budget when prompted, or press Enter to use the default of Rs. 5,000.
6. Review the summary and category-wise analysis printed in the console.
7. Open the generated CSV reports inside the `data` folder.

## CSV Format
The input file must contain these columns:
- `Date` — date in `YYYY-MM-DD` format
- `Description` — what the expense was for
- `Category` — e.g. Food, Transport, Bills, Education
- `Amount` — non-negative numeric amount in rupees

Example:
```csv
Date,Description,Category,Amount
2026-10-01,Groceries,Food,850
2026-10-02,Bus Pass,Transport,600
```

## How It Works
1. Read the CSV file.
2. Validate required columns and amounts.
3. Ask for the monthly budget.
4. Calculate totals and average spending.
5. Aggregate transactions by category.
6. Compare total expenses with the budget using conditional statements.
7. Display the report and export results to CSV files.

## Example
Using the included sample data and a budget of Rs. 5,000, the program calculates total spending, category totals, remaining budget, and budget status from the actual CSV records.

## Notes
- The sample data is fictional and intended only for demonstration.
- Amounts are assumed to be in Indian rupees (Rs.).
- This is a console-based R project, not a web application.
