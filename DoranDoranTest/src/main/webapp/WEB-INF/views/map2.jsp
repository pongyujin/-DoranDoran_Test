<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<title>map2</title>
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
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;800&display=swap" rel="stylesheet">
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
	font-family: 'Manrope', sans-serif; /* 기본 폰트 설정 */
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
	cursor: grab;
}

.videoModal:active {
	cursor: grabbing;
}

/* 비디오 스타일 */
.videoModal img {
	color: white;
}

.videoModal h3 {
	font-size: 18px;
	margin: 10px 0px 10px;
	text-align: center;
}

.video-close-btn {
	z-index: 3;
	position: absolute;
	top: 20px;
	right: 30px;
	cursor: pointer;
	font-size: 20px;
	color: black;
	background-color: transparent;
	border: none;
}
</style>
</head>
<body>
	<div id="app">
	
		<div id="map"></div>
		
		<div id="videoModal"
			class="videoModal w-[80%] max-w-screen-md rounded-3xl bg-neutral-50 text-center antialiased px-5 md:px-20 py-10 shadow-2xl shadow-zinc-900 relative top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
			style="padding:10px 30px;">

			<h3 class="text-2xl lg:text-3xl font-bold text-neutral-900 my-4">
				Camera view</h3>

			<button class="video-close-btn" @click="closeVideoModal">✖</button>
			<img id="cameraVideo" src="http://192.168.219.47:8080/video_feed"
				alt="Video Feed" />

			<button type="button" id="reset" disabled
				class="px-8 py-4 mt-8 rounded-2xl text-neutral-50 bg-violet-800 hover:bg-violet-600 active:bg-violet-900 disabled:bg-neutral-900 disabled:cursor-not-allowed transition-colors"
				style="margin: 16px 0px 0px">
				Reset the position</button>

			<svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg"
				class="w-[16px] h-[16px] absolute right-6 top-6">
					<path d="m2 2 12 12m0-12-12 12" class="stroke-2 stroke-current" /></svg>
		</div>
		
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

		<div class="info-overlay">
			<div class="time-distance">
				<span id="remainingTime">9분</span> <span id="remainingDistance">4.1km</span>
			</div>

			<button class="destination-btn" @click="endSail">항해 완료</button>
		</div>

		<div class="info-panel" id="infoPanel">
			<button class="close-btn" @click="closeInfoPanel">✖</button>
			<h3 id="infoTitle">정보</h3>
			<p id="infoContent">상세 내용</p>
		</div>
		
	</div>
	
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
	            flightPlanCoordinates: [] // Polyline 데이터를 저장할 곳
	        };
	    },
	    mounted() {
	        this.loadPoly(); // 경로 데이터 받아오기
	        this.updateLocation(); // 위치 업데이트 시작
	        this.initSpeedControls(); // 속도 조절 컨트롤 초기화
	        this.toggleModal(); // 실시간 비디오 모달 켜기
	        this.initDraggable(); // 모달 드래그 기능 초기화
	    },
	    methods: {
	    	loadPoly() { // 1. 경로 데이터 받아오기(GoogleMapController)
	            axios.get("http://localhost:8085/controller/flightPlanCoordinates")
	            .then(response => {
	              console.log(JSON.stringify(response.data, null, 2)); // JSON 형식으로 출력
	              this.flightPlanCoordinates = response.data;  // 데이터를 Vue 데이터 속성에 할당
	              this.initMap();
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

	            // 위치 업데이트 간격 설정(100초 간격)
	            setInterval(updatePosition, 100000);
	        },
	        initSpeedControls() { // 4. 속도 조절 함수
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
	        showInfo(title, content) { // 5. 정보 패널 표시 함수

	            const infoPanel = document.getElementById('infoPanel');
	            const infoTitle = document.getElementById('infoTitle');
	            const infoContent = document.getElementById('infoContent');

	            infoTitle.textContent = title; // 패널 제목 설정
	            infoContent.textContent = content; // 패널 내용 설정
	            infoPanel.classList.add('active'); // 패널 표시
	            
	        }, closeInfoPanel() { // 6. 정보 패널 숨김 함수

	            const infoPanel = document.getElementById('infoPanel');
	            infoPanel.classList.remove('active'); // 패널 숨김
	            
	        }, endSail() { // 7. 항해 종료 함수
	        	axios.get("http://localhost:8085/controller/sail/endSail")
	            .then(response => {
	            	console.log("Sail toggled successfully.");
	            })
	            .catch(error => {
	                console.error('Error endSail:', error);
	            });
	        
	        }, closeVideoModal(){ // 8. 실시간 카메라 모달 끄기 함수
	        	
	        	var videoModal = document.getElementById("videoModal");
	        	videoModal.style.display = "none";
	        }, toggleModal() {
	            var modal = document.getElementById("videoModal");
	            var mapDiv = document.getElementById("map");

	            if (modal.style.display === "none" || modal.style.display === "") {
	                var mapHeight = mapDiv.offsetHeight;
	                var mapWidth = mapDiv.offsetWidth;
	                
	                var modalWidth = mapWidth * 0.35;
	                var modalHeight = modalWidth * 0.946;
	                console.log(modalHeight, modalWidth);

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
	        initDraggable() { // 9. 실시간 카메라 모달 드래그 함수
	            const modal = document.getElementById('videoModal');
	            const wrapper = document.getElementById('map');
	            const reset = document.getElementById('reset');
	            const page = document.getElementById('app');

	            const resetModalPosition = () => {
	            	
	            	const wrapperRect = wrapper.getBoundingClientRect();
	                const pageRect = page.getBoundingClientRect();
	            	
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
	        }
	    }
	});
	
    </script>
 
</body>
</html>
