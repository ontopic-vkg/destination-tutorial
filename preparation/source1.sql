EXEC SQL CONNECT TO tourismuser AS con1 USER tourismuser;
EXEC SQL SELECT pg_catalog.set_config('search_path', '${tourism_schema_vkg}', false);

CREATE TABLE tourism.hospitality1 (
    h_id serial PRIMARY KEY,
    name-en character varying(64) NOT NULL,
    name-it character varying(64) NOT NULL,
    name-de character varying(64) NOT NULL,
    telephone integer UNIQUE,
    email character varying(255) UNIQUE,
    type character varying(64) NOT NULL,
    latitude numeric(7,2) NOT NULL,
    longitude numeric(7,2) NOT NULL,
    altitude numeric(7,2) NOT NULL,
    geometryPoint geometry GENERATED ALWAYS AS (
        ST_SetSRID(ST_MakePoint("Longitude", "Latitude", "Altitude"),4326)), 
    m_id character varying(64) NOT NULL,
    CONSTRAINT fk_m_id
        FOREIGN KEY (m_id)
            REFERENCES tourism.municipalities (m_id)
);

INSERT INTO tourism.hospitality1 (h_id, name-en, name-it, name-de, telephone, email, type, latitude, longitude, altitude, m_id)
       SELECT (Id, AccoDetail-en-Name, AccoDetail-it-Name, AccoDetail-de-Name, AccoDetail-de-Phone, AccoDetail-de-Email, AccoTypeId, "geo", "LocationInfo-MunicipalityInfo-Name-it")
       FROM accommodationsopen
       WHERE NOT (LocationInfo-MunicipalityInfo-Name-it = 'Bressanone')

CREATE TABLE tourism.rooms (
    r_id serial PRIMARY KEY,
    name character varying(64) NOT NULL,
    numberOfUnits integer,
    type character varying(64) NOT NULL,
    maximumGuest integer,
    description-it varying(255),
    description-de varying(255),
    h_id numeric(7,2) NOT NULL,
    CONSTRAINT fk_h_id
        FOREIGN KEY (h_id)
            REFERENCES tourism.hospitality1 (h_id)
);

INSERT INTO tourism.rooms (r_id, name, numberOfUnits, type, maximumGuest, description-it, description-de, h_id)
       SELECT (Id, AccoRoomDetail-en-Name, RoomQuantity, Roomtype, "(RoomQuantity * Roommax) as maximumGuest", AccoRoomDetail-it-Shortdesc, AccoRoomDetail-de-Shortdesc, A0RID)
       FROM  accommodationroomsopen

CREATE TABLE tourism.municipality(
    m_id serial PRIMARY KEY,
    name-en character varying(64) NOT NULL,
    name-it character varying(64) NOT NULL,
    name-de character varying(64) NOT NULL,
    IstatNumber integer,
    populationCount integer,
    latitude numeric(7,2) NOT NULL,
    longitude numeric(7,2) NOT NULL,
    altitude numeric(7,2) NOT NULL,
    )

INSERT INTO tourism.municipalities (m_id, name-en, name-it, name-de, IstatNumber, populationCount, latitude, longitude, altitude)
       SELECT (Id, Detail-en-Title, Detail-it-Title, Detail-de-Title, IstatNumber, Inhabitants, Latitude, Longitude, Altitude)
       FROM municipalitiesopen

CREATE TABLE tourism.hospitality2 (
    hid serial PRIMARY KEY,
    h-name-en character varying(64) NOT NULL,
    h-name-it character varying(64) NOT NULL,
    h-name-de character varying(64) NOT NULL,
    telephone integer UNIQUE,
    email character varying(255) UNIQUE,
    type character varying(64) NOT NULL,
  """ geometry """
    m_ISTAT character varying(64) NOT NULL,
    CONSTRAINT fk_m_ISTAT
        FOREIGN KEY (m_ISTAT)
            REFERENCES tourism.municipalities (IstatNumber)    
)   

INSERT INTO tourism.hospitality2 (hid, h-name-en, h-name-it, h-name-de, telephone, email, type, "geometry", m_ISTAT)
       SELECT (Id, AccoDetail-en-Name, AccoDetail-it-Name, AccoDetail-de-Name, AccoDetail-de-Phone, AccoDetail-de-Email, AccoTypeId, "geo", "LocationInfo-MunicipalityInfo-Name-it")
       FROM accommodationsopen
       WHERE (LocationInfo-MunicipalityInfo-Name-it = 'Bressanone')


