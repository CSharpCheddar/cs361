
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Properties;

/*
 * Provides all method for accessing data from the MySQL database.
 * @author Martin Mueller
 */
class Database {
	/*
	 * Instance variables
	 */
	String user;           // database username
	String password;       // database password
	String db;             // database name
	String url;            // database URL
	Connection connection; // database connection
	/*
	 * Constructor establishes connection to database.
	 */
	Database() {
		System.out.println("Fetching database credentials...");
		fetchCredentials();
		System.out.println("Connecting to database...");
		establishConnection();
		System.out.println("Connected.");
	} // constructor
	/*
	 * Reads the credentials from the db.properties
	 * file and writes them to instance variables.
	 */
	private void fetchCredentials() {
		try {
			Properties prop = new Properties();
			prop.load(new FileInputStream("db.properties"));
			user = prop.getProperty("user");
			password = prop.getProperty("password");
			db = prop.getProperty("db");
			url = prop.getProperty("url");
		} catch (FileNotFoundException e) {
			System.err.println("Database credentials not found.");
			System.exit(1);
		} catch (IOException e) {
			System.err.println("Failed to read database credentials file.");
			System.exit(2);
		}
	} // fetchCredentials method
	/*
	 * Establishes a connection with the MySQL database.
	 */
	private void establishConnection() {
		try {
			connection = DriverManager.getConnection(url + db, user, password);
		} catch (SQLException e) {
			System.err.println("Failed to establish database connection.");
			System.exit(3);
		}
	} // establishConnection method
	/*
	 * Closes the connection to the MySQL database.
	 */
	void close() {
		try {
			connection.close();
		} catch (SQLException e) {
			System.err.println("Failed to close database connection.");
			System.exit(4);
		}
	} // close method
	/*
	 * Gets the PIN of a given account.
	 * @param accountNum The number of the account
	 * @return The account's PIN
	 */
	String getPIN(int accountNum) {
		String pin = null;
		String query = "SELECT c.pin " +
				   	   "FROM Account AS a " +
				   	   "INNER JOIN Customer AS c " +
				   	   "ON a.cust_name = c.cust_name " +
				   	   "WHERE a.acc_num = ?";
		try (PreparedStatement statement = connection.prepareStatement(query)) {
			statement.setInt(1, accountNum);
			ResultSet results = statement.executeQuery();
			results.next();
			pin = results.getString(1);
		} catch (SQLException e) {
			System.err.println("Failed to retreive authentication data.");
		}
		return pin;
	} // getPIN method
	/*
	 * Gets the balance of a given account.
	 * @param accountNum The customer's account number
	 * @ return The balance of the account
	 */
	double getBalance(int accountNum) {
		double balance = -1.0;
		String query = "SELECT balance " +
				   	   "FROM Account " +
				   	   "WHERE acc_num = ?";
		try (PreparedStatement statement = connection.prepareStatement(query)) {
			statement.setInt(1, accountNum);
			ResultSet results = statement.executeQuery();
			results.next();
			balance = results.getDouble(1);
		} catch (SQLException e) {
			System.err.println("Failed to retrieve customer account data.");
		}
		return balance;
	} // getBalance method
	/*
	 * Gets all of a customer's successful transactions from the past 30 days.
	 * Each transaction record has a date, description, amount, and new balance.
	 * @param accountNum The customer's account number
	 * @return The successful transactions within the past 30 days.
	 */
	ArrayList<String> getTransactions(int accountNum) {
		ArrayList<String> transactions = new ArrayList<String>();
		String query = "SELECT DATE_FORMAT(transaction_timestamp, '%m/%d/%Y'), " +
					   "description, amount " +
			   	   	   "FROM SuccessfulTransactions " +
			   	   	   "WHERE acc_num = ? AND " +
			   	   	   "transaction_timestamp BETWEEN " +
			   	   	   "DATE_SUB(NOW(), INTERVAL 30 DAY) AND NOW() " +
			   	   	   "ORDER BY transaction_timestamp DESC";
		try (PreparedStatement statement = connection.prepareStatement(query)) {
			statement.setInt(1, accountNum);
			ResultSet results = statement.executeQuery();
			while (results.next()) {
				transactions.add(results.getString(1));
				transactions.add(results.getString(2));
				transactions.add(results.getString(3));
			}
		} catch (SQLException e) {
			System.err.println("Failed to retreive transaction record.");
		}
		return transactions;
	} // getTransactions method
	/*
	 * Withdraws a given amount from a customer's account.
	 * @param customer The customer's account number
	 * @param amount The amount to be withdrawn
	 */
	boolean withdraw(int accountNum, double amount) {
		double balance = getBalance(accountNum);
		String query = "UPDATE Account " +
				   	   "SET balance = balance - ? " +
				   	   "WHERE acc_num = ?";
		try (PreparedStatement statement = connection.prepareStatement(query)) {
			statement.setDouble(1, amount);
			statement.setInt(2, accountNum);
			statement.executeUpdate();
		} catch (SQLException e) {
			System.err.println("Failed to update account balance.");
		}
		if (balance < amount) {
			return false;
		} else {
			query = "INSERT INTO AccountTransaction " +
					"VALUES (DEFAULT, ?, 'ATM WITHDRAWL', -?, DEFAULT)";
			try (PreparedStatement statement = connection.prepareStatement(query)) {
				statement.setInt(1, accountNum);
				statement.setDouble(2, amount);
				statement.executeUpdate();
			} catch (SQLException e) {
				System.err.println("Failed to update transaction record.");
			}
		}
		return true;
	} // withdraw method
	/*
	 * Deposits a given amount into a customer's account.
	 * @param customer The customer's account number
	 * @param amount The amount to be deposited
	 */
	void deposit(int accountNum, double amount) {
		String query = "UPDATE Account " +
			   	   	   "SET balance = balance + ? " +
			   	   	   "WHERE acc_num = ?";
		try (PreparedStatement statement = connection.prepareStatement(query)) {
			statement.setDouble(1, amount);
			statement.setInt(2, accountNum);
			statement.executeUpdate();
		} catch (SQLException e) {
			System.err.println("Failed to update account balance.");
		}
		query = "INSERT INTO AccountTransaction " +
				"VALUES (DEFAULT, ?, 'ATM DEPOSIT', ?, DEFAULT)";
		try (PreparedStatement statement = connection.prepareStatement(query)) {
			statement.setInt(1, accountNum);
			statement.setDouble(2, amount);
			statement.executeUpdate();
		} catch (SQLException e) {
			System.err.println("Failed to update transaction record.");
		}
	} // deposit method
	/*
	 * Changes a customer's PIN.
	 * @param customer The customer's account number
	 * @param newPIN The customer's new PIN
	 */
	void changePIN(int accountNum, String newPIN) {
		String query = "UPDATE Customer " +
			   	   	   "SET pin = ? " +
			   	   	   "WHERE cust_name = (" +
			   	   	   "SELECT cust_name " +
			   	   	   "FROM Account " +
			   	   	   "WHERE acc_num = ?)";
		try (PreparedStatement statement = connection.prepareStatement(query)) {
			statement.setString(1, newPIN);
			statement.setInt(2, accountNum);
			statement.executeUpdate();
		} catch (SQLException e) {
			System.err.println("Failed to change PIN.");
		}
	} // changePIN method
}
