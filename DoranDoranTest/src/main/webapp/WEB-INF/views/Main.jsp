<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="modal.jsp" %> <!-- modal.jsp 파일을 포함 -->
<!DOCTYPE html>
<html>
<head>
    <title>선박 메인 화면</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Slab&display=swap" rel="stylesheet">

    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow-x: hidden;
            font-family: 'Roboto Slab', serif;
        }

        .background-image {
            position: relative;
            width: 100vw;
            height: 200vh;
            background-image: linear-gradient(
                to bottom,
                rgba(4, 27, 35, 0) 0%,
                rgba(4, 27, 35, 0.5) 50%,
                rgba(4, 27, 35, 1) 100%
            ), url('<%=request.getContextPath()%>/resources/img/선박.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .header {
            position: fixed;
            top: 0;
            right: 50px;
            height: 50px;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            z-index: 1000;
        }

        .header a {
            color: white;
            margin-left: 20px;
            text-decoration: none;
            font-size: 18px;
            padding: 0 10px;
            position: relative;
            padding-top: 10px;
        }

        /* 세로 막대 제거 */
        .header a:not(:first-child)::before {
            content: none;
        }

        .header a:first-child {
            border-left: none;
        }

        .header a:hover {
            text-decoration: underline;
        }

        .scroll-section {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(
                to bottom,
                rgba(4, 27, 35, 1) 0%,
                rgba(4, 27, 35, 0.98) 15%,
                rgba(4, 27, 35, 0.95) 30%,
                rgba(4, 27, 35, 0.9) 50%,
                rgba(4, 27, 35, 0.85) 70%,
                rgba(4, 27, 35, 0.8) 100%
            );
            color: white;
            font-size: 24px;
        }
    </style>
</head>
<body>

    <div class="header">
        <a href="#" id="openJoinModal">Join</a>
        <a href="#" id="openLoginModal">Login</a>
    </div>

    <div class="background-image"></div>
    <div class="scroll-section"></div>

    <script>
        // Join 모달 열기
        document.getElementById("openJoinModal").addEventListener("click", function(e) {
            e.preventDefault();
            document.getElementById("joinModal").style.display = "block";
            document.getElementById("openLoginModal").style.display = "none"; // Login 버튼 숨기기
            document.getElementById("openJoinModal").style.display = "block"; // Join 버튼 보이기
        });

        // Login 모달 열기
        document.getElementById("openLoginModal").addEventListener("click", function(e) {
            e.preventDefault();
            document.getElementById("loginModal").style.display = "block";
            document.getElementById("openJoinModal").style.display = "block"; // Join 버튼 보이기
            document.getElementById("openLoginModal").style.display = "none"; // Login 버튼 숨기기
        });

        // Join 모달 닫기
        document.getElementById("closeJoinModal").addEventListener("click", function() {
            document.getElementById("joinModal").style.display = "none";
            document.getElementById("openLoginModal").style.display = "block"; // Login 버튼 복원
        });

        // Login 모달 닫기
        document.getElementById("closeLoginModal").addEventListener("click", function() {
            document.getElementById("loginModal").style.display = "none";
            document.getElementById("openJoinModal").style.display = "block"; // Join 버튼 복원
        });
    </script>
</body>
</html>
