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



