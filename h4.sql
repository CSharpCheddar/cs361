--
-- Drop all tables if they exist
--

DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Branch;
DROP TABLE IF EXISTS Customer;

--
-- Table structure for table Branch
--

CREATE TABLE Branch (
  bank_name VARCHAR(50),
  addr VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  assets FLOAT NOT NULL,
  CONSTRAINT PRIMARY KEY (bank_name)
);

--
-- Dumping data for table Branch
--

INSERT INTO Branch VALUES ('Branch1','123 Fake Dr.','Faketown, IL',100);
INSERT INTO Branch VALUES ('Branch2','124 Fake Dr.','Faketown, IL',200);

--
-- Table structure for table Customer
--

CREATE TABLE Customer (
  cust_name VARCHAR(50),
  addr VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  CONSTRAINT PRIMARY KEY (cust_name)
);

--
-- Dumping data for table Customer
--

INSERT INTO Customer VALUES ('Rob','125 Fake Dr.','Faketown, IL');
INSERT INTO Customer VALUES ('Bob','126 Fake Dr.','Faketown, IL');

--
-- Table structure for table Account
--

CREATE TABLE Account (
  acc_num INT(11),
  cust_name VARCHAR(50) NOT NULL,
  bank_name VARCHAR(50) NOT NULL,
  type VARCHAR(8) NOT NULL,
  balance FLOAT NOT NULL,
  CONSTRAINT PRIMARY KEY (acc_num),
  CONSTRAINT FOREIGN KEY (cust_name) REFERENCES Customer (cust_name)
    ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY (bank_name) REFERENCES Branch (bank_name)
    ON UPDATE CASCADE,
  CHECK (type IN ('checking','savings'))
);

--

-- Dumping data for table Account
--

INSERT INTO Account VALUES (1,'Rob','Branch1','checking',100);
INSERT INTO Account VALUES (2,'Bob','Branch2','savings',200);

--
-- Table structure for table Loan
--

CREATE TABLE Loan (
  loan_num INT(11),
  cust_name VARCHAR(50) NOT NULL,
  bank_name VARCHAR(50) NOT NULL,
  type VARCHAR(8) NOT NULL,
  amount FLOAT NOT NULL,
  CONSTRAINT PRIMARY KEY (loan_num),
  CONSTRAINT FOREIGN KEY (cust_name) REFERENCES Customer (cust_name)
    ON UPDATE CASCADE,
  CONSTRAINT FOREIGN KEY (bank_name) REFERENCES Branch (bank_name)
    ON UPDATE CASCADE,
  CHECK (type IN ('mortgage','car'))
);

--
-- Dumping data for table Loan
--

INSERT INTO Loan VALUES (1,'Rob','Branch1','mortgage',20);
INSERT INTO Loan VALUES (2,'Bob','Branch2','car',20);
