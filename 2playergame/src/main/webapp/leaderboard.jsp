<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leaderboard</title>
    <link rel="stylesheet" href="leaderboard.css">
</head>
<body>
    <div class="leaderboard-container">
        <h1>Leaderboard</h1>
        <table>
            <thead>
                <tr>
                    <th>Username</th>
                    <th>High Score</th>
                    <th>Total High Score</th>
                    <th>Top User</th>
                    <th>Latest Score</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Database connection parameters
                    String url = "jdbc:mysql://localhost:3306/gamedetails";
                    String username = "your_username";
                    String password = "your_password";

                    // Query to fetch data from the database
                    String query = "SELECT username, highscore, totalhighscore, topuser, latestscore FROM details";

                    // Establish database connection and fetch data
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection connection = DriverManager.getConnection(url, username, password);
                        Statement statement = connection.createStatement();
                        ResultSet resultSet = statement.executeQuery(query);

                        // Iterate over the result set and display data
                        while (resultSet.next()) {
                            String username = resultSet.getString("username");
                            int highscore = resultSet.getInt("highscore");
                            int totalHighscore = resultSet.getInt("totalhighscore");
                            String topUser = resultSet.getString("topuser");
                            int latestScore = resultSet.getInt("latestscore");
                %>
                <tr>
                    <td><%= username %></td>
                    <td><%= highscore %></td>
                    <td><%= totalHighscore %></td>
                    <td><%= topUser %></td>
                    <td><%= latestScore %></td>
                </tr>
                <% 
                        }
                        resultSet.close();
                        statement.close();
                        connection.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
