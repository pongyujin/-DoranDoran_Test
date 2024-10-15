<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Ship Statistics</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
   href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
   src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script
   src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body>

   <script type="text/javascript">
   // 선박 번호로 통계 조회
   function loadShipStats(siNum) {
      $.ajax({
         url: "/ship/" + siNum,
         type: "get",
         dataType: "json",
         success: makeView,
         error: function() {
            alert("선박 데이터를 불러오는 데 실패했습니다.");
         }
      });
   }

   // 통계 데이터 출력
   function makeView(data) {
      var listHtml = "<table class='table table-bordered'>";
      listHtml += "<tr>";
      listHtml += "<td>선박 번호</td>";
      listHtml += "<td>목적지</td>";
      listHtml += "<td>위도</td>";
      listHtml += "<td>경도</td>";
      listHtml += "<td>상태</td>";
      listHtml += "</tr>";

      listHtml += "<tr>";
      listHtml += "<td>" + data.siNum + "</td>";
      listHtml += "<td>" + data.statDest + "</td>";
      listHtml += "<td>" + data.statLat + "</td>";
      listHtml += "<td>" + data.statLng + "</td>";
      listHtml += "<td>" + data.statStatus + "</td>";
      listHtml += "</tr>";

      listHtml += "</table>";
      $("#view").html(listHtml);
   }

   </script>

   <div class="container">
      <h2>선박 통계 정보</h2>
      <div class="panel panel-default">
         <div class="panel-heading">선박 통계 조회</div>
         <div class="panel-body">
            <label for="siNum">선박 번호를 입력하세요:</label>
            <input type="text" id="siNum" class="form-control">
            <button class="btn btn-primary" onclick="loadShipStats($('#siNum').val())">조회</button>
         </div>
         <div id="view" class="panel-body"></div>
      </div>
   </div>

</body>
</html>
