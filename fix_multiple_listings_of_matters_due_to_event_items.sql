DROP SEQUENCE event_items_id_seq;
CREATE TABLE tmptb AS SELECT DISTINCT ON ("EventItemMatterId") * FROM event_items;
DROP TABLE event_items;
CREATE TABLE event_items AS SELECT * FROM tmptb;
CREATE SEQUENCE event_items_id_seq;
