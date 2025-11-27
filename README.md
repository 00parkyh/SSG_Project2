# 🚀 SSG 2차 2팀 프로젝트 

## 📌 프로젝트 소개
- **프로젝트명**: RACL
- **팀명**: 빌더스(Builders)
- **개발 기간**: 2025.11.07 ~ 2025.11.14
- **주요 기능**: WMS 창고관리 (의류 중심)
- **기술 스택**:
  - **Frontend**:
    - HTML5 / CSS3
    - JavaScript (ES6+)
    - jQuery 3.x
    - Bootstrap 5
    - ApexCharts.js
  - **Backend**:
    - Java 17
    - Spring Framework 5.x
    - Spring MVC
    - MyBatis 3.x
    - JSP (JavaServer Pages)
    - Tomcat 9.0
    - HikariCP
    - Gradle
  - **Database**:
    - MySQL 8.x
  - **Tools & Collaboration**:
    - Git
    - GitHub
    - ERD Cloud
    - IntelliJ IDEA

## 👥 팀원
| 역할 | 이름 | GitHub |
|------|------|--------|
| 팀장 | 엄현석 | [@heathcliff4736](https://github.com/heathcliff4736) |
| Git Master | 김형근 | [@geeunii](https://github.com/geeunii) |
| 팀원 | 박용헌 | [@00parkyh](https://github.com/00parkyh) |
| 팀원 | 김도윤 | [@doyooning](https://github.com/doyooning) |
| 팀원 | 장현우 | [@fsdawer](https://github.com/fsdawer) |
| 팀원 | 이재훈 | [@jaehoon0321](https://github.com/jaehoon0321) |

---

## 🌿 브랜치 전략

### 브랜치 구조
```
main (배포용 - 최종 완성본만)
  ↑
develop (개발 통합 - 작업 중인 코드)
  ↑
dev/개인 branch (개인 작업 브랜치)
```

### 브랜치 네이밍 규칙
```bash
dev/개인 branch        # 예: dev/KHG
fix/버그명-이름        # 예: fix/signup-bug-KHG
docs/문서명-이름       # 예: docs/readme-update-KHG
refactor/대상-이름     # 예: refactor/api-KHG
```

---

## 📝 커밋 메시지 규칙

### 타입
| 타입 | 설명 |
|------|------|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `docs` | 문서 수정 |
| `style` | 코드 포맷팅 (기능 변경 없음) |
| `refactor` | 코드 리팩토링 |
| `test` | 테스트 코드 |
| `chore` | 빌드, 설정 파일 수정 |

### 작성 예시
```bash
git commit -m "feat: 사용자 로그인 API 구현"
git commit -m "fix: 회원가입 시 이메일 중복 체크 버그 수정"
git commit -m "docs: API 명세서 업데이트"
```

---

## 🔄 작업 프로세스

### 1️⃣ 작업 시작
```bash
git checkout develop
git pull origin develop
git checkout dev/KHG(개인 브랜치)
--- 또는 ---
git fetch origin
git merge origin develop
```

### 2️⃣ 작업 & 커밋
```bash
# 파일 수정 후...
git add .
git commit -m "feat: 로그인 페이지 구현"
git push origin dev/KHG(개인 브랜치)
```

### 3️⃣ PR 생성 (GitHub)
1. **Pull requests** 탭 → **New pull request**
2. `base: develop` ← `compare: dev/KHG(개인 브랜치)`
3. 제목/설명 작성 (템플릿 활용)
4. **Reviewers** 최소 1명 지정
5. **Create pull request** 클릭

### 4️⃣ 리뷰 & Merge
- 리뷰어 1명 이상 **Approve** 필요
- 충돌 해결 후 Merge
- Merge 후 브랜치 자동 삭제

### 5️⃣ Merge 후 정리
```bash
git checkout develop
git pull origin develop
git branch -d dev/KHG(개인 브랜치)
```

---

## 👀 코드 리뷰 규칙

- **리뷰 기한**: PR 생성 후 24시간 이내
- **최소 인원**: 1명 이상 Approve
- **리뷰 태도**:
  - 💡 제안: 더 나은 방법 제시
  - ❓ 질문: 궁금한 점
  - ⚠️ 수정 필요: 명확한 이유와 함께
  - ✅ LGTM: Looks Good To Me!

---

## 🔨 충돌 해결 방법

### 충돌 발생 시
```bash
# 1. develop 최신화
git checkout develop
git pull origin develop

# 2. 내 브랜치로 돌아와서 병합
git checkout dev/KHG(개인 브랜치)
git merge develop

# 3. 충돌 파일 수정 (VS Code에서 쉽게 가능)

# 4. 해결 후 커밋
git add .
git commit -m "chore: merge conflict 해결"
git push origin dev/KHG(개인 브랜치)
```

### VS Code에서 충돌 해결
- `Accept Current Change` (내 코드)
- `Accept Incoming Change` (다른 사람 코드)
- `Accept Both Changes` (둘 다)
- 또는 직접 수정

---

## ⚠️ 주의사항

### ❌ 절대 금지
- `main`, `develop` 브랜치에 직접 push
- 다른 사람 브랜치에 push

### ✅ 꼭 지키기
- 작업 시작 전 항상 `git pull origin develop`
- 충돌 발생 시 팀원과 즉시 소통
- PR은 작은 단위로 자주
- 커밋 메시지 규칙 준수

---

## 🚨 긴급 상황

### Hotfix가 필요한 경우
```bash
git checkout main
git checkout -b hotfix/버그명-이름
# 수정 후
git push origin hotfix/버그명-이름
# main과 develop 모두에 PR 생성
```

---

## 🔧 개발 환경 설정

### 최초 1회 설정
```bash
# 1. 저장소 클론

# 2. Git 사용자 정보 설정
git config user.name "홍길동"
git config user.email "gildong@example.com"

# 3. 의존성 설치
npm install  # 또는 필요한 설치 명령어
```

---

**마지막 업데이트**: 2025.11.12
