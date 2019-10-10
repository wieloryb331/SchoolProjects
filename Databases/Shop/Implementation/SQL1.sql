USE master;
DROP DATABASE IF EXISTS E_bilet;
GO

CREATE DATABASE E_bilet;
GO

USE E_bilet;
GO
sp_who
kill 52

------------ USUÑ TABELE/WIDOKI/FUNKCJE/PROCEDURY ------------

DROP TABLE IF EXISTS Imprezy;
DROP TABLE IF EXISTS Obiekty;
DROP TABLE IF EXISTS Podmioty;
DROP TABLE IF EXISTS Artysci;
DROP TABLE IF EXISTS Wystepy;
DROP TABLE IF EXISTS Przynaleznosc;
DROP TABLE IF EXISTS Bilety;

DROP VIEW IF EXISTS ImprezyZakonczone;
DROP VIEW IF EXISTS HarmonogramOpener2019;
DROP VIEW IF EXISTS PodmiotyWiecejNizRaz;

DROP FUNCTION IF EXISTS ImprezyWDanymRoku;
DROP FUNCTION IF EXISTS IloscNiesprzedanychBiletowByID;

DROP PROCEDURE IF EXISTS DodajImpreze;
DROP PROCEDURE IF EXISTS DodajPuleBiletow;
DROP PROCEDURE IF EXISTS KupBilety;
DROP PROCEDURE IF EXISTS UsunArtyste;

DROP TRIGGER IF EXISTS UsunArtyste_tr;
DROP TRIGGER IF EXISTS DodajArtyste_tr;
DROP TRIGGER IF EXISTS DodajImpreze_tr;
DROP TRIGGER IF EXISTS ZmienImpreze_tr;


------------ CREATE - UTWÓRZ TABELE I POWI¥ZANIA ------------

CREATE TABLE Obiekty
(
    nazwa    VARCHAR(20) NOT NULL PRIMARY KEY,
    kraj	 VARCHAR(20) NOT NULL,
	miasto   VARCHAR(20) NOT NULL, 
    max_l_osob INTEGER NOT NULL
);

CREATE TABLE Imprezy
(
    ID_imprezy INTEGER IDENTITY(1,1) PRIMARY KEY,
    nazwa      Varchar(50) NOT NULL,
    status     VARCHAR(20) NOT NULL,
	data_pocz DATETIME NOT NULL,
	data_konc DATETIME NOT NULL,
	typ		  VARCHAR(10) NOT NULL ,
	obiekt_nazwa VARCHAR(20) NOT NULL REFERENCES Obiekty(nazwa),
	CONSTRAINT imprezy_status CHECK (status IN ('planowana','zakonczona','wyprzedana')),
    CONSTRAINT imprezy_data_k CHECK (data_konc > data_pocz),
    CONSTRAINT imprezy_typ CHECK (typ in('festiwal','koncert'))
);

CREATE TABLE Podmioty
(
    nazwa    VARCHAR(20) NOT NULL PRIMARY KEY,
    gatunek  VARCHAR(20),
    kraj_pochodzenia VARCHAR(20),
	typ VARCHAR(10) not null CONSTRAINT podmioty_typ CHECK(typ in('sztuczny','zespol'))
);

CREATE TABLE Artysci
(
    ID_artysty INT IDENTITY(1,1) PRIMARY KEY,
    imie VARCHAR(20) NOT NULL,
	nazwisko VARCHAR(20) NOT NULL
);

CREATE TABLE Wystepy
(
    ID_imprezy INTEGER NOT NULL,
	nazwa_podmiotu VARCHAR(20),
	data_rozp DATETIME NOT NULL,
	data_zak DATETIME NOT NULL,
    FOREIGN KEY(ID_imprezy) REFERENCES Imprezy(ID_imprezy),
	FOREIGN KEY(nazwa_podmiotu) REFERENCES Podmioty(nazwa),
    CONSTRAINT wystepy_godz_z CHECK (data_zak>data_rozp)
);

CREATE TABLE Przynaleznosc
(
    ID_artysty INTEGER NOT NULL,
	nazwa_podmiotu VARCHAR(20),
	spiew BIT NOT NULL,
	instrument VARCHAR(20),
    FOREIGN KEY(ID_artysty) REFERENCES Artysci(ID_artysty),
	FOREIGN KEY(nazwa_podmiotu) REFERENCES Podmioty(nazwa)
);

CREATE TABLE Bilety
(
    ID_imprezy INTEGER NOT NULL,
	numer INTEGER IDENTITY(1,1),
	miejsce  INTEGER NULL, --stojace to null
	cena MONEY, --null jak impreza otwarta
	kategoria VARCHAR(10) NOT NULL CONSTRAINT bilety_kat check(kategoria in('vip','normalny')),
	status VARCHAR(10) NOT NULL CONSTRAINT bilety_stat check(status in('sprzedany','wolny')),
	data_pocz DATETIME NOT NULL,
	data_konc DATETIME NOT NULL,
	PRIMARY KEY(ID_imprezy,numer),
	FOREIGN KEY(ID_imprezy) REFERENCES Imprezy(ID_imprezy),
    CONSTRAINT bilety_data_k CHECK (data_konc>data_pocz)
);

GO



------------ INSERT - WSTAW DANE ------------

INSERT INTO Obiekty VALUES ('Lotnisko Gdynia', 'Polska', 'Gdynia', 13354)
INSERT INTO Obiekty VALUES ('Atlas Arena', 'Polska', 'Lodz', 1337)
INSERT INTO Obiekty VALUES ('Arena Poznan', 'Polska', 'Poznan', 5200)
INSERT INTO Obiekty VALUES ('Stadion Narodowy', 'Polska', 'Warszawa', 45000)
INSERT INTO Obiekty VALUES ('Pustynia', 'USA', 'Black Rock City', 100000)

INSERT INTO Imprezy VALUES
('Opener','zakonczona', '2018-06-30 12:30:00', '2018-07-04 12:30:00','festiwal','Lotnisko Gdynia'),
('Opener','planowana', '2019-06-30 12:30:00', '2019-07-04 12:30:00','festiwal','Lotnisko Gdynia'),
('Eminem w Warszawie','wyprzedana', '2019-08-30 12:30:00', '2019-08-30 15:30:00','koncert','Stadion Narodowy'),
('Burning Man','planowana', '2020-03-15 12:30:00', '2020-03-20 12:30:00','festiwal','Pustynia'),
('Dawid Podsiadlo solo','wyprzedana', '2019-09-10 15:30:00', '2019-09-10 17:30:00','koncert','Arena Poznan')

INSERT INTO Podmioty VALUES 
('Eminem', 'rap', 'USA', 'sztuczny'),
('The Dumplings', 'alternatywa', 'Polska','zespol'),
('The Offspring', 'punkrock', 'USA','zespol'),
('Schafter', 'rap', 'Polska','sztuczny'),
('Dawid Podsiadlo', 'pop', 'Polska','sztuczny'),
('Blink 182', 'rock', 'USA','zespol')

INSERT INTO Artysci VALUES
('Marshall', 'Bruce'),
('Jan', 'Kowalski'),
('Agata', 'Nowak'),
('Bryan', 'Holland'),
('Gregory', 'Kriesel'),
('Kevin', 'Wasserman'),
('Pete', 'Parada'),
('Wojtek', 'Schafter'),
('Dawid', 'Podsiadlo'),
('Mark', 'Hoppus'),
('Travis', 'Barker'),
('Matt', 'Skiba')

INSERT INTO Wystepy VALUES
(1, 'Eminem', '2018-06-30 12:30:00', '2018-06-30 13:30:00' ),
(2, 'Eminem', '2019-06-30 12:30:00', '2019-06-30 14:00:00' ),
(3, 'Eminem', '2019-08-30 12:30:00', '2019-08-30 15:30:00' ),
(2, 'The Offspring', '2019-07-01 18:30:00', '2019-07-01 20:00:00' ),
(2, 'Dawid Podsiadlo', '2019-07-02 10:30:00', '2019-07-02 11:45:00' ),
(5, 'Dawid Podsiadlo', '2019-09-10 15:30:00', '2019-09-10 17:30:00' ),
(2, 'Schafter', '2019-07-03 14:30:00', '2019-07-03 16:30:00' )

INSERT INTO Przynaleznosc VALUES
(1,'Eminem',1, NULL),
(9, 'Dawid Podsiadlo',1,'gitara'),
(8, 'Schafter',1,'bitmaker'),
(3, 'The Dumplings',1,'keyboard'),
(2, 'The Dumplings',1,'gitara')

INSERT INTO Bilety VALUES
(2,1,450,'VIP','sprzedany', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,2,450,'VIP','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,3,450,'VIP','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','sprzedany', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(2,NULL,350,'normalny','wolny', '2018-06-30 12:30:00', '2018-07-04 12:30:00'),
(5,1,250,'normalny','sprzedany', '2019-09-10 15:30:00', '2019-09-10 17:30:00'),
(5,2,250,'normalny','wolny', '2019-09-10 15:30:00', '2019-09-10 17:30:00'),
(5,3,280,'VIP','wolny', '2019-09-10 15:30:00', '2019-09-10 17:30:00'),
(5,4,180,'normalny','sprzedany', '2019-09-10 15:30:00', '2019-09-10 17:30:00'),
(5,5,180,'normalny','wolny', '2019-09-10 15:30:00', '2019-09-10 17:30:00')

------------ VIEWS ------------
Go
CREATE VIEW ImprezyZakonczone(ID_imprezy, nazwa, data_konc , obiekt_nazwa, kraj)
AS
(
    SELECT ID_imprezy, Imprezy.nazwa, data_konc, obiekt_nazwa, kraj
    FROM Imprezy 
    INNER JOIN Obiekty ON Imprezy.obiekt_nazwa=Obiekty.nazwa
    WHERE Imprezy.status = 'zakonczona'
);
GO

CREATE VIEW HarmonogramOpener2019(nazwa_podmiotu, data_rozp, data_zak)
AS
(
    SELECT TOP 100percent nazwa_podmiotu, data_rozp, data_zak FROM Wystepy
    WHERE Wystepy.ID_imprezy=(SELECT ID_imprezy FROM Imprezy WHERE nazwa='Opener' AND YEAR(data_pocz) = 2019)
    ORDER BY Wystepy.data_rozp ASC
);
GO

CREATE VIEW PodmiotyWiecejNizRaz(nazwa_podmiotu, ilosc_wystapien)
AS
(
    SELECT DISTINCT nazwa_podmiotu,COUNT(nazwa_podmiotu) 'ilosc_wystapien' FROM Wystepy WHERE nazwa_podmiotu in (SELECT nazwa_podmiotu FROM Wystepy
    GROUP BY nazwa_podmiotu
    HAVING COUNT(*) > 1)
    GROUP BY nazwa_podmiotu
);
GO

------------ FUNCTIONS ------------

CREATE FUNCTION ImprezyWDanymRoku
(
    @input INT
)
    RETURNS TABLE
AS
    RETURN SELECT nazwa FROM Imprezy
    WHERE YEAR(Imprezy.data_pocz) = @input;
GO

CREATE FUNCTION IloscNiesprzedanychBiletowByID
(
    @id  INT
)
    RETURNS INT
AS
BEGIN
    RETURN (select count(Bilety.numer) from Bilety where Bilety.ID_imprezy=@id and Bilety.status='wolny');
END;
GO

------------ PROCEDURES ------------

CREATE OR ALTER PROCEDURE DodajImpreze
    @nazwa VARCHAR(50),
    @status VARCHAR(20),
    @data_pocz DATETIME,
    @data_konc DATETIME,
    @typ VARCHAR(10),
    @obiekt_nazwa VARCHAR(20)
AS
BEGIN TRY
    INSERT INTO Imprezy VALUES (@nazwa, @status, @data_pocz, @data_konc, @typ, @obiekt_nazwa)
END TRY
BEGIN CATCH 
           SELECT ERROR_NUMBER()  AS 'NUMER BLEDU',
           ERROR_MESSAGE() AS 'KOMUNIKAT';
END CATCH;
GO


CREATE OR ALTER PROCEDURE DodajPuleBiletow
    @ID_imprezy INT,
    @iloscBiletowVIP INT,
    @iloscBiletowSiedziacych INT,
    @iloscBiletowStojacych INT,
    @cenaBiletuVIP INT,
    @cenaBiletuSiedzacego INT,
    @cenaBiletuStojacego INT,
    @data_pocz DATETIME,
    @data_konc DATETIME
AS  
BEGIN
    DECLARE @i  INT = 0
    WHILE @iloscBiletowVIP > 0
    BEGIN TRY
        INSERT INTO Bilety VALUES (@ID_imprezy, @i, @cenaBiletuVIP, 'VIP', 'wolny', @data_pocz,@data_konc)
        SET @i = @i+1
        SET @iloscBiletowVIP = @iloscBiletowVIP - 1
    END TRY
    BEGIN CATCH 
           SELECT ERROR_NUMBER()  AS 'NUMER BLEDU',
           ERROR_MESSAGE() AS 'KOMUNIKAT';
    END CATCH;
    WHILE @iloscBiletowSiedziacych > 0
    BEGIN TRY
        INSERT INTO Bilety VALUES (@ID_imprezy, @i, @cenaBiletuSiedzacego, 'normalny', 'wolny', @data_pocz,@data_konc)
        SET @i = @i+1
        SET @iloscBiletowSiedziacych = @iloscBiletowSiedziacych - 1
    END TRY
    BEGIN CATCH 
           SELECT ERROR_NUMBER()  AS 'NUMER BLEDU',
           ERROR_MESSAGE() AS 'KOMUNIKAT';
    END CATCH;
    WHILE @iloscBiletowStojacych > 0 
    BEGIN TRY
        INSERT INTO Bilety VALUES (@ID_imprezy, NULL, @cenaBiletuStojacego, 'normalny', 'wolny', @data_pocz,@data_konc)
        SET @iloscBiletowStojacych = @iloscBiletowStojacych - 1
    END TRY
    BEGIN CATCH 
           SELECT ERROR_NUMBER()  AS 'NUMER BLEDU',
           ERROR_MESSAGE() AS 'KOMUNIKAT';
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE KupBilety
    @ID_imprezy INT,
    @iloscBiletowVIP INT,
    @iloscBiletowStojacych INT,
    @iloscBiletowSiedzacych INT
AS
BEGIN
    DECLARE @a INT
    DECLARE @b INT
    DECLARE @c INT
    DECLARE @iloscDostepnychVIP INT = (SELECT COUNT(*) FROM Bilety WHERE Bilety.ID_imprezy=@ID_imprezy AND status = 'wolny' AND kategoria='VIP')
    DECLARE @iloscDostepnychStoj INT = (SELECT COUNT(*) FROM Bilety WHERE Bilety.ID_imprezy=@ID_imprezy AND status = 'wolny' AND kategoria='normalny' AND miejsce IS NULL) 
    DECLARE @iloscDostepnychSiedz INT = (SELECT COUNT(*) FROM Bilety WHERE Bilety.ID_imprezy=@ID_imprezy AND status = 'wolny' AND kategoria='normalny' AND miejsce IS NOT NULL)
    DECLARE @i INT = 1
    WHILE @i>0
    BEGIN
    IF @iloscBiletowSiedzacych+@iloscBiletowStojacych+@iloscBiletowVIP > 10
    BEGIN
        PRINT 'CHCESZ KUPIC ZA DUZO BILETOW, MAKSYMALNIE 10 NARAZ'
        BREAK
    END
    ELSE
        IF @iloscDostepnychVIP<@iloscBiletowVIP
        BEGIN
        PRINT 'BLAD, CHCIALES KUPIC ZA DUZO BILETOW VIP'
        BREAK
        END
        ELSE
            IF @iloscDostepnychStoj<@iloscBiletowStojacych
            BEGIN
            PRINT 'BLAD, CHCIALES KUPIC ZA DUZO BILETOW STOJACYCH'
            BREAK
            END
            ELSE
                IF @iloscDostepnychSiedz<@iloscBiletowSiedzacych
                BEGIN
                PRINT 'BLAD, CHCIALES KUPIC ZA DUZO BILETOW SIEDZACYCH'
                BREAK
                END
                ELSE
                    WHILE @iloscBiletowSiedzacych>0
                    BEGIN TRY
                    SET @a = (SELECT TOP 1 numer FROM Bilety WHERE status='wolny' AND kategoria='normalny' AND miejsce IS NOT NULL AND ID_imprezy = @ID_imprezy)
                        UPDATE Bilety
                        SET status = 'sprzedany'
                        WHERE numer = @a
                        SET @iloscBiletowSiedzacych = @iloscBiletowSiedzacych - 1
                    END TRY
                    BEGIN CATCH 
                    SELECT ERROR_NUMBER()  AS 'NUMER BLEDU', ERROR_MESSAGE() AS 'KOMUNIKAT';
                    END CATCH

                    WHILE @iloscBiletowStojacych>0
                    BEGIN TRY
                    SET @b = (SELECT TOP 1 numer FROM Bilety WHERE status='wolny' AND kategoria='normalny' AND miejsce IS NULL AND ID_imprezy = @ID_imprezy)
                        UPDATE Bilety
                        SET status = 'sprzedany'
                        WHERE numer = @b
                        SET @iloscBiletowStojacych = @iloscBiletowStojacych - 1
                    END TRY
                    BEGIN CATCH 
                    SELECT ERROR_NUMBER()  AS 'NUMER BLEDU', ERROR_MESSAGE() AS 'KOMUNIKAT';
                    END CATCH

                    WHILE @iloscBiletowVIP>0
                    BEGIN TRY
                    SET @c = (SELECT TOP 1 numer FROM Bilety WHERE status='wolny' AND kategoria='VIP' AND ID_imprezy = @ID_imprezy)
                        UPDATE Bilety
                        SET status = 'sprzedany'
                        WHERE numer = @c
                        SET @iloscBiletowVIP = @iloscBiletowVIP - 1
                    END TRY
                    BEGIN CATCH 
                    SELECT ERROR_NUMBER()  AS 'NUMER BLEDU', ERROR_MESSAGE() AS 'KOMUNIKAT';
                    END CATCH
                BREAK
                END
                END
            
GO
CREATE PROCEDURE UsunArtyste
@ID_artysty INT
AS
BEGIN
DELETE FROM Przynaleznosc WHERE ID_artysty=@ID_artysty
DELETE FROM Artysci WHERE ID_artysty=@ID_artysty
END
GO

------------ TRIGGERS ------------
CREATE TRIGGER UsunArtyste_tr
ON Artysci
INSTEAD OF DELETE
AS
	DELETE FROM	Przynaleznosc WHERE ID_artysty=(select ID_artysty from deleted)
	DELETE FROM	Artysci WHERE ID_artysty=(select ID_artysty from deleted)
    SELECT TOP 1 USER_NAME() 'Usunal artyste',ID_artysty 'ID usunietego', imie 'imie usunietego', nazwisko 'nazwisko usunietego' FROM deleted
GO

CREATE TRIGGER UsunImpreze_tr
ON Imprezy
INSTEAD OF DELETE
AS
    PRINT 'NIE MOZNA USUWAC IMPREZ'
GO

CREATE TRIGGER DodajImpreze_tr
ON Imprezy
AFTER INSERT
AS
    PRINT 'DODANO IMPREZE'
	SELECT * FROM inserted    
GO

CREATE TRIGGER ZmienImpreze_tr
ON Imprezy
INSTEAD OF UPDATE
AS
    DECLARE @a VARCHAR(20)
    SET @a = (SELECT TOP 1 status FROM deleted)
    IF @a = 'zakonczona'
    BEGIN
    PRINT 'NIE MOZNA ZMIENIAC ZAKONCZONYCH IMPREZ'
    END
	else 
	begin
		if (select top 1 ID_imprezy from inserted) != (select top 1 ID_imprezy from deleted)
		begin
		print('NIE MOZNA ZMIENIC ID IMPREZY')
		end
		else
			begin
				if(select top 1 nazwa from inserted)!=(select top 1 nazwa from deleted)
				begin
				UPDATE Imprezy
				set nazwa=(SELECT TOP 1 nazwa from inserted)
				where ID_imprezy=(select top 1 ID_imprezy from deleted)
				end
				else
				begin
					if(select top 1 data_pocz from inserted) != (select top 1 data_pocz from deleted)
					begin
						UPDATE Imprezy
						set data_pocz=(SELECT TOP 1 data_pocz from inserted)
						where ID_imprezy=(select top 1 ID_imprezy from deleted)
					end
					else
					begin
					if(select top 1 data_konc from inserted) != (select top 1 data_konc from deleted)
					begin
						UPDATE Imprezy
						set data_konc=(SELECT TOP 1 data_konc from inserted)
						where ID_imprezy=(select top 1 ID_imprezy from deleted)
					end
					else
					begin
					if(select top 1 typ from inserted) != (select top 1 typ from deleted)
					begin
						UPDATE Imprezy
						set typ=(SELECT TOP 1 typ from inserted)
						where ID_imprezy=(select top 1 ID_imprezy from deleted)
					end
					else
					begin 
					if(select top 1 obiekt_nazwa from inserted) != (select top 1 obiekt_nazwa from deleted)
					begin
						UPDATE Imprezy
						set obiekt_nazwa=(SELECT TOP 1 obiekt_nazwa from inserted)
						where ID_imprezy=(select top 1 ID_imprezy from deleted)
					end
					else
					begin
					if(select top 1 status from inserted) != (select top 1 status from deleted)
					begin
						UPDATE Imprezy
						set status=(SELECT TOP 1 status from inserted)
						where ID_imprezy=(select top 1 ID_imprezy from deleted)
					end
					end
					end
					end
					end  
				end
			end
		UPDATE Imprezy
		set status=(select top 1 status from inserted)
		where ID_imprezy=(select top 1 ID_imprezy from deleted)
	end
GO

