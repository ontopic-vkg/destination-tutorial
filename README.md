# Destination tutorial for Ontop

This tutorial is derived from [the Virtual Knowledge Graph](https://github.com/noi-techpark/it.bz.opendatahub.sparql) of the South Tyrolean [Open Data Hub](https://opendatahub.bz.it/).

## Requirements
 - Docker
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

This command starts and initialises the database. Once the database is ready, it launches the SPARQL endpoint of Ontop at http://localhost:8080 .

For this tutorial, we assume that the ports 7777 (used for database) and 8080 (used by Ontop) are free. If you need to use different ports, please edit the file `.env`.


## Dataset

The dataset is composed of the following tables:
 - `source1.municipalities`

The table `source1.municipalities` contains the local ID _(m_id)_, name _(en, it, de)_, ISTAT number,  population, geometrical coordinates _(latitude, longitude, altitude)_ and geometrical points of the municipalities.
 
| m_id | name_en  | name_en | name_de | IstatNumber | population | latitude | longitude | altitude | geometryPoint | 
| --------------- | --------------- | --------------- |  --------------- | --------------- | --------------- | --------------- | --------------- | --------------- | --------------- |
| |  | | | |  | | | | 

The column _m_id_ is a primary key.


 - `source1.hospitality`

The table `source1.hospitality` contains the local ID _(h_id)_, name _(en ,it ,de)_, telephone number, email, type _(kind)_, geometrical coordinates _(latitude, longitude, altitude)_, geometrical points and the associated municipality ID of the lodging business. 
 
 | h_id | name_en  | name_en | name_de | telephone | kind | latitude | longitude | altitude | geometryPoint | 
| --------------- | --------------- | --------------- |  --------------- | --------------- | --------------- | --------------- | --------------- | --------------- | --------------- |
| |  | | | |  | | | | 

The column kind is populated with string data types: _Hotel, Hostel, Campground, Bed and Breakfast_.

The column _h_id_ is a primary key.


 - `source1.rooms`

Similarly, the table `source1.rooms` contains the room ID, name, number of room unit, maximal number of guests, multilingual descriptions and hospitality ID of the rooms.

| r_id | name_en  | name_en | name_de | roomUnits | type | maximumGuest | description_it | description_de | h_id | 
| --------------- | --------------- | --------------- |  --------------- | --------------- | --------------- | --------------- | --------------- | --------------- | --------------- |
| |  | | | |  | | | | 

The column type is also populated with string data types: _Room, Appartement, Pitch, Youth_.

The column _r_id_ is a primary key.

 - `source2.hotels`

The table `source2.hotels` contains the ID, the name _(english, italian, german)_, type _(htype)_, geographical coordinates _(lat, long, alt)_ rating values _(cat)_, municipalities _(mun)_ and the geometrical points _(geom)_ of the lodging business. The table `source2.hotels` contains same attributs as the table `source1.hospitality` with a different schema.   

| id | english  | italian | german | htype | lat | long | alt | cat | mun | geom | 
| --------------- | --------------- | --------------- |  --------------- | --------------- | --------------- | --------------- | --------------- | --------------- | --------------- | --------------- |
| |  | | | |  | | | | |

The column _htype_ is populated with magic numbers (they differ from the table `source1.hospitality`):

- 1 -> BedAndBreakfast
- 2 -> Hotel
- 4 -> Campground

The column _id_ is a primary key.


 - `source2.accommodation`

The table `source2.accommodation` contains same attributs as the table `source1.rooms` with a different schema. 

| id | english_title  | german_title | italian_title | accommodation_units | acco_type | guest_nb | german_description | italian_description | hotel | 
| --------------- | --------------- | --------------- |  --------------- | --------------- | --------------- | --------------- | --------------- | --------------- | --------------- |
| |  | | | |  | | | | 

The column _acco_type_ is populated with magic numbers (they differ from the table `source1.hospitality`):

- 1 -> Room
- 2 -> Apartment
- 3 -> Pitch
- 4 -> Youth

The column _id_ is a primary key.

 - `source3.weather_platforms`

The table `source3.weather_platforms` contains a local ID, name and the geometrical points of the weather platforms. 

| id | name  | pointprojection | 
| --------------- | --------------- | --------------- | 
|  |  |  | 


 - `source3.weather_measurement`
 
 The table `source3.weather_measurement` contains the local ID, period, timestamp, name, values of the weather measurements observed by the weather platforms. Also, there is an ID of the platforms.  


| id | period  | timestamp | double_value | platform_id | 
| --------------- | --------------- | --------------- |  --------------- | --------------- | 
| |  | | | 

 - `source3.measurement_types`
 
The table `source3.measurement_types` contains name, unit, description and statistical type of the measurements.

| name | unit  | description | statisticalType | 
| --------------- | --------------- | --------------- |  --------------- |
| | | | |

### Optional: visualize it in DBeaver
To visualize the dataset in DBeaver or a similar tool, the credentials to access the PostgreSQL database are the followings:
 - Host: *localhost*
 - Port: 7777
 - User: *postgres*
 - Password: *postgres2*


## Mapping

In this tutorial, the ontology and the SPARQL queries are already provided. We will focus on the mapping. Our goal is achieve a fragment of the following diagrams.

For tables in the schemas `source1` and `source2`:

<img src="diagrams/lodging.png" width="800"/>

For tables in the schema `source3`:

<img src="diagrams/weather.png" width="570"/>

The initial mapping includes already an entry describing municipalities.

### Open the project on Protégé

On Protégé, open (in a new window if requested) the ontology file `vkg/dest.ttl`. Go to the *Ontop Mappings* tab (if you don't see it, enable it in *Windows -> Tabs*) and to the *Mapping manager* sub-tab. One mapping entry called *Municipality* should be visible.

If you click of *File -> Save*, your changes will be saved and the Ontop SPARQL endpoint will be automatically restarted.

### Proposed sequence
 1. Map the municipality geometries
 2. Map the names, telephone, email and the main class of `source1` lodging businesses
 3. Map these lodging businesses to municipalities
 4. Map their geometries
 5. Map the sub-classes of `source1` lodging businesses
 6. Map the names and descriptions of `source1` accommodations
 7. Map `source1` accommodations to their lodging businesses
 8. Map the names and the main class of `source2` lodging businesses
 9. Map these lodging businesses to municipalities
 10. Map the main class, names and geometries of weather stations
 11. Map weather observations
 12. Map weather sensors
 13. Map weather results
 14. Map the observed properties
 
***M.0 `source1` - Municipality***
  
- Target                      
```sparql
data:municipalities/{istat} a :Municipality ; schema:name {name_it}@it , {name_de}@de , {name_en}@en ; geo:defaultGeometry data:geo/municipalities/{istat} ; schema:geo data:geo/municipalities/{istat} . 
```
- Source
```sql
SELECT * FROM source1.municipalities 
```
Some remarks:

- The target part is described using a [Turtle-like syntax](https://github.com/ontop/ontop/wiki/TurtleSyntax) while the source part is a regular SQL query.
- We used the primary key `istat` to create the IRI. [As we can see on the Ontop Tutorial](https://ontop-vkg.org/tutorial/mapping/primary-keys.html), this practice enables to remove self-joins, which is very important for optimizing the query performance.
- This entry could be split into several mapping assertions:
```sparql
data:municipalities/{istat} a :Municipality.
data:municipalities/{istat} schema:name {name_it}@it , {name_de}@de , {name_en}@en.
data:municipalities/{istat} geo:defaultGeometry data:geo/municipalities/{istat}. 
data:municipalities/{istat} schema:geo data:geo/municipalities/{istat} . 
```
Note: To map data properties, we use the data directly from table by using the column names. For the object properties, we create an unique IRI to identify the object. Then, if an object has associated data properties, they will be defined as you can see in the next mapping. 

Let us now add the other mapping assertions by clicking on create:

***M1 `source1` - Municipality-geometry***
- Target
```sparql
data:geo/municipality/{istat} a schema:GeoCoordinates ; schema:longitude {longitude} ; schema:latitude {latitude} ; schema:elevation {altitude} ; geo:asWKT {wkt}^^geo:wktLiteral . 
```
- Source
 ```sql
SELECT *, ST_AsText(geometrypoint) AS wkt FROM source1.municipalities
```
Note: As we use [GeoSPARQL](https://en.wikipedia.org/wiki/OGC_GeoSPARQL) vocabulary for representing spatial information in our mappings, the vector geometry objects needed to be represented as _Well-known text (WKT)_. In this case, we use `ST_AsText` function which returns WKT representation of the geometry. 

***M2 `source1` - LodgingBusiness***
- Target
```sparql
data:source1/hospitality/{h_id} a schema:LodgingBusiness ; schema:name {name_en}@en , {name_it}@it , {name_de}@de ; schema:telephone {telephone} ; schema:email {email} ; geo:defaultGeometry data:source1/geo/hospitality/{h_id} ; schema:geo data:source1/geo/hospitality/{h_id} . 
```
- Source
 ```sql
SELECT * FROM source1.hospitality
```

***M3 `source1` - LodgingBusiness-municipalities***
- Target
```sparql
data:source1/hospitality/{h_id} schema:containedInPlace data:municipality/{istat} .  
```
- Source
 ```sql
SELECT h.h_id, m.istat FROM source1.hospitality h, source1.municipalities m
WHERE h.m_id = m.m_id
```
***M4 `source1` - LodgingBusiness-geometry***
- Target
```sparql
data:source1/geo/hospitality/{h_id} a schema:GeoCoordinates ; schema:longitude {longitude} ; schema:latitude {latitude} ; schema:elevation {altitude} ; geo:asWKT {wkt}^^geo:wktLiteral . 
```
- Source
 ```sql
SELECT *, ST_AsText(geometrypoint) AS wkt FROM source1.hospitality
```
***M5 sub-classes of `source1` lodging businesses***

In the hospitaly table, lodging business types are populated by using the string values such as _HotelPension, Camping, BedAndBreakfast and Youth_. In order to create sub-class of lodging business, we need to specify a filtering condition in the `WHERE` clause.  

***M5.a `source1` - Hotel***
- Target
```sparql
data:source1/hospitality/{h_id} a schema:Hotel . 
```
- Source
 ```sql
SELECT h_id, h_type FROM source1.hospitality
WHERE h_type = 'HotelPension'
```
***M5.b `source1` - Campground***
- Target
```sparql
data:source1/hospitality/{h_id} a schema:Campground . 
```
- Source
 ```sql
SELECT h_id, h_type FROM source1.hospitality
WHERE h_type = 'Camping'
```
***M5.c `source1` - BedAndBreakfast***
- Target
```sparql
data:source1/hospitality/{h_id} a schema:BedAndBreakfast . 
```
- Source
 ```sql
SELECT h_id, h_type FROM source1.hospitality
WHERE h_type = 'BedAndBreakfast'
```
***M5.d `source1` - Hostel***
- Target
```sparql
data:source1/hospitality/{h_id} a schema:Hostel . 
```
- Source
 ```sql
SELECT h_id, h_type FROM source1.hospitality
WHERE h_type = 'Youth'
```
***M6 `source1` - Accomodation***
- Target
```sparql
data:source1/rooms/{r_id} a schema:Accommodation ; schema:name {name_en}@en , {name_it}@it , {name_de}@de ; schema:description {description_de}@de , {description_it}@it ; :numberOfUnits {room_units} ; schema:occupancy data:source1/occupancy/rooms/{r_id} . 

```
- Source
 ```sql
SELECT * FROM source1.rooms
```
***M6 `source1` - RoomOccupancy***
- Target
```sparql
data:source1/occupancy/rooms/{r_id} a schema:QuantitativeValue ; schema:maxValue {capacity} ; schema:unitCode "C62"^^xsd:string . 
```
- Source
 ```sql
SELECT * FROM source1.rooms
```
***M6 sub-classes of `source1` accomodation***

The sub-classes of the room are constructed with the same way as lodging business types. 

***M6.a `source1` - Apartement***
- Target
```sparql
data:source1/rooms/{r_id} a schema:Apartment . 
```
- Source
 ```sql
SELECT * FROM source1.rooms
WHERE r_type = 'apartment'
```
***M6.b `source1` - Room***
- Target
```sparql
data:source1/rooms/{r_id} a schema:Room . 
```
- Source
 ```sql
SELECT * FROM source1.rooms
WHERE r_type = 'room'
```
***M6.c `source1` - CampingPitch***
- Target
```sparql
data:source1/rooms/{r_id} a schema:CampingPitch . 
```
- Source
 ```sql
SELECT * FROM source1.rooms
WHERE r_type = 'pitch'
```
***M7 `source1` - accomodation-lodgingBusiness***
- Target
```sparql
data:source1/rooms/{r_id} a schema:Accommodation ; schema:containedInPlace data:source1/hospitality/{h_id} .
```
- Source
 ```sql
SELECT * FROM source1.rooms
```
#### Source 2

The database of `source2` has a different schema for the lodging business. 

***`source2` - Lodging Business***
- Target
```sparql
data:source2/hotels/{id} a schema:LodgingBusiness ; schema:name {english}@en , {italian}@it , {german}@de ; schema:containedInPlace data:municipality/0{mun} ; schema:geo data:source2/geo/hotels/{id} ; geo:defaultGeometry data:source2/geo/hotels/{id} .
```
- Source
 ```sql
SELECT * FROM source2.hotels
```
***`source2` - LodgingBusiness-geo***
- Target
```sparql
data:source2/geo/hotels/{id} a schema:GeoCoordinates ; schema:longitude {long} ; schema:latitude {lat} ; schema:elevation {alt} ; geo:asWKT {wkt}^^geo:wktLiteral . 
```
- Source
 ```sql
SELECT *, ST_AsText(geom) AS wkt FROM source2.hotels
```
***sub-classes of `source2` lodging business***

Unlike the `source1`, the type of `source2` lodging business is populated with magic numbers. 
- 1 -> BedAndBreakfast
- 2 -> Hotel
- 4 -> Campground

***`source2` - Hotel***
- Target
```sparql
data:source2/hotels/{id} a schema:Hotel . 
```
- Source
 ```sql
SELECT * FROM source2.hotels
WHERE htype = 2
```
***`source2` - BedAndBreakfast***
- Target
```sparql
data:source2/hotels/{id} a schema:BedAndBreakfast. 
```
- Source
 ```sql
SELECT * FROM source2.hotels
WHERE htype = 1
```
***`source2` - CampGround***
- Target
```sparql
data:source2/hotels/{id} a schema:Campground . 
```
- Source
 ```sql
SELECT * FROM source2.hotels
WHERE htype = 4
```
***`source2` - lodgingBusiness-accomodation***
- Target
```sparql
data:source2/accommodation/{id} a schema:Accommodation ; schema:name {english_title}@en , {italian_title}@it , {german_title}@de ; schema:description {german_description}@de , {italian_description}@it ; :numberOfUnits {accommodation_units} ; schema:containedInPlace data:source1/hospitality/{hotel} ; schema:occupancy data:source2/occupancy/accommodation/{id} . 
```
- Source
 ```sql
SELECT * FROM source2.accommodation
```
***`source2` - RoomOccupancy***
- Target
```sparql
data:source2/occupancy/accommodation/{id} a schema:QuantitativeValue ; schema:maxValue {guest_nb} ; schema:unitCode "C62"^^xsd:string . 
```
- Source
 ```sql
SELECT * FROM source2.accommodation
```
***`source2` - Apartement***

the type of `source2` accommodation is also populated with magic numbers. 
- 1 -> Room
- 2 -> Apartment
- 3 -> CampingPitch
***`source2` - Apartement***
- Target
```sparql
data:source2/accommodation/{id} a schema:Apartment . 
```
- Source
 ```sql
SELECT * FROM source2.accommodation
WHERE acco_type = 2
```
***`source2` - Room***
- Target
```sparql
data:source2/accommodation/{id} a schema:Room . 
```
- Source
 ```sql
SELECT * FROM source2.accommodation
WHERE acco_type = 1
```
***`source2` - CampingPitch***
- Target
```sparql
data:source2/accommodation/{id} a schema:CampingPitch . 
```
- Source
 ```sql
SELECT * FROM source2.accommodation
WHERE acco_type = 3
```
#### Source 3

***M10 Weather platform***
- Target
```sparql
data:weather/platform/{id} a :WeatherStation ; schema:name {name} ; geo:defaultGeometry data:geo/weather/platform/{id} . 
```
- Source
 ```sql
SELECT * FROM source3.weather_platforms
```
***M10 Weather platform - geo***
- Target
```sparql
data:geo/weather/platform/{id} geo:asWKT {wkt}^^geo:wktLiteral . 
```
- Source
 ```sql
SELECT *, st_AsText(pointprojection) AS wkt FROM source3.weather_platforms
```
***M11 Weather observation***
- Target
```sparql
data:weather/observation/{id} a sosa:Observation ; sosa:resultTime {timestamp} ; sosa:madeBySensor data:weather/sensor/{name}/{platform_id} ; sosa:observedProperty data:measurement/property/{name} ; sosa:hasResult data:weather/observation/result/{id} . 
```
- Source
 ```sql
SELECT * FROM source3.weather_measurement
```
***M12 Weather sensor***
- Target
```sparql
target		data:weather/sensor/{name}/{platform_id} a sosa:Sensor ; sosa:isHostedBy data:weather/platform/{platform_id} . 
```
- Source
 ```sql
SELECT * FROM source3.weather_measurement
```
***M13 Weather observation result***
- Target
```sparql
data:weather/observation/result/{id} a sosa:Result ; qudt:numericValue {double_value} . 
```
- Source
 ```sql
SELECT * FROM source3.weather_measurement
```
***M13.a Weather observation result degree celius***
- Target
```sparql
data:weather/observation/result/{id} qudt:unit qudt-unit:DegreeCelsius . 
```
- Source
 ```sql
SELECT m.id FROM source3.weather_measurement m, source3.measurement_types t
WHERE m.name = t.name and t.unit = '°C'
```
***M13.b Weather observation result m/s***
- Target
```sparql
data:weather/observation/result/{id} qudt:unit qudt-unit:MeterPerSecond . 
```
- Source
 ```sql
SELECT m.id FROM source3.weather_measurement m, source3.measurement_types t
WHERE m.name = t.name and t.unit = 'm/s'
```
***M14 Measurement property***
- Target
```sparql
data:measurement/property/{name} a sosa:ObservableProperty ; schema:description {description}@it . 
```
- Source
 ```sql
SELECT * FROM source3.measurement_types
```
***M14.a Wind Speed***
- Target
```sparql
data:measurement/property/{name} a :WindSpeed . 
```
- Source
 ```sql
SELECT * FROM source3.measurement_types
WHERE name = 'wind-speed'
```
***M14.b Water Temperature***
- Target
```sparql
data:measurement/property/{name} a :WaterTemperature . 
```
- Source
 ```sql
SELECT * FROM source3.measurement_types
WHERE name = 'water-temperature'
```

## Solutions

First, stop the current docker-compose.

Then
```sh
docker-compose -f docker-compose.solution.yml up
```

This Docker-compose file uses the mapping `vkg/dest-solution.obda`.

You can see it in Protégé by opening the ontology `vkg/dest-solution.ttl` in a different window.

Example SPARQL queries are available at http://localhost:8080/ .

## To know more

Visit https://ontop-vkg.org . This official website provides a more detailed tutorial.
