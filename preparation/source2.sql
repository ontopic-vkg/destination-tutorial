CREATE SCHEMA if not exists source2;

drop table if exists source2.hotels;

CREATE TABLE source2.hotels (
    id text PRIMARY KEY,
    english text NOT NULL,
    italian text,
    german text NOT NULL,
    htype text NOT NULL,
    lat float NOT NULL,
    long float NOT NULL,
    alt float NOT NULL,
    cat text NOT NULL,
    mun integer NOT NULL,
    geom geometry GENERATED ALWAYS AS (
        ST_SetSRID(ST_MakePoint("long", "lat", "alt"),4326)) STORED
);   

INSERT INTO source2.hotels (id, english, italian, german, htype, lat, long, alt, cat, mun)
       (select a."Id", "AccoDetail-en-Name", "AccoDetail-it-Name", "AccoDetail-de-Name", "AccoTypeId", a."Latitude", a."Longitude", a."Altitude", "AccoCategoryId", m."IstatNumber"::integer 
       FROM v_accommodationsopen a join v_municipalitiesopen m on a."LocationInfo-MunicipalityInfo-Id" = m."Id"
       where a."LocationInfo-RegionInfo-Name-de" in ('Vinschgau'));

