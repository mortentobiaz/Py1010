-- opprett database
create database case_nvdb;

--filen hendelser.csv kan ikke importeres i sql server fra gui, men må endres fra , til ; i delimiter for at 
--sql server skal godta denne. kjør bulk script som gjør dette

bulk insert facthendelser
from '<filsti>' -- <-- her må du spesifisere filsti til filen hendelser.csv
with (
    firstrow = 2,
    fieldterminator = ',',
    rowterminator = '0x0d0a'
);
go

-- opprett tabeller i følgende rekkefølge 

--1 faktatabellen med hendelser 

create table facthendelser (
    hendelse_id int identity(1,1) primary key,
    veglenkesekvensid bigint not null unique,
    relativ_posisjon float,
    vegvedlikeholde nvarchar(100),
    rand_float float,
    year int
    );

-- 2 dimensjonstabell med vegobjekt data

create table dimvegobjekt (
    vegobjekt_key int identity(1,1) primary key,
    nvdb_id bigint not null unique,

    vegnummer int,
    vegkategori nvarchar(50),
    fase nvarchar(50),

    kommune_id int,
    fylke_id int,

    lengde float
);

-- 3 hjelpetabell for stedfestinger. et vegobjekt kan ha mange stedfestinger

create table staging_vegobjekt_stedfesting (
    vegobjekt_id bigint not null,
    veglenkesekvens_id int not null,
    startpos float not null,
    sluttpos float not null
);

-- 4 brotabell. viktig tabell som knytter sammen  hendelse til et vegobjekt. identifikator i hendelses tabellen er kombinasjonen av
-- veglenkesekvensid og relativ_posisjon for å beskrive punkt på en linje. dette kan forekomme i flere objekter, rekkverk, skilt, vegbane etc. 
-- derfor har vi et mange til mange forhold, og derfor også behovet for en brotabell.

create table bro_stedfesting (
    hendelse_id int not null,
    vegobjekt_key int not null,

    constraint pk_bro_stedfesting 
        primary key (hendelse_id, vegobjekt_key),

    constraint fk_bro_hendelse 
        foreign key (hendelse_id) 
        references facthendelser(hendelse_id),

    constraint fk_bro_vegobjekt 
        foreign key (vegobjekt_key) 
        references dimvegobjekt(vegobjekt_key)
);
use case_nvdb;

-- populer bro tabell med data. nb! må kjøres etter at python script er kjørt.
/*
insert into bro_stedfesting (hendelse_id, vegobjekt_key)
select distinct
    h.hendelse_id,
    d.vegobjekt_key
from facthendelser h
join staging_vegobjekt_stedfesting s
    on h.veglenkesekvensid = s.veglenkesekvens_id
join dimvegobjekt d
    on s.vegobjekt_id = d.nvdb_id
where h.relativ_posisjon between s.startpos and s.sluttpos;
*/