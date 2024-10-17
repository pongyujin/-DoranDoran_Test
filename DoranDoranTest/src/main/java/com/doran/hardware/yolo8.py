import socket
import cv2
import numpy as np
import struct
from ultralytics import YOLO
import json
import time  # time 모듈을 추가하여 대기 시간을 구현
import sys
import os


# video_url = 'http://192.168.0.14:5001/video'
video_url = 'http://192.168.219.42:5001/video'


def send_data_to_java_server(frame, detections):
    try:
        # 소켓서버 연결
        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client_socket.connect(('localhost', 5000))
        
        # 이미지 인코딩
        _, img_encoded = cv2.imencode('.jpg', frame)
        img_bytes = img_encoded.tobytes()
        #print(f"py : 이미지 인코딩 완료. 크기: {len(img_bytes)} 바이트")

        # 이미지 크기
        size_info = struct.pack('>I', len(img_bytes))
        client_socket.sendall(size_info)
        #print(f"py : 이미지 크기 정보 전송 완료: {len(img_bytes)} 바이트")

        # 이미지 데이터 전송
        client_socket.sendall(img_bytes)
        #print("py : 이미지 데이터 전송 완료")

        # 감지 결과 JSON 형식으로 변환
        detection_data = []
        for det in detections:
            x1, y1, x2, y2, conf, cls = det
            detection_data.append({
                "class": int(cls),
                "confidence": float(conf),
                "bbox": [float(x1), float(y1), float(x2), float(y2)]
            })
        json_data = json.dumps(detection_data)

        # 감지 결과 크기 전송
        data_size = struct.pack('>I', len(json_data))
        client_socket.sendall(data_size)

        # 감지 결과 데이터 전송
        client_socket.sendall(json_data.encode())
        #print("py : 감지 결과 전송 완료")

        client_socket.close()
        print("py : 연결 종료")
    except Exception as e:
        print(f"py : 오류 발생: {str(e)}")

# YOLOv8 모델 로드
model = YOLO('yolov8n.pt')
#print("py : YOLOv8 모델 로드 완료")


# 웹캠에서 프레임 캡처
cap = cv2.VideoCapture(video_url)
#print("py : 웹캠 초기화 완료")

last_sent_time = time.time()  # 마지막 전송 시간을 기록

while True:
    ret, frame = cap.read()
    if not ret:
        print("py : 프레임 캡처 실패")
        break

    #print("py : YOLOv8로 객체 감지 중...")
    results = model(frame)
    #print("py : 객체 감지 완료")

    # 결과 시각화
    annotated_frame = results[0].plot()

    # 현재 시간과 마지막 전송 시간을 비교하여 3초가 지나면 서버로 전송
    current_time = time.time()
    if current_time - last_sent_time >= 3:
        # 3초가 지났을 때만 데이터 전송
        send_data_to_java_server(annotated_frame, results[0].boxes.data)
        last_sent_time = current_time  # 마지막 전송 시간 갱신

    # 화면에 표시 (프레임 처리는 계속 반복됨)
    cv2.imshow('YOLO Detection', annotated_frame)

    # 'q' 키를 누르면 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
print("프로그램 종료")
