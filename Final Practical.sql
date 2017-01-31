 -- --------------------------------------------------------------------------------
-- Name: Bryan Caldwell
-- Class: IT-111-001 Tues Thurs 9:00 - 11:50
-- Abstract: Final Practical
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL1		-- Get out of the master database
SET NOCOUNT ON	-- Report only errors
GO
-- --------------------------------------------------------------------------------
-- Step #1: Drop Tables
-- --------------------------------------------------------------------------------
DROP TABLE TEmployeeDepartments
DROP TABLE TDepartments
DROP TABLE TEmployeeGenders
DROP TABLE TGenders
DROP TABLE TEmployeeMaritalStatuses
DROP TABLE TMaritalStatuses
DROP TABLE TEmployeePhones
DROP TABLE TEmployees

IF OBJECT_ID( 'uspCaldwellDisplay2Records' )	IS NOT NULL DROP PROCEDURE uspCaldwellDisplay2Records
GO
-- --------------------------------------------------------------------------------
-- Step #2: Create Tables
-- --------------------------------------------------------------------------------
CREATE TABLE TEmployees
(
	 intEmployeeID				INTEGER				NOT NULL
	,intOrganizationLevel		INTEGER				NOT NULL
	,strJobTitle				VARCHAR(50)			NOT NULL
	,strBirthDate				VARCHAR(50)			NOT NULL
	,strHireDate				VARCHAR(50)			NOT NULL
	,strStartDate				VARCHAR(50)			NOT NULL
	,CONSTRAINT TEmployees_PK PRIMARY KEY (intEmployeeID)
)
CREATE TABLE TEmployeePhones
(
	 intEmployeeID				INTEGER				NOT NULL
	,intPhoneIndex				INTEGER				NOT NULL
	,strPhone					VARCHAR(50)			NOT NULL
	,CONSTRAINT TEmployeePhones_PK PRIMARY KEY (intEmployeeID, intPhoneIndex)
)
CREATE TABLE TMaritalStatuses
(
	 intMaritalStatusID			INTEGER				NOT NULL
	,strMaritalStatus			VARCHAR(50)			NOT NULL
	,CONSTRAINT TMaritalStatuses_PK PRIMARY KEY (intMaritalStatusID)
)
CREATE TABLE TEmployeeMaritalStatuses
(
	 intEmployeeID				INTEGER				NOT NULL
	,intMaritalStatusID			INTEGER				NOT NULL
	,CONSTRAINT TEmployeeMaritalStatuses_PK PRIMARY KEY (intEmployeeID, intMaritalStatusID)
)
CREATE TABLE TGenders
(
	 intGenderID				INTEGER				NOT NULL
	,strGender					VARCHAR(50)			NOT NULL
	,CONSTRAINT TGenders_PK PRIMARY KEY (intGenderID)
)
CREATE TABLE TEmployeeGenders
(
	 intEmployeeID				INTEGER				NOT NULL
	,intGenderID				INTEGER				NOT NULL
	,CONSTRAINT TEmployeeGenders_PK PRIMARY KEY (intEmployeeID, intGenderID)
)
CREATE TABLE TDepartments
(
	 intDepartmentID			INTEGER				NOT NULL
	,strDepartmentName			VARCHAR(50)			NOT NULL
	,strDepartmentCode			VARCHAR(50)			NOT NULL
	,CONSTRAINT TDepartments_PK PRIMARY KEY (intDepartmentID)
)
CREATE TABLE TEmployeeDepartments
(
	 intEmployeeID				INTEGER				NOT NULL
	,intDepartmentID			INTEGER				NOT NULL
	,CONSTRAINT TEmployeeDepartments_PK PRIMARY KEY (intEmployeeID, intDepartmentID)
)
-- --------------------------------------------------------------------------------
-- Step #3: Insert Statements
-- --------------------------------------------------------------------------------

INSERT INTO TEmployees
(
	 intEmployeeID			
	,intOrganizationLevel	
	,strJobTitle			
	,strBirthDate			
	,strHireDate
	,strStartDate			
)
VALUES
	 (1, 0, 'Chief Executive Officer', '3/2/1963', '2/15/2003', '2/15/2003')
	,(2, 1, 'Vice President of Engineering', '9/1/1965', '3/3/2002', '3/3/2002')

INSERT INTO TEmployeePhones
(
	  intEmployeeID	
	 ,intPhoneIndex	
	 ,strPhone		
)
VALUES
	 (1, 1, '697-555-0142')
	,(1, 2, '697-555-0143')
	,(2, 1, '819-555-0175')
	,(2, 2, '819-555-0176')

INSERT INTO TMaritalStatuses
(
	 intMaritalStatusID		
	,strMaritalStatus		
)
VALUES
	 (1, 'M')
	,(2, 'S')

INSERT INTO TEmployeeMaritalStatuses
(
	 intEmployeeID		
	,intMaritalStatusID	
)
VALUES
	  (1, 2)
	 ,(2, 2)

INSERT INTO TGenders
(
	 intGenderID
	,strGender	
)
VALUES
	 (1, 'M')
	,(2, 'F')

INSERT INTO TEmployeeGenders
(
	  intEmployeeID	
	 ,intGenderID
)
VALUES
	 (1, 1)
	,(2, 2)
INSERT INTO TDepartments
(
	 intDepartmentID	
	,strDepartmentName	
	,strDepartmentCode	
)
VALUES
	 (1, 'Executive', 'E')
	,(2, 'Engineering', 'ENG')

INSERT INTO TEmployeeDepartments
(
	  intEmployeeID		
	 ,intDepartmentID	
)
VALUES
	 (1, 1)
	,(2, 2)

-- --------------------------------------------------------------------------------
-- Step #4: Identify and create foreign keys.
-- --------------------------------------------------------------------------------

--	#		Child										Parent								Column(s)
--	-		-----										------								---------
--	1		TEmployeePhones								TEmployees							intEmployeeID
--	2		TEmployeeMaritalStatuses					TMaritalStatuses					intMaritalStatusID
--	3		TEmployeeGenders							TGenders							intGenderID
--	4		TEmployeeDepartments						TDepartments						intDepartmentID
--	5		TEmployeeMaritalStatuses					TEmployees							intEmployeeID
--	6		TEmployeeGenders							TEmployees							intEmployeeID
--	7		TEmployeeDepartments						TEmployees							intEmployeeID

ALTER TABLE TEmployeePhones ADD CONSTRAINT TEmployeePhones_TEmployees_FK
FOREIGN KEY ( intEmployeeID ) REFERENCES TEmployees ( intEmployeeID )

ALTER TABLE TEmployeeMaritalStatuses ADD CONSTRAINT TEmployeeMaritalStatuses_TMaritalStatuses_FK
FOREIGN KEY ( intMaritalStatusID ) REFERENCES TMaritalStatuses ( intMaritalStatusID )

ALTER TABLE TEmployeeGenders ADD CONSTRAINT TEmployeeGenders_TGenders_FK
FOREIGN KEY ( intGenderID ) REFERENCES TGenders ( intGenderID )

ALTER TABLE TEmployeeDepartments ADD CONSTRAINT TEmployeeDepartments_TDepartments_FK
FOREIGN KEY ( intDepartmentID ) REFERENCES TDepartments ( intDepartmentID )

ALTER TABLE TEmployeeMaritalStatuses ADD CONSTRAINT TEmployeeMaritalStatuses_TEmployees_FK
FOREIGN KEY ( intEmployeeID ) REFERENCES TEmployees ( intEmployeeID )

ALTER TABLE TEmployeeGenders ADD CONSTRAINT TEmployeeGenders_TEmployees_FK
FOREIGN KEY ( intEmployeeID ) REFERENCES TEmployees ( intEmployeeID )

ALTER TABLE TEmployeeDepartments ADD CONSTRAINT TEmployeeDepartments_TEmployees_FK
FOREIGN KEY ( intEmployeeID ) REFERENCES TEmployees ( intEmployeeID )

-- --------------------------------------------------------------------------------
-- Step #5: Join the tables to produce a row that has the same columns as the original EMPLOYEES table, and display only 1 record.
-- --------------------------------------------------------------------------------

SELECT		 TE.intEmployeeID
			,TE.intOrganizationLevel
			,TE.strJobTitle
			,TE.strBirthDate
			,TMS.strMaritalStatus
			,TG.strGender
			,TE.strHireDate
			,TD.strDepartmentName
			,TD.strDepartmentCode
			,TE.strStartDate
			,TEP.strPhone

FROM TEmployees						as TE
		JOIN TEmployeeMaritalStatuses as TEMS
			ON TEMS.intEmployeeID = TE.intEmployeeID
		JOIN TMaritalStatuses as TMS
			ON TMS.intMaritalStatusID = TEMS.intMaritalStatusID
		JOIN TEmployeeGenders as TEG
			ON TEG.intEmployeeID = TE.intEmployeeID
		JOIN TGenders as TG
			ON TG.intGenderID = TEG.intGenderID
		JOIN TEmployeeDepartments as TED
			ON TED.intEmployeeID = TE.intEmployeeID
		JOIN TDepartments as TD
			ON TD.intDepartmentID = TED.intDepartmentID
		JOIN TEmployeePhones as TEP
			ON TEP.intEmployeeID = TE.intEmployeeID

WHERE TE.intEmployeeID = 1 
--and TEP.strPhone IN
--		(
--		SELECT strPhone
--		FROM TEmployeePhones
--		WHERE TEP.intPhoneIndex = 1
--		)

-- --------------------------------------------------------------------------------
-- Step #6: Write a query to display the original record and the added record. 
-- Step #7:	Put the query in a stored procedure.  Include your name in the procedure, like uspCoilDisplay2Records
-- --------------------------------------------------------------------------------

GO
CREATE PROCEDURE uspCaldwellDisplay2Records
AS

SELECT		 TE.intEmployeeID
			,TE.intOrganizationLevel
			,TE.strJobTitle
			,TE.strBirthDate
			,TMS.strMaritalStatus
			,TG.strGender
			,TE.strHireDate
			,TD.strDepartmentName
			,TD.strDepartmentCode
			,TE.strStartDate
			,TEP.strPhone

FROM TEmployees						as TE
		JOIN TEmployeeMaritalStatuses as TEMS
			ON TEMS.intEmployeeID = TE.intEmployeeID
		JOIN TMaritalStatuses as TMS
			ON TMS.intMaritalStatusID = TEMS.intMaritalStatusID
		JOIN TEmployeeGenders as TEG
			ON TEG.intEmployeeID = TE.intEmployeeID
		JOIN TGenders as TG
			ON TG.intGenderID = TEG.intGenderID
		JOIN TEmployeeDepartments as TED
			ON TED.intEmployeeID = TE.intEmployeeID
		JOIN TDepartments as TD
			ON TD.intDepartmentID = TED.intDepartmentID
		JOIN TEmployeePhones as TEP
			ON TEP.intEmployeeID = TE.intEmployeeID

WHERE (TE.intEmployeeID = 1 or TE.intEmployeeID = 2)
--and TEP.strPhone IN
--		(
--		SELECT strPhone
--		FROM TEmployeePhones
--		WHERE TEP.intPhoneIndex = 1
--		)

GO

uspCaldwellDisplay2Records