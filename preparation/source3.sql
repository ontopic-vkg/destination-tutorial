CREATE SCHEMA if not exists source3;

drop table if exists source3.weather_measurement;
drop table if exists source3.measurement_types;
drop table if exists source3.weather_platforms;

CREATE TABLE source3.weather_platforms (
	id int8 NOT NULL,
	"name" varchar(255) NOT NULL,
	pointprojection geometry NOT NULL,
	CONSTRAINT station_pkey PRIMARY KEY (id)
);

INSERT INTO source3.weather_platforms (id, "name", pointprojection)
  (SELECT id, "name", pointprojection FROM intimev2.station s WHERE stationtype='MeteoStation' 
  -- Brenner (has wrong geometry)
  AND s.id <> 619
  AND exists (SELECT * from intimev2.measurement m where m.station_id = s.id) );

CREATE TABLE source3.measurement_types (
	"name" text NOT NULL,
	"unit" text NOT NULL,
    "description" text,
    "statisticalType" text,
	CONSTRAINT measurement_type_pkey PRIMARY KEY (name)
);

INSERT INTO source3.measurement_types("name", "unit", "description", "statisticalType")
(select cname, cunit, "description", rtype from intimev2."type" t  where cname IN ('NOX','Ozono','PM10','umidita_abs','umidita_rel','water-temperature','wind-direction','wind-speed','wind10m_direction','wind10m_speed','temp_aria'));


CREATE TABLE source3.weather_measurement (
	id int8 NOT NULL,
	"period" int4 NOT NULL,
	"timestamp" timestamp NOT NULL,
    "name" text NOT NULL,
	double_value float8 NOT NULL,
    platform_id int8 NOT NULL,
	CONSTRAINT measurement_pkey PRIMARY KEY (id),
    CONSTRAINT fk_measurement_station_id_station_pk FOREIGN KEY (platform_id) REFERENCES source3.weather_platforms (id),
    CONSTRAINT fk_measurement_type FOREIGN KEY ("name") REFERENCES source3.measurement_types ("name")
);

CREATE INDEX idx_measurement_timestamp ON source3.weather_measurement USING btree ("timestamp" DESC);

INSERT INTO source3.weather_measurement (id, "period", "timestamp", "name", "double_value", "platform_id")
 (SELECT m.id, m."period", m."timestamp", t.cname, double_value, station_id 
 FROM intimev2.measurement m, intimev2.station s, intimev2."type" t  
 WHERE m.station_id = s.id and s.stationtype='MeteoStation' and m.type_id = t.id 
       -- Brenner (has wrong geometry)
       and s.id <> 619 
       and cname IN ('NOX','Ozono','PM10','umidita_abs','umidita_rel','water-temperature','wind-direction','wind-speed','wind10m_direction','wind10m_speed','temp_aria'));