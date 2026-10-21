# 보안 점검 구성

이 저장소는 public 저장소에서 무료로 제공되는 GitHub 보안 기능만 사용한다. 유료 라이선스(GHAS Code Security/Secret Protection, Code Quality)와 AI 사용량 과금 기능은 켜지 않는다.

## 사용하는 점검

| 점검 | 실행 위치 | 시점 |
| --- | --- | --- |
| CodeQL code scanning (default setup, extended 쿼리) | GitHub 관리 | push, PR, 주 1회 |
| Secret scanning + push protection | GitHub 관리 | 상시 |
| Dependabot alerts / security updates | GitHub 관리 | 상시 |
| Dependabot version updates (`.github/dependabot.yml`) | GitHub 관리 | 주 1회 |
| Dependency review (`security-checks.yml`) | `jhl-space` | 같은 저장소 브랜치의 PR |
| Trivy 저장소 스캔: 취약점·비밀정보·설정 오류 (`security-checks.yml`) | `jhl-space` | push, PR, 주 1회 |
| OpenSSF Scorecard (`security-checks.yml`) | `jhl-space` | main push, 주 1회 |
| 컨테이너 이미지 Trivy 스캔 (`container.yml`) | `jhl-space` | 이미지 발행 시 |

Trivy와 Scorecard 결과는 SARIF로 code scanning에 올려 Security 탭에서 함께 본다.

## 결정 사항

- **조직 보안 구성**: `jhl-labs-public-free` 구성(dependency graph, Dependabot, 비공개 취약점 신고)만 연결한다. code scanning·secret scanning을 조직 구성에 넣으려면 `advanced_security`/`code_security`를 켜야 하고, 이 구성은 저장소가 private로 바뀌면 유료 라이선스를 사용한다. 그래서 두 기능은 저장소 단위 설정으로 켠다.
- **Runner**: 기존 워크플로와 같이 `jhl-space`를 쓴다. fork PR의 코드가 self-hosted runner에서 실행되지 않도록 모든 job에 저장소 조건을 둔다. CodeQL default setup은 GitHub이 관리하는 실행으로 남겨 둔다.
- **Gate**: Trivy는 고칠 수 있는 CRITICAL/HIGH 취약점과 비밀정보만 실패 처리하고, MEDIUM 이상은 보고만 한다. Dependency review는 HIGH 이상을 실패 처리한다.
- **제외**: Copilot Autofix, AI 기반 비밀정보 탐지, Code Quality는 public에서도 AI 사용량이 과금되거나 저장소가 private로 바뀌면 라이선스가 과금되므로 켜지 않는다.
- **Scorecard**: `publish_results: false`로 외부 공개 API에 결과를 게시하지 않고 code scanning에만 올린다.
