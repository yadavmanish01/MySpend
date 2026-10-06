# Spendly — Smart Expense & Receipt Manager

Spendly is a modern personal finance management application built with **Flutter, BLoC, and Firebase**. It helps users track income and expenses, manage budgets and savings goals, analyze spending patterns, and scan receipts using OCR to automatically extract transaction details.

## Features

### Authentication
- Firebase Authentication
- Email & Password Login
- User Registration
- Forgot Password
- Profile Management

### Expense Management
- Add income and expenses
- Categorize transactions
- Add notes and payment methods
- Transaction history
- Search and filter transactions
- Transaction details

### Receipt OCR
Scan a physical receipt and automatically extract:

- Merchant name
- Total amount
- Date
- Expense category

```text
Scan Receipt
      ↓
OCR Processing
      ↓
Extract Details
      ↓
Review & Edit
      ↓
Confirm
      ↓
Save Transaction
