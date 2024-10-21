<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>라즈베리파이 ssh연결</h1>
<form action="hardwareCon" method="post">
<table>
<tr>
	<td><input type="text" name="sshUser" id="sshUser" value="xo"></td>
</tr>
<tr>
	<td><input type="text" name="sshHost" id="sshHost" value="192.168.219.47"></td>
</tr>
<tr>
	<td><input type="number" name="sshPort" id="sshPort" value="22"></td>
</tr>
<tr>
	<td><input type="text" name="sshPw" id="sshPw" value="xo"></td>
</tr>
<tr>
	<td><input type="text" name="sshCommand" id="sshCommand" value="cd projects && cd Yolo5 && python3 app.py"></td>
</tr>
<tr>
	<td><input type="submit" value="접속"></td>
</tr>


</table>
</form>
</body>
</html>