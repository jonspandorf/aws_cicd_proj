CREATE TABLE IF NOT EXISTS As_company (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS As_account  (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
    Company_id INT,
    FOREIGN KEY (Company_id) REFERENCES As_company(Id)
);

CREATE TABLE IF NOT EXISTS As_project (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Account_id INT,
    Status INT NOT NULL, 
    FOREIGN KEY (Account_id) REFERENCES As_account(Id)
);

INSERT INTO As_company (Id, Name) VALUES (123, 'Panaya');
INSERT INTO As_account (Id, Name, Company_id) 
VALUES 
 (111, "Production system", 123),
 (222, "Dev system", 123);
INSERT INTO As_project (Id, Name, Account_id, Status)
VALUES 
 (1111,"Upgrade",111,1),
 (2222,"Testing",111,0),
 (3333,"Cleansing",111,2),
 (4444,"Restore",222,1);


