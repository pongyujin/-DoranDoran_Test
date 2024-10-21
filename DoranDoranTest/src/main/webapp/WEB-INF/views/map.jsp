<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<title>map</title>
<script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
<!-- Google Maps API - Spring에서 전달된 API 키 사용 -->
<script
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDtt1tmfQ-lTeQaCimRBn2PQPTlCLRO6Pg"></script>
<style>
/* 기본 스타일 */
body {
	background: linear-gradient(90deg, #1A2529 12%, #1C2933 29%, #17293A 46%, #313F49
		100%);
	margin: 0;
	padding: 0;
	position: relative; /* 지도를 기준으로 속도 조절 위치 조정 */
}

/* 지도 및 버튼 스타일 */
#map {
	width: 100%; /* 너비를 100%로 설정 */
	height: 100vh; /* 높이를 화면 전체로 설정 */
	z-index: 1; /* 지도는 뒤로 배치 */
}

/* 투명한 배경 박스 스타일 */
.info-overlay {
	position: absolute;
	bottom: 20%; /* 화면 크기에 따라 위치 조정 */
	left: 50%;
	transform: translateX(-50%);
	background-color: rgba(255, 255, 255, 0.8);
	padding: 10px 20px;
	width: 90%; /* 폭을 90%로 조정 */
	max-width: 500px; /* 최대 너비를 설정 */
	border-radius: 10px;
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 10;
}

/* 시간 및 거리 표시 스타일 */
.time-distance {
	font-size: 20px;
	font-weight: bold;
	color: #000;
	display: flex;
	justify-content: space-between;
	width: 100%; /* 폭을 100%로 조정 */
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
	position: fixed;
	right: 20px; /* 오른쪽 위치 조정 */
	bottom: 20px; /* 바텀은 20px로 조정 */
	z-index: 9999;
	box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.3);
}

.destination-btn:hover {
	background-color: #17293A;
}

/* 컨트롤 패널 스타일 */
.control-panel {
	position: relative;
	width: 100%;
	height: 200px; /* 패널의 높이 */
	margin-top: 50px;
	display: flex;
	justify-content: center;
	align-items: center;
	flex-direction: column;
}

/* 화살표 버튼 스타일 */
.arrow-buttons {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 20px; /* 버튼 간격 설정 */
}

/* 상향 버튼 */
.up-btn, .left-btn, .right-btn {
	width: 80px; /* 버튼 너비 */
	height: 80px; /* 버튼 높이 */
}

/* STOP 아이콘 */
.stop-icon {
	width: 100px; /* STOP 아이콘 너비 */
	height: 100px; /* STOP 아이콘 높이 */
}

/* 속도 조절 컨트롤 스타일 */
.speed-control-wrapper {
	position: absolute;
	bottom: 120px;
	left: 50%; /* 중앙으로 이동 */
	transform: translateX(-50%);
	display: flex;
	flex-direction: column;
	gap: 10px;
	z-index: 1000;
	padding: 10px;
}

/* 속도 조절 컨트롤 스타일 */
.speed-control {
	display: flex;
	align-items: center;
	justify-content: center;
	background-color: #1A2529;
	padding: 10px;
	border-radius: 10px;
	width: 90%; /* 폭을 90%로 조정 */
	max-width: 300px; /* 최대 너비 설정 */
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

/* 아이콘 패널 스타일 */
.icon-panel {
	position: absolute;
	top: 10%; /* 상단으로 위치 조정 */
	right: 10px;
	background-color: rgba(0, 0, 0, 0.7);
	border-radius: 10px;
	padding: 15px;
	display: flex;
	flex-direction: column;
	gap: 10px;
	z-index: 1;
}

/* 아이콘 스타일 */
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

/* 정보 패널 스타일 */
.info-panel {
	position: absolute;
	top: 10%; /* 상단으로 위치 조정 */
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

/* 닫기 버튼 스타일 */
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

/* 속도 표시 스타일 */
.speed-display {
	font-size: 50px;
	font-weight: bold;
	position: absolute;
	top: 15%; /* 화면의 위쪽에서 15% */
	left: 50%; /* 중앙으로 이동 */
	transform: translateX(-50%);
	color: black; /* 기본 모드에서는 검은색 */
	z-index: 1000;
	padding: 10px;
	border-radius: 5px;
}

.dark-mode .speed-display {
	color: white;
}

/* 미디어 쿼리 */
@media ( max-width : 768px) {
	.info-overlay {
		width: 95%; /* 작은 화면에서는 폭을 더 넓게 설정 */
		bottom: 15%; /* 위치 조정 */
	}
	.destination-btn {
		right: 15px; /* 버튼 위치 조정 */
		bottom: 15px; /* 버튼 위치 조정 */
	}
	.control-panel {
		height: 150px; /* 패널 높이 조정 */
	}
	.speed-control {
		flex-direction: column; /* 세로 방향으로 변경 */
		width: 100%; /* 폭을 100%로 조정 */
	}
	.speed-display {
		font-size: 40px; /* 속도 표시 크기 조정 */
	}
}

@media ( max-width : 480px) {
	.time-distance {
		font-size: 16px; /* 시간 거리 표시 크기 조정 */
	}
	.up-btn, .left-btn, .right-btn, .stop-icon {
		width: 60px; /* 버튼 크기 조정 */
		height: 60px; /* 버튼 크기 조정 */
	}
	.speed-control input[type="range"] {
		width: 100px; /* 슬라이더 크기 조정 */
	}
	.speed-display {
		font-size: 30px; /* 속도 표시 크기 조정 */
	}
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
			<div class="icon"
				@click="showInfo('현재 위치', '위도: 37.5665, 경도: 126.9780')">📍</div>
			<div class="icon" @click="showInfo('방위', '북쪽 방향')">🧭</div>
			<div class="icon" @click="showInfo('주변 장애물 탐지', '장애물 없음')">🚧</div>
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
	
	<div class="container">
		<form action="sail/insert" method="post">
			<table class="table table-bordered"
				style="text-align: center; border: 1px solid #dddddd;">
				<tr>
					<td style="vertical-align: middle; width: 110px;">선박 코드</td>
					<td><input type="text" name="siCode" id="siCode"
						placeholder="선박 코드를 입력해주세요" class="form-control"></td>
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
					<td colspan="2"><input type="submit"
						class="btn btn-danger btn-sm pull-right" value="항해 시작"> <input
						type="reset" class="btn btn-warning btn-sm pull-right"
						value="새로고침"></td>
				</tr>
			</table>
		</form>
		<form id="weatherForm" action="weather" method="post">
			<table class="table table-bordered"
				style="text-align: center; border: 1px solid #dddddd;">
				<tr>
					<td style="vertical-align: middle; width: 110px;">선박 코드</td>
					<td><input type="text" name="siCode" id="siCode"
						placeholder="선박 코드를 입력해주세요" class="form-control"></td>
				</tr>
				<tr>
					<td style="vertical-align: middle; width: 110px;">항해 번호</td>
					<td><input type="number" name="sailNum" id="sailNum"
						placeholder="항해번호 입력해주세요" class="form-control"></td>
				</tr>
				<tr>
					<td colspan="2"><input type="submit"
						class="btn btn-danger btn-sm pull-right" value="기상데이터"> <input
						type="reset" class="btn btn-warning btn-sm pull-right"
						value="새로고침"></td>
				</tr>
			</table>
		</form>
		<div id="responseMessage" style="text-align: center; margin-top: 20px;"></div>

	</div>

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
	                center: { lat: 34.500000, lng: 128.730000 }, // 초기 중심 좌표
	                zoom: 13, // 초기 줌 레벨
	                mapTypeControlOptions: {
	                    mapTypeIds: ['roadmap', 'satellite', 'hybrid', 'terrain', 'styled_map']
	                },
	                mapTypeId: "terrain", // 지도 유형 설정
	            });

	            // 다크 모드 맵 적용
	            this.map.mapTypes.set('styled_map', styledMapType);
	            this.map.setMapTypeId('styled_map'); // 다크 모드로 설정

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

	            toggleDarkMode(true); // 다크 모드 적용
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
	        },
	        closeInfoPanel() {
	            // 정보 패널 숨김
	            const infoPanel = document.getElementById('infoPanel');
	            infoPanel.classList.remove('active'); // 패널 숨김
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

	toggleDarkMode(false); // 다크 모드 활성화
	
	$(document).ready(function() {
	    $('#weatherForm').on('submit', function(event) {
	        event.preventDefault(); // 기본 폼 제출 방지

	        // 폼 데이터 수집
	        var formData = {
	            siCode: $('#siCode').val(),
	            sailNum: $('#sailNum').val()
	        };

	        alert('Sending data:', JSON.stringify(formData));
	        console.log('Sending data:', JSON.stringify(formData));

	        // AJAX 요청
	        $.ajax({
	            type: 'POST',
	            url: $(this).attr('action'), // action 속성에서 URL 가져오기
	            contentType: 'application/json', // JSON 형식으로 전송
	            data: formData, // JSON 문자열로 변환
	            success: function(response) {
	                $('#responseMessage').html('<p>기상 데이터가 성공적으로 저장되었습니다.</p>');
	            },
	            error: function(xhr, status, error) {
	                $('#responseMessage').html('<p>오류 발생: ' + error + '</p>');
	            }
	        });
	    });
	});

    </script>

</body>
</html>
