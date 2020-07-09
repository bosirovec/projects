-00--
--prikazi tablica Driver i Vehicle--
SELECT *
FROM driver;
SELECT *
FROM Vehicle;



--1--
--Sve Bornine vožnje 15.8. sortirane po cijeni 
SELECT d.name AS "Ime vozača", d.surname AS "Prezime", sc.month AS "Mjesec", sh.day as "Dan", st.length as "Trajanje smjene (h)", r.ride_id AS "ID Vožnje",
                  r.passenger_number AS "Broj Putnika",r.pickup_point AS "Početna točka", r.destination_point AS "Odredište", r.phone_number as "Telefon klijenta",
                  r.price AS "Cijena Vožnje" , v.vehicle_id AS "ID vozila", v.brand as "Marka vozila", v.model as "Model vozila"
FROM driver d INNER JOIN schedule sc USING(driver_id)
     INNER JOIN shift sh USING(schedule_id)
     INNER JOIN ride r USING(shift_id), vehicle v, shift_type st
WHERE d.name='Borna' and sc.month=8 and sh.day=15 and r.vehicle_id=v.vehicle_id and sh.type= st.type
ORDER BY r.price DESC;

--2--
--Tko je sve radio 26.7 u kojem autu i koliko je voznji imao?
Select DISTINCT d.name as "Ime vozača", d.surname as "Prezime vozača", st.start_time as "Vrijeme početka(h)", v.vehicle_id as "ID vozila", COUNT(r.ride_id) as "Broj Vožnji"
FROM driver d INNER JOIN schedule sc USING(driver_id)
     INNER JOIN shift sh USING(schedule_id)
     INNER JOIN ride r USING(shift_id), vehicle v, shift_type st
WHERE sc.month=7 and sh.day=26 and r.vehicle_id = v.vehicle_id and sh.type = st.type
GROUP BY d.name, d.surname, st.start_time, v.vehicle_id 
ORDER BY st.start_time, v.vehicle_id;

--3--
--Prosjecni trosak goriva--
SELECT AVG(cost) as "Prosječna cijena goriva"
FROM expenses
WHERE info='gorivo';


--4--
--Ime vozača s najvećom zaradom--
SELECT podupit.name "Ime Vozača", podupit.surname "Prezime vozača", SUM(podupit.price) "Ukupna zarada"
FROM (SELECT d.name, d.surname, r.price
      FROM driver d INNER JOIN schedule sc USING(driver_id)
           INNER JOIN shift sh USING(schedule_id)
           INNER JOIN ride r USING(shift_id)   
      ORDER BY d.name) podupit
GROUP BY podupit.name, podupit.surname
HAVING SUM(podupit.price) IN (SELECT MAX(SUM(podupit.price))
                              FROM (SELECT d.name, d.surname, r.price
                                    FROM driver d INNER JOIN schedule sc USING(driver_id)
                                    INNER JOIN shift sh USING(schedule_id)
                                    INNER JOIN ride r USING(shift_id)   
                                    ORDER BY d.name) podupit
                                    GROUP BY podupit.name, podupit.surname);

--5--
--Kolika je placa vozaca s IDem 2 za 9.mj?
SELECT SUM(st.length*d.money_per_hour) "Iznos plaće u kunama"
FROM driver d, schedule sc, shift sh, shift_type st
WHERE d.driver_id = sc.driver_id and sh.schedule_id = sc.schedule_id and st.type = sh.type and d.driver_id='2' and sc.month=9;


--Procedura za mijenjanje satnice nekom vozaču--
CREATE PROCEDURE update_mph (in_driver_id IN driver.driver_id%TYPE, novi_mph IN INTEGER) 
as driver_counter INTEGER;
BEGIN
    Select COUNT(*)
    INTO driver_counter
    FROM driver
    WHERE driver_id = in_driver_id;
    IF driver_counter = 1 THEN
        UPDATE driver
        SET money_per_hour = novi_mph*1
        Where driver_id = in_driver_id;
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END update_mph;
--CALL update_mph(1,28)



--Procedura za unos novih vozila u bazu podataka--
CREATE PROCEDURE insert_vehicle (invehicle_id IN vehicle.vehicle_id%TYPE, inbrand IN vehicle.brand%TYPE, inmodel IN vehicle.model%TYPE , inyear IN vehicle.year%TYPE, infuel_type IN vehicle.fuel_type%TYPE, inseats IN vehicle.seats%TYPE, inkilometers IN vehicle.kilometers%TYPE)
AS
BEGIN
    INSERT INTO vehicle(vehicle_id,brand,model,year,fuel_type,seats,kilometers)
    VALUES(invehicle_id, inbrand, inmodel, inyear, infuel_type, inseats, inkilometers);
END insert_vehicle;
--CALL insert_vehicle('5','Opel','Astra',2020,'LPG',5,10000);




CREATE INDEX i_ride_phones ON ride(phone_number);
CREATE INDEX i_expenses_infos ON expenses(info);

CREATE OR REPLACE TRIGGER change_of_mph
BEFORE UPDATE OF money_per_hour ON driver
FOR EACH ROW WHEN
(new.money_per_hour <> old.money_per_hour)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Promjenila se satnica vozaču');
End change_of_mph;

CREATE OR REPLACE TRIGGER status_change
BEFORE UPDATE OF status ON ride
FOR EACH ROW WHEN
(new.status <> old.status)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Promjenio se status vožnje');
End status_change;


CREATE OR REPLACE TRIGGER ride_trigger
AFTER UPDATE ON ride
BEGIN
    DBMS_OUTPUT.PUT_LINE('Napravio si update u tablici RIDE');
End ride_trigger;