package com.serversetup;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseSetup {

	private static final String JDBC_URL = "jdbc:mysql://localhost:3306/ApplicationDatabase";
	private static final String USER = "root";
	private static final String PASSWORD = "root";

	public static void main(String[] args) {
		try (Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD)) {
			createTables(connection);
			System.out.println("Database and tables created successfully.");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private static void createTables(Connection connection) throws SQLException {
		try (Statement statement = connection.createStatement()) {
			// Create the User table with an index on the username column
			statement.executeUpdate("CREATE TABLE IF NOT EXISTS user (" + "id INT AUTO_INCREMENT PRIMARY KEY,"
					+ "username VARCHAR(255) NOT NULL," + "email VARCHAR(255) NOT NULL,"
					+ "password VARCHAR(255) NOT NULL," + "UNIQUE KEY idx_username (username)) ");

			// Create the Address table with a foreign key referencing the User table
			statement.executeUpdate("CREATE TABLE IF NOT EXISTS address (" + "id INT AUTO_INCREMENT PRIMARY KEY,"
					+ "username VARCHAR(255) NOT NULL," + "address VARCHAR(255) NOT NULL,"
					+ "FOREIGN KEY (username) REFERENCES user(username))");
		}
	}

}
