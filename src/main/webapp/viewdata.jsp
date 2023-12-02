<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
    <title>User Addresses</title>
</head>
<body>
    <h2>User Addresses</h2>
    <table border='1'>
        <thead>
            <tr>
                <th>Address</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="address" items="${addresses}">
                <tr>
                    <td>${address}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <br>
    <a href='admin.jsp'><button type='button'>Back to Admin Page</button></a>
</body>
</html>
