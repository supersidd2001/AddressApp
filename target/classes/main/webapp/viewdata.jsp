<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>

<%
String targetUsername = request.getParameter("username");

if (targetUsername != null) {
	try {
		String JDBC_URL = "jdbc:mysql://localhost:3306/ApplicationDatabase";
		String USER = "root";
		String PASSWORD = "root";

		try (Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD)) {
	String selectAddressQuery = "SELECT address FROM address WHERE username=?";
	try (PreparedStatement selectAddressStatement = connection.prepareStatement(selectAddressQuery)) {
		selectAddressStatement.setString(1, targetUsername);
		ResultSet resultSet = selectAddressStatement.executeQuery();

		// Create a list to hold the addresses
		List<String> addresses = new ArrayList<>();

		while (resultSet.next()) {
			String address = resultSet.getString("address");
			addresses.add(address);
		}

		// Display addresses as a table
%>
<html>
<head>
<title>Address Data</title>
</head>
<body>
	<h2>
		Address Data for
		<%=targetUsername%></h2>
	<table border='1'>
		<thead>
			<tr>
				<th>Address</th>
			</tr>
		</thead>
		<tbody>
			<%
			for (String address : addresses) {
			%>
			<tr>
				<td><%=address%></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
</body>
</html>
<%
}
}
} catch (SQLException e) {
e.printStackTrace();
response.getWriter().println("SQL Exception: " + e.getMessage());
} catch (Exception e) {
e.printStackTrace();
response.getWriter().println("Exception: " + e.getMessage());
}
} else {
response.getWriter().println("Invalid request. Username parameter is missing.");
}
%>
