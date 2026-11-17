# 데이터 사전

릴레이션 43개 — 논문 대상 30개(속성 141개, 키 · 운영 속성 제외) · 시스템 운영 · 부가 13개. 스키마 v2.0.0.

- 키: `PK` 기본키 · `FK` 외래키 · `NN` NOT NULL
- 참조: `코드(X)` 는 `코드.코드ID` 참조, 허용 범위는 코드그룹 X
- 자료형: 논리 자료형. 식별자 · 일자는 `varchar`

## 공간·층서

### 사업단위

Project · 독립 단위 · 발굴조사 사업 단위

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 조사ID | varchar | PK |  |
| 사업명 | varchar |  |  |
| 조사차수 | varchar |  |  |
| 조사성격_cd | int | FK | 코드(조사성격) |
| 소재지 | varchar |  |  |
| 조사면적 | float |  |  |
| 발굴허가번호 | varchar |  |  |
| 조사시작일 | varchar |  |  |
| 조사종료일 | varchar |  |  |
| 조사기관 | varchar |  |  |
| 조사단장 | varchar |  |  |
| 책임조사원 | varchar |  |  |
| 기타 | varchar |  |  |

### 조사구역

Zone · 독립 단위 · 조사 구역. 위계는 상위구역ID 자기참조

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 구역ID | varchar | PK |  |
| 조사ID | varchar | FK | 사업단위.조사ID |
| 상위구역ID | varchar | FK | 조사구역.구역ID |
| 구역명 | varchar |  |  |
| 유적성격_cd | int | FK | 코드(유적성격) |
| 공간좌표_구역 | varchar |  |  |
| 조사원 | varchar |  |  |
| 비고 | varchar |  |  |

### 발굴구획

Grid · 독립 단위 · 그리드 · 트렌치 등 발굴 구획

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 구획ID | varchar | PK |  |
| 구역ID | varchar | FK | 조사구역.구역ID |
| 구획구분_cd | int | FK | 코드(구획구분) |
| 구획명 | varchar |  |  |
| 구획일자 | varchar |  |  |
| 조사원 | varchar |  |  |
| 비고 | varchar |  |  |

### 기준층위

Reference section · 독립 단위 · 기준 토층 단면

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 기준층위ID | varchar | PK |  |
| 기준층위명 | varchar |  |  |
| 비고 | varchar |  |  |

### 토층

Stratum · 독립 단위 · 기준층위에 속한 개별 토층

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 토층ID | varchar | PK |  |
| 기준층위ID | varchar | FK | 기준층위.기준층위ID |
| 토층명 | varchar |  |  |
| 토층번호 | varchar |  |  |
| 토층구분_cd | int | FK | 코드(토층분류) |
| 현장편년_cd | int | FK | 코드(시기) |
| 토색_cd | int | FK | 코드(먼셀토색) |
| 토질_cd | int | FK | 코드(토질) |
| 입도_cd | int | FK | 코드(입도) |
| 비고 | varchar |  |  |

### 혼입요소

Inclusion · 종속 단위 · 토층의 혼입물

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 포함물ID | varchar | PK |  |
| 토층ID | varchar | FK | 토층.토층ID |
| 포함물_cd | int | FK | 코드(포함물) |
| 비고 | varchar |  |  |

- UNIQUE (토층ID, 포함물_cd)

### 층서관계

Stratigraphic relation · 연관 단위 · 토층 간 층서 관계

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 관계ID | int | PK |  |
| 기준층서ID | varchar | FK | 토층.토층ID |
| 대상층서ID | varchar | FK | 토층.토층ID |
| 관계유형_cd | int | FK | 코드(층서관계유형) |
| 비고 | varchar |  |  |

- UNIQUE (기준층서ID, 대상층서ID, 관계유형_cd)

### 매핑_구획_기준층위

Grid–section mapping · 연관 단위 · 발굴구획 – 기준층위 N:M

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 매핑ID | int | PK |  |
| 구획ID | varchar | FK | 발굴구획.구획ID |
| 기준층위ID | varchar | FK | 기준층위.기준층위ID |
| 비고 | varchar |  |  |

- UNIQUE (구획ID, 기준층위ID)

## 유구·유물

### 유구

Feature · 독립 단위 · 유구. 포함 관계는 상위유구ID 자기참조

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 유구ID | varchar | PK |  |
| 구역ID | varchar | FK | 조사구역.구역ID |
| 상위유구ID | varchar | FK | 유구.유구ID |
| 유구명 | varchar |  |  |
| 유구번호 | varchar |  |  |
| 유구분류_cd | int | FK | 코드(유구분류) |
| 현장편년_cd | int | FK | 코드(시기) |
| 공간좌표_유구 | varchar |  |  |
| 평면형태_cd | int | FK | 코드(평면형태) |
| 단면형태_cd | int | FK | 코드(단면형태) |
| 주축방향 | varchar |  |  |
| 잔존상태_cd | int | FK | 코드(유구잔존상태) |
| 조사자 | varchar |  |  |
| 기타 | varchar |  |  |

### 유구시설

Feature facility · 종속 단위 · 유구의 구성 시설

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 시설ID | varchar | PK |  |
| 유구ID | varchar | FK | 유구.유구ID |
| 시설구분_cd | int | FK | 코드(시설구분) |
| 시설형태_cd | int | FK | 코드(평면형태) |
| 재질_cd | int | FK | 코드(재질) |
| 잔존상태_cd | int | FK | 코드(구성요소잔존상태) |
| 수량 | int |  |  |
| 비고 | varchar |  |  |

### 유구관계

Feature relation · 연관 단위 · 유구 간 중첩 · 연접 등의 관계

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 관계ID | int | PK |  |
| 기준유구ID | varchar | FK | 유구.유구ID |
| 대상유구ID | varchar | FK | 유구.유구ID |
| 관계유형_cd | int | FK | 코드(중첩관계) |
| 비고 | varchar |  |  |

- UNIQUE (기준유구ID, 대상유구ID, 관계유형_cd)

### 매핑_유구_구획

Feature–grid mapping · 연관 단위 · 유구 – 발굴구획 N:M

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 매핑ID | int | PK |  |
| 유구ID | varchar | FK | 유구.유구ID |
| 구획ID | varchar | FK | 발굴구획.구획ID |

- UNIQUE (유구ID, 구획ID)

### 매핑_유구_층서

Feature–stratum mapping · 연관 단위 · 유구 – 토층 N:M

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 매핑ID | int | PK |  |
| 유구ID | varchar | FK | 유구.유구ID |
| 토층ID | varchar | FK | 토층.토층ID |
| 관계유형_cd | int | FK | 코드(유구층서관계유형) |
| 비고 | varchar |  |  |

- UNIQUE (유구ID, 토층ID, 관계유형_cd)

### 유물

Artifact · 독립 단위 · 유물

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 유물ID | varchar | PK |  |
| 출토토층ID | varchar | FK | 토층.토층ID |
| 구획ID | varchar | FK | 발굴구획.구획ID |
| 유구ID | varchar | FK | 유구.유구ID |
| 유물명 | varchar |  |  |
| 유물번호 | varchar |  |  |
| 유물분류_cd | int | FK | 코드(유물분류) |
| 현장편년_cd | int | FK | 코드(시기) |
| 출토위치 | varchar |  |  |
| 공간좌표_유물 | varchar |  |  |
| 수량 | int |  |  |
| 잔존상태_cd | int | FK | 코드(유물잔존상태) |
| 수습일자 | varchar |  |  |
| 조사자 | varchar |  |  |
| 비고 | varchar |  |  |

- FK (유구ID, 구획ID) → 매핑_유구_구획 (유구ID, 구획ID)

### 유물부위

Artifact part · 종속 단위 · 유물의 부위. 재질 · 색조 귀속

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 유물부위ID | varchar | PK |  |
| 유물ID | varchar | FK | 유물.유물ID |
| 부위_cd | int | FK | 코드(부위) |
| 재질_cd | int | FK | 코드(재질) |
| 색조_cd | int | FK | 코드(색조) |
| 비고 | varchar |  |  |

- UNIQUE (유물ID, 부위_cd)

### 형태요소

Form element · 종속 단위 · 부위의 조형 요소

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 형태요소ID | varchar | PK |  |
| 유물부위ID | varchar | FK | 유물부위.유물부위ID |
| 형태요소_cd | int | FK | 코드(형태요소) |
| 수량 | int |  |  |
| 비고 | varchar |  |  |

### 문양

Motif · 종속 단위 · 부위의 문양

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 문양ID | varchar | PK |  |
| 유물부위ID | varchar | FK | 유물부위.유물부위ID |
| 문양구분_cd | int | FK | 코드(문양) |
| 면_cd | int | FK | 코드(면) |
| 비고 | varchar |  |  |

### 표면흔적

Surface trace · 종속 단위 · 부위 표면의 흔적

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 표면흔적ID | varchar | PK |  |
| 유물부위ID | varchar | FK | 유물부위.유물부위ID |
| 흔적종류_cd | int | FK | 코드(흔적종류) |
| 면_cd | int | FK | 코드(면) |
| 비고 | varchar |  |  |

### 제작속성

Manufacturing attribute · 종속 단위 · 제작 공정(성형 · 조정 · 표면처리 · 시문 · 소성) 판정

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 제작속성ID | varchar | PK |  |
| 유물부위ID | varchar | FK NN | 유물부위.유물부위ID |
| 제작속성_cd | int | FK NN | 코드(제작속성) |
| 재료_cd | int | FK | 코드(사용재료) |
| 면_cd | int | FK | 코드(면) |
| 비고 | varchar |  |  |

- UNIQUE (유물부위ID, 제작속성_cd)

### 명문

Inscription · 종속 단위 · 부위의 문자

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 명문ID | varchar | PK |  |
| 유물부위ID | varchar | FK | 유물부위.유물부위ID |
| 명문내용 | varchar |  |  |
| 비고 | varchar |  |  |

### 유물조합

Artifact set · 독립 단위 · 유물 조합 단위

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 조합ID | varchar | PK |  |
| 조합유형_cd | int | FK | 코드(조합유형) |
| 조합유물명 | varchar |  |  |
| 비고 | varchar |  |  |

### 조합개체

Set member · 연관 단위 · 유물조합 – 유물 N:M

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 매핑ID | int | PK |  |
| 조합ID | varchar | FK | 유물조합.조합ID |
| 유물ID | varchar | FK | 유물.유물ID |
| 비고 | varchar |  |  |

- UNIQUE (조합ID, 유물ID)

## 공통 기록

### 측정

Measurement · 공통 단위 · 정량 계측치

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 측정ID | varchar | PK |  |
| 유구ID | varchar | FK | 유구.유구ID |
| 토층ID | varchar | FK | 토층.토층ID |
| 시설ID | varchar | FK | 유구시설.시설ID |
| 유물ID | varchar | FK | 유물.유물ID |
| 유물부위ID | varchar | FK | 유물부위.유물부위ID |
| 문양ID | varchar | FK | 문양.문양ID |
| 시료ID | varchar | FK | 시료.시료ID |
| 측정항목_cd | int | FK | 코드(측정항목) |
| 측정값 | float |  |  |
| 측정단위_cd | int | FK | 코드(측정단위) |
| 측정방법_cd | int | FK | 코드(측정방법) |
| 측정자 | varchar |  |  |
| 측정일자 | varchar |  |  |

- CHECK — 유구ID · 토층ID · 시설ID · 유물ID · 유물부위ID · 문양ID · 시료ID 중 1개만 NOT NULL

### 시료

Sample · 공통 단위 · 분석 시료

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 시료ID | varchar | PK |  |
| 토층ID | varchar | FK | 토층.토층ID |
| 유구ID | varchar | FK | 유구.유구ID |
| 구획ID | varchar | FK | 발굴구획.구획ID |
| 유물ID | varchar | FK | 유물.유물ID |
| 시료번호 | varchar |  |  |
| 채취일자 | varchar |  |  |
| 채취자 | varchar |  |  |
| 채취부위 | varchar |  |  |
| 비고 | varchar |  |  |

- CHECK — 토층ID · 유구ID · 구획ID · 유물ID 중 1개 이상 NOT NULL

### 과학분석

Scientific analysis · 공통 단위 · 과학적 분석 결과

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 분석ID | varchar | PK |  |
| 시료ID | varchar | FK | 시료.시료ID |
| 유물ID | varchar | FK | 유물.유물ID |
| 분석종류_cd | int | FK | 코드(분석종류) |
| 측정값 | float |  |  |
| 측정값_하한 | float |  |  |
| 측정값_상한 | float |  |  |
| 오차 | float |  |  |
| 측정단위_cd | int | FK | 코드(측정단위) |
| 분석자 | varchar |  |  |
| 분석기관 | varchar |  |  |
| 분석일자 | varchar |  |  |
| 비고 | varchar |  |  |

- CHECK — 시료ID · 유물ID 중 1개만 NOT NULL

### 조사자료

Documentation record · 공통 단위 · 조사 산출 자료(사진 · 도면 · 3D 등)의 메타데이터

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 조사자료ID | varchar | PK |  |
| 조사ID | varchar | FK | 사업단위.조사ID |
| 구획ID | varchar | FK | 발굴구획.구획ID |
| 기준층위ID | varchar | FK | 기준층위.기준층위ID |
| 토층ID | varchar | FK | 토층.토층ID |
| 유구ID | varchar | FK | 유구.유구ID |
| 유물ID | varchar | FK | 유물.유물ID |
| 분석ID | varchar | FK | 과학분석.분석ID |
| 자료유형_cd | int | FK | 코드(자료유형) |
| 자료번호 | varchar |  |  |
| 저장위치 | varchar |  |  |
| 원본파일명 | varchar |  |  |
| 확장자 | varchar |  |  |
| 등록일자 | varchar |  |  |
| 촬영일자 | varchar |  |  |
| 촬영자 | varchar |  |  |
| 촬영구분_cd | int | FK | 코드(촬영구분) |
| 캡션 | varchar |  |  |
| 저장파일명 | varchar |  |  |
| 파일크기 | int |  |  |
| 파일해시 | varchar |  |  |
| 표시파일명 | varchar |  |  |
| 썸네일파일명 | varchar |  |  |
| 이미지폭 | int |  |  |
| 이미지높이 | int |  |  |
| 등록방식 | varchar |  |  |
| 문서ID | varchar | FK | 행정문서.문서ID |
| 정리상태_cd | int | FK | 코드(정리상태) |
| 문헌ID | varchar | FK | 보고서.보고서ID |

- 운영 속성: 저장파일명 · 파일크기 · 파일해시 · 표시파일명 · 썸네일파일명 · 이미지폭 · 이미지높이 · 등록방식 · 문서ID · 정리상태_cd · 문헌ID
- CHECK — 조사ID · 구획ID · 기준층위ID · 토층ID · 유구ID · 유물ID · 분석ID · 문서ID · 문헌ID 중 1개 이하 NOT NULL

## 어휘 통제

### 코드

Code · 독립 단위 · 통제 어휘. 계층은 상위코드ID 자기참조

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 코드ID | int | PK |  |
| 상위코드ID | int | FK | 코드.코드ID |
| 코드그룹 | varchar |  |  |
| 코드값 | varchar |  |  |
| 정렬순서 | int |  |  |
| 사용여부 | int |  |  |
| 변경상태 | varchar |  |  |

- 운영 속성: 변경상태
- UNIQUE (코드ID, 상위코드ID)
- UNIQUE (코드그룹, 상위코드ID, 코드값)

### 코드관계매핑

Code relation mapping · 연관 단위 · 코드 간 관계(패싯 적용 규칙 · 등가 관계)

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 매핑ID | int | PK |  |
| 기준코드ID | int | FK NN | 코드.코드ID |
| 대상코드ID | int | FK NN | 코드.코드ID |
| 관계유형_cd | int | FK NN | 코드(관계유형) |
| 비고 | varchar |  |  |

- UNIQUE (기준코드ID, 대상코드ID, 관계유형_cd)

### 고유속성

Class-specific attribute · 공통 단위 · 세부 분류 속성(개체 – 속성 – 값)

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 고유속성ID | int | PK |  |
| 유물ID | varchar | FK | 유물.유물ID |
| 유물부위ID | varchar | FK | 유물부위.유물부위ID |
| 유구ID | varchar | FK | 유구.유구ID |
| 시설ID | varchar | FK | 유구시설.시설ID |
| 문양ID | varchar | FK | 문양.문양ID |
| 속성_cd | int | FK NN | 코드(고유속성항목 · 연화문속성항목) |
| 속성값_cd | int | FK NN | 코드 — 속성_cd 의 하위 코드 |
| 비고 | varchar |  |  |

- UNIQUE (문양ID, 속성_cd)
- UNIQUE (시설ID, 속성_cd)
- UNIQUE (유구ID, 속성_cd)
- UNIQUE (유물ID, 속성_cd)
- UNIQUE (유물부위ID, 속성_cd)
- FK (속성값_cd, 속성_cd) → 코드 (코드ID, 상위코드ID)
- CHECK — 유물ID · 유물부위ID · 유구ID · 시설ID · 문양ID 중 1개만 NOT NULL

## 기록 변경

### 기록변경로그

Change log · 기타 단위 · 속성값 변경 이력

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 로그ID | int | PK |  |
| 시각 | varchar |  |  |
| 테이블 | varchar | NN |  |
| 키 | varchar | NN |  |
| 이름 | varchar |  |  |
| 컬럼 | varchar | NN |  |
| 이전값 | varchar |  |  |
| 이후값 | varchar |  |  |
| 변경자 | varchar |  |  |
| 사유 | varchar |  |  |
| 묶음ID | varchar |  |  |
| 되돌림 | int |  |  |

- 운영 속성: 묶음ID · 되돌림

## 시스템 운영 · 부가

### 인원

Person · 조사 참여 인원 · 기관

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 인원ID | varchar | PK |  |
| 성명 | varchar |  |  |
| 기관명 | varchar |  |  |
| 팀 | varchar |  |  |
| 직책_직급 | varchar |  |  |
| 연락처 | varchar |  |  |
| 비고 | varchar |  |  |

### 행정문서

Administrative document · 행정 문서

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 문서ID | varchar | PK |  |
| 문서번호 | varchar |  |  |
| 문서명 | varchar |  |  |
| 발신기관 | varchar |  |  |
| 수신기관 | varchar |  |  |
| 작성일자 | varchar |  |  |
| 비고 | varchar |  |  |
| 문서유형_cd | int | FK | 코드(문서유형) |
| 시행일자 | varchar |  |  |
| 담당자ID | varchar | FK | 인원.인원ID |
| 보존기간_cd | int | FK | 코드(보존기간) |
| 공개구분_cd | int | FK | 코드(공개구분) |

### 보고서

Reference · 보고서 · 참고문헌

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 보고서ID | varchar | PK |  |
| 보고서명 | varchar |  |  |
| 보고서유형_cd | int | FK | 코드(보고서유형) |
| 저자 | varchar |  |  |
| 발간기관 | varchar |  |  |
| 발간연도 | int |  |  |
| ISBN | varchar |  |  |
| 소장처 | varchar |  |  |
| 비고 | varchar |  |  |

### 관리항목

Management decision · 유물 관리 상태 결정 기록

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 관리ID | varchar | PK |  |
| 유물ID | varchar | FK NN | 유물.유물ID |
| 관리항목_cd | int | FK | 코드(관리항목) |
| 결정일자 | varchar |  |  |
| 담당자ID | varchar | FK | 인원.인원ID |
| 비고 | varchar |  |  |

### 이동사항

Transfer · 유물 이동 · 보관 이력

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 이동ID | varchar | PK |  |
| 유물ID | varchar | FK | 유물.유물ID |
| 이동성격_cd | int | FK | 코드(이동성격) |
| 이전보관처_cd | int | FK | 코드(보관처) |
| 이전보관_장 | varchar |  |  |
| 이전보관_단 | varchar |  |  |
| 이전보관_열 | varchar |  |  |
| 현재보관처_cd | int | FK | 코드(보관처) |
| 현재보관_장 | varchar |  |  |
| 현재보관_단 | varchar |  |  |
| 현재보관_열 | varchar |  |  |
| 이동일자 | varchar |  |  |
| 담당자ID | varchar | FK | 인원.인원ID |
| 비고 | varchar |  |  |
| 용기번호 | varchar |  |  |
| 정리상태_cd | int | FK | 코드(유물정리상태) |

### 자료연결

Record link · 조사자료 – 개체 N:M

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 연결ID | int | PK |  |
| 조사자료ID | varchar | FK NN | 조사자료.조사자료ID |
| 대상테이블 | varchar | NN |  |
| 대상ID | varchar | NN |  |
| 비고 | varchar |  |  |

- UNIQUE (조사자료ID, 대상테이블, 대상ID)

### 개체연결

Entity link · 외래키가 없는 개체 간 연결

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 연결ID | int | PK |  |
| 기준테이블 | varchar | NN |  |
| 기준ID | varchar | NN |  |
| 대상테이블 | varchar | NN |  |
| 대상ID | varchar | NN |  |
| 관계 | varchar |  |  |
| 비고 | varchar |  |  |

- UNIQUE (기준테이블, 기준ID, 대상테이블, 대상ID)

### 컬럼_코드그룹_매핑

Column–code group mapping · 속성별 코드그룹 지정

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 소속테이블 | varchar |  |  |
| DB컬럼 | varchar |  |  |
| 참조_코드그룹 | varchar |  |  |
| 계층 | varchar |  |  |
| 비고 | varchar |  |  |
| 표시명 | varchar |  |  |

### 코드변경로그

Code change log · 코드 변경 이력

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 로그ID | int | PK |  |
| 시각 | varchar |  |  |
| 작업 | varchar |  |  |
| 코드ID | int |  |  |
| 코드그룹 | varchar |  |  |
| 이전값 | varchar |  |  |
| 이후값 | varchar |  |  |
| 복구됨 | int |  |  |

### UI라벨

UI label · 화면 표시명

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 종류 | varchar | PK |  |
| 키 | varchar | PK |  |
| 표시명 | varchar |  |  |

### 삭제로그

Deletion log · 삭제 이력

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 로그ID | int | PK |  |
| 시각 | varchar |  |  |
| 테이블 | varchar |  |  |
| 키 | varchar |  |  |
| 이름 | varchar |  |  |
| 함께삭제 | int |  |  |
| 내역 | varchar |  |  |
| 묶음ID | varchar |  |  |
| 상태 | varchar |  |  |
| 삭제자 | varchar |  |  |

### 휴지통

Trash · 삭제 행 보관

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 휴지통ID | int | PK |  |
| 묶음ID | varchar | NN |  |
| 시각 | varchar |  |  |
| 테이블 | varchar |  |  |
| 키 | varchar |  |  |
| 이름 | varchar |  |  |
| 깊이 | int |  |  |
| 내용 | varchar |  |  |
| 복원됨 | int |  |  |

### 유사도색인

Similarity index · 속성 유사도 조회용 색인

| 속성 | 자료형 | 키 | 참조 |
|---|---|---|---|
| 표 | varchar | NN |  |
| 개체ID | varchar | NN |  |
| 칸 | varchar | NN |  |
| 라벨 | varchar |  |  |
| 묶음 | varchar |  |  |
| 순 | int |  |  |
| 값 | varchar |  |  |
| 값글 | varchar |  |  |
| 수 | float |  |  |
| 원수 | float |  |  |
| 단위 | varchar |  |  |
| 셈 | int |  |  |

## 뷰

| 뷰 | 정의 | 속성 |
|---|---|---|
| v_자료연결 | 조사자료의 주대상(FK)과 자료연결의 통합 | 조사자료ID · 대상테이블 · 대상ID · 연결경로 |

## 코드그룹

코드 수는 사용 중인 코드 기준이다.

| 코드그룹 | 적용 속성 | 계층 | 코드 수 |
|---|---|---|---|
| 조사성격 | 사업단위.조사성격_cd |  | 3 |
| 유적성격 | 조사구역.유적성격_cd |  | 12 |
| 구획구분 | 발굴구획.구획구분_cd |  | 3 |
| 토층분류 | 토층.토층구분_cd | ○ | 10 |
| 시기 | 토층.현장편년_cd · 유구.현장편년_cd · 유물.현장편년_cd | ○ | 205 |
| 먼셀토색 | 토층.토색_cd | ○ | 150 |
| 토질 | 토층.토질_cd |  | 7 |
| 입도 | 토층.입도_cd |  | 6 |
| 포함물 | 혼입요소.포함물_cd | ○ | 31 |
| 층서관계유형 | 층서관계.관계유형_cd |  | 5 |
| 유구분류 | 유구.유구분류_cd | ○ | 63 |
| 평면형태 | 유구.평면형태_cd · 유구시설.시설형태_cd |  | 12 |
| 단면형태 | 유구.단면형태_cd |  | 1 |
| 유구잔존상태 | 유구.잔존상태_cd |  | 4 |
| 시설구분 | 유구시설.시설구분_cd |  | 10 |
| 재질 | 유구시설.재질_cd · 유물부위.재질_cd | ○ | 242 |
| 구성요소잔존상태 | 유구시설.잔존상태_cd |  | 4 |
| 중첩관계 | 유구관계.관계유형_cd |  | 3 |
| 유구층서관계유형 | 매핑_유구_층서.관계유형_cd |  | 5 |
| 유물분류 | 유물.유물분류_cd | ○ | 233 |
| 유물잔존상태 | 유물.잔존상태_cd |  | 5 |
| 부위 | 유물부위.부위_cd | ○ | 16 |
| 색조 | 유물부위.색조_cd |  | 36 |
| 형태요소 | 형태요소.형태요소_cd | ○ | 11 |
| 문양 | 문양.문양구분_cd | ○ | 220 |
| 면 | 문양.면_cd · 표면흔적.면_cd · 제작속성.면_cd |  | 4 |
| 흔적종류 | 표면흔적.흔적종류_cd | ○ | 27 |
| 제작속성 | 제작속성.제작속성_cd | ○ | 33 |
| 사용재료 | 제작속성.재료_cd |  | 10 |
| 조합유형 | 유물조합.조합유형_cd |  | 3 |
| 측정항목 | 측정.측정항목_cd |  | 21 |
| 측정단위 | 측정.측정단위_cd · 과학분석.측정단위_cd |  | 13 |
| 측정방법 | 측정.측정방법_cd |  | 11 |
| 분석종류 | 과학분석.분석종류_cd |  | 16 |
| 자료유형 | 조사자료.자료유형_cd |  | 11 |
| 촬영구분 | 조사자료.촬영구분_cd |  | 7 |
| 정리상태 | 조사자료.정리상태_cd |  | 5 |
| 관계유형 | 코드관계매핑.관계유형_cd |  | 8 |
| 고유속성항목 | 고유속성.속성_cd |  | 8 |
| 연화문속성항목 | 고유속성.속성_cd |  | 12 |
| 문서유형 | 행정문서.문서유형_cd |  | 12 |
| 보존기간 | 행정문서.보존기간_cd |  | 7 |
| 공개구분 | 행정문서.공개구분_cd |  | 3 |
| 보고서유형 | 보고서.보고서유형_cd |  | 5 |
| 관리항목 | 관리항목.관리항목_cd |  | 4 |
| 이동성격 | 이동사항.이동성격_cd | ○ | 16 |
| 보관처 | 이동사항.이전보관처_cd · 이동사항.현재보관처_cd | ○ | 7 |
| 유물정리상태 | 이동사항.정리상태_cd |  | 5 |

`고유속성.속성값_cd` 의 코드그룹(20): 화판구분 · 기초형식 · 벽체구조 · 매장주체부 · 봉토구조 · 축조기법 · 생산품목 · 태토 · 연잎형태 · 유문자형유무 · 연판_판단형태 · 연판_단면형태 · 연판_능선유무 · 연판_단부장식 · 자방_연자배치 · 자방_단면형태 · 자방_경계처리 · 권선 · 간엽 · 연판_판엽형태
