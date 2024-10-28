<%@ page import="com.doran.controller.HwMotorController"%>
<%@ page import="com.doran.controller.HwServoMotorController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Arrow Buttons</title>
    <style>
        .arrow-button {
            display: inline-block;
            width: 50px;
            height: 50px;
            margin: 5px;
            background-color: #4CAF50; /* 버튼 배경색 */
            border: none;
            color: white;
            text-align: center;
            text-decoration: none;
            font-size: 20px;
            line-height: 50px;
            border-radius: 5px;
            cursor: pointer;
        }
        .reset-button{
        	display: inline-block;
            width: 100px;
            height: 50px;
            margin: 5px;
            background-color: #4CAF50; /* 버튼 배경색 */
            border: none;
            color: white;
            text-align: center;
            text-decoration: none;
            font-size: 15px;
            line-height: 50px;
            border-radius: 5px;
            cursor: pointer;
        
        }
        

        .up::before { content: "↑"; }
        .down::before { content: "↓"; }
        .left::before { content: "←"; }
        .right::before { content: "→"; }
        .reset::before { content: "방향타 중앙"}
        .stop::before { content: "모터 스톱"}

        .button-container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .horizontal-buttons {
            display: flex;
            justify-content: center;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="button-container">
        <button class="arrow-button up" onclick="move('up')"></button>
        <div class="horizontal-buttons">
            <button class="arrow-button left" onclick="moveServo('left')"></button>
            <button class="arrow-button down" onclick="move('down')"></button>
            <button class="arrow-button right" onclick="moveServo('right')"></button>
        </div>
        <br>
        <button class="reset-button reset" onclick="servoReset()"></button>
        <br>
        <button class="reset-button stop" onclick="motorStop()"></button>
    </div>
	
    <script>
        var speed = 0; //초기값
        var maxSpeed = 100;
        var minSpeed = 0;

        var degree = 90;  // 서보 모터 기본 각도
        var maxDegree = 180;
        var minDegree = 0;
        
        // 속도 ↑ ↓
        function move(direction) {
            if (direction === 'up') {
                speed += 10;
                if (speed > maxSpeed) {
                    speed = maxSpeed;
                }
            } else if (direction === 'down') {
                speed -= 10;
                if (speed < minSpeed) {
                    speed = minSpeed;
                }
            }

            // AJAX 요청으로 서버에 속도 값 전달
            fetch('/controller/updateSpeed', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ speed: speed })
            })
            .then(response => response.json())
            .then(data => {
                console.log('Speed updated on server:', data);
            })
            .catch(error => {
                console.error('Error updating speed:', error);
            });
        }
		
        // 방향타 ← →
        function moveServo(direction) {
            if (direction === 'left') {
                degree -= 10;
                if (degree < minDegree) {
                    degree = minDegree;
                }
            } else if (direction === 'right') {
                degree += 10;
                if (degree > maxDegree) {
                    degree = maxDegree;
                }
            }

            console.log('Sending degree to server:', degree);

            // AJAX 요청으로 서버에 각도 값 전달
            fetch('/controller/updateServoDegree', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ degree: degree })
            })
            .then(response => response.json())
            .then(data => {
                console.log('Degree updated on server:', data);
            })
            .catch(error => {
                console.error('Error updating degree:', error);
            });
        }
        
        // 모터 스탑 속도값 0
        function motorStop() {
        	speed = 0;
        	fetch('/controller/updateSpeed', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ speed: speed })
            })
            .then(response => response.json())
            .then(data => {
                console.log('Speed updated on server:', data);
            })
            .catch(error => {
                console.error('Error updating speed:', error);
            });
        }        	
         
        // 서보 중앙고정 90도 값
        function servoReset() {
        	degree = 90;
        	fetch('/controller/updateServoDegree', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ degree: degree })
            })
            .then(response => response.json())
            .then(data => {
                console.log('Degree updated on server:', data);
            })
            .catch(error => {
                console.error('Error updating degree:', error);
            });
        }
        
    </script>
</body>
</html>
