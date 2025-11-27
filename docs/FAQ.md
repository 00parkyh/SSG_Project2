# ❓ Git/GitHub 자주 묻는 질문 (FAQ)

---

### Q1: 실수로 `develop` (또는 `main`) 브랜치에 커밋했습니다. 어떻게 되돌리나요?

**A:** 아직 `push` 하지 않았다면, 안전하게 되돌릴 수 있습니다.

1.  **새 브랜치 생성:** 현재 커밋을 기반으로 올바른 브랜치를 만듭니다.
    ```bash
    git checkout -b dev/내-기능-브랜치
    ```
2.  **`develop` 브랜치 원상복구:** `develop` 브랜치로 돌아가서 원격(origin)의 상태로 되돌립니다.
    ```bash
    git checkout develop
    git reset --hard origin/develop
    ```
3.  이제 `dev/내-기능-브랜치`에서 작업을 계속하고 PR을 올리시면 됩니다.

> **⚠️ 경고:** 이미 `push` 했다면 절대 `reset --hard`를 사용하지 말고, 즉시 Git Master에게 도움을 요청하세요!

---

### Q2: 방금 한 커밋 메시지에 오타가 있습니다. 수정하고 싶어요.

**A:** 아직 `push` 하기 전이라면 간단하게 수정할 수 있습니다.

```bash
git commit --amend
````

Vim 또는 설정된 에디터가 열리면 커밋 메시지를 수정한 후 저장하고 닫으세요.

> **💡 팁:** 메시지만 수정하고 싶다면 `-m` 옵션을 사용하세요.
> `git commit --amend -m "feat: 로그인 기능 진짜 완료"`

-----

### Q3: 방금 한 로컬 커밋을 취소하고 싶습니다. (파일 변경 사항은 남기고)

**A:** `soft reset`을 사용하여 커밋 기록만 취소할 수 있습니다.

```bash
# 가장 최근의 커밋 1개를 취소 (파일 변경 내용은 Staged 상태로 보존)
git reset --soft HEAD~1
```

  * `HEAD~1`은 "현재로부터 1개 이전의 커밋"을 의미합니다.
  * 이제 파일들은 "Changes to be committed" (Staged) 상태로 돌아가므로, 다시 수정하거나 커밋할 수 있습니다.

-----

### Q4: `develop` 브랜치의 최신 변경 사항을 제 브랜치에 반영하고 싶습니다.

**A:** `CONFLICT_GUIDE.md`에서 배운 `merge`를 사용하면 됩니다.

1.  `develop` 브랜치를 최신 상태로 업데이트합니다.
    ```bash
    git checkout develop
    git pull origin develop
    ```
2.  내 작업 브랜치로 돌아와서 `develop`을 병합합니다.
    ```bash
    git checkout dev/개인 브랜치
    git merge develop
    ```
3.  충돌이 발생하면 `CONFLICT_GUIDE.md`를 참고하여 해결하고, `push` 합니다.
    ```bash
    # 충돌 해결 후
    git push origin dev/개인 브랜치
    ```

-----

### Q5: `git pull`과 `git fetch`의 차이가 무엇인가요?

**A:** 둘 다 원격 저장소의 최신 정보를 가져오지만, 로컬 코드에 적용하는 방식이 다릅니다.

  * **`git fetch`**: 원격 저장소의 최신 이력(커밋)을 **가져오기만** 합니다. 내 로컬 브랜치에는 **아무런 변경도 일어나지 않습니다.**

      * *예: "새로운 버전이 나왔는지 확인만 할게."*
      * 이후 `git merge origin/develop`처럼 수동으로 병합해야 합니다.

  * **`git pull`**: `git fetch` + `git merge`입니다. 원격 저장소의 최신 이력을 가져온 후, **즉시** 현재 내 브랜치와 \*\*병합(merge)\*\*합니다.

      * *예: "새 버전 확인하고 바로 내 코드에 합쳐버릴게."*
      * 팀 작업 시에는 `pull`이 가장 간편하지만, 충돌이 바로 발생할 수 있습니다.

-----

### Q6: 실수로 브랜치를 삭제했습니다. 복구할 수 있나요?

**A:** `git reflog`를 사용하면 최근 작업 내역을 보고 복구할 수 있습니다.

1.  `reflog`로 삭제된 브랜치의 마지막 커밋 해시(hash)를 찾습니다.
    ```bash
    git reflog
    # 출력 예시
    # b1a2c3d HEAD@{1}: commit: 로그인 기능 완료
    # a4b5c6e HEAD@{2}: checkout: moving from dev/login to develop
    ```
2.  복구하려는 커밋 해시(예: `b1a2c3d`)를 찾아 새 브랜치로 생성합니다.
    ```bash
    git checkout -b dev/복구된-로그인-브랜치 b1a2c3d
    ```

-----

### Q7: PR(Pull Request)을 올렸는데, "Squash and Merge"가 뭔가요?

**A:** "Squash and Merge"는 \*\*"압축하여 병합하기"\*\*입니다.

  * 여러분이 기능 브랜치에서 작업하며 `commit1`, `commit2`, `commit3`... 이렇게 여러 개의 커밋을 만들었을 것입니다.
  * 이것을 `develop` 브랜치에 병합할 때, "Squash"를 하면 이 모든 커밋이 **단 하나의 커밋**으로 합쳐져서 병합됩니다.
  * **이점:** `develop` 브랜치의 히스토리가 "로그인 기능 완료", "회원가입 기능 완료"처럼 기능 단위로 깔끔하게 유지됩니다.

여러분의 PR이 승인(Approve)되면 Git Master가 "Squash and Merge" 버튼을 눌러 병합을 완료합니다.

````
