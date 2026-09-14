# Changelog

이 저장소의 모든 눈에 띄는 변경을 기록한다. 형식은 [Keep a Changelog](https://keepachangelog.com/ko/1.1.0/), 버전은 [Semantic Versioning](https://semver.org/lang/ko/) 을 따른다.

## [1.0.0] - 2026-09-14

논문 부록으로 공개하는 최초 판.

### Added
- `schema/schema.dbml` — 30 릴레이션 논리 스키마 (공간·층서 8 · 유구·유물 14 · 공통 기록 4 · 어휘 통제·시소러스 3 · 기록의 변경 1). 참조 95건(구조 참조 51 · 코드사전 참조 44)을 모두 선언.
- `schema/schema.sql` — DBML 에서 생성한 PostgreSQL DDL. 고유속성 · 조사자료 · 과학분석의 배타적 아크를 CHECK 로 강제.
- `docs/data-dictionary.md` · `docs/erd.md` · `docs/code-groups.md` — 데이터 사전, ERD 3매(논문 그림 1~3), 코드그룹 목록.
- `tools/build_docs.js` — DBML 에서 위 파생 산출물을 생성하는 스크립트.
- `CITATION.cff`, `LICENSE` (CC BY 4.0).

[1.0.0]: https://github.com/mch5153/excavation-record-schema/releases/tag/v1.0.0
