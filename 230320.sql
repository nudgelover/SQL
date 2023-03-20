--SAL 가장 많은 사람 추출하기
SELECT *
FROM EMP
WHERE SAL = (SELECT max(SAL) FROM EMP);

--SAL 가장 적은 사람 추출하기
SELECT *
FROM EMP
WHERE SAL = (SELECT min(SAL) FROM EMP);

--upper
SELECT *
FROM EMP
WHERE UPPER(ENAME) = UPPER('scott');

--TRIM : 공란 제거
SELECT TRIM('  ___ORCLE_ _ _ ') 
FROM dual; //의미가 없는 양쪽에 붙은 공란만 제거. 즉 _ _ _ 이 사이의 공란은 제거되지 않는다.


--concat 문자열 연결
SELECT EMPNO 
	  , ENAME 
	  , CONCAT(EMPNO, ENAME) 
	  , CONCAT(EMPNO, ' ')
FROM EMP

--REPLACE 교체
--주요 예시 : 휴대폰 번호, 이메일, 집주소 등등

SELECT '010-7659-0206' AS MOBILE_PHONE
	,REPLACE ('010-7659-0206','-','') AS REPLACE
	FROM DUAL;

--LPAD, RPAD  문자열을 채우기하는 함수
--PADDING 함수는 문자열의 자리수를 일치시키기 위한 함수

SELECT LPAD('ORALE_1234_XE',20) AS LPAD_20
	, RPAD('ORALE_1234_XE',20) AS RPAD_20
FROM DUAL;


--number 관련 함수

SELECT  ROUND(3.1428,3) AS ROUND0
	,	ROUND(123.45678,3) AS ROUND1
	,	TRUNC(123.45678,3) AS TRUNC0
	,	TRUNC(123.45678,2) AS TRUNC1
FROM DUAL;

SELECT CEIL(3.14) AS CEIL0
	, FLOOR(3.14) AS FLOOR0
	, MOD(15, 6) AS MOD0
	, MOD(11, 1) AS MOD1
FROM dual;


SELECT EMPNO ,ENAME, HIREDATE
	ADD_MONTHS(HIREDATE, 12*20) AS WORK20YEAR
FROM EMP;



SELECT SYSDATE,
	NEXT_DAY(SYSDATE,'월요일'),
	LAST_DAY(SYSDATE)
FROM DUAL;



SELECT ENAME
		, EXTRACT(YEAR FROM HIREDATE) AS Y
		, EXTRACT(MONTH FROM HIREDATE) AS M
		, EXTRACT(DAY FROM HIREDATE) AS D
FROM EMP;


SELECT SYSDATE, ROUND(SYSDATE,'CC') AS FORMAT_CC,
       SYSDATE, ROUND(SYSDATE,'YYYY') AS FORMAT_YYYY,
       SYSDATE, ROUND(SYSDATE,'Q') AS FORMAT_Q,
       SYSDATE, ROUND(SYSDATE,'DDD') AS FORMAT_DDD,
       SYSDATE, ROUND(SYSDATE,'HH') AS FORMAT_HH
FROM DUAL;



--명시적 형 변환
--24시간 표시, 시분초까지 표시
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') AS CURRENT_DATETIME
FROM DUAL;

SELECT SYSDATE 
	,TO_CHAR(SYSDATE, 'MM') AS MM
	,TO_CHAR(SYSDATE, 'MON') AS MON
	,TO_CHAR(SYSDATE, 'MONTH') AS MONTH
	,TO_CHAR(SYSDATE, 'MON','NLS_DATE_LANGUAGE = JAPANESE') AS MON_JPN
	,TO_CHAR(SYSDATE, 'MON','NLS_DATE_LANGUAGE = ENGLISH') AS MON_ENG
	,TO_CHAR(SYSDATE, 'DD') AS DD
	,TO_CHAR(SYSDATE, 'DY') AS DY
	,TO_CHAR(SYSDATE, 'DAY') AS DAY
FROM DUAL;

--최대 자리수(최대 자리수 넘어가면 에러.. 일부로 에러내야하는 경우 사용 TRY CATCH 처럼)
SELECT TO_NUMBER('3,300', '999,999')
FROM DUAL;


--TO DATE (입력날짜, 'RR-MM-DD')  날짜 포맷 RR YY값 비교
--RR은 정말 쓸일이 없겠네....
SELECT TO_DATE('49/12/10','YY/MM/DD')AS YY_YERR_49
		, TO_DATE('49/12/10','RR/MM/DD')AS RR_YERR_49
		, TO_DATE('50/12/10','YY/MM/DD')AS YY_YERR_50
		, TO_DATE('50/12/10','RR/MM/DD')AS RR_YERR_50
FROM DUAL;

--NVL(입력값, NULL인 대체할 값) !!! 메우 중요!!!!
SELECT EMPNO, ENAME
	,NVL(COMM,0)
	,SAL+NVL(COMM,0)
FROM EMP;

--NVL(입력값, NULL이 아닌 경우, NULL인 경우)
SELECT EMPNO,ENAME,SAL, COMM
	,NVL2(COMM,SAL*12+COMM,SAL*12)AS ANNSAL
FROM EMP;


--DECODE
SELECT EMPNO, ENAME, JOB, SAL
	,DECODE(JOB,
			'MANAGER',SAL*2,
			'SALESMAN',SAL*0.3,
			'ANALYST',SAL*0.05,
			SAL*0.1) AS BONUS 
FROM EMP;

--CASE
SELECT EMPNO, ENAME, JOB, SAL
	,CASE JOB
			WHEN 'MANAGER' THEN SAL*2
			WHEN'SALESMAN'THEN SAL*0.3
			WHEN'ANALYST'THEN SAL*0.05
			ELSE SAL*0.1
			END AS BONUS 
FROM EMP;
