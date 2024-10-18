import socket
import cv2
import numpy as np
import struct
import torch
import json

video_url = 'http://192.168.0.14:5001/video'

def send_data_to_java_server(frame, detections):
    try:
        print("서버 연결 시도 중...")
        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client_socket.connect(('localhost', 5000))
        print("서버에 연결되었습니다.")

        print("이미지 인코딩 중...")
        _, img_encoded = cv2.imencode('.jpg', frame)
        img_bytes = img_encoded.tobytes()
        print(f"이미지 인코딩 완료. 크기: {len(img_bytes)} 바이트")

        # 이미지 크기 정보 전송
        size_info = struct.pack('>I', len(img_bytes))
        client_socket.sendall(size_info)
        print(f"이미지 크기 정보 전송 완료: {len(img_bytes)} 바이트")

        # 이미지 데이터 전송
        print("이미지 데이터 전송 중...")
        client_socket.sendall(img_bytes)
        print("이미지 데이터 전송 완료")

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
        print("감지 결과 전송 완료")

        client_socket.close()
        print("연결 종료")
    except Exception as e:
        print(f"오류 발생: {str(e)}")

# YOLOv5 모델 로드
print("YOLOv5 모델 로드 중...")
model = torch.hub.load('ultralytics/yolov5', 'yolov5s')
print("YOLOv5 모델 로드 완료")

# 웹캠에서 프레임 캡처
print("웹캠 초기화 중...")
cap = cv2.VideoCapture(video_url)
print("웹캠 초기화 완료")

while True:
    ret, frame = cap.read()
    if not ret:
        print("프레임 캡처 실패")
        break

    print("YOLOv5로 객체 감지 중...")
    results = model(frame)
    print("객체 감지 완료")

    # 결과 시각화
    annotated_frame = np.squeeze(results.render())

    # 결과 이미지와 감지 데이터를 서버로 전송
    detections = results.xyxy[0].cpu().numpy()
    send_data_to_java_server(annotated_frame, detections)

    # 화면에 표시 (선택사항)
    cv2.imshow('YOLO Detection', annotated_frame)

    # 'q' 키를 누르면 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
print("프로그램 종료")