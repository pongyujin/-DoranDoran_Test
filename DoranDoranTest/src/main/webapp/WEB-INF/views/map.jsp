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
				src="<%=request.getContextPath()%>/resources/img/top.png" alt="top"
				class="arrow-icon"> <img
				src="<%=request.getContextPath()%>/resources/img/right.png"
				alt="right" class="arrow-icon">
		</div>

	</div>

	<img class="stop-icon"
		src="<%=request.getContextPath()%>/resources/img/stop.png"
		alt="멈추기 아이콘" width="40" height="40">

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
		<form action="weather" method="post">
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
	    },
	    methods: {
	        initMap() {
	            // Google Maps 초기화
	            this.map = new google.maps.Map(document.getElementById('map'), {
	                center: { lat: 34.500000, lng: 128.730000 }, // 초기 중심 좌표 (서울)
	                zoom: 13, // 초기 줌 레벨
	                mapTypeId: "terrain", // 지도 유형 설정
	            });

	            // 경로 좌표 리스트 (예시 데이터)
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


	            // Polyline 객체 생성
	            const flightPath = new google.maps.Polyline({
	                path: flightPlanCoordinates, // Polyline에 사용할 좌표 경로
	                geodesic: true, // 곡선을 그리기 위해 지구 곡선 사용
	                strokeColor: "#FF0000", // 선 색상
	                strokeOpacity: 1.0, // 선 투명도
	                strokeWeight: 3, // 선 두께
	            });

	            // 생성한 Polyline을 지도에 추가
	            flightPath.setMap(this.map);
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

	            // 2초 간격으로 위치 갱신
	            setInterval(updatePosition, 10000000000);
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

	</script>
</body>
</html>