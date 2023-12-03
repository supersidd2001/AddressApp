<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>

<%
String username = (String) session.getAttribute("username");

// Fetch user information including email
String email = null;
if (username != null) {
	try {
		String JDBC_URL = "jdbc:mysql://localhost:3306/ApplicationDatabase";
		String USER = "root";
		String PASSWORD = "root";

		try (Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD)) {
	String selectUserQuery = "SELECT * FROM user WHERE username=?";
	try (PreparedStatement selectUserStatement = connection.prepareStatement(selectUserQuery)) {
		selectUserStatement.setString(1, username);
		ResultSet userResultSet = selectUserStatement.executeQuery();

		if (userResultSet.next()) {
			email = userResultSet.getString("email");
			session.setAttribute("email", email);
		}
	}
		}
	} catch (SQLException sqlException) {
		sqlException.printStackTrace();
	}
}

// Add Address snippet
if (request.getMethod().equalsIgnoreCase("post")) {
	String address = request.getParameter("address");
	if (address != null && !address.isEmpty()) {
		try {
	String JDBC_URL = "jdbc:mysql://localhost:3306/ApplicationDatabase";
	String USER = "root";
	String PASSWORD = "root";

	try (Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD)) {
		String insertAddressQuery = "INSERT INTO address (username, address) VALUES (?, ?)";
		try (PreparedStatement insertAddressStatement = connection.prepareStatement(insertAddressQuery)) {
			insertAddressStatement.setString(1, username);
			insertAddressStatement.setString(2, address);
			insertAddressStatement.executeUpdate();
		}
	}
		} catch (SQLException e) {
	e.printStackTrace();
		}
	}
}
%>

<html>
<head>
<title>Welcome</title>
</head>
<body>
	<h2>
		Welcome,
		<%=session.getAttribute("username")%>!
	</h2>

	<h3>Your Information:</h3>
	<table border='1'>
		<thead>
			<tr>
				<th>Username</th>
				<th>Email</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><%=session.getAttribute("username")%></td>
				<td><%=session.getAttribute("email")%></td>
			</tr>
		</tbody>
	</table>

	<h3>Add Address:</h3>
	<form action="" method="post">
		<label for="address">Address:</label> <input type="text" id="address"
			name="address" required> <input type="submit"
			value="Add Address">
	</form>

	<h3>Your Addresses:</h3>
	<table border='1'>
		<thead>
			<tr>
				<th>Address</th>
			</tr>
		</thead>
		<tbody>
			<%
			try {
				String JDBC_URL = "jdbc:mysql://localhost:3306/ApplicationDatabase";
				String USER = "root";
				String PASSWORD = "root";

				try (Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD)) {
					String selectAddressQuery = "SELECT address FROM address WHERE username=?";
					try (PreparedStatement selectAddressStatement = connection.prepareStatement(selectAddressQuery)) {
				selectAddressStatement.setString(1, username);
				ResultSet resultSet = selectAddressStatement.executeQuery();
				while (resultSet.next()) {
					String userAddress = resultSet.getString("address");
			%>
			<tr>
				<td><%=userAddress%></td>
			</tr>
			<%
			}
			}
			} catch (SQLException e) {
			e.printStackTrace();
			}
			} catch (Exception e) {
			e.printStackTrace();
			}
			%>
		</tbody>
	</table>

	<br>
	<a href='login.jsp'><button type='button'>Logout</button></a>
</body>
</html>
