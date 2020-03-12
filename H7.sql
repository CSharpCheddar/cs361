/*
 CS 361 - Spring 2020
 Homework 7
 Martin Mueller
 10 points

Prelim Due: 3/10 (before class) - Submit to Canvas before class, and bring printed copy to class
Due: 3/12 (before class) - Submit to Canvas before class, and bring printed copy to class

Consider the schema below that models a bank’s branches, customers and their accounts and loans.
Provide SQL queries to answer the questions that follow. 

Branch (bank_name, addr, city, assets) // Primary Key=bank_name
Customer (cust_name, addr, city) // Primary Key=cust_name
Account (acc_num, cust_name, bank_name, type, balance) // Primary Key=acc_num
Loan (loan_num, cust_name, bank_name, type, amount)  // Primary Key=loan_num

*/

-- 1. Find the customer(s) who has(ve) the loan(s) with the highest amount. 
--    (Note: Different customers may have loans with the same amount.)

SELECT *
  FROM Customer
  WHERE Loan.amount = (SELECT MAX(amount) FROM Loan);

-- 2. Find the names of all the customers who live in a city with no bank branches.
-- a) Use a nested subquery.

SELECT cust_name
  FROM Customer
  WHERE city NOT IN (SELECT city FROM Branch);

-- b) Use a correlated subquery.

SELECT cust_name
  FROM Customer C IN (
    SELECT city FROM Branch B
      WHERE C.city <> B.city
  );

-- 3. Find the bank with the largest total account balance, i.e., the bank 
--    that has the most funds in accounts with it.

SELECT bank_name
  FROM Branch
  WHERE bank_name = (
    SELECT bank_name
      FROM Account
      ORDER BY SUM(balance)
      LIMIT 1;
  );

-- 4. Use a join to list customers and their account numbers and balances 
--    paired with other customers and their loan numbers, types and amounts 
--    for loans greater than $5,000 that the first paired customer has enough 
--    money to pay for.

SELECT Account.cust_name, Account.acc_num, Account.balance,
  Loan.cust_name, Loan.loan_num, Loan.type, Loan.amount
  WHERE amount > 5000 AND balance > amount;
