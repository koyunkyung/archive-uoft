BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "avg_price_by_vendor" (
	"vendor"	TEXT,
	"product_name"	TEXT,
	"avg_price"	
);
INSERT INTO "avg_price_by_vendor" VALUES ('Loblaws','Abate Fetel Pears',6.96666666666667);
INSERT INTO "avg_price_by_vendor" VALUES ('Loblaws','Bartlett Pears',5.718);
INSERT INTO "avg_price_by_vendor" VALUES ('Loblaws','Bosc Pears',6.96333333333333);
INSERT INTO "avg_price_by_vendor" VALUES ('Loblaws','Brown Asian Pears',6.6);
INSERT INTO "avg_price_by_vendor" VALUES ('Loblaws','D''Anjou Pears',7.69);
INSERT INTO "avg_price_by_vendor" VALUES ('Loblaws','Forelle Pears',5.38);
INSERT INTO "avg_price_by_vendor" VALUES ('Loblaws','Red Anjou Pears',6.6);
INSERT INTO "avg_price_by_vendor" VALUES ('Loblaws','Yellow Asian Pears',5.5);
INSERT INTO "avg_price_by_vendor" VALUES ('NoFrills','Abate Fetel Pears',7.695);
INSERT INTO "avg_price_by_vendor" VALUES ('NoFrills','Bartlett Pears',4.518);
INSERT INTO "avg_price_by_vendor" VALUES ('NoFrills','Bosc Pears',5.49);
INSERT INTO "avg_price_by_vendor" VALUES ('NoFrills','D''Anjou Pears',6.59);
INSERT INTO "avg_price_by_vendor" VALUES ('NoFrills','Forelle Pears',5.49);
INSERT INTO "avg_price_by_vendor" VALUES ('NoFrills','Rocha Pears',5.49);
INSERT INTO "avg_price_by_vendor" VALUES ('NoFrills','Yellow Asian Pears',5.04);
INSERT INTO "avg_price_by_vendor" VALUES ('Voila','Anjou Pears Large 1 Count ',1.14);
INSERT INTO "avg_price_by_vendor" VALUES ('Voila','Excel Spearmint Mints 34g 1 Tin',3.14);
INSERT INTO "avg_price_by_vendor" VALUES ('Voila','Excel Spearmint Sugar Free Chewing Gum 12 Pieces 1 Pack',1.99);
INSERT INTO "avg_price_by_vendor" VALUES ('Voila','Excel Spearmint Sugar Free Chewing Gum 60 Pieces 1 Bottle',5.31);
INSERT INTO "avg_price_by_vendor" VALUES ('Voila','Excel Spearmint Sugar Free Soft Chew Gum 40 Pieces 1 Bottle',5.31);
INSERT INTO "avg_price_by_vendor" VALUES ('Voila','Organics Pears Bartlett 1 Count ',1.49);
INSERT INTO "avg_price_by_vendor" VALUES ('Voila','Pear Bartlett 1 Count ',1.065);
INSERT INTO "avg_price_by_vendor" VALUES ('Voila','Pears Asian 1 Count ',2.29);
INSERT INTO "avg_price_by_vendor" VALUES ('Voila','Pears Bosc Large 1 Count',1.09);
INSERT INTO "avg_price_by_vendor" VALUES ('Voila','Trident Gum Sugar Free Spearmint 14 Pieces ea',2.49);
COMMIT;
