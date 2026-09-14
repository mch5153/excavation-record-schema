# excavation-record-schema

고고학 발굴조사 기록의 구조화된 적재를 위한 관계형 논리 스키마 — 경주 월성 발굴조사 자료 사례.
Relational logical schema for archaeological excavation records, developed from the Wolseong site case study (Gyeongju, Korea). → [English summary](#english-summary)

이 저장소는 아래 논문의 **부록(스키마 명세)** 입니다. 본문은 설계 기준과 대표 릴레이션을 다루고, 전체 릴레이션 · 속성 · 참조 관계 · 어휘 도메인은 여기에 수록합니다.

> 민찬홍. 고고학 원천자료의 구조화된 적재를 위한 데이터베이스 설계 – 월성 발굴조사 자료를 중심으로 –. *(게재 정보는 확정 후 갱신)*

## 구성

| 경로 | 내용 |
|---|---|
| [`schema/schema.dbml`](schema/schema.dbml) | **원본(source of truth)** — 30 릴레이션의 논리 스키마, [DBML](https://dbml.dbdiagram.io) 표기 |
| [`schema/schema.sql`](schema/schema.sql) | PostgreSQL DDL — DBML 에서 생성, 배타적 아크 CHECK 포함 |
| [`docs/data-dictionary.md`](docs/data-dictionary.md) | 데이터 사전 — 릴레이션별 열 · 자료형 · 키 · 참조 · 설명 |
| [`docs/erd.md`](docs/erd.md) | ERD 3매 (논문 그림 1~3 대응) — GitHub 에서 바로 렌더링 |
| [`docs/code-groups.md`](docs/code-groups.md) | 코드그룹(어휘 도메인) 목록과 시소러스 대응 |
| [`tools/`](tools/) | DBML → DDL · 데이터 사전 · ERD 생성 스크립트 |
| [`CHANGELOG.md`](CHANGELOG.md) · [`CITATION.cff`](CITATION.cff) | 버전 이력 · 인용 정보 |

## 스키마 개요

발굴조사 과정에서 최초로 생산되는 원천 기록을 기계가 읽을 수 있는 구조로 적재하기 위한 논리 스키마입니다. 관계형 모델에 기반하며, 세 가지 설계 기준으로 구조화했습니다.

1. **기록 단위의 설정** — 관찰과 판정이 귀속되는 단위를 참조 성격에 따라 독립 · 종속 · 횡단 · 연관의 네 유형으로 나누어 릴레이션으로 세움
2. **속성의 분해와 배치** — 명칭과 서술에 함축된 의미를 속성으로 분해하고, 반복되는 관찰 · 행위는 릴레이션(스키마 층위)으로, 분류 체계에서 파생되는 세부 속성은 값(코드 층위, `고유속성`)으로 배치
3. **기록 값의 통제** — 코드사전(`코드`)과 코드 간 규칙(`코드관계매핑`)으로 시소러스의 계층 · 연관 · 등가 관계를 구현

### 릴레이션 목록 (논문 표 3)

| 단위유형 | 범주 | 릴레이션 |
|---|---|---|
| 독립 | 공간·층서 | 사업단위 · 조사구역 · 발굴구획 · 토층단면도 · 층위 |
| 독립 | 유구·유물 | 유구 · 유물 · 유물조합 |
| 독립 | 어휘 통제·시소러스 | 코드 |
| 종속 | 공간·층서 | 복합토질 |
| 종속 | 유구·유물 | 유구시설 · 유물부위 · 형태요소 · 문양 · 표면흔적 · 제작속성 · 명문 |
| 횡단 | 공통 기록 | 측정 · 시료 · 과학분석 · 조사자료 |
| 횡단 | 어휘 통제·시소러스 | 고유속성 |
| 연관 | 공간·층서 | 층위관계 · 매핑_구획_단면도 |
| 연관 | 유구·유물 | 유구관계 · 조합개체 · 매핑_유구_구획 · 매핑_유구_층위 |
| 연관 | 어휘 통제·시소러스 | 코드관계매핑 |
| 기타 | 기록의 변경 | 변경기록 |

- **독립** 단독으로 참조되는 개체 집합 · **종속** 다른 단위를 참조해야 식별되는 집합 · **횡단** 참조 대상이 여러 단위에 걸친 집합 · **연관** 두 개체 사이에서만 성립하는 관계

### 표기 규약

- 릴레이션 · 열 이름은 논문과 같은 한국어 명칭을 그대로 씁니다. 영문 대역은 [데이터 사전](docs/data-dictionary.md)에 있습니다.
- 접미사 `_cd` 를 가진 열은 모두 `코드.코드ID` 를 참조합니다. 허용되는 코드그룹이 곧 그 열의 도메인이며([코드그룹 목록](docs/code-groups.md)), ERD 에서는 이 참조선을 생략해 그립니다.
- 위계는 자기참조로 표현합니다 — `조사구역.상위구역ID`, `유구.상위유구ID`, `코드.상위코드ID`. 릴레이션을 늘리지 않고 분화를 수용합니다.
- 다대다 관계는 `매핑_*` · `조합개체` 릴레이션으로, 개체 사이의 관계 사건은 `층위관계` · `유구관계` 로 독립시켰습니다.
- 여러 부모 가운데 하나를 택하는 배타적 아크(`고유속성` · `조사자료` · `과학분석`)는 DBML 의 Note 와 DDL 의 CHECK 로 적었습니다.
- 자료형은 논리 수준(`varchar` · `int` · `float`)이며, 식별자와 날짜는 문자열입니다. 물리 설계(색인 · 저장 방식)는 범위 밖입니다.

## 보는 법

- **ERD** — [`docs/erd.md`](docs/erd.md) 를 열면 GitHub 이 Mermaid 도표를 그려 줍니다. 전체 결선을 한 장으로 보려면 [dbdiagram.io](https://dbdiagram.io) 에 `schema/schema.dbml` 내용을 붙여 넣습니다.
- **DDL 적용** — PostgreSQL 에서 `psql -f schema/schema.sql`. 다른 DBMS 는 `@dbml/cli` 의 `dbml2sql schema/schema.dbml --mysql` 등으로 변환합니다.
- **파생 문서 재생성** — `schema.dbml` 을 고친 뒤 `cd tools && npm install && npm run build`.

## 구현과의 관계

이 스키마는 개념증명(PoC) 정보시스템(Flask + SQLite)으로 구현해 입력 · 조회 · 집계를 검증했습니다. 구현 스키마 42개 릴레이션 가운데 시스템 운영용 12개를 제외한 30개가 여기에 실린 논문 범위이며, 운영용 열(파일 해시 · 썸네일 등)도 생략했습니다. 명칭은 논문을 기준으로 하므로 구현체의 물리 명칭과 다를 수 있습니다. 검증에 쓴 데이터는 포함하지 않습니다.

## 버전

[Semantic Versioning](https://semver.org/lang/ko/) 을 따릅니다 — 기존 데이터 · 참조를 깨는 변경은 MAJOR, 릴레이션 · 열의 추가는 MINOR, 설명 · 문서 수정은 PATCH. 이력은 [`CHANGELOG.md`](CHANGELOG.md), 논문이 인용하는 판은 **v1.0.0** 입니다. 스키마는 후속 연구에 따라 보완 · 확장될 수 있으며, 제안은 [Issues](https://github.com/mch5153/excavation-record-schema/issues) 로 받습니다.

## 인용

[`CITATION.cff`](CITATION.cff) 를 참조하십시오 (GitHub 의 "Cite this repository" 버튼).

```
민찬홍. 고고학 원천자료의 구조화된 적재를 위한 데이터베이스 설계 – 월성 발굴조사 자료를 중심으로 –.
스키마 부록: https://github.com/mch5153/excavation-record-schema (v1.0.0)
```

## 라이선스

[CC BY 4.0](LICENSE) — 출처를 밝히면 자유롭게 이용 · 수정 · 재배포할 수 있습니다.

---

## English summary

This repository is the **schema appendix** of the paper *A Database Design for the Structured Loading of Archaeological Source Data: The Case of the Wolseong Excavation, Gyeongju* (MIN Chanhong). It publishes the full logical schema that the paper describes only in part.

- **What** — a relational logical schema of 30 relations for archaeological primary records produced during excavation (spatial units, stratigraphy, features, artifacts, cross-cutting records, controlled vocabulary, change log). Relation and column names are in Korean, as in the paper; English glosses are given in the [data dictionary](docs/data-dictionary.md).
- **Design principles** — (1) recording units classified by their reference pattern into independent, dependent, cross-cutting and associative units; (2) decomposition of compound terms into attributes, with recurring observations placed at schema level and class-specific attributes at code level (`고유속성`, an entity–attribute–value relation); (3) vocabulary control through a self-referencing code table (`코드`) and code-to-code rules (`코드관계매핑`) that implement thesaurus hierarchy, association and equivalence.
- **Files** — `schema/schema.dbml` (source of truth, [DBML](https://dbml.dbdiagram.io)), `schema/schema.sql` (generated PostgreSQL DDL), `docs/erd.md` (Mermaid ER diagrams matching Figures 1–3 of the paper), `docs/data-dictionary.md`, `docs/code-groups.md`.
- **Conventions** — every column suffixed `_cd` references `코드.코드ID`; the permitted code group is the column's domain. Hierarchies use self-references; many-to-many relations use `매핑_*` tables; exclusive arcs are enforced by CHECK constraints in the DDL.
- **License** — CC BY 4.0. Please cite the paper and this repository (see `CITATION.cff`).
