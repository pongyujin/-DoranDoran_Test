from flask import Flask, Response
import cv2
from ultralytics import YOLO

app = Flask(__name__)
video_url = 'http://192.168.219.42:5001/video'
model = YOLO('yolov8n.pt')
cap = cv2.VideoCapture(video_url)

def generate_frames():
    while True:
        ret, frame = cap.read()
        if not ret:
            break

        # YOLO 객체 감지 수행
        results = model(frame)
        annotated_frame = results[0].plot()

        # 프레임을 JPEG 형식으로 인코딩
        ret, buffer = cv2.imencode('.jpg', annotated_frame)
        frame_bytes = buffer.tobytes()

        # HTTP 응답을 위한 스트림 형식으로 생성
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n')

@app.route('/video_feed')
def video_feed():
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5001)
