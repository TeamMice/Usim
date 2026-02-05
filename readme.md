# 🛡️ 으심대 - 스미싱 및 피싱 방지 도우미

> **"의심되면, 혼자 판단하지 마세요."**
> '으심대'는 수상한 문자 메시지와 QR 코드를 분석하여 사용자를 피싱 범죄로부터 보호하는 iOS 애플리케이션입니다.

---

## ✨ 주요 기능 (Key Features)

### 1. 🔍 AI 메시지 분석 (UsimView)
- 수상한 문자 내용을 복사하여 붙여넣으면 AI가 스팸 여부를 판단합니다.
- **분석 내용**: 위험도(isSpam), 카테고리, 신뢰도, 그리고 구체적인 판단 근거를 제공합니다.
- 사용자의 시스템 언어에 맞춘 다국어 분석 요청 기능을 지원합니다.

### 2. 📸 QR 코드 스캔 및 분석 (CameraView)
- **실시간 스캔**: 카메라를 통해 QR 코드를 즉시 인식합니다.
- **사진 라이브러리**: 앨범에 저장된 스크린샷이나 이미지에서 QR 코드를 추출(Vision Framework)하여 분석할 수 있습니다.
- **URL 검사**: 추출된 URL의 위험성을 서버에 조회하여 안전 여부를 확인합니다.

### 3. 🚨 즉시 신고 서비스 (ReportView)
- 피해 발생 시 신속하게 대응할 수 있도록 주요 기관 연결 기능을 제공합니다.
- **온라인 신고**: 경찰청 사이버범죄 신고시스템(ECRM) 연결
- **전화 연결**: 경찰청(112), 한국인터넷진흥원(118), 금융감독원(1332) 직통 전화 버튼

---

## 🛠 기술 스택 (Tech Stack)

- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **API**: Custom REST API (`URLSession`, `JSONDecoder`)
- **Libraries/Frameworks**:
  - `AVFoundation`: 실시간 카메라 QR 인식 구현
  - `Vision`: 이미지 파일 내 QR 코드 분석
  - `PhotosUI`: 시스템 사진 앨범 접근 및 이미지 선택

---

## 📱 실행 화면 (Screenshots)

| 으심대 (메인 분석) | QR 스캔 | 신고 센터 |
| :---: | :---: | :---: |
| <img src="https://via.placeholder.com/200x400" width="200"> | <img src="https://via.placeholder.com/200x400" width="200"> | <img src="https://via.placeholder.com/200x400" width="200"> |
| *메시지 분석 화면* | *카메라 기반 QR 인식* | *기관별 즉시 신고* |

---

## 🚀 시작하기 (Getting Started)

### 요구 사항
- iOS 16.0 이상
- Xcode 15.0 이상

### 설치 및 실행
1. 저장소를 클론합니다.
   ```bash
   git clone [https://github.com/your-username/Dorgu.git](https://github.com/your-username/Dorgu.git)
