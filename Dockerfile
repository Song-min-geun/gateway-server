# gateway-server/Dockerfile

# --- STAGE 1: Gradle을 이용해 Jar 파일 빌드 ---
FROM gradle:8.5.0-jdk17-focal AS builder

WORKDIR /app
COPY . .

# ⭐️ gateway-server 모듈만 특정해서 테스트를 건너뛰고 빌드합니다.
RUN ./gradlew build -x test --no-daemon


# --- STAGE 2: 빌드된 Jar 파일로 최종 실행 이미지 생성 ---
FROM openjdk:17-jdk-slim

WORKDIR /app

# ⭐️ 빌드된 gateway-server의 .jar 파일만 정확히 복사해옵니다.
COPY --from=builder /app/build/libs/*.jar app.jar

# 컨테이너가 시작될 때 이 명령어로 애플리케이션을 실행합니다.
ENTRYPOINT ["java", "-jar", "app.jar"]