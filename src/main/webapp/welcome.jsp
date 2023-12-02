<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>

<%
String address = request.getParameter("address");

if (request.getMethod().equalsIgnoreCase("post") && address != null && !address.isEmpty()) {
	try {
		String JDBC_URL = "jdbc:mysql://localhost:3306/ApplicationDatabase";
		String USER = "root";
		String PASSWORD = "root";

		try (Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD)) {
	String insertAddressQuery = "INSERT INTO address (username, address) VALUES (?, ?)";
	try (PreparedStatement insertAddressStatement = connection.prepareStatement(insertAddressQuery)) {
		insertAddressStatement.setString(1, (String) session.getAttribute("username"));
		insertAddressStatement.setString(2, address);
		insertAddressStatement.executeUpdate();
	}
		} catch (SQLException e) {
	e.printStackTrace();
	// Handle SQL exceptions
		}
	} catch (Exception e) {
		e.printStackTrace();
		// Handle other exceptions
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
				selectAddressStatement.setString(1, (String) session.getAttribute("username"));
				ResultSet resultSet = selectAddressStatement.executeQuery();
				while (resultSet.next()) {
					String userAddress = resultSet.getString("address");
					out.println("<tr>");
					out.println("<td>" + userAddress + "</td>");
					out.println("</tr>");
				}
					}
				} catch (SQLException e) {
					e.printStackTrace();
					// Handle SQL exceptions
				}
			} catch (Exception e) {
				e.printStackTrace();
				// Handle other exceptions
			}
			%>
		</tbody>
	</table>

	<br>
	<a href='logout.jsp'><button type='button'>Logout</button></a>
</body>
</html>
