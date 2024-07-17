<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            height: 100vh;
            overflow: hidden;
        }
        .video-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
        }
        .video-background video {
            min-width: 100%;
            min-height: 100%;
        }
        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            height: 100%;
            width: 100%;
            position: relative; /* Added */
        }
        .container form {
            background-color: #2c3e50;
            padding: 60px;
            border-radius: 20px;
            box-shadow: 0px 0px 20px 5px rgba(0,0,0,0.8);
            text-align: center;
            width: 500px;
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
        .error-message, .success-message {
            color: white;
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 10px;
            border-radius: 5px;
        }
        .error-message {
            background-color: #ff6347;
        }
        .success-message {
            background-color: #32cd32;
        }
    </style>
</head>
<body>
<div class="video-background">
    <video autoplay loop muted>
        <source src="backvideo.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
</div>
<div class="container">
    <h2>Register</h2>
    <form action="register.jsp" method="post">
        <input type="text" name="firstuser" placeholder="Username" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <input type="password" name="confirmPassword" placeholder="Confirm Password" required><br>
        <input type="submit" value="Register">
    </form>
    <%
        // Check if form submitted
        if (request.getMethod().equalsIgnoreCase("post")) {
            String userid = request.getParameter("firstuser");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamedetails","root","tiger");

                if (!password.equals(confirmPassword)) {
    %>
                    <p class="error-message">Passwords do not match. Please try again.</p>
    <%
                } else {
                    String sql = "INSERT INTO details (username, password, highscore, totalhighscore, topuser, latestscore) VALUES (?, ?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, userid);
                    pstmt.setString(2, password);
                    pstmt.setInt(3, 0);
                    pstmt.setInt(4, 0);
                    pstmt.setString(5, "a");
                    pstmt.setInt(6, 0);
                    int rowsAffected = pstmt.executeUpdate();
                    if (rowsAffected > 0) {
    %>
                        <meta http-equiv="refresh" content="3; URL=index.jsp">
                        <p class="success-message">Registration successful. You will be redirected to <a href="index.jsp">index</a> page shortly.</p>
    <%
                    } else {
    %>
                        <p class="error-message">Failed to register. Please try again.</p>
    <%
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p class='error-message'>Database connection error. Please try again later.</p>");
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                out.println("<p class='error-message'>MySQL JDBC Driver not found.</p>");
            } finally {
                try {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<p class='error-message'>Error closing resources.</p>");
                }
            }
        }
    %>
</div>
</body>
</html>
