--SQLite
DROP TABLE agents;
DROP TABLE origin;
DROP TABLE roles;
DROP TABLE weapons;
DROP TABLE kda;
DROP TABLE maps;

CREATE TABLE agents (
    a_agentkey decimal(2,0) not null,
    a_name char(10) not null,
    a_rolekey decimal(2,0) not null,
    a_originkey decimal(2,0) not null,
    a_gender char(10) not null,
    a_race char(10) not null
);

CREATE TABLE origin (
    o_originkey decimal(2,0) not null,
    o_name char(30) not null
);

CREATE TABLE roles (
    r_rolekey decimal(2,0) not null,
    r_name char(10) not null,
    r_weaponkey decimal(2,0) not null
);

CREATE TABLE weapons (
    w_weaponkey decimal(2,0) not null,
    w_name char(10) not null,
    w_type decimal(2,0) not null,
    w_price decimal(4,0) not null,
    w_firerate decimal(4,2) not null,
    w_nearheaddmg decimal(3,0) not null,
    w_nearbodydmg decimal(3,0) not null,
    w_nearlegdmg decimal(3,0) not null,
    w_midheaddmg decimal(3,0) not null,
    w_midbodydmg decimal(3,0) not null,
    w_midlegdmg decimal(3,0) not null,
    w_farheaddmg decimal(3,0) not null,
    w_farbodydmg decimal(3,0) not null,
    w_farlegdmg decimal(3,0) not null
);

CREATE TABLE kda (
    kda_agentkey decimal(2,0) not null,
    kda_mapkey decimal(2,0) not null,
    kda_kill decimal(3,1) not null,
    kda_death decimal(3,1) not null,
    kda_assist decimal(2,1) not null,
    kda_winrate decimal(3,2) not null,
    kda_atkwin decimal(3,2) not null,
    kda_defwin decimal(3,2) not null,
    kda_agentpr decimal(3,2) not null
);

CREATE TABLE maps (
    m_mapkey decimal(1,0) not null,
    m_name char(10) not null,
    m_atkwin decimal(3,1) not null,
    m_defwin decimal(3,1) not null,
    m_description char(100) not null
);

--SQLite Bulk Loading
.mode "csv"
.separator ","
.headers off

-- import data from csv file to table
.import '| tail -n +2 data/agents.csv' agents
.import '| tail -n +2 data/origin.csv' origin
.import '| tail -n +2 data/roles.csv' roles
.import '| tail -n +2 data/weapons.csv' weapons
.import '| tail -n +2 data/kda.csv' kda
.import '| tail -n +2 data/maps.csv' maps


