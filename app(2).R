# Personal Expense Tracker and Budget Analyzer Using R
# Run from the project folder with: source("app.R")

options(stringsAsFactors = FALSE)

DATA_DIR <- "data"
INPUT_FILE <- file.path(DATA_DIR, "expenses.csv")
OUTPUT_FILE <- file.path(DATA_DIR, "analyzed_expenses.csv")
SUMMARY_FILE <- file.path(DATA_DIR, "budget_summary.csv")

if (!dir.exists(DATA_DIR)) dir.create(DATA_DIR, recursive = TRUE)

# Create a sample CSV automatically if it does not exist.
if (!file.exists(INPUT_FILE)) {
  sample_expenses <- data.frame(
    Date = c("2026-10-01", "2026-10-02", "2026-10-03", "2026-10-04",
             "2026-10-05", "2026-10-06", "2026-10-07", "2026-10-08"),
    Description = c("Groceries", "Bus Pass", "Lunch", "Mobile Recharge",
                    "Notebook", "Movie", "Electricity Bill", "Snacks"),
    Category = c("Food", "Transport", "Food", "Bills",
                 "Education", "Entertainment", "Bills", "Food"),
    Amount = c(850, 600, 180, 299, 120, 250, 950, 100),
    stringsAsFactors = FALSE
  )
  write.csv(sample_expenses, INPUT_FILE, row.names = FALSE)
}

cat("\n")
cat("====================================================\n")
cat("       PERSONAL EXPENSE TRACKER AND BUDGET ANALYZER\n")
cat("====================================================\n\n")

# Read the expense records from CSV.
expenses <- tryCatch(
  read.csv(INPUT_FILE, stringsAsFactors = FALSE),
  error = function(e) {
    stop("Could not read data/expenses.csv. Check the file and try again.")
  }
)

required_columns <- c("Date", "Description", "Category", "Amount")
missing_columns <- setdiff(required_columns, names(expenses))
if (length(missing_columns) > 0) {
  stop(paste("Missing required CSV column(s):", paste(missing_columns, collapse = ", ")))
}

expenses$Amount <- suppressWarnings(as.numeric(expenses$Amount))
if (any(is.na(expenses$Amount)) || any(expenses$Amount < 0)) {
  stop("Every Amount must be a valid non-negative number in data/expenses.csv.")
}
if (nrow(expenses) == 0) stop("The expense CSV contains no records.")

# Budget can be edited here, or entered when prompted.
default_budget <- 5000
budget_input <- readline(
  paste0("Enter your monthly budget in Rs. (press Enter for Rs. ",
         default_budget, "): ")
)
if (trimws(budget_input) == "") {
  monthly_budget <- default_budget
} else {
  monthly_budget <- suppressWarnings(as.numeric(budget_input))
  if (is.na(monthly_budget) || monthly_budget < 0) {
    cat("Invalid budget. Using default budget of Rs.", default_budget, "\n")
    monthly_budget <- default_budget
  }
}

# Add date/month fields and calculate totals.
expenses$Date <- as.character(expenses$Date)
expenses$Month <- substr(expenses$Date, 1, 7)
total_expense <- sum(expenses$Amount)
average_expense <- mean(expenses$Amount)
largest_expense_index <- which.max(expenses$Amount)
largest_expense <- expenses[largest_expense_index, ]

# Category-wise analysis.
category_totals <- aggregate(Amount ~ Category, data = expenses, FUN = sum)
category_totals <- category_totals[order(-category_totals$Amount), ]
names(category_totals)[2] <- "Total_Amount"
category_totals$Percentage <- round(
  category_totals$Total_Amount / total_expense * 100, 2
)

# Budget status.
remaining_budget <- monthly_budget - total_expense
budget_status <- if (total_expense > monthly_budget) {
  "OVER BUDGET"
} else if (total_expense == monthly_budget) {
  "BUDGET FULLY USED"
} else {
  "WITHIN BUDGET"
}

# Add useful analysis columns and export the detailed report.
expenses$Category_Total <- category_totals$Total_Amount[
  match(expenses$Category, category_totals$Category)
]
expenses$Budget_Status <- budget_status
write.csv(expenses, OUTPUT_FILE, row.names = FALSE)

summary_table <- data.frame(
  Metric = c("Monthly Budget (Rs.)", "Total Expenses (Rs.)",
             "Remaining Budget (Rs.)", "Average Expense (Rs.)",
             "Number of Transactions", "Largest Expense (Rs.)",
             "Budget Status"),
  Value = c(
    round(monthly_budget, 2),
    round(total_expense, 2),
    round(remaining_budget, 2),
    round(average_expense, 2),
    nrow(expenses),
    round(largest_expense$Amount, 2),
    budget_status
  ),
  stringsAsFactors = FALSE
)
write.csv(summary_table, SUMMARY_FILE, row.names = FALSE)

cat("\n---------------- OVERALL SUMMARY -------------------\n")
cat(sprintf("Monthly Budget       : Rs. %.2f\n", monthly_budget))
cat(sprintf("Total Expenses       : Rs. %.2f\n", total_expense))
cat(sprintf("Remaining Budget     : Rs. %.2f\n", remaining_budget))
cat(sprintf("Average Transaction  : Rs. %.2f\n", average_expense))
cat(sprintf("Number of Transactions: %d\n", nrow(expenses)))
cat(sprintf("Largest Expense      : %s (Rs. %.2f)\n",
            largest_expense$Description, largest_expense$Amount))
cat(sprintf("Budget Status        : %s\n", budget_status))

cat("\n---------------- CATEGORY ANALYSIS -----------------\n")
print(category_totals, row.names = FALSE)

cat("\n---------------- TRANSACTION RECORDS ---------------\n")
print(expenses[, c("Date", "Description", "Category", "Amount")],
      row.names = FALSE)

cat("\n---------------- SAVED REPORTS ---------------------\n")
cat("Detailed report : ", OUTPUT_FILE, "\n", sep = "")
cat("Budget summary  : ", SUMMARY_FILE, "\n", sep = "")
cat("\nAnalysis completed successfully.\n")
