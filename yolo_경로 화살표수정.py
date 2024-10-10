import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import matplotlib.font_manager as fm

# 한글 폰트 설정 (필요 시 시스템에 설치된 폰트로 변경)
plt.rcParams['font.family'] = 'Malgun Gothic'  # 또는 'AppleGothic', 'NanumGothic' 등
plt.rcParams['axes.unicode_minus'] = False  # 마이너스 기호 깨짐 방지

# 허버사인 공식을 사용하여 두 지점 간 거리 계산
def haversine(lat1, lon1, lat2, lon2):
    R = 6371.0  # 지구 반지름 (킬로미터)
    lat1_rad, lon1_rad = np.radians([lat1, lon1])
    lat2_rad, lon2_rad = np.radians([lat2, lon2])
    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad
    a = np.sin(dlat / 2) ** 2 + np.cos(lat1_rad) * np.cos(lat2_rad) * np.sin(dlon / 2) ** 2
    c = 2 * np.arcsin(np.sqrt(a))
    distance = R * c
    return distance

def haversine_matrix(lat1, lon1, lat2, lon2):
    # 벡터화된 허버사인 계산
    R = 6371.0  # 지구 반지름 (킬로미터)
    lat1_rad = np.radians(lat1)
    lon1_rad = np.radians(lon1)
    lat2_rad = np.radians(lat2)
    lon2_rad = np.radians(lon2)
    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad
    a = np.sin(dlat / 2) ** 2 + np.cos(lat1_rad) * np.cos(lat2_rad) * np.sin(dlon / 2) ** 2
    c = 2 * np.arcsin(np.sqrt(a))
    distance = R * c
    return distance

# 그리드 생성
def create_grid(lat1, lon1, lat2, lon2, grid_size=200):
    lat_min = min(lat1, lat2) - 0.5  # 범위를 넓게 조정
    lat_max = max(lat1, lat2) + 0.5
    lon_min = min(lon1, lon2) - 0.5
    lon_max = max(lon1, lon2) + 0.5

    lat_grid = np.linspace(lat_min, lat_max, grid_size)
    lon_grid = np.linspace(lon_min, lon_max, grid_size)

    return lat_grid, lon_grid

# 장애물 맵 생성
def create_obstacle_map(lat_grid, lon_grid, obstacles, moving_obstacles, ship_lat, ship_lon, sensing_radius,
                        obstacle_radius=3, avoidance_cost=5):
    obstacle_map = np.zeros((len(lat_grid), len(lon_grid)))

    # 고정 장애물 마킹
    for obstacle in obstacles:
        obstacle_lat, obstacle_lon = obstacle
        distances = haversine_matrix(lat_grid[:, np.newaxis], lon_grid[np.newaxis, :], obstacle_lat, obstacle_lon)
        obstacle_map[distances <= obstacle_radius] = 1  # 장애물 위치 표시

    # 센싱 반경 내의 이동 장애물만 고려
    for moving_obstacle in moving_obstacles:
        # 무인 선박과의 거리 계산
        distance_to_ship = haversine(ship_lat, ship_lon, moving_obstacle['lat'], moving_obstacle['lon'])
        if distance_to_ship <= sensing_radius:
            obstacle_lat = moving_obstacle['lat']
            obstacle_lon = moving_obstacle['lon']
            direction = moving_obstacle['direction']
            distances = haversine_matrix(lat_grid[:, np.newaxis], lon_grid[np.newaxis, :], obstacle_lat,
                                         obstacle_lon)
            obstacle_map[distances <= obstacle_radius] = 1  # 이동 장애물 위치 표시

            # 회피할 오른쪽 영역 계산
            right_angle = (direction + 90) % 360
            rad = np.radians(right_angle)
            dx = np.cos(rad) * obstacle_radius
            dy = np.sin(rad) * obstacle_radius

            # 오른쪽 방향으로 회피할 영역을 마킹
            avoidance_lat = obstacle_lat + (dy / 111)  # 대략적인 위도 변환 (1도 ≈ 111km)
            avoidance_lon = obstacle_lon + (dx / (111 * np.cos(np.radians(obstacle_lat))))  # 대략적인 경도 변환

            # 회피 영역에 추가 비용 적용
            avoidance_distance = haversine_matrix(lat_grid[:, np.newaxis], lon_grid[np.newaxis, :], avoidance_lat,
                                                  avoidance_lon)
            obstacle_map[avoidance_distance <= obstacle_radius] += avoidance_cost  # 회피 영역에 비용 추가

    return obstacle_map

# A* 알고리즘을 위한 노드 클래스
class Node:
    def __init__(self, position, parent=None, g=0, h=0):
        self.position = position  # (x, y)
        self.parent = parent
        self.g = g  # 시작 노드로부터의 비용
        self.h = h  # 휴리스틱 비용
        self.f = g + h  # 총 비용

    def __eq__(self, other):
        return self.position == other.position

# A* 알고리즘 구현
def astar(obstacle_map, start_idx, goal_idx, lat_grid, lon_grid):
    open_list = []
    closed_list = set()

    start_node = Node(start_idx)
    goal_node = Node(goal_idx)

    open_list.append(start_node)

    while open_list:
        # f 값이 가장 낮은 노드를 선택
        open_list.sort(key=lambda node: node.f)
        current_node = open_list.pop(0)
        closed_list.add(current_node.position)

        # 목표 지점에 도달하면 경로 반환
        if current_node == goal_node:
            path = []
            node = current_node
            while node is not None:
                path.append(node.position)
                node = node.parent
            return path[::-1]  # 경로를 역순으로 반환

        # 현재 노드의 인접한 노드 탐색
        (x, y) = current_node.position
        neighbors = [(-1, 0), (1, 0), (0, -1), (0, 1),
                     (-1, -1), (-1, 1), (1, -1), (1, 1)]

        for dx, dy in neighbors:
            nx, ny = x + dx, y + dy

            # 그리드 범위 내에 있는지 확인
            if nx < 0 or nx >= obstacle_map.shape[0] or ny < 0 or ny >= obstacle_map.shape[1]:
                continue
            # 장애물인지 확인
            if obstacle_map[nx][ny] >= 1:
                continue
            # 이미 닫힌 리스트에 있는지 확인
            if (nx, ny) in closed_list:
                continue

            g = current_node.g + 1
            # 휴리스틱을 허버사인 거리로 계산
            h = haversine(lat_grid[nx], lon_grid[ny], lat_grid[goal_idx[0]], lon_grid[goal_idx[1]])
            neighbor_node = Node((nx, ny), current_node, g, h)

            # 이미 열린 리스트에 있는 노드인지 확인
            in_open_list = False
            for node in open_list:
                if neighbor_node == node and neighbor_node.g >= node.g:
                    in_open_list = True
                    break

            if not in_open_list:
                open_list.append(neighbor_node)

    return None  # 경로 없음

def generate_route_with_obstacles(lat1, lon1, lat2, lon2, obstacles, moving_obstacles, ship_lat, ship_lon,
                                  sensing_radius, grid_size=200):
    lat_grid, lon_grid = create_grid(lat1, lon1, lat2, lon2, grid_size=grid_size)
    obstacle_map = create_obstacle_map(lat_grid, lon_grid, obstacles, moving_obstacles, ship_lat, ship_lon,
                                       sensing_radius)

    start_idx = (np.abs(lat_grid - lat1).argmin(), np.abs(lon_grid - lon1).argmin())
    goal_idx = (np.abs(lat_grid - lat2).argmin(), np.abs(lon_grid - lon2).argmin())

    path = astar(obstacle_map, start_idx, goal_idx, lat_grid, lon_grid)

    if path is None:
        print("경로를 찾을 수 없습니다.")
        return [], [], obstacle_map, lat_grid, lon_grid

    route_lats = [lat_grid[pos[0]] for pos in path]
    route_lons = [lon_grid[pos[1]] for pos in path]

    return route_lats, route_lons, obstacle_map, lat_grid, lon_grid

def interpolate_path(route_lats, route_lons):
    path_distances = [0]
    for i in range(1, len(route_lats)):
        distance = haversine(route_lats[i - 1], route_lons[i - 1], route_lats[i], route_lons[i])
        path_distances.append(distance)
    cumulative_distances = np.cumsum(path_distances)
    total_distance = cumulative_distances[-1]

    num_points = max(int(total_distance / 0.05), 2)
    new_distances = np.linspace(0, total_distance, num_points)

    route_lats_interp = np.interp(new_distances, cumulative_distances, route_lats)
    route_lons_interp = np.interp(new_distances, cumulative_distances, route_lons)

    return route_lats_interp, route_lons_interp, new_distances

# 시뮬레이션 설정
initial_lat, initial_lon = 34.5, 128.73
destination_lat, destination_lon = 35.22, 128.90
current_lat, current_lon = initial_lat, initial_lon
previous_lat, previous_lon = initial_lat, initial_lon

# 고정 장애물 리스트 (5곳)
fixed_obstacles = [
    (34.95, 128.95),
    (34.90, 128.90),
    (34.75, 128.80),
    (34.85, 128.85),
    (35.00, 128.75),
]

# 이동 장애물 리스트 (30곳)
moving_obstacles = [
    {'lat': 34.85, 'lon': 128.85, 'direction': 90, 'speed': 15},
    {'lat': 35.0, 'lon': 129.0, 'direction': 135, 'speed': 12},
    {'lat': 34.95, 'lon': 129.25, 'direction': 180, 'speed': 10},
    {'lat': 34.70, 'lon': 128.80, 'direction': 90, 'speed': 8},
    {'lat': 34.75, 'lon': 129.00, 'direction': 270, 'speed': 14},
    {'lat': 34.90, 'lon': 129.10, 'direction': 315, 'speed': 16},
    {'lat': 34.60, 'lon': 128.75, 'direction': 180, 'speed': 9},
    {'lat': 34.85, 'lon': 128.95, 'direction': 90, 'speed': 13},
    {'lat': 35.05, 'lon': 128.90, 'direction': 270, 'speed': 11},
    {'lat': 34.95, 'lon': 129.10, 'direction': 225, 'speed': 17},
    {'lat': 34.65, 'lon': 128.85, 'direction': 90, 'speed': 15},
    {'lat': 34.80, 'lon': 128.90, 'direction': 180, 'speed': 12},
    {'lat': 35.10, 'lon': 129.05, 'direction': 315, 'speed': 18},
    {'lat': 34.75, 'lon': 128.75, 'direction': 135, 'speed': 14},
    {'lat': 34.88, 'lon': 129.05, 'direction': 90, 'speed': 16},
    {'lat': 34.92, 'lon': 129.20, 'direction': 180, 'speed': 9},
    {'lat': 35.12, 'lon': 129.00, 'direction': 45, 'speed': 20},
    {'lat': 34.82, 'lon': 128.88, 'direction': 225, 'speed': 11},
    {'lat': 34.78, 'lon': 129.15, 'direction': 270, 'speed': 13},
    {'lat': 34.67, 'lon': 128.78, 'direction': 315, 'speed': 10},
    # 추가된 이동 장애물 10개
    {'lat': 34.85, 'lon': 128.80, 'direction': 90, 'speed': 14},
    {'lat': 34.90, 'lon': 128.95, 'direction': 135, 'speed': 12},
    {'lat': 35.05, 'lon': 129.15, 'direction': 180, 'speed': 9},
    {'lat': 34.65, 'lon': 128.70, 'direction': 90, 'speed': 15},
    {'lat': 34.80, 'lon': 129.05, 'direction': 270, 'speed': 13},
    {'lat': 34.95, 'lon': 129.05, 'direction': 315, 'speed': 16},
    {'lat': 34.55, 'lon': 128.80, 'direction': 180, 'speed': 11},
    {'lat': 34.90, 'lon': 128.85, 'direction': 90, 'speed': 14},
    {'lat': 35.00, 'lon': 128.95, 'direction': 270, 'speed': 12},
    {'lat': 34.85, 'lon': 129.00, 'direction': 225, 'speed': 17},
]

ship_speed = 30  # km/h
total_time = 300  # 총 시뮬레이션 시간 (분)
time_step = 0.1  # 시간 간격 (분)
num_steps = int(total_time / time_step)
sensing_radius = 10  # km

ship_distance_since_replan = 0
reached_destination = False

# 초기 경로 생성
route_lats, route_lons, obstacle_map, lat_grid, lon_grid = generate_route_with_obstacles(
    current_lat, current_lon, destination_lat, destination_lon, fixed_obstacles, moving_obstacles,
    current_lat, current_lon, sensing_radius, grid_size=200)

if not route_lats or not route_lons:
    print("초기 경로 생성 실패. 시뮬레이션을 종료합니다.")
    exit()

route_lats_interp, route_lons_interp, cumulative_distances = interpolate_path(route_lats, route_lons)

# 축 범위 설정 (경로 및 목적지를 포함하도록)
lat_min_plot = min(min(route_lats_interp), destination_lat, initial_lat) - 0.1
lat_max_plot = max(max(route_lats_interp), destination_lat, initial_lat) + 0.1
lon_min_plot = min(min(route_lons_interp), destination_lon, initial_lon) - 0.1
lon_max_plot = max(max(route_lons_interp), destination_lon, initial_lon) + 0.1

# 애니메이션 초기화
fig, ax = plt.subplots(figsize=(12, 8))

def update(frame):
    global current_lat, current_lon, previous_lat, previous_lon, route_lats_interp, route_lons_interp, obstacle_map
    global cumulative_distances, lat_grid, lon_grid, ship_distance_since_replan, reached_destination
    global lat_min_plot, lat_max_plot, lon_min_plot, lon_max_plot

    current_time = frame * time_step

    # 이동 장애물 위치 업데이트
    for mo in moving_obstacles:
        speed, direction = mo['speed'], mo['direction']
        distance = speed * (time_step / 60)  # km
        delta_lat = (distance / 111) * np.cos(np.radians(direction))
        delta_lon = (distance / (111 * np.cos(np.radians(mo['lat'])))) * np.sin(np.radians(direction))
        mo['lat'] += delta_lat
        mo['lon'] += delta_lon

    # 무인 선박의 이동 거리 업데이트
    ship_distance_since_replan += ship_speed * (time_step / 60)  # km

    # 무인 선박의 위치 업데이트
    if ship_distance_since_replan >= cumulative_distances[-1]:
        current_lat, current_lon = route_lats_interp[-1], route_lons_interp[-1]
    else:
        idx = np.searchsorted(cumulative_distances, ship_distance_since_replan)
        if idx == 0:
            current_lat, current_lon = route_lats_interp[0], route_lons_interp[0]
        else:
            ratio = (ship_distance_since_replan - cumulative_distances[idx - 1]) / (
                        cumulative_distances[idx] - cumulative_distances[idx - 1])
            current_lat = route_lats_interp[idx - 1] + ratio * (route_lats_interp[idx] - route_lats_interp[idx - 1])
            current_lon = route_lons_interp[idx - 1] + ratio * (route_lons_interp[idx] - route_lons_interp[idx - 1])

    # 선박이 목적지에 도달했는지 확인
    distance_to_destination = haversine(current_lat, current_lon, destination_lat, destination_lon)
    if distance_to_destination < 0.01 and not reached_destination:
        reached_destination = True
        print(f"목적지에 도달했습니다. 시간: {current_time:.1f}분")
        ani.event_source.stop()

    previous_lat, previous_lon = current_lat, current_lon

    # 경로 재계획
    if (frame % int(10 / time_step) == 0) and (frame != 0) and (not reached_destination):
        new_route_lats, new_route_lons, obstacle_map, lat_grid, lon_grid = generate_route_with_obstacles(
            current_lat, current_lon, destination_lat, destination_lon, fixed_obstacles, moving_obstacles,
            current_lat, current_lon, sensing_radius, grid_size=200)

        if new_route_lats and new_route_lons:
            new_route_lats_interp, new_route_lons_interp, new_cumulative_distances = interpolate_path(new_route_lats,
                                                                                                      new_route_lons)

            if new_cumulative_distances[-1] > 0:
                route_lats_interp, route_lons_interp, cumulative_distances = new_route_lats_interp, new_route_lons_interp, new_cumulative_distances
                ship_distance_since_replan = 0

                # 축 범위 재설정 (목적지와 시작점을 포함하도록)
                lat_min_plot = min(min(route_lats_interp), destination_lat, initial_lat) - 0.1
                lat_max_plot = max(max(route_lats_interp), destination_lat, initial_lat) + 0.1
                lon_min_plot = min(min(route_lons_interp), destination_lon, initial_lon) - 0.1
                lon_max_plot = max(max(route_lons_interp), destination_lon, initial_lon) + 0.1
            else:
                print("경로 재계획 시 누적 거리가 0입니다. 이전 경로를 유지합니다.")
        else:
            print("경로 재계획 실패. 이전 경로를 유지합니다.")

    # 시각화
    ax.cla()
    ax.imshow(obstacle_map.T, extent=(lon_grid.min(), lon_grid.max(), lat_grid.min(), lat_grid.max()),
              origin='lower', cmap='Greys', alpha=0.5)
    ax.plot(route_lons_interp, route_lats_interp, color='blue', label='경로', linewidth=2)

    # 고정 장애물 표시
    ax.scatter([lon for lat, lon in fixed_obstacles], [lat for lat, lon in fixed_obstacles],
               color='red', marker='x', label='고정 장애물', s=50)

    # 이동 장애물 표시 (화살표 방향 수정)
    for mo in moving_obstacles:
        ax.scatter(mo['lon'], mo['lat'], color='green', marker='o', s=50)
        arrow_dx = 0.02 * np.sin(np.radians(mo['direction']))
        arrow_dy = 0.02 * np.cos(np.radians(mo['direction']))
        ax.arrow(mo['lon'], mo['lat'], arrow_dx, arrow_dy,
                 head_width=0.01, head_length=0.01, fc='green', ec='green')

    # 무인 선박의 현재 위치 표시
    ax.scatter(current_lon, current_lat, marker='o', color='cyan', s=200, label='무인 선박')

    # 이동 방향 화살표 계산
    delta_lat, delta_lon = current_lat - previous_lat, current_lon - previous_lon
    if delta_lat != 0 or delta_lon != 0:
        direction_rad = np.arctan2(delta_lon, delta_lat)
        arrow_length = 0.05
        arrow_dx, arrow_dy = arrow_length * np.sin(direction_rad), arrow_length * np.cos(direction_rad)
        ax.arrow(current_lon, current_lat, arrow_dx, arrow_dy,
                 head_width=0.02, head_length=0.02, fc='cyan', ec='cyan')

    # 시작점과 목적지 표시
    ax.scatter(initial_lon, initial_lat, marker='o', color='yellow', s=100, label='시작점')
    ax.scatter(destination_lon, destination_lat, marker='*', color='magenta', s=200, label='목적지')

    # 그래프 설정
    ax.set_title(f'시간: {current_time:.1f}분')
    ax.set_xlabel('경도')
    ax.set_ylabel('위도')
    ax.legend(loc='upper left', bbox_to_anchor=(1, 1))
    ax.grid(True)

    # 축 범위 설정 (최소값이 최대값보다 작도록)
    ax.set_xlim(lon_min_plot, lon_max_plot)
    ax.set_ylim(lat_min_plot, lat_max_plot)
    ax.set_aspect('equal', adjustable='box')

    # 디버깅 정보 출력
    print(
        f"시간: {current_time:.1f}분, 선박 위치: ({current_lat:.4f}, {current_lon:.4f}), 목적지까지 거리: {distance_to_destination:.4f} km")
    print(f"현재 경로 거리: {cumulative_distances[-1]:.2f} km")

# 애니메이션 실행
ani = FuncAnimation(fig, update, frames=num_steps, interval=50)

plt.tight_layout()
plt.show()
