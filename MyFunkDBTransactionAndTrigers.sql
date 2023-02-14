CREATE DATABASE MyFunkDBT;

USE MyFunkDBT;

CREATE TABLE employee(
idTest INT AUTO_INCREMENT NOT NULL,
name VARCHAR(20) NOT NULL,
phone VARCHAR(15) NOT NULL,
PRIMARY KEY(idTest)
);

CREATE TABLE employee_position(
employee_id INT AUTO_INCREMENT NOT NULL,
employee_post VARCHAR(30) NOT NULL,
salary DOUBLE NOT NULL,
PRIMARY KEY(employee_id),
FOREIGN KEY (employee_id) REFERENCES employee(idTest) 
);

CREATE TABLE personal_data(
employee_id INT AUTO_INCREMENT NOT NULL,
marital_status VARCHAR(20) NOT NULL,
birthday DATE NOT NULL,
address VARCHAR(30) NOT NULL,
PRIMARY KEY(employee_id),
FOREIGN KEY (employee_id) REFERENCES employee(idTest) 
);

DELIMITER |

CREATE PROCEDURE addPerson(IN n VARCHAR(20), 
							IN ph VARCHAR(15), 
							IN post VARCHAR(30), 
                            IN sal DOUBLE, 
							IN marit VARCHAR(20), 
                            IN bd DATE, 
                            IN addr VARCHAR(30))
BEGIN
DECLARE Id int;
START TRANSACTION;
			
		INSERT employee(name, phone)
		VALUES (n, ph);
		SET Id = @@IDENTITY;
		
		INSERT employee_position(employee_id, employee_post, salary)
		VALUES (Id, post, sal);
		
		INSERT personal_data(employee_id, marital_status, birthday, address)
		VALUES (Id, marit, bd, addr);
		
IF EXISTS (SELECT * FROM employee WHERE name = n AND phone = ph AND idTest != Id)
			THEN
				ROLLBACK; 
				
			END IF;	
			
		COMMIT; 
END; |


|
CALL addPerson('Bob','+380985456325', 'Director', 100000, 'married', '1993-10-08','Kyiv, Sacsaganskogo 9');
|
CALL addPerson('Alan','+380965789652', 'Manager', 50000, 'not married', '1992-09-09','Kyiv, Korolova 20');
|
CALL addPerson('Mary','+380991111111', 'Worker', 25000, 'married', '1991-12-10','Kyiv, Korolova 25');
|


|
CALL addPerson('Bob','+380985456325', 'Director', 100000, 'married', '1993-10-08','Kyiv, Sacsaganskogo 9');
|

SELECT * FROM employee;

|
CREATE TRIGGER delete_from_position_and_personal
BEFORE DELETE ON employee
FOR EACH ROW
BEGIN
	DELETE FROM employee_position WHERE employee_id = OLD.idTest;
	DELETE FROM personal_data WHERE employee_id = OLD.idTest;
END;
|

SELECT * FROM employee;

|
DELETE FROM employee WHERE idTest = 2; 
|
SELECT * FROM employee;