-- excavation-record-schema v2.0.0 — DDL (표준 SQL)
-- 자료형은 논리 자료형이다. 정수 대리키의 자동 증가는 DBMS 의 구문으로 지정한다.

CREATE TABLE "코드" (
  "코드ID" INTEGER PRIMARY KEY,
  "상위코드ID" INTEGER REFERENCES "코드" ("코드ID"),
  "코드그룹" VARCHAR,
  "코드값" VARCHAR,
  "정렬순서" INTEGER,
  "사용여부" INTEGER,
  UNIQUE ("코드ID", "상위코드ID"),
  UNIQUE ("코드그룹", "상위코드ID", "코드값")
);

CREATE TABLE "사업단위" (
  "조사ID" VARCHAR PRIMARY KEY,
  "사업명" VARCHAR,
  "조사차수" VARCHAR,
  "조사성격_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "소재지" VARCHAR,
  "조사면적" FLOAT,
  "발굴허가번호" VARCHAR,
  "조사시작일" VARCHAR,
  "조사종료일" VARCHAR,
  "조사기관" VARCHAR,
  "조사단장" VARCHAR,
  "책임조사원" VARCHAR,
  "기타" VARCHAR
);

CREATE TABLE "조사구역" (
  "구역ID" VARCHAR PRIMARY KEY,
  "조사ID" VARCHAR REFERENCES "사업단위" ("조사ID"),
  "상위구역ID" VARCHAR REFERENCES "조사구역" ("구역ID"),
  "구역명" VARCHAR,
  "유적성격_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "공간좌표_구역" VARCHAR,
  "조사원" VARCHAR,
  "비고" VARCHAR
);

CREATE TABLE "발굴구획" (
  "구획ID" VARCHAR PRIMARY KEY,
  "구역ID" VARCHAR REFERENCES "조사구역" ("구역ID"),
  "구획구분_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "구획명" VARCHAR,
  "구획일자" VARCHAR,
  "조사원" VARCHAR,
  "비고" VARCHAR
);

CREATE TABLE "기준층위" (
  "기준층위ID" VARCHAR PRIMARY KEY,
  "기준층위명" VARCHAR,
  "비고" VARCHAR
);

CREATE TABLE "토층" (
  "토층ID" VARCHAR PRIMARY KEY,
  "기준층위ID" VARCHAR REFERENCES "기준층위" ("기준층위ID"),
  "토층명" VARCHAR,
  "토층번호" VARCHAR,
  "토층구분_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "현장편년_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "토색_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "토질_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "입도_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "비고" VARCHAR
);

CREATE TABLE "혼입요소" (
  "포함물ID" VARCHAR PRIMARY KEY,
  "토층ID" VARCHAR REFERENCES "토층" ("토층ID"),
  "포함물_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "비고" VARCHAR,
  UNIQUE ("토층ID", "포함물_cd")
);

CREATE TABLE "층서관계" (
  "관계ID" INTEGER PRIMARY KEY,
  "기준층서ID" VARCHAR REFERENCES "토층" ("토층ID"),
  "대상층서ID" VARCHAR REFERENCES "토층" ("토층ID"),
  "관계유형_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "비고" VARCHAR,
  UNIQUE ("기준층서ID", "대상층서ID", "관계유형_cd")
);

CREATE TABLE "매핑_구획_기준층위" (
  "매핑ID" INTEGER PRIMARY KEY,
  "구획ID" VARCHAR REFERENCES "발굴구획" ("구획ID"),
  "기준층위ID" VARCHAR REFERENCES "기준층위" ("기준층위ID"),
  "비고" VARCHAR,
  UNIQUE ("구획ID", "기준층위ID")
);

CREATE TABLE "유구" (
  "유구ID" VARCHAR PRIMARY KEY,
  "구역ID" VARCHAR REFERENCES "조사구역" ("구역ID"),
  "상위유구ID" VARCHAR REFERENCES "유구" ("유구ID"),
  "유구명" VARCHAR,
  "유구번호" VARCHAR,
  "유구분류_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "현장편년_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "공간좌표_유구" VARCHAR,
  "평면형태_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "단면형태_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "주축방향" VARCHAR,
  "잔존상태_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "조사자" VARCHAR,
  "기타" VARCHAR
);

CREATE TABLE "유구시설" (
  "시설ID" VARCHAR PRIMARY KEY,
  "유구ID" VARCHAR REFERENCES "유구" ("유구ID"),
  "시설구분_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "시설형태_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "재질_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "잔존상태_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "수량" INTEGER,
  "비고" VARCHAR
);

CREATE TABLE "유구관계" (
  "관계ID" INTEGER PRIMARY KEY,
  "기준유구ID" VARCHAR REFERENCES "유구" ("유구ID"),
  "대상유구ID" VARCHAR REFERENCES "유구" ("유구ID"),
  "관계유형_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "비고" VARCHAR,
  UNIQUE ("기준유구ID", "대상유구ID", "관계유형_cd")
);

CREATE TABLE "매핑_유구_구획" (
  "매핑ID" INTEGER PRIMARY KEY,
  "유구ID" VARCHAR REFERENCES "유구" ("유구ID"),
  "구획ID" VARCHAR REFERENCES "발굴구획" ("구획ID"),
  UNIQUE ("유구ID", "구획ID")
);

CREATE TABLE "매핑_유구_층서" (
  "매핑ID" INTEGER PRIMARY KEY,
  "유구ID" VARCHAR REFERENCES "유구" ("유구ID"),
  "토층ID" VARCHAR REFERENCES "토층" ("토층ID"),
  "관계유형_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "비고" VARCHAR,
  UNIQUE ("유구ID", "토층ID", "관계유형_cd")
);

CREATE TABLE "유물" (
  "유물ID" VARCHAR PRIMARY KEY,
  "출토토층ID" VARCHAR REFERENCES "토층" ("토층ID"),
  "구획ID" VARCHAR REFERENCES "발굴구획" ("구획ID"),
  "유구ID" VARCHAR REFERENCES "유구" ("유구ID"),
  "유물명" VARCHAR,
  "유물번호" VARCHAR,
  "유물분류_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "현장편년_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "출토위치" VARCHAR,
  "공간좌표_유물" VARCHAR,
  "수량" INTEGER,
  "잔존상태_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "수습일자" VARCHAR,
  "조사자" VARCHAR,
  "비고" VARCHAR,
  FOREIGN KEY ("유구ID", "구획ID") REFERENCES "매핑_유구_구획" ("유구ID", "구획ID")
);

CREATE TABLE "유물부위" (
  "유물부위ID" VARCHAR PRIMARY KEY,
  "유물ID" VARCHAR REFERENCES "유물" ("유물ID"),
  "부위_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "재질_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "색조_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "비고" VARCHAR,
  UNIQUE ("유물ID", "부위_cd")
);

CREATE TABLE "형태요소" (
  "형태요소ID" VARCHAR PRIMARY KEY,
  "유물부위ID" VARCHAR REFERENCES "유물부위" ("유물부위ID"),
  "형태요소_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "수량" INTEGER,
  "비고" VARCHAR
);

CREATE TABLE "문양" (
  "문양ID" VARCHAR PRIMARY KEY,
  "유물부위ID" VARCHAR REFERENCES "유물부위" ("유물부위ID"),
  "문양구분_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "면_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "비고" VARCHAR
);

CREATE TABLE "표면흔적" (
  "표면흔적ID" VARCHAR PRIMARY KEY,
  "유물부위ID" VARCHAR REFERENCES "유물부위" ("유물부위ID"),
  "흔적종류_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "면_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "비고" VARCHAR
);

CREATE TABLE "제작속성" (
  "제작속성ID" VARCHAR PRIMARY KEY,
  "유물부위ID" VARCHAR NOT NULL REFERENCES "유물부위" ("유물부위ID"),
  "제작속성_cd" INTEGER NOT NULL REFERENCES "코드" ("코드ID"),
  "재료_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "면_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "비고" VARCHAR,
  UNIQUE ("유물부위ID", "제작속성_cd")
);

CREATE TABLE "명문" (
  "명문ID" VARCHAR PRIMARY KEY,
  "유물부위ID" VARCHAR REFERENCES "유물부위" ("유물부위ID"),
  "명문내용" VARCHAR,
  "비고" VARCHAR
);

CREATE TABLE "유물조합" (
  "조합ID" VARCHAR PRIMARY KEY,
  "조합유형_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "조합유물명" VARCHAR,
  "비고" VARCHAR
);

CREATE TABLE "조합개체" (
  "매핑ID" INTEGER PRIMARY KEY,
  "조합ID" VARCHAR REFERENCES "유물조합" ("조합ID"),
  "유물ID" VARCHAR REFERENCES "유물" ("유물ID"),
  "비고" VARCHAR,
  UNIQUE ("조합ID", "유물ID")
);

CREATE TABLE "시료" (
  "시료ID" VARCHAR PRIMARY KEY,
  "토층ID" VARCHAR REFERENCES "토층" ("토층ID"),
  "유구ID" VARCHAR REFERENCES "유구" ("유구ID"),
  "구획ID" VARCHAR REFERENCES "발굴구획" ("구획ID"),
  "유물ID" VARCHAR REFERENCES "유물" ("유물ID"),
  "시료번호" VARCHAR,
  "채취일자" VARCHAR,
  "채취자" VARCHAR,
  "채취부위" VARCHAR,
  "비고" VARCHAR,
  CONSTRAINT "ck_시료_채취맥락" CHECK ((CASE WHEN "토층ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "유구ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "구획ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "유물ID" IS NULL THEN 0 ELSE 1 END) >= 1)
);

CREATE TABLE "측정" (
  "측정ID" VARCHAR PRIMARY KEY,
  "유구ID" VARCHAR REFERENCES "유구" ("유구ID"),
  "토층ID" VARCHAR REFERENCES "토층" ("토층ID"),
  "시설ID" VARCHAR REFERENCES "유구시설" ("시설ID"),
  "유물ID" VARCHAR REFERENCES "유물" ("유물ID"),
  "유물부위ID" VARCHAR REFERENCES "유물부위" ("유물부위ID"),
  "문양ID" VARCHAR REFERENCES "문양" ("문양ID"),
  "시료ID" VARCHAR REFERENCES "시료" ("시료ID"),
  "측정항목_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "측정값" FLOAT,
  "측정단위_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "측정방법_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "측정자" VARCHAR,
  "측정일자" VARCHAR,
  CONSTRAINT "ck_측정_소유단위" CHECK ((CASE WHEN "유구ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "토층ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "시설ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "유물ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "유물부위ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "문양ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "시료ID" IS NULL THEN 0 ELSE 1 END) = 1)
);

CREATE TABLE "과학분석" (
  "분석ID" VARCHAR PRIMARY KEY,
  "시료ID" VARCHAR REFERENCES "시료" ("시료ID"),
  "유물ID" VARCHAR REFERENCES "유물" ("유물ID"),
  "분석종류_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "측정값" FLOAT,
  "측정값_하한" FLOAT,
  "측정값_상한" FLOAT,
  "오차" FLOAT,
  "측정단위_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "분석자" VARCHAR,
  "분석기관" VARCHAR,
  "분석일자" VARCHAR,
  "비고" VARCHAR,
  CONSTRAINT "ck_과학분석_대상" CHECK ((CASE WHEN "시료ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "유물ID" IS NULL THEN 0 ELSE 1 END) = 1)
);

CREATE TABLE "조사자료" (
  "조사자료ID" VARCHAR PRIMARY KEY,
  "조사ID" VARCHAR REFERENCES "사업단위" ("조사ID"),
  "구획ID" VARCHAR REFERENCES "발굴구획" ("구획ID"),
  "기준층위ID" VARCHAR REFERENCES "기준층위" ("기준층위ID"),
  "토층ID" VARCHAR REFERENCES "토층" ("토층ID"),
  "유구ID" VARCHAR REFERENCES "유구" ("유구ID"),
  "유물ID" VARCHAR REFERENCES "유물" ("유물ID"),
  "분석ID" VARCHAR REFERENCES "과학분석" ("분석ID"),
  "자료유형_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "자료번호" VARCHAR,
  "저장위치" VARCHAR,
  "원본파일명" VARCHAR,
  "확장자" VARCHAR,
  "등록일자" VARCHAR,
  "촬영일자" VARCHAR,
  "촬영자" VARCHAR,
  "촬영구분_cd" INTEGER REFERENCES "코드" ("코드ID"),
  "캡션" VARCHAR,
  CONSTRAINT "ck_조사자료_주대상" CHECK ((CASE WHEN "조사ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "구획ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "기준층위ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "토층ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "유구ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "유물ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "분석ID" IS NULL THEN 0 ELSE 1 END) <= 1)
);

CREATE TABLE "코드관계매핑" (
  "매핑ID" INTEGER PRIMARY KEY,
  "기준코드ID" INTEGER NOT NULL REFERENCES "코드" ("코드ID"),
  "대상코드ID" INTEGER NOT NULL REFERENCES "코드" ("코드ID"),
  "관계유형_cd" INTEGER NOT NULL REFERENCES "코드" ("코드ID"),
  "비고" VARCHAR,
  UNIQUE ("기준코드ID", "대상코드ID", "관계유형_cd")
);

CREATE TABLE "고유속성" (
  "고유속성ID" INTEGER PRIMARY KEY,
  "유물ID" VARCHAR REFERENCES "유물" ("유물ID"),
  "유물부위ID" VARCHAR REFERENCES "유물부위" ("유물부위ID"),
  "유구ID" VARCHAR REFERENCES "유구" ("유구ID"),
  "시설ID" VARCHAR REFERENCES "유구시설" ("시설ID"),
  "문양ID" VARCHAR REFERENCES "문양" ("문양ID"),
  "속성_cd" INTEGER NOT NULL REFERENCES "코드" ("코드ID"),
  "속성값_cd" INTEGER NOT NULL REFERENCES "코드" ("코드ID"),
  "비고" VARCHAR,
  UNIQUE ("문양ID", "속성_cd"),
  UNIQUE ("시설ID", "속성_cd"),
  UNIQUE ("유구ID", "속성_cd"),
  UNIQUE ("유물ID", "속성_cd"),
  UNIQUE ("유물부위ID", "속성_cd"),
  FOREIGN KEY ("속성값_cd", "속성_cd") REFERENCES "코드" ("코드ID", "상위코드ID"),
  CONSTRAINT "ck_고유속성_대상" CHECK ((CASE WHEN "유물ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "유물부위ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "유구ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "시설ID" IS NULL THEN 0 ELSE 1 END) + (CASE WHEN "문양ID" IS NULL THEN 0 ELSE 1 END) = 1)
);

CREATE TABLE "기록변경로그" (
  "로그ID" INTEGER PRIMARY KEY,
  "시각" VARCHAR,
  "테이블" VARCHAR NOT NULL,
  "키" VARCHAR NOT NULL,
  "이름" VARCHAR,
  "컬럼" VARCHAR NOT NULL,
  "이전값" VARCHAR,
  "이후값" VARCHAR,
  "변경자" VARCHAR,
  "사유" VARCHAR
);
