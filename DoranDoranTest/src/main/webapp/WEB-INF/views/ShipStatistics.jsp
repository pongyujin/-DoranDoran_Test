<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Ship Statistics</title>
</head>
<body>
    <h1>Ship Statistics</h1>

    <!-- siNum을 입력하는 폼 -->
    <form action="/controller/ship/statistics" method="get">
        <label for="siNum">Enter Ship Number:</label>
        <input type="text" id="siNum" name="siNum">
        <button type="submit">Submit</button>
    </form>

    <!-- 조회된 선박 정보 출력 -->
    <c:if test="${not empty shipstat}">
        <h2>Ship Information</h2>
        <p>Ship Number: ${shipstat.siNum}</p>
        <p>Battery Status: ${shipstat.statBattery}</p>
        <p>Destination: ${shipstat.statDest}</p>
        <p>Latitude: ${shipstat.statLat}</p>
        <p>Longitude: ${shipstat.statLng}</p>
        <p>Status: ${shipstat.statStatus}</p>
    </c:if>
</body>
</html>
