<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 페이지</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #1A2529;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: white;
        }

        .manager-page {
            background-color: #17293A;
            padding: 50px;
            border-radius: 10px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
            text-align: center;
            width: 90vw;
            height: 90vh;
            overflow-y: auto;
        }

        h1 {
            margin-bottom: 40px;
            font-size: 28px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 16px 20px;
            text-align: center;
            border-bottom: 1px solid #313F49;
        }

        th {
            background-color: #1C2933;
            color: white;
            font-weight: normal;
            font-size: 16px;
        }

        tr:nth-child(even) {
            background-color: #1F2D3A;
        }

        tr:hover {
            background-color: #313F49;
        }

        .approve-btn {
            background-color: #5A77F9;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .reject-btn {
            background-color: #F95A5A;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .approve-btn:hover {
            background-color: #4763C8;
        }

        .reject-btn:hover {
            background-color: #D44A4A;
        }

    </style>
</head>
<body>

<div class="manager-page">
    <h1>관리자 페이지</h1>
    <table>
        <thead>
            <tr>
                <th>사용자 ID</th>
                <th>선박 ID</th>
                <th>파일</th>  <!-- 파일 열 추가 -->
                <th>승인 / 거절</th>
            </tr>
        </thead>
        <tbody>
            <!-- 서버에서 받은 userList 데이터가 있을 때만 반복 출력 -->
            <c:forEach var="user" items="${userList}">
                <tr>
                    <td>${user.userId}</td>
                    <td>${user.shipId}</td>
                    <td>
                        <!-- 파일이 있을 경우 파일 링크, 없을 경우 "파일 없음" 표시 -->
                        <c:choose>
                            <c:when test="${not empty user.filePath}">
                                <a href="${user.filePath}" download>파일 다운로드</a>
                            </c:when>
                            <c:otherwise>
                                파일 없음
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <!-- 등록한 사용자가 있을 때만 승인/거절 버튼 표시 -->
                        <c:if test="${not empty user.userId and not empty user.shipId}">
                            <form action="approveShip" method="post" style="display:inline;">
                                <input type="hidden" name="userId" value="${user.userId}">
                                <input type="hidden" name="shipId" value="${user.shipId}">
                                <button type="submit" class="approve-btn">승인</button>
                            </form>
                            <form action="rejectShip" method="post" style="display:inline;">
                                <input type="hidden" name="userId" value="${user.userId}">
                                <input type="hidden" name="shipId" value="${user.shipId}">
                                <button type="submit" class="reject-btn">거절</button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>
