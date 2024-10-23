// modal.js 파일로 이동할 스크립트
console.log("modal.js 파일이 로드되었습니다.");

// Member - 1. 아이디 중복 체크
function registerCheck() {
	var memId = $("#memIdJoin").val();
	console.log(memId);
	$.ajax({
		url: "registerCheck",
		type: "get",
		data: { "memId": memId },
		success: function(data) {
			if (data == 0) {
				$("#checkMessage").text("사용 불가능한 아이디 입니다.");
				$("#messageType").attr("class", "modal-content panel-danger");
			} else {
				$("#checkMessage").text("사용 가능한 아이디 입니다.");
				$("#messageType").attr("class", "modal-content panel-success");
			}
		},
		error: function() {
			console.log("error");
		}
	});
	// 모달창 띄우기
	$("#myModal").modal("show");
}

// Member - 2. 비밀번호 확인
function passwordCheck() {
	var pw1 = $("#memPw").val();
	var pw2 = $("#memPw2").val();
	if (pw1 == pw2) {
		$(".passMessage").attr("style", "color:green; vertical-align:middle; margin-top:10px;");
		$("#memPwJoin").attr("value", pw1);
		$(".passMessage").text("비밀 번호가 일치합니다");
	} else {
		$(".passMessage").attr("style", "color:#ff5656; vertical-align:middle; margin-top:10px;");
		$(".passMessage").text("비밀 번호가 일치하지 않습니다");
	}
}

// Ship - 3. 모달을 열 때 선박 리스트 로드
function loadShipList() {

	$.ajax({
		url: 'shipList',
		type: 'GET',
		dataType: 'json', // 서버로부터 받는 데이터의 형식
		success: function(data) {
			console.log("선박리스트 데이터 : " + data);
			const shipListElement = document.getElementById('shipList');
			shipListElement.innerHTML = ''; // 기존 리스트 초기화

			data.forEach(function(ship) {
				const listItem = document.createElement('li');
				listItem.innerHTML = `
                    <p>선박번호: ${ship.siCode}</p>
                    <p>선박명: ${ship.siName}</p>
                    <button onclick="openGroupInfo('${ship.siCode}')">그룹 정보</button>
                    <button onclick="openGroupInfo('${ship.siCode}')">관제 화면</button>
                    <button onclick="openGroupInfo('${ship.siCode}')">통계 페이지</button>
                `;
				shipListElement.appendChild(listItem);
			});
		},
		error: function(xhr, status, error) {
			console.error('Error fetching ship list:', error);
		}
	});
}

// ------------------------------------- shipgroup 가져오기 

// 전역 변수로 선택된 siCode를 저장
let selectedSiCode = null;

// 그룹 정보를 로드하고 siCode 설정
function loadGroupInfo(siCode) {
	selectedSiCode = siCode;  // 선택된 siCode를 전역 변수에 저장
	console.log("선택된 선박 코드: ", selectedSiCode);

	// AJAX 요청을 통해 그룹 멤버 리스트 불러오기
	$.ajax({
		url: 'grouplist',  // 서버 API 경로
		type: 'GET',
		data: { siCode: siCode },  // 선택된 선박의 siCode 전달
		dataType: 'json',
		success: function(data) {
			const userListElement = document.querySelector('.user-list');
			userListElement.innerHTML = '';  // 기존 리스트 초기화

			// 그룹 멤버 리스트 동적으로 추가
			data.forEach(function(member) {
				const listItem = document.createElement('li');
				listItem.innerHTML = `
                    <span>${member.memId}</span>
                    <select>
                        <option value="관리자" ${member.authNum === 1 ? 'selected' : ''}>관리자</option>
                        <option value="관제보기전용" ${member.authNum === 2 ? 'selected' : ''}>관제페이지허용</option>
                        <option value="통계이용" ${member.authNum === 3 ? 'selected' : ''}>통계페이지보기</option>
                    </select>
                `;
				userListElement.appendChild(listItem);
			});
		},
		error: function(xhr, status, error) {
			console.error('그룹 리스트 불러오기 실패:', error);
		}
	});
}

function inviteMember() {
	if (!selectedSiCode) {
		alert('선박이 선택되지 않았습니다.');
		return;
	}

	var memberId = document.getElementById('invitememID').value;  // 초대할 사용자 ID 또는 이메일
	var authNum = document.querySelector('.invite-section select').value;  // 선택된 권한 번호

	console.log("초대할 사용자 ID:", memberId);
	console.log("선택된 권한 번호:", authNum);
	console.log("초대할 선박 코드:", selectedSiCode);

	if (!memberId) {
		alert('초대할 사용자 ID 또는 이메일을 입력해주세요.');
		return;
	}

	// 소유자 여부 확인
	$.ajax({
		url: 'checkOwnership',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify({ siCode: selectedSiCode }),
		success: function(isOwner) {
			console.log("소유자 여부:", isOwner);

			if (isOwner) {
				authNum = 0;  // 소유자일 경우 관리자 권한 설정
			}

			// 초대 요청
			$.ajax({
				url: 'groupinvite',
				type: 'POST',
				contentType: 'application/json',
				data: JSON.stringify({
					memId: memberId,
					siCode: selectedSiCode,
					authNum: authNum  // 권한 번호
				}),
				success: function(response) {
					console.log('초대 성공:');
					alert('초대 성공:');  // 서버에서 반환된 메시지를 출력
					loadGroupInfo(selectedSiCode);  // 그룹 정보를 다시 로드
				},
				error: function(xhr, status, error) {
					if (xhr.status === 409) {
						alert('해당 사용자는 이미 그룹에 속해 있습니다.');
					} else {
						console.error('초대 실패:');
						alert('사용자가 없습니다.');
					}
				}
			});

		},
		error: function(xhr, status, error) {
			console.error('소유자 확인 실패:', error);
			alert('소유자 확인 실패');
		}
	});
}