<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.math.BigInteger"%>

<html>
<head>
<title>User Registration</title>
<%!private boolean isDuplicate(String columnName, String value) {
		try {
			// Your database connection details
			String JDBC_URL = "jdbc:mysql://localhost:3306/applicationdatabase";
			String USER = "root";
			String PASSWORD = "root";

			// Load the MySQL JDBC driver
			Class.forName("com.mysql.cj.jdbc.Driver");

			// Establish the database connection
			Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD);
			String query = "SELECT COUNT(*) FROM user WHERE " + columnName + " = ?";
			PreparedStatement preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, value);
			ResultSet resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				int count = resultSet.getInt(1);
				return count > 0;
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		}
		return false;
	}

	private String hashPassword(String password) {
		try {
			// Use SHA-256 algorithm for hashing
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			byte[] messageDigest = md.digest(password.getBytes());
			BigInteger no = new BigInteger(1, messageDigest);
			StringBuilder hashText = new StringBuilder(no.toString(16));
			while (hashText.length() < 32) {
				hashText.insert(0, "0");
			}
			return hashText.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			// Handle NoSuchAlgorithmException
			return null;
		}
	}%>
</head>
<body>
	<h2>User Registration</h2>

	<%
	String username = request.getParameter("username");
	String email = request.getParameter("email");
	String password = request.getParameter("password");

	if (request.getMethod().equalsIgnoreCase("post")) {
		try {
			// Load the MySQL JDBC driver
			try {
		Class.forName("com.mysql.cj.jdbc.Driver");
			} catch (ClassNotFoundException e) {
		e.printStackTrace();
		// Handle class not found exception (driver not found)
		response.sendRedirect("register.jsp?error=db");
		return;
			}

			if (isDuplicate("username", username)) {
		// Redirect to register.jsp with an error message for duplicate username
		response.sendRedirect("register.jsp?error=username");
		return;
			}

			if (isDuplicate("email", email)) {
		// Redirect to register.jsp with an error message for duplicate email
		response.sendRedirect("register.jsp?error=email");
		return;
			}

			String hashedpassword = hashPassword(password);

			// Try to connect to the database and insert the user
			String JDBC_URL = "jdbc:mysql://localhost:3306/ApplicationDatabase";
			String USER = "root";
			String PASSWORD = "root";
			try (Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD)) {
		String insertQuery = "INSERT INTO user (username, email, password) VALUES (?, ?, ?)";
		try (PreparedStatement preparedStatement = connection.prepareStatement(insertQuery)) {
			preparedStatement.setString(1, username);
			preparedStatement.setString(2, email);
			preparedStatement.setString(3, hashedpassword);
			preparedStatement.executeUpdate();
		}
		response.sendRedirect("/AddressApp/login.jsp"); // Redirect to a login page
			} catch (SQLException e) {
		e.printStackTrace();
		// Redirect back to register.jsp with an error message for database connection issue
		response.sendRedirect("register.jsp?error=db");
			}
		} catch (Exception e) {
			e.printStackTrace();
			// Redirect back to register.jsp with a general error message
			response.sendRedirect("register.jsp?error=general");
		}
	}
	%>

	<form action="" method="post">
		<label for="username">Username:</label> <input type="text"
			id="username" name="username" required><br> <label
			for="email">Email:</label> <input type="email" id="email"
			name="email" required><br> <label for="password">Password:</label>
		<input type="password" id="password" name="password" required><br>

		<input type="submit" value="Register"> <a href="login.jsp"><button
				type="button">Login</button></a>
	</form>

	<%
	// Display error message if any
	String error = request.getParameter("error");
	if (error != null) {
		if (error.equals("username")) {
			out.println("<p style='color: red;'>Username already exists. Please choose a different one.</p>");
		} else if (error.equals("email")) {
			out.println("<p style='color: red;'>Email already exists. Please choose a different one.</p>");
		} else if (error.equals("db")) {
			out.println("<p style='color: red;'>Unable to connect to the database. Please try again later.</p>");
		} else if (error.equals("general")) {
			out.println("<p style='color: red;'>An unexpected error occurred. Please try again later.</p>");
		}
	}
	%>
</body>
</html>
