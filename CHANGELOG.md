# Changelog

형식 [Keep a Changelog](https://keepachangelog.com/ko/1.1.0/) · 버전 [SemVer](https://semver.org/lang/ko/).

## [2.0.0] - 2026-11-17

### Changed

- 기록 단위 유형: 횡단 → 공통
- 릴레이션: 토층단면도 → 기준층위 · 층위 → 토층 · 복합토질 → 혼입요소 · 층위관계 → 층서관계 · 매핑_구획_단면도 → 매핑_구획_기준층위 · 매핑_유구_층위 → 매핑_유구_층서 · 변경기록 → 기록변경로그 (관련 식별자 · 속성명 동반 변경)
- 속성: 추정시기_cd → 현장편년_cd · 공간좌표 → 공간좌표_구역 · 공간좌표_유구 · 공간좌표_유물 · 조사원 → 조사자(유구 · 유물) · 비고 → 기타(사업단위 · 유구) · 고유속성.유구시설ID → 시설ID
- 유물부위.재질_cd 의 코드그룹: 태토 → 재질. 태토는 고유속성으로 적재
- 기록변경로그의 속성 구성: 시각 · 테이블 · 키 · 이름 · 컬럼 · 이전값 · 이후값 · 변경자 · 사유
- 조사자료의 주대상 CHECK: 1개 → 1개 이하
- DDL: PostgreSQL → 표준 SQL. 제약 조건을 CREATE TABLE 에 선언
- 코드그룹 목록을 데이터 사전에 통합

### Added

- 사업단위.책임조사원 · 토층.토층번호 · 유구시설.시설형태_cd · 면_cd(문양 · 표면흔적 · 제작속성)
- 측정.유물ID · 문양ID · 과학분석.측정값_하한 · 측정값_상한
- 조사자료.분석ID · 촬영일자 · 촬영자 · 촬영구분_cd · 캡션
- CHECK: 측정(대상 1개) · 시료(채취 대상 1개 이상)
- 복합 FK: 유물 (유구ID, 구획ID) → 매핑_유구_구획

### Removed

- 조사원(토층 · 유구시설) · 유물부위.내면/외면 · 매핑_유구_구획.비고 · 측정.비고 · 조사자료.등록자 · 비고
- `schema/schema.dbml` · `docs/code-groups.md` · `tools/`

## [1.0.0] - 2026-09-14

- 30 릴레이션 논리 스키마 · PostgreSQL DDL · 데이터 사전 · ERD · 코드그룹 목록

[2.0.0]: https://github.com/mch5153/excavation-record-schema/releases/tag/v2.0.0
[1.0.0]: https://github.com/mch5153/excavation-record-schema/releases/tag/v1.0.0
