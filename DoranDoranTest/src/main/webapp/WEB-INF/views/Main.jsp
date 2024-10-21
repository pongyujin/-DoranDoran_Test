<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="modal.jsp"%>
<%@ include file="Header.jsp" %>
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
    background-image: linear-gradient(to bottom, rgba(4, 27, 35, 0) 0%, rgba(4, 27, 35, 0.5) 50%, rgba(4, 27, 35, 1) 100%), 
        url('<%=request.getContextPath()%>/resources/img/선박.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
}

.header {
    position: fixed;
    top: 0;
    right: 0;
    width: 100%;
    height: 50px;
    display: flex;
    justify-content: flex-end;
    align-items: center;
    z-index: 1000;
    background-color: rgba(0, 0, 0, 0); /* 헤더를 투명하게 설정 */
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

.header a:not(:first-child)::before {
    content: '';
    position: absolute;
    left: -10px;
    top: 10px;
    bottom: 0;
    width: 1px;
    background-color: white;
}

.header a:first-child {
    border-left: none;
}

.header a:hover {
    text-decoration: underline;
}

/* 햄버거 메뉴 리스트 스타일 */
.menu {
    display: none;
    position: absolute;
    top: 50px;
    right: 10px; /* right 값을 조정하여 위치 설정 */
    background-color: rgba(255, 255, 255, 0.9); /* 메뉴 배경에 약간의 투명도 */
    box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
    border-radius: 5px;
    width: 200px; /* 메뉴의 너비를 충분히 설정 */
    z-index: 1001; /* 헤더보다 앞에 나오도록 설정 */
    overflow: visible; /* 메뉴가 화면 밖으로 나가는 것을 방지 */
}


.menu a {
    color: black;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
    font-size: 14px;
}

.menu a:hover {
    background-color: #ddd;
}
.main-content {
    padding-top: 100px; /* 헤더 높이만큼 위쪽에 공간을 확보 */
}

/* 스크롤 섹션 */
.scroll-section {
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(to bottom, rgba(4, 27, 35, 1) 0%, rgba(4, 27, 35, 0.98) 15%, rgba(4, 27, 35, 0.95) 30%, 
        rgba(4, 27, 35, 0.9) 50%, rgba(4, 27, 35, 0.85) 70%, rgba(4, 27, 35, 0.8) 100%);
    color: white;
    font-size: 24px;
}
</style>

</head>
<body>

<div class="background-image"></div>
<div class="scroll-section"></div>

<script>
    // Join 모달 열기
    document.getElementById("openJoinModal").addEventListener("click", function(e) {
        e.preventDefault();
        document.getElementById("joinModal").style.display = "block"; // Join 모달 열기
        document.getElementById("loginModal").style.display = "none"; // Login 모달 닫기
        document.getElementById("openJoinModal").style.display = "none"; // Join 버튼 숨기기
        document.getElementById("openLoginModal").style.display = "block"; // Login 버튼 보이기
    });

    // Login 모달 열기
    document.getElementById("openLoginModal").addEventListener("click", function(e) {
        e.preventDefault();
        document.getElementById("loginModal").style.display = "block"; // Login 모달 열기
        document.getElementById("joinModal").style.display = "none"; // Join 모달 닫기
        document.getElementById("openLoginModal").style.display = "none"; // Login 버튼 숨기기
        document.getElementById("openJoinModal").style.display = "block"; // Join 버튼 보이기
    });

    // Join 모달 닫기
    document.getElementById("closeJoinModal").addEventListener("click", function() {
        document.getElementById("joinModal").style.display = "none"; // Join 모달 닫기
        document.getElementById("openJoinModal").style.display = "block"; // Join 버튼 복원
        document.getElementById("openLoginModal").style.display = "block"; // Login 버튼 복원
    });

    // Login 모달 닫기
    document.getElementById("closeLoginModal").addEventListener("click", function() {
        document.getElementById("loginModal").style.display = "none"; // Login 모달 닫기
        document.getElementById("openJoinModal").style.display = "block"; // Join 버튼 복원
        document.getElementById("openLoginModal").style.display = "block"; // Login 버튼 복원
    });


    // 햄버거 메뉴 클릭 시 메뉴 리스트 토글
    document.getElementById("hamburgerMenu")?.addEventListener("click", function(e) {
        e.preventDefault();
        console.log("햄버거 메뉴 클릭");
        var menu = document.getElementById("menu");
        menu.style.display = (menu.style.display === "block") ? "none" : "block";
    });



        // Login 모달 닫기
        document.getElementById("closeLoginModal").addEventListener("click", function() {
            document.getElementById("loginModal").style.display = "none"; // Login 모달 닫기
            document.getElementById("openJoinModal").style.display = "block"; // Join 버튼 복원
            document.getElementById("openLoginModal").style.display = "block"; // Login 버튼 복원
        });
        
        </script>  
    
    <%
    Boolean openLoginModal = (Boolean) session.getAttribute("openLoginModal");
    if (openLoginModal != null && openLoginModal) {
        // 세션에서 로그인 모달을 열라는 신호가 있으면
        session.removeAttribute("openLoginModal"); // 신호 제거
	%>
        <script>
            document.getElementById("loginModal").style.display = "block"; // Login 모달 열기
            document.getElementById("joinModal").style.display = "none"; // Join 모달 닫기
            document.getElementById("openLoginModal").style.display = "none"; // Login 버튼 숨기기
            document.getElementById("openJoinModal").style.display = "block"; // Join 버튼 보이기
        </script>
	<%
    }
	%>
	
	<%
    Boolean openJoinModal = (Boolean) session.getAttribute("openJoinModal");
    if (openJoinModal != null && openJoinModal) {
        // 세션에서 회원가입 모달을 열라는 신호가 있으면
        session.removeAttribute("openJoinModal"); // 신호 제거
	%>
        <script>
            document.getElementById("joinModal").style.display = "block"; // Join 모달 열기
            document.getElementById("loginModal").style.display = "none"; // Login 모달 닫기
            document.getElementById("openJoinModal").style.display = "none"; // Join 버튼 숨기기
            document.getElementById("openLoginModal").style.display = "block"; // Login 버튼 보이기
        </script>
	<%
    }
	%>
    

</body>
</html>
