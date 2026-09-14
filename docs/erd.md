# ERD

`schema/schema.dbml` 에서 생성한 Mermaid 도표. 논문의 그림 1~3 에 대응한다. 전체 결선을 한 장으로 보려면 `schema.dbml` 을 [dbdiagram.io](https://dbdiagram.io) 에 붙여 넣는다.

선 끝의 기호 — `||` 정확히 하나 · `|o` 0 또는 하나 · `o{` 0 이상 여럿. 선 위의 이름은 참조하는 열(FK).

## 그림 1 · 공통 ERD

공통 기록 · 어휘 통제 · 기록의 변경. 다른 범주의 릴레이션은 참조 대상으로만(빈 상자) 나타난다. 코드사전으로 가는 선은 어휘 통제 릴레이션(코드관계매핑 · 고유속성)의 것만 그렸다.

```mermaid
erDiagram
  "유구" |o--o{ "측정" : "유구ID"
  "층위" |o--o{ "측정" : "층위ID"
  "유구시설" |o--o{ "측정" : "시설ID"
  "유물부위" |o--o{ "측정" : "유물부위ID"
  "시료" |o--o{ "측정" : "시료ID"
  "층위" |o--o{ "시료" : "층위ID"
  "유구" |o--o{ "시료" : "유구ID"
  "발굴구획" |o--o{ "시료" : "구획ID"
  "유물" |o--o{ "시료" : "유물ID"
  "시료" |o--o{ "과학분석" : "시료ID"
  "유물" |o--o{ "과학분석" : "유물ID"
  "사업단위" |o--o{ "조사자료" : "조사ID"
  "발굴구획" |o--o{ "조사자료" : "구획ID"
  "토층단면도" |o--o{ "조사자료" : "단면도ID"
  "층위" |o--o{ "조사자료" : "층위ID"
  "유구" |o--o{ "조사자료" : "유구ID"
  "유물" |o--o{ "조사자료" : "유물ID"
  "코드" |o--o{ "코드" : "상위코드ID"
  "코드" ||--o{ "코드관계매핑" : "기준코드ID"
  "코드" ||--o{ "코드관계매핑" : "대상코드ID"
  "유물" |o--o{ "고유속성" : "유물ID"
  "유물부위" |o--o{ "고유속성" : "유물부위ID"
  "유구" |o--o{ "고유속성" : "유구ID"
  "유구시설" |o--o{ "고유속성" : "유구시설ID"
  "문양" |o--o{ "고유속성" : "문양ID"
  "코드" ||--o{ "코드관계매핑" : "관계유형_cd"
  "코드" ||--o{ "고유속성" : "속성_cd"
  "코드" ||--o{ "고유속성" : "속성값_cd, 속성_cd"
  "고유속성" {
    int 고유속성ID PK
    varchar 유물ID FK
    varchar 유물부위ID FK
    varchar 유구ID FK
    varchar 유구시설ID FK
    varchar 문양ID FK
    int 속성_cd FK "고유속성항목"
    int 속성값_cd FK
    varchar 비고
  }
  "측정" {
    varchar 측정ID PK
    varchar 유구ID FK
    varchar 층위ID FK
    varchar 시설ID FK
    varchar 유물부위ID FK
    varchar 시료ID FK
    int 측정항목_cd FK "측정항목"
    float 측정값
    int 측정단위_cd FK "측정단위"
    int 측정방법_cd FK "측정방법"
    varchar 측정자
    varchar 측정일자
    varchar 비고
  }
  "시료" {
    varchar 시료ID PK
    varchar 층위ID FK
    varchar 유구ID FK
    varchar 구획ID FK
    varchar 유물ID FK
    varchar 시료번호
    varchar 채취일자
    varchar 채취자
    varchar 채취부위
    varchar 비고
  }
  "과학분석" {
    varchar 분석ID PK
    varchar 시료ID FK
    varchar 유물ID FK
    int 분석종류_cd FK "분석종류"
    float 측정값
    float 오차
    int 측정단위_cd FK "측정단위"
    varchar 분석자
    varchar 분석기관
    varchar 분석일자
    varchar 비고
  }
  "조사자료" {
    varchar 조사자료ID PK
    varchar 조사ID FK
    varchar 구획ID FK
    varchar 단면도ID FK
    varchar 층위ID FK
    varchar 유구ID FK
    varchar 유물ID FK
    int 자료유형_cd FK "자료유형"
    varchar 자료번호
    varchar 저장위치
    varchar 원본파일명
    varchar 확장자
    varchar 등록일자
    varchar 등록자
    varchar 비고
  }
  "코드" {
    int 코드ID PK
    varchar 코드그룹
    int 상위코드ID FK
    varchar 코드값
    int 정렬순서
    int 사용여부
  }
  "코드관계매핑" {
    int 매핑ID PK
    int 기준코드ID FK
    int 대상코드ID FK
    int 관계유형_cd FK "관계유형"
    varchar 비고
  }
  "변경기록" {
    int 변경ID PK
    varchar 대상릴레이션
    varchar 대상키
    varchar 대상속성
    varchar 변경전
    varchar 변경후
    varchar 변경일시
    varchar 변경자
    varchar 변경사유
    varchar 비고
  }
  "문양" {
  }
  "발굴구획" {
  }
  "사업단위" {
  }
  "유구" {
  }
  "유구시설" {
  }
  "유물" {
  }
  "유물부위" {
  }
  "층위" {
  }
  "토층단면도" {
  }
```

## 그림 2 · 공간·층서·유구 ERD

코드사전(_cd 열)으로 가는 선은 생략했다. 도메인은 데이터 사전을 참조.

```mermaid
erDiagram
  "사업단위" |o--o{ "조사구역" : "조사ID"
  "조사구역" |o--o{ "조사구역" : "상위구역ID"
  "조사구역" |o--o{ "발굴구획" : "구역ID"
  "토층단면도" |o--o{ "층위" : "단면도ID"
  "층위" |o--o{ "복합토질" : "층위ID"
  "층위" |o--o{ "층위관계" : "기준층위ID"
  "층위" |o--o{ "층위관계" : "대상층위ID"
  "발굴구획" |o--o{ "매핑_구획_단면도" : "구획ID"
  "토층단면도" |o--o{ "매핑_구획_단면도" : "단면도ID"
  "조사구역" |o--o{ "유구" : "구역ID"
  "유구" |o--o{ "유구" : "상위유구ID"
  "유구" |o--o{ "유구시설" : "유구ID"
  "유구" |o--o{ "유구관계" : "기준유구ID"
  "유구" |o--o{ "유구관계" : "대상유구ID"
  "유구" |o--o{ "매핑_유구_구획" : "유구ID"
  "발굴구획" |o--o{ "매핑_유구_구획" : "구획ID"
  "유구" |o--o{ "매핑_유구_층위" : "유구ID"
  "층위" |o--o{ "매핑_유구_층위" : "층위ID"
  "사업단위" {
    varchar 조사ID PK
    varchar 사업명
    varchar 조사차수
    int 조사성격_cd FK "조사성격"
    varchar 소재지
    float 조사면적
    varchar 발굴허가번호
    varchar 조사시작일
    varchar 조사종료일
    varchar 조사기관
    varchar 조사단장
    varchar 비고
  }
  "조사구역" {
    varchar 구역ID PK
    varchar 조사ID FK
    varchar 상위구역ID FK
    varchar 구역명
    int 유적성격_cd FK "유적성격"
    varchar 공간좌표
    varchar 조사원
    varchar 비고
  }
  "발굴구획" {
    varchar 구획ID PK
    varchar 구역ID FK
    int 구획구분_cd FK "구획구분"
    varchar 구획명
    varchar 구획일자
    varchar 조사원
    varchar 비고
  }
  "토층단면도" {
    varchar 단면도ID PK
    varchar 단면도명
    varchar 비고
  }
  "층위" {
    varchar 층위ID PK
    varchar 단면도ID FK
    varchar 층위명
    int 층위구분_cd FK "토층분류"
    int 추정시기_cd FK "시기"
    int 토색_cd FK "먼셀토색"
    int 토질_cd FK "토질"
    int 입도_cd FK "입도"
    varchar 조사원
    varchar 비고
  }
  "복합토질" {
    varchar 포함물ID PK
    varchar 층위ID FK
    int 포함물_cd FK "포함물"
    varchar 비고
  }
  "층위관계" {
    int 관계ID PK
    varchar 기준층위ID FK
    varchar 대상층위ID FK
    int 관계유형_cd FK "층위관계유형"
    varchar 비고
  }
  "매핑_구획_단면도" {
    int 매핑ID PK
    varchar 구획ID FK
    varchar 단면도ID FK
    varchar 비고
  }
  "유구" {
    varchar 유구ID PK
    varchar 구역ID FK
    varchar 상위유구ID FK
    varchar 유구명
    varchar 유구번호
    int 유구분류_cd FK "유구분류"
    int 추정시기_cd FK "시기"
    varchar 공간좌표
    int 평면형태_cd FK "평면형태"
    int 단면형태_cd FK "단면형태"
    varchar 주축방향
    int 잔존상태_cd FK "유구잔존상태"
    varchar 조사원
    varchar 비고
  }
  "유구시설" {
    varchar 시설ID PK
    varchar 유구ID FK
    int 시설구분_cd FK "시설구분"
    int 재질_cd FK "재질"
    int 잔존상태_cd FK "구성요소잔존상태"
    int 수량
    varchar 조사원
    varchar 비고
  }
  "유구관계" {
    int 관계ID PK
    varchar 기준유구ID FK
    varchar 대상유구ID FK
    int 관계유형_cd FK "중첩관계"
    varchar 비고
  }
  "매핑_유구_구획" {
    int 매핑ID PK
    varchar 유구ID FK
    varchar 구획ID FK
    varchar 비고
  }
  "매핑_유구_층위" {
    int 매핑ID PK
    varchar 유구ID FK
    varchar 층위ID FK
    int 관계유형_cd FK "층서관계유형"
    varchar 비고
  }
```

## 그림 3 · 유물 ERD

코드사전(_cd 열)으로 가는 선은 생략했다. 출토 맥락(층위 · 발굴구획 · 유구)은 참조 대상으로만 나타난다.

```mermaid
erDiagram
  "층위" |o--o{ "유물" : "출토층위ID"
  "발굴구획" |o--o{ "유물" : "구획ID"
  "유구" |o--o{ "유물" : "유구ID"
  "유물" |o--o{ "유물부위" : "유물ID"
  "유물부위" |o--o{ "표면흔적" : "유물부위ID"
  "유물부위" ||--o{ "제작속성" : "유물부위ID"
  "유물부위" |o--o{ "형태요소" : "유물부위ID"
  "유물부위" |o--o{ "문양" : "유물부위ID"
  "유물부위" |o--o{ "명문" : "유물부위ID"
  "유물" |o--o{ "조합개체" : "유물ID"
  "유물조합" |o--o{ "조합개체" : "조합ID"
  "유물" {
    varchar 유물ID PK
    varchar 출토층위ID FK
    varchar 구획ID FK
    varchar 유구ID FK
    varchar 유물명
    varchar 유물번호
    int 유물분류_cd FK "유물분류"
    int 추정시기_cd FK "시기"
    varchar 출토위치
    varchar 공간좌표
    int 수량
    int 잔존상태_cd FK "유물잔존상태"
    varchar 수습일자
    varchar 조사원
    varchar 비고
  }
  "유물부위" {
    varchar 유물부위ID PK
    varchar 유물ID FK
    int 부위_cd FK "부위"
    int 내면_외면
    int 재질_cd FK "태토"
    int 색조_cd FK "색조"
    varchar 비고
  }
  "표면흔적" {
    varchar 표면흔적ID PK
    varchar 유물부위ID FK
    int 흔적종류_cd FK "흔적종류"
    varchar 비고
  }
  "제작속성" {
    varchar 제작속성ID PK
    varchar 유물부위ID FK
    int 제작속성_cd FK "제작속성"
    int 재료_cd FK "사용재료"
    varchar 비고
  }
  "형태요소" {
    varchar 형태요소ID PK
    varchar 유물부위ID FK
    int 형태요소_cd FK "형태요소"
    int 수량
    varchar 비고
  }
  "문양" {
    varchar 문양ID PK
    varchar 유물부위ID FK
    int 문양구분_cd FK "문양"
    varchar 비고
  }
  "명문" {
    varchar 명문ID PK
    varchar 유물부위ID FK
    varchar 명문내용
    varchar 비고
  }
  "유물조합" {
    varchar 조합ID PK
    int 조합유형_cd FK "조합유형"
    varchar 조합유물명
    varchar 비고
  }
  "조합개체" {
    int 매핑ID PK
    varchar 유물ID FK
    varchar 조합ID FK
    varchar 비고
  }
  "발굴구획" {
  }
  "유구" {
  }
  "층위" {
  }
```
