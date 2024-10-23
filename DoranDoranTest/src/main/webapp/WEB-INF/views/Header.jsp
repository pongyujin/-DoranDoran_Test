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
            font-size: 37px !important;
            padding: 10px !important;
            cursor: pointer !important;
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

        .menu {
            display: none;
            position: absolute;
            top: 60px;
            left: calc(100% - 220px);
            background-color: rgba(255, 255, 255, 0.9);
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
            border-radius: 5px;
            width: 220px;
            z-index: 1001;
            max-height: 400px;
            overflow-y: auto;

            /* 메뉴 전체를 수직 정렬 */
            display: flex;
            flex-direction: column;
            align-items: flex-start; /* 메뉴 아이템들을 왼쪽 정렬 */
            justify-content: center;
        }

        .menu a {
            display: flex;
            justify-content: flex-start; /* 가로 왼쪽 정렬 */
            align-items: center; /* 세로 가운데 정렬 */
            text-decoration: none;
            color: black;
            padding: 3px 10px;
            font-size: 12px;
            width: 100%; /* a 태그를 메뉴 너비에 맞춤 */
            transition: background-color 0.3s;
            list-style-type: none;
            border-left: none !important;
            box-sizing: border-box;
        }

        .menu a::before, .menu a::after {
            content: none !important; /* 가상 요소 제거 */
            border: none !important; /* 가상 요소의 경계선 제거 */
        }

        .menu a:hover {
            background-color: #f1f1f1; /* 배경색 변경 */
            width: 200px; /* hover 시에도 너비 고정 */
            box-sizing: border-box; /* 패딩이 너비에 포함되도록 */
        }

        .menu-icon {
            width: 20px;
            height: 20px;
            margin-right: 8px;
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
            <a href="#" id="openShipRegisterModal">
                <img src="<%=request.getContextPath()%>/resources/img/ship.png" alt="선박 등록" class="menu-icon">
                선박 등록
            </a>
            <a href="#" id="openShipListModal">
                <img src="<%=request.getContextPath()%>/resources/img/list.png" alt="선박 리스트" class="menu-icon">
                선박 리스트
            </a>

            <a href="#" id="openEditModal">
                <img src="<%=request.getContextPath()%>/resources/img/user.png" alt="회원정보 수정" class="menu-icon">
                회원정보 수정
            </a>
            <a href="<%=request.getContextPath()%>/logout">
                <img src="<%=request.getContextPath()%>/resources/img/logout.png" alt="로그아웃" class="menu-icon">
                로그아웃
            </a>
        </div>
    <%
    } else {
    %>
        <!-- 비로그인 상태 Join 및 Login 버튼 표시 -->
        <a href="#" id="openJoinModal" style="font-size: 20px; font-weight: bold;">Join</a>
        <a href="#" id="openLoginModal" style="font-size: 20px; font-weight: bold;">Login</a>
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

document.getElementById("openShipRegisterModal")?.addEventListener("click", function(e) {
    e.preventDefault();
    document.getElementById("shipRegisterModal").style.display = "block";
});

function closeAllModals() {
    // 모든 모달 창 닫기
    document.getElementById("shipRegisterModal").style.display = "none";
    document.getElementById("editModal").style.display = "none";
    document.getElementById("listModal").style.display = "none";
    document.getElementById("groupInfoModal").style.display = "none";

    // 필요시 추가 모달도 여기에 추가
}

// 선박 등록 모달 열기
document.getElementById("openShipRegisterModal")?.addEventListener("click", function(e) {
    e.preventDefault();
    closeAllModals(); // 다른 모달을 닫기
    document.getElementById("shipRegisterModal").style.display = "block"; // 선박 등록 모달 열기
});

// 회원정보 수정 모달 열기
document.getElementById("openEditModal")?.addEventListener("click", function(e) {
    e.preventDefault();
    closeAllModals(); // 다른 모달을 닫기
    document.getElementById("editModal").style.display = "block"; // 회원정보 수정 모달 열기
});

// 선박 등록 모달 닫기
document.getElementById("closeShipRegisterModal")?.addEventListener("click", function() {
    closeAllModals(); // 모든 모달 닫기
});

// 회원정보 수정 모달 닫기
document.getElementById("closeEditModal")?.addEventListener("click", function() {
    closeAllModals(); // 모든 모달 닫기
});

//선박 리스트 모달 열기
document.getElementById("openShipListModal").addEventListener("click", function(e) {
    e.preventDefault();
    closeAllModals(); // 다른 모달을 닫기
    document.getElementById("listModal").style.display = "block";
});

// 선박 리스트 모달 닫기
document.getElementById("closeShipListModal").addEventListener("click", function() {
    document.getElementById("listModal").style.display = "none";
});
//그룹 정보 모달 닫기 버튼 클릭 이벤트
document.getElementById("closeGroupInfoModal").addEventListener("click", function() {
    closeAllModals(); // 모든 모달 닫기
    document.getElementById("listModal").style.display = "block"; // 선박 리스트 모달 다시 열기
});


</script>

<%
    Boolean openShipRegisterModal = (Boolean) session.getAttribute("openShipRegisterModal");
    if (openShipRegisterModal != null && openShipRegisterModal) {
        // 세션에서 선박 등록모달을 열라는 신호가 있으면
        session.removeAttribute("openShipRegisterModal"); // 신호 제거
%>
        <script>
        closeAllModals(); // 다른 모달을 닫기
        document.getElementById("shipRegisterModal").style.display = "block"; // 선박 등록 모달 열기
        </script>
<%
    }
%>

</body>
</html>
