package com.serversetup;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddressDataServlet")
public class AddressDataServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String username = (String) request.getSession().getAttribute("username");

		if (username != null) {
			try {
				String JDBC_URL = "jdbc:mysql://localhost:3306/ApplicationDatabase";
				String USER = "root";
				String PASSWORD = "root";

				try (Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD)) {
					String selectAddressQuery = "SELECT address FROM address WHERE username=?";
					try (PreparedStatement selectAddressStatement = connection.prepareStatement(selectAddressQuery)) {
						selectAddressStatement.setString(1, username);
						ResultSet resultSet = selectAddressStatement.executeQuery();

						// Create a list to hold the addresses
						List<String> addresses = new ArrayList<>();

						while (resultSet.next()) {
							String address = resultSet.getString("address");
							addresses.add(address);
						}

						// Set the addresses as a request attribute
						request.setAttribute("addresses", addresses);
						request.getRequestDispatcher("viewdata.jsp").forward(request, response);
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
			// Redirect to login page if the user is not logged in
			response.sendRedirect("login.jsp");
		}
	}
}
