USE E_bilet;
GO

------------ SELECT ------------
SELECT * FROM Imprezy;
SELECT * FROM Obiekty;
SELECT * FROM Podmioty;
SELECT * FROM Artysci;
SELECT * FROM Wystepy;
SELECT * FROM Przynaleznosc;
SELECT * FROM Bilety;
GO
------------ VIEWS ------------
SELECT * FROM ImprezyZakonczone
GO
SELECT * FROM HarmonogramOpener2019
GO
SELECT * FROM PodmiotyWiecejNizRaz
GO
------------ FUNCTIONS ------------
SELECT * FROM ImprezyWDanymRoku(2020)
GO
SELECT * FROM ImprezyWDanymRoku(2019)
GO
SELECT dbo.IloscNiesprzedanychBiletowByID(2) 'ilosc'
GO
SELECT dbo.IloscNiesprzedanychBiletowByID(1) 'ilosc'
GO
------------ PROCEDURES ------------
--
EXECUTE DodajImpreze 'Orange Lodz Festiwal', 'planowana', '2019-05-30 19:30:00', '2019-06-03 12:10:00', 'festiwal', 'Atlas Arena'
SELECT ID_imprezy,nazwa FROM Imprezy
GO
--
EXECUTE DodajPuleBiletow 6, 15, 10, 5, 150, 100, 50, '2019-05-30 19:30:00', '2019-06-03 12:10:00'
SELECT dbo.IloscNiesprzedanychBiletowByID(6) 'ilosc'
GO
--
EXECUTE KupBilety 6, 3, 3,3
GO
SELECT * FROM Bilety WHERE ID_imprezy = 6
GO
--
EXECUTE UsunArtyste 2
SELECT * FROM Artysci
GO
--
------------ TRIGGERS ------------
--
SELECT * FROM Artysci
DELETE FROM Artysci WHERE ID_artysty=1
SELECT * FROM Artysci
GO
--
SELECT * FROM Imprezy
DELETE FROM Imprezy WHERE ID_imprezy=1
SELECT * FROM Imprezy
GO
--
INSERT INTO Imprezy VALUES('Alan Walker','planowana', '2022-04-16 22:30:00', '2022-04-16 23:59:00','koncert','Atlas Arena')
GO
--
select * from Imprezy
UPDATE Imprezy
SET ID_imprezy = 14
WHERE Imprezy.ID_imprezy = 2
select * from Imprezy
GO
select * from Imprezy
UPDATE Imprezy
SET nazwa = 'Katy Perry'
WHERE Imprezy.ID_imprezy = 5
select * from Imprezy
GO
select * from Imprezy
UPDATE Imprezy
SET typ = 'koncert'
WHERE Imprezy.ID_imprezy = 1
select * from Imprezy
GO