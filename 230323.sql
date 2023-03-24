CREATE TABLE DEPT_TCL
AS(SELECT * FROM DEPT)
;

SELECT *FROM DEPT_TCL;

INSERT INTO DEPT_TCL 
VALUES(50,'DATAVASE','SEOUL');

DELETE FROM DEPT_TCL
WHERE DNAME = 'RESEARCH'
;

ROLLBACK;


SELECT *
FROM USER_INDEXES
WHERE TABLE_NAME LIKE 'EMP'
;

CREATE INDEX IDX_EMP_JOB
	ON EMP(JOB)
;


SELECT JOB,SUM(SAL) AS SUM_OF_SAL
FROM EMP GROUP BY JOB
ORDER BY SUM_OF_SAL DESC;







