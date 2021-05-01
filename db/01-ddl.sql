CREATE EXTENSION postgis;

-- DROP SCHEMA source1;

CREATE SCHEMA source1;


-- Drop table

-- DROP TABLE source1.municipalities;

CREATE TABLE source1.municipalities (
	m_id text NOT NULL,
	istat text NOT NULL,
	name_en text NOT NULL,
	name_it text NOT NULL,
	name_de text NOT NULL,
	population int4 NULL,
	latitude float8 NOT NULL,
	longitude float8 NOT NULL,
	altitude float8 NOT NULL,
	geometrypoint geometry NOT NULL, -- GENERATED ALWAYS AS (st_setsrid(st_makepoint(longitude, latitude, altitude), 4326)) STORED,
	CONSTRAINT municipalities_istat_key UNIQUE (istat),
	CONSTRAINT municipalities_pkey PRIMARY KEY (m_id)
);

-- Drop table

-- DROP TABLE source1.hospitality;

CREATE TABLE source1.hospitality (
	h_id text NOT NULL,
	name_en text NOT NULL,
	name_it text NULL,
	name_de text NOT NULL,
	telephone text NOT NULL,
	email text NOT NULL,
	h_type text NOT NULL,
	latitude float8 NOT NULL,
	longitude float8 NOT NULL,
	altitude float8 NOT NULL,
	category text NOT NULL,
	geometrypoint geometry NOT NULL, -- GENERATED ALWAYS AS (st_setsrid(st_makepoint(longitude, latitude, altitude), 4326)) STORED,
	m_id text NOT NULL,
	CONSTRAINT hospitality_pkey PRIMARY KEY (h_id),
	CONSTRAINT fk_hospitality FOREIGN KEY (m_id) REFERENCES source1.municipalities(m_id)
);

-- Drop table

-- DROP TABLE source1.rooms;

CREATE TABLE source1.rooms (
	r_id text NOT NULL,
	name_en text NOT NULL,
	name_de text NOT NULL,
	name_it text NOT NULL,
	room_units int4 NULL,
	r_type text NOT NULL,
	capacity int4 NULL,
	description_de text NULL,
	description_it text NULL,
	h_id text NOT NULL,
	CONSTRAINT rooms_pkey PRIMARY KEY (r_id),
	CONSTRAINT fk_hospitality FOREIGN KEY (h_id) REFERENCES source1.hospitality(h_id)
);

-- DROP SCHEMA source2;

CREATE SCHEMA source2;

-- Drop table

-- DROP TABLE source2.hotels;

CREATE TABLE source2.hotels (
	id text NOT NULL,
	english text NOT NULL,
	italian text NULL,
	german text NOT NULL,
	htype int4 NULL,
	lat float8 NOT NULL,
	long float8 NOT NULL,
	alt float8 NOT NULL,
	cat text NOT NULL,
	mun int4 NOT NULL,
	geom geometry NOT NULL, -- NULL GENERATED ALWAYS AS (st_setsrid(st_makepoint(long, lat, alt), 4326)) STORED,
	CONSTRAINT hotels_pkey PRIMARY KEY (id)
);

-- Drop table

-- DROP TABLE source2.accommodation;

CREATE TABLE source2.accommodation (
	id text NOT NULL,
	english_title text NOT NULL,
	german_title text NOT NULL,
	italian_title text NOT NULL,
	acco_type int4 NOT NULL,
	guest_nb int4 NULL,
	german_description text NULL,
	italian_description text NULL,
	hotel text NOT NULL,
	CONSTRAINT accommodation_pkey PRIMARY KEY (id)
);

-- DROP SCHEMA source3;

CREATE SCHEMA source3;

-- Drop table

-- DROP TABLE source3.weather_platforms;

CREATE TABLE source3.weather_platforms (
	id int8 NOT NULL,
	"name" varchar(255) NOT NULL,
	pointprojection geometry NOT NULL,
	CONSTRAINT station_pkey PRIMARY KEY (id)
);

-- Drop table

-- DROP TABLE source3.measurement_types;

CREATE TABLE source3.measurement_types (
	"name" text NOT NULL,
	unit text NOT NULL,
	description text NULL,
	"statisticalType" text NULL,
	CONSTRAINT measurement_type_pkey PRIMARY KEY (name)
);

-- Drop table

-- DROP TABLE source3.weather_measurement;

CREATE TABLE source3.weather_measurement (
	id int8 NOT NULL,
	"period" int4 NOT NULL,
	"timestamp" timestamp NOT NULL,
	"name" text NOT NULL,
	double_value float8 NOT NULL,
	platform_id int8 NOT NULL,
	CONSTRAINT measurement_pkey PRIMARY KEY (id),
	CONSTRAINT fk_measurement_station_id_station_pk FOREIGN KEY (platform_id) REFERENCES source3.weather_platforms(id),
	CONSTRAINT fk_measurement_type FOREIGN KEY (name) REFERENCES source3.measurement_types(name)
);
CREATE INDEX idx_measurement_timestamp ON source3.weather_measurement USING btree ("timestamp" DESC);
