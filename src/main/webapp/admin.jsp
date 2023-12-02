<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.sql.*"%>

<%
// Your database connection details
String JDBC_URL = "jdbc:mysql://localhost:3306/ApplicationDatabase";
String USER = "root";
String PASSWORD = "root";

try (Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD)) {
	String selectQuery = "SELECT * FROM user";
	try (PreparedStatement selectStatement = connection.prepareStatement(selectQuery)) {
		ResultSet resultSet = selectStatement.executeQuery();

		out.println("<html>");
		out.println("<head>");
		out.println("<title>Admin Page</title>");
		out.println("</head>");
		out.println("<body>");
		out.println("<h2>Admin Page</h2>");

		// Table header with new columns for View Addresses button
		out.println("<table border='1'>");
		out.println("<thead>");
		out.println("<tr>");
		out.println("<th>Username</th>");
		out.println("<th>Email</th>");
		out.println("<th>Actions</th>");
		out.println("</tr>");
		out.println("</thead>");
		out.println("<tbody>");

		while (resultSet.next()) {
	String username = resultSet.getString("username");
	String email = resultSet.getString("email");

	// Check if the user is not admin before displaying the row
	if (!"admin".equals(username)) {
		// Button to view addresses (passing username as a parameter)
		out.println("<tr>");
		out.println("<td>" + username + "</td>");
		out.println("<td>" + email + "</td>");
		out.println("<td><a href='viewdata.jsp?username=" + username + "'>View Addresses</a></td>");
		out.println("</tr>");
	}
		}

		out.println("</tbody>");
		out.println("</table>");
		out.println("</body>");
		out.println("</html>");
	}
} catch (SQLException e) {
	e.printStackTrace();
	// Handle SQL exceptions
}
%>
