/* Question 1 */
DELIMITER //
CREATE TRIGGER UpdateAccountOrOverdraft
  AFTER UPDATE ON Account
  FOR EACH ROW
  BEGIN
    IF (NEW.balance < 0) THEN
      UPDATE Account
        SET balance = OLD.balance;
      INSERT INTO AccountTransaction (acc_num, description, amount)
        VALUES(NEW.acc_num, 'OVERDRAFT ATTEMPT', NEW.balance - OLD.balance);
      INSERT INTO OverdraftAttempt
        VALUES(
          (SELECT transaction_id
             FROM AccountTransaction
             ORDER BY transaction_timestamp DESC
             LIMIT 1),
          OLD.balance
        );
    END IF;
  END//
DELIMITER ;

/* Question 2 */
CREATE VIEW SuccessfulTransactions AS
  SELECT *
  FROM AccountTransaction
  WHERE description <> 'OVERDRAFT ATTEMPT';

/* Question 3 */
DELIMITER //
CREATE PROCEDURE compoundInterest()
  COMMENT 'Computes daily compound interest for each savings accounts.'
  BEGIN
    DECLARE acc_num INT DEFAULT 0;
    DECLARE balance INT DEFAULT 0;
    DECLARE interest DECIMAL(20, 10) DEFAULT 0;
    DECLARE interest_rate DECIMAL (7, 6) DEFAULT 0;
    DECLARE n INT DEFAULT 365;
    DECLARE t INT DEFAULT 1;
    DECLARE more_rows TINYINT DEFAULT 1;
    DECLARE accounts CURSOR FOR
      SELECT a.acc_num, balance, interest, interest_rate / 100
        FROM Account AS a
        LEFT JOIN AccruedInterest AS i
        ON a.acc_num = i.acc_num
        WHERE type = 'savings';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET more_rows = 0;
    OPEN accounts;
    FETCH accounts INTO acc_num, balance, interest, interest_rate;
    WHILE more_rows DO
      IF interest = NULL THEN
        # Stuff
      ELSE
        # Other stuff
      END IF;
      FETCH accounts INTO acc_num, balance, interest, interest_rate;
    END WHILE;
    CLOSE accounts;
  END//
DELIMITER ;

/* Question 4 */

