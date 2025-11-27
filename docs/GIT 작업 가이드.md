# 📘 Git 작업 상세 가이드

## 목차
1. [최초 설정](#최초-설정)
2. [일상 작업 흐름](#일상-작업-흐름)
3. [PR 작성 및 리뷰](#pr-작성-및-리뷰)
4. [브랜치 관리](#브랜치-관리)

---

## 최초 설정

### 1. Git 사용자 정보 설정
```bash
git config --global user.name "홍길동"
git config --global user.email "gildong@example.com"

# 확인
git config --list
```

### 2. 저장소 클론
```bash
https://github.com/SSG-2nd-2team/팀 깃헙 레포지토리.git

# 현재 브랜치 확인 (develop이어야 함)
git branch
```

### 3. .gitignore 설정
**Node.js 프로젝트:**
```gitignore
node_modules/
.env
.env.local
dist/
build/
*.log
.DS_Store
```

**Java 프로젝트:**
```gitignore
target/
*.class
*.jar
.idea/
*.iml
```

---

## 일상 작업 흐름

### 🌅 매일 아침 루틴
```bash
# 1. develop 최신화
git checkout develop
git pull origin develop

# 2. 내 브랜치가 있다면 병합
git checkout dev/개인 branch
git merge develop
```

### 📝 새 작업 시작
```bash
# 1. develop에서 최신 코드 받기
git checkout develop
git pull origin develop

# 2. 새 브랜치 생성
git checkout -b dev/개인 branch

# 3. 작업하기
# 파일 수정...

# 4. 변경사항 확인
git status
git diff

# 5. 커밋
git add .
git commit -m "feat: 로그인 페이지 UI 구현"

# 6. 푸시
git push origin dev/개인 branch
```

### 🔄 작업 중간에 develop 업데이트된 경우
```bash
# 현재 작업 커밋
git add .
git commit -m "feat: 작업 진행 중"

# develop 최신화
git checkout develop
git pull origin develop

# 내 브랜치로 돌아와서 병합
git checkout dev/개인 branch
git merge develop

# 충돌이 있다면 해결 후
git add .
git commit -m "chore: develop 병합"
git push
```

### 💾 작업 임시 저장 (stash)
```bash
# 긴급하게 다른 작업이 필요할 때
git stash

# 다른 브랜치로 이동해서 작업
git checkout develop
# ... 긴급 작업 ...

# 원래 브랜치로 돌아와서 복구
git checkout dev/개인 branch
git stash pop
```

---

## PR 작성 및 리뷰

### 📝 PR 제목 작성법
```
feat: 사용자 로그인 기능 구현
fix: 회원가입 시 이메일 중복 체크 버그 수정
docs: API 명세서에 로그인 엔드포인트 추가
refactor: 인증 로직 함수 분리
style: 코드 포맷팅 적용
test: 로그인 API 단위 테스트 추가
chore: ESLint 설정 파일 추가
```

### 📋 PR 템플릿 활용
```markdown
## 📝 작업 내용
- 로그인 페이지 UI 구현 (HTML/CSS)
- JWT 토큰 기반 인증 API 연동
- 로컬스토리지에 토큰 저장

## 🔗 관련 이슈
- Closes #12

## ✅ 체크리스트
- [x] 코드가 정상적으로 동작합니다
- [x] 커밋 메시지 규칙을 준수했습니다
- [x] 충돌을 해결했습니다

## 💬 특이사항
- 비밀번호는 최소 8자 이상으로 제한
```

### 👀 코드 리뷰하기
1. **PR 페이지 → Files changed 탭**
2. **코드 라인에 마우스 오버 → + 버튼**
3. **댓글 작성**
   - 💡 제안: "이렇게 하면 더 좋을 것 같아요"
   - ❓ 질문: "이 부분은 왜 이렇게 했나요?"
   - ⚠️ 수정 필요: "이 부분은 버그가 있을 수 있어요"
   - ✅ LGTM: "좋습니다!"
4. **Review changes 클릭**
   - Comment (의견만)
   - Approve (승인)
   - Request changes (수정 요청)

### 🔧 리뷰 반영하기
```bash
# 파일 수정 후
git add .
git commit -m "fix: 리뷰 반영 - 변수명 명확하게 수정"
git push

# GitHub PR에 자동 반영됨
```

---

## 브랜치 관리

### 브랜치 확인
```bash
# 로컬 브랜치 목록
git branch

# 원격 브랜치 포함 전체 목록
git branch -a

# 현재 브랜치 확인
git branch --show-current
```

### 브랜치 삭제
```bash
# 로컬 브랜치 삭제
git branch -d dev/개인 branch

# 강제 삭제 (병합 안 된 경우)
git branch -D dev/개인 branch

# 원격 브랜치 삭제
git push origin --delete dev/개인 branch
```

### 브랜치 이름 변경
```bash
# 로컬 브랜치 이름 변경
git branch -m 잘못된이름 올바른이름

# 원격에 반영
git push origin --delete 잘못된이름
git push origin 올바른이름
```

---

## 유용한 Git 명령어

### 히스토리 확인
```bash
# 커밋 로그 보기
git log

# 한 줄로 보기
git log --oneline

# 그래프로 보기
git log --oneline --graph --all

# 최근 5개만
git log -5
```

### 변경사항 확인
```bash
# 현재 상태
git status

# 변경된 내용 상세히
git diff

# 스테이징된 내용
git diff --staged
```

### 특정 커밋으로 이동
```bash
# 특정 커밋 보기
git show <커밋해시>

# 특정 커밋으로 이동 (읽기 전용)
git checkout <커밋해시>

# 다시 최신으로
git checkout develop
```

---

## GitHub Desktop 사용법

### 기본 작업
1. **File → Clone repository** (최초 1회)
2. **Current branch → New branch** (브랜치 생성)
3. 파일 수정
4. 좌측에서 변경사항 확인
5. **Summary** 입력 (커밋 메시지)
6. **Commit to dev/개인 브랜치명**
7. **Push origin**
8. GitHub 웹에서 PR 생성

### 장점
- 시각적으로 변경사항 확인 쉬움
- 충돌 해결 UI 제공
- 명령어 외울 필요 없음

---

## 추가 팁

### 커밋을 잘게 나누기
```bash
# 특정 파일만 스테이징
git add login.js
git commit -m "feat: 로그인 API 연동"

git add login.css
git commit -m "style: 로그인 페이지 스타일링"
```

### 커밋 메시지 수정
```bash
# 마지막 커밋 메시지 수정 (push 전)
git commit --amend -m "새로운 메시지"

# push 후에는 수정하지 말 것!
```

### 원격 저장소 확인
```bash
# 원격 저장소 목록
git remote -v

# 원격 브랜치 최신화
git fetch origin

# 오래된 원격 브랜치 정리
git remote prune origin
```
