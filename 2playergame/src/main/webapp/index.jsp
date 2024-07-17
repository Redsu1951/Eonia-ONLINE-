<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>2d Retro</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #1f1f1f;
            color: #fff;
        }

        .video-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: -1;
        }

        video {
            min-width: 100%;
            min-height: 100%;
            width: auto;
            height: auto;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: -1;
        }

        .container {
            width: 400px;
            margin: 350px auto 100px auto; /* Adjusted margin */
            background-color: #2c3e50;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            padding: 40px;
            text-align: center;
            background: linear-gradient(to bottom, #000000, #7b1fa2); /* Adjusted gradient */
        }

        h2 {
            color: #fff;
            margin-bottom: 30px;
        }

        .button {
            display: inline-block;
            background: #7b1fa2;
            color: #fff;
            padding: 12px 30px;
            border-radius: 25px;
            text-decoration: none;
            transition: background 0.3s ease;
            font-size: 18px;
            margin: 10px;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .button:hover {
            background: #5e134c;
        }

        .button.login {
            background-color: #2980b9;
        }

        .button.register {
            background-color: #27ae60;
        }
    </style>
</head>
<body>
<div class="video-container">
    <video autoplay loop muted>
        <source src="back1.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
</div>
<div class="container">
    <h2>Welcome to 2d Retro!</h2>
    <a href="login.jsp" class="button login">Login</a>
    <a href="register.jsp" class="button register">Register</a>
</div>
</body>
</html>
