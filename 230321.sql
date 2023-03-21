--P189
SELECT *
FROM EMP, DEPT
ORDER BY EMPNO

SELECT * FROM EMP E, DEPT D
WHERE ENAME = 'MILLER' ORDER BY EMPNO

--P190 (교집합)
SELECT *
FROM EMP, DEPT 
WHERE emp.DEPTNO  = dept.DEPTNO 
ORDER BY  EMPNO 

SELECT *
FROM EMP E JOIN DEPT D 
	ON(E.DEPTNO = D.DEPTNO)
ORDER BY EMPNO;


SELECT E.EMPNO,E.ENAME,D.DEPTNO,D.DNAME,D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO 
ORDER BY D.DEPTNO, E.EMPNO ;

--P192 JOIN에 WHERE 조건식 추가
SELECT E.EMPNO,E.ENAME,SAL,D.DEPTNO,D.DNAME,D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO 
AND SAL <=2000
ORDER BY SAL DESC;


SELECT d.DNAME, e.JOB 
	,ROUND(AVG(e.sal),0) AS AVG_SAL
	,SUM(e.sal) AS SUM_SAL
	,MAX(e.sal) AS MAX_SAL
	,MIN(e.sal) AS MIN_SAL
	,COUNT(e.sal) AS CNT_SAL	
FROM emp e
	,dept d
WHERE e.DEPTNO  = d.DEPTNO AND e.sal <2000
GROUP BY D.DNAME, e.JOB 
;


SELECT ENAME,JOB,SAL,GRADE,LOSAL,HISAL
FROM EMP e , SALGRADE s 
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL ;
-- ORDER BY를 적용하지 않았지만 SAL 이 정렬된 이유는???


--P193 자체조인(Self-join)

SELECT E1.EMPNO
		,E1.ENAME 
		,E1.MGR
		,E2.EMPNO AS MGR_EMPNO
		,E2.ENAME AS MGR_ENAME
FROM EMP E1, EMP E2
WHERE E1.MGR = E2.EMPNO;


--LEFT JOIN(상사이름 가져오기)
SELECT d.DEPTNO 
	 , d.DNAME 
	 , e1.EMPNO
	 , e1.ENAME
	 , e1.MGR
 	 , e1.SAL
 	 , e1.DEPTNO 
 	 ,s.LOSAL
 	 ,s.HISAL
 	 ,s.GRADE
 	 ,e2.EMPNO AS MGR_EMPNO
 	 ,e2.ENAME AS MGR_ENAME
FROM EMP e1
	,DEPT d 
	,SALGRADE s 
	,EMP e2
WHERE E1.DEPTNO(+) = D.DEPTNO 
	AND e1.sal BETWEEN s.LOSAL AND s.HISAL 
	AND e1.MGR =e2.EMPNO (+)
ORDER BY D.DEPTNO ,E1.EMPNO ;


SELECT d.DEPTNO 
	 , d.DNAME 
	 , e1.EMPNO
	 , e1.ENAME
	 , e1.MGR
 	 , e1.SAL
 	 , e1.DEPTNO 
 	 ,s.LOSAL
 	 ,s.HISAL
 	 ,s.GRADE
 	 ,e2.EMPNO AS MGR_EMPNO
 	 ,e2.ENAME AS MGR_ENAME
FROM EMP e1 RIGHT JOIN DEPT d 
		ON E1.DEPTNO = D.DEPTNO 
	LEFT OUTER JOIN SALGRADE s 
		ON (E1.SAL>=S.LOSAL AND E1.SAL <=S.HISAL)
	LEFT OUTER JOIN EMP E2
		ON(E1.MGR = E2.EMPNO)
ORDER BY D.DEPTNO ,E1.EMPNO 
;




--단일행 서브 쿼리 - 쿼리 안에 쿼리 문장을 사용
--SMITH 보다 돈 많이 받는 사람~~

SELECT  ENAME, SAL
FROM EMP
WHERE SAL >(SELECT SAL FROM EMP WHERE ENAME = 'SMITH')
;

SELECT ENAME, SAL
FROM EMP e, DEPT d
WHERE e.DEPTNO = d.DEPTNO
		AND e.DEPTNO =20
		AND e.SAL >(SELECT avg(SAL) FROM EMP)
;


--다중행 서브 쿼리
--부서별 최고 급여에 해당하는 직원을 조회하여 출력
SELECT DEPTNO ,ENAME, SAL
FROM EMP
WHERE SAL IN (SELECT MAX(SAL)
				FROM EMP
				GROUP BY DEPTNO);

			
SELECT a.empno
	  ,a.sal
      ,b.DNAME 
      ,b.LOC 
FROM (SELECT *FROM EMP WHERE DEPTNO=30) A
	,(SELECT *FROM DEPT) B
WHERE A.deptno = B.deptno



CREATE TABLE DEPT_TEMP 
	AS SELECT * FROM DEPT;


	