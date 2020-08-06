
import java.util.Scanner;

/*
 * Starts the application and handles user interaction.
 * @author Martin Mueller
 */
class ATM {
	/*
	 * Instance variables
	 */
	static Logic logic;          // business logic
	static Scanner scanner;      // scanner for user input
	static int accountNum;       // current user's account number
	static final int MAXALA = 3; // max allowed login attempts
	/*
	 * Main method
	 */
	public static void main(String[] args) {
		startup();
		if (authenticate()) {
			run();
		}
		shutdown();
	} // main method
	/*
	 * Initializes instance variables.
	 */
	static void startup() {
		System.out.println("Starting ATM...");
		logic = new Logic();
		scanner = new Scanner(System.in);
	} // startup method
	/*
	 * Authenticates user.
	 * @return Whether the user was successfully authenticated
	 */
	static boolean authenticate() {
		for (int i = 0; i < MAXALA; i ++) {
			System.out.println("Enter your account number:");
			accountNum = scanner.nextInt();
			System.out.println("Enter your account PIN:");
			String PIN = scanner.next();
			if (logic.authenticate(accountNum, PIN)) {
				return true;
			} else {
				System.err.println("Incorrect credentials.");
			}
		}
		System.err.println("Maximum allowed login attempts reached.");
		return false;
	} // authenticate method
	/*
	 * Displays the main menu and reacts to user input.
	 */
	static void run() {
		boolean running = true;
		while (running) {
			// Print menu
			System.out.println("Select an option:");
			System.out.println("1  Balance Inquiry");
			System.out.println("2  Mini Statement");
			System.out.println("3  Cash Withdrawl");
			System.out.println("4  Deposit");
			System.out.println("5  PIN Change");
			System.out.println("6  Quit");
			// get input and react
			switch (scanner.next()) {
				case "1":
					balanceInquiry();
					break;
				case "2":
					miniStatement();
					break;
				case "3":
					cashWithdrawl();
					break;
				case "4":
					deposit();
					break;
				case "5":
					changePIN();
					break;
				case "6":
					running = false;
					break;
				default:
					invalidOption();
			}
		}
	} // run method
	/*
	 * Outputs the user's current balance.
	 */
	static void balanceInquiry() {
		System.out.println("Your current balance is: " +
				   		   logic.getBalance(accountNum));
	} // balanceInquiry method
	/*
	 * Outputs a mini statement containing the user's
	 * account transactions from the past 30 days.
	 */
	static void miniStatement() {
		System.out.print(logic.getTransactions(accountNum));
	} // miniStatement method
	/*
	 * Prompts the user for an amount to withdraw from
	 * his account, then withdraws it.
	 */
	static void cashWithdrawl() {
		System.out.println("Select an amount to withdraw:");
		System.out.println("1  $20");
		System.out.println("2  $40");
		System.out.println("3  $60");
		System.out.println("4  $100");
		System.out.println("5  $150");
		System.out.println("6  Other");
		switch (scanner.next()) {
			case "1":
				verifyWithdrawl(20.0);
				break;
			case "2":
				verifyWithdrawl(40.0);
				break;
			case "3":
				verifyWithdrawl(60.0);
				break;
			case "4":
				verifyWithdrawl(100.0);
				break;
			case "5":
				verifyWithdrawl(150.0);
				break;
			case "6":
				System.out.println("Enter the desired withdrawl amount:");
				double amount = scanner.nextDouble();
				if (amount < 0.0) {
					System.err.println("Invalid amount.");
				} else {
					verifyWithdrawl(amount);
				}
				break;
			default:
				invalidOption();
		}
	} // cashWithdrawl method
	/*
	 * Verifies the user has enough money to withdraw
	 * a given amount. Complains otherwise.
	 * @param amount The amount to be withdrawn
	 */
	static void verifyWithdrawl(double amount) {
		if (logic.withdraw(accountNum, amount)) {
			System.out.printf("Here is your $%.2f.\n", amount);
		} else {
			System.err.println("Insufficient funds.");
		}
	} // verifyWithdrawl method
	/*
	 * Prompts the user for an amount to deposit into
	 * his account, then deposits it.
	 */
	static void deposit() {
		System.out.println("Enter the desired deposit amount:");
		double amount = scanner.nextDouble();
		if (amount < 0.0) {
			System.err.println("Invalid amount.");
		} else {
			logic.deposit(accountNum, amount);
		}
	} // deposit method
	/*
	 * Prompts the user for a new PIN, then
	 * changes his current PIN to the new PIN.
	 */
	static void changePIN() {
		System.out.println("Enter your new PIN:");
		String PIN1 = scanner.next();
		System.out.println("Confirm your new PIN:");
		String PIN2 = scanner.next();
		if (!PIN1.equals(PIN2)) {
			System.err.println("PINs do not match.");
		} else if (!PIN1.matches("\\d{4}")) {
			System.err.println("PIN must be 4 consecutive digits.");
		} else {
			logic.changePIN(accountNum, PIN1);
		}
	} // changePIN method
	/*
	 * Tells the user he has entered an incorrect option.
	 */
	static void invalidOption() {
		System.err.println("Invalid option");
	} // invalid option method
	/*
	 * Performs final actions before shutting down.
	 */
	static void shutdown() {
		System.out.println("Bye!");
		scanner.close();
		logic.close();
	} // shutdown method
}
