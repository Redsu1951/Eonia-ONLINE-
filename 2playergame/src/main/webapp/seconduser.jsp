<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Second User Login</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(to bottom right, #1f1f1f, #1f1f1f, #7b1fa2);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: rgba(0, 0, 0, 0.5);
            padding: 60px;
            border-radius: 20px;
            box-shadow: 0px 0px 20px 5px rgba(0,0,0,0.8);
            width: 500px;
            text-align: center;
        }
        h2 {
            color: #fff;
            margin-bottom: 30px;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 15px;
            margin-bottom: 30px;
            border: none;
            border-radius: 10px;
            background-color: #34495e;
            color: #fff;
        }
        input[type="submit"] {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 10px;
            background-color: #7b1fa2;
            color: #fff;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        input[type="submit"]:hover {
            background-color: #5e134c;
        }
        .error-message {
            color: red;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Second User Login</h2>
    <form action="seconduser.jsp" method="post">
        <input type="text" name="username" placeholder="Username" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <input type="hidden" name="firstuser" value="<%= request.getParameter("firstuser") %>">
        <input type="submit" value="Login">
    </form>
    <%
        String firstuser = request.getParameter("firstuser");
        String userid = request.getParameter("username");
        String pin = request.getParameter("password");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamedetails","root","tiger");

            String sql = "SELECT * FROM details WHERE username = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid);
            pstmt.setString(2, pin);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                if (!rs.getString("username").equals(firstuser)) {
                    response.sendRedirect("index.html?firstUsername=" + request.getParameter("firstuser") + "&secondUsername=" + request.getParameter("username"));
                } else {
    %>
                    <p class="error-message">The second user cannot be the same as the first user.</p>
    <%
                }
            } else {
    %>
                <p class="error-message">Invalid username or password. Please try again.</p>
    <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p class='error-message'>Database connection error. Please try again later.</p>");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<p class='error-message'>MySQL JDBC Driver not found.</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p class='error-message'>Error closing resources.</p>");
            }
        }
    %>
</div>
	
</body>
</html>
