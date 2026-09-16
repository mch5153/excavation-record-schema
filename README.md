# excavation-record-schema

고고학 발굴조사 기록의 관계형 논리 스키마 — 경주 월성 발굴조사 자료 사례.
Relational logical schema for archaeological excavation records (Wolseong, Gyeongju, Korea). → [English](#english)

아래 논문의 부록(스키마 명세)이다. 본문에 싣지 않은 전체 릴레이션 · 속성 · 참조 · 어휘 도메인을 담는다.

> 민찬홍. 고고학 원천자료의 구조화된 적재를 위한 데이터베이스 설계 – 월성 발굴조사 자료를 중심으로 –. (게재 정보 추후 갱신)

## 구성

| 경로 | 내용 |
|---|---|
| [`schema/schema.dbml`](schema/schema.dbml) | 논리 스키마 원본 ([DBML](https://dbml.dbdiagram.io)) |
| [`schema/schema.sql`](schema/schema.sql) | PostgreSQL DDL |
| [`docs/data-dictionary.md`](docs/data-dictionary.md) | 데이터 사전 — 릴레이션별 열 · 자료형 · 키 · 참조 |
| [`docs/erd.md`](docs/erd.md) | ERD 3매 (논문 그림 1~3) |
| [`docs/code-groups.md`](docs/code-groups.md) | 코드그룹(어휘 도메인) 목록 |
| [`tools/`](tools/) | DBML → DDL · 문서 생성 |
| [`CHANGELOG.md`](CHANGELOG.md) · [`CITATION.cff`](CITATION.cff) · [`LICENSE`](LICENSE) | 버전 이력 · 인용 · 라이선스 |

## 기본 개념

- **릴레이션** — 같은 종류의 개체를 모은 표. 열은 속성, 행은 개체 하나.
- **기본키(PK)** — 행을 유일하게 가리키는 열. **외래키(FK)** — 다른 릴레이션의 기본키를 참조하는 열. 릴레이션은 이 값으로 연결된다.
- **코드** — 분류 · 상태 같은 값을 자유 입력 대신 어휘 사전(`코드` 릴레이션)에서 고르게 하는 통제. 접미사 `_cd` 열이 코드를 참조한다.
- **기록 단위 4유형** — 독립(단독으로 성립: 유구 · 유물) · 종속(다른 단위에 딸림: 유물부위) · 횡단(여러 단위에 걸침: 측정) · 연관(두 개체 사이의 관계: 유구관계).

## 설계 기준

1. **기록 단위의 설정** — 관찰 · 판정이 귀속되는 단위를 위 4유형으로 나누어 릴레이션으로 세운다.
2. **속성의 분해와 배치** — 명칭 · 서술에 함축된 의미를 속성으로 분해한다. 반복되는 관찰 · 행위는 릴레이션으로, 분류 체계에 따라 늘어나는 세부 속성은 값(`고유속성`)으로 둔다.
3. **기록 값의 통제** — `코드`(계층)와 `코드관계매핑`(연관 · 등가)으로 시소러스를 구현한다.

## 릴레이션 목록 (논문 표 3)

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

## 표기 규약

- 이름은 논문과 같은 한국어. 영문 대역은 데이터 사전에.
- `_cd` 열은 `코드.코드ID` 를 참조. 허용 코드그룹이 도메인. ERD 에서는 이 선을 생략.
- 위계는 자기참조 — `조사구역.상위구역ID` · `유구.상위유구ID` · `코드.상위코드ID`.
- 다대다는 `매핑_*` · `조합개체`, 개체 사이의 관계 사건은 `층위관계` · `유구관계`.
- 배타적 아크(`고유속성` · `조사자료` · `과학분석`)는 Note 와 DDL 의 CHECK.
- 자료형은 논리 수준(varchar · int · float). 식별자 · 날짜는 문자열.
- PoC 구현(Flask + SQLite) 42개 릴레이션 중 논문 범위 30개. 검증 데이터는 미포함.

## 보는 법

- ERD — [`docs/erd.md`](docs/erd.md). 전체 결선은 `schema.dbml` 을 [dbdiagram.io](https://dbdiagram.io) 에 붙여 넣기.
- DDL — `psql -f schema/schema.sql`.
- 재생성 — `cd tools && npm install && npm run build`.

## 버전 · 인용 · 라이선스

- [SemVer](https://semver.org/lang/ko/). 이력은 [`CHANGELOG.md`](CHANGELOG.md). 논문 인용판 **v1.0.0**.
- 인용은 [`CITATION.cff`](CITATION.cff).
- [CC BY 4.0](LICENSE).

## English

Schema appendix of *A Database Design for the Structured Loading of Archaeological Source Data: The Case of the Wolseong Excavation, Gyeongju* (MIN Chanhong).

- 30 relations: spatial units, stratigraphy, features, artifacts, cross-cutting records, controlled vocabulary, change log. Names are in Korean as in the paper; English glosses are in the [data dictionary](docs/data-dictionary.md).
- Source of truth: `schema/schema.dbml`. Generated: `schema/schema.sql` (PostgreSQL), `docs/erd.md`, `docs/data-dictionary.md`.
- Columns suffixed `_cd` reference `코드.코드ID`; the permitted code group is the domain. Hierarchies use self-references; many-to-many uses `매핑_*` tables; exclusive arcs are CHECK constraints in the DDL.
- License CC BY 4.0. Citation in `CITATION.cff`.
