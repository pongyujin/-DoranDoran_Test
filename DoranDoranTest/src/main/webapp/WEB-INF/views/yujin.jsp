<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.doran.entity.Member"%>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Header Navigation</title>
  <style>
    /* 기본 스타일 */
    :root {
      --black: #09090c;
      --grey: #a4b2bc;
      --white: #fff;
      --background: rgba(137, 171, 245, 0.37);
    }
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      background-color: var(--background);
      font-family: "Poppins", sans-serif;
      overflow-x: hidden;
    }

    /* 헤더 스타일 */
    .header {
      background-color: rgba(51, 51, 51, 0.8);
      padding: 20px;
      position: fixed;
      width: 100%;
      top: 0;
      z-index: 1000;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    /* 햄버거 버튼 스타일 */
    .hamburger {
      background-color: var(--black);
      border: none;
      width: 2.5rem;
      height: 2.5rem;
      border-radius: 50%;
      cursor: pointer;
      display: flex;
      justify-content: center;
      align-items: center;
      position: relative;
    }

    .hamburger::before,
    .hamburger::after {
      content: "";
      background-color: var(--white);
      height: 2px;
      width: 1rem;
      position: absolute;
      transition: all 0.3s ease;
    }

    .hamburger::before {
      top: ${(props) => (props.clicked ? "1.5rem" : "1rem")};
      transform: ${(props) => (props.clicked ? "rotate(135deg)" : "rotate(0)")};
    }
    .hamburger::after {
      top: ${(props) => (props.clicked ? "1.2rem" : "1.5rem")};
      transform: ${(props) => (props.clicked ? "rotate(-135deg)" : "rotate(0)")};
    }

    /* 오른쪽에서 나오는 메뉴 스타일 */
    .menu {
      position: fixed;
      top: 0;
      right: -250px; /* 숨겨진 상태 */
      background-color: var(--black);
      color: var(--white);
      width: 250px;
      height: 100vh;
      padding-top: 20px;
      transition: right 0.3s ease;
      z-index: 1001;
    }

    /* 메뉴가 열렸을 때 위치 */
    .menu.open {
      right: 0;
    }

    /* 메뉴 항목 스타일 */
    .menu a {
      display: flex;
      align-items: center;
      text-decoration: none;
      color: white;
      padding: 15px 20px;
      font-size: 14px;
      transition: background-color 0.3s;
    }

    .menu-icon {
      width: 20px;
      height: 20px;
      margin-right: 10px;
    }

    .menu a:hover {
      background-color: #333;
    }

    .menu .admin-only {
      border-top: 1px solid var(--grey);
      margin-top: 10px;
      padding-top: 10px;
    }
  </style>

  <!-- SweetAlert2 CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
  <!-- SweetAlert2 JS -->
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<%
Object user = session.getAttribute("user");
System.out.println("세션 유저: " + user);
%>

<div class="header">
  <% if (user != null) { %>
    <!-- 로그인된 경우 햄버거 메뉴 표시 -->
    <button id="hamburgerMenu" class="hamburger"></button>
  <% } else { %>
    <!-- 비로그인 상태 Join 및 Login 버튼 표시 -->
    <a href="#" id="openJoinModal" style="font-size: 20px; font-weight: bold;">Join</a>
    <a href="#" id="openLoginModal" style="font-size: 20px; font-weight: bold;">Login</a>
  <% } %>
</div>

<!-- 오른쪽 슬라이드 메뉴 -->
<div class="menu" id="menu">
  <a href="#" id="openShipRegisterModal">
    <img src="<%=request.getContextPath()%>/resources/img/ship.png" alt="선박 등록" class="menu-icon"> 선박 등록
  </a>
  <a href="#" id="openShipListModal">
    <img src="<%=request.getContextPath()%>/resources/img/list.png" alt="선박 리스트" class="menu-icon"> 선박 리스트
  </a>
  <a href="#" id="openEditModal">
    <img src="<%=request.getContextPath()%>/resources/img/user.png" alt="회원정보 수정" class="menu-icon"> 회원정보 수정
  </a>
  <a href="<%=request.getContextPath()%>/logout">
    <img src="<%=request.getContextPath()%>/resources/img/logout.png" alt="로그아웃" class="menu-icon"> 로그아웃
  </a>
  <!-- 관리자 전용 메뉴 -->
  <c:if test="${user.memId eq 'admin'}">
    <a href="<%=request.getContextPath()%>/manager" class="admin-only">
      <img src="<%=request.getContextPath()%>/resources/img/admin.png" alt="관리자 전용" class="menu-icon"> 관리자 전용
    </a>
  </c:if>
</div>

<script>
  // 햄버거 버튼 클릭 시 메뉴 열기/닫기
  document.getElementById("hamburgerMenu")?.addEventListener("click", function(e) {
    e.preventDefault();
    const menu = document.getElementById("menu");
    menu.classList.toggle("open");
  });

  // 외부 클릭 시 메뉴 닫기
  window.addEventListener("click", function(event) {
    const menu = document.getElementById("menu");
    const hamburger = document.getElementById("hamburgerMenu");
    if (event.target !== menu && event.target !== hamburger && !menu.contains(event.target)) {
      menu.classList.remove("open");
    }
  });

  // 모달 열기 및 닫기 기능 예시
  document.getElementById("openShipRegisterModal")?.addEventListener("click", function(e) {
    e.preventDefault();
    closeAllModals();
    document.getElementById("shipRegisterModal").style.display = "block";
  });

  function closeAllModals() {
    document.getElementById("shipRegisterModal")?.style.display = "none";
    document.getElementById("editModal")?.style.display = "none";
    document.getElementById("listModal")?.style.display = "none";
  }
</script>

</body>
</html>
