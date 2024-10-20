<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ship Statistics with Vue.js</title>
<script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
<!-- Google Maps API, geometry 라이브러리 포함, callback 파라미터 추가 -->
<script async defer
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDtt1tmfQ-lTeQaCimRBn2PQPTlCLRO6Pg&libraries=geometry&callback=initMap"></script>
<!-- 차트를 그리는 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
#map-container {
	position: relative;
	width: 100%;
	height: 600px;
}

#map {
	height: 100%;
	width: 100%;
}

.distance-label {
	background-color: white;
	padding: 10px;
	border: 1px solid black;
	border-radius: 5px;
	position: absolute;
	bottom: 20px; /* 지도 오른쪽 하단으로 위치 변경 */
	right: 20px;
	z-index: 10; /* 지도보다 위에 표시되도록 높은 값 설정 */
	font-weight: bold;
	font-size: 16px;
}
</style>
</head>
<body>


	<div id="app">
		<div class="container">
			<h2>선박 통계 정보 및 경로</h2>
			<div class="panel panel-default">
				<div class="panel-heading">선박 통계 조회</div>
				<div class="panel-body">
					<label for="sailNum">sailNum를 입력하세요:</label> <input type="text"
						v-model="sailNum" class="form-control"> <label
						for="siCode">siCode를 입력하세요:</label> <input type="text"
						v-model="siCode" class="form-control">
					<button class="btn btn-primary" @click="loadShipStats">조회</button>
				</div>
			</div>
			
			
			<form id="uploadForm" method="post" enctype="multipart/form-data">
				<label for="fileInput">이미지를 업로드하세요:</label> <input type="file"
					id="fileInput" name="file" class="form-control">
				<button type="button" class="btn btn-primary" @click="uploadImage">업로드</button>
			</form>


			<!-- 차트를 표시할 캔버스 -->
			<canvas id="weatherChart" width="400" height="200"></canvas>

			<!-- 지도와 거리 라벨을 감싸는 div -->
			<div id="map-container">
				<div id="map"></div>
				<div v-if="totalDistanceKm" class="distance-label">총 경로 거리: {{
					totalDistanceKm }} km</div>
			</div>
		</div>
	</div>

	<script>
new Vue({
    el: '#app',
    data: {
        siCode: '',
        sailNum: '',
        totalDistanceKm: '',
        map: null,
        weatherList: [],
    },
    methods: {
        // Google Maps 초기화
        initMap() {
            this.map = new google.maps.Map(document.getElementById("map"), {
                center: { lat: 33.5097, lng: 126.5219 }, // 기본 위치: 제주도
                zoom: 7,
            });
        },
        // 경로 그리기 및 거리 계산
        drawRoute(routeData) {
            const routeCoordinates = [];
            let totalDistance = 0;

            // 경로 데이터를 처리
            for (let i = 0; i < routeData.length; i++) {
                const { gpsLat, gpsLng } = routeData[i];
                const position = { lat: gpsLat, lng: gpsLng };
                routeCoordinates.push(position);

                // 두 지점 사이의 거리 계산 (마지막 지점은 제외)
                if (i > 0) {
                    const prevPos = routeCoordinates[i - 1];
                    const distance = google.maps.geometry.spherical.computeDistanceBetween(
                        new google.maps.LatLng(prevPos.lat, prevPos.lng),
                        new google.maps.LatLng(gpsLat, gpsLng)
                    );
                    totalDistance += distance; // 거리를 더함
                }
            }

            // 경로 Polyline 생성
            const routePath = new google.maps.Polyline({
                path: routeCoordinates,
                geodesic: true,
                strokeColor: '#FF0000',
                strokeOpacity: 1.0,
                strokeWeight: 2
            });

            // 지도에 경로 추가
            routePath.setMap(this.map);

            // 전체 경로 거리 (킬로미터) 계산 및 거리 라벨 업데이트
            this.totalDistanceKm = (totalDistance / 1000).toFixed(2); // 미터를 킬로미터로 변환
        },
        // 선박 번호로 통계 조회 및 경로 그리기
        loadShipStats() {
            const sailNum = this.sailNum;
            const siCode = this.siCode;
            console.log("sailNum 입력된 선박 번호: " + sailNum);
            console.log("siCode 입력된 선박 코드: " + siCode);

            fetch('statistics/' + siCode + '/' + sailNum)
                .then(response => response.json())
                .then(data => {
                    // 경로 데이터: gpsList
                    const route = data.gpsList;
                    const weather = data.weatherList;
                    console.log("경로 데이터: ", route);
                    console.log("날씨 데이터: ", weather);

                    // 경로 그리기 및 거리 계산
                    this.drawRoute(route);

                    // 날씨 데이터 설정
                    this.weatherList = weather;
                    this.drawWeatherChart();
                })
                .catch(error => {
                    console.log("Error:", error);
                });
        },
        // 날씨와 배터리 상태 차트를 그리기 위한 메서드
        drawWeatherChart() {
            const ctx = document.getElementById('weatherChart').getContext('2d');
            
            // 데이터가 제대로 있는지 확인하기 위해 로그 추가
            console.log("weatherList 데이터:", this.weatherList);
            
            // 데이터 값들을 숫자형으로 변환 (필요한 경우)
            const labels = this.weatherList.map(item => item.wtime);
            const temps = this.weatherList.map(item => parseFloat(item.wtemp));
            const batteryLevels = this.weatherList.map(item => parseFloat(item.statBattery));

            
            console.log("시간 데이터:", labels);
            console.log("온도 데이터:", temps);
            console.log("배터리 데이터:", batteryLevels);

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: 'Temperature (°C)',
                            data: temps,
                            borderColor: 'rgba(255, 99, 132, 1)',
                            fill: false,
                        },
                        {
                            label: 'Battery Level (%)',
                            data: batteryLevels,
                            borderColor: 'rgba(54, 162, 235, 1)',
                            fill: false,
                        }
                    ]
                },
                options: {
                    responsive: true,
                    title: {
                        display: true,
                        text: 'Weather and Battery Level Over Time'
                    },
                    scales: {
                        x: {
                            display: true,
                            title: {
                                display: true,
                                text: 'Time'
                            }
                        },
                        y: {
                            display: true,
                            title: {
                                display: true,
                                text: 'Values'
                            }
                        }
                    }
                }
            });
        },
        
        uploadImage() {
            const fileInput = document.getElementById('fileInput');
            const file = fileInput.files[0];

            if (!file) {
                alert('이미지를 선택하세요.');
                return;
            }

            // FormData 객체 생성
            const formData = new FormData();
            formData.append('imageFile', file);  // 변경: 서버에서 받는 파라미터와 일치하도록 수정
            formData.append('siCode', this.siCode); // 선박 코드
            formData.append('sailNum', this.sailNum); // 항해 번호

            // 이미지 업로드 요청
            fetch('/upload/image', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(result => {
                console.log("업로드 결과:", result);
                alert("이미지가 업로드되었습니다.");
            })
            .catch(error => {
                console.error("업로드 중 오류 발생:", error);
                alert("이미지 업로드에 실패했습니다.");
            });
        }
    

    },
    mounted() {
        // Vue가 로드되면 지도 초기화
        window.initMap = this.initMap;
    }
});
</script>

</body>
</html>
