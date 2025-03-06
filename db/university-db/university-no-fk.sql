-- PostgreSQL dump of university database
DROP DATABASE IF EXISTS university-no-fk;

CREATE DATABASE university-no-fk;

\connect university-no-fk

DROP SCHEMA IF EXISTS uni1;

DROP SCHEMA IF EXISTS uni2;

-- Create schemas
CREATE SCHEMA uni1;
CREATE SCHEMA uni2;

-- uni1.student table
CREATE TABLE uni1.student (
    s_id INTEGER NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (s_id)
);

-- Insert student data
INSERT INTO uni1.student (s_id, first_name, last_name) VALUES
(1, 'Mary', 'Smith'),
(2, 'John', 'Doe'),
(3, 'Franck', 'Combs'),
(4, 'Billy', 'Hinkley'),
(5, 'Alison', 'Robards');

-- uni1.academic table
CREATE TABLE uni1.academic (
    a_id INTEGER NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    position INTEGER NOT NULL,
    PRIMARY KEY (a_id)
);

-- Insert academic data
INSERT INTO uni1.academic (a_id, first_name, last_name, position) VALUES
(1, 'Anna', 'Chambers', 1),
(2, 'Edward', 'May', 9),
(3, 'Rachel', 'Ward', 8),
(4, 'Priscilla', 'Hildr', 2),
(5, 'Zlata', 'Richmal', 3),
(6, 'Nathaniel', 'Abolfazl', 4),
(7, 'Sergei', 'Elian', 5),
(8, 'Alois', 'Jayant', 6),
(9, 'Torborg', 'Chernobog', 7),
(10, 'Udi', 'Heinrike', 8),
(11, 'Alvena', 'Merry', 9),
(12, 'Kyler', 'Josephina', 1),
(13, 'Gerard', 'Cosimo', 2),
(14, 'Karine', 'Attilio', 3);

-- Create index on position
CREATE INDEX academic_position_idx ON uni1.academic(position);

-- uni1.course table
CREATE TABLE uni1.course (
    c_id INTEGER NOT NULL,
    title VARCHAR(100) NOT NULL,
    PRIMARY KEY (c_id)
);

-- Insert course data
INSERT INTO uni1.course (c_id, title) VALUES
(1234, 'Linear Algebra'),
(1235, 'Analysis'),
(1236, 'Operating Systems'),
(1500, 'Data Mining'),
(1501, 'Theory of Computing'),
(1502, 'Research Methods');

-- uni1.teaching table
CREATE TABLE uni1.teaching (
    c_id INTEGER NOT NULL,
    a_id INTEGER NOT NULL
);

-- Insert teaching data
INSERT INTO uni1.teaching (c_id, a_id) VALUES
(1234, 1),
(1234, 2),
(1235, 1),
(1235, 3),
(1236, 4),
(1236, 8),
(1236, 9),
(1500, 12),
(1500, 2),
(1501, 12),
(1501, 14),
(1501, 7),
(1502, 13);

-- Create indexes on teaching
CREATE INDEX teaching_c_id_idx ON uni1.teaching(c_id);
CREATE INDEX teaching_a_id_idx ON uni1.teaching(a_id);

-- uni1.course-registration table
-- Note: PostgreSQL doesn't like hyphens in identifiers, so using underscores
CREATE TABLE uni1.course_registration (
    c_id INTEGER NOT NULL,
    s_id INTEGER NOT NULL
);

-- Insert course registration data
INSERT INTO uni1.course_registration (c_id, s_id) VALUES
(1234, 1),
(1234, 2),
(1234, 3),
(1235, 1),
(1235, 2),
(1236, 1),
(1236, 3),
(1500, 4),
(1500, 5),
(1501, 4),
(1502, 5);

-- Create indexes on course_registration
CREATE INDEX course_reg_c_id_idx ON uni1.course_registration(c_id);
CREATE INDEX course_reg_s_id_idx ON uni1.course_registration(s_id);

-- uni2.person table
CREATE TABLE uni2.person (
    pid INTEGER NOT NULL,
    fname VARCHAR(40) NOT NULL,
    lname VARCHAR(40) NOT NULL,
    status INTEGER NOT NULL,
    PRIMARY KEY (pid)
);

-- Insert person data
INSERT INTO uni2.person (pid, fname, lname, status) VALUES
(1, 'Zak', 'Lane', 8),
(2, 'Mattie', 'Moses', 1),
(3, 'Céline', 'Mendez', 2),
(4, 'Rachel', 'Ward', 9),
(5, 'Alvena', 'Merry', 3),
(6, 'Victor', 'Scott', 7),
(7, 'Kellie', 'Griffin', 8),
(8, 'Sueann', 'Samora', 9),
(9, 'Billy', 'Hinkley', 2),
(10, 'Larry', 'Alfaro', 1),
(11, 'John', 'Sims', 4);

-- Create index on status
CREATE INDEX person_status_idx ON uni2.person(status);

-- uni2.course table
CREATE TABLE uni2.course (
    cid INTEGER NOT NULL,
    lecturer INTEGER NOT NULL,
    lab_teacher INTEGER NOT NULL,
    topic VARCHAR(100) NOT NULL,
    PRIMARY KEY (cid)
);

-- Insert course data
INSERT INTO uni2.course (cid, lecturer, lab_teacher, topic) VALUES
(1, 1, 3, 'Information security'),
(2, 8, 5, 'Software factory'),
(3, 7, 8, 'Software process management'),
(4, 7, 9, 'Introduction to programming'),
(5, 1, 8, 'Discrete mathematics and logic'),
(6, 7, 4, 'Intelligent Systems');

-- Create indexes on course
CREATE INDEX course_lecturer_idx ON uni2.course(lecturer);
CREATE INDEX course_lab_teacher_idx ON uni2.course(lab_teacher);

-- uni2.registration table
CREATE TABLE uni2.registration (
    pid INTEGER NOT NULL,
    cid INTEGER NOT NULL
);

-- Insert registration data
INSERT INTO uni2.registration (pid, cid) VALUES
(2, 1),
(10, 4),
(2, 5),
(10, 4),
(3, 2),
(3, 3),
(9, 2);

-- Create indexes on registration
CREATE INDEX registration_pid_idx ON uni2.registration(pid);
CREATE INDEX registration_cid_idx ON uni2.registration(cid);

