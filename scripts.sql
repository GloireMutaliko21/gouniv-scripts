BEGIN TRANSACTION;

DROP DATABASE gouniv;

CREATE DATABASE gouniv;

CREATE USER admin;

CREATE USER doyen;

CREATE USER assistant;

ALTER DATABASE gouniv OWNER  TO admin;
REVOKE ALL PRIVILEGES ON DATABASE gouniv FROM PUBLIC;

GRANT ALL PRIVILEGES ON TABLE Student, Course TO doyen;
GRANT SELECT ON TABLE Staff TO doyen;

GRANT SELECT ON TABLE Student, Course TO assistant;

GRANT CONNECT ON DATABASE gouniv TO doyen, assistant;

DROP TABLE staff;
CREATE TABLE IF NOT EXISTS staff(
    StaffNo serial PRIMARY KEY,
    Nom VARCHAR(50) UNIQUE NOT NULL,
    Region VARCHAR(50),
    validity BOOLEAN DEFAULT 'false'
);

DROP TABLE student;
CREATE TABLE IF NOT EXISTS student(
    StudentID serial PRIMARY KEY,
    Nom VARCHAR(50) UNIQUE NOT NULL,
    Region VARCHAR(50),
    StaffNo INT,
    validity BOOLEAN DEFAULT 'true',
    FOREIGN KEY (StaffNo) REFERENCES staff(StaffNo)
);

DROP TABLE course;
CREATE TABLE IF NOT EXISTS course(
    CourseCode serial PRIMARY KEY,
    Title VARCHAR(50) UNIQUE NOT NULL,
    Credit INT NOT NULL,
    Quota INT NOT NULL,
    StaffNo INT,
    validity BOOLEAN DEFAULT 'true',
    FOREIGN KEY (StaffNo) REFERENCES staff(StaffNo)
);

DROP TABLE enrollment;
CREATE TABLE IF NOT EXISTS enrollment(
    StudentID INT NOT NULL,
    CourseCode INT NOT NULL,
    DateEnrolled DATE NOT NULL DEFAULT CURRENT_DATE,
    FinalGrade INT,
    PRIMARY KEY(StudentID, CourseCode),
    FOREIGN KEY (StudentID) REFERENCES student(StudentID),
    FOREIGN KEY (CourseCode) REFERENCES course(CourseCode)
);

DROP TABLE assignment;
CREATE TABLE IF NOT EXISTS assignment(
    StudentID INT NOT NULL,
    CourseCode INT NOT NULL,
    Assignment SERIAL,
    Grade INT,
    validity BOOLEAN DEFAULT 'true',
    PRIMARY KEY(StudentID, CourseCode, Assignment),
    FOREIGN KEY (StudentID) REFERENCES student(StudentID),
    FOREIGN KEY (CourseCode) REFERENCES course(CourseCode)
);




INSERT INTO Staff(Nom, Region) VALUES ('Gloire', 'Sud-Kivu');
INSERT INTO student(Nom, Region, StaffNo) VALUES ('Mutaliko','Montreal',1);
INSERT INTO course(Title, Credit, Quota, StaffNo) VALUES ('Genie Logiciel',8,2,6);
INSERT INTO enrollment(StudentID, CourseCode, FinalGrade) VALUES (4,8,2);
INSERT INTO assignment(StudentID, CourseCode, Grade) VALUES (3,2,5);

COMMIT;