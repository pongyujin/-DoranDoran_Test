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
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    /* 햄버거 메뉴 스타일 */
    .hamburger {
      font-size: 37px;
      padding: 10px;
      cursor: pointer;
      color: white;
    }

    /* 오른쪽에서 나오는 메뉴 스타일 */
    .menu {
      position: fixed;
      top: 0;
      right: -250px; /* 숨겨진 상태 */
      background-color: rgba(255, 255, 255, 0.9);
      width: 250px;
      height: 100vh;
      padding-top: 20px;
      box-shadow: -2px 0 8px rgba(0, 0, 0, 0.3);
      border-radius: 5px 0 0 5px;
      transition: right 0.3s ease; /* 슬라이드 애니메이션 */
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
      color: black;
      padding: 15px 20px;
      font-size: 14px;
      transition: background-color 0.3s;
    }

    /* 아이콘 스타일 */
    .menu-icon {
      width: 20px;
      height: 20px;
      margin-right: 10px;
    }

    .menu a:hover {
      background-color: #f1f1f1;
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
    <a href="#" id="hamburgerMenu" class="hamburger">&#9776;</a>
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
    <a href="<%=request.getContextPath()%>/manager" id="adminOnly">
      <img src="<%=request.getContextPath()%>/resources/img/admin.png" alt="관리자 전용" class="menu-icon"> 관리자 전용
    </a>
  </c:if>
</div>

<script>
  // 햄버거 버튼 클릭 시 메뉴 열기/닫기
  document.getElementById("hamburgerMenu")?.addEventListener("click", function(e) {
    e.preventDefault();
    const menu = document.getElementById("menu");
    menu.classList.toggle("open"); // 메뉴 열림/닫힘 토글
  });

  // 외부 클릭 시 메뉴 닫기
  window.addEventListener("click", function(event) {
    const menu = document.getElementById("menu");
    const hamburger = document.getElementById("hamburgerMenu");
    if (event.target !== menu && event.target !== hamburger && !menu.contains(event.target)) {
      menu.classList.remove("open");
    }
  });

  // 회원정보 수정 모달 열기 이벤트 리스너
  document.getElementById("openEditModal")?.addEventListener("click", function(e) {
    e.preventDefault();
    closeAllModals();
    document.getElementById("editModal").style.display = "block";
  });

  function closeAllModals() {
    document.getElementById("shipRegisterModal").style.display = "none";
    document.getElementById("editModal").style.display = "none";
    document.getElementById("listModal").style.display = "none";
    document.getElementById("groupInfoModal").style.display = "none";
  }
</script>

</body>
</html>
