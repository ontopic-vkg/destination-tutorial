CREATE SCHEMA if not exists source1;


drop table if exists source1.hospitality;

CREATE TABLE source1.hospitality (
    h_id text PRIMARY KEY,
    name_en text NOT NULL,
    name_it text,
    name_de text NOT NULL,
    telephone text not NULL,
    email text NOT NULL,
    kind text NOT NULL,
    latitude float NOT NULL,
    longitude float NOT NULL,
    altitude float NOT NULL,
    category text NOT NULL,
    geometryPoint geometry GENERATED ALWAYS AS (
        ST_SetSRID(ST_MakePoint("longitude", "latitude", "altitude"),4326)) STORED, 
    m_id text NOT NULL
);

-- TODO: FK to municipality

INSERT INTO source1.hospitality (h_id, name_en, name_it, name_de, telephone, email, kind, latitude, longitude, altitude, category, m_id)
       (select "Id", "AccoDetail-en-Name", "AccoDetail-it-Name", "AccoDetail-de-Name", "AccoDetail-de-Phone", "AccoDetail-de-Email", "AccoTypeId", "Latitude", "Longitude", "Altitude", "AccoCategoryId", "LocationInfo-MunicipalityInfo-Id"
       FROM v_accommodationsopen
       where "LocationInfo-RegionInfo-Name-de" not in ('Vinschgau'));


drop table if exists source1.municipalities;


CREATE TABLE source1.municipalities(
    m_id text PRIMARY KEY,
    istat text NOT NULL,
    name_en text NOT NULL,
    name_it text NOT NULL,
    name_de text NOT NULL,
    "population" integer,
    latitude float8 NOT NULL,
    longitude float8 NOT NULL,
    altitude float8 NOT NULL,
    UNIQUE(istat)
    );

INSERT INTO source1.municipalities (m_id, istat, name_en, name_it, name_de, "population", latitude, longitude, altitude)
       (SELECT "Id", "IstatNumber", "Detail-en-Title", "Detail-it-Title", "Detail-de-Title", "Inhabitants", "Latitude", "Longitude", "Altitude"
       FROM v_municipalitiesopen);

ALTER TABLE source1.hospitality
ADD CONSTRAINT fk_hospitality
FOREIGN KEY (m_id) 
REFERENCES source1.municipalities (m_id);



CREATE TABLE source1.rooms (
    r_id text PRIMARY KEY,
    name text NOT NULL,
    numberOfUnits integer,
    type text NOT NULL,
    maximumGuest integer,
    description-it varying(255),
    description-de varying(255),
    h_id text NOT NULL,
    CONSTRAINT fk_h_id
        FOREIGN KEY (h_id)
            REFERENCES source1.hospitality (h_id)
);

INSERT INTO source1.rooms (r_id, name, numberOfUnits, type, maximumGuest, description-it, description-de, h_id)
       SELECT (Id, AccoRoomDetail-en-Name, RoomQuantity, Roomtype, "Roommax", AccoRoomDetail-it-Shortdesc, AccoRoomDetail-de-Shortdesc, A0RID)
       FROM  accommodationroomsopen


