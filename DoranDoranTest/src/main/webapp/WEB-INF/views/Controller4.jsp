<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.doran.entity.Ship"%>
<!DOCTYPE html>
<html>
<head>
<title>Controller</title>
<meta charset="UTF-8">
<!-- bootstrap -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- Google Maps API - Spring에서 전달된 API 키 사용 -->
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<script
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDtt1tmfQ-lTeQaCimRBn2PQPTlCLRO6Pg"></script>
<!-- Tailwind CSS CDN -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Outfit:wght@100;200;300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/map.css">

<!-- Include a required theme -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- 정유진 장애물감지시 모달창 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<style type="text/css">
.control-panel {
	height: 500px; /* 컨테이너의 높이를 500px로 설정합니다. */
	background-color: #2a3b4c;
}

.arrow-buttons {
	position: absolute; /* 절대 위치로 설정하여 화면에서 고정된 위치에 배치합니다. */
	top: 75px;
	left: 45%;
	width: 300px;
	height: 300px;
}

/* 각 방향 버튼의 기본 스타일입니다. 버튼 크기와 색상, 모양을 지정합니다. */
.control-button {
	position: absolute; /* 각 버튼을 arrow-buttons 안에서 절대 위치로 배치합니다. */
	width: 150px; /* 버튼 너비를 70px로 설정합니다. */
	height: 150px; /* 버튼 높이를 70px로 설정합니다. */
	border: none; /* 버튼의 기본 테두리를 제거합니다. */
	border-radius: 10px; /* 버튼 모서리를 10px 반경으로 둥글게 처리합니다. */
	cursor: pointer; /* 버튼 위에 마우스를 올리면 포인터 모양이 나타나도록 설정합니다. */
}

/* 위쪽 버튼을 배치하는 클래스입니다. */
.up-btn {
	top: 0; /* 컨테이너의 위쪽에 위치시킵니다. */
	left: 50%; /* 수평 중앙에 위치하도록 합니다. */
	transform: translate(-50%, -50%); /* 버튼을 -50%씩 이동하여 정확한 중앙에 배치합니다. */
}

/* 아래쪽 버튼을 배치하는 클래스입니다. */
.down-btn {
	bottom: 0; /* 컨테이너의 아래쪽에 위치시킵니다. */
	left: 50%; /* 수평 중앙에 위치하도록 합니다. */
	transform: translate(-50%, 50%) rotate(180deg);
	/* 버튼을 수평 중앙으로 이동하고 180도 회전시킵니다. */
}

/* 왼쪽 버튼을 배치하는 클래스입니다. */
.left-btn {
	left: 0; /* 컨테이너의 왼쪽에 위치시킵니다. */
	top: 50%; /* 수직 중앙에 위치하도록 합니다. */
	transform: translate(-50%, -50%) rotate(-90deg);
	/* 버튼을 수직 중앙으로 이동하고 -90도 회전시킵니다. */
}

/* 오른쪽 버튼을 배치하는 클래스입니다. */
.right-btn {
	right: 0; /* 컨테이너의 오른쪽에 위치시킵니다. */
	top: 50%; /* 수직 중앙에 위치하도록 합니다. */
	transform: translate(45%, -50%) rotate(90deg);
	/* 버튼을 수직 중앙으로 이동하고 90도 회전시킵니다. */
}

.stop-btn {
	position: absolute; /* 부모 요소를 기준으로 절대 위치를 설정합니다. */
	top: 50%; /* 화면의 세로 중앙으로 배치합니다. */
	left: 50%; /* 화면의 가로 중앙으로 배치합니다. */
	transform: translate(-50%, -50%); /* 요소의 중심이 정확히 중앙에 오도록 조정합니다. */
}

/* 각 버튼 안에 들어갈 이미지를 설정하는 스타일입니다. */
.control-button img {
	width: 100%; /* 이미지 너비를 버튼 크기에 맞춥니다. */
	height: 100%; /* 이미지 높이를 버튼 크기에 맞춥니다. */
	object-fit: cover; /* 이미지 크기 조정 방식으로 cover를 사용하여 버튼에 꽉 차게 만듭니다. */
}
</style>
</head>
<body>
	<div id="app">

		<div id="map"></div>

		<!-- 정유진 객체인식시 이미지 로드하는 모달창 -->
		<div id="alertModal"
			style="display: none; position: fixed; top: 20%; left: 50%; transform: translate(-50%, -50%); width: 300px; padding: 20px; background-color: white; box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);">
			<h2>경고!</h2>
			<p>객체가 인식되었습니다.</p>
			<img id="detectedImage" src="" alt="Detected Object"
				style="width: 100%;">
			<button onclick="closeAlertModal()">닫기</button>
		</div>

		<!-- 실시간 비디오 모달 -->
		<div id="videoModal"
			class="videoModal w-[80%] max-w-screen-md rounded-3xl bg-neutral-50 text-center antialiased px-5 md:px-20 py-10 shadow-2xl shadow-zinc-900 relative top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
			style="padding: 10px 30px;">

			<h3 class="text-2xl lg:text-3xl font-bold text-neutral-900 my-4">
				Camera view</h3>

			<button class="video-close-btn" @click="closeVideoModal">✖</button>
			<img id="cameraVideo" src="http://192.168.219.47:8080/video_feed"
				alt="Video Feed" />

			<button type="button" id="reset" disabled
				class="px-8 py-4 mt-8 rounded-2xl text-neutral-50 bg-violet-800 hover:bg-violet-600 active:bg-violet-900 disabled:bg-neutral-900 disabled:cursor-not-allowed transition-colors"
				style="margin: 16px 0px 0px">Reset the position</button>

			<svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg"
				class="w-[16px] h-[16px] absolute right-6 top-6">
               <path d="m2 2 12 12m0-12-12 12"
					class="stroke-2 stroke-current" /></svg>
		</div>

		<!-- 항해 시작 설정 모달 -->
		<div class="modal-overlay" id="sailModal" style="display: none;"
			@click="closeSailModal2">
			<div
				class="sailModal w-[80%] max-w-screen-md rounded-3xl bg-neutral-50 text-center antialiased px-5 md:px-20 py-10 shadow-2xl shadow-zinc-900 relative top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
				style="padding: 10px 30px;">

				<h3 class="text-2xl lg:text-3xl font-bold text-neutral-900 my-4"
					style="margin: 25px 0px;">Sail Start</h3>

				<div class="sailContainer form-floating mb-3">

					<form id="sailForm" action="sail/insert" method="post">
						<table class="table table-bordered" style="text-align: center;">
							<tr>
								<td style="vertical-align: middle; width: 110px;">선박 코드</td>
								<td><input type="text" name="siCode" id="siCode"
									value="${sessionScope.nowShip.siCode }" readonly
									class="form-control"></td>
							</tr>
							<tr>
								<td style="vertical-align: middle; width: 110px;">출발지</td>
								<td><input type="text" name="startSail" id="startSail"
									placeholder="출발지를 입력해주세요" class="form-control"></td>
							</tr>
							<tr>
								<td style="vertical-align: middle; width: 110px;">목적지</td>
								<td><input type="text" name="endSail" id="endSail"
									placeholder="목적지를 입력해주세요" class="form-control"></td>
							</tr>

							<tr>
								<td colspan="2">
									<button type="button" id="routeSet" @click="getFirstPoly"
										class="px-8 py-4 mt-8 rounded-2xl text-neutral-50 bg-violet-800 hover:bg-violet-600 active:bg-violet-900 disabled:bg-neutral-900 disabled:cursor-not-allowed transition-colors"
										style="margin: 8px 0px">경로 탐색</button>
								</td>
							</tr>
						</table>
					</form>
				</div>

				<svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg"
					class="w-[16px] h-[16px] absolute right-6 top-6"
					@click="closeSailModal" style="cursor: pointer;">
               <path d="m2 2 12 12m0-12-12 12"
						class="stroke-2 stroke-current" /></svg>

				<div class="wayPoint">

					<!-- 여기에 지도 추가 -->
					<div id="sailModalMap"
						style="width: 100%; height: 300px; z-index: 1000000"></div>

					<div class="sailSetAlert">
						<ol style="list-style-position: inside;">
							<p>경유지를 추가할 경우 경로 재탐색이 필요합니다</p>
						</ol>
					</div>

					<button type="button" id="addWaypoint" @click="startSailInsert"
						class="px-8 py-4 mt-8 rounded-2xl text-neutral-50 bg-violet-800 hover:bg-violet-600 active:bg-violet-900 disabled:bg-neutral-900 disabled:cursor-not-allowed transition-colors"
						style="margin: 16px 32px;">경로 재탐색 🚤</button>
					<button type="button" id="addWaypoint" @click="showAlert"
						class="px-8 py-4 mt-8 rounded-2xl text-neutral-50 bg-violet-800 hover:bg-violet-600 active:bg-violet-900 disabled:bg-neutral-900 disabled:cursor-not-allowed transition-colors"
						style="margin: 16px 32px;">항해 시작 🚤</button>
				</div>

			</div>
		</div>

		<!-- 속도계 -->
		<div id="speedDisplay" class="speed-display">0</div>

		<!-- 속도 조절 패널 -->
		<div class="speed-control-wrapper">
			<div class="speed-control">
				<label for="speedRange1">속도</label> <input type="range"
					id="speedRange1" min="0" max="40" value="0"> <span
					id="speedDisplay1">0</span> KM
			</div>
			<div class="speed-control">
				<button id="setSpeedBtn">속도 조절</button>
			</div>
		</div>

		<!-- 수동 제어 패널 -->
		<!-- 허재혁 -->
		<div class="control-panel">
			<div class="arrow-buttons">
				<button ref="upBtn" onclick="move('up')"
					class="control-button up-btn">
					<img
						src="<%=request.getContextPath()%>/resources/img/arrowButton.png"
						alt="up">
				</button>
				<button ref="leftBtn" onclick="moveServo('left')"
					class="control-button left-btn">
					<img
						src="<%=request.getContextPath()%>/resources/img/arrowButton.png"
						alt="left">
				</button>
				<button ref="rightBtn" onclick="moveServo('right')"
					class="control-button right-btn">
					<img
						src="<%=request.getContextPath()%>/resources/img/arrowButton.png"
						alt="right">
				</button>
				<button ref="downBtn" onclick="move('down')"
					class="control-button down-btn">
					<img
						src="<%=request.getContextPath()%>/resources/img/arrowButton.png"
						alt="down">
				</button>
				<button ref="stopBtn" onclick="motorStop()"
					class="control-button stop-btn">
					<img src="<%=request.getContextPath()%>/resources/img/stop.png"
						alt="STOP">
				</button>
			</div>
		</div>

		<!-- 아이콘 패널(우측) -->
		<div class="icon-panel">
			<div class="icon" @click="toggleShipModal()">🚤</div>
			<div class="icon" @click="getInfo('온도')">🌡️</div>
			<div class="icon" @click="getInfo('배터리')">🔋</div>
			<div class="icon" @click="getInfo('통신 상태')">📶</div>
			<div class="icon" @click="getInfo('현재 위치')">📍</div>
			<div class="icon" @click="getInfo('방위')">🧭</div>
			<div class="icon" @click="getInfo('주변 장애물 탐지')">🚧</div>
			<div class="icon" @click="goMain()">🔙</div>
			<div class="icon" @click="toggleModal()">📷</div>
		</div>

		<!-- 남은 시간 거리 패널 -->
		<div class="info-overlay">
			<div class="time-distance">
				<span id="remainingTime">9분</span> <span id="remainingDistance">4.1km</span>
			</div>

			<button class="startSail-btn" @click="toggleSailStart"
				:disabled="sailStatus === '1'">항해 시작</button>
			<button class="destination-btn" @click="endSail"
				:disabled="sailStatus === '0'">항해 완료</button>

		</div>

		<!-- 아이콘 정보 상세 패널 -->
		<div class="info-panel" id="infoPanel">
			<button class="close-btn" @click="closeInfoPanel">✖</button>
			<h3 id="infoTitle">정보</h3>
			<p id="infoContent">상세 내용</p>
		</div>

	</div>

	<!-- 자동/수동, 운항중 상태 표시 패널 -->
	<div class="status-overlay">
		<div class="status-btn">
			<button class="autoSift-btn" id="autoSift-btn"
				@click="toggleAutopilot()">auto "on"</button>
			<img class="nowSail-btn" id="nowSail-btn"
				src="<%=request.getContextPath()%>/resources/img/stop.png"
				alt="STOP">
		</div>
	</div>

	<!-- 최초 선박 정보 표시 모달 -->
	<div id="shipModal" class="modal-overlay">
		<div class="modal" @click="closeShipModal2">

			<article class="modal-container">
				<header class="modal-container-header">
					<h1 class="modal-container-title">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
							width="24" height="24" aria-hidden="true">
          <path fill="none" d="M0 0h24v24H0z" />
          <path fill="currentColor"
								d="M14 9V4H5v16h6.056c.328.417.724.785 1.18 1.085l1.39.915H3.993A.993.993 0 0 1 3 21.008V2.992C3 2.455 3.449 2 4.002 2h10.995L21 8v1h-7zm-2 2h9v5.949c0 .99-.501 1.916-1.336 2.465L16.5 21.498l-3.164-2.084A2.953 2.953 0 0 1 12 16.95V11zm2 5.949c0 .316.162.614.436.795l2.064 1.36 2.064-1.36a.954.954 0 0 0 .436-.795V13h-5v3.949z" />
        </svg>
						Current Ship
					</h1>
					<button class="icon-button" @click="closeShipModal">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
							width="24" height="24">
          <path fill="none" d="M0 0h24v24H0z" />
          <path fill="currentColor"
								d="M12 10.586l4.95-4.95 1.414 1.414-4.95 4.95 4.95 4.95-1.414 1.414-4.95-4.95-4.95 4.95-1.414-1.414 4.95-4.95-4.95-4.95L7.05 5.636z" />
        </svg>
					</button>
				</header>
				<section class="modal-container-body rtf">

					<h1>Ship Code</h1>

					<p id="siCode">${sessionScope.nowShip.siCode}</p>

					<h2>선박 명</h2>

					<p id="siName">${sessionScope.nowShip.siName}</p>

					<p id="siCert">인증 여부 : ${sessionScope.nowShip.siCert == '1' ? '인증 승인 완료' : '인증 미승인'}
					</p>
					<p id="sailStatus">운항 상태 : ${sessionScope.nowShip.sailStatus == '1' ? '운항중' : '정박중'}
					</p>

					<h2>자율운항 이용약관</h2>
					<ol
						style="margin-left: 20px; list-style-position: inside; list-style: numeric;">
						<li>자율운항선박 운항해역의 지정·변경·해제(안 제2조) 해수부장관은 자율운항선박 운항해역 지정·변경·해제
							절차 등 규정</li>
						<li>자율운항선박 및 기자재 안전성 평가(안 제3조) 안전성 평가의 신청, 심사·평가 및 활용에 관한 사항
							규정</li>
						<li>운항의 승인신청(안 제4조) 자율운항선박의 운항 승인 신청 절차 규정</li>
						<li>운항의 승인(안 제5조) 자율운항선박의 운항 승인·불승인 관련 사항 규정</li>
						<li>규제 신속확인(안 제6조) 규제 신속확인 신청서 및 통지서 서식</li>
					</ol>
				</section>
				<footer class="modal-container-footer">
					<button class="button is-ghost" @click="goMain">Decline</button>
					<button class="button is-primary" @click="closeShipModal">Accept</button>
				</footer>
			</article>
		</div>
	</div>

	<%
	Ship nowShip = (Ship) session.getAttribute("nowShip");
	char sailStatus = (nowShip != null) ? nowShip.getSailStatus() : '0';
	String siCode = (nowShip != null) ? nowShip.getSiCode() : "siCode is null";
	String msgType = (String) request.getAttribute("msgType");
	String waypoints = (String) session.getAttribute("waypoints");
	%>

	<script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
	<!-- GSAP Scripts -->
	<script src='https://unpkg.com/gsap@3/dist/gsap.min.js'></script>
	<script src='https://unpkg.com/gsap@3/dist/Draggable.min.js'></script>
	<script src='https://assets.codepen.io/16327/InertiaPlugin.min.js'></script>
	<script>
   
   new Vue({
       el: '#app',
       data() {
           return {
               map: null,    // Google Maps 객체를 저장할 변수
               marker: null, // 사용자 마커 객체를 저장할 변수
               flightPlanCoordinates: [], // Polyline 데이터를 저장할 곳
               sailStatus: '<%=String.valueOf(sailStatus)%>',
               
               sailMap: null, // sailModal에 들어갈 지도
               sailMarkers: [], // sailModal에서 표시된 마커들
               currentPositionMarker: null, // 사용자 현재 위치 마커
               waypoints: <%=(waypoints != null) ? waypoints : "[]"%>,
               
               formData: { // 항해 시작 설정 form 데이터 저장
                   siCode: "<%=siCode%>",
                   startSail: "",
                   endSail: ""
               },
               msgType: '<%=(msgType != null) ? msgType : ""%>'
           };
       },
       mounted() {
          // 전역에서 참조 가능하도록 저장
           window.appVueInstance = this;
          
           this.loadPoly(); // 경로 데이터 받아오기
           this.updateLocation(); // 위치 업데이트 시작
           this.initSpeedControls(); // 속도 조절 컨트롤 초기화
           this.toggleModal(); // 실시간 비디오 모달 켜기
           this.initDraggable(); // 모달 드래그 기능 초기화
           this.afterStartSail(); // 항해 시작 후 (경유지 추가)
       },
       methods: {
          loadPoly() { // 1. 경로 데이터 받아오기(GoogleMapController)

             const waypoints = JSON.stringify(this.waypoints);
               axios.post("http://localhost:8085/controller/flightPlanCoordinates", waypoints, {
                   headers: {
                       'Content-Type': 'application/json' // 올바른 Content-Type 헤더 설정
                   }
               })
               .then(response => {
                 this.flightPlanCoordinates = response.data;  // 데이터를 Vue 데이터 속성에 할당
                 this.initMap();
                 this.initSailMap();
               })
               .catch(error => {
                 console.error("Error fetching coordinates:", error);
               });
          
           },
           initMap() { // 2. 지도 초기화 및 polyline 그리기(Google maps api)
               // Google Maps 스타일 설정 (다크 모드)
               var styledMapType = new google.maps.StyledMapType(
                   [
                       { elementType: 'geometry', stylers: [{ color: '#212121' }] },
                       { elementType: 'labels.icon', stylers: [{ visibility: 'off' }] },
                       { elementType: 'labels.text.fill', stylers: [{ color: '#757575' }] },
                       { elementType: 'labels.text.stroke', stylers: [{ color: '#212121' }] },
                       {
                           featureType: 'administrative',
                           elementType: 'geometry',
                           stylers: [{ color: '#757575' }]
                       },
                       {
                           featureType: 'road',
                           elementType: 'geometry.fill',
                           stylers: [{ color: '#2c2c2c' }]
                       },
                       {
                           featureType: 'water',
                           elementType: 'geometry',
                           stylers: [{ color: '#000000' }]
                       },
                       {
                           featureType: 'poi.park',
                           elementType: 'geometry',
                           stylers: [{ color: '#181818' }]
                       }
                   ],
                   { name: 'Dark Mode' }
               );

               // Google Maps 초기화
               this.map = new google.maps.Map(document.getElementById('map'), {
                  center: { lat: 34.804309-0.005032, lng: 126.364591-0.076814 }, // 초기 중심 좌표 설정(북항)
                   zoom: 13, // 초기 줌 레벨
                   mapTypeControlOptions: {
                       mapTypeIds: ['roadmap', 'satellite', 'hybrid', 'terrain', 'styled_map']
                   },
                   mapTypeId: "roadmap", // 지도 유형 설정
               });

               // 기본 맵 스타일 적용
               this.map.mapTypes.set('styled_map', styledMapType);
               this.map.setMapTypeId('roadmap');
               
               // Polyline 생성 및 지도에 추가
               const flightPath = new google.maps.Polyline({
                   path: this.flightPlanCoordinates,
                   geodesic: true,
                   strokeColor: "#FF0000",
                   strokeOpacity: 1.0,
                   strokeWeight: 3,
               });
               flightPath.setMap(this.map);

           },
           async updateLocation() { // 3. 사용자 현재 위치 표시(Google geolocation api)
               // 위치 업데이트를 위한 함수
               const updatePosition = () => {
                   // Geolocation API를 사용하여 현재 위치 가져오기
                   navigator.geolocation.getCurrentPosition(async (position) => {
                       const { latitude, longitude } = position.coords;

                       // Google Maps에 사용자 마커 표시
                       if (!this.marker) {
                           // 마커가 없는 경우 새로 생성
                           this.marker = new google.maps.Marker({
                               position: { lat: latitude, lng: longitude }, // 마커 위치
                               map: this.map, // 표시할 지도
                               icon: {
                                   url: '<%=request.getContextPath()%>/resources/img/icon.png', // 마커 아이콘 경로
                                   scaledSize: new google.maps.Size(100, 100) // 아이콘 크기 조정
                               }
                           });

                           // 마커의 위치로 지도의 중심 이동
                           this.map.setCenter({ lat: latitude, lng: longitude });
                       } else {
                           // 마커가 이미 있는 경우 위치 업데이트
                           this.marker.setPosition({ lat: latitude, lng: longitude });
                       }

                       // 서버에 위치 정보 요청
                       try {
                           const response = await fetch(`/api/location?latitude=${latitude}&longitude=${longitude}`);
                           const data = await response.json();
                       } catch (error) {
                           console.error('Error fetching location info:', error);
                       }
                   }, (error) => {
                       console.error('Geolocation error:', error); // 오류 처리
                   });
               };

               // 위치 업데이트 간격 설정(100초 간격)
               setInterval(updatePosition, 100000);
           },
           initSpeedControls() { // 4. 속도 조절 함수
               
               document.getElementById('speedRange1').addEventListener('input', function () {
                   document.getElementById('speedDisplay1').textContent = this.value;
               });

               document.getElementById('setSpeedBtn').addEventListener('click', function () {
                   var currentSpeed = document.getElementById('speedRange1').value;
                   alert(currentSpeed + 'km로 속도를 설정합니다.');
               });

               document.getElementById('speedRange1').addEventListener('input', function () {
                   var speedValue = this.value;
                   document.getElementById('speedDisplay').textContent = speedValue;
                   document.getElementById('speedDisplay1').textContent = speedValue;
               });
           },
           showInfo(title) { // 5. 정보 패널 표시 함수

               const infoPanel = document.getElementById('infoPanel');
               const infoTitle = document.getElementById('infoTitle');

               infoTitle.textContent = title; // 패널 제목 설정
               infoPanel.classList.add('active'); // 패널 표시

           }, getInfo(title){ // 6. 정보 패널 데이터 받아오기
              
               const infoContent = document.getElementById('infoContent');
           
              axios.get("http://localhost:8085/controller/getInfo", {
                 params: {
                    infoTitle: title
                 }
              }) 
               .then(response => {
                   this.infoTitle = title;
                   infoContent.textContent = response.data;  // 받아온 데이터로 infoContent 업데이트
                   this.showInfo(title);  // info-panel을 열어줌
               })
               .catch(error => {
                   console.error('Error getInfow data:', error);
               });
              
           }, closeInfoPanel() { // 7. 정보 패널 숨김 함수

               const infoPanel = document.getElementById('infoPanel');
               infoPanel.classList.remove('active'); // 패널 숨김
               
           }, startSail(){ // 8. startSail 메서드 실행 함수
              
              axios.get("http://localhost:8085/controller/sail/startSail")
              .then(response => {
                   console.log("Sail started successfully.");
               })
               .catch(error => {
                   console.error('Error in startSail:', error.response ? error.response.data : error.message);
               });
              
           }, endSail() { // 9. endSail 메서드 실행 함수
              
              axios.get("http://localhost:8085/controller/sail/endSail")
              .then(response => {
                   console.log("Sail ended successfully.", response.data);
                   window.location.href = "http://localhost:8085/controller/map2";
               })
               .catch(error => {
                   console.error('Error in endSail:', error.response ? error.response.data : error.message);
               });
           
           }, closeVideoModal(){ // 10. 실시간 카메라 모달 끄기 함수
              
              var videoModal = document.getElementById("videoModal");
              videoModal.style.display = "none";
               
           }, toggleModal() { // 11. 실시간 카메라 모달 켜기 함수
               var modal = document.getElementById("videoModal");
               var mapDiv = document.getElementById("map");

               if (modal.style.display === "none" || modal.style.display === "") {
                   var mapHeight = mapDiv.offsetHeight;
                   var mapWidth = mapDiv.offsetWidth;
                   
                   var modalWidth = mapWidth * 0.35;
                   var modalHeight = modalWidth * 0.946;

                   // 모달 크기 설정
                   modal.style.height = modalHeight + "px";
                   modal.style.width = modalWidth + "px";
                   
                   // 모달 위치 중앙에 설정
                   modal.style.top = (mapHeight * 0.3) + "px";
                   modal.style.left = (mapWidth * 0.075) + "px";

                   modal.style.display = "block"; // 모달 표시
               } else {
                   modal.style.display = "none";
               }
           },
           initDraggable() { // 12. 실시간 카메라 모달 드래그 함수
               const modal = document.getElementById('videoModal');
               const wrapper = document.getElementById('map');
               const reset = document.getElementById('reset');
               const page = document.getElementById('app');

               const resetModalPosition = () => {
                  
                  const wrapperRect = wrapper.getBoundingClientRect();
                   const pageRect = page.getBoundingClientRect();
                   
                   modal.style.position = 'fixed';
                  
                   gsap.to(modal, {
                       duration: 0.6,
                       ease: "power3.out",
                       x: wrapperRect.left,
                       y: pageRect.top,
                       xPercent: 0,
                       yPercent: 0,
                   });
                   reset.disabled = true;
               };

               Draggable.create(modal, {
                   type: 'x,y',
                   bounds: wrapper,
                   edgeResistance: 0.85,
                   inertia: true,
                   throwResistance: 3000,
                   onPressInit: function() {
                       page.classList.add('bg-violet-900');
                   },
                   onRelease: function() {
                       page.classList.remove('bg-violet-900');
                   },
                   onDrag: function() {
                       const x = gsap.getProperty(this, 'x');
                       const y = gsap.getProperty(this, 'y');

                       if (x === 0 && y === 0) {
                           reset.disabled = true;
                       } else {
                           reset.disabled = false;
                       }
                   }
               });

               reset.addEventListener('click', resetModalPosition);

               window.addEventListener('resize', () => {
                   resetModalPosition();
               });
           }, toggleSailStart() { // 1. 항해 시작 모달(sailModal) 켜기 ------------------------------------------------------------------------------------------
               var modal = document.getElementById("sailModal");

               if (modal.style.display === "none" || modal.style.display === "") {
                  
                  modal.style.display = "block"; // 모달 표시
               } else {
                   modal.style.display = "none";
               }
           },
           initSailMap() { // 2. sailModal에 지도를 띄우는 새로운 로직(마커 정보를 변수에 저장하고 좌표 정보도 저장)
               
               this.sailMap = new google.maps.Map(document.getElementById('sailModalMap'), {
                  center: { lat: 34.804309, lng: 126.364591}, // 초기 중심 좌표 설정(북항)
                   zoom: 13
               });
           
               // 사용자의 현재 위치 마커 표시
               const updatePosition = () => {
                   navigator.geolocation.getCurrentPosition(async (position) => {
                       const { latitude, longitude } = position.coords;

                       if (!this.marker) {
                           this.marker = new google.maps.Marker({
                               position: { lat: latitude, lng: longitude }, 
                               map: this.sailMap, // 표시할 지도
                               icon: {
                                   url: '<%=request.getContextPath()%>/resources/img/icon.png', // 마커 아이콘 경로
                                   scaledSize: new google.maps.Size(100, 100) // 아이콘 크기 조정
                               }
                           });

                           this.sailMap.setCenter({ lat: latitude, lng: longitude });
                       } else {
                           this.marker.setPosition({ lat: latitude, lng: longitude });
                       }

                       try {
                           const response = await fetch(`/api/location?latitude=${latitude}&longitude=${longitude}`);
                           const data = await response.json();
                       } catch (error) {
                           console.error('Error fetching location info:', error);
                       }
                   }, (error) => {
                       console.error('Geolocation error:', error); 
                   });
               };

               // 위치 업데이트 간격 설정(100초 간격)
               setInterval(updatePosition, 100000);
              
               // sailModal 지도를 클릭할 때마다 마커를 추가하는 기능
               this.sailMap.addListener('click', (event) => {
                   const position = { lat: event.latLng.lat(), lng: event.latLng.lng() };
                   const marker = new google.maps.Marker({
                       position,
                       map: this.sailMap,
                   });

                   // 추가된 마커를 배열에 저장
                   this.sailMarkers.push(marker);
                   
                   this.waypoints = this.sailMarkers.map(marker => ({
                      lat: marker.getPosition().lat(),
                      lng: marker.getPosition().lng(),
                  }));
               });
               
           }, 
           getFirstPoly() { // 3. 목적지 설정 버튼 누르면 비동기 방식으로 경로 받아오기(GoogleMapController에서 a*알고리즘과 통신)

              const waypoints = JSON.stringify(this.waypoints);
              console.log("waypoints : "+waypoints);
               
               axios.post('http://localhost:8085/controller/flightPlanCoordinates', waypoints, {
                   headers: {
                       'Content-Type': 'application/json' // 올바른 Content-Type 헤더 설정
                   }
               })
                   .then(response => {
                      this.flightPlanCoordinates = response.data;
                         
                         // Polyline 생성 및 지도에 추가
                       const flightPath = new google.maps.Polyline({
                           path: this.flightPlanCoordinates,
                           geodesic: true,
                           strokeColor: "#FF0000",
                           strokeOpacity: 1.0,
                           strokeWeight: 3,
                       });
                       flightPath.setMap(this.sailMap);
                        
                   })
                   .catch(error => {
                       console.error("목적지 설정 실패:", error);
                   });
          },
           sendWaypoints() { // 4. sailMarkers에 저장된 좌표 정보를 Controller로 전송(db 저장)
           
               axios.post("http://localhost:8085/controller/saveWaypoint", this.waypoints, {
                   headers: {
                       'Content-Type': 'application/json' // 올바른 Content-Type 헤더 설정
                   }
               })
                   .then(response => {
                   })
                   .catch(error => {
                       console.error("Error saving waypoints:", error);
                   });
               
           }, startSailInsert(){ // 5. sailController에 데이터 보내고(form submit) 항해시작db저장
              
              axios.post("http://localhost:8085/controller/waypointSession", this.waypoints)
                .then(response => {
                })
                .catch(error => {
                    console.error("Error waypointSession waypoints:", error);
                });
              
             document.getElementById("sailForm").submit(); // 항해 시작 Controller 연결

           }, afterStartSail(){
              
              if (this.msgType === "성공") {
                this.sendWaypoints();
               }
              
           }, showAlert() { // 6. 항해 확정 alert 창 
              
               const waypointsList = this.waypoints.map(waypoint => 
                  waypoint.lat + " " + waypoint.lng
              ).join('<br>');
              console.log("waypointsList : "+waypointsList);

              Swal.fire({
                   title: "<strong>Waypoints</strong>",
                   icon: "info",
                   html: "Here are the waypoints:<br>"
                       + waypointsList,
                   showCloseButton: true,
                   showCancelButton: true,
                   focusConfirm: false,
                   confirmButtonText: `
                       <i class="fa fa-thumbs-up">Great!</i>
                   `,
                   confirmButtonAriaLabel: "Thumbs up, great!",
                   cancelButtonText: `
                       <i class="fa fa-thumbs-down">Cancel</i>
                   `,
                   cancelButtonAriaLabel: "Thumbs down"
               }).then((result) => {
                   if (result.isConfirmed) {
                       this.startSailInsert(); // 버튼 클릭 시 메소드 호출
                   }
               });
               
           }, closeSailModal(){ // 항해 시작 모달 끄기(x 클릭)1
              var videoModal = document.getElementById("sailModal");
              videoModal.style.display = "none";
           }, closeSailModal2(event){ // 항해 시작 모달 끄기(레이아웃 클릭)2---------------------------------------------------------------------------
              
              var modal = document.getElementById("sailModal");
              
              if (event.target === event.currentTarget) {
                   modal.style.display = "none";
               }
           }, goMain(){
              window.location.href = "http://localhost:8085/controller/main"; // 특정 페이지로 이동
              
           }, toggleShipModal() { // 1. 선박 정보 최조 출력 모달
               
            var modal = document.getElementById("shipModal");

               if (modal.style.display === "none" || modal.style.display === "") {
                  
                  modal.style.display = "block"; // 모달 표시
               } else {
                   modal.style.display = "none";
               }
           }
       }
   });
   
   new Vue({
      el: '#shipModal',
      data(){
         return{
            
            sailStatus: '<%=String.valueOf(sailStatus)%>'
         };
      }, mounted(){
         
         // 이전 페이지가 main인지 확인
           if (document.referrer === "http://localhost:8085/controller/main") {
              this.toggleShipModal();
           }
      },
      methods: {
         toggleShipModal() { // 1. 선박 정보 최조 출력 모달
               
            var modal = document.getElementById("shipModal");

               if (modal.style.display === "none" || modal.style.display === "") {
                  
                  modal.style.display = "block"; // 모달 표시
               } else {
                   modal.style.display = "none";
               }
           }, closeShipModal(){ // 2. 선박 정보 최초 출력 모달 끄기
              
              var shipModal = document.getElementById("shipModal");
              shipModal.style.display = "none";
              
           }, closeShipModal2(event){
              
              var modal = document.getElementById("shipModal");
              
              if (event.target === event.currentTarget) {
                   modal.style.display = "none";
               }
           }, goMain(){ // 3. 메인으로 이동
              window.location.href = "http://localhost:8085/controller/main"; // 특정 페이지로 이동
              
           }
      }
   });
   
   new Vue({
       el: '.status-overlay',
       data() {
           return {
               
               sailStatus: '<%=String.valueOf(sailStatus)%>'
           };
       }, mounted () {
          
          this.checkSailStatus(); // 운항 상태 확인
       },
       methods: {
          toggleAutopilot() { // 자율운항 toggle

              var btn = document.getElementById("autoSift-btn");
              btn.textContent = btn.textContent === 'auto "on"' ? 'auto "off"' : 'auto "on"';
              
              if(btn.textContent === 'auto "off"'){
                 btn.style.opacity = 0.7;
              }else{
                 btn.style.opacity = 1;
              }
              
              // #app 인스턴스의 control-panel 버튼 비활성화/활성화
               const appInstance = window.appVueInstance;
               if (appInstance) {
                   ["upBtn", "leftBtn", "rightBtn", "downBtn", "stopBtn"].forEach(ref => {
                       if (appInstance.$refs[ref]) {
                           appInstance.$refs[ref].disabled = (btn.textContent === 'auto "on"');
                       }
                   });
               }
              
           }, checkSailStatus(){
              
              var btn = document.getElementById("nowSail-btn");
              console.log(this.sailStatus);
              
              if(this.sailStatus === '1'){
                 btn.style.opacity = 1;
                 btn.style.boxShadow = '0 0 20px rgba(255, 0, 0, 0.7), 0 0 30px rgba(255, 0, 0, 0.5)';
              }else {
                 btn.style.opacity = 0.5;
                 btn.style.boxShadow = 'none';
              }
              
           }
       }
   });

    </script>

	<!-- 수동제어 관련 / 허재혁 -->
	<script>
        var speed = 0; //초기값
        var maxSpeed = 100;
        var minSpeed = 0;

        var degree = 90;  // 서보 모터 기본 각도
        var maxDegree = 180;
        var minDegree = 0;
        
        // 속도 ↑ ↓
        function move(direction) {
            if (direction === 'up') {
                speed += 10;
                if (speed > maxSpeed) {
                    speed = maxSpeed;
                }
            } else if (direction === 'down') {
                speed -= 10;
                if (speed < minSpeed) {
                    speed = minSpeed;
                }
            }

            // AJAX 요청으로 서버에 속도 값 전달
            fetch('/controller/updateSpeed', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ speed: speed })
            })
            .then(response => response.json())
            .then(data => {
                console.log('Speed updated on server:', data);
            })
            .catch(error => {
                console.error('Error updating speed:', error);
            });
        }
      
        // 방향타 ← →
        function moveServo(direction) {
            if (direction === 'left') {
                degree -= 10;
                if (degree < minDegree) {
                    degree = minDegree;
                }
            } else if (direction === 'right') {
                degree += 10;
                if (degree > maxDegree) {
                    degree = maxDegree;
                }
            }

            console.log('Sending degree to server:', degree);

            // AJAX 요청으로 서버에 각도 값 전달
            fetch('/controller/updateServoDegree', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ degree: degree })
            })
            .then(response => response.json())
            .then(data => {
                console.log('Degree updated on server:', data);
            })
            .catch(error => {
                console.error('Error updating degree:', error);
            });
        }
        
        // 모터 스탑 속도값 0
        function motorStop() {
           speed = 0;
           fetch('/controller/updateSpeed', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ speed: speed })
            })
            .then(response => response.json())
            .then(data => {
                console.log('Speed updated on server:', data);
            })
            .catch(error => {
                console.error('Error updating speed:', error);
            });
        }           
         
        // 서보 중앙고정 90도 값
        function servoReset() {
           degree = 90;
           fetch('/controller/updateServoDegree', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ degree: degree })
            })
            .then(response => response.json())
            .then(data => {
                console.log('Degree updated on server:', data);
            })
            .catch(error => {
                console.error('Error updating degree:', error);
            });
        }
        
        // 정유진 웹소캣 수진하기
        let stompClient = null;

        function connectWebSocket() {
            const socket = new SockJS('/ws');
            stompClient = Stomp.over(socket);

            stompClient.connect({}, function (frame) {
                console.log('Connected: ' + frame);
                stompClient.subscribe('/topic/alerts', function (message) {
                    const data = JSON.parse(message.body);
                    if (data.status === "success") {
                        document.getElementById("detectedImage").src = data.image;
                        document.getElementById("alertModal").style.display = "block";
                    }
                });
            });
        }

        document.addEventListener('DOMContentLoaded', (event) => {
            connectWebSocket();
        });

        
    </script>

</body>
</html>