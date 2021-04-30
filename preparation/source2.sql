CREATE SCHEMA if not exists source2;

drop table if exists source2.accommodation;
drop table if exists source2.hotels;

CREATE TABLE source2.hotels (
    id text PRIMARY KEY,
    english text NOT NULL,
    italian text,
    german text NOT NULL,
    htype integer,
    lat float NOT NULL,
    long float NOT NULL,
    alt float NOT NULL,
    cat text NOT NULL,
    mun integer NOT NULL,
    geom geometry GENERATED ALWAYS AS (
        ST_SetSRID(ST_MakePoint("long", "lat", "alt"),4326)) STORED
);

INSERT INTO source2.hotels (id, english, italian, german, htype, lat, long, alt, cat, mun)
       (select a."Id", "AccoDetail-en-Name", "AccoDetail-it-Name", "AccoDetail-de-Name",
case "AccoTypeId" when 'BedBreakfast' then 1 when 'HotelPension' then 2 when 'Farm' then 3 when 'Camping' then 4 end, 
a."Latitude", a."Longitude", a."Altitude", "AccoCategoryId", m."IstatNumber"::integer 
       FROM v_accommodationsopen a join v_municipalitiesopen m on a."LocationInfo-MunicipalityInfo-Id" = m."Id"
       where a."LocationInfo-RegionInfo-Name-de" in ('Vinschgau'));

CREATE TABLE source2.accommodation (
    id text PRIMARY KEY,
    english_title text NOT NULL,
    german_title text NOT NULL,
    italian_title text NOT NULL,    
    acco_type integer NOT NULL,
    guest_nb integer,
    german_description text,
    italian_description text,
    hotel text NOT NULL
);

INSERT INTO source2.accommodation (id, english_title, german_title, italian_title, acco_type, guest_nb, german_description, italian_description, hotel)
       (SELECT "Id", "AccoRoomDetail-en-Name", "AccoRoomDetail-de-Name", "AccoRoomDetail-it-Name", 
       CASE "Roomtype" WHEN 'room' THEN 1 WHEN 'apartment' then 2 when 'pitch' then 3 end, "Roommax",  "AccoRoomDetail-de-Shortdesc", "AccoRoomDetail-it-Shortdesc", "A0RID"
       FROM  v_accommodationroomsopen 
       WHERE v_accommodationroomsopen."A0RID" IN (SELECT "Id" FROM v_accommodationsopen WHERE "LocationInfo-RegionInfo-Name-de" IN ('Vinschgau')));