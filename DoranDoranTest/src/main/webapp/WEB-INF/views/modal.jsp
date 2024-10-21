<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!-- Google Fonts 로드 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Arial&display=swap"
	rel="stylesheet">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	

<!-- Join 모달 -->
<div id="joinModal" class="modal">
	<span class="close" id="closeJoinModal">&times;</span>
	<h2>Join</h2>
	<div class="modal-content">
		<form action="memberJoin" method="post">
			<!--  비밀번호가 일치할 경우에만 데이터 넘겨주기  -->
			<input type="hidden" id="memPw" name="memPw" value=""> <input
				type="text" id="memId" name="memId" placeholder="ID">
			<button type="button" id="checkDuplicate" class="duplicate-btn" onclick="registerCheck()">중복체크</button>
			<input type="password" id="memPw1" name="memPw1"
				placeholder="Password"> <input type="password" id="memPw2"
				name="memPw2" placeholder="Password Check"> <input
				type="text" id="memNick" name="memNick" placeholder="Nickname">
			<input type="email" id="memEmail" name="memEmail" placeholder="Email">
			<input type="text" id="memPhone" name="memPhone"
				placeholder="Phone Number">
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
		
		<input type="text" id="memId" name="memId" placeholder="ID"> <input
			type="password" id="memPw" name="memPw" placeholder="Password">
		<!-- 소셜 로그인 버튼 -->
		<div class="social-login">
			<a href="https://accounts.google.com/signin/oauth"
				class="social-btn google"> <img
				src="<%=request.getContextPath()%>/resources/img/google_logo.png"
				alt="Google" />
			</a> <a href="https://nid.naver.com/oauth2.0/authorize"
				class="social-btn naver"> <img
				src="<%=request.getContextPath()%>/resources/img/naver_logo.png"
				alt="Naver" />
			</a> <a href="https://kauth.kakao.com/oauth/authorize"
				class="social-btn kakao"> <img
				src="<%=request.getContextPath()%>/resources/img/kakao_logo.png"
				alt="Kakao" />
			</a>
		</div>
		<button type="submit" class="join-button">Login</button>
		</form>
	</div>
</div>

<!-- 아이디 중복 체크 모달창 -->
<div class="container">

	<!-- Modal -->
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div id="messageType" class="modal-content">
				<div class="modal-header panel-heading">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">아이디 중복 체크</h4>
				</div>
				<div class="modal-body">
					<p id="checkMessage"></p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>

</div>

<!-- 회원가입 실패 메세지 모달창 -->
<div class="container">

	<!-- Modal -->
	<div class="modal fade" id="myMessage" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div id="messageType2" class="modal-content">
				<div class="modal-header panel-heading">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">${msgType }</h4>
				</div>
				<div class="modal-body">
					<p id="checkMessage">${msg }</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>

</div>

<!-- 모달 CSS 스타일 -->
<<<<<<< HEAD
+


=======
<style>
* {
	font-family: Arial, sans-serif; /* 또는 다른 폰트 */
}
>>>>>>> branch 'master' of https://github.com/pongyujin/DoranDoran_Test.git

<!--
모달 CSS 스타일 --> <style> /* 전체에 폰트 적용 */ * {
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

input[type="text"]:focus, input[type="password"]:focus, input[type="email"]:focus
	{
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
<script type="text/javascript">
  	
  // 1. 아이디 중복 체크
  	function registerCheck(){
  	
  		// 아이디 중복 확인
  		var memId = $("#memId").val();
  		
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
  		
  		var pw1 = $("#memPw1").val();
  		var pw2 = $("#memPw2").val();
  		
  		if(pw1==pw2){
  			$("#passMessage").attr("style", "color:green; vertical-align:middle;");
  			$("#memPw").attr("value", pw1)
  			$("#passMessage").text("비밀 번호가 일치합니다");
  		}else{
  			$("#passMessage").attr("style", "color:red; vertical-align:middle;");
  			$("#passMessage").text("비밀 번호가 일치하지 않습니다");
  		}
  	}
  	
  	// 3-1. 회원가입 실패 모달창 띄우기
  	$(document).ready(
  		function(){
  			if(${not empty msgType}){
  				if(${msgType eq "실패"}){
  					$("#messageType2").attr("class", "modal-content panel-warning");
  				}
  				$("#myMessage").modal("show");
  			}
  		}
  	);
  	
 	// 3-2. 로그인 실패 모달창 띄우기
	$(document).ready(
		function(){
			if(${not empty msgType}){
				if(${msgType eq "실패"}){
					$("#messageType").attr("class", "modal-content panel-danger");
				}
				$("#myMessage").modal("show");
			}
		}
	);
  	
  </script>
