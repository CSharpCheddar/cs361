
import java.util.ArrayList;

/*
 * Handles business logic of the application.
 * @author Martin Mueller
 */
class Logic {
	/*
	 * Instance variables
	 */
	Database db; // handles interaction with MySQL database
	/*
	 * Constructor initializes Database object.
	 */
	Logic() {
		db = new Database();
	} // constructor
	/*
	 * Determines if the given PIN is valid for the given account.
	 * @param accountNum The account number
	 * @param PIN The account's PIN
	 * @return Whether the credentials match
	 */
	boolean authenticate(int accountNum, String PIN) {
		return db.getPIN(accountNum).equals(PIN) ? true : false;
	} // authenticate method
	/*
	 * Retrieves the balance of a given account.
	 * @param accountNum The customer's account number
	 * @return The balance of the given account
	 */
	String getBalance(int accountNum) {
		return String.format("$%.2f", db.getBalance(accountNum));
	} // getBalance method
	/*
	 * Gets a record of all transactions on a customer's account in
	 * the past 30 days and formats them into a table.
	 * @param accountNum The customer's account number
	 * @return The transaction record table
	 */
	String getTransactions(int accountNum) {
		ArrayList<String> transactions = db.getTransactions(accountNum);
		StringBuilder sb = new StringBuilder("");
		sb.append("+-------------------+-------------------+-------------------+-------------------+\n");
		sb.append(String.format("| %17s | %17s | %17s | %17s |\n", "Date", 
																   "Description",
																   "Amount",
																   "New Balance"));
		sb.append("+-------------------+-------------------+-------------------+-------------------+\n");
		double newBalance = db.getBalance(accountNum);
		for (int i = 0; i < transactions.size() / 3; i++) {
			double amount = Double.parseDouble(transactions.get(3 * i + 2));
			String formattedAmount = "";
			if (amount < 0) {
				formattedAmount = String.format("-$%,.2f", -1.0 * amount);
			} else {
				formattedAmount = String.format("+$%,.2f", amount);
			}
			String formattedBalance = String.format("$%,.2f", newBalance);
			sb.append(String.format("| %17s | %17s | %17s | %17s |\n", transactions.get(3 * i),
																	   transactions.get(3 * i + 1),
																	   formattedAmount,
																	   formattedBalance));
			newBalance -= Double.parseDouble(transactions.get(3 * i + 2));
		}
		sb.append("+-------------------+-------------------+-------------------+-------------------+\n");
		return sb.toString();
	} // getTransactions method
	/*
	 * Withdraws a given amount from a customer's account.
	 * @param customer The customer's account number
	 * @param amount The amount to be withdrawn
	 */
	boolean withdraw(int accountNum, double amount) {
		return db.withdraw(accountNum, amount);
	} // withdraw method
	/*
	 * Deposits a given amount into a customer's account.
	 * @param customer The customer's account number
	 * @param amount The amount to be deposited
	 */
	void deposit(int accountNum, double amount) {
		db.deposit(accountNum, amount);
	} // deposit method
	/*
	 * Changes a customer's PIN.
	 * @param customer The customer's account number
	 * @param newPIN The customer's new PIN
	 */
	void changePIN(int accountNum, String newPIN) {
		db.changePIN(accountNum, newPIN);
	} // changePIN method
	/*
	 * Safely shuts down logic by closing the database connection.
	 */
	void close() {
		db.close();
	} // close method
}
