<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); %>
<% response.setHeader("Pragma", "no-cache"); %>
<% response.setDateHeader("Expires", 0); %>
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        /* 헤더 스타일 */
        .header {
            background-color: rgba(51, 51, 51, 0.8);
            padding: 20px;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }

        .hamburger {
            font-size: 30px;
            cursor: pointer;
        }

        .header a {
            float: right;
            display: block;
            color: white;
            text-align: center;
            padding: 14px 20px;
            text-decoration: none;
            font-size: 17px;
            transition: background-color 0.3s, color 0.3s;
        }

        .header a:hover {
            background-color: #ddd;
            color: black;
        }

        .header a.active {
            background-color: #4CAF50;
            color: white;
        }

        /* 메뉴 리스트 스타일 */
        .menu {
            display: none; /* 기본적으로 숨김 */
            position: absolute;
            top: 60px; /* 헤더 바로 아래에 위치 */
            right: 0;
            background-color: rgba(255, 255, 255, 0.9);
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
            border-radius: 5px;
            width: 200px;
            z-index: 1001;
            max-height: 400px;
            overflow-y: auto; /* 높이를 초과하는 경우 스크롤 가능하게 */
        }

        .menu a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .menu a:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>

<%
    Object user = session.getAttribute("user");
    System.out.println("세션 유저: " + user);
%>

<div class="header">
    <%
    if (user != null) {
    %>
        <!-- 로그인된 경우 햄버거 메뉴 표시 -->
        <a href="#" id="hamburgerMenu" class="hamburger">&#9776;</a>
        <div class="menu" id="menu">
            <a href="/ship/register">선박 등록</a>
            <a href="/ship/list">선박 리스트</a>
            <a href="/member/edit">회원정보 수정</a>
            <a href="/logout">로그아웃</a>
        </div>
    <%
    } else {
    %>
        <!-- 비로그인 상태 Join 및 Login 버튼 표시 -->
        <a href="#" id="openJoinModal">Join</a>
        <a href="#" id="openLoginModal">Login</a>
    <%
    }
    %>
</div>

<script>
document.getElementById("hamburgerMenu")?.addEventListener("click", function(e) {
    e.preventDefault();
    var menu = document.getElementById("menu");
    if (menu.style.display === "block") {
        menu.style.display = "none";
    } else {
        menu.style.display = "block";
    }
});
</script>

</body>
</html>
