<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<title>Vue.js with Google Maps</title>
<script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
<!-- Google Maps API - Spring에서 전달된 API 키 사용 -->
<script
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDtt1tmfQ-lTeQaCimRBn2PQPTlCLRO6Pg"></script>
<style>

/* 지도 및 버튼 스타일 */
#map {
	width: 100%; /* 너비를 100%로 설정 */
	height: 900px; /* 높이를 800px로 늘림 */
}

.map-button {
	position: absolute;
	top: 20px;
	left: 200px;
	z-index: 1; /* 지도 위에 버튼이 표시되도록 z-index 설정 */
	background-color: white;
	border: 2px solid #007bff;
	padding: 10px;
	cursor: pointer;
}
/* 아이콘 패널 스타일 */
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
	z-index: 1; /* 지도 위에 표시되도록 설정 */
}

.icon {
	width: 50px; /* 아이콘의 너비를 증가 */
	height: 50px; /* 아이콘의 높이를 증가 */
	background-color: rgba(255, 255, 255, 0.1);
	border-radius: 10px;
	display: flex;
	justify-content: center;
	align-items: center;
	cursor: pointer;
	transition: background-color 0.3s ease, transform 0.3s ease;
	font-size: 27px; /* 아이콘 자체의 크기를 키움 */
}

.icon:hover {
	background-color: rgba(255, 255, 255, 0.3);
	transform: scale(1.1);
}
/* 정보 패널 스타일 */
.info-panel {
	position: absolute;
	top: 100px;
	right: 70px; /* 아이콘 옆에 표시되도록 */
	background-color: rgba(0, 0, 0, 0.9);
	border-radius: 10px;
	padding: 20px;
	width: 250px;
	color: white;
	display: none; /* 기본적으로 숨김 */
	z-index: 2;
}

.info-panel.active {
	display: block; /* 아이콘 클릭 시 나타나도록 설정 */
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
/* 닫기 버튼 */
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

/* stop 아이콘의 스타일 정의 */
.stop-icon {
	width: 150px; /* 이미지 너비 */
	height: 150px; /* 이미지 높이 */
	display: block; /* 이미지가 독립적인 블록으로 표시되도록 */
	margin: 0 auto; /* 이미지 가운데 정렬 */
	border-radius: 5px; /* 모서리를 둥글게 */
	/* 추가된 위치 조정 속성 */
	position: relative; /* 현재 위치 기준으로 이동 */
	top: 10px; /* 밑으로 10px 이동 */
	bottom: 20px;
	left: 270px; /* 오른쪽으로 10px 이동 */
}

.control-panel {
	display: flex;
	justify-content: center;
	align-items: center;
	margin-top: 50px;
}

.arrow-buttons {
	display: flex;
	flex-direction: column;
	align-items: center;
}

.arrow-buttons img {
	width: 50px;
	height: 50px;
	margin: 5px;
	cursor: pointer;
}

.stop-btn {
	background-color: red;
	color: white;
	padding: 10px 30px;
	border-radius: 50%;
	font-size: 18px;
	border: none;
	cursor: pointer;
}
</style>
</head>
<body>
	<div id="app">
		<!-- 지도 영역 -->
		<div id="map"></div>

		<!-- 아이콘 패널 -->
		<div class="icon-panel">
			<!-- 날씨 아이콘 -->
			<div class="icon" @click="showInfo('날씨', '12 kn, SW(241°), 23°C')">🌤️</div>

			<!-- 온도 아이콘 -->
			<div class="icon" @click="showInfo('온도', '24°C 입니다')">🌡️</div>

			<!-- 배터리 아이콘 -->
			<div class="icon" @click="showInfo('배터리', '배터리 잔량 80%')">🔋</div>

			<!-- 통신 아이콘 -->
			<div class="icon" @click="showInfo('통신 상태', '통신 상태 양호')">📶</div>

			<!-- 속도 아이콘 -->
			<div class="icon" @click="showInfo('속도', '30 노트 속도')">🚤</div>

			<!-- 남은 시간 아이콘 -->
			<div class="icon" @click="showInfo('남은 시간', '남은 시간 2시간')">⏱️</div>

			<!-- 남은 거리 아이콘 -->
			<div class="icon" @click="showInfo('남은 거리', '남은 거리 10km')">🛣️</div>
		</div>

		<!-- 정보 패널 -->
		<div class="info-panel" id="infoPanel">
			<button class="close-btn" @click="closeInfoPanel">✖</button>
			<h3 id="infoTitle">정보</h3>
			<p id="infoContent">상세 내용</p>
		</div>
	</div>

	<!-- 이미지 태그에 클래스 적용 -->
	<div class="control-panel">
		<div class="arrow-buttons">
			<img src="<%=request.getContextPath()%>/resources/img/left.png"
				alt="left" class="arrow-icon"> <img
				src="<%=request.getContextPath()%>/resources/img/top.png"
				alt="top" class="arrow-icon"> <img
				src="<%=request.getContextPath()%>/resources/img/right.png"
				alt="right" class="arrow-icon">
		</div>

	</div>
	
	<img class="stop-icon"
		src="<%=request.getContextPath()%>/resources/img/stop.png"
		alt="멈추기 아이콘" width="40" height="40">

	<script>
	new Vue({
        el: '#app',
        data() {
            return {
                map: null,
                marker: null,
            };
        },
        mounted() {
            this.initMap();
            this.updateLocation();
        },
        methods: {
            initMap() {
                this.map = new google.maps.Map(document.getElementById('map'), {
                    center: { lat: 37.5665, lng: 126.9780 },  // 서울 좌표
                    zoom: 15
                });
            },
            async updateLocation() {
                const updatePosition = () => {
                    navigator.geolocation.getCurrentPosition(async (position) => {
                        const { latitude, longitude } = position.coords;
                        console.log(`위도: ${latitude}, 경도: ${longitude}`);
                        
                        // Google Maps에 마커 표시
                        if (!this.marker) {
                            this.marker = new google.maps.Marker({
                                position: { lat: latitude, lng: longitude },
                                map: this.map,
                                icon: {
                                	url: '<%=request.getContextPath()%>/resources/img/icon.png',
                                	scaledSize: new google.maps.Size(100, 100)
                                }
                            });
                            
                            // 마커의 위치로 지도의 중심 이동
                            this.map.setCenter({ lat: latitude, lng: longitude });
                            
                        } else {
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
                        console.error('Geolocation error:', error);
                    });
                };

                // 2초 간격으로 위치 갱신
                setInterval(updatePosition, 2000);
            },
            
            showInfo(title, content) {
                const infoPanel = document.getElementById('infoPanel');
                const infoTitle = document.getElementById('infoTitle');
                const infoContent = document.getElementById('infoContent');
                
                infoTitle.textContent = title;
                infoContent.textContent = content;
                infoPanel.classList.add('active');  // 패널 표시
            },
            closeInfoPanel() {
                const infoPanel = document.getElementById('infoPanel');
                infoPanel.classList.remove('active');  // 패널 숨김
            }
        }
    });
    </script>
</body>
</html>