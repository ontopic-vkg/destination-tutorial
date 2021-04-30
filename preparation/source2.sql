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

drop table if exists source2.weather_measurement;
drop table if exists source2.measurement_types;
drop table if exists source2.weather_platforms;

CREATE TABLE source2.weather_platforms (
	id int8 NOT NULL,
	"name" varchar(255) NOT NULL,
	pointprojection geometry NOT NULL,
	CONSTRAINT station_pkey PRIMARY KEY (id)
);

INSERT INTO source2.weather_platforms (id, "name", pointprojection)
  (SELECT id, "name", pointprojection FROM intimev2.station s WHERE stationtype='MeteoStation' 
  -- Brenner (has wrong geometry)
  AND s.id <> 619
  AND exists (SELECT * from intimev2.measurement m where m.station_id = s.id) );

CREATE TABLE source2.measurement_types (
	"name" text NOT NULL,
	"unit" text NOT NULL,
    "description" text,
    "statisticalType" text,
	CONSTRAINT measurement_type_pkey PRIMARY KEY (name)
);

INSERT INTO source2.measurement_types("name", "unit", "description", "statisticalType")
(select cname, cunit, "description", rtype from intimev2."type" t  where cname IN ('NOX','Ozono','PM10','umidita_abs','umidita_rel','water-temperature','wind-direction','wind-speed','wind10m_direction','wind10m_speed','temp_aria'));


CREATE TABLE source2.weather_measurement (
	id int8 NOT NULL,
	"period" int4 NOT NULL,
	"timestamp" timestamp NOT NULL,
    "name" text NOT NULL,
	double_value float8 NOT NULL,
    platform_id int8 NOT NULL,
	CONSTRAINT measurement_pkey PRIMARY KEY (id),
    CONSTRAINT fk_measurement_station_id_station_pk FOREIGN KEY (platform_id) REFERENCES source2.weather_platforms (id),
    CONSTRAINT fk_measurement_type FOREIGN KEY ("name") REFERENCES source2.measurement_types ("name")
);

CREATE INDEX idx_measurement_timestamp ON source2.weather_measurement USING btree ("timestamp" DESC);

INSERT INTO source2.weather_measurement (id, "period", "timestamp", "name", "double_value", "platform_id")
 (SELECT m.id, m."period", m."timestamp", t.cname, double_value, station_id 
 FROM intimev2.measurement m, intimev2.station s, intimev2."type" t  
 WHERE m.station_id = s.id and s.stationtype='MeteoStation' and m.type_id = t.id 
       -- Brenner (has wrong geometry)
       and s.id <> 619 
       and cname IN ('NOX','Ozono','PM10','umidita_abs','umidita_rel','water-temperature','wind-direction','wind-speed','wind10m_direction','wind10m_speed','temp_aria'));