/*
 *
 * 팀 명 : TEAM 5 (BLACK PINK)
 * 팀 원 : 이성영, 조현손, 김진희, 정인보
 * MUZE 인력 관리 시스템
 * TABLE : KB_EMP(인사정보), EMP_POOL(직원별 직무 점수 정보), EMP_WORK(근무이력), EMP_STUDY(연수이력), EMP_CERTIFICATE(자격증이력)
 * SELECT, UPDATE SQL
 * 
 */

/*
 * 1.나의 정보 보기
 */
-- 개인정보
SELECT e.EMPNO, e.ENAME, e.BIRTH, e.GENDER, e.HIREDATE, w.DEPTNAME AS CURRENT_DEPTNAME, e.TITLE, e.MAJOR
FROM KB_EMP e LEFT OUTER JOIN (
	SELECT w1.*, RANK()OVER(PARTITION BY w1.EMPNO ORDER BY w1.SEQ DESC) AS EMP_RANK
	FROM EMP_WORK w1 ) w
	ON e.EMPNO = w.EMPNO AND w.EMP_RANK = 1
WHERE e.EMPNO = '1234567';

-- 연락정보
SELECT CONTACT, ADDRESS, EMAIL
FROM KB_EMP
WHERE EMPNO = '1234567';

-- 연락정보 > 핸드폰번호 변경
UPDATE KB_EMP
SET CONTACT = '010-6656-5394'
WHERE EMPNO = '1234567';

-- 근무이력
SELECT SEQ, WORK_STARTDATE, WORK_ENDDATE, DEPTNAME, JOBNO
FROM EMP_WORK
WHERE EMPNO = '1234567'
ORDER BY SEQ DESC;

-- 2. 연수 수료과정
SELECT STUDYNO, STUDYCODE, STUDYNAME, SCORE, JOBNO
FROM EMP_STUDY
WHERE EMPNO = '1234567';

-- 2. 자격 취득과정
SELECT CERTNO, CERTNAME, CERTGETDATE, GRADE, JOBNO
FROM EMP_CERTIFICATE
WHERE EMPNO = '1234567';

/*
 * 3.개인별 직무 점수 보기
 */

/* 직무 점수 계산 */
-- 근무이력(EMP_WORK)을 참조하여 2년 이상 근무한 경우 직무 점수 정보를 +1점 UPDATE 해준다.
--초기화
UPDATE EMP_POOL 
SET SCORE = 0;

--1.
UPDATE EMP_POOL ep
SET ep.SCORE = ep.SCORE + 1
WHERE ep.JOBNO IN ('UB', 'IT', 'BIZ')
AND EXISTS (
    SELECT 'UB', 'IT', 'BIZ'
    FROM EMP_WORK ew
    WHERE ew.JOBNO = ep.JOBNO
    AND ew.EMPNO = ep.EMPNO
    AND (WORK_ENDDATE - WORK_STARTDATE) >= 730
);

--2. 연수(EMP_STUDY)를 참조하여 직무 점수 정보를 +1점 UPDATE 해준다.
UPDATE EMP_POOL E
SET SCORE = SCORE + (
  SELECT COUNT(*)
  FROM EMP_STUDY ES
  WHERE ES.JOBNO = E.JOBNO
    AND ES.EMPNO = E.EMPNO
    AND ES.JOBNO IN ('UB', 'IT', 'BIZ')
);

--3. 자격증(EMP_CERTIFICATE)을 참조하여 직무 점수 정보를 +1점 UPDATE 해준다.
UPDATE EMP_POOL E
SET SCORE = SCORE + (
  SELECT COUNT(*)
  FROM EMP_CERTIFICATE EC
  WHERE EC.JOBNO = E.JOBNO
    AND EC.EMPNO = E.EMPNO
    AND EC.JOBNO IN ('UB', 'IT', 'BIZ')
);

--4. 관련 전공(KB_EMP)을 참조하여 컴퓨터 관련 전공인 경우 IT 직무 점수 정보를 +1점 UPDATE 해준다.
UPDATE EMP_POOL
SET SCORE = SCORE + 1
WHERE (EMPNO, JOBNO) IN
	(SELECT EMPNO, 'IT' AS JOBNO
	FROM KB_EMP
	WHERE MAJOR LIKE '%컴퓨터%'); 

-- 조현손 대리 : 직무점수 조회하기
SELECT * FROM EMP_POOL
WHERE EMPNO = '1234567'; 

/*
 * KB차세대 인력 POOL 전체조회(HR담당자 전용)
 */

-- UB 9명 수만 추출
SELECT E.JOBNO, COUNT(*) AS CNT
FROM (SELECT EMPNO, JOBNO, SCORE, ROW_NUMBER()OVER(PARTITION BY EMPNO ORDER BY SCORE DESC) AS SCORE_RANK
	FROM EMP_POOL) E -- 동일 점수는 동일 등수 안되게 처리
WHERE E.SCORE_RANK = 1
AND E.JOBNO = 'UB'
GROUP BY E.JOBNO;

-- UB 대상 전체조회 추출
SELECT E.EMPNO, K.ENAME, K.TITLE, E.SCORE
FROM (SELECT EMPNO, JOBNO, SCORE, ROW_NUMBER()OVER(PARTITION BY EMPNO ORDER BY SCORE DESC) AS SCORE_RANK
	FROM EMP_POOL) E -- 동일 점수는 동일 등수 안되게 처리
	JOIN KB_EMP K ON E.EMPNO = K.EMPNO
WHERE E.SCORE_RANK = 1
AND E.JOBNO = 'UB';

-- IT 명수만 추출
SELECT E.JOBNO, COUNT(*) AS CNT
FROM (SELECT EMPNO, JOBNO, SCORE, ROW_NUMBER()OVER(PARTITION BY EMPNO ORDER BY SCORE DESC) AS SCORE_RANK
	FROM EMP_POOL) E -- 동일 점수는 동일 등수 안되게 처리
WHERE E.SCORE_RANK = 1
AND E.JOBNO = 'IT'
GROUP BY E.JOBNO;

-- IT 대상 전체조회 추출
SELECT E.EMPNO, K.ENAME, K.TITLE, E.SCORE
FROM (SELECT EMPNO, JOBNO, SCORE, ROW_NUMBER()OVER(PARTITION BY EMPNO ORDER BY SCORE DESC) AS SCORE_RANK
	FROM EMP_POOL) E -- 동일 점수는 동일 등수 안되게 처리
	JOIN KB_EMP K ON E.EMPNO = K.EMPNO
WHERE E.SCORE_RANK = 1
AND E.JOBNO = 'IT';

-- BIZ 명수만 추출
SELECT E.JOBNO, COUNT(*) AS CNT
FROM (SELECT EMPNO, JOBNO, SCORE, ROW_NUMBER()OVER(PARTITION BY EMPNO ORDER BY SCORE DESC) AS SCORE_RANK
	FROM EMP_POOL) E -- 동일 점수는 동일 등수 안되게 처리
WHERE E.SCORE_RANK = 1
AND E.JOBNO = 'BIZ'
GROUP BY E.JOBNO;

-- BIZ 전체조회 추출
SELECT E.EMPNO, K.ENAME, K.TITLE, E.SCORE
FROM (SELECT EMPNO, JOBNO, SCORE, ROW_NUMBER()OVER(PARTITION BY EMPNO ORDER BY SCORE DESC) AS SCORE_RANK
	FROM EMP_POOL) E -- 동일 점수는 동일 등수 안되게 처리
	JOIN KB_EMP K ON E.EMPNO = K.EMPNO
WHERE E.SCORE_RANK = 1
AND E.JOBNO = 'BIZ';