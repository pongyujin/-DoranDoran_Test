<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Google Fonts 로드 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Arial&display=swap" rel="stylesheet">


<!-- Join 모달 -->
<div id="joinModal" class="modal">
    <span class="close" id="closeJoinModal">&times;</span>
    <h2>Join</h2>
    <div class="modal-content">
        <input type="text" id="id" name="id" placeholder="ID">
        <button type="button" id="checkDuplicate" class="duplicate-btn">중복체크</button>
        <input type="password" id="pw" name="pw" placeholder="Password">
        <input type="password" id="pwCheck" name="pwCheck" placeholder="Password Check">
        <input type="text" id="nick" name="nick" placeholder="Nickname">
        <input type="email" id="email" name="email" placeholder="Email">
        <input type="text" id="phoneNumber" name="phoneNumber" placeholder="Phone Number">
        <button type="submit" class="join-button">Join</button>
    </div>
</div>

<!-- Login 모달 -->
<div id="loginModal" class="modal">
    <span class="close" id="closeLoginModal">&times;</span>
    <h2>Login</h2>
    <div class="modal-content">
        <input type="text" id="loginId" name="loginId" placeholder="ID">
        <input type="password" id="loginPw" name="loginPw" placeholder="Password">
        <!-- 소셜 로그인 버튼 -->
        <div class="social-login">
            <a href="https://accounts.google.com/signin/oauth" class="social-btn google">
                <img src="<%=request.getContextPath()%>/resources/img/google_logo.png" alt="Google" />
            </a>
            <a href="https://nid.naver.com/oauth2.0/authorize" class="social-btn naver">
                <img src="<%=request.getContextPath()%>/resources/img/naver_logo.png" alt="Naver" />
            </a>
            <a href="https://kauth.kakao.com/oauth/authorize" class="social-btn kakao">
                <img src="<%=request.getContextPath()%>/resources/img/kakao_logo.png" alt="Kakao" />
            </a>
        </div>
        <button type="submit" class="join-button">Login</button>
    </div>
</div>

<!-- 모달 CSS 스타일 -->
+



<!-- 모달 CSS 스타일 -->
<style>
    /* 전체에 폰트 적용 */
    * {
        font-family: 'Arial', 'Helvetica', sans-serif;
    }

    .modal {
        display: none;
        position: fixed;
        z-index: 1001;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        width: 400px;
        background-color: rgba(49, 63, 73, 0.9);
        padding: 60px;
        border-radius: 10px;
        color: white;
    }

    .modal-content {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    h2 {
        text-align: center;
    }

    /* 중복체크 버튼 스타일 */
    .duplicate-btn {
        position: absolute;
        right: 60px;
        top: 27.5%;
        transform: translateY(-50%);
        padding: 5px 10px;
        background-color: #1C2933;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        width: 80px;
    }

    .duplicate-btn:hover {
        background-color: #17293A;
    }

    input[type="text"], input[type="password"], input[type="email"] {
        width: 100%;
        padding: 10px;
        border: none;
        border-bottom: 1px solid rgba(255, 255, 255, 0.7);
        background-color: transparent;
        color: white;
        font-size: 16px;
    }

    input[type="text"]:focus, input[type="password"]:focus, input[type="email"]:focus {
        outline: none;
        border-bottom-color: white;
    }

    .close {
        position: absolute;
        top: 10px;
        right: 20px;
        color: white;
        font-size: 20px;
        cursor: pointer;
    }

    .join-button {
        display: block;
        margin: 20px auto 0;
        padding: 10px;
        width: 100px;
        background-color: #1C2933;
        border: none;
        color: white;
        font-size: 16px;
        border-radius: 5px;
        cursor: pointer;
    }

    .join-button:hover {
        background-color: #17293A;
    }
    .social-login {
    display: flex;
    justify-content: center;
    gap: 30px; /* 아이콘 사이의 간격을 30px로 설정 */
    margin-top: 20px;
}

.social-btn img {
    width: 40px;
    height: 40px;
}

.social-btn.naver img {
    width: 62px; /* 네이버 버튼 크기 조정 */
    height: 60px;
    margin-top: -12px; /* 살짝 위로 이동 */
}

</style>
