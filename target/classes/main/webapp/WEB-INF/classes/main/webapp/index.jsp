<%@ page
	import="java.sql.*, java.security.MessageDigest, java.nio.charset.StandardCharsets"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page
	import="java.security.MessageDigest, java.nio.charset.StandardCharsets"%>

<%!// Method to hash the password using SHA-256
	private String hashPassword(String password) {
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));

			// Convert the byte array to a hexadecimal string
			StringBuilder hexString = new StringBuilder();
			for (byte b : hash) {
				String hex = Integer.toHexString(0xff & b);
				if (hex.length() == 1)
					hexString.append('0');
				hexString.append(hex);
			}

			return hexString.toString();
		} catch (Exception e) {
			return null;
		}
	}%>

<html>
<head>
<title>User Registration</title>
</head>
<body>
	<h2>User Registration</h2>

	<%
	String jdbcUrl = "jdbc:mysql://localhost:3306/projectdb";
	String username = "root";
	String password = "root";

	boolean isValid = true;

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection connection = DriverManager.getConnection(jdbcUrl, username, password);

		if (request.getParameter("submit") != null) {
			String name = request.getParameter("name");
			String usernameInput = request.getParameter("username");
			String emailInput = request.getParameter("email");
			String passwordInput = request.getParameter("password");
			String confirmPassword = request.getParameter("confirmPassword");

			// Check for duplicate username
			String checkUsernameQuery = "SELECT * FROM users WHERE username = ?";
			try (PreparedStatement usernameStatement = connection.prepareStatement(checkUsernameQuery)) {
		usernameStatement.setString(1, usernameInput);
		ResultSet resultSet = usernameStatement.executeQuery();
		if (resultSet.next()) {
			out.println("Error: Username already exists. Please choose a different username.");
			isValid = false;
		}
			} catch (SQLException e) {
		out.println("Error: " + e.getMessage());
			}

			// Check for duplicate email
			String checkEmailQuery = "SELECT * FROM users WHERE email = ?";
			try (PreparedStatement emailStatement = connection.prepareStatement(checkEmailQuery)) {
		emailStatement.setString(1, emailInput);
		ResultSet resultSet = emailStatement.executeQuery();
		if (resultSet.next()) {
			out.println("Error: Email already exists. Please use a different email address.");
			isValid = false;
		}
			} catch (SQLException e) {
		out.println("Error: " + e.getMessage());
			}

			// Check if passwords match
			if (!passwordInput.equals(confirmPassword)) {
		out.println("Error: Passwords do not match. Please re-enter your password.");
		isValid = false;
			}

			// If everything is valid, proceed with registration
			if (isValid) {
		// Hash the password using SHA-256
		String hashedPassword = hashPassword(passwordInput);

		String insertQuery = "INSERT INTO users (username, name, email, password) VALUES (?, ?, ?, ?)";
		try (PreparedStatement preparedStatement = connection.prepareStatement(insertQuery)) {
			preparedStatement.setString(1, usernameInput);
			preparedStatement.setString(2, name);
			preparedStatement.setString(3, emailInput);
			preparedStatement.setString(4, hashedPassword);

			preparedStatement.executeUpdate();
		} catch (SQLException e) {
			out.println("Error: " + e.getMessage());
		}

		out.println("Registration successful! Redirecting to login page...");

		// Redirect to the LoginServlet after successful registration
		response.sendRedirect("LoginServlet");
			}
		}

		connection.close();
	} catch (Exception e) {
		out.println("Error: " + e.getMessage());
	}
	%>

	<form method="post" action="/AddressViewer/login.jsp">
		<label for="name">Name:</label> <input type="text" name="name"
			required><br> <label for="username">Username:</label> <input
			type="text" name="username" required><br> <label
			for="email">Email:</label> <input type="email" name="email" required><br>

		<label for="password">Password:</label> <input type="password"
			name="password" required><br> <label
			for="confirmPassword">Confirm Password:</label> <input
			type="password" name="confirmPassword" required><br> <input
			type="submit" name="submit" value="Register">
	</form>
</body>
</html>