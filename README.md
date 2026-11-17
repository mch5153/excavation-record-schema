# excavation-record-schema

고고학 발굴조사 기록의 관계형 논리 스키마 — 경주 월성 발굴조사 자료 · [English](#english)

> 민찬홍. 고고학 원천자료의 구조화된 적재를 위한 데이터베이스 설계 – 월성 발굴조사 자료를 중심으로 –. (게재 정보 추후 갱신)

## 구성

| 경로 | 내용 |
|---|---|
| [`schema/schema.sql`](schema/schema.sql) | DDL (표준 SQL) |
| [`docs/data-dictionary.md`](docs/data-dictionary.md) | 데이터 사전 — 속성 · 자료형 · 키 · 참조 · 제약 조건 · 코드그룹 |
| [`docs/erd.md`](docs/erd.md) | ERD |
| [`CHANGELOG.md`](CHANGELOG.md) · [`CITATION.cff`](CITATION.cff) · [`LICENSE`](LICENSE) | 변경 이력 · 인용 정보 · 라이선스 |

## 범위

- 릴레이션 30개 · 속성 141개(키 제외) — 논문 표 3 · 표 4
- 제외: 시스템 운영 · 부가 릴레이션과 속성, 적재 자료, 코드값

## 릴레이션

| 기록 단위 | 범주 | 릴레이션 |
|---|---|---|
| 독립 | 공간·층서 | 사업단위 · 조사구역 · 발굴구획 · 기준층위 · 토층 |
| 독립 | 유구·유물 | 유구 · 유물 · 유물조합 |
| 독립 | 어휘 통제 | 코드 |
| 종속 | 공간·층서 | 혼입요소 |
| 종속 | 유구·유물 | 유구시설 · 유물부위 · 형태요소 · 문양 · 표면흔적 · 제작속성 · 명문 |
| 공통 | 공통 기록 | 측정 · 시료 · 과학분석 · 조사자료 |
| 공통 | 어휘 통제 | 고유속성 |
| 연관 | 공간·층서 | 층서관계 · 매핑_구획_기준층위 |
| 연관 | 유구·유물 | 유구관계 · 조합개체 · 매핑_유구_구획 · 매핑_유구_층서 |
| 연관 | 어휘 통제 | 코드관계매핑 |
| 기타 | 기록 변경 | 기록변경로그 |

## 조회 방법

- ERD: [`docs/erd.md`](docs/erd.md)
- DDL 적용: `sqlite3 <DB 파일> < schema/schema.sql` 또는 `psql -f schema/schema.sql`

## 버전 · 인용 · 라이선스

- 버전: [SemVer](https://semver.org/lang/ko/). 현재 **v2.0.0**
- 인용: [`CITATION.cff`](CITATION.cff)
- 라이선스: [CC BY 4.0](LICENSE)

## English

Relational logical schema for archaeological excavation records; schema appendix of *A Database Design for the Structured Loading of Archaeological Source Data: The Case of the Wolseong Excavation, Gyeongju* (MIN Chanhong).

- 30 relations, 141 non-key attributes. Relation and attribute names are in Korean as in the paper; English relation names are given in the [data dictionary](docs/data-dictionary.md).
- `schema/schema.sql` — DDL (standard SQL) · `docs/data-dictionary.md` — data dictionary · `docs/erd.md` — ERD.
- Attributes suffixed `_cd` reference `코드.코드ID`; the permitted code group is the domain.
- License CC BY 4.0. Citation: `CITATION.cff`.
