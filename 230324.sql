-- unpivot 인라인 뷰 별칭 대문자

SELECT * FROM (SELECT DEPTNO
				,MAX(DECODE(JOB,'CLECK',SAL)) AS "CLERK"
				,MAX(DECODE(JOB,'SALESMAN',SAL)) AS "SALES"
				,MAX(DECODE(JOB,'PRESIDENT',SAL)) AS "PRESI"
				,MAX(DECODE(JOB,'MANAGER',SAL)) AS "MAN"
				,MAX(DECODE(JOB,'ANALTST',SAL)) AS "ANA"
			FROM EMP
			GROUP BY DEPTNO 
			ORDER BY DEPTNO)
UNPIVOT(SAL FOR JOB IN ("CLERK","SALES","PRESI","MAN","ANA"))
ORDER BY DEPTNO, JOB
;


SELECT *
 FROM EMP E JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO 
    ;
   
 
 SELECT  ENAME,JOB,SAL,GRADE,LOSAL,HISAL
  FROM EMP E,SALGRADE S
   WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;
  
  
  
--selfjoin
  
 SELECT E1.EMPNO
 		,E1.ENAME
 		,E2.EMPNO AS MGR_EMPNO
 		,E2.ENAME AS MGR_ENAME
 FROM EMP E1, EMP E2
 WHERE E1.MGR = E2.EMPNO;
 
--------이렇게 하면 매니저가 없는 KING이 안나옴..! 이럴 땐 LEFTJOIN을 사용하면된다.


--LEFTJOIN
--오라클 버전
 SELECT E1.EMPNO
 		,E1.ENAME
 		,E2.EMPNO AS MGR_EMPNO
 		,E2.ENAME AS MGR_ENAME
 FROM EMP E1, EMP E2
 WHERE E1.MGR = E2.EMPNO(+);
 
--표준SAL 버전
 SELECT E1.EMPNO
 		,E1.ENAME
 		,E2.EMPNO AS MGR_EMPNO
 		,E2.ENAME AS MGR_ENAME
 FROM EMP E1 LEFT OUTER JOIN EMP E2
 ON (E1.MGR = E2.EMPNO)
 
 
 
SELECT E1.EMPNO
 		,E1.ENAME
 		,E2.EMPNO AS MGR_EMPNO
 		,E2.ENAME AS MGR_ENAME
FROM EMP E1 LEFT OUTER JOIN EMP E2
ON (E1.MGR = E2.EMPNO)

WHERE E2.EMPNO IS NULL;   -- 이렇게 교집합 빼면 KING만 나옴


------------------------------강사님하고 HR 스키마 공부함
/*
Rem
Rem $Header: hr_code.sql 29-aug-2002.11:44:01 hyeh Exp $
Rem
Rem hr_code.sql
Rem
Rem Copyright (c) 2001, 2015, Oracle Corporation.  All rights reserved.  
Rem 
Rem Permission is hereby granted, free of charge, to any person obtaining
Rem a copy of this software and associated documentation files (the
Rem "Software"), to deal in the Software without restriction, including
Rem without limitation the rights to use, copy, modify, merge, publish,
Rem distribute, sublicense, and/or sell copies of the Software, and to
Rem permit persons to whom the Software is furnished to do so, subject to
Rem the following conditions:
Rem 
Rem The above copyright notice and this permission notice shall be
Rem included in all copies or substantial portions of the Software.
Rem 
Rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
Rem EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
Rem MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
Rem NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
Rem LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
Rem OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
Rem WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
Rem
Rem    NAME
Rem      hr_code.sql - Create procedural objects for HR schema
Rem
Rem    DESCRIPTION
Rem      Create a statement level trigger on EMPLOYEES
Rem      to allow DML during business hours.
Rem      Create a row level trigger on the EMPLOYEES table,
Rem      after UPDATES on the department_id or job_id columns.
Rem      Create a stored procedure to insert a row into the
Rem      JOB_HISTORY table.  Have the above row level trigger
Rem      row level trigger call this stored procedure. 
Rem
Rem    NOTES
Rem
Rem    CREATED by Nancy Greenberg - 06/01/00
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    hyeh        08/29/02 - hyeh_mv_comschema_to_rdbms
Rem    ahunold     05/11/01 - disable
Rem    ahunold     03/03/01 - HR simplification, REGIONS table
Rem    ahunold     02/20/01 - Created
Rem

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF

REM **************************************************************************

REM procedure and statement trigger to allow dmls during business hours:
CREATE OR REPLACE PROCEDURE secure_dml
IS
BEGIN
  IF TO_CHAR (SYSDATE, 'HH24:MI') NOT BETWEEN '08:00' AND '18:00'
        OR TO_CHAR (SYSDATE, 'DY') IN ('SAT', 'SUN') THEN
	RAISE_APPLICATION_ERROR (-20205, 
		'You may only make changes during normal office hours');
  END IF;
END secure_dml;
/

CREATE OR REPLACE TRIGGER secure_employees
  BEFORE INSERT OR UPDATE OR DELETE ON employees
BEGIN
  secure_dml;
END secure_employees;
/

ALTER TRIGGER secure_employees DISABLE;

REM **************************************************************************
REM procedure to add a row to the JOB_HISTORY table and row trigger 
REM to call the procedure when data is updated in the job_id or 
REM department_id columns in the EMPLOYEES table:

CREATE OR REPLACE PROCEDURE add_job_history
  (  p_emp_id          job_history.employee_id%type
   , p_start_date      job_history.start_date%type
   , p_end_date        job_history.end_date%type
   , p_job_id          job_history.job_id%type
   , p_department_id   job_history.department_id%type 
   )
IS
BEGIN
  INSERT INTO job_history (employee_id, start_date, end_date, 
                           job_id, department_id)
    VALUES(p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
END add_job_history;
/

CREATE OR REPLACE TRIGGER update_job_history
  AFTER UPDATE OF job_id, department_id ON employees
  FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate, 
                  :old.job_id, :old.department_id);
END;
/

COMMIT;*/

 

