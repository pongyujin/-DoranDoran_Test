<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ship Statistics with Vue.js</title>
    <script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
    <!-- Google Maps API, geometry 라이브러리 포함 -->
    <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDtt1tmfQ-lTeQaCimRBn2PQPTlCLRO6Pg&libraries=geometry"></script>
    <style>
        #map {
            height: 400px;
            width: 100%;
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
                <label for="siNum">선박 번호를 입력하세요:</label>
                <input type="text" v-model="siNum" class="form-control">
                <button class="btn btn-primary" @click="loadShipStats">조회</button>
            </div>
            <div v-html="shipStatsTable" class="panel-body"></div>
        </div>

        <!-- 경로 거리 표시 -->
        <div v-if="totalDistanceKm" style="margin-top: 20px; font-weight: bold;">
            총 경로 거리: {{ totalDistanceKm }} km
        </div>

        <!-- Google Map을 표시할 div -->
        <div id="map"></div>
    </div>
</div>

<script>
new Vue({
    el: '#app',
    data: {
        siNum: '',
        shipStatsTable: '',
        totalDistanceKm: '',
        map: null,
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

            // 경로 데이터를 세미콜론으로 나누고, 각 좌표를 처리
            const coordinates = routeData.split(';');
            for (let i = 0; i < coordinates.length; i++) {
                const [lat, lng] = coordinates[i].split(',').map(Number);
                const position = { lat: lat, lng: lng };
                routeCoordinates.push(position);

                // 두 지점 사이의 거리 계산 (마지막 지점은 제외)
                if (i > 0) {
                    const prevPos = routeCoordinates[i - 1];
                    const distance = google.maps.geometry.spherical.computeDistanceBetween(
                        new google.maps.LatLng(prevPos.lat, prevPos.lng),
                        new google.maps.LatLng(lat, lng)
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

            // 전체 경로 거리 (킬로미터) 계산
            this.totalDistanceKm = (totalDistance / 1000).toFixed(2); // 미터를 킬로미터로 변환
        },
        // 선박 번호로 통계 조회 및 경로 그리기
        loadShipStats() {
            const siNum = this.siNum;
            console.log("입력된 선박 번호: " + siNum);

            fetch(`statistics/${siNum}`)
                .then(response => response.json())
                .then(data => {
                    // 통계 데이터를 표로 출력
                    this.makeView(data);

                    // 경로 데이터: statRoute
                    const route = data.statRoute;
                    console.log("경로 데이터: " + route);

                    // 경로 그리기 및 거리 계산
                    this.drawRoute(route);
                })
                .catch(error => {
                    console.log("Error:", error);
                });
        },
        // 통계 데이터를 HTML 테이블로 변환
        makeView(data) {
            let listHtml = `<table class='table table-bordered'>
                <tr>
                    <td>선박 번호</td>
                    <td>목적지</td>
                    <td>위도</td>
                    <td>경도</td>
                    <td>상태</td>
                </tr>
                <tr>
                    <td>${data.siNum}</td>
                    <td>${data.statDest}</td>
                    <td>${data.statLat}</td>
                    <td>${data.statLng}</td>
                    <td>${data.statStatus}</td>
                </tr>
            </table>`;
            this.shipStatsTable = listHtml;
        }
    },
    mounted() {
        // Vue가 로드되면 지도 초기화
        this.initMap();
    }
});
</script>

</body>
</html>
