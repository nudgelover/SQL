/* Q2-1
(1) 테이블
(2) 외래키(FK)
(3) NULL
 Q2-2
(1) 문자셋(CharacterSet)
(2) 문자셋(CharSet)
 Q2-3
(1) VARCHAR2
(2) CHAR
 Q2-4
(1) 제약조건
(2) 기본키(PRIMARY KEY)
(3) 외래키(FOREIGN KEY)
  Q2-5
(1) 무결성(INTEGRITY)
(2) 무결성
(3) 무결성
  Q2-6
(1) UNIQUE
(2) NOT NULL
(3) INDEX*/

--1. EMP 테이블에서 부서번호, 평균 급여, 최고급여, 최저급여, 사원수를 출력
--	단, 평균급여 출력 시 소수점을 제외하고 각 부서번호별로 출력(그룹화)
SELECT DEPTNO AS 부서번호
		,TRUNC(AVG(SAL),0) AS 평균급여
		,MAX(SAL) AS 최고급여
		,MIN(SAL) AS 최저급여
		,COUNT(*) AS 사원수
FROM EMP  
GROUP BY DEPTNO ;
	
--2. 같은 직책에 있는 사원이 사원이 3명 이상인 경우 직책과 인원수를 출력 (JOB으로 그룹화)
SELECT JOB
		,COUNT(*)
FROM EMP  
GROUP BY JOB
HAVING COUNT(*) >=3;

--3. 사원들의 입사년도를 기준으로 부서별로 몇 명이 입사했는지 출력
SELECT EXTRACT(YEAR FROM HIREDATE) AS HIRE_YEAR
	,DEPTNO
	,COUNT(*) AS CNT
FROM EMP
GROUP BY DEPTNO, EXTRACT(YEAR FROM HIREDATE);

		
--4. 추가 수당을 받는 사원수와 받지 안흔 사원수를 출력

SELECT NVL2(COMM,'Y','N') AS EXIST_COMM
	,COUNT(*) AS CNT
FROM EMP
GROUP BY NVL2(COMM,'Y','N');


--5. 각 부서의 입사 연도별 사원수, 최고급여, 급여합, 평균 급여를 출력하고 각 부서별 소계와 총계를 함께 출력
SELECT DEPTNO
	,EXTRACT(YEAR FROM HIREDATE) AS HIRE_YEAR
	,MAX(SAL)
	,SUM(SAL)
	,AVG(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO, EXTRACT(YEAR FROM HIREDATE));


--1. INNER JOIN  방식으로 급여가 2000초과인 사원들의 부서 정보, 사원정보를 출력
--(1)오라클
SELECT D.DEPTNO
	, D.DNAME
	, E.EMPNO
	, E.ENAME
	, E.SAL
FROM EMP E,DEPT D
WHERE E.DEPTNO = D.DEPTNO 
		AND E.SAL > 2000
ORDER BY D.DEPTNO;
--
--(2) 표준
SELECT D.DEPTNO
	, D.DNAME
	, E.EMPNO
	, E.ENAME
	, E.SAL
FROM EMP E JOIN DEPT D 
		ON(E.DEPTNO = D.DEPTNO)
WHERE E.SAL > 2000
ORDER BY D.DEPTNO;


--2. NATURAL-JOIN  각 부서별 평균급여, 최대급여, 최소급여, 사원수를 출력
SELECT DEPTNO
	,DNAME
	,TRUNC(AVG(SAL),0) AS AVG_SAL
	,MAX(SAL) AS MAX_SAL
	,MIN(SAL) AS MIN_SAL
	,COUNT(*) AS CNT
FROM EMP NATURAL JOIN DEPT 
GROUP BY DEPTNO, DNAME;



--3. 모든 부서 정보와 사원 정보를 부서정보 기분으로 조인(RIGHT JOIN)

SELECT D.DEPTNO
	, D.DNAME
	, E.EMPNO
	, E.ENAME
	, E.JOB
	, E.SAL
FROM EMP E RIGHT OUTER JOIN DEPT D 
ON E.DEPTNO = D.DEPTNO
;

--4.부서정보, 사원정보, 급여 등급 정보를 JOIN하여 각 사원의 직속 상관의 정보를 부서정보, 사원번호 순으로 정렬하여 출력(RIGHT-JOIN)
SELECT D.DEPTNO 
	, D.DNAME
	, E.EMPNO
	, E.ENAME
	, E.MGR
	, E.SAL
	, S.LOSAL
	, S.HISAL
	, S.GRADE
	, M.EMPNO AS MGR_EMPNO 
	, M.ENAME AS MGR_ENAME 
FROM EMP E, DEPT D, SALGRADE S, EMP M
WHERE E.DEPTNO(+) = D.DEPTNO
	AND E.SAL BETWEEN S.LOSAL(+) AND S.HISAL(+) 
	AND E.MGR = M.EMPNO(+)
ORDER BY D.DEPTNO, D.DNAME, E.ENAME , E.MGR
;

--1. 'ALLEN'과 같은 직책(JOB)인 직원들의 사원명, 사원정보, 부서정보를 출력
SELECT E.JOB
	, E.EMPNO
	, E.ENAME
	, E.SAL
	, D.DEPTNO
	, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
		AND JOB = (SELECT JOB
				FROM EMP
				WHERE ENAME = 'ALLEN')
;

--2. 전체 사원의 평균 급여보다 높은 급여를 받는 사원정보, 부서정보, 급여 출력
SELECT E.EMPNO
	, E.ENAME
	, D.DNAME
	, E.HIREDATE
	, D.LOC
	, E.SAL
	, S.GRADE
FROM EMP E, DEPT D, SALGRADE S
WHERE E.DEPTNO = D.DEPTNO
	AND E.SAL BETWEEN S.LOSAL AND S.HISAL
	AND SAL > (SELECT AVG(SAL)
FROM EMP)
ORDER BY E.SAL DESC, E.EMPNO
;

--3. 부서코드 10인 부서에 근무하는 사원 중 부서코드 30번 부서에 존재하지 않는 직책을 가진 사원드의 정보를 출력
SELECT E.EMPNO
	, E.ENAME
	, E.JOB
	, D.DEPTNO
	, D.DNAME
	, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
	AND E.DEPTNO = 10
	AND JOB NOT IN (SELECT DISTINCT JOB
					FROM EMP
					WHERE DEPTNO =30)
;

--4. 직책이 SALESMAN인 사람드의 최고 급여보다 높은 급여를 받는 사원드의 정보를 출력. 다중행 함수를 사용한 경우 MAX()이용
SELECT E.EMPNO
	, E.ENAME
	, E.SAL
	, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
	AND SAL > ALL(SELECT MAX(SAL)
				FROM EMP
				WHERE JOB = 'SALESMAN')
ORDER BY EMPNO
;
--5. 위의 4번을 다중행 함수를 사용하지 않고 ALL 키워드를 사용하여 결과를 출력

SELECT E.EMPNO
	, E.ENAME
	, E.SAL
	, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
	AND SAL > ALL(SELECT SAL
				FROM EMP
				WHERE JOB = 'SALESMAN')
ORDER BY EMPNO
;
