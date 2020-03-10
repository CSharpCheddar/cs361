/*
 CS 361 - Spring 2020
 Homework 6
 Martin Mueller
 10 points

Prelim Due: 3/5 (before class) - Submit to Canvas before class, and bring printed copy to class
Due: 3/10 (before class) - Submit to Canvas before class, and bring printed copy to class

Consider the schema below that models a bank’s branches, customers and their accounts and loans. Provide SQL queries to answer the questions that follow.

Branch (bank_name, addr, city, assets) // Primary Key=bank_name
Customer (cust_name, addr, city) // Primary Key=cust_name
Account (acc_num, cust_name, bank_name, type, balance) // Primary Key=acc_num
Loan (loan_num, cust_name, bank_name, type, amount)  // Primary Key=loan_num

*/


-- 1. List the names of all account customers together with their account numbers.

SELECT cust_name, acc_num FROM Account;

-- 2. List the unique names of all customers, sorted in descending order,
--    that have a loan at a bank branch with more than $10,000 in assets.

SELECT DISTINCT cust_name FROM Loan, Branch
  WHERE Loan.bank_name = Branch.bank_name AND Branch.assets > 10000
  ORDER BY cust_name DESC;

-- 3. List the names of all bank branches and the number of accounts they have.

SELECT bank_name, COUNT(acc_num) FROM Branch, Account
  WHERE Branch.bank_name = Account.bank_name;

-- 4. List the total loans amount for every customer who has more than 3 loans.

SELECT SUM(amount) FROM Loan
  GROUP BY cust_name
  HAVING COUNT(*) > 3;

-- 5. List customers and their account numbers and balances
--    paired with other customers and their loan numbers, types and amounts
--    for loans greater than $5,000 that the first paired customer has enough money to pay for.

SELECT Account.cust_name, Account.acc_num, Account.balance,
  Loan.cust_name, Loan.loan_num, Loan.type, Loan.amount
  WHERE amount > 5000 AND balance > amount;
