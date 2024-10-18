<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        .header {
            background-color: #333;
            overflow: hidden;
            padding: 20px;
        }

        .header a {
            float: right;
            display: block;
            color: white;
            text-align: center;
            padding: 14px 20px;
            text-decoration: none;
            font-size: 17px;
        }

        .header a:hover {
            background-color: #ddd;
            color: black;
        }

        .header a.active {
            background-color: #4CAF50;
            color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <a href="#" id="openJoinModal">Join</a>
        <a href="#" id="loginLink">Login</a>
        <a href="#" id="hamburgerMenu" style="display: none;">&#9776;</a> <!-- íë²ê±° ìì´ì½ -->
    </div>
</body>



</html>
