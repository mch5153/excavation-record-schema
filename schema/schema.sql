-- =============================================================================
-- excavation-record-schema — PostgreSQL DDL
-- schema/schema.dbml 에서 tools/build_docs.js 가 생성한 파일. 직접 고치지 말 것.
-- 논리 스키마의 자료형(varchar · int · float)을 그대로 옮겼으며, 배타적 아크는 끝의 CHECK 로 강제한다.
-- =============================================================================

CREATE TABLE "사업단위" (
  "조사ID" varchar PRIMARY KEY,
  "사업명" varchar,
  "조사차수" varchar,
  "조사성격_cd" int,
  "소재지" varchar,
  "조사면적" float,
  "발굴허가번호" varchar,
  "조사시작일" varchar,
  "조사종료일" varchar,
  "조사기관" varchar,
  "조사단장" varchar,
  "비고" varchar
);

CREATE TABLE "조사구역" (
  "구역ID" varchar PRIMARY KEY,
  "조사ID" varchar,
  "상위구역ID" varchar,
  "구역명" varchar,
  "유적성격_cd" int,
  "공간좌표" varchar,
  "조사원" varchar,
  "비고" varchar
);

CREATE TABLE "발굴구획" (
  "구획ID" varchar PRIMARY KEY,
  "구역ID" varchar,
  "구획구분_cd" int,
  "구획명" varchar,
  "구획일자" varchar,
  "조사원" varchar,
  "비고" varchar
);

CREATE TABLE "토층단면도" (
  "단면도ID" varchar PRIMARY KEY,
  "단면도명" varchar,
  "비고" varchar
);

CREATE TABLE "층위" (
  "층위ID" varchar PRIMARY KEY,
  "단면도ID" varchar,
  "층위명" varchar,
  "층위구분_cd" int,
  "추정시기_cd" int,
  "토색_cd" int,
  "토질_cd" int,
  "입도_cd" int,
  "조사원" varchar,
  "비고" varchar
);

CREATE TABLE "복합토질" (
  "포함물ID" varchar PRIMARY KEY,
  "층위ID" varchar,
  "포함물_cd" int,
  "비고" varchar
);

CREATE TABLE "층위관계" (
  "관계ID" int PRIMARY KEY,
  "기준층위ID" varchar,
  "대상층위ID" varchar,
  "관계유형_cd" int,
  "비고" varchar
);

CREATE TABLE "매핑_구획_단면도" (
  "매핑ID" int PRIMARY KEY,
  "구획ID" varchar,
  "단면도ID" varchar,
  "비고" varchar
);

CREATE TABLE "유구" (
  "유구ID" varchar PRIMARY KEY,
  "구역ID" varchar,
  "상위유구ID" varchar,
  "유구명" varchar,
  "유구번호" varchar,
  "유구분류_cd" int,
  "추정시기_cd" int,
  "공간좌표" varchar,
  "평면형태_cd" int,
  "단면형태_cd" int,
  "주축방향" varchar,
  "잔존상태_cd" int,
  "조사원" varchar,
  "비고" varchar
);

CREATE TABLE "유구시설" (
  "시설ID" varchar PRIMARY KEY,
  "유구ID" varchar,
  "시설구분_cd" int,
  "재질_cd" int,
  "잔존상태_cd" int,
  "수량" int,
  "조사원" varchar,
  "비고" varchar
);

CREATE TABLE "유구관계" (
  "관계ID" int PRIMARY KEY,
  "기준유구ID" varchar,
  "대상유구ID" varchar,
  "관계유형_cd" int,
  "비고" varchar
);

CREATE TABLE "매핑_유구_구획" (
  "매핑ID" int PRIMARY KEY,
  "유구ID" varchar,
  "구획ID" varchar,
  "비고" varchar
);

CREATE TABLE "매핑_유구_층위" (
  "매핑ID" int PRIMARY KEY,
  "유구ID" varchar,
  "층위ID" varchar,
  "관계유형_cd" int,
  "비고" varchar
);

CREATE TABLE "유물" (
  "유물ID" varchar PRIMARY KEY,
  "출토층위ID" varchar,
  "구획ID" varchar,
  "유구ID" varchar,
  "유물명" varchar,
  "유물번호" varchar,
  "유물분류_cd" int,
  "추정시기_cd" int,
  "출토위치" varchar,
  "공간좌표" varchar,
  "수량" int,
  "잔존상태_cd" int,
  "수습일자" varchar,
  "조사원" varchar,
  "비고" varchar
);

CREATE TABLE "유물부위" (
  "유물부위ID" varchar PRIMARY KEY,
  "유물ID" varchar,
  "부위_cd" int,
  "내면/외면" int,
  "재질_cd" int,
  "색조_cd" int,
  "비고" varchar
);

CREATE TABLE "표면흔적" (
  "표면흔적ID" varchar PRIMARY KEY,
  "유물부위ID" varchar,
  "흔적종류_cd" int,
  "비고" varchar
);

CREATE TABLE "제작속성" (
  "제작속성ID" varchar PRIMARY KEY,
  "유물부위ID" varchar NOT NULL,
  "제작속성_cd" int NOT NULL,
  "재료_cd" int,
  "비고" varchar
);

CREATE TABLE "형태요소" (
  "형태요소ID" varchar PRIMARY KEY,
  "유물부위ID" varchar,
  "형태요소_cd" int,
  "수량" int,
  "비고" varchar
);

CREATE TABLE "문양" (
  "문양ID" varchar PRIMARY KEY,
  "유물부위ID" varchar,
  "문양구분_cd" int,
  "비고" varchar
);

CREATE TABLE "명문" (
  "명문ID" varchar PRIMARY KEY,
  "유물부위ID" varchar,
  "명문내용" varchar,
  "비고" varchar
);

CREATE TABLE "유물조합" (
  "조합ID" varchar PRIMARY KEY,
  "조합유형_cd" int,
  "조합유물명" varchar,
  "비고" varchar
);

CREATE TABLE "조합개체" (
  "매핑ID" int PRIMARY KEY,
  "유물ID" varchar,
  "조합ID" varchar,
  "비고" varchar
);

CREATE TABLE "측정" (
  "측정ID" varchar PRIMARY KEY,
  "유구ID" varchar,
  "층위ID" varchar,
  "시설ID" varchar,
  "유물부위ID" varchar,
  "시료ID" varchar,
  "측정항목_cd" int,
  "측정값" float,
  "측정단위_cd" int,
  "측정방법_cd" int,
  "측정자" varchar,
  "측정일자" varchar,
  "비고" varchar
);

CREATE TABLE "시료" (
  "시료ID" varchar PRIMARY KEY,
  "층위ID" varchar,
  "유구ID" varchar,
  "구획ID" varchar,
  "유물ID" varchar,
  "시료번호" varchar,
  "채취일자" varchar,
  "채취자" varchar,
  "채취부위" varchar,
  "비고" varchar
);

CREATE TABLE "과학분석" (
  "분석ID" varchar PRIMARY KEY,
  "시료ID" varchar,
  "유물ID" varchar,
  "분석종류_cd" int,
  "측정값" float,
  "오차" float,
  "측정단위_cd" int,
  "분석자" varchar,
  "분석기관" varchar,
  "분석일자" varchar,
  "비고" varchar
);

CREATE TABLE "조사자료" (
  "조사자료ID" varchar PRIMARY KEY,
  "조사ID" varchar,
  "구획ID" varchar,
  "단면도ID" varchar,
  "층위ID" varchar,
  "유구ID" varchar,
  "유물ID" varchar,
  "자료유형_cd" int,
  "자료번호" varchar,
  "저장위치" varchar,
  "원본파일명" varchar,
  "확장자" varchar,
  "등록일자" varchar,
  "등록자" varchar,
  "비고" varchar
);

CREATE TABLE "코드" (
  "코드ID" int PRIMARY KEY,
  "코드그룹" varchar,
  "상위코드ID" int,
  "코드값" varchar,
  "정렬순서" int,
  "사용여부" int
);

CREATE TABLE "코드관계매핑" (
  "매핑ID" int PRIMARY KEY,
  "기준코드ID" int NOT NULL,
  "대상코드ID" int NOT NULL,
  "관계유형_cd" int NOT NULL,
  "비고" varchar
);

CREATE TABLE "고유속성" (
  "고유속성ID" int PRIMARY KEY,
  "유물ID" varchar,
  "유물부위ID" varchar,
  "유구ID" varchar,
  "유구시설ID" varchar,
  "문양ID" varchar,
  "속성_cd" int NOT NULL,
  "속성값_cd" int NOT NULL,
  "비고" varchar
);

CREATE TABLE "변경기록" (
  "변경ID" int PRIMARY KEY,
  "대상릴레이션" varchar NOT NULL,
  "대상키" varchar NOT NULL,
  "대상속성" varchar NOT NULL,
  "변경전" varchar,
  "변경후" varchar,
  "변경일시" varchar,
  "변경자" varchar,
  "변경사유" varchar,
  "비고" varchar
);

CREATE UNIQUE INDEX ON "복합토질" ("층위ID", "포함물_cd");

CREATE UNIQUE INDEX ON "층위관계" ("기준층위ID", "대상층위ID", "관계유형_cd");

CREATE UNIQUE INDEX ON "매핑_구획_단면도" ("구획ID", "단면도ID");

CREATE UNIQUE INDEX ON "유구관계" ("기준유구ID", "대상유구ID", "관계유형_cd");

CREATE UNIQUE INDEX ON "매핑_유구_구획" ("유구ID", "구획ID");

CREATE UNIQUE INDEX ON "매핑_유구_층위" ("유구ID", "층위ID", "관계유형_cd");

CREATE UNIQUE INDEX ON "유물부위" ("유물ID", "부위_cd");

CREATE UNIQUE INDEX ON "제작속성" ("유물부위ID", "제작속성_cd");

CREATE UNIQUE INDEX ON "코드" ("코드ID", "상위코드ID");

CREATE UNIQUE INDEX ON "코드" ("코드그룹", "상위코드ID", "코드값");

CREATE UNIQUE INDEX ON "코드관계매핑" ("기준코드ID", "대상코드ID", "관계유형_cd");

CREATE UNIQUE INDEX ON "고유속성" ("유물ID", "속성_cd");

CREATE UNIQUE INDEX ON "고유속성" ("유물부위ID", "속성_cd");

CREATE UNIQUE INDEX ON "고유속성" ("유구ID", "속성_cd");

CREATE UNIQUE INDEX ON "고유속성" ("유구시설ID", "속성_cd");

CREATE UNIQUE INDEX ON "고유속성" ("문양ID", "속성_cd");

COMMENT ON TABLE "사업단위" IS '발굴조사 사업(조사 차수) 단위. 공간 위계 사업단위 › 조사구역 › 발굴구획의 최상위.';

COMMENT ON COLUMN "사업단위"."조사성격_cd" IS '코드그룹 조사성격';

COMMENT ON COLUMN "조사구역"."상위구역ID" IS '자기참조 — 지구 › 구역처럼 위계가 여러 번 분화하는 것을 릴레이션 추가 없이 표현';

COMMENT ON COLUMN "조사구역"."유적성격_cd" IS '코드그룹 유적성격';

COMMENT ON COLUMN "발굴구획"."구획구분_cd" IS '코드그룹 구획구분';

COMMENT ON TABLE "토층단면도" IS '유적·유구 곳곳의 토층 단면 위치를 기록한다. 층위가 여기에 종속되어 위치가 부여된 층서 정보가 된다.';

COMMENT ON COLUMN "층위"."층위구분_cd" IS '코드그룹 토층분류';

COMMENT ON COLUMN "층위"."추정시기_cd" IS '코드그룹 시기 · 발굴자의 현장 편년. 종합 편년이 아니라 비가역적인 현장 관찰이므로 기록 대상에 포함';

COMMENT ON COLUMN "층위"."토색_cd" IS '코드그룹 먼셀토색';

COMMENT ON COLUMN "층위"."토질_cd" IS '코드그룹 토질';

COMMENT ON COLUMN "층위"."입도_cd" IS '코드그룹 입도';

COMMENT ON TABLE "복합토질" IS '한 층위에 혼입된 복수의 포함물(소토 · 목탄 등). 층위당 같은 포함물은 하나.';

COMMENT ON COLUMN "복합토질"."포함물_cd" IS '코드그룹 포함물';

COMMENT ON TABLE "층위관계" IS '층위 사이의 퇴적 사건을 한 개체로 적재한다. 퇴적은 선후 관계의 일대일 대응을 보장하지 않으므로 어느 한 층위의 속성으로 환원하지 않는다.';

COMMENT ON COLUMN "층위관계"."관계유형_cd" IS '코드그룹 층위관계유형 (층위 ↔ 층위)';

COMMENT ON TABLE "매핑_구획_단면도" IS '발굴구획 ↔ 토층단면도 N:M. 단면도는 여러 구획에 걸치고, 한 구획 안에 여러 단면이 생긴다.';

COMMENT ON TABLE "유구" IS '유구 범주의 허브. 공간(조사구역 · 매핑_유구_구획)과 층서(매핑_유구_층위)를 잇는 맥락의 중추.';

COMMENT ON COLUMN "유구"."상위유구ID" IS '자기참조 — 포함 계층(고분 › 적석목곽묘 › 목곽). 중첩 · 연접은 유구관계가 받는다';

COMMENT ON COLUMN "유구"."유구번호" IS '유구 일련번호';

COMMENT ON COLUMN "유구"."유구분류_cd" IS '코드그룹 유구분류';

COMMENT ON COLUMN "유구"."추정시기_cd" IS '코드그룹 시기 · 발굴자의 현장 편년';

COMMENT ON COLUMN "유구"."평면형태_cd" IS '코드그룹 평면형태';

COMMENT ON COLUMN "유구"."단면형태_cd" IS '코드그룹 단면형태';

COMMENT ON COLUMN "유구"."잔존상태_cd" IS '코드그룹 유구잔존상태';

COMMENT ON TABLE "유구시설" IS '유구에 종속된 구성 설비(적심 · 초석 · 노지 · 주공 등). 개수 · 재질을 갖는 개체이며, 판정값을 담는 고유속성과 구분된다.';

COMMENT ON COLUMN "유구시설"."시설구분_cd" IS '코드그룹 시설구분';

COMMENT ON COLUMN "유구시설"."재질_cd" IS '코드그룹 재질';

COMMENT ON COLUMN "유구시설"."잔존상태_cd" IS '코드그룹 구성요소잔존상태';

COMMENT ON TABLE "유구관계" IS '중첩 · 연접 · 일부 훼손 등 유구 사이의 관계 사건. 어느 한 유구에 귀속되지 않는 연관 단위.';

COMMENT ON COLUMN "유구관계"."관계유형_cd" IS '코드그룹 중첩관계';

COMMENT ON TABLE "매핑_유구_구획" IS '유구 ↔ 발굴구획 N:M.';

COMMENT ON TABLE "매핑_유구_층위" IS '유구 ↔ 층위 N:M. 한 층위에서 여러 유구가, 한 유구에서 여러 층위가 나온다.';

COMMENT ON COLUMN "매핑_유구_층위"."관계유형_cd" IS '코드그룹 층서관계유형 (유구 ↔ 층위)';

COMMENT ON TABLE "유물" IS '유물 범주의 허브. 수직 위계(대 · 중 · 소 분류)는 릴레이션이 아니라 유물분류_cd 의 코드 계층이 진다 — IS-A 하위 릴레이션을 두지 않는다.';

COMMENT ON COLUMN "유물"."유물번호" IS '유물 일련번호 (현장 · 정리 번호)';

COMMENT ON COLUMN "유물"."유물분류_cd" IS '코드그룹 유물분류';

COMMENT ON COLUMN "유물"."추정시기_cd" IS '코드그룹 시기 · 발굴자의 현장 편년';

COMMENT ON COLUMN "유물"."잔존상태_cd" IS '코드그룹 유물잔존상태';

COMMENT ON TABLE "유물부위" IS '관찰 5축(표면흔적 · 제작속성 · 형태요소 · 문양 · 명문)이 매달리는 허브. 한 유물에 같은 부위는 하나. 재질 · 색조는 유물 전체가 아니라 부위에 1:1 대응하므로 여기에 둔다.';

COMMENT ON COLUMN "유물부위"."부위_cd" IS '코드그룹 부위 · 유물분류에 따라 허용 부위가 코드관계매핑으로 제한된다';

COMMENT ON COLUMN "유물부위"."재질_cd" IS '코드그룹 태토';

COMMENT ON COLUMN "유물부위"."색조_cd" IS '코드그룹 색조';

COMMENT ON TABLE "표면흔적" IS '표면에 남은 자국과 처리 흔적(타날흔 · 물손질흔 · 시유 등) — 관찰의 기록.';

COMMENT ON COLUMN "표면흔적"."흔적종류_cd" IS '코드그룹 흔적종류';

COMMENT ON TABLE "제작속성" IS '공정 단계의 판정. 표면흔적(관찰)과 분리해 두어 근거를 남긴 채 판정만 갱신할 수 있다.';

COMMENT ON COLUMN "제작속성"."제작속성_cd" IS '코드그룹 제작속성 · 대분류 = 공정단계(성형 / 조정 / 표면처리 / 접합 / 시문 / 소성), 중분류 = 그 아래 값';

COMMENT ON COLUMN "제작속성"."재료_cd" IS '코드그룹 사용재료 · 표면처리에 쓰인 재료';

COMMENT ON TABLE "형태요소" IS '유물에 가해진 입체적 조형 요소(투창 · 돌대 등).';

COMMENT ON COLUMN "형태요소"."형태요소_cd" IS '코드그룹 형태요소';

COMMENT ON TABLE "문양" IS '부위에 표현된 도상. 문양별 세부 속성(연화문의 연판 · 자방 등)은 전용 릴레이션이 아니라 고유속성이 값으로 받는다 — 자료가 늘 때 늘어나는 것이 값이 아니라 항목인 축은 스키마가 아니라 코드가 받는다.';

COMMENT ON COLUMN "문양"."문양구분_cd" IS '코드그룹 문양';

COMMENT ON TABLE "명문" IS '유물에 새겨진 문자 흔적.';

COMMENT ON TABLE "유물조합" IS '접합 · 쌍 · 연 · 조 등 유물의 조합 관계를 후속 사건에 따른 새 개체로 적재한다.';

COMMENT ON COLUMN "유물조합"."조합유형_cd" IS '코드그룹 조합유형';

COMMENT ON TABLE "조합개체" IS '유물 ↔ 유물조합 N:M. 조합에 참여하는 유물의 참여 관계.';

COMMENT ON TABLE "측정" IS '범용 계측 릴레이션. 유구 · 층위 · 유구시설 · 유물부위 · 시료 5종 부모 가운데 하나를 참조한다. 코드값이 아니라 수(數)로 기록되는 축은 여기가 받는다.';

COMMENT ON COLUMN "측정"."측정항목_cd" IS '코드그룹 측정항목';

COMMENT ON COLUMN "측정"."측정단위_cd" IS '코드그룹 측정단위';

COMMENT ON COLUMN "측정"."측정방법_cd" IS '코드그룹 측정방법';

COMMENT ON TABLE "시료" IS '채취 대상 4종(층위 · 유구 · 발굴구획 · 유물) 가운데 하나를 참조한다.';

COMMENT ON TABLE "과학분석" IS '시료를 경유하는 분석(파괴)과 유물을 직접 대상으로 하는 분석(비파괴)의 두 갈래. CHECK: 시료ID · 유물ID 가운데 정확히 하나만 NOT NULL.';

COMMENT ON COLUMN "과학분석"."유물ID" IS '비파괴 분석의 대상 유물. 시료ID 와 배타적';

COMMENT ON COLUMN "과학분석"."분석종류_cd" IS '코드그룹 분석종류';

COMMENT ON COLUMN "과학분석"."측정단위_cd" IS '코드그룹 측정단위';

COMMENT ON TABLE "조사자료" IS '사진 · 도면 · 3D 등 조사 산출물의 카탈로그(메타데이터와 색인). 주대상 FK 6종(조사 · 구획 · 단면도 · 층위 · 유구 · 유물) 가운데 정확히 하나만 채운다 — 여럿이면 삭제 연쇄에서 어느 것을 따라야 하는지 정해지지 않는다. CHECK: 6종 가운데 정확히 하나만 NOT NULL.';

COMMENT ON COLUMN "조사자료"."자료유형_cd" IS '코드그룹 자료유형';

COMMENT ON TABLE "코드" IS '어휘 사전. 모든 _cd 열의 도착점. 유일키가 (코드그룹, 상위코드ID, 코드값)이므로 같은 코드값이 부모만 달리해 여럿 있을 수 있다. (코드ID, 상위코드ID) 유일키는 고유속성의 복합 FK 가 참조한다.';

COMMENT ON COLUMN "코드"."상위코드ID" IS '자기참조 — 수직 분류 체계(시소러스의 계층 관계)';

COMMENT ON TABLE "코드관계매핑" IS '코드 사이의 수평 규칙(시소러스의 연관 · 등가 관계). 기준 코드의 상위 마디에 걸면 하위 마디가 상속한다. 예: 유물분류.수막새 → 부위.화판부 (부위적용가능).';

COMMENT ON COLUMN "코드관계매핑"."관계유형_cd" IS '코드그룹 관계유형 — 부위적용가능 · 문양적용가능 · 속성적용가능 · 흔적적용가능 · 면적용가능 · 재료적용가능 · 동의어 · 관련어';

COMMENT ON TABLE "고유속성" IS '분류 체계에서 파생되는 세부 속성을 대상 - 속성 - 값 삼항으로 적재하는 횡단 릴레이션. 분류가 속성을 부른다 — 코드관계매핑(속성적용가능)이 유구분류 · 유물분류 · 문양 → 고유속성항목 을 선언하고, 입력은 그 선언만큼만 열린다. 새 속성 축은 코드 추가만으로 수용한다. CHECK: 부모 5종(유물 · 유물부위 · 유구 · 유구시설 · 문양) 가운데 정확히 하나만 NOT NULL (배타적 아크). 개체당 같은 속성은 하나.';

COMMENT ON COLUMN "고유속성"."속성_cd" IS '코드그룹 고유속성항목 · 속성을 정의하는 마디';

COMMENT ON COLUMN "고유속성"."속성값_cd" IS '속성_cd 의 자식 마디. 복합 FK (속성값_cd, 속성_cd) → 코드(코드ID, 상위코드ID) 로 부모-자식 정합성을 강제';

COMMENT ON TABLE "변경기록" IS '값의 갱신을 하나의 사건으로 적재한다. 개체 릴레이션에는 늘 현재의 확정값만 두어 조회를 단순하게 유지하고(현재 상태와 이력의 분리), 값이 그 값이 되기까지의 경위를 사후 검증의 근거로 남긴다. 대상 행은 (대상릴레이션, 대상키) 문자열로 가리킨다 — 대상 행이 삭제되어도 이력은 남아야 하므로 FK 를 걸지 않는다.';

ALTER TABLE "조사구역" ADD FOREIGN KEY ("조사ID") REFERENCES "사업단위" ("조사ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "조사구역" ADD FOREIGN KEY ("상위구역ID") REFERENCES "조사구역" ("구역ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "발굴구획" ADD FOREIGN KEY ("구역ID") REFERENCES "조사구역" ("구역ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "층위" ADD FOREIGN KEY ("단면도ID") REFERENCES "토층단면도" ("단면도ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "복합토질" ADD FOREIGN KEY ("층위ID") REFERENCES "층위" ("층위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "층위관계" ADD FOREIGN KEY ("기준층위ID") REFERENCES "층위" ("층위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "층위관계" ADD FOREIGN KEY ("대상층위ID") REFERENCES "층위" ("층위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "매핑_구획_단면도" ADD FOREIGN KEY ("구획ID") REFERENCES "발굴구획" ("구획ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "매핑_구획_단면도" ADD FOREIGN KEY ("단면도ID") REFERENCES "토층단면도" ("단면도ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구" ADD FOREIGN KEY ("구역ID") REFERENCES "조사구역" ("구역ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구" ADD FOREIGN KEY ("상위유구ID") REFERENCES "유구" ("유구ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구시설" ADD FOREIGN KEY ("유구ID") REFERENCES "유구" ("유구ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구관계" ADD FOREIGN KEY ("기준유구ID") REFERENCES "유구" ("유구ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구관계" ADD FOREIGN KEY ("대상유구ID") REFERENCES "유구" ("유구ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "매핑_유구_구획" ADD FOREIGN KEY ("유구ID") REFERENCES "유구" ("유구ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "매핑_유구_구획" ADD FOREIGN KEY ("구획ID") REFERENCES "발굴구획" ("구획ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "매핑_유구_층위" ADD FOREIGN KEY ("유구ID") REFERENCES "유구" ("유구ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "매핑_유구_층위" ADD FOREIGN KEY ("층위ID") REFERENCES "층위" ("층위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유물" ADD FOREIGN KEY ("출토층위ID") REFERENCES "층위" ("층위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유물" ADD FOREIGN KEY ("구획ID") REFERENCES "발굴구획" ("구획ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유물" ADD FOREIGN KEY ("유구ID") REFERENCES "유구" ("유구ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유물부위" ADD FOREIGN KEY ("유물ID") REFERENCES "유물" ("유물ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "표면흔적" ADD FOREIGN KEY ("유물부위ID") REFERENCES "유물부위" ("유물부위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "제작속성" ADD FOREIGN KEY ("유물부위ID") REFERENCES "유물부위" ("유물부위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "형태요소" ADD FOREIGN KEY ("유물부위ID") REFERENCES "유물부위" ("유물부위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "문양" ADD FOREIGN KEY ("유물부위ID") REFERENCES "유물부위" ("유물부위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "명문" ADD FOREIGN KEY ("유물부위ID") REFERENCES "유물부위" ("유물부위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "조합개체" ADD FOREIGN KEY ("유물ID") REFERENCES "유물" ("유물ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "조합개체" ADD FOREIGN KEY ("조합ID") REFERENCES "유물조합" ("조합ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "측정" ADD FOREIGN KEY ("유구ID") REFERENCES "유구" ("유구ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "측정" ADD FOREIGN KEY ("층위ID") REFERENCES "층위" ("층위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "측정" ADD FOREIGN KEY ("시설ID") REFERENCES "유구시설" ("시설ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "측정" ADD FOREIGN KEY ("유물부위ID") REFERENCES "유물부위" ("유물부위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "측정" ADD FOREIGN KEY ("시료ID") REFERENCES "시료" ("시료ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "시료" ADD FOREIGN KEY ("층위ID") REFERENCES "층위" ("층위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "시료" ADD FOREIGN KEY ("유구ID") REFERENCES "유구" ("유구ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "시료" ADD FOREIGN KEY ("구획ID") REFERENCES "발굴구획" ("구획ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "시료" ADD FOREIGN KEY ("유물ID") REFERENCES "유물" ("유물ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "과학분석" ADD FOREIGN KEY ("시료ID") REFERENCES "시료" ("시료ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "과학분석" ADD FOREIGN KEY ("유물ID") REFERENCES "유물" ("유물ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "조사자료" ADD FOREIGN KEY ("조사ID") REFERENCES "사업단위" ("조사ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "조사자료" ADD FOREIGN KEY ("구획ID") REFERENCES "발굴구획" ("구획ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "조사자료" ADD FOREIGN KEY ("단면도ID") REFERENCES "토층단면도" ("단면도ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "조사자료" ADD FOREIGN KEY ("층위ID") REFERENCES "층위" ("층위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "조사자료" ADD FOREIGN KEY ("유구ID") REFERENCES "유구" ("유구ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "조사자료" ADD FOREIGN KEY ("유물ID") REFERENCES "유물" ("유물ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "코드" ADD FOREIGN KEY ("상위코드ID") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "코드관계매핑" ADD FOREIGN KEY ("기준코드ID") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "코드관계매핑" ADD FOREIGN KEY ("대상코드ID") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "고유속성" ADD FOREIGN KEY ("유물ID") REFERENCES "유물" ("유물ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "고유속성" ADD FOREIGN KEY ("유물부위ID") REFERENCES "유물부위" ("유물부위ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "고유속성" ADD FOREIGN KEY ("유구ID") REFERENCES "유구" ("유구ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "고유속성" ADD FOREIGN KEY ("유구시설ID") REFERENCES "유구시설" ("시설ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "고유속성" ADD FOREIGN KEY ("문양ID") REFERENCES "문양" ("문양ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "사업단위" ADD FOREIGN KEY ("조사성격_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "조사구역" ADD FOREIGN KEY ("유적성격_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "발굴구획" ADD FOREIGN KEY ("구획구분_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "층위" ADD FOREIGN KEY ("층위구분_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "층위" ADD FOREIGN KEY ("추정시기_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "층위" ADD FOREIGN KEY ("토색_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "층위" ADD FOREIGN KEY ("토질_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "층위" ADD FOREIGN KEY ("입도_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "복합토질" ADD FOREIGN KEY ("포함물_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "층위관계" ADD FOREIGN KEY ("관계유형_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구" ADD FOREIGN KEY ("유구분류_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구" ADD FOREIGN KEY ("추정시기_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구" ADD FOREIGN KEY ("평면형태_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구" ADD FOREIGN KEY ("단면형태_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구" ADD FOREIGN KEY ("잔존상태_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구시설" ADD FOREIGN KEY ("시설구분_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구시설" ADD FOREIGN KEY ("재질_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구시설" ADD FOREIGN KEY ("잔존상태_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유구관계" ADD FOREIGN KEY ("관계유형_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "매핑_유구_층위" ADD FOREIGN KEY ("관계유형_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유물" ADD FOREIGN KEY ("유물분류_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유물" ADD FOREIGN KEY ("추정시기_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유물" ADD FOREIGN KEY ("잔존상태_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유물부위" ADD FOREIGN KEY ("부위_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유물부위" ADD FOREIGN KEY ("재질_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유물부위" ADD FOREIGN KEY ("색조_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "표면흔적" ADD FOREIGN KEY ("흔적종류_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "제작속성" ADD FOREIGN KEY ("제작속성_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "제작속성" ADD FOREIGN KEY ("재료_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "형태요소" ADD FOREIGN KEY ("형태요소_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "문양" ADD FOREIGN KEY ("문양구분_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "유물조합" ADD FOREIGN KEY ("조합유형_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "측정" ADD FOREIGN KEY ("측정항목_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "측정" ADD FOREIGN KEY ("측정단위_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "측정" ADD FOREIGN KEY ("측정방법_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "과학분석" ADD FOREIGN KEY ("분석종류_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "과학분석" ADD FOREIGN KEY ("측정단위_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "조사자료" ADD FOREIGN KEY ("자료유형_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "코드관계매핑" ADD FOREIGN KEY ("관계유형_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "고유속성" ADD FOREIGN KEY ("속성_cd") REFERENCES "코드" ("코드ID") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "고유속성" ADD FOREIGN KEY ("속성값_cd", "속성_cd") REFERENCES "코드" ("코드ID", "상위코드ID") DEFERRABLE INITIALLY IMMEDIATE;

-- 배타적 아크 — 부모 열 가운데 정확히 하나만 NOT NULL
ALTER TABLE "고유속성" ADD CONSTRAINT "ck_고유속성_exactly_one_parent" CHECK (("유물ID" IS NOT NULL)::int + ("유물부위ID" IS NOT NULL)::int + ("유구ID" IS NOT NULL)::int + ("유구시설ID" IS NOT NULL)::int + ("문양ID" IS NOT NULL)::int = 1);
ALTER TABLE "조사자료" ADD CONSTRAINT "ck_조사자료_exactly_one_parent" CHECK (("조사ID" IS NOT NULL)::int + ("구획ID" IS NOT NULL)::int + ("단면도ID" IS NOT NULL)::int + ("층위ID" IS NOT NULL)::int + ("유구ID" IS NOT NULL)::int + ("유물ID" IS NOT NULL)::int = 1);
ALTER TABLE "과학분석" ADD CONSTRAINT "ck_과학분석_exactly_one_parent" CHECK (("시료ID" IS NOT NULL)::int + ("유물ID" IS NOT NULL)::int = 1);
