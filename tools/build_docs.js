#!/usr/bin/env node
/*
 * build_docs.js — schema/schema.dbml 에서 파생 산출물을 생성한다.
 *
 *   schema/schema.sql          PostgreSQL DDL (+ 배타적 아크 CHECK)
 *   docs/data-dictionary.md    데이터 사전 (릴레이션별 열 · 자료형 · 키 · 참조 · 설명)
 *   docs/erd.md                Mermaid ERD 3매 (논문 그림 1~3 대응, GitHub 이 렌더링)
 *
 * 실행:  cd tools && npm install && npm run build
 * 원본은 schema.dbml 하나이며, 위 세 파일은 손으로 고치지 않는다.
 */
'use strict';
const fs = require('fs');
const path = require('path');
const { Parser, exporter } = require('@dbml/core');

const ROOT = path.resolve(__dirname, '..');
const SRC = path.join(ROOT, 'schema', 'schema.dbml');
const CODE = '코드';

// 릴레이션 메타 — 논문 표 3 (단위유형 · 범주) + 영문 대역
const META = {
  '사업단위':         { en: 'Survey project',            unit: '독립', cat: '공간·층서' },
  '조사구역':         { en: 'Survey area',               unit: '독립', cat: '공간·층서' },
  '발굴구획':         { en: 'Excavation unit',           unit: '독립', cat: '공간·층서' },
  '토층단면도':       { en: 'Stratigraphic section',     unit: '독립', cat: '공간·층서' },
  '층위':             { en: 'Stratum',                   unit: '독립', cat: '공간·층서' },
  '복합토질':         { en: 'Soil inclusion',            unit: '종속', cat: '공간·층서' },
  '층위관계':         { en: 'Stratum relationship',      unit: '연관', cat: '공간·층서' },
  '매핑_구획_단면도': { en: 'Unit–section mapping',      unit: '연관', cat: '공간·층서' },
  '유구':             { en: 'Feature',                   unit: '독립', cat: '유구·유물' },
  '유구시설':         { en: 'Feature component',         unit: '종속', cat: '유구·유물' },
  '유구관계':         { en: 'Feature relationship',      unit: '연관', cat: '유구·유물' },
  '매핑_유구_구획':   { en: 'Feature–unit mapping',      unit: '연관', cat: '유구·유물' },
  '매핑_유구_층위':   { en: 'Feature–stratum mapping',   unit: '연관', cat: '유구·유물' },
  '유물':             { en: 'Artifact',                  unit: '독립', cat: '유구·유물' },
  '유물부위':         { en: 'Artifact part',             unit: '종속', cat: '유구·유물' },
  '표면흔적':         { en: 'Surface trace',             unit: '종속', cat: '유구·유물' },
  '제작속성':         { en: 'Manufacturing attribute',   unit: '종속', cat: '유구·유물' },
  '형태요소':         { en: 'Morphological element',     unit: '종속', cat: '유구·유물' },
  '문양':             { en: 'Decorative motif',          unit: '종속', cat: '유구·유물' },
  '명문':             { en: 'Inscription',               unit: '종속', cat: '유구·유물' },
  '유물조합':         { en: 'Artifact assemblage',       unit: '독립', cat: '유구·유물' },
  '조합개체':         { en: 'Assemblage member',         unit: '연관', cat: '유구·유물' },
  '측정':             { en: 'Measurement',               unit: '횡단', cat: '공통 기록' },
  '시료':             { en: 'Sample',                    unit: '횡단', cat: '공통 기록' },
  '과학분석':         { en: 'Scientific analysis',       unit: '횡단', cat: '공통 기록' },
  '조사자료':         { en: 'Documentation asset',       unit: '횡단', cat: '공통 기록' },
  '코드':             { en: 'Code (controlled vocabulary)', unit: '독립', cat: '어휘 통제·시소러스' },
  '코드관계매핑':     { en: 'Code relationship mapping', unit: '연관', cat: '어휘 통제·시소러스' },
  '고유속성':         { en: 'Class-specific attribute',  unit: '횡단', cat: '어휘 통제·시소러스' },
  '변경기록':         { en: 'Change log',                unit: '기타', cat: '기록의 변경' },
};

// 관계 모델의 선언으로 표현되지 않아 CHECK 로 옮기는 제약 — "열 가운데 정확히 하나만 NOT NULL"
const EXACTLY_ONE = {
  '고유속성': ['유물ID', '유물부위ID', '유구ID', '유구시설ID', '문양ID'],
  '조사자료': ['조사ID', '구획ID', '단면도ID', '층위ID', '유구ID', '유물ID'],
  '과학분석': ['시료ID', '유물ID'],
};

// ERD 3매 — 논문 그림 1~3. codeRefs 에 든 릴레이션만 코드사전으로 가는 선을 그린다(나머지는 생략).
const DIAGRAMS = [
  { title: '그림 1 · 공통 ERD', note: '공통 기록 · 어휘 통제 · 기록의 변경. 다른 범주의 릴레이션은 참조 대상으로만(빈 상자) 나타난다. 코드사전으로 가는 선은 어휘 통제 릴레이션(코드관계매핑 · 고유속성)의 것만 그렸다.',
    tables: ['고유속성', '측정', '시료', '과학분석', '조사자료', '코드', '코드관계매핑', '변경기록'], codeRefs: ['코드', '코드관계매핑', '고유속성'] },
  { title: '그림 2 · 공간·층서·유구 ERD', note: '코드사전(_cd 열)으로 가는 선은 생략했다. 도메인은 데이터 사전을 참조.',
    tables: ['사업단위', '조사구역', '발굴구획', '토층단면도', '층위', '복합토질', '층위관계', '매핑_구획_단면도',
             '유구', '유구시설', '유구관계', '매핑_유구_구획', '매핑_유구_층위'], codeRefs: [] },
  { title: '그림 3 · 유물 ERD', note: '코드사전(_cd 열)으로 가는 선은 생략했다. 출토 맥락(층위 · 발굴구획 · 유구)은 참조 대상으로만 나타난다.',
    tables: ['유물', '유물부위', '표면흔적', '제작속성', '형태요소', '문양', '명문', '유물조합', '조합개체'], codeRefs: [] },
];

// ── 파싱 ─────────────────────────────────────────────────────────────────────
const dbml = fs.readFileSync(SRC, 'utf8');
let db;
try { db = Parser.parse(dbml, 'dbmlv2'); } catch (e) { db = Parser.parse(dbml, 'dbml'); }
const schema = db.schemas[0];
const tables = schema.tables;
const byName = Object.fromEntries(tables.map(t => [t.name, t]));

// ref → { child, childCols, parent, parentCols, mandatory }
const refs = schema.refs.map(r => {
  const [a, b] = r.endpoints;
  const child = a.relation === '*' ? a : b;
  const parent = a.relation === '*' ? b : a;
  const t = byName[child.tableName];
  const mandatory = child.fieldNames.every(c => (t.fields.find(f => f.name === c) || {}).not_null);
  return { child: child.tableName, childCols: child.fieldNames, parent: parent.tableName, parentCols: parent.fieldNames, mandatory };
});
const refsByChild = {};
for (const r of refs) (refsByChild[r.child] = refsByChild[r.child] || []).push(r);

const groupOrder = schema.tableGroups.map(g => ({ name: g.name, tables: g.tables.map(t => t.name) }));
const missing = tables.map(t => t.name).filter(n => !META[n]);
if (missing.length) throw new Error('META 에 없는 릴레이션: ' + missing.join(', '));
const ungrouped = tables.map(t => t.name).filter(n => !groupOrder.some(g => g.tables.includes(n)));
if (ungrouped.length) throw new Error('TableGroup 에 없는 릴레이션: ' + ungrouped.join(', '));

const noteOf = x => (x && x.note ? String(x.note).replace(/\s+/g, ' ').trim() : '');
const fkOf = (tname, col) => (refsByChild[tname] || []).filter(r => r.childCols.length === 1 && r.childCols[0] === col);
const md = s => s.replace(/\|/g, '\\|');

// ── 1. PostgreSQL DDL ────────────────────────────────────────────────────────
let sql = exporter.export(dbml, 'postgres');
const checks = [];
for (const [t, cols] of Object.entries(EXACTLY_ONE)) {
  const expr = cols.map(c => `("${c}" IS NOT NULL)::int`).join(' + ');
  checks.push(`ALTER TABLE "${t}" ADD CONSTRAINT "ck_${t}_exactly_one_parent" CHECK (${expr} = 1);`);
}
sql = [
  '-- =============================================================================',
  '-- excavation-record-schema — PostgreSQL DDL',
  '-- schema/schema.dbml 에서 tools/build_docs.js 가 생성한 파일. 직접 고치지 말 것.',
  '-- 논리 스키마의 자료형(varchar · int · float)을 그대로 옮겼으며, 배타적 아크는 끝의 CHECK 로 강제한다.',
  '-- =============================================================================',
  '',
  sql.trim(),
  '',
  '-- 배타적 아크 — 부모 열 가운데 정확히 하나만 NOT NULL',
  ...checks,
  '',
].join('\n');
fs.writeFileSync(path.join(ROOT, 'schema', 'schema.sql'), sql);

// ── 2. 데이터 사전 ───────────────────────────────────────────────────────────
const dd = [];
dd.push('# 데이터 사전 (Data dictionary)');
dd.push('');
dd.push('`schema/schema.dbml` 에서 생성. 30 릴레이션을 논문 표 3의 범주 순서로 싣는다.');
dd.push('');
dd.push('- **키** — PK 기본키 · FK 외래키 · NN NOT NULL');
dd.push('- **참조** — FK 가 가리키는 `릴레이션.열`. 접미사 `_cd` 열은 모두 `코드.코드ID` 를 참조하며, 허용 범위는 설명의 코드그룹이다 ([코드그룹 목록](code-groups.md)).');
dd.push('- **단위유형** — 독립(단독으로 참조되는 개체) · 종속(다른 단위를 참조해야 식별) · 횡단(참조 대상이 여러 단위에 걸침) · 연관(두 개체 사이에서만 성립하는 관계) · 기타');
dd.push('');
dd.push('## 차례');
dd.push('');
for (const g of groupOrder) {
  dd.push(`- **${g.name}** — ` + g.tables.map(n => `[${n}](#${anchor(n)})`).join(' · '));
}
dd.push('');
for (const g of groupOrder) {
  dd.push(`## ${g.name}`);
  dd.push('');
  for (const n of g.tables) {
    const t = byName[n];
    const m = META[n];
    dd.push(`### ${n}`);
    dd.push('');
    dd.push(`*${m.en}* · 단위유형 **${m.unit}** · 범주 ${m.cat}`);
    dd.push('');
    if (noteOf(t)) { dd.push(noteOf(t)); dd.push(''); }
    dd.push('| 열 | 자료형 | 키 | 참조 | 설명 |');
    dd.push('|---|---|---|---|---|');
    for (const f of t.fields) {
      const keys = [];
      if (f.pk) keys.push('PK');
      const fks = fkOf(n, f.name);
      const comps = (refsByChild[n] || []).filter(r => r.childCols.length > 1 && r.childCols.includes(f.name));
      if (fks.length || comps.length) keys.push('FK');
      if (f.not_null && !f.pk) keys.push('NN');
      const ref = [
        ...fks.map(r => `${r.parent}.${r.parentCols[0]}`),
        ...comps.map(r => `${r.parent}(${r.parentCols.join(', ')}) 복합`),
      ].join(', ');
      dd.push(`| ${md(f.name)} | ${f.type.type_name} | ${keys.join(' ')} | ${ref} | ${md(noteOf(f))} |`);
    }
    const uniques = t.indexes.filter(i => i.unique).map(i => '(' + i.columns.map(c => c.value).join(', ') + ')');
    const composite = (refsByChild[n] || []).filter(r => r.childCols.length > 1)
      .map(r => `(${r.childCols.join(', ')}) → ${r.parent}(${r.parentCols.join(', ')})`);
    const extra = [];
    if (uniques.length) extra.push(`유일키: ${uniques.join(' · ')}`);
    if (composite.length) extra.push(`복합 FK: ${composite.join(' · ')}`);
    if (extra.length) { dd.push(''); dd.push(extra.map(e => `- ${e}`).join('\n')); }
    dd.push('');
  }
}
fs.writeFileSync(path.join(ROOT, 'docs', 'data-dictionary.md'), dd.join('\n'));

// ── 3. Mermaid ERD ───────────────────────────────────────────────────────────
const mmName = s => `"${s}"`;
const mmAttr = s => s.replace(/[^\p{L}\p{N}_]/gu, '_');
const erd = [];
erd.push('# ERD');
erd.push('');
erd.push('`schema/schema.dbml` 에서 생성한 Mermaid 도표. 논문의 그림 1~3 에 대응한다. 전체 결선을 한 장으로 보려면 `schema.dbml` 을 [dbdiagram.io](https://dbdiagram.io) 에 붙여 넣는다.');
erd.push('');
erd.push('선 끝의 기호 — `||` 정확히 하나 · `|o` 0 또는 하나 · `o{` 0 이상 여럿. 선 위의 이름은 참조하는 열(FK).');
erd.push('');
for (const d of DIAGRAMS) {
  const set = new Set(d.tables);
  erd.push(`## ${d.title}`);
  erd.push('');
  erd.push(d.note);
  erd.push('');
  erd.push('```mermaid');
  erd.push('erDiagram');
  const external = new Set();
  const lines = [];
  for (const r of refs) {
    if (!set.has(r.child)) continue;
    if (r.parent === CODE && !d.codeRefs.includes(r.child)) continue;
    if (!set.has(r.parent)) external.add(r.parent);
    const parentEnd = r.mandatory ? '||' : '|o';
    lines.push(`  ${mmName(r.parent)} ${parentEnd}--o{ ${mmName(r.child)} : ${mmName(r.childCols.join(', '))}`);
  }
  erd.push(...lines);
  for (const n of d.tables) {
    const t = byName[n];
    erd.push(`  ${mmName(n)} {`);
    for (const f of t.fields) {
      const keys = [];
      if (f.pk) keys.push('PK');
      if (fkOf(n, f.name).length || (refsByChild[n] || []).some(r => r.childCols.includes(f.name))) keys.push('FK');
      const m = /코드그룹 ([^\s·]+)/.exec(noteOf(f));
      const comment = m ? ` "${m[1]}"` : '';
      erd.push(`    ${f.type.type_name} ${mmAttr(f.name)}${keys.length ? ' ' + keys.join(', ') : ''}${comment}`);
    }
    erd.push('  }');
  }
  for (const n of [...external].sort()) erd.push(`  ${mmName(n)} {\n  }`);
  erd.push('```');
  erd.push('');
}
fs.writeFileSync(path.join(ROOT, 'docs', 'erd.md'), erd.join('\n'));

// ── 요약 ─────────────────────────────────────────────────────────────────────
const nCols = tables.reduce((s, t) => s + t.fields.length, 0);
console.log(`릴레이션 ${tables.length} · 열 ${nCols} · 참조 ${refs.length} (코드사전 ${refs.filter(r => r.parent === CODE).length})`);
console.log('→ schema/schema.sql · docs/data-dictionary.md · docs/erd.md');

function anchor(s) { return s.toLowerCase().replace(/[^\p{L}\p{N}\s_-]/gu, '').replace(/\s/g, '-'); }
