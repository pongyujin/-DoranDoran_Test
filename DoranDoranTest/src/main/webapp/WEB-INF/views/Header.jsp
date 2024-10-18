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
        <a href="#" id="hamburgerMenu" style="display: none;">&#9776;</a> <!-- 햄버거 아이콘 -->
    </div>
</body>

<script>
    // Join 버튼을 눌렀을 때 Join 모달을 표시
    document.getElementById("openJoinModal").addEventListener("click", function(e) {
        e.preventDefault();
        // Join 모달을 Main.jsp에서 제어
        var joinModal = parent.document.getElementById("joinModal"); // 부모 페이지에서 모달 찾기
        if (joinModal) {
            joinModal.style.display = "block"; // Join 모달 열기
        }
    });

    // Login 버튼을 눌렀을 때 Login 텍스트 숨기고 Join만 남기기
    document.getElementById("loginLink").addEventListener("click", function(e) {
        e.preventDefault();
        document.getElementById("loginLink").style.display = "none"; // Login 숨기기
        document.getElementById("openJoinModal").style.display = "block"; // Join 보이기
    });

    // 로그인 완료 후 햄버거 메뉴 표시하는 함수
    function showHamburgerMenu() {
        document.getElementById("loginLink").style.display = "none"; // Login 링크 숨기기
        document.getElementById("openJoinModal").style.display = "none"; // Join 링크 숨기기
        document.getElementById("hamburgerMenu").style.display = "block"; // 햄버거 메뉴 표시
    }

    // 로그인 성공 시 showHamburgerMenu 함수 호출
    // 실제 로그인 로직 후에 이 함수를 호출해야 함
    // 예: 로그인 성공 시 showHamburgerMenu();
</script>
</html>
