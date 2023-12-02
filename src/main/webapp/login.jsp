<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.math.BigInteger"%>

<%
String username = request.getParameter("username");
String password = request.getParameter("password");

if (request.getMethod().equalsIgnoreCase("post")) {
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");

		String JDBC_URL = "jdbc:mysql://localhost:3306/ApplicationDatabase";
		String USER = "root";
		String PASSWORD = "root";

		try (Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD)) {
	String hashedPassword = hashPassword(password);

	String loginQuery = "SELECT * FROM user WHERE username=? AND password=?";
	try (PreparedStatement loginStatement = connection.prepareStatement(loginQuery)) {
		loginStatement.setString(1, username);
		loginStatement.setString(2, hashedPassword);

		ResultSet resultSet = loginStatement.executeQuery();
		if (resultSet.next()) {
			// Successful login
			session.setAttribute("username", username);
			if ("admin".equals(username) && "admin".equals(password)) {
				// Redirect to admin.jsp for admin login
				response.sendRedirect("admin.jsp");
			} else {
				// Redirect to welcome.jsp for regular user login
				response.sendRedirect("welcome.jsp");
			}
			return;
		} else {
			// Failed login
			response.sendRedirect("login.jsp?error=invalid");
			return;
		}
	}
		} catch (SQLException e) {
	e.printStackTrace();
	// Redirect back to login.jsp with an error message for database connection issue
	response.sendRedirect("login.jsp?error=db");
		}
	} catch (Exception e) {
		e.printStackTrace();
		// Redirect back to login.jsp with a general error message
		response.sendRedirect("login.jsp?error=general");
	}
}
%>

<%!private String hashPassword(String password) {
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

<html>
<head>
<title>User Login</title>
</head>
<body>
	<h2>User Login</h2>

	<form action="" method="post">
		<label for="username">Username:</label> <input type="text"
			id="username" name="username" required><br> <label
			for="password">Password:</label> <input type="password" id="password"
			name="password" required><br> <input type="submit"
			value="Login"> <a href="register.jsp"><button
				type="button">Register</button></a>
	</form>

	<%
	// Display error message if any
	String error = request.getParameter("error");
	if (error != null) {
		if (error.equals("invalid")) {
			out.println("<p style='color: red;'>Invalid username or password. Please try again.</p>");
		} else if (error.equals("db")) {
			out.println("<p style='color: red;'>Unable to connect to the database. Please try again later.</p>");
		} else if (error.equals("general")) {
			out.println("<p style='color: red;'>An unexpected error occurred. Please try again later.</p>");
		}
	}
	%>
</body>
</html>
