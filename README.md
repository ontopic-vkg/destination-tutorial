# Destination tutorial for Ontop

This tutorial is adapted from [the Virtual Knowledge Graph](https://github.com/noi-techpark/it.bz.opendatahub.sparql) of the South Tyrolean [Open Data Hub](https://opendatahub.bz.it/).


## Materials 
Slides of the tutorial given at the Knowledge Graph Conference (KGC) 2021 can be found in the `slides` directory.

The video of the tutorial is available [here](https://knowledgegraphconference.vhx.tv/kgc-2021/videos/may-3rd-t3-integrating-data-through-virtual-knowledge-graphs-with-ontop-bb71a1dc-c38d-4729-baa0-03917fdd0d99) (subscription or conference ticket required).

## Requirements
 - [Docker](https://www.docker.com/)
 - Protégé 5.5 with the Ontop 4.1.0 plugin installed. A bundle is available [here](https://sourceforge.net/projects/ontop4obda/files/ontop-4.1.0/).
 - Optionally [DBeaver](https://dbeaver.io/) or another database tool for visualizing the data source.

## Clone this repository

On Windows
```sh
git clone https://github.com/ontopic-vkg/destination-tutorial  --config core.autocrlf=input
```

Otherwise, on MacOS and Linux:
```sh
git clone https://github.com/ontopic-vkg/destination-tutorial
```

## Table of contents
* [Setup Protégé](#setup-protégé)
* [Start Docker-Compose](#start-docker-compose)
* [Dataset](#dataset)
* [Mapping](#mapping)
* [Solutions](#solutions)
* [More info](#to-know-more)



## Setup Protégé
* Run Protégé (*run.bat* on Windows, *run.sh* on Mac/Linux)
* Register the PostgreSQL JDBC driver: go to *Preferences -> JDBC Drivers* and add an entry with the following information
   * Description: *postgresql*
   * Class Name: *org.postgresql.Driver*
   * Driver file (jar): */path/to/destination-tutorial/jdbc/postgresql-42.2.8.jar*
* Go to *Reasoner* and select *Ontop 4.1.0* .

## Start Docker-compose

* Go to the `destination-tutorial` repository
* Start the default Docker-compose file

```sh
docker-compose pull && docker-compose up
```

This command starts and initializes the database. Once the database is ready, it launches the SPARQL endpoint from Ontop at http://localhost:8080 .

For this tutorial, we assume that the ports 7777 (used for database) and 8080 (used by Ontop) are free. If you need to use different ports, please edit the file `.env`.


## Dataset

The dataset is composed of the following tables:
 - `source1.municipalities`

The table `source1.municipalities` contains the ID _(m_id)_, name _(en, it, de)_, Italian statistical institute code _(istat)_ , population, geospatial coordinates _(latitude, longitude, altitude)_ and geometrical point of municipalities.
 
| m_id | istat | name_en | name_it | name_de | population | latitude | longitude | altitude | geometrypoint | 
| ---- | ----------- | ------- | ------- | ------- | ---------- | -------- | --------- | ---------| ------------- |
|A7CA017FF0424503 827BCD0E552F4648 |	021069 |	Proves/Proveis |	Proves |	Proveis |	266 |	46.4781 |	11.023 |	1420.0 |	POINT Z(11.023 46.4781 1420) |
| BB0043517A574986 83B2F997B7B68D5F |	021065 |	Ponte Gardena/Waidbruck |	Ponte Gardena |	Waidbruck |	203 |	46.598 |	11.5317 |	470.0 |	POINT Z(11.5317 46.598 470) |
| 516EF5F9F7794997 B874828DBE157E6E |	021036 |	Glorenza/Glurns |	Glorenza |	Glurns |	894 |	46.6711 |	10.5565  |	907.0 |	POINT Z(10.5565 46.6711 907) |

The column _m_id_ is the primary key.


 - `source1.hospitality`

The table `source1.hospitality` contains the ID _(h_id)_, name _(en ,it ,de)_, telephone number, email, type _(kind)_, geospatial coordinates _(latitude, longitude, altitude)_, geometrical points and the associated municipality ID of lodging businesses. 
 
| h_id | name_en  | name_it | name_de | telephone | email | kind | latitude | longitude | altitude | category | geometrypoint | m_id |
| ---- | -------- | ------- |  ------ | --------- | ----- | ---- | -------- | ----------| -------- | -------- | ------------- | --------- |
| ACE81868364111D4 9F0000105AF76E96 | Apartments Monica | Appartamenti Monica | Appartements Monica | +39 380 4243160 | info@appartements-monica.com | BedBreakfast | 46.9386 | 11.4444 | 1098.0 | 2suns | POINT Z(11.4444 46.9386 1098) | 2B138D40992744BD BD38F56B73F45183 |
| EFF0FACBA54C11D1 AD760020AFF92740 |	Residence Tuberis |	Residence Tuberis |	Residence Tuberis |	+39 0474 678488 |	info@tubris.com |	HotelPension |	46.9191 |	11.9547 |	865.0 |	3stars |	POINT Z(11.9547 46.9191 865) |	6A5FF36917FA48D2 B1996B76C7AA8BC6 |
| 5F74DCC404AAA52B 318A12507A1F27F7 |	Camping  Gisser Vitha Hotels |	Camping  Gisser Vitha Hotels |	Camping  Gisser Vitha Hotels |	+39 0474 569605 |	reception@hotelgisser.it |	Camping	| 46.807976 |	11.812105 |	778.0 |	3stars |	POINT Z(11.812105 46.807976 778) |	1E84922B82234EE6 82A341531E1D1925 |

The column _kind_ is populated with the following values: _Hotel, Hostel, Campground, Bed and Breakfast_.

The column _h_id_ is the primary key.


 - `source1.rooms`

Similarly, the table `source1.rooms` contains the ID, name, number of units, maximal number of guests, multilingual descriptions and lodging business ID of accommodations (e.g. rooms and apartments).

| r_id | name_en  | name_it | name_de | room_units | type | guest_nb | description_de | description_it | h_id | 
| ---- | -------- | ------- | ------- | --------- | ---- | ------------ | ---------------| -------------- | -------- |
| E4B47698C5A67758 4245B6F4E13CCB69 |	Appartement "PANORMASUITE" |	Appartamento "PANORMASUITE" |	Apartment "Panoramasuite" |	1	| apartment	| 4 |	Natursuite mit Schlafempore...|	Suite con area notte al piano superiore... |	32001C4FAA1311D1 926F00805A150B0B |
| AF57632D700A11D3 962F00104B421FA8 |	"Crab apple" |	"Mela selvatica" |	"Zierapfel" |	1 |	apartment |	6 |	Wohnraum mit Kochnische... |	Stanza di soggiorno con cucina...|	E650C0C33DC111D2 9536004F56000ECA |
| 65F7D5D3182D4300 A42E23D60F836F61 |	apartment Sella for 5-6 people |	Appartamento Sella per 5-6 persone |	Ferienwohnung Sella für 5-6 Personen |	1	| apartment |	6 |	Ferienwohnung 5 Personen |	Appartamento 5 persone |	8DA75A1A0AE743B4 89948BA98ECA30A9 |

The column _type_ is also populated with the following datatypes: _Room, Appartement, Pitch, Youth_.

The column _r_id_ is the primary key.

 - `source2.hotels`

The table `source2.hotels` has similar content to `source1.hospitality`, but with a different structure. It contains the ID, multilingual names _(english, italian, german)_, type _(htype)_, geospatial coordinates _(lat, long, alt)_ rating value _(cat)_, municipality ISTAT code _(mun)_ and geometrical point _(geom)_ of lodging businesses.  

| id | english  | italian | german | htype | lat | long | alt | cat | mun | geom | 
| -- | -------- | ------- | ------ | ----- | --- | ---- | --- | ----| --- | ---- |
| 001AE4C0FA0781A2C DD3750811DBDAEB |	Apartment Haideblick |	Appartamento Haideblick	App. | Ferienwohnung Haideblick |	1 |	46.766831	 | 10.533657 |	1470.0 |	2suns |	21027 |	POINT Z(10.533657 46.766831 1470) |
| 0614E1C5699E11D7 82540020AF71A63E |	House Rosi |	Cafe/Casa Rosi | Cafe Ferienhaus Rosi |	1 |	46.615587	| 10.699991 |	868.0	 | 3suns |	21042 |	POINT Z(10.699991 46.615587 868) |
| 05287B29094E4B03 AD97A5B4B3E66345 |	Sonnenhof	| Sonnenhof |	Sonnenhof|	3|	46.706881	|10.473704|	1730.0|	1flower	|21046	|POINT Z(10.473704 46.706881 1730)|

The column _htype_ is populated with magic numbers:

- 1 -> BedAndBreakfast
- 2 -> Hotel
- 3 -> Hostel
- 4 -> Campground

The column _id_ is the primary key.


 - `source2.accommodation`

The table `source2.accommodation` has similar content to `source1.rooms`, but with a different structure. An important difference is that it does not contain the number of units, which is implicitly equal to 1.

| id | english_title  | german_title | italian_title | acco_type | guest_nb | german_description | italian_description | hotel | 
| -- | -------------- | ------------ | ------------- | --------- | -------- | ------------------ | ------------------- | ------|
|73F2B6C02A6152C2 86BFF186D1572DBC |	Apartment Zerminiger |	Ferienwohnung Zerminiger |	Appartamento Zerminiger |	2 | 4 |	Mit einer Wohnfläche von 59 m² bietet... |	Con una superficie abitabile di 59 mq... | 	0A99E8B00EBA5795 6959949D017055FB |
|7F90B92F9CAA2F65 3B0F4DAEF5476A67|	Appartment for 2-6 persons	| Ferienwohnung für 2-6 Personen |	Appartamento per 2-6 persone |	2 |	5 |	Großzügig ausgestatete geräumige Wohnung... |	Ben aredate spazio appartamento...	| 25548AEDD4682E0D 809086AD1B28E6F2 |
| D3B0D75E132711D2 91A60040055FA744 |	Family room |	Doppelzimmer | Süd A mit Balkon & Talblick	Camera famigliare |	1 |	4 |	WC, Dusche, Balkon, Talblick |	WC, doccia, balcone |	F63F948FEE3E11D1 91A60040055FA744 |

The column _acco_type_ is populated with magic numbers:

- 1 -> Room
- 2 -> Apartment
- 3 -> Pitch
- 4 -> Youth

The column _id_ is the primary key.

 - `source3.weather_platforms`

The table `source3.weather_platforms` contains the ID, name and geometrical point of weather platforms. 

| id | name | pointprojection | 
| -- | ---- | --------------- | 
|23862|	Forte D'Ampola |	POINT (10.646293 45.863893) |
|23863|	Ghiacciaio Del Careser |	POINT (10.718272 46.451278) |
|23864|	Ghiacciaio di Fradusta |	POINT (11.871709 46.255107) |

 - `source3.weather_measurement`
 
 The table `source3.weather_measurement` contains the ID, validity period, timestamp, name and value of weather measurements. There is also the ID of the platform that performed the measurement.


| id | period  | timestamp | name | double_value | platform_id | 
| -- | ------- | --------- | ---- | ------------ | ----------- | 
| 203881 |	3600	| 2019-01-07 23:00:00	| water-temperature	| 11.7 |	2173 |
| 204004	| 3600 |	2019-01-07 23:00:00 |	water-temperature	| 10.8 |	2166 |
| 230277	| 900 |	2020-07-14 14:15:00 |	wind10m_speed |	4.5 |	23893 |
 - `source3.measurement_types`
 
The table `source3.measurement_types` contains the name, unit, description and statistical type of measurements.

| name | unit  | description | statisticalType | 
| --------------- | --------------- | --------------- |  --------------- |
|temp_aria |	[°C] |	Temperatura dell’aria |	Mean |
|umidita_rel|	[%] |	Umidità relativa dell’aria |	Mean |
|umidita_abs|	[g/m^3]|	Umidità assoluta dell’aria |	Mean |

### Optional: visualize it in DBeaver
To visualize the dataset in DBeaver or a similar tool, we need to create a database connection. In DBeaver, one can follow the next steps:  *Database* -> *New Database Connection* -> *PostgreSQL*

The credentials to access the PostgreSQL database are the followings:
 - Host: *localhost*
 - Port: 7777
 - User: *postgres*
 - Password: *postgres2*


## Mapping

In this tutorial, the ontology and the SPARQL queries are already provided. We will focus on the mapping. Our goal is to reproduce the following diagrams.

For tables in the schemas `source1` and `source2`:

<img src="diagrams/lodging.png" width="800"/>

For tables in the schema `source3`:

<img src="diagrams/sensors.svg" width="800"/>

The initial mapping already includes an entry describing municipalities.

### Open the project on Protégé

On Protégé, open (in a new window if requested) the ontology file `vkg/dest.ttl`. Go to the *Ontop Mappings* tab (if you don't see it, enable it in *Windows -> Tabs*) and to the *Mapping manager* sub-tab. One mapping entry called *Municipality* should be visible.

If you click of *File -> Save*, your changes will be saved and the Ontop SPARQL endpoint will be automatically restarted.


### Mapping entries
 
See [the dedicated page](mapping.md) for specifying the mapping entries.


## Solutions

First, stop the current docker-compose:
```sh
docker-compose stop
```

Then, specify the file by using *-f* : 
```sh
docker-compose -f docker-compose.solution.yml up
```

This Docker-compose file uses the mapping `vkg/dest-solution.obda`.

You can see it in Protégé by opening the ontology `vkg/dest-solution.ttl` in a different window.

Example SPARQL queries are available at http://localhost:8080/ .

## To know more

Visit the official website of Ontop https://ontop-vkg.org, which also provides a more detailed tutorial.
