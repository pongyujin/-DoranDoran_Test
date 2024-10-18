<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
    <title>Vue.js with Google Maps</title>
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>
    <!-- Google Maps API - Spring에서 전달된 API 키 사용 -->
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDtt1tmfQ-lTeQaCimRBn2PQPTlCLRO6Pg"></script>
    <style>

    /* 지도 및 버튼 스타일 */
    #map {
        width: 100%; /* 너비를 100%로 설정 */
        height: 900px; /* 높이를 900px로 설정 */
        z-index: 1; /* 지도는 뒤로 배치 */
    }
    body {
        background: linear-gradient(90deg, #1A2529 12%, #1C2933 29%, #17293A 46%, #313F49 100%);
        margin: 0;
        padding: 0;
        position: relative; /* 지도를 기준으로 속도 조절 위치 조정 */
    }

    /* 투명한 배경 박스 스타일 (위쪽으로 위치 조정) */
    .info-overlay {
        position: absolute;
        bottom:370px;
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
        color: black !important;
 /* 기본 모드에서는 검은색 */
        z-index: 1000;
        padding: 10px;
        border-radius: 5px;
    }

    .dark-mode .speed-display {
        color: white !important;
    }

    </style>
</head>
<body>
    <div id="app">
        <div id="map"></div>
        <div id="speedDisplay" class="speed-display">0</div>

        <div class="speed-control-wrapper">
            <div class="speed-control">
                <label for="speedRange1">속도</label>
                <input type="range" id="speedRange1" min="0" max="40" value="0">
                <span id="speedDisplay1">0</span> KM
            </div>
            <div class="speed-control">
                <button id="setSpeedBtn">속도 조절</button>
            </div>
        </div>

        <div class="control-panel">
            <div class="arrow-buttons">
                <img src="<%=request.getContextPath()%>/resources/img/left.png"
                    alt="left" class="left-btn"> 
                <img src="<%=request.getContextPath()%>/resources/img/top.png"
                    alt="up" class="up-btn"> 
                <img src="<%=request.getContextPath()%>/resources/img/right.png"
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
        </div>
        
        <div class="info-overlay">
            <div class="time-distance">
                <span id="remainingTime">9분</span>
                <span id="remainingDistance">4.1km</span>
            </div>

            <button class="destination-btn" @click="setDestinationMode">목적지 설정</button>
        </div>

        <div class="info-panel" id="infoPanel">
            <button class="close-btn" @click="closeInfoPanel">✖</button>
            <h3 id="infoTitle">정보</h3>
            <p id="infoContent">상세 내용</p>
        </div>
    </div>

    <script>
        new Vue({
            el: '#app',
            mounted() {
                this.initMap();
            },
            methods: {
                initMap() {
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

                    var map = new google.maps.Map(document.getElementById('map'), {
                        center: { lat: 37.5665, lng: 126.9780 }, // 서울 좌표
                        zoom: 10,
                        mapTypeControlOptions: {
                            mapTypeIds: ['roadmap', 'satellite', 'hybrid', 'terrain', 'styled_map']
                        }
                    });

                    map.mapTypes.set('styled_map', styledMapType);
                    map.setMapTypeId('styled_map'); // 다크 모드로 설정

                    toggleDarkMode(true); // 다크 모드 적용
                },
                setDestination() {
                    alert('목적지를 설정합니다.');
                },
                showInfo(title, content) {
                    const infoPanel = document.getElementById('infoPanel');
                    const infoTitle = document.getElementById('infoTitle');
                    const infoContent = document.getElementById('infoContent');
                    
                    infoTitle.textContent = title;
                    infoContent.textContent = content;
                    infoPanel.classList.add('active');
                },
                closeInfoPanel() {
                    const infoPanel = document.getElementById('infoPanel');
                    infoPanel.classList.remove('active');
                }
            }
        });

        document.getElementById('speedRange1').addEventListener('input', function() {
            document.getElementById('speedDisplay1').textContent = this.value;
        });

        document.getElementById('setSpeedBtn').addEventListener('click', function() {
            var currentSpeed = document.getElementById('speedRange1').value;
            alert(currentSpeed + 'km로 속도를 설정합니다.');
        });

        document.getElementById('speedRange1').addEventListener('input', function() {
            var speedValue = this.value;
            document.getElementById('speedDisplay').textContent = speedValue;
            document.getElementById('speedDisplay1').textContent = speedValue;
        });

        function toggleDarkMode(isDarkMode) {
            const body = document.body;
            if (isDarkMode) {
                body.classList.add('dark-mode');
            } else {
                body.classList.remove('dark-mode');
            }
        }

        toggleDarkMode(true); // 다크 모드 활성화
    </script>
    
</body>
</html>
