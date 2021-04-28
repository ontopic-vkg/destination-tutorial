CREATE TABLE source2.hotels (
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

INSERT INTO source2.hotels (hid, h-name-en, h-name-it, h-name-de, telephone, email, type, "geometry", m_ISTAT)
       SELECT (Id, AccoDetail-en-Name, AccoDetail-it-Name, AccoDetail-de-Name, AccoDetail-de-Phone, AccoDetail-de-Email, AccoTypeId, "geo", "LocationInfo-MunicipalityInfo-Name-it")
       FROM accommodationsopen
       WHERE (LocationInfo-MunicipalityInfo-Name-it = 'Bressanone')