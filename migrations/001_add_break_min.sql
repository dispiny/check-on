-- attendance 테이블에 휴게시간(분) 컬럼 추가. Supabase 대시보드 > SQL Editor에서 실행.
alter table public.attendance
  add column if not exists "breakMin" integer not null default 60;

-- 30분/1시간 외 값 방지
alter table public.attendance
  drop constraint if exists attendance_break_min_check,
  add constraint attendance_break_min_check check ("breakMin" between 0 and 240);
