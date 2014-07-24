

--=======================================================================================================================--

                                  --Tables, Sequences, Incrementing Triggers, AND Constraints

--=======================================================================================================================--


--************************************************************
--Create Meet Table w/ Sequences AND Triggers
--************************************************************

--Meet Table
CREATE TABLE proj_meet (
meet_id NUMBER(10) NOT NULL,
meet_name NVARCHAR2(50) NOT NULL,
meet_date DATE NOT NULL,
number_of_races NUMBER(10) NOT NULL,
entry_price NUMBER(10) NOT NULL,
PRIMARY KEY(meet_id)
);

--Meet Sequence
CREATE SEQUENCE proj_meet_seq
START WITH 1
INCREMENT BY 1;

--Meet Trigger
CREATE OR REPLACE TRIGGER proj_meet_seq_trigger
BEFORE INSERT ON proj_meet
FOR EACH ROW
BEGIN
SELECT proj_meet_seq.NEXTVAL
INTO :NEW.meet_id
FROM DUAL;
END;
/

COMMIT;
DESCRIBE proj_meet;

--***********************************************************
--Create race details Table w/ Sequences AND Triggers
--***********************************************************

--Race Details Table
CREATE TABLE proj_race_details (
race_id NUMBER(10) NOT NULL,
meet_id NUMBER(10) NOT NULL,
race_time DATE NOT NULL,
race_type NVARCHAR2(50) NOT NULL,
distance NUMBER(5) NOT NULL,
prize_money NUMBER(10) NOT NULL,
ground NVARCHAR2(50) NULL,
PRIMARY KEY(race_id),
FOREIGN KEY(meet_id) REFERENCES proj_meet(meet_id)
);

--Race Deatils Sequence
CREATE SEQUENCE proj_race_details_seq
START WITH 1
INCREMENT BY 1;

--Race Details Trigger
CREATE OR REPLACE TRIGGER proj_race_details_seq_trigger
BEFORE INSERT ON proj_race_details
FOR EACH ROW
BEGIN
SELECT proj_race_details_seq.NEXTVAL
INTO :NEW.race_id
FROM DUAL;
END;
/

COMMIT;
DESCRIBE proj_race_details;

--***********************************************************
--Create Jockey Table w/ Sequences AND Triggers
--***********************************************************

--Jockey Table
CREATE TABLE proj_jockey(
jockey_id NUMBER(10) NOT NULL,
jf_name NVARCHAR2(50) NOT NULL,
jl_name NVARCHAR2(50) NOT NULL,
jockey_dob DATE NOT NULL,
PRIMARY KEY(jockey_id)
);

--Jockey Sequence
CREATE SEQUENCE proj_jockey_seq
START WITH 1
INCREMENT BY 1;

--Jockey Trigger
CREATE OR REPLACE TRIGGER proj_jockey_seq_trigger
BEFORE INSERT ON proj_jockey
FOR EACH ROW
BEGIN
SELECT proj_jockey_seq.NEXTVAL
INTO :NEW.jockey_id
FROM DUAL;
END;
/

COMMIT;
DESCRIBE proj_jockey;

--***********************************************************
--Create Breeder Table w/ Sequences AND Triggers
--***********************************************************

--Breeder Table
CREATE TABLE proj_breeder(
breeder_id NUMBER(10) NOT NULL,
bf_name NVARCHAR2(50) NOT NULL,
bl_name NVARCHAR2(50) NOT NULL,
breeder_phone NUMBER(20) NOT NULL,
breeder_address NVARCHAR2(100) NOT NULL,
PRIMARY KEY(breeder_id)
);

--Breeder Sequence
CREATE SEQUENCE proj_breeder_seq
START WITH 1
INCREMENT BY 1;

--Breeder Trigger
CREATE OR REPLACE TRIGGER proj_breeder_seq_trigger
BEFORE INSERT ON proj_breeder
FOR EACH ROW
BEGIN
SELECT proj_breeder_seq.NEXTVAL
INTO :NEW.breeder_id
FROM DUAL;
END;
/

COMMIT;
DESCRIBE proj_breeder;

--***********************************************************
--Create Trainer Table w/ Sequences AND Triggers
--***********************************************************

--Trainer Table
CREATE TABLE proj_trainer(
trainer_id NUMBER(10) NOT NULL,
tf_name NVARCHAR2(50) NOT NULL,
tl_name NVARCHAR2(50) NOT NULL,
trainer_phone NUMBER(20) NOT NULL,
trainer_address NVARCHAR2(100) NOT NULL,
PRIMARY KEY(trainer_id)
);

--Trainer Sequence
CREATE SEQUENCE proj_trainer_seq
START WITH 1
INCREMENT BY 1;


--Trainer Trigger
CREATE OR REPLACE TRIGGER proj_trainer_seq_trigger
BEFORE INSERT ON proj_trainer
FOR EACH ROW
BEGIN
SELECT proj_trainer_seq.NEXTVAL
INTO :NEW.trainer_id
FROM DUAL;
END;
/

COMMIT;
DESCRIBE proj_trainer;

--***********************************************************
--Create Owner Table w/ Sequences AND Triggers
--***********************************************************


--Owner Table
CREATE TABLE proj_owner(
owner_id NUMBER(10) NOT NULL,
of_name NVARCHAR2(50) NOT NULL,
ol_name NVARCHAR2(50) NOT NULL,
owner_phone NUMBER(20) NOT NULL,
owner_address NVARCHAR2(100) NOT NULL,
PRIMARY KEY(owner_id)
);

--Owner Sequence
CREATE SEQUENCE proj_owner_seq
START WITH 1
INCREMENT BY 1;


--Owner Trigger
CREATE OR REPLACE TRIGGER proj_owner_seq_trigger
BEFORE INSERT ON proj_owner
FOR EACH ROW
BEGIN
SELECT proj_owner_seq.NEXTVAL
INTO :NEW.owner_id
FROM DUAL;
END;
/

COMMIT;
DESCRIBE proj_owner;

--***********************************************************
--Create Horse Table w/ Sequences AND Triggers
--***********************************************************

--Horse Table
CREATE TABLE proj_horses(
horse_id NUMBER(10) NOT NULL,
horse_name NVARCHAR2(50) NOT NULL,
horse_dob DATE NOT NULL,
weight NUMBER(10) NOT NULL,
trainer_id NUMBER(10) NOT NULL,
breeder_id NUMBER(10) NULL,
PRIMARY KEY(horse_id),
FOREIGN KEY(breeder_id) REFERENCES proj_breeder(breeder_id),
FOREIGN KEY(trainer_id) REFERENCES proj_trainer(trainer_id)
);

--Horse Sequence
CREATE SEQUENCE proj_horses_seq
START WITH 1
INCREMENT BY 1;

--Horse Trigger
CREATE OR REPLACE TRIGGER proj_horses_seq_trigger
BEFORE INSERT ON proj_horses
FOR EACH ROW
BEGIN
SELECT proj_horses_seq.NEXTVAL
INTO :NEW.horse_id
FROM DUAL;
END;
/

COMMIT;
DESCRIBE proj_horses;

--***********************************************************
--Create Entry Table w/ additional Constaints
--***********************************************************

--Entry Table
CREATE TABLE proj_entry(
race_id NUMBER(10) NOT NULL,
horse_id NUMBER(10) NOT NULL,
jockey_id NUMBER(10) NOT NULL,
odds FLOAT(5) NULL,
stall NUMBER(10) NOT NULL,
place NUMBER(10) NULL,
note NVARCHAR2(100) NULL,
PRIMARY KEY(race_id, horse_id),
FOREIGN KEY (race_id) REFERENCES proj_race_details(race_id),
FOREIGN KEY (horse_id) REFERENCES proj_horses(horse_id),
FOREIGN KEY (jockey_id) REFERENCES proj_jockey(jockey_id)
);

--This table needs additional constraints,to prevent double bookings.
ALTER Table proj_entry ADD CONSTRAINT one_jockey UNIQUE(race_id, jockey_id);
ALTER Table proj_entry ADD CONSTRAINT one_stall UNIQUE(race_id, stall);

--No Sequnce is required for this table: It must be done manually.

COMMIT;
DESCRIBE proj_entry;

--***********************************************************
--Create Certification Table
--***********************************************************

--Horse Cert Table
CREATE TABLE proj_horse_cert(
passport_id NUMBER(10) NOT NULL,
Reg_date DATE NOT NULL,
expiry_Date DATE NOT NULL,
country_residence NVARCHAR2(50) NOT NULL,
horse_id NUMBER(10) NOT NULL,
PRIMARY KEY(passport_id),
FOREIGN KEY(horse_id) REFERENCES proj_horses(horse_id)
);

COMMIT; 
DESCRIBE proj_horse_cert;

--***********************************************************
--Create Owner-Horse Junction Table (Doesn't Break Down!)
--***********************************************************


--This is the junction table between owner and horse
--All 60 horses are shared by some 10 owners
CREATE TABLE proj_owner_horse(
horse_id NUMBER(10) NOT NULL,
owner_id NUMBER(10) NOT NULL,
PRIMARY KEY (horse_id, owner_id),
FOREIGN KEY (horse_id) REFERENCES proj_horses(horse_id),
FOREIGN KEY (owner_id) REFERENCES proj_owner(owner_id)
);

COMMIT;
DESCRIBE proj_owner_horse;

--***********************************************************
--Create Bets Table *Compund Foreign Key
--***********************************************************

--Bets Table
CREATE TABLE proj_bets(
bet_id NUMBER(10) NOT NUll,
race_id NUMBER(10) NOT NULL,
horse_id NUMBER(10) NOT NUll,
stake NUMBER(10) NOT NULL,
profit NUMBER(10) NULL,
status NVARCHAR2(10) NULL,
PRIMARY KEY(bet_id),
FOREIGN KEY(horse_id,race_id) REFERENCES proj_entry(horse_id, race_id)
);

--Bets Seqeunce
CREATE SEQUENCE proj_bets_seq
START WITH 1
INCREMENT BY 1;

--Bets Trigger
CREATE OR REPLACE TRIGGER proj_bets_seq_trigger
BEFORE INSERT ON proj_bets
FOR EACH ROW
BEGIN
SELECT proj_bets_seq.NEXTVAL
INTO :NEW.bet_id
FROM DUAL;
END;
/

COMMIT;
DESCRIBE proj_bets;

--=======================================================================================================================--

                                                     --Populating Tales

--=======================================================================================================================--

--***********************************************************
/*This block inserts 10 meets FROM one of three courses.
  The meets at Wexford AND Wolverhampton are concurrent
  AND so our business rules about double-bookings may be 
  put to the test later!
*/
--***********************************************************

BEGIN
INSERT INTO proj_meet VALUES(NULL, 'Wexford', TO_DATE('12/04/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 3, 10);
INSERT INTO proj_meet VALUES(NULL, 'Wexford', TO_DATE('19/04/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 3, 10);
INSERT INTO proj_meet VALUES(NULL, 'Wexford', TO_DATE('26/04/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 3, 10);
INSERT INTO proj_meet VALUES(NULL, 'Wolverhampton', TO_DATE('12/04/2014 17:35:00','DD/MM/YYYY HH24:MI:SS'), 3, 15);
INSERT INTO proj_meet VALUES(NULL, 'Wolverhampton', TO_DATE('19/04/2014 17:35:00','DD/MM/YYYY HH24:MI:SS'), 3, 15);
INSERT INTO proj_meet VALUES(NULL, 'Wolverhampton', TO_DATE('26/04/2014 17:35:00','DD/MM/YYYY HH24:MI:SS'), 3, 15);
INSERT INTO proj_meet VALUES(NULL, 'Ayr', TO_DATE('12/05/2014 14:10:00','DD/MM/YYYY HH24:MI:SS'), 3, 7);
INSERT INTO proj_meet VALUES(NULL, 'Ayr', TO_DATE('15/05/2014 14:10:00','DD/MM/YYYY HH24:MI:SS'), 3, 7);
INSERT INTO proj_meet VALUES(NULL, 'Ayr', TO_DATE('19/05/2014 14:10:00','DD/MM/YYYY HH24:MI:SS'), 3, 7);
INSERT INTO proj_meet VALUES(NULL, 'Ayr', TO_DATE('26/05/2014 14:10:00','DD/MM/YYYY HH24:MI:SS'), 3, 7);
END;
/

--***********************************************************
/*This block inserts 3 races per each of the 10 meets above.
  This means we are dealing with just 30 races in total
*/
--***********************************************************

BEGIN
INSERT INTO proj_race_details VALUES(NULL, 1, TO_DATE('12/04/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 7, 5000, 'good to soft');
INSERT INTO proj_race_details VALUES(NULL, 1, TO_DATE('12/04/2014 17:00:00','DD/MM/YYYY HH24:MI:SS'), 'Hurdles', 13, 4500, 'good to soft');
INSERT INTO proj_race_details VALUES(NULL, 1, TO_DATE('12/04/2014 17:40:00','DD/MM/YYYY HH24:MI:SS'), 'Novice Chase', 5, 2000, 'good to soft');

INSERT INTO proj_race_details VALUES(NULL, 2, TO_DATE('19/04/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 7, 5000, 'hard');
INSERT INTO proj_race_details VALUES(NULL, 2, TO_DATE('19/04/2014 17:00:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 13, 4500, 'hard');
INSERT INTO proj_race_details VALUES(NULL, 2, TO_DATE('19/04/2014 17:40:00','DD/MM/YYYY HH24:MI:SS'), 'Novice Chase', 5, 2000 , 'good to soft');

INSERT INTO proj_race_details VALUES(NULL, 3, TO_DATE('26/04/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 7, 5000, 'good to soft');
INSERT INTO proj_race_details VALUES(NULL, 3, TO_DATE('26/04/2014 17:00:00','DD/MM/YYYY HH24:MI:SS'), 'Hurdles', 13, 4500, 'good to soft');
INSERT INTO proj_race_details VALUES(NULL, 3, TO_DATE('26/04/2014 17:40:00','DD/MM/YYYY HH24:MI:SS'), 'Novice Chase', 5, 2000, 'soft');

INSERT INTO proj_race_details VALUES(NULL, 4, TO_DATE('12/04/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 7, 5000, 'hard');
INSERT INTO proj_race_details VALUES(NULL, 4, TO_DATE('12/04/2014 17:00:00','DD/MM/YYYY HH24:MI:SS'), 'Hurdles', 13, 4500, 'hard');
INSERT INTO proj_race_details VALUES(NULL, 4, TO_DATE('12/04/2014 17:40:00','DD/MM/YYYY HH24:MI:SS'), 'Hurdles', 5, 2000, 'good to soft');

INSERT INTO proj_race_details VALUES(NULL, 5, TO_DATE('19/04/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 7, 5000, 'soft');
INSERT INTO proj_race_details VALUES(NULL, 5, TO_DATE('19/04/2014 17:00:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 13, 4500, 'soft');
INSERT INTO proj_race_details VALUES(NULL, 5, TO_DATE('19/04/2014 17:40:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 5, 2000, 'good to soft');

INSERT INTO proj_race_details VALUES(NULL, 6, TO_DATE('26/04/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 'Hurdles', 18, 5000, 'good to soft');
INSERT INTO proj_race_details VALUES(NULL, 6, TO_DATE('26/04/2014 17:00:00','DD/MM/YYYY HH24:MI:SS'), 'Hurdles', 13, 4500, 'good to soft');
INSERT INTO proj_race_details VALUES(NULL, 6, TO_DATE('26/04/2014 17:40:00','DD/MM/YYYY HH24:MI:SS'), 'Novice Chase', 5, 2000, 'good to soft');

INSERT INTO proj_race_details VALUES(NULL, 7, TO_DATE('12/05/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 7, 5000, 'good to soft');
INSERT INTO proj_race_details VALUES(NULL, 7, TO_DATE('12/05/2014 17:00:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 7, 4500, 'good to soft');
INSERT INTO proj_race_details VALUES(NULL, 7, TO_DATE('12/05/2014 17:40:00','DD/MM/YYYY HH24:MI:SS'), 'Novice Chase', 5, 2000, 'good to soft');

INSERT INTO proj_race_details VALUES(NULL, 8, TO_DATE('15/05/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 12, 5000, 'good to soft');
INSERT INTO proj_race_details VALUES(NULL, 8, TO_DATE('15/05/2014 17:00:00','DD/MM/YYYY HH24:MI:SS'), 'Hurdles', 13, 4500, 'good to soft');
INSERT INTO proj_race_details VALUES(NULL, 8, TO_DATE('15/05/2014 17:40:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 5, 6000, 'soft');

INSERT INTO proj_race_details VALUES(NULL, 9, TO_DATE('19/05/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 10, 5000, 'hard');
INSERT INTO proj_race_details VALUES(NULL, 9, TO_DATE('19/05/2014 17:00:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 13, 4500, 'hard');
INSERT INTO proj_race_details VALUES(NULL, 9, TO_DATE('19/05/2014 17:40:00','DD/MM/YYYY HH24:MI:SS'), 'Novice Chase', 7, 2000, 'hard');

INSERT INTO proj_race_details VALUES(NULL, 10, TO_DATE('26/05/2014 16:20:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 12, 5000, 'good to soft');
INSERT INTO proj_race_details VALUES(NULL, 10, TO_DATE('26/05/2014 17:00:00','DD/MM/YYYY HH24:MI:SS'), 'Flat', 13, 4500, 'soft');
INSERT INTO proj_race_details VALUES(NULL, 10, TO_DATE('26/05/2014 17:40:00','DD/MM/YYYY HH24:MI:SS'), 'Novice Chase', 7, 2000, 'good to soft');
END;
/

--***********************************************************
/*This block inserts 60 Jockeys. With 30 races on the cards
  AND 10 horses per race these 60 jockeys will have to ride
  exactly 300 races, collectively. Wexford AND Wolverhampton
  are also running concurrently so it will be all hANDs on deck
*/
--***********************************************************

BEGIN
INSERT INTO proj_jockey VALUES(NUll, 'Frank', 'Malone',TO_DATE('01/04/1980 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'John', 'Mc Inerney',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Roger', 'Clark',TO_DATE('01/04/1977 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Stanley', 'Lee',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Mike', 'Lenihan',TO_DATE('01/04/1986 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Sal', 'Hehir',TO_DATE('01/04/1990 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'ANDy', 'Fields',TO_DATE('01/04/1984 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'July', 'Michaels',TO_DATE('01/04/1979 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Dan', 'Murry',TO_DATE('01/04/1982 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Larry', 'Finn',TO_DATE('01/04/1993 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Mary', 'Shelly',TO_DATE('01/04/1980 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Barry', 'Pratt',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Tom', 'Connors',TO_DATE('01/04/1977 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Dualta', 'Bruan',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Greg', 'Lenihan',TO_DATE('01/04/1986 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Alan', 'Hehir',TO_DATE('01/04/1990 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Ray', 'Fields',TO_DATE('01/04/1984 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'July', 'Stewards',TO_DATE('01/04/1979 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Danny', 'Man',TO_DATE('01/04/1982 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Harry', 'Finn',TO_DATE('01/04/1993 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'John', 'Hurt',TO_DATE('01/04/1993 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Mick', 'Slagh',TO_DATE('01/04/1980 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Gerard', 'Perry',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Tom', 'Feelen',TO_DATE('01/04/1977 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Derk', 'Banger',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Gary', 'Hart',TO_DATE('01/04/1986 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Alan', 'Mc Moe',TO_DATE('01/04/1990 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Roger', 'Stanley',TO_DATE('01/04/1984 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'July', 'Green',TO_DATE('01/04/1979 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Danny', 'Bruton',TO_DATE('01/04/1982 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Haily', 'Finegan',TO_DATE('01/04/1993 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'John', 'Malone',TO_DATE('01/04/1980 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Roger', 'Mc Inerney',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Stan', 'Clark',TO_DATE('01/04/1977 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Mick', 'Lee',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Sal', 'Lenihan',TO_DATE('01/04/1986 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'ANDy', 'Hehir',TO_DATE('01/04/1990 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Jules', 'Fields',TO_DATE('01/04/1984 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Dan', 'Michaels',TO_DATE('01/04/1979 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Larry', 'Murry',TO_DATE('01/04/1982 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Mark', 'Finn',TO_DATE('01/04/1993 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Bart', 'Shelly',TO_DATE('01/04/1980 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Barry', 'Pratt',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Dualta', 'Connors',TO_DATE('01/04/1977 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Gregory', 'Bruan',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Al', 'Lenihan',TO_DATE('01/04/1986 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Raymond', 'Hehir',TO_DATE('01/04/1990 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Jamie', 'Fields',TO_DATE('01/04/1984 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'July', 'Stewards',TO_DATE('01/04/1979 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Fran', 'Man',TO_DATE('01/04/1982 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Joe', 'Finn',TO_DATE('01/04/1993 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Michele', 'Hurt',TO_DATE('01/04/1993 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Gary', 'Slagh',TO_DATE('01/04/1980 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Tim', 'Perry',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Derek', 'Feelen',TO_DATE('01/04/1977 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Brad', 'Banger',TO_DATE('01/04/1981 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Graham', 'Hart',TO_DATE('01/04/1986 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Al', 'Mc Moe',TO_DATE('01/04/1990 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Jerry', 'Stanley',TO_DATE('01/04/1984 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'May', 'Green',TO_DATE('01/04/1979 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Francy', 'Bruton',TO_DATE('01/04/1982 00:40:00','DD/MM/YYYY HH24:MI:SS'));
INSERT INTO proj_jockey VALUES(NUll, 'Hal', 'Finegan',TO_DATE('01/04/1993 00:40:00','DD/MM/YYYY HH24:MI:SS'));
END;
/

--***********************************************************
/*This block inserts 10 Breeders FROM across the country.
  The majority of the horses in the database will have 
  been FROM thesestud farms
*/
--***********************************************************

BEGIN
INSERT INTO proj_breeder VALUES(NULL, 'Kevin', 'O Shea', 0871234234, '22 Pickle Rd, Ballsbridge');
INSERT INTO proj_breeder VALUES(NULL, 'Roger', 'Clemins', 0871233234, '23 Prom Rd, Tuam');
INSERT INTO proj_breeder VALUES(NULL, 'Jimmy', 'Jones', 0871232234, '24 College Rd, D2');
INSERT INTO proj_breeder VALUES(NULL, 'Thomas', 'Barrett', 0872233234, '25 Marys Rd, Sligo');
INSERT INTO proj_breeder VALUES(NULL, 'Larry', 'Flynn', 087123664, '26 Flan Rd, Laois');
INSERT INTO proj_breeder VALUES(NULL, 'Sean', 'Lenihan', 0871288234, '27 Long Rd, Cork');
INSERT INTO proj_breeder VALUES(NULL, 'Mark', 'Finn', 0877734234, '28 Cherry Rd, Mayo');
INSERT INTO proj_breeder VALUES(NULL, 'Jerry', 'Burten', 08712399234, '29 Hardcourt Rd, Clare');
INSERT INTO proj_breeder VALUES(NULL, 'Barry', 'O Regan', 087174234, '12 Haddington Rd, Mayo');
INSERT INTO proj_breeder VALUES(NULL, 'Flan', 'Mitchell', 0871134234, '15 St. Michaels Rd, Donegal');
END;
/

--***********************************************************
/*This block inserts 10 Trainers FROM across the country.
  All the horses in the database will have 
  been trained by one one of these entries
*/
--***********************************************************

BEGIN
INSERT INTO proj_trainer VALUES(NULL, 'George', 'Grams', 0859876876, '88 Galway Rd, Galway');
INSERT INTO proj_trainer VALUES(NULL, 'Brian', 'Barns', 0853276876, '89 Alley Rd, Dublin');
INSERT INTO proj_trainer VALUES(NULL, 'Gary', 'shark', 0859876876, '90 Malleys Rd, Kerry');
INSERT INTO proj_trainer VALUES(NULL, 'Sam', 'Samuels', 0859876876, '91 Court Rd, Mayo');
INSERT INTO proj_trainer VALUES(NULL, 'Sal', 'Bruton', 0859876876, '92 Blooms Rd, Laois');
INSERT INTO proj_trainer VALUES(NULL, 'Will', 'Murry', 0859876876, '93 Collins Rd, Monaghan');
INSERT INTO proj_trainer VALUES(NULL, 'Jack', 'Sully', 0859876876, '94 Dark Rd, Derry');
INSERT INTO proj_trainer VALUES(NULL, 'Collin', 'Graham', 0859876876, '12 Country Rd, Kerry');
INSERT INTO proj_trainer VALUES(NULL, 'Barry', 'Boru', 0859876876, '44 Sligo Rd, Clare');
INSERT INTO proj_trainer VALUES(NULL, 'Burt', 'Simon', 0859876876, '55 Ennis Rd, Dublin');
END;
/

--***********************************************************
/*This block inserts 10 Owners who collectively own all the horses
in the database. Individually, they may own one or several horses 
either as part of syndicate, or as sole owner. 
*/
--***********************************************************

BEGIN
INSERT INTO proj_owner VALUES(NULL, 'Harry', 'Hugh', 0859444876, '50 Ennis Rd, Dublin');
INSERT INTO proj_owner VALUES(NULL, 'Shaun', 'Penn', 0859444876, '50 Ennis Rd, Dublin');
INSERT INTO proj_owner VALUES(NULL, 'Perry', 'Smith', 0859444876, '50 Ennis Rd, Dublin');
INSERT INTO proj_owner VALUES(NULL, 'Mike', 'Smith', 0859444876, '50 Ennis Rd, Dublin');
INSERT INTO proj_owner VALUES(NULL, 'Conrad', 'Bair', 0859444876, '50 Ennis Rd, Dublin');
INSERT INTO proj_owner VALUES(NULL, 'Hal', 'Samuels', 0859444876, '50 Ennis Rd, Dublin');
INSERT INTO proj_owner VALUES(NULL, 'Sara', 'Philips', 0859444876, '50 Ennis Rd, Dublin');
INSERT INTO proj_owner VALUES(NULL, 'Jerry', 'Loren', 0859444876, '50 Ennis Rd, Dublin');
INSERT INTO proj_owner VALUES(NULL, 'Tara', 'Knite', 0859444876, '50 Ennis Rd, Dublin');
INSERT INTO proj_owner VALUES(NULL, 'Bob', 'Tatty', 0859444876, '50 Ennis Rd, Dublin');
END;
/

--***********************************************************
/* 
 This block inserts the 60 horses who will race in our 300
 races along with our 60 Jockeys. Again, the races running at 
 Wexford AND Wolverhampton on the same days could be problematic 
 if their aren't some precautions taken.
*/
--***********************************************************

BEGIN
INSERT INTO proj_horses VALUES(NULL, 'Black Swan', TO_DATE('01/04/2010 00:40:00','DD/MM/YYYY HH24:MI:SS'), 500, 1, 1);
INSERT INTO proj_horses VALUES(NULL, 'Johnny Boy', TO_DATE('01/04/2008 00:40:00','DD/MM/YYYY HH24:MI:SS'), 510, 2, 1);
INSERT INTO proj_horses VALUES(NULL, 'Rocket Ray', TO_DATE('01/04/2010 00:40:00','DD/MM/YYYY HH24:MI:SS'), 500, 1, 1);
INSERT INTO proj_horses VALUES(NULL, 'Door Slam', TO_DATE('01/04/2006 00:40:00','DD/MM/YYYY HH24:MI:SS'), 523, 3, 2);
INSERT INTO proj_horses VALUES(NULL, 'Arounf the Bend', TO_DATE('01/04/2003 00:40:00','DD/MM/YYYY HH24:MI:SS'), 500, 4, 1);
INSERT INTO proj_horses VALUES(NULL, 'Topsy Turvy', TO_DATE('01/04/2010 00:40:00','DD/MM/YYYY HH24:MI:SS'), 450, 5,3);
INSERT INTO proj_horses VALUES(NULL, 'Sally Shoe', TO_DATE('01/04/2004 00:40:00','DD/MM/YYYY HH24:MI:SS'), 470, 2,3);
INSERT INTO proj_horses VALUES(NULL, 'Rare Stone', TO_DATE('01/04/2007 00:40:00','DD/MM/YYYY HH24:MI:SS'), 510, 6,2);
INSERT INTO proj_horses VALUES(NULL, 'Bone Dry', TO_DATE('01/04/2010 00:40:00','DD/MM/YYYY HH24:MI:SS'), 500, 1, 1);
INSERT INTO proj_horses VALUES(NULL, 'Wet Wally', TO_DATE('01/04/2003 00:40:00','DD/MM/YYYY HH24:MI:SS'), 502, 7, 3);
INSERT INTO proj_horses VALUES(NULL, 'Alarm Anne', TO_DATE('01/04/2009 00:40:00','DD/MM/YYYY HH24:MI:SS'), 501, 8, 4);
INSERT INTO proj_horses VALUES(NULL, 'Brown Sailor', TO_DATE('01/04/2008 00:40:00','DD/MM/YYYY HH24:MI:SS'), 502, 9, 5);
INSERT INTO proj_horses VALUES(NULL, 'Barry Brew', TO_DATE('01/04/2010 00:40:00','DD/MM/YYYY HH24:MI:SS'), 440, 10,6);
INSERT INTO proj_horses VALUES(NULL, 'CANDy Fix', TO_DATE('01/04/2007 00:40:00','DD/MM/YYYY HH24:MI:SS'), 440, 1, 6);
INSERT INTO proj_horses VALUES(NULL, 'Star Boy', TO_DATE('01/04/2012 00:40:00','DD/MM/YYYY HH24:MI:SS'), 460, 2, 7);
INSERT INTO proj_horses VALUES(NULL, 'Astral Beat', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 500, 3, 8);
INSERT INTO proj_horses VALUES(NULL, 'SANDy Cove', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 500, 4, 9);
INSERT INTO proj_horses VALUES(NULL, 'Run Run', TO_DATE('01/04/2003 00:40:00','DD/MM/YYYY HH24:MI:SS'), 480, 5, 10);
INSERT INTO proj_horses VALUES(NULL, 'Green IslAND', TO_DATE('01/04/2005 00:40:00','DD/MM/YYYY HH24:MI:SS'), 490, 6, 10);
INSERT INTO proj_horses VALUES(NULL, 'Sound of Success', TO_DATE('01/04/2003 00:40:00','DD/MM/YYYY HH24:MI:SS'), 500, 7, 10);
INSERT INTO proj_horses VALUES(NULL, 'Ferry Home', TO_DATE('01/04/2010 00:40:00','DD/MM/YYYY HH24:MI:SS'), 570, 8, 1);
INSERT INTO proj_horses VALUES(NULL, 'Night runner', TO_DATE('01/04/2012 00:40:00','DD/MM/YYYY HH24:MI:SS'), 530, 9, 2);
INSERT INTO proj_horses VALUES(NULL, 'Fairy Dust', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 510, 10, 4);
INSERT INTO proj_horses VALUES(NULL, 'ANDy PANDy', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 504, 1, 3);
INSERT INTO proj_horses VALUES(NULL, 'Before Noon', TO_DATE('01/04/2010 00:40:00','DD/MM/YYYY HH24:MI:SS'), 534, 2, 7);
INSERT INTO proj_horses VALUES(NULL, 'Sure Thing', TO_DATE('01/04/2002 00:40:00','DD/MM/YYYY HH24:MI:SS'), 512, 3, 6);
INSERT INTO proj_horses VALUES(NULL, 'Another Day', TO_DATE('01/04/2010 00:40:00','DD/MM/YYYY HH24:MI:SS'), 512, 4, 9);
INSERT INTO proj_horses VALUES(NULL, 'After dark', TO_DATE('01/04/2004 00:40:00','DD/MM/YYYY HH24:MI:SS'), 450, 5, 8);
INSERT INTO proj_horses VALUES(NULL, 'Rainbow child', TO_DATE('01/04/2002 00:40:00','DD/MM/YYYY HH24:MI:SS'), 467, 6, 4);
INSERT INTO proj_horses VALUES(NULL, 'Rainy Day', TO_DATE('01/04/2006 00:40:00','DD/MM/YYYY HH24:MI:SS'), 453, 7, 3);
INSERT INTO proj_horses VALUES(NULL, 'Sea Orchin', TO_DATE('01/04/2005 00:40:00','DD/MM/YYYY HH24:MI:SS'), 565, 8, 2);
INSERT INTO proj_horses VALUES(NULL, 'Ocean Monster', TO_DATE('01/04/2008 00:40:00','DD/MM/YYYY HH24:MI:SS'), 506, 9, 8);
INSERT INTO proj_horses VALUES(NULL, 'Hardy Now', TO_DATE('01/04/2009 00:40:00','DD/MM/YYYY HH24:MI:SS'), 420, 10, 7);
INSERT INTO proj_horses VALUES(NULL, 'Abba', TO_DATE('01/04/2000 00:40:00','DD/MM/YYYY HH24:MI:SS'), 467, 1, 6);
INSERT INTO proj_horses VALUES(NULL, 'Duck Luck', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 487, 1, 4);
INSERT INTO proj_horses VALUES(NULL, 'Brown Clown', TO_DATE('01/04/2009 00:40:00','DD/MM/YYYY HH24:MI:SS'), 477, 5, 3);
INSERT INTO proj_horses VALUES(NULL, 'Lucky Buck', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 487, 5, 4);
INSERT INTO proj_horses VALUES(NULL, 'BlAND Bob', TO_DATE('01/04/2005 00:40:00','DD/MM/YYYY HH24:MI:SS'), 490, 6, 10);
INSERT INTO proj_horses VALUES(NULL, 'Plain Sally', TO_DATE('01/04/2003 00:40:00','DD/MM/YYYY HH24:MI:SS'), 500, 7, 10);
INSERT INTO proj_horses VALUES(NULL, 'Two Tails', TO_DATE('01/04/2010 00:40:00','DD/MM/YYYY HH24:MI:SS'), 570, 8, 1);
INSERT INTO proj_horses VALUES(NULL, 'Flags comin', TO_DATE('01/04/2012 00:40:00','DD/MM/YYYY HH24:MI:SS'), 530, 9, 2);
INSERT INTO proj_horses VALUES(NULL, 'Petrol head', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 510, 10, 4);
INSERT INTO proj_horses VALUES(NULL, 'Rare Type', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 504, 1, 3);
INSERT INTO proj_horses VALUES(NULL, 'Scam Artist', TO_DATE('01/04/2010 00:40:00','DD/MM/YYYY HH24:MI:SS'), 534, 2, 7);
INSERT INTO proj_horses VALUES(NULL, 'Shredder', TO_DATE('01/04/2002 00:40:00','DD/MM/YYYY HH24:MI:SS'), 512, 3, 6);
INSERT INTO proj_horses VALUES(NULL, 'Bangers AND Mash', TO_DATE('01/04/2010 00:40:00','DD/MM/YYYY HH24:MI:SS'), 512, 4, 9);
INSERT INTO proj_horses VALUES(NULL, 'Blue Gills', TO_DATE('01/04/2004 00:40:00','DD/MM/YYYY HH24:MI:SS'), 450, 5, 8);
INSERT INTO proj_horses VALUES(NULL, 'Elbow Eddie', TO_DATE('01/04/2002 00:40:00','DD/MM/YYYY HH24:MI:SS'), 467, 6, 4);
INSERT INTO proj_horses VALUES(NULL, 'Dark Train', TO_DATE('01/04/2006 00:40:00','DD/MM/YYYY HH24:MI:SS'), 453, 7, 3);
INSERT INTO proj_horses VALUES(NULL, 'Happy Fish', TO_DATE('01/04/2005 00:40:00','DD/MM/YYYY HH24:MI:SS'), 565, 8, 2);
INSERT INTO proj_horses VALUES(NULL, 'Zumbo', TO_DATE('01/04/2008 00:40:00','DD/MM/YYYY HH24:MI:SS'), 506, 9, 8);
INSERT INTO proj_horses VALUES(NULL, 'Bella', TO_DATE('01/04/2009 00:40:00','DD/MM/YYYY HH24:MI:SS'), 420, 10, 7);
INSERT INTO proj_horses VALUES(NULL, 'Stella', TO_DATE('01/04/2000 00:40:00','DD/MM/YYYY HH24:MI:SS'), 467, 1, 6);
INSERT INTO proj_horses VALUES(NULL, 'Dire Days', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 487, 1, 4);
INSERT INTO proj_horses VALUES(NULL, 'Celtic', TO_DATE('01/04/2009 00:40:00','DD/MM/YYYY HH24:MI:SS'), 477, 5, 3);
INSERT INTO proj_horses VALUES(NULL, 'Brawn ', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 487, 5, 4);
INSERT INTO proj_horses VALUES(NULL, 'Story Time', TO_DATE('01/04/2008 00:40:00','DD/MM/YYYY HH24:MI:SS'), 506, 9, 8);
INSERT INTO proj_horses VALUES(NULL, 'My Round', TO_DATE('01/04/2009 00:40:00','DD/MM/YYYY HH24:MI:SS'), 420, 10, 7);
INSERT INTO proj_horses VALUES(NULL, 'Flurry', TO_DATE('01/04/2000 00:40:00','DD/MM/YYYY HH24:MI:SS'), 467, 1, 6);
INSERT INTO proj_horses VALUES(NULL, 'Barmy VANDetta', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 487, 1, 4);
END;
/

--***********************************************************
/* 
 This block inserts 60 certificates of ownership/horse-passports.
 The course is legally obliged to check this information before 
 allowing horses on the track. If disease or infections were to 
 spread as a result of not checking these certs then the course
 would be liable for damages.
*/
--***********************************************************

BEGIN
INSERT INTO proj_horse_cert VALUES(10111111, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',1);
INSERT INTO proj_horse_cert VALUES(20101011, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',2);
INSERT INTO proj_horse_cert VALUES(12222221, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',3);
INSERT INTO proj_horse_cert VALUES(20101111, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',4);
INSERT INTO proj_horse_cert VALUES(11101010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',5);
INSERT INTO proj_horse_cert VALUES(21101010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',6);
INSERT INTO proj_horse_cert VALUES(11111010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',7);
INSERT INTO proj_horse_cert VALUES(20088010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',8);
INSERT INTO proj_horse_cert VALUES(00101010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',9);
INSERT INTO proj_horse_cert VALUES(20001990, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',10);
INSERT INTO proj_horse_cert VALUES(10199000, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',12);
INSERT INTO proj_horse_cert VALUES(22101188, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',13);
INSERT INTO proj_horse_cert VALUES(13101010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',14);
INSERT INTO proj_horse_cert VALUES(24101022, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',15);
INSERT INTO proj_horse_cert VALUES(15101010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',16);
INSERT INTO proj_horse_cert VALUES(26101033, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',17);
INSERT INTO proj_horse_cert VALUES(17101010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',18);
INSERT INTO proj_horse_cert VALUES(28101013, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',19);
INSERT INTO proj_horse_cert VALUES(19101012, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',20);
INSERT INTO proj_horse_cert VALUES(20201014, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',21);
INSERT INTO proj_horse_cert VALUES(10201015, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',22);
INSERT INTO proj_horse_cert VALUES(20301018, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',23);
INSERT INTO proj_horse_cert VALUES(10401510, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',23);
INSERT INTO proj_horse_cert VALUES(20501052, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',24);
INSERT INTO proj_horse_cert VALUES(10301010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',25);
INSERT INTO proj_horse_cert VALUES(20701014, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',26);
INSERT INTO proj_horse_cert VALUES(10301020, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',27);
INSERT INTO proj_horse_cert VALUES(30901013, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',28);
INSERT INTO proj_horse_cert VALUES(10311010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',29);
INSERT INTO proj_horse_cert VALUES(30421017, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',30);
INSERT INTO proj_horse_cert VALUES(10131010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',31);
INSERT INTO proj_horse_cert VALUES(30141017, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',32);
INSERT INTO proj_horse_cert VALUES(10151010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',33);
INSERT INTO proj_horse_cert VALUES(30661015, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',34);
INSERT INTO proj_horse_cert VALUES(10721010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',35);
INSERT INTO proj_horse_cert VALUES(30781017, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',36);
INSERT INTO proj_horse_cert VALUES(14121010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',37);
INSERT INTO proj_horse_cert VALUES(30102019, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',38);
INSERT INTO proj_horse_cert VALUES(19103010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',39);
INSERT INTO proj_horse_cert VALUES(30104012, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',40);
INSERT INTO proj_horse_cert VALUES(18105010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',41);
INSERT INTO proj_horse_cert VALUES(30106011, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',42);
INSERT INTO proj_horse_cert VALUES(14107010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',43);
INSERT INTO proj_horse_cert VALUES(36108014, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',44);
INSERT INTO proj_horse_cert VALUES(14109010, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',45);
INSERT INTO proj_horse_cert VALUES(30101212, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',46);
INSERT INTO proj_horse_cert VALUES(15101310, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',47);
INSERT INTO proj_horse_cert VALUES(30101415, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',48);
INSERT INTO proj_horse_cert VALUES(11015109, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',49);
INSERT INTO proj_horse_cert VALUES(39101613, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',50);
INSERT INTO proj_horse_cert VALUES(17101710, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',51);
INSERT INTO proj_horse_cert VALUES(35101810, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',52);
INSERT INTO proj_horse_cert VALUES(13101914, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',53);
INSERT INTO proj_horse_cert VALUES(31101020, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',54);
INSERT INTO proj_horse_cert VALUES(19101032, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',55);
INSERT INTO proj_horse_cert VALUES(38101040, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',56);
INSERT INTO proj_horse_cert VALUES(17101050, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',57);
INSERT INTO proj_horse_cert VALUES(36101067, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',58);
INSERT INTO proj_horse_cert VALUES(15101070, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',59);
INSERT INTO proj_horse_cert VALUES(34101088, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',60);
INSERT INTO proj_horse_cert VALUES(13101090, TO_DATE('01/01/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('20/12/2014 00:00:00','DD/MM/YYYY HH24:MI:SS'),'IRELAND',11);
END;
/

--***********************************************************
/*The following data is inderted in the junction table
between owners AND horses to resolve the many to many reltionship
*/
--***********************************************************

BEGIN
INSERT INTO proj_owner_horse VALUES(1,1);
INSERT INTO proj_owner_horse VALUES(1,2);
INSERT INTO proj_owner_horse VALUES(2,3);
INSERT INTO proj_owner_horse VALUES(3,4);
INSERT INTO proj_owner_horse VALUES(4,5);
INSERT INTO proj_owner_horse VALUES(5,6);
INSERT INTO proj_owner_horse VALUES(5,7);
INSERT INTO proj_owner_horse VALUES(5,8);
INSERT INTO proj_owner_horse VALUES(6,9);
INSERT INTO proj_owner_horse VALUES(7,10);
INSERT INTO proj_owner_horse VALUES(8,1);
INSERT INTO proj_owner_horse VALUES(8,2);
INSERT INTO proj_owner_horse VALUES(9,3);
INSERT INTO proj_owner_horse VALUES(10,4);
INSERT INTO proj_owner_horse VALUES(11,5);
INSERT INTO proj_owner_horse VALUES(11,6);
INSERT INTO proj_owner_horse VALUES(12,7);
INSERT INTO proj_owner_horse VALUES(12,8);
INSERT INTO proj_owner_horse VALUES(13,9);
INSERT INTO proj_owner_horse VALUES(14,10);
INSERT INTO proj_owner_horse VALUES(15,1);
INSERT INTO proj_owner_horse VALUES(16,2);
INSERT INTO proj_owner_horse VALUES(17,3);
INSERT INTO proj_owner_horse VALUES(18,4);
INSERT INTO proj_owner_horse VALUES(18,5);
INSERT INTO proj_owner_horse VALUES(19,6);
INSERT INTO proj_owner_horse VALUES(20,7);
INSERT INTO proj_owner_horse VALUES(21,8);
INSERT INTO proj_owner_horse VALUES(22,8);
INSERT INTO proj_owner_horse VALUES(22,9);
INSERT INTO proj_owner_horse VALUES(23,1);
INSERT INTO proj_owner_horse VALUES(24,2);
INSERT INTO proj_owner_horse VALUES(25,3);
INSERT INTO proj_owner_horse VALUES(26,7);
INSERT INTO proj_owner_horse VALUES(27,8);
INSERT INTO proj_owner_horse VALUES(28,9);
INSERT INTO proj_owner_horse VALUES(29,10);
INSERT INTO proj_owner_horse VALUES(30,1);
INSERT INTO proj_owner_horse VALUES(31,2);
INSERT INTO proj_owner_horse VALUES(32,3);
INSERT INTO proj_owner_horse VALUES(33,7);
INSERT INTO proj_owner_horse VALUES(34,8);
INSERT INTO proj_owner_horse VALUES(35,9);
INSERT INTO proj_owner_horse VALUES(36,6);
INSERT INTO proj_owner_horse VALUES(37,1);
INSERT INTO proj_owner_horse VALUES(38,2);
INSERT INTO proj_owner_horse VALUES(1,4);
INSERT INTO proj_owner_horse VALUES(2,5);
INSERT INTO proj_owner_horse VALUES(4,6);
INSERT INTO proj_owner_horse VALUES(6,7);
INSERT INTO proj_owner_horse VALUES(8,8);
INSERT INTO proj_owner_horse VALUES(9,9);
INSERT INTO proj_owner_horse VALUES(10,10);
INSERT INTO proj_owner_horse VALUES(39,1);
INSERT INTO proj_owner_horse VALUES(40,2);
INSERT INTO proj_owner_horse VALUES(41,3);
INSERT INTO proj_owner_horse VALUES(42,4);
INSERT INTO proj_owner_horse VALUES(43,5);
INSERT INTO proj_owner_horse VALUES(44,6);
INSERT INTO proj_owner_horse VALUES(45,7);
INSERT INTO proj_owner_horse VALUES(46,8);
INSERT INTO proj_owner_horse VALUES(46,9);
INSERT INTO proj_owner_horse VALUES(47,10);
INSERT INTO proj_owner_horse VALUES(48,1);
INSERT INTO proj_owner_horse VALUES(49,2);
INSERT INTO proj_owner_horse VALUES(50,3);
INSERT INTO proj_owner_horse VALUES(51,4);
INSERT INTO proj_owner_horse VALUES(52,5);
INSERT INTO proj_owner_horse VALUES(53,6);
INSERT INTO proj_owner_horse VALUES(54,7);
INSERT INTO proj_owner_horse VALUES(55,8);
INSERT INTO proj_owner_horse VALUES(56,9);
INSERT INTO proj_owner_horse VALUES(57,10);
INSERT INTO proj_owner_horse VALUES(57,1);
INSERT INTO proj_owner_horse VALUES(58,2);
INSERT INTO proj_owner_horse VALUES(59,3);
INSERT INTO proj_owner_horse VALUES(60,4);
INSERT INTO proj_owner_horse VALUES(60,5);
INSERT INTO proj_owner_horse VALUES(55,6);
INSERT INTO proj_owner_horse VALUES(22,7);
INSERT INTO proj_owner_horse VALUES(34,6);
INSERT INTO proj_owner_horse VALUES(33,8);
INSERT INTO proj_owner_horse VALUES(52,9);
INSERT INTO proj_owner_horse VALUES(39,3);
INSERT INTO proj_owner_horse VALUES(39,2);
INSERT INTO proj_owner_horse VALUES(44,3);
INSERT INTO proj_owner_horse VALUES(46,7);
INSERT INTO proj_owner_horse VALUES(48,8);
INSERT INTO proj_owner_horse VALUES(45,9);
END;

--***********************************************************
/* 
 This block uses a loop to populate the entry table with 300 
 entries. I've used the modulus function carefully to ensure 
 that Jockeys AND Horses have been allocated to their respective
 venues without double bookings. For now, the following three
 attributes are left null: odds, place, AND comment. The odds
 cannot be calculated until the first bet has been placed AND
 will be automatically updated in due course. The place AND comment
 will be updated after the race using a special procedure which 
 will performs several necessary AND related tasks.
*/
--***********************************************************

BEGIN
FOR i IN 0..299 LOOP
	INSERT INTO proj_entry 
	VALUES (trunc(i/10) + 1, mod(i,60)+1,mod(i,60)+1,null,mod(i,10)+1,null,null); 
END LOOP;
END;
/

--***********************************************************
/* 
 This block insert 300 bets at a time AND it can be run
 multiple times. Each time it's run it generates three bets for
 each entry in the database.I chose to run it only three times 
 giving a total of 900 bets. The paramter for stake was designed 
 to model typical betting behvaiour patters: The odds shorten as you
 travserse the entries AND are not flat.Furthermore, the odds
 generated will be slighly different each time they are generated
 giving a relaisitc spread. The rising pattern of odds
 is also offset FROM the number of horses per race to ensure 
 than the beting patterns aren't overly predictable. 

 The procedure called after the loop is designed solely
 for current task of populating this table. In this instance
 it was more effecient to calculate the odds just once. However,
 FROM herein a different procedure will be used which must re-calculate
 the odds for all entries in a race after each single bet is placed.
 This is processor heavey. 

 If you chose to run this loop three times like I did(for 900 entries), 
 be warned that the next loop may take sometime (180 seconds to run
 on my 4GB, i7 laptop). It's probably sufficient to  run this 
 loop just once, AND the next loop once (but set to 299, not 899). 
 This would still yield 3 bets per horse.
*/
--***********************************************************

--You must run install the package before you can run this loop!
BEGIN
FOR j IN 0..299 LOOP --I ran this three times
	INSERT INTO proj_bets 
	VALUES (NULL,trunc(j/10) + 1,mod(j,60)+1, (mod(j*2,49)+2 * dbms_rANDom.value(1,2)), 0,'Accepted');
END LOOP;
pkg.update_all_odds;
END;
/

--***********************************************************
/* 
 This Block will update the the profit/loss column in the bet
 table AND the status of the bet to WIN/LOSE. As mentioned 
 already, this block takes 3 minutes on my laptop so you may
 want to run the previous loop just once AND then set this loop
 to run only as far as 299. 
*/
--***********************************************************

BEGIN
FOR i IN 0..899 LOOP
	pkg.update_result(trunc(i/10) + 1,mod(i,60)+1,mod((i+trunc(i/20)),10)+1,null);
END LOOP;
END;
/


--=======================================================================================================================--

                                                     --Packages & Procedures

--=======================================================================================================================--

--My package contains 6 procedures
--1) update_result
--2) update_profit
--3) placeBet
--4) update_race_odds
--5) cancel_race
--6) update_all_odds
--                                                        Summary
--
-- The procedures are used in the following way. After an entry is made it's results (odds, place, comment) will
-- be null unitl they are updated after the race. This updating is done by Procdure(1) whcih in turn calls 
-- Procedure(2). So one Procedure (1) & (2) have a relationship. The first procedure updates the results and the second
-- updates the profites and betting slips as the information rolls in.

--A similar relationship exists between Procedur(3) & (4). For eachbet that is placed (3) the procedure calls
--Procedure (4) so that the odds for every horse in that race can be quickly recalculated. Therefore our first
-- four produres are paired off into two groups, each one madeup of a parent and child procedure
--       Parent (1) -> Child (2)
--       Parent (2) -> Child (3)
--
--The final procdure (6) is to be used when for cancelling races when illegal gambling procedures hve been detected
--by triggers discussed later on. When a raceis cancelled all betting slips have their status set to 'REFUND' and
--and WINS/LOSES are voided. Therefore, the profit column is setto zero also.
--


--Package Head
CREATE OR REPLACE PACKAGE pkg AS --Declare Interface
PROCEDURE update_result(race_id_Arg NUMBER, horse_id_Arg NUMBER, place_Arg NUMBER, note_Arg NVARCHAR2);
PROCEDURE update_profit;
PROCEDURE placeBet(race_id_Arg NUMBER, horse_id_Arg NUMBER, stake NUMBER);
PROCEDURE update_race_odds(race_id_Arg NUMBER);
PROCEDURE update_all_odds;
PROCEDURE cancel_race(race_id_Arg NUMBER);
END;
/

--Package Body
CREATE OR REPLACE PACKAGE BODY Pkg AS


--=======================================================================================================--
											--Procedure Number(1)--
											   --update_result--
--=======================================================================================================--
PROCEDURE update_result(race_id_Arg NUMBER, horse_id_Arg NUMBER, place_Arg NUMBER, note_Arg NVARCHAR2)
IS
IMPOSSIBLE_PLACE EXCEPTION;
PRAGMA EXCEPTION_INIT(IMPOSSIBLE_PLACE, -20001);
BEGIN
SAVEPOINT before_update_result;
IF place_Arg <= 0
THEN
RAISE IMPOSSIBLE_PLACE;
END IF;
UPDATE proj_entry SET place = place_Arg WHERE horse_id = horse_id_Arg AND race_id = race_id_Arg;
UPDATE proj_entry SET note = note_Arg WHERE horse_id = horse_id_Arg AND race_id = race_id_Arg;
--HERE IS WHERE THE CHILD PROCEDURE IS CALLED. 
pkg.update_profit;
EXCEPTION
WHEN IMPOSSIBLE_PLACE 
THEN RAISE_APPLICATION_ERROR(-20001, 'A Placemust be a postive integer');
ROLLBACK TO before_update_result;
END update_result;

--=======================================================================================================--
											--Procedure Number(2)
											  --update_profit--
--=======================================================================================================--
PROCEDURE update_profit
IS
odds_temp NUMBER(10);
place_temp NUMBER(10);
CURSOR curBet 
IS 
SELECT bet_id,race_id,horse_id, profit, status, stake
FROM proj_bets FOR UPDATE OF profit, status;
varBetRow curBet%ROWTYPE;
MAX_PAYOUT EXCEPTION;
PRAGMA EXCEPTION_INIT(MAX_PAYOUT,-20002);
BEGIN
SAVEPOINT before_update_profit;
--Open our cursor
OPEN curBet;
--Fetch the first row FROM our cursor
FETCH curBet
INTO varBetRow;
--While a result is found, Loop
WHILE curBet%FOUND LOOP
	SELECT proj_entry.odds INTO odds_temp FROM proj_entry WHERE race_id = varBetRow.race_id AND horse_id = varBetRow.horse_id;
	SELECT proj_entry.place INTO place_temp FROM proj_entry WHERE race_id = varBetRow.race_id AND horse_id = varBetRow.horse_id;
	IF place_temp = 1
		THEN
		IF (varBetRow.stake * odds_temp * -1) < -1000
			THEN
			RAISE MAX_PAYOUT;
		END IF;
		UPDATE proj_bets SET profit = (varBetRow.stake * odds_temp * -1) WHERE bet_id = varBetRow.bet_id;
		UPDATE proj_bets SET status = 'WIN' WHERE race_id = varBetRow.race_id AND horse_id = varBetRow.horse_id;
	ELSE
		UPDATE proj_bets SET profit = (varBetRow.stake) WHERE bet_id = varBetRow.bet_id;
		UPDATE proj_bets SET status = 'LOSE' WHERE race_id = varBetRow.race_id AND horse_id = varBetRow.horse_id;
	END IF;
	FETCH curBet 
	INTO varBetRow;
END LOOP;
EXCEPTION
WHEN MAX_PAYOUT 
THEN RAISE_APPLICATION_ERROR(-20002, 'Large Payout for betslip: '||varBetRow.bet_id);
ROLLBACK to before_update_profit;
END update_profit;

--=======================================================================================================--
											--Procedure Number(3)
											     --placeBet--
--=======================================================================================================--

PROCEDURE placeBet(race_id_Arg NUMBER, horse_id_Arg NUMBER, stake NUMBER)
IS
STAKE_TOO_LARGE EXCEPTION;
STAKE_TOO_SMALL EXCEPTION;
PRAGMA EXCEPTION_INIT(STAKE_TOO_LARGE, -20003);
PRAGMA EXCEPTION_INIT(STAKE_TOO_SMALL, -20004);
BEGIN
SAVEPOINT before_place_bet;
IF stake < 2
THEN 
RAISE STAKE_TOO_SMALL;
ELSIF stake > 100
THEN RAISE STAKE_TOO_LARGE;
END IF;
INSERT INTO proj_bets VALUES(NULL, race_id_Arg, horse_id_Arg, stake, NULL,'Accepted');
--HERE IS WHERE THE CHILD PROCEDURE IS CALLED
pkg.update_race_odds(race_id_Arg); 
EXCEPTION
WHEN STAKE_TOO_LARGE
THEN RAISE_APPLICATION_ERROR(-20003,'Your stake cannot exceed 100 Euros');
ROLLBACK TO before_place_bet;
WHEN STAKE_TOO_SMALL
THEN RAISE_APPLICATION_ERROR(-20004, 'Your stake must exceed 2 euro');
ROLLBACK TO before_place_bet;
END placeBet;

--=======================================================================================================--
											--Procedure Number(4)
											  --update_race_odds--
--=======================================================================================================--

PROCEDURE update_race_odds(race_id_Arg NUMBER)
AS
total_sum_race_bets NUMBER(10);
total_sum_horse_bets NUMBER(10);
odds_calculation FLOAT(10);
CURSOR curEnt 
IS 
SELECT race_id,horse_id, odds
FROM proj_entry WHERE race_id = race_id_Arg FOR UPDATE OF odds;
varEntRow curEnt%ROWTYPE;
ODDS_UPPER_LIMIT EXCEPTION;
ODDS_LOWER_LIMIT EXCEPTION;
PRAGMA EXCEPTION_INIT(ODDS_UPPER_LIMIT,-20005);
PRAGMA EXCEPTION_INIT(ODDS_LOWER_LIMIT, -20006);
BEGIN
SAVEPOINT before_update_race_odds;
--Open our cursor
OPEN curEnt;
--Fetch the first row FROM our cursor
FETCH curEnt
INTO varEntRow;
--While a result is found, Loop
WHILE curEnt%FOUND LOOP
	SELECT sum(stake) INTO total_sum_race_bets FROM proj_bets WHERE race_id = race_id_Arg;
	SELECT sum(stake) INTO total_sum_horse_bets FROM proj_bets WHERE race_id = race_id_Arg AND horse_id = varEntRow.horse_id;
	odds_calculation := ((1.0 / (total_sum_horse_bets / total_sum_race_bets)) * .8);
	IF odds_calculation > 500
		THEN RAISE ODDS_UPPER_LIMIT;
	ELSIF odds_calculation <= 1.05
		THEN RAISE ODDS_UPPER_LIMIT;
	END IF;
	UPDATE proj_entry SET odds = odds_calculation WHERE race_id = race_id_Arg AND horse_id = varEntRow.horse_id;
	FETCH curEnt 
	INTO varEntRow;
END LOOP;
EXCEPTION
WHEN ODDS_UPPER_LIMIT
	THEN RAISE_APPLICATION_ERROR(-20005,'The odds upper-limit of 500 has been exceeded');
	ROLLBACK TO before_update_race_odds;
	WHEN ODDS_LOWER_LIMIT
	THEN RAISE_APPLICATION_ERROR(-20006, 'The odds lower-limit of 1.05 has been exceeded');
	ROLLBACK TO before_update_race_odds;
END update_race_odds;

--=======================================================================================================--
											--Procedure Number(5)
											  --update_all_odds--
											--*NOT FOR GENERAL USE*--
--=======================================================================================================--

--update all odds
PROCEDURE update_all_odds
AS
total_sum_race_bets NUMBER(10);
total_sum_horse_bets NUMBER(10);
odds_calculation FLOAT(10);
CURSOR curEnt
IS
SELECT race_id,horse_id, odds
FROM proj_entry FOR UPDATE OF odds;
varEntRow curEnt%ROWTYPE;
ODDS_UPPER_LIMIT EXCEPTION;
ODDS_LOWER_LIMIT EXCEPTION;
BEGIN
SAVEPOINT before_update_all_odds;
--Open our cursor
OPEN curEnt;
--Fetch the first row FROM our cursor
FETCH curEnt
INTO varEntRow;
--While a result is found, Loop
WHILE curEnt%FOUND LOOP
    SELECT sum(stake) INTO total_sum_race_bets FROM proj_bets WHERE race_id = varEntRow.race_id;
    SELECT sum(stake) INTO total_sum_horse_bets FROM proj_bets WHERE race_id = varEntRow.race_id AND horse_id = varEntRow.horse_id;
    odds_calculation := ((1.0 / (total_sum_horse_bets / total_sum_race_bets)) * .8);
    IF odds_calculation > 500
		THEN RAISE ODDS_UPPER_LIMIT;
	ELSIF odds_calculation <= 1
		THEN RAISE ODDS_UPPER_LIMIT;
	END IF;
    UPDATE proj_entry SET odds = odds_calculation WHERE race_id = varEntRow.race_id AND horse_id = varEntRow.horse_id;
    FETCH curEnt
    INTO varEntRow;
END LOOP;
EXCEPTION
	WHEN ODDS_UPPER_LIMIT
	THEN RAISE_APPLICATION_ERROR(-20005,'The odds upper-limit of 500 has been exceeded');
	ROLLBACK TO before_update_all_odds;
	WHEN ODDS_LOWER_LIMIT
	THEN RAISE_APPLICATION_ERROR(-20006, 'The odds lower-limit of has been exceeded');
	ROLLBACK TO before_update_all_odds;
END update_all_odds;


--=======================================================================================================--
											--Procedure Number(6)
											  --cancel_race--
--=======================================================================================================--

PROCEDURE cancel_race(race_id_Arg NUMBER)
AS
CURSOR curBet
IS
SELECT status, profit, race_id
FROM proj_bets 
WHERE race_id = race_id_Arg
FOR UPDATE OF profit, status;

varBetRow curBet%ROWTYPE;
BEGIN
--Open our cursor
OPEN curBet;
--Fetch the first row FROM our cursor
FETCH curBet
INTO varBetRow;
--While a result is found, Loop
WHILE curBet%FOUND LOOP
    UPDATE proj_bets SET profit = 0 WHERE race_id = varBetRow.race_id;
    UPDATE proj_bets SET status = 'REFUND' WHERE race_id = varBetRow.race_id;
    FETCH curBet
    INTO varBetRow;
END LOOP;
END cancel_race;
END pkg;
/


--=======================================================================================================================--

                                                     --	Inner Joins--

--=======================================================================================================================--

--=====================================
--Inner Join #1: 
--Business Question: What trainers have made the most prize_money?

--First a view needs to be made so that a 
--query can be made more easily using data
--from different tables.

--The views needed four joins 
--to make the output more human readable
--The number of could be lower in
--of my later joins also, if I had 
--not made them more human readable.

Create view trainer_vw AS
SELECT
prize_money, 
(e.tf_name||' '||e.tl_name) AS Trainer,
e.trainer_phone AS PHONE,
e.trainer_address AS ADDRESS
FROM proj_meet a 
JOIN proj_race_details b 
ON a.meet_id = b.meet_id 
JOIN proj_entry c 
on b.race_id = c.race_id
JOIN proj_horses d
ON d.horse_id = c.horse_id
JOIN proj_trainer e
ON e.trainer_id = d.trainer_id;

--Now a query is made on the view very simply
SELECT
trainer,
phone,
address,
SUM(prize_money) AS total_money
FROM trainer_vw
GROUP BY trainer,phone,address
ORDER BY total_money DESC;
--=====================================

--Inner Join 2
--Business Question: How many bets were placed for the first race in Wolverhampton on the 12th of April?

--Two tables needed to be joined to make this
--queury possible. Then they restricted by
--meet name and time of day.

SELECT 
count(bet_id) AS NUM_OF_BETS,
meet_name,
race_time 
FROM proj_meet a 
JOIN proj_race_details b 
ON a.meet_id = b.meet_id 
JOIN proj_bets c 
ON b.race_id = c.race_id
WHERE meet_name = 'Wolverhampton' 
AND race_time = TO_DATE('12/04/2014 16:20:00','DD/MM/YYYY HH24:MI:SS')
GROUP BY(meet_name,race_time);

--======================================
--Inner Join 3
--What horse/horses has won the most races?

--Currently, there are 30 horses who have won a single race each.
--This produces a big screenshot so I updated the tables so that
--horse number 1 would has 2 wins.
UPDATE proj_entry SET place = 1 WHERE race_id = 7 AND horse_id = 1;
UPDATE proj_entry SET place = 4 WHERE race_id = 7 AND horse_id = 8;

--This query should now retun one horse; the one
--with the most wins. To demonstrate an alternative
--approach I didn't use a metod for this question.
--As a result it's full of subqueries and is hard to
--read. If you look closely you see that the same queuery
--gets repaeated in within the larger sub-queuery. This
--is not a nice way to work.

SELECT 
horse_name AS Horse,
tot_wins AS Wins
FROM
	(
	SELECT 
	HORSE_ID, 
	COUNT(HORSE_ID) AS tot_wins
	FROM 
	PROJ_ENTRY WHERE PLACE = 1
	HAVING count(HORSE_ID)=
		(
			SELECT MAX(tot_wins)
			FROM
			(
				SELECT HORSE_ID, COUNT(HORSE_ID) AS tot_wins FROM PROJ_ENTRY WHERE PLACE = 1 GROUP BY HORSE_ID
			)
		)
		GROUP BY HORSE_ID
	) a
JOIN proj_horses b
ON
a.horse_id = b.horse_id;

--=========================================
--Inner Join  4
--Business Question: WHERE can I see the horse Duck Luck running?

--First i make a master view which contains almost everything 
--I could want. I'll usethis view again in future.

CREATE VIEW results AS
SELECT DISTINCT
a.race_id,
e.horse_id,
b.meet_name AS Course,
a.race_time AS Time, 
(f.jf_name||' '||f.jl_name) AS Jockey, 
e.horse_name AS Horse, 
e.weight AS "Weight (Kg)", 
trunc(months_between(sysdate,e.horse_dob)/12) AS Age, 
c.odds, 
c.place, 
c.note AS Note, 
(g.bf_name||' '||g.bl_name) AS Breeder, 
(h.tf_name||' '||h.tl_name) AS Trainer, 
(j.of_name||' '||j.ol_name) AS Owner, 
a.race_type AS Type, 
a.distance AS Furlongs, 
a.prize_money AS "Prize Money", 
a.ground AS Ground, 
c.stall AS Stall
FROM proj_race_details a
JOIN proj_meet b ON a.meet_id = b.meet_id
JOIN proj_entry c ON c.race_id = a.race_id
JOIN proj_bets d ON d.race_id = c.race_id AND d.horse_id = c.horse_id
JOIN proj_horses e ON e.horse_id = d.horse_id
JOIN proj_jockey f ON f.jockey_id = c.jockey_id
JOIN proj_breeder g ON g.breeder_id = e.breeder_id
JOIN proj_trainer h ON h.trainer_id = e.trainer_id
JOIN 
(SELECT ph.horse_id AS horse_id, MIN(pj.owner_id) AS Owner
FROM proj_owner_horse pj INNER JOIN proj_horses ph
ON pj.horse_id = ph.horse_id
GROUP BY ph.horse_id
) i
ON i.horse_id = e.horse_id
JOIN proj_owner j ON j.owner_id = i.Owner
ORDER BY Race_id;

--Now that I have a wonderful view
--I don't need to resort to ugly subqueries
--and I can make one very simple queury as follows:

SELECT * FROM results WHERE horse = 'Duck Luck' ORDER BY TIME;

--=======================================================================================================================--

                                                     --	Outer Joins--

--=======================================================================================================================--


--Left Join #1
--Left join entrys(manditory) to bets(optional)
--First, I must insert three entries with no bets
--to illistrate the point of an outer join.

BEGIN
INSERT INTO proj_entry VALUES(30,18,1,100,11,11,NULL);
INSERT INTO proj_entry VALUES(30,19,2,100,12,12,NULL);
INSERT INTO proj_entry VALUES(30,1,3,100,13,13,NULL);
END;
/

--Now return the left join.
--In the PDF you can see 
--the effect of this left join on the 
--upper rows of the table because
--i've order the output descendingly.
--Entries canbe seen with no betting 
--information becuase they were on 
--left side of the left-join
--and didn't need to be mached
--on eaither horse_id or race_id

SELECT DISTINCT
b.bet_id, 
a.race_id,
a.horse_id, 
a.jockey_id, 
a.odds,
a.stall,
a.place,
b.profit,
b.status 
FROM proj_entry a 
LEFT JOIN proj_bets b 
ON a.race_id = b.race_id 
AND a.horse_id = b.horse_id
WHERE a.race_id = 30
ORDER BY bet_id DESC;

--==============================================================================
--Left Join 2
--Left Join horses(Manditory) to Breeder(Optional)
--First, insert some horses without breeders to illustrate the puurpose of an outer join

BEGIN
INSERT INTO proj_horses VALUES(NULL, 'Over Yonder', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 476, 3, null);
INSERT INTO proj_horses VALUES(NULL, 'War Horse', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 476, 3, null);
INSERT INTO proj_horses VALUES(NULL, 'Jibber Jabber', TO_DATE('01/04/2011 00:40:00','DD/MM/YYYY HH24:MI:SS'), 476, 3, null);
END;
/

--Next, return our left join.
--The horses wihtout trainers are clearly
--visable in the top three rows of the output
SELECT 
(b.bf_name||' '||b.bl_name) AS Breeder, 
a.horse_name AS Horse
FROM proj_horses a 
LEFT JOIN proj_breeder b 
ON a.breeder_id = b.breeder_id
ORDER BY Breeder;

--================================================================================
--Right Join #1
--Right Join Entry(Optional) to Horse(Manditory)
--We can use the horses inserted for Left Join #2 because they have no entries

--The output shows many empty entry-columns
--on the top rows for the three horses wothout
--any entries.

SELECT * 
FROM proj_entry a 
RIGHT JOIN proj_horses b 
ON a.horse_id = b.horse_id
order by race_id DESC;

--==============================================================================
--Right Join #2
--Right Join Horse(Optional) to Owner(Manditory)
--We canuse the horses inserted for Left Join #2 because they have no owners

--Becuase of the junction table
--involved with owners, this
--query was a little bit more tricky
--to get into human readable form.
--The junction table is right-joined with 
--horses, and then that whole table
--is right joined with the non-junction
--owner table.
SELECT 
b.horse_name AS Horse,
(c.of_name||' '||c.ol_name) AS Owner,
owner_phone AS Phone,
owner_address AS Address
FROM proj_owner_horse a 
RIGHT JOIN proj_horses b 
ON a.horse_id = b.horse_id
LEFT JOIN proj_owner c
ON a.owner_id = c.owner_id
order by b.horse_id;
--==============================================================================
--Full Join #1
--Full Join Breeder(Optional) to Horse(Optional)

--First, insert a new breeder with who has not bred any horses yet
--for illistrative purposes
INSERT 
INTO proj_breeder 
VALUES(NULL, 'Ger', 'Griffin', 087184234, '11 St. Harrys Rd, Limerick');

--Perform a full join
--Notie that there are now empty 
--columns on both the left and right
--side of the join in the output (see PDF)
SELECT *
FROM
proj_breeder a
FULL JOIN
proj_horses b
ON a.breeder_id = b.breeder_id
ORDER BY a.breeder_id DESC;

--==============================================================================
--Full Join #2
--Full Join Breeder(Optional) to Horse(Optional) AND then Full Join all of that with 
--Entries, which a horse may (Optionlly) ot may not have. 
--Note that only the odds column is retrun FROM the entry table.

--First, make an entry for a horse without a breerder
--Then, we also update our entry table, so we can observe differences FROM the full joins
BEGIN
INSERT INTO proj_entry VALUES(5,61,1,NULL,11,NULL,'A poor run');
pkg.update_result(5,44,11,NULL);
END;
/

--Observe that Over Yonder(horse: 61) has a race_id,
--but the other 2 horses without breeders
--do not have any race_id
SELECT 
b.horse_id,
b.horse_name,
a.race_id,
a.odds,
(c.bf_name||' '||c.bl_name) AS Breeder
FROM
proj_entry a
FULL JOIN
proj_horses b
ON a.horse_id = b.horse_id
FULL JOIN
proj_breeder c 
ON c.breeder_id = b.breeder_id
ORDER BY horse_id DESC;

--===============================================================================--

										--CUBE
--===============================================================================--


--This summarizes profits From all races and all race-courses
--in one table. As wellas giving a breakdown of the individual
--races and race courses it gives totals for each too.
--So we cn see how much profit we made from race 1 a Wexford
--as wellas how much we from Wexford in all races.
--This table is thebest way of ensuring that the system
--making a profit for the client who specified this need
--as a Business rule inthe project specification

SELECT 
a.meet_name AS COURSE, 
b.race_id AS RACE_NUM, 
SUM(PROFIT) AS PROFIT
FROM proj_meet a 
JOIN proj_race_details b 
ON a.meet_id = b.meet_id 
JOIN proj_bets c 
ON b.race_id = c.race_id 
GROUP BY cube(a.meet_name, b.race_id) 
ORDER BY meet_name;

--===============================================================================

--SubQuery #1
--Business Question: What horses were bred in Sligo?

--The LIKE operator is used to generalize here.
--Otherwise, a simple query.

SELECT 
horse_name As Horses_Bred_in_Sligo
FROM 
proj_horses
WHERE
breeder_id =
(
	SELECT 
	breeder_id
	FROM 
	proj_breeder
	WHERE
	BREEDER_ADDRESS LIKE '%Sligo%'
);

--===============================================================================

--SubQuery #2
--Business Question: What Trainer trained Star Boy?

--Straight forward query here with a concatenation
--of the trainers first and last name 
--for the output

SELECT 
(tf_name||' '||tl_name) AS Star_Boy_Trainer
FROM
proj_trainer
WHERE 
trainer_id =
(
	SELECT
	trainer_id
	FROM
	proj_horses
	WHERE
	horse_name = 'Star Boy'
);

--==============================================================================

--SubQuery #3
--Business Question: The client has a horse running in a novice
--chase over 10 furlongs, but he can't remember which course
--the race was at. Can you help?

--This query is a real shot in the dark and could return
--answers giving an error.This time we were lucky.
--We could modifyit in lots of ways, using either LIKE
-- > or < on the distance variable.

SELECT 
meet_name AS Course,
meet_date
FROM
proj_meet
WHERE 
Meet_id =
(
	SELECT
	meet_id
	FROM
	proj_race_details
	WHERE
	RACE_TYPE= 'Flat'
	AND
	DISTANCE = 10
);

--==============================================================================
--SubQuery #4

--Business Question: The client needs the contact details of one owner for
--the horse named Duck Luck. Find the information.

--This query was made complex for three reasons:
--1) A horse has many owners

--2) The relationship is many to
--   many between owner and horse giving rise to ajunction table.

--3) Making it human readable, without being all integers

SELECT
(of_name||' '||ol_name) AS Owner,
Owner_Phone As Phone,
Owner_Address AS Address
FROM
proj_owner
WHERE
owner_id =
	(
	SELECT
	MAX(owner_id) As Owner
	FROM
	proj_owner_horse
	WHERE
	horse_id =
		(
		SELECT 
		horse_id
		FROM 
		proj_horses
		WHERE
		horse_id = 
			(
			SELECT
			horse_id
			FROM
			proj_horses
			WHERE
			horse_name = 'Duck Luck'
			)
		)
	);

	--============================================================================
--SubQuery #5
--Business Question: A client has lost his money on a horse AND would like
--to know who the rubbish Jockey was. You only have the race_id
--AND the stall number, but you need to find the Jockey's name.

SELECT
(jf_name||' '||jl_name) AS Jockey
FROM
proj_jockey
WHERE
jockey_id =
	(
	SELECT
	Jockey_id
	FROM
	proj_entry
	WHERE
	race_id = 1
	AND
	stall = 1
	);

	--=======================================================================================================================--

                                                     --	Functions --

--=======================================================================================================================--
--============================================================================
--Function #1
--Business Question: In order to attract customers you need to find a reliable
--metohd of giving good tips to your customers. 
--This function takes in a unique race_id AND returns the name of one horse based
--on the combined number of total wins for each jockey-horse combination in that race.


--View #1 needed for function
CREATE VIEW
tot_j_wins
AS
SELECT
jockey_id AS Jockey, 
COUNT(jockey_id) AS Jockey_Wins
FROM
proj_entry
WHERE
place = 1
GROUP BY jockey_id;

--View #2 needed for function
CREATE VIEW
tot_h_wins
AS
SELECT
horse_id AS Horse, 
COUNT(horse_id) AS Horse_Wins
FROM
proj_entry
WHERE
place = 1
GROUP BY horse_id;


--The Function is long, but with nothng much new
--The NVL function is used so that when a null is added
--with a 2, for eaxmple, the answer is 2 and not null.


--Function #1 for giving tips
CREATE OR REPLACE FUNCTION tips(race_id_Arg NUMBER)
RETURN NVARCHAR2
IS 
tip NVARCHAR2(50);
num_races NUMBER(10);
NO_RACE_EXISTS EXCEPTION;
PRAGMA EXCEPTION_INIT(NO_RACE_EXISTS,-20020);
BEGIN

--SELECT into block
SELECT 
(
	SELECT
	COUNT(race_id) 
	FROM
	results
	WHERE
	race_id = race_id_Arg
)
INTO
num_races
FROM DUAL;

--Check for exceptions
IF (num_races = 0)
THEN RAISE NO_RACE_EXISTS;
END IF;

--Long SELECT INTO BLOCK
SELECT
(
	SELECT
	horse_name
	FROM
	proj_horses
	WHERE
	horse_id =
	(
		SELECT
		max(horse_id)
		FROM
		proj_entry a
		FULL JOIN
		tot_h_wins b
		ON 
			a.horse_id = b.horse
		FULL JOIN
		tot_j_wins c
		ON
		a.jockey_id = c.jockey
		WHERE 
		race_id = race_id_Arg
		AND
		NVL(horse_wins, 0) + NVL(jockey_wins, 0) =
			(
			SELECT
			MAX(NVL(horse_wins, 0) + NVL(jockey_wins, 0))
			FROM
			proj_entry a
			FULL JOIN
			tot_h_wins b
			ON 
			a.horse_id = b.horse
			FULL JOIN
			tot_j_wins c
			ON
			a.jockey_id = c.jockey
			WHERE 
			race_id = race_id_Arg
			)
		)
	)
INTO
tip FROM DUAL;
RETURN tip;
EXCEPTION
	WHEN NO_RACE_EXISTS
	THEN RAISE_APPLICATION_ERROR(-20020, 'No race exits with this id');
DBMS_OUTPUT.PUT_LINE(tip);
END tips;
/

--============================================================================
--Function #2
--Business Question: What stall has the most wins for a given course?

--Again, the function is long, but with nothing new. Its made of SELECT INTO BLOCKS
--of varying sizes, and one exception check-point.

CREATE OR REPLACE FUNCTION bestStall(Course_Arg NVARCHAR2)
RETURN NVARCHAR2
IS 
num_of_stalls NUMBER(10);
varBestStall NVARCHAR2(50);
NO_BEST_STALL EXCEPTION;
PRAGMA EXCEPTION_INIT(NO_BEST_STALL,-20040);
BEGIN
SELECT
(
	SELECT
	COUNT(*)
	FROM
	(
		SELECT 
		stall, 
		count(course) 
		AS Stall_Wins 
		FROM results 
		WHERE place = 1 
		AND course = Course_Arg
		GROUP BY stall
	)
	WHERE
	STALL_WINS =
	(
	SELECT
	MAX(STALL_WINS) AS a
	FROM
		(
		SELECT 
		stall, 
		count(course) 
		AS Stall_Wins 
		FROM results 
		WHERE place = 1 
		AND course = Course_Arg
		GROUP BY stall
		)
	)
)
INTO
num_of_stalls
FROM DUAL;
--Check for multiple favourite stalls, hence throw exception
IF num_of_stalls > 1
THEN RAISE NO_BEST_STALL;
END IF;

SELECT
	(
	SELECT stall 
	FROM 
		(
		SELECT course, stall, count(course) AS Stall_Wins FROM results WHERE place = 1 AND course = Course_Arg GROUP BY course, stall
		)
    WHERE
    Course = Course_Arg
    AND
	Stall_Wins =
		(
		SELECT max(count(course)) AS Stall_Wins FROM results WHERE place = 1 AND course = Course_Arg GROUP BY course, stall
		)
	)
INTO varBestStall
FROM DUAL; 
DBMS_OUTPUT.PUT_LINE('The top stall number is: '|| varBestStall);
RETURN varBestStall;
EXCEPTION
	WHEN NO_BEST_STALL
	THEN RAISE_APPLICATION_ERROR(-20040,'No stall can be favoured fro this current race');
END bestStall;
/

--=======================================================================================================================--

                                                     --	Triggers--

--=======================================================================================================================--

--=============================================================================

--Both of the following triggers makeuse of the
--view here:

CREATE OR REPLACE FORCE VIEW  "ENTRY_MASTER" ("HORSE_ID", "JOCKEY_ID", "RACE_ID", "COURSE", "TIME", "JOCKEY", "ODDS", "PLACE", "NOTE", "TYPE", "FURLONGS", "Prize Money", "GROUND", "STALL") AS
  SELECT DISTINCT
C.horse_id,
f.jockey_id,
a.race_id,
b.meet_name AS Course,
a.race_time AS Time,
(f.jf_name||' '||f.jl_name) AS Jockey,
c.odds,
c.place,
c.note AS Note,
a.race_type AS Type,
a.distance AS Furlongs,
a.prize_money AS "Prize Money",
a.ground AS Ground,
c.stall AS Stall
FROM proj_race_details a
JOIN proj_meet b ON a.meet_id = b.meet_id
JOIN proj_entry c ON c.race_id = a.race_id
JOIN proj_jockey f ON f.jockey_id = c.jockey_id
ORDER BY Race_id;

--Using a view allows for much more readbale code.


--Trigger 1

--This trigger ensures that no horse
--canbebooked for any two races on a single day
--in any 2 locations.

CREATE OR REPLACE TRIGGER horse_double_booking
BEFORE INSERT 
ON proj_entry
FOR EACH ROW
DECLARE
DOUBLE_BOOKING EXCEPTION;
PRAGMA EXCEPTION_INIT(DOUBLE_BOOKING, -20025);
timeTemp DATE;
Number_Of_Bookings NUMBER;
BEGIN
SELECT 
(
	SELECT 
	DISTINCT
	time
	FROM entry_master
	WHERE 
	race_id = :NEW.race_id
)
INTO 
timeTemp 
FROM DUAL;
SELECT
(
	SELECT
	COUNT(horse_id)
	FROM
	entry_master
	WHERE horse_id = :NEW.horse_id
	AND
	TRUNC(time) = TRUNC(timeTemp)
)
INTO
Number_Of_Bookings 
FROM DUAL;

IF Number_Of_Bookings > 0
	THEN DBMS_OUTPUT.PUT_LINE('Horse with ID: '||:NEW.horse_id||' is already racing somewhere on this date :'||timeTemp);
	RAISE DOUBLE_BOOKING;
END IF;
EXCEPTION
	WHEN DOUBLE_BOOKING
	THEN RAISE_APPLICATION_ERROR(-20025,'ERROR: Horse already racing this day');
END;
/


--=============================================================================

--Trigger 2

CREATE OR REPLACE TRIGGER jockey_double_booking
BEFORE INSERT 
ON proj_entry
FOR EACH ROW
DECLARE
JOCKEY_DOUBLE_BOOKING EXCEPTION;
PRAGMA EXCEPTION_INIT(JOCKEY_DOUBLE_BOOKING, -20011);
timeTemp DATE;
Number_Of_Bookings NUMBER;
courseTemp NVARCHAR2(100);
BEGIN
SELECT
(
	SELECT
	DISTINCT
	COURSE 
	FROM
	entry_master
	WHERE
	race_id = :NEW.race_id
)
INTO
courseTemp
FROM DUAL;

SELECT 
(
	SELECT 
	DISTINCT
	time
	FROM entry_master
	WHERE 
	race_id = :NEW.race_id
)
INTO 
timeTemp 
FROM DUAL;
SELECT
(
	SELECT
	COUNT(jockey_id)
	FROM
	entry_master
	WHERE jockey_id = :NEW.jockey_id
	AND
	TRUNC(time) = TRUNC(timeTemp)
	AND
	Course <> courseTemp
)
INTO
Number_Of_Bookings 
FROM DUAL;

IF Number_Of_Bookings > 0
	THEN DBMS_OUTPUT.PUT_LINE('Horse with ID: '||:NEW.jockey_id||' is already racing at another track on this day:'||timeTemp);
	RAISE JOCKEY_DOUBLE_BOOKING;
END IF;
EXCEPTION
	WHEN JOCKEY_DOUBLE_BOOKING
	THEN RAISE_APPLICATION_ERROR(-20011,'ERROR: Jockey already racing at this time of day'||Number_Of_Bookings);
END;
/

--===============================================================================

--After Trigger

--========================================================================
--After Trigger
--Business Question: The bookmaker needs information to manage his risk and 
--balance his books.After every update of the odds, let the bookie know if any 
--horses are coming in at low odds.

CREATE OR REPLACE TRIGGER suspicious_odds
AFTER UPDATE
OF odds
ON proj_entry
FOR EACH ROW
DECLARE
SUSPICIOUS_ODDS EXCEPTION;
PRAGMA EXCEPTION_INIT(SUSPICIOUS_ODDS,-20012);
BEGIN
IF :NEW.odds < (:OLD.odds / 3)
THEN
RAISE SUSPICIOUS_ODDS;
END IF;
EXCEPTION
	WHEN SUSPICIOUS_ODDS
	THEN 
	IF :OLD.odds/:New.odds > 1
		THEN
		DBMS_OUTPUT.PUT_LINE('WANRNING: Suspicious Market Behaviour!');
		DBMS_OUTPUT.PUT_LINE('Horse number: '||:NEW.horse_id||' in race '|| :NEW.race_id||'.');
		DBMS_OUTPUT.PUT_LINE('Odds shortened by factor of: '|| :OLD.odds/:New.odds);
	END IF;
END;
/


--===================================================================

