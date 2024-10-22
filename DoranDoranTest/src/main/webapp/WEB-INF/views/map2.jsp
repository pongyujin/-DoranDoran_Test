<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<title>map2</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- Google Maps API - Spring에서 전달된 API 키 사용 -->
<script
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDtt1tmfQ-lTeQaCimRBn2PQPTlCLRO6Pg"></script>
<style>

/* 지도 및 버튼 스타일 */
#map {
	width: 100%; /* 너비를 100%로 설정 */
	height: 900px; /* 높이를 900px로 설정 */
	z-index: 1; /* 지도는 뒤로 배치 */
}

body {
	background: linear-gradient(90deg, #1A2529 12%, #1C2933 29%, #17293A 46%, #313F49
		100%);
	margin: 0;
	padding: 0;
	position: relative; /* 지도를 기준으로 속도 조절 위치 조정 */
}

/* 투명한 배경 박스 스타일 (위쪽으로 위치 조정) */
.info-overlay {
	position: absolute;
	bottom: 370px;
	left: 50%;
	transform: translateX(-50%);
	background-color: rgba(255, 255, 255, 0.8);
	padding: 10px 20px;
	width: 500px;
	border-radius: 10px;
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 10; /* 지도의 z-index보다 높은 값을 설정하여 지도 위에 표시되도록 설정 */
}

.time-distance {
	font-size: 20px;
	font-weight: bold;
	color: #000;
	display: flex;
	justify-content: space-between;
	width: 200px;
}

.time-distance span {
	margin: 0 10px;
}

/* 목적지 설정 버튼 스타일 */
.destination-btn {
	background-color: #1C2933;
	color: #ffffff;
	padding: 10px 20px;
	font-size: 14px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	position: fixed !important; /* Viewport에 고정 */
	right: -600px !important; /* 오른쪽 끝에서 100px 더 오른쪽으로 이동 */
	bottom: 11px !important; /* 바텀은 그대로 유지 */
	z-index: 9999 !important; /* 매우 높은 z-index로 다른 요소 위에 표시 */
	box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.3); /* 버튼에 그림자 추가 */
}

.destination-btn:hover {
	background-color: #17293A;
}

/* 부모 컨테이너 설정 */
.control-panel {
	position: relative;
	width: 100%; /* 부모 컨테이너의 너비를 100%로 설정 */
	height: 300px; /* 패널의 높이 */
	margin-top: 50px;
}

/* 개별 클래스 적용 */
.left-btn {
	position: absolute;
	left: 42.9%; /* 적당한 위치로 이동 */
	width: 130px;
	height: 120px;
	bottom: 120px;
}

.right-btn {
	position: absolute;
	left: 51.5%; /* 적당한 위치로 이동 */
	width: 110px;
	height: 120px;
	bottom: 125px;
}

/* 상향 버튼 (.up-btn) */
.up-btn {
	position: absolute;
	bottom: 200px; /* 위쪽으로 배치 */
	left: 50%; /* 부모의 왼쪽으로부터 50% */
	transform: translateX(-42%); /* 50%에서 45%로 변경하여 살짝 오른쪽으로 이동 */
	width: 110px;
	height: 110px;
}

/* STOP 아이콘 */
.stop-icon {
	position: absolute;
	width: 160px;
	height: 160px;
	bottom: 130px;
	right: 500px; /* 70px에서 90px로 변경하여 살짝 왼쪽으로 이동 */
}

/* 속도 조절 컨트롤 고정 */
.speed-control-wrapper {
	position: absolute; /* 부모 요소에 고정 */
	bottom: 120px; /* 부모 요소의 아래쪽으로부터 100px 간격 */
	left: 400px; /* 부모 요소의 왼쪽으로부터 400px 간격 */
	display: flex;
	flex-direction: column;
	gap: 10px;
	z-index: 1000; /* 다른 요소 위에 배치 */
	padding: 10px;
	border-radius: 10px;
}

/* 속도 조절 컨트롤 스타일 */
.speed-control {
	display: flex;
	align-items: center;
	justify-content: center;
	background-color: #1A2529;
	padding: 10px;
	border-radius: 10px;
	width: 300px;
	margin-bottom: 10px;
	font-size: 18px;
	color: #ffffff;
}

.speed-control input[type="range"] {
	width: 150px;
	margin: 0 10px;
	background-color: #313F49;
	accent-color: #1C2933;
}

.speed-control span {
	color: #ffffff;
	font-weight: bold;
}

.speed-control button {
	background-color: #1C2933;
	border: none;
	color: #ffffff;
	padding: 10px 20px;
	font-size: 18px;
	cursor: pointer;
	border-radius: 5px;
}

.speed-control button:hover {
	background-color: #17293A;
}

.icon-panel {
	position: absolute;
	top: 100px;
	right: 10px;
	background-color: rgba(0, 0, 0, 0.7);
	border-radius: 10px;
	padding: 15px;
	display: flex;
	flex-direction: column;
	gap: 10px;
	z-index: 1;
}

.icon {
	width: 40px;
	height: 40px;
	background-color: rgba(255, 255, 255, 0.1);
	border-radius: 10px;
	display: flex;
	justify-content: center;
	align-items: center;
	cursor: pointer;
	transition: background-color 0.3s ease, transform 0.3s ease;
	font-size: 27px;
}

.icon:hover {
	background-color: rgba(255, 255, 255, 0.3);
	transform: scale(1.1);
}

.info-panel {
	position: absolute;
	top: 100px;
	right: 70px;
	background-color: rgba(0, 0, 0, 0.9);
	border-radius: 10px;
	padding: 20px;
	width: 250px;
	color: white;
	display: none;
	z-index: 2;
}

.info-panel.active {
	display: block;
}

.info-panel h3 {
	margin-top: 0;
	font-size: 18px;
	text-align: center;
}

.info-panel p {
	font-size: 14px;
	text-align: center;
}

.close-btn {
	position: absolute;
	top: 10px;
	right: 10px;
	cursor: pointer;
	font-size: 20px;
	color: white;
	background-color: transparent;
	border: none;
}

.speed-display {
	font-size: 50px;
	font-weight: bold;
	position: absolute;
	top: 170px; /* 화면의 위쪽에서 80px (이전보다 10px 더 아래) */
	left: 170px; /* 화면의 왼쪽에서 80px (이전보다 20px 더 오른쪽) */
	color: black; /* 기본 모드에서는 검은색 */
	z-index: 1000;
	padding: 10px;
	border-radius: 5px;
}

.dark-mode .speed-display {
	color: white;
}

/* 모달창 기본 스타일 */
.videoModal {
	position: absolute;
	color: white;
	background-color: rgba(0, 0, 0, 0.9);
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	z-index: 2;
	border-radius: 10px;
	cursor: grab;
	overflow: hidden; /* 자식 요소가 부모 요소를 넘지 않도록 설정 */
	display: flex; /* Flexbox 사용 */
	flex-direction: column; /* 수직 방향으로 정렬 */
	align-items: center; /* 수평 중앙 정렬 */
	justify-content: center; /* 수직 중앙 정렬 */
}

.videoModal:active {
	cursor: grabbing;
}

/* 비디오 스타일 */
.videoModal img {
	width: auto; /* 부모 요소에 맞춰 너비 조정 */
    height: 100%; /* 비율에 맞춰 높이 조정 */
	margin: 10px;
	color: white;
}

.videoModal h3 {
	font-size: 18px;
	margin-top: 10px;
	text-align: center;
}
</style>
</head>
<body>
	<div id="app">
	
		<div id="map"></div>
		
		<div id="speedDisplay" class="speed-display">0</div>

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

		<div class="control-panel">
			<div class="arrow-buttons">
				<img src="<%=request.getContextPath()%>/resources/img/left.png"
					alt="left" class="left-btn"> <img
					src="<%=request.getContextPath()%>/resources/img/top.png" alt="up"
					class="up-btn"> <img
					src="<%=request.getContextPath()%>/resources/img/right.png"
					alt="right" class="right-btn">
			</div>
			<img class="stop-icon"
				src="<%=request.getContextPath()%>/resources/img/stop.png"
				alt="STOP">
		</div>

		<div class="icon-panel">
			<div class="icon" @click="showInfo('날씨', '12 kn, SW(241°), 23°C')">🌤️</div>
			<div class="icon" @click="showInfo('온도', '24°C 입니다')">🌡️</div>
			<div class="icon" @click="showInfo('배터리', '배터리 잔량 80%')">🔋</div>
			<div class="icon" @click="showInfo('통신 상태', '통신 상태 양호')">📶</div>
			<div class="icon" @click="showInfo('속도', '30 노트 속도')">🚤</div>
			<div class="icon" @click="showInfo('남은 시간', '남은 시간 2시간')">⏱️</div>
			<div class="icon" @click="showInfo('남은 거리', '남은 거리 10km')">🛣️</div>
			<div class="icon" @click="showInfo('현재 위치', '위도: 37.5665, 경도: 126.9780')">📍</div>
			<div class="icon" @click="showInfo('방위', '북쪽 방향')">🧭</div>
			<div class="icon" @click="showInfo('주변 장애물 탐지', '장애물 없음')">🚧</div>
			<div class="icon" @click="toggleModal()">📷</div>
		</div>

		<!-- 실시간 영상 모달창 -->
		<div class="videoModal" id="videoModal"  @mousedown="startDrag" @mouseup="stopDrag" @mousemove="drag"
		:style="{ top: modalTop, left: modalLeft, display: modalDisplay }">
			<button class="close-btn" @click="closeVideoModal">✖</button>
			<h3>camera view</h3>
			<img id="cameraVideo" src="http://192.168.219.47:8080/video_feed" alt="Video Feed" />
		</div>

		<div class="info-overlay">
			<div class="time-distance">
				<span id="remainingTime">9분</span> <span id="remainingDistance">4.1km</span>
			</div>

			<button class="destination-btn" @click="setDestinationMode">목적지
				설정</button>
		</div>

		<div class="info-panel" id="infoPanel">
			<button class="close-btn" @click="closeInfoPanel">✖</button>
			<h3 id="infoTitle">정보</h3>
			<p id="infoContent">상세 내용</p>
		</div>
		
	</div>
	
	<script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
	<script>
	
	new Vue({
	    el: '#app',
	    data() {
	        return {
	            map: null,    // Google Maps 객체를 저장할 변수
	            marker: null, // 사용자 마커 객체를 저장할 변수
	        };
	    },
	    mounted() {
	        this.initMap(); // 컴포넌트가 마운트될 때 지도 초기화
	        this.updateLocation(); // 위치 업데이트 시작
	        this.initSpeedControls(); // 속도 조절 컨트롤 초기화
	        this.toggleModal(); // 실시간 비디오 모달 켜기
	    },
	    methods: {
	        initMap() {
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
	                center: { lat: 34.500000-0.005032, lng: 128.730000-0.076814 }, // 초기 중심 좌표
	                zoom: 13, // 초기 줌 레벨
	                mapTypeControlOptions: {
	                    mapTypeIds: ['roadmap', 'satellite', 'hybrid', 'terrain', 'styled_map']
	                },
	                mapTypeId: "roadmap", // 지도 유형 설정
	            });

	            // 기본 맵 스타일 적용
	            this.map.mapTypes.set('styled_map', styledMapType);
	            this.map.setMapTypeId('roadmap');

	            // Polyline 경로 설정 (예시 데이터)
	            const flightPlanCoordinates = [
	            	{ lat: 34.500000, lng: 128.730000 },
	                { lat: 34.503015, lng: 128.722764 },
	                { lat: 34.508543, lng: 128.717588 },
	                { lat: 34.514070, lng: 128.712412 },
	                { lat: 34.519598, lng: 128.707236 },
	                { lat: 34.525126, lng: 128.702060 },
	                { lat: 34.530653, lng: 128.702060 },
	                { lat: 34.536181, lng: 128.702060 },
	                { lat: 34.541709, lng: 128.702060 },
	                { lat: 34.547236, lng: 128.702060 },
	                { lat: 34.552764, lng: 128.702060 },
	                { lat: 34.558291, lng: 128.702060 },
	                { lat: 34.563819, lng: 128.702060 },
	                { lat: 34.569347, lng: 128.702060 },
	                { lat: 34.574874, lng: 128.702060 },
	                { lat: 34.580402, lng: 128.702060 },
	                { lat: 34.585930, lng: 128.702060 },
	                { lat: 34.591457, lng: 128.702060 },
	                { lat: 34.596985, lng: 128.702060 },
	                { lat: 34.602513, lng: 128.702060 },
	                { lat: 34.607985, lng: 128.710016 },
	                { lat: 34.614002, lng: 128.716287 },
	                { lat: 34.620020, lng: 128.722558 },
	                { lat: 34.626037, lng: 128.728829 },
	                { lat: 34.632055, lng: 128.735100 },
	                { lat: 34.638072, lng: 128.741371 },
	                { lat: 34.644090, lng: 128.747642 },
	                { lat: 34.650107, lng: 128.753913 },
	                { lat: 34.656125, lng: 128.760184 },
	                { lat: 34.662142, lng: 128.766455 },
	                { lat: 34.668160, lng: 128.772726 },
	                { lat: 34.674177, lng: 128.778997 },
	                { lat: 34.680195, lng: 128.785268 },
	                { lat: 34.686212, lng: 128.791539 },
	                { lat: 34.692230, lng: 128.797810 },
	                { lat: 34.698248, lng: 128.804081 },
	                { lat: 34.704265, lng: 128.810353 },
	                { lat: 34.710283, lng: 128.816624 },
	                { lat: 34.716300, lng: 128.822895 },
	                { lat: 34.722318, lng: 128.829166 },
	                { lat: 34.728335, lng: 128.835437 },
	                { lat: 34.734353, lng: 128.841708 },
	                { lat: 34.740370, lng: 128.847979 },
	                { lat: 34.746388, lng: 128.854250 },
	                { lat: 34.752405, lng: 128.860521 },
	                { lat: 34.758423, lng: 128.866792 },
	                { lat: 34.764440, lng: 128.873063 },
	                { lat: 34.770458, lng: 128.879334 },
	                { lat: 34.776475, lng: 128.885605 },
	                { lat: 34.782493, lng: 128.891876 },
	                { lat: 34.788510, lng: 128.898147 },
	                { lat: 34.794528, lng: 128.904418 },
	                { lat: 34.800545, lng: 128.910689 },
	                { lat: 34.800545, lng: 128.916960 },
	                { lat: 34.800545, lng: 128.923231 },
	                { lat: 34.800545, lng: 128.929503 },
	                { lat: 34.800545, lng: 128.935774 },
	                { lat: 34.800545, lng: 128.942045 },
	                { lat: 34.800545, lng: 128.948316 },
	                { lat: 34.806984, lng: 128.942596 },
	                { lat: 34.814117, lng: 128.937328 },
	                { lat: 34.821250, lng: 128.932060 },
	                { lat: 34.828383, lng: 128.926792 },
	                { lat: 34.835516, lng: 128.921524 },
	                { lat: 34.842649, lng: 128.916256 },
	                { lat: 34.849782, lng: 128.910988 },
	                { lat: 34.856915, lng: 128.905720 },
	                { lat: 34.864048, lng: 128.900452 },
	                { lat: 34.871180, lng: 128.895184 },
	                { lat: 34.878313, lng: 128.889916 },
	                { lat: 34.885446, lng: 128.884648 },
	                { lat: 34.892579, lng: 128.879381 },
	                { lat: 34.899712, lng: 128.874113 },
	                { lat: 34.906845, lng: 128.879381 },
	                { lat: 34.913978, lng: 128.884648 },
	                { lat: 34.921111, lng: 128.889916 },
	                { lat: 34.928244, lng: 128.895184 },
	                { lat: 34.935377, lng: 128.900452 },
	                { lat: 34.942510, lng: 128.900452 },
	                { lat: 34.949643, lng: 128.900452 },
	                { lat: 34.956776, lng: 128.900452 },
	                { lat: 34.963909, lng: 128.900452 },
	                { lat: 34.971042, lng: 128.900452 },
	                { lat: 34.978175, lng: 128.900452 },
	                { lat: 34.985307, lng: 128.900452 },
	                { lat: 34.992440, lng: 128.900452 },
	                { lat: 34.999573, lng: 128.900452 },
	                { lat: 35.006706, lng: 128.900452 },
	                { lat: 35.013839, lng: 128.900452 },
	                { lat: 35.020972, lng: 128.900452 },
	                { lat: 35.028105, lng: 128.900452 },
	                { lat: 35.035238, lng: 128.900452 },
	                { lat: 35.042371, lng: 128.900452 },
	                { lat: 35.049504, lng: 128.900452 },
	                { lat: 35.056637, lng: 128.900452 },
	                { lat: 35.063770, lng: 128.900452 },
	                { lat: 35.070903, lng: 128.900452 },
	                { lat: 35.078036, lng: 128.900452 },
	                { lat: 35.085169, lng: 128.900452 },
	                { lat: 35.092302, lng: 128.900452 },
	                { lat: 35.099434, lng: 128.900452 },
	                { lat: 35.106567, lng: 128.900452 },
	                { lat: 35.113700, lng: 128.900452 },
	                { lat: 35.120833, lng: 128.900452 },
	                { lat: 35.127966, lng: 128.900452 },
	                { lat: 35.135099, lng: 128.900452 },
	                { lat: 35.142232, lng: 128.900452 },
	                { lat: 35.149365, lng: 128.900452 },
	                { lat: 35.156498, lng: 128.900452 },
	                { lat: 35.163631, lng: 128.900452 },
	                { lat: 35.170764, lng: 128.900452 },
	                { lat: 35.177897, lng: 128.900452 }
	            ];

	            // Polyline 생성 및 지도에 추가
	            const flightPath = new google.maps.Polyline({
	                path: flightPlanCoordinates,
	                geodesic: true,
	                strokeColor: "#FF0000",
	                strokeOpacity: 1.0,
	                strokeWeight: 3,
	            });
	            flightPath.setMap(this.map);

	            toggleDarkMode(false); // 다크 모드 적용
	        },
	        async updateLocation() {
	            // 위치 업데이트를 위한 함수
	            const updatePosition = () => {
	                // Geolocation API를 사용하여 현재 위치 가져오기
	                navigator.geolocation.getCurrentPosition(async (position) => {
	                    const { latitude, longitude } = position.coords; // 위도, 경도 추출
	                    console.log(`위도: ${latitude}, 경도: ${longitude}`);

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
	                        console.log(data);
	                    } catch (error) {
	                        console.error('Error fetching location info:', error);
	                    }
	                }, (error) => {
	                    console.error('Geolocation error:', error); // 오류 처리
	                });
	            };

	            // 위치 업데이트 간격 설정
	            setInterval(updatePosition, 10000); // 10초 간격
	        },
	        initSpeedControls() {
	            // 속도 조절 기능 초기화
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
	        showInfo(title, content) {
	            // 정보 패널 표시
	            const infoPanel = document.getElementById('infoPanel');
	            const infoTitle = document.getElementById('infoTitle');
	            const infoContent = document.getElementById('infoContent');

	            infoTitle.textContent = title; // 패널 제목 설정
	            infoContent.textContent = content; // 패널 내용 설정
	            infoPanel.classList.add('active'); // 패널 표시
	        }, closeInfoPanel() {
	            // 정보 패널 숨김
	            const infoPanel = document.getElementById('infoPanel');
	            infoPanel.classList.remove('active'); // 패널 숨김
	        }, closeVideoModal(){
	        	
	        	var videoModal = document.getElementById("videoModal");
	        	videoModal.style.display = "none";
	        }, endSail() { // 항해 종료 함수 endSail() 실행
	   		 
	            fetch('/sail/endSail', {
	                method: 'GET'
	            })
	            .then(response => {
	                if (response.ok) {
	                    console.log("Weather toggled successfully.");
	                } else {
	                	 return response.text().then(text => { 
	                         console.error("Failed to toggle weather: ", response.status, text); 
	                     });
	                }
	            })
	            .catch(error => {
	                console.error('Error:', error);
	            });
	        }, toggleModal() { // 비디오 모달 열기
                var modal = document.getElementById("videoModal");
                var mapDiv = document.getElementById("map");

                if (modal.style.display === "none" || modal.style.display === "") {
                    var mapHeight = mapDiv.offsetHeight;
                    var mapWidth = mapDiv.offsetWidth;

                    // 모달 크기 설정
                    modal.style.height = (mapHeight * 0.6) + "px";
                    modal.style.width = (mapWidth * 0.4) + "px";
                    
                	// 모달 위치 중앙에 설정
                    modal.style.top = (mapHeight * 0.3) + "px";
                	modal.style.left = (mapWidth * 0.075) + "px";


                    modal.style.display = "block"; // 모달 표시
                } else {
                    modal.style.display = "none";
                }
            }
	    }
	});
	
	// 다크 모드 전환 함수
	function toggleDarkMode(isDarkMode) {
	    const body = document.body;
	    if (isDarkMode) {
	        body.classList.add('dark-mode');
	    } else {
	        body.classList.remove('dark-mode');
	    }
	}

    </script>

</body>
</html>
