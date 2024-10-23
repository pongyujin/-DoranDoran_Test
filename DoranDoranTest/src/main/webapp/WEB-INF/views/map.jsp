<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>map</title>
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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/map.css">
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
			<div class="icon" @click="getInfo('날씨')">🌤️</div>
			<div class="icon" @click="getInfo('온도')">🌡️</div>
			<div class="icon" @click="getInfo('배터리')">🔋</div>
			<div class="icon" @click="getInfo('통신 상태')">📶</div>
			<div class="icon" @click="getInfo('속도')">🚤</div>
			<div class="icon" @click="getInfo('남은 시간')">⏱️</div>
			<div class="icon" @click="getInfo('남은 거리')">🛣️</div>
			<div class="icon" @click="getInfo('현재 위치')">📍</div>
			<div class="icon" @click="getInfo('방위')">🧭</div>
			<div class="icon" @click="getInfo('주변 장애물 탐지')">🚧</div>
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
			<div id="responseMessage"
				style="text-align: center; margin-top: 20px;"></div>

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
	            
	        }, endSail() { // 8. 항해 종료 함수
	        	
	        	axios.get("http://localhost:8085/controller/sail/endSail")
	        	.then(response => {
	                console.log("Sail ended successfully.", response.data);
	                // 페이지 이동
	                window.location.href = "http://localhost:8085/controller/main";
	            })
	            .catch(error => {
	                console.error('Error in endSail:', error.response ? error.response.data : error.message);
	            });
	        
	        }, closeVideoModal(){ // 9. 실시간 카메라 모달 끄기 함수
	        	
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
	        initDraggable() { // 10. 실시간 카메라 모달 드래그 함수
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
	        }
	    }
	});
	
    </script>
 
</body>
</html>
