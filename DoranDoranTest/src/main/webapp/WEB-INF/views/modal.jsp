<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!-- Google Fonts 로드 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Arial&display=swap" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<script type="text/javascript">

  // 1. 아이디 중복 체크
  function registerCheck(){
      var memId = $("#memIdJoin").val();
      $.ajax({
          url : "registerCheck",
          type : "get",
          data : {"memId" : memId},
          success : function(data){
              if(data==0){
                  $("#checkMessage").text("사용 불가능한 아이디 입니다.");
                  $("#messageType").attr("class","modal-content panel-danger")
              }else{
                  $("#checkMessage").text("사용 가능한 아이디 입니다.");
                  $("#messageType").attr("class","modal-content panel-success")
              }
          },
          error : function(){
              console.log("error");
          }
      });
      // 모달창 띄우기
      $("#myModal").modal("show");
  }

  // 2. 비밀번호 확인
  function passwordCheck(){
      var pw1 = $("#memPwJoin").val();
      var pw2 = $("#memPwJoin2").val();
      if(pw1==pw2){
          $("#passMessage").attr("style", "color:green; vertical-align:middle;");
          $("#memPwJoin").attr("value", pw1)
          $("#passMessage").text("비밀 번호가 일치합니다");
      }else{
          $("#passMessage").attr("style", "color:red; vertical-align:middle;");
          $("#passMessage").text("비밀 번호가 일치하지 않습니다");
      }
  }

  // 3. 모달창 띄우기
  $(document).ready(function(){
      if(${not empty msgType}){
          if(${msgType eq "회원가입 실패"}){
              $("#messageType2").attr("class", "modal-content panel-warning");
          }
          $("#myMessage").modal("show");
      }
  });
</script>

<!-- Join 모달 -->
<div id="joinModal" class="modal">
    <span class="close" id="closeJoinModal">&times;</span>
    <h2>Join</h2>
    <div class="modal-content">
        <form action="memberJoin" method="post">
            <input type="hidden" id="memPwJoin1" name="memPw1" value=""> 
            <input type="text" id="memIdJoin" name="memId" placeholder="ID" autocomplete="username">
            <button type="button" id="checkDuplicate" class="duplicate-btn" onclick="registerCheck()">중복체크</button>
            <input type="password" id="memPwJoin" name="memPw" placeholder="Password" autocomplete="new-password"> 
            <input type="password" id="memPwJoin2" name="memPw2" placeholder="Password Check" autocomplete="new-password">
            <input type="text" id="memNickJoin" name="memNick" placeholder="Nickname">
            <input type="email" id="memEmailJoin" name="memEmail" placeholder="Email" autocomplete="email">
            <input type="text" id="memPhoneJoin" name="memPhone" placeholder="Phone Number">
            <button type="submit" class="join-button">Join</button>
        </form>
    </div>
</div>

<!-- Login 모달 -->
<div id="loginModal" class="modal">
    <span class="close" id="closeLoginModal">&times;</span>
    <h2>Login</h2>
    <div class="modal-content">
        <form action="memberLogin" method="post">
            <input type="text" id="memIdLogin" name="memId" placeholder="ID" autocomplete="username">
            <input type="password" id="memPwLogin" name="memPw" placeholder="Password" autocomplete="current-password">
            <button type="submit" class="join-button">Login</button>
        </form>
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
    </div>
</div>

<!-- 선박 등록 모달 -->
<div id="shipRegisterModal" class="modal">
    <span class="close" id="closeShipRegisterModal">&times;</span>
    <h2>Ship registration</h2>
    <div class="modal-content">
        <form action="shipRegister" method="post" enctype="multipart/form-data">
            <input type="text" id="shipId" name="shipId" placeholder="Ship ID">
            <input type="text" id="shipName" name="shipName" placeholder="Ship Name">
            <!-- 커스텀 파일 업로드 버튼 -->
          <!-- 커스텀 파일 업로드 버튼 -->
<label for="shipFile" class="custom-file-upload" style="margin-top: 10px;">파일 선택</label>
<input id="shipFile" type="file" name="shipFile" style="display:none;">
<span id="fileName" style="color:white; margin-left: 10px;"></span> <!-- 파일 이름 표시 -->

<!-- 파일 선택 시 파일 이름 표시하는 스크립트 -->
<script>
  $(document).ready(function(){
      $("#shipFile").change(function(){
          var fileName = this.files[0] ? this.files[0].name : "파일이 선택되지 않았습니다";
          $("#fileName").text(fileName); // 파일 이름을 span에 표시
      });
  });
</script>

<input id="shipFile" type="file" name="shipFile" style="display:none;">
<span id="fileName" style="color:white; margin-left: 10px;"></span> <!-- 파일 이름 표시 -->

            <button type="submit" class="register-button">Ship registration</button>
        </form>
    </div>
</div>
<!-- 회원정보 수정 모달 -->
<div id="editModal" class="modal">
    <span class="close" id="closeEditModal">&times;</span>
    <h2>Edit</h2>
    <div class="modal-content">
        <form action="updateMemberInfo" method="post">
            <input type="text" id="editId" name="editId" placeholder="ID" required>
            <input type="password" id="editPw" name="editPw" placeholder="Password" required>
            <input type="password" id="editNewPw" name="editNewPw" placeholder="New Password" required>
            <input type="password" id="editConfirmNewPw" name="editConfirmNewPw" placeholder="Confirm New Password" required>
            <button type="submit" class="edit-button">Edit</button>
        </form>
    </div>
</div>
<!-- 모달 CSS 스타일 -->
<style>
* {
    font-family: Arial, sans-serif;
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
    right: 35px; 
    top: 26%; 
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

input[type="text"], input[type="password"], input[type="email"], input[type="file"] {
    width: 100%;
    padding: 10px;
    border: none;
    border-bottom: 1px solid rgba(255, 255, 255, 0.7);
    background-color: transparent;
    color: white;
    font-size: 16px;
}

input[type="text"]:focus, input[type="password"]:focus, input[type="email"]:focus, input[type="file"]:focus {
    outline: none;
    border-bottom-color: white;
}

/* 커스텀 파일 업로드 버튼 스타일 */
.custom-file-upload {
    display: inline-block;
    padding: 10px 20px;
    cursor: pointer;
    background-color: #1C2933;
    color: white;
    border-radius: 5px;
    transition: background-color 0.3s ease;
}

.custom-file-upload:hover {
    background-color: #17293A;
}

.custom-file-upload:active {
    background-color: #0f1c28;
}

.close {
    position: absolute;
    top: 10px;
    right: 20px;
    color: white;
    font-size: 20px;
    cursor: pointer;
}

.join-button, .register-button {
    display: block;
    margin: 20px auto 0;
    padding: 10px;
    width: 150px;
    background-color: #1C2933;
    border: none;
    color: white;
    font-size: 16px;
    border-radius: 5px;
    cursor: pointer;
}

.join-button:hover, .register-button:hover {
    background-color: #17293A;
}

.social-login {
    display: flex;
    justify-content: center;
    gap: 30px;
    margin-top: 20px;
}

.social-btn img {
    width: 40px;
    height: 40px;
}

.social-btn.naver img {
    width: 62px;
    height: 60px;
    margin-top: -12px;
}
</style>
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
    padding: 20px;
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

.edit-button {
    display: block;
    margin: 20px auto 0;
    padding: 10px;
    width: 150px;
    background-color: #1C2933;
    border: none;
    color: white;
    font-size: 16px;
    border-radius: 5px;
    cursor: pointer;
}

.edit-button:hover {
    background-color: #17293A;
}
