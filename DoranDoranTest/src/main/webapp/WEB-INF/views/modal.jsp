<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <button type="submit" class="join-button">Login</button>
    </div>
</div>

<!-- 모달 CSS 스타일 -->
<style>
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

    /* 중복체크 버튼 스타일 */
    .duplicate-btn {
        position: absolute;
        right: 40px;
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
</style>
