<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ship Statistics with Vue.js</title>
<script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
<script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDtt1tmfQ-lTeQaCimRBn2PQPTlCLRO6Pg&libraries=geometry&callback=initMap"></script>
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
    bottom: 20px;
    right: 20px;
    z-index: 10;
    font-weight: bold;
    font-size: 16px;
}

.image-container {
    margin-top: 20px;
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
                <!-- 사용자가 선박 번호와 siCode를 입력하는 입력 폼 -->
                <label for="sailNum">sailNum를 입력하세요:</label> 
                <input type="text" v-model="sailNum" class="form-control"> 
                <label for="siCode">siCode를 입력하세요:</label> 
                <input type="text" v-model="siCode" class="form-control">
                <button class="btn btn-primary" @click="loadShipStats">조회</button>
            </div>
        </div>

        <!-- 이미지 업로드를 위한 입력 폼 -->
        <form id="uploadForm" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
            <label for="fileInput">이미지를 업로드하세요:</label>
            <input type="file" id="fileInput" name="file" class="form-control">
            <button type="button" class="btn btn-primary" @click="uploadImage">업로드</button>
        </form>

        <!-- 차트 표시용 캔버스 -->
        <canvas id="weatherChart" width="400" height="200"></canvas>
        <canvas id="waveBatteryChart" width="400" height="200" style="margin-top: 20px;"></canvas>

        <!-- 지도와 경로 정보를 표시하는 컨테이너 -->
        <div id="map-container">
            <div id="map"></div>
            <div v-if="totalDistanceKm" class="distance-label">총 경로 거리: {{ totalDistanceKm }} km</div>
        </div>

        <!-- 서버에서 가져온 장애물 이미지들을 표시하는 영역 -->
        <div v-if="imageUrls.length" class="image-container">
            <h3>장애물 이미지</h3>
            <div v-for="(url, index) in imageUrls" :key="index">
                <img :src="url" alt="선박 이미지" style="max-width: 100%; height: auto;">
            </div>
        </div>
    </div>
</div>

<script>
new Vue({
    el: '#app',
    data: {
        siCode: '', // 사용자로부터 입력받는 siCode
        sailNum: '', // 사용자로부터 입력받는 sailNum
        totalDistanceKm: '', // 총 경로 거리 저장
        map: null, // Google Map 객체 저장
        weatherList: [], // 날씨 정보 목록 저장
        imageUrls: [] // 서버에서 가져온 이미지 URL 목록 저장
    },
    methods: {
        // Google Maps 초기화 함수
        initMap() {
            this.map = new google.maps.Map(document.getElementById("map"), {
                center: { lat: 33.5097, lng: 126.5219 }, // 기본 중심 위치를 제주도로 설정
                zoom: 7, // 줌 레벨 설정
            });
        },
        // 선박 경로를 지도에 그리는 함수
        drawRoute(routeData) {
            const routeCoordinates = [];
            let totalDistance = 0;

            // 경로 데이터 배열을 처리하여 지도에 표시할 준비를 합니다.
            for (let i = 0; i < routeData.length; i++) {
                const { gpsLat, gpsLng } = routeData[i];
                const position = { lat: gpsLat, lng: gpsLng };
                routeCoordinates.push(position);

                // 두 지점 사이의 거리를 계산하여 총 거리 업데이트
                if (i > 0) {
                    const prevPos = routeCoordinates[i - 1];
                    const distance = google.maps.geometry.spherical.computeDistanceBetween(
                        new google.maps.LatLng(prevPos.lat, prevPos.lng),
                        new google.maps.LatLng(gpsLat, gpsLng)
                    );
                    totalDistance += distance;
                }
            }

            // 경로를 그리기 위한 Google Maps의 Polyline 객체 생성
            const routePath = new google.maps.Polyline({
                path: routeCoordinates,
                geodesic: true,
                strokeColor: '#FF0000',
                strokeOpacity: 1.0,
                strokeWeight: 2
            });

            // 지도에 경로 추가
            routePath.setMap(this.map);
            this.totalDistanceKm = (totalDistance / 1000).toFixed(2); // 총 경로 거리를 km 단위로 변환하여 저장
        },
        // 서버로부터 선박 통계와 경로 데이터를 가져오는 함수
        loadShipStats() {
            const sailNum = this.sailNum;
            const siCode = this.siCode;

            // 선박 통계와 경로 정보를 서버에서 가져옵니다.
            fetch('statistics/' + siCode + '/' + sailNum)
                .then(response => response.json())
                .then(data => {
                    const route = data.gpsList;
                    const weather = data.weatherList;

                    // 경로 그리기 및 날씨 차트 그리기
                    this.drawRoute(route);
                    this.weatherList = weather;
                    this.drawWeatherChart();
                    this.drawWaveBatteryChart();

                    // 장애물 이미지 정보를 가져오기 위해 새로운 API 호출
                    return fetch('http://192.168.219.101:8085/controller/statistics/getImage?siCode=' + siCode + '&sailNum=' + sailNum);
                })
                .then(response => response.json())
                .then(data => {
                    if (data && Array.isArray(data)) {
                        // 이미지 목록을 저장하여 화면에 표시되도록 함
                        this.imageUrls = data.map(camera => 'http://192.168.219.101:8085' + camera.obsImg);
                    } else {
                        this.imageUrls = [];
                        console.error("이미지 정보가 없습니다.");
                    }
                })
                .catch(error => {
                    console.error("Error:", error);
                });
        },
        // 날씨와 배터리 상태를 차트로 그리는 함수
        drawWeatherChart() {
            const ctx = document.getElementById('weatherChart').getContext('2d');
            const labels = this.weatherList.map(item => item.wtime); // 시간 정보 추출
            const temps = this.weatherList.map(item => parseFloat(item.wtemp)); // 온도 정보 추출
            const batteryLevels = this.weatherList.map(item => parseFloat(item.statBattery)); // 배터리 상태 정보 추출

            // 차트를 생성하여 날씨와 배터리 상태를 시각화합니다.
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
        // 파고와 배터리 상태를 차트로 그리는 함수
        drawWaveBatteryChart() {
            const ctx = document.getElementById('waveBatteryChart').getContext('2d');
            console.log(this.weatherList);
            const labels = this.weatherList.map(item => item.wtime); // 시간 정보 추출
            const waveHeights = this.weatherList.map(item => parseFloat(item.wwaveHeight)); // 파고 정보 추출
            const batteryLevels = this.weatherList.map(item => parseFloat(item.statBattery)); // 배터리 상태 정보 추출

            // 차트를 생성하여 파고와 배터리 상태를 시각화합니다.
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: 'Wave Height (m)',
                            data: waveHeights,
                            borderColor: 'rgba(75, 192, 192, 1)',
                            fill: false,
                        },
                        {
                            label: 'Battery Level (%)',
                            data: batteryLevels,
                            borderColor: 'rgba(153, 102, 255, 1)',
                            fill: false,
                        }
                    ]
                },
                options: {
                    responsive: true,
                    title: {
                        display: true,
                        text: 'Wave Height and Battery Level Over Time'
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
        // 이미지를 서버에 업로드하는 함수
        uploadImage() {
            const fileInput = document.getElementById('fileInput');
            const file = fileInput.files[0];

            if (!file) {
                alert('이미지를 선택하세요.');
                return;
            }

            const formData = new FormData();
            formData.append('file', file);

            fetch('http://192.168.219.101:8085/controller/statistics/upload/image', {
                method: 'POST',
                body: formData,
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
        window.initMap = this.initMap;
    }
});
</script>

</body>
</html>
