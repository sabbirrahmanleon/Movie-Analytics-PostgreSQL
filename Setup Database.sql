create database movie;

drop table if exists movies;
create table movies (
movie_id integer,
title varchar(100),
industry varchar(100),
release_year integer,
imdb_rating numeric(5,2),
studio varchar(100),
language_id integer,
primary key (movie_id)
);

drop table if exists finantials;
create table finantials (
movie_id integer,
budget numeric(10,2),
revenue numeric(10,2),
unit varchar(50),
currency varchar(30),
primary key (movie_id)
);

drop table if exists actors;
create table actors (
actor_id integer,
name varchar(100),
birth_year integer,
primary key (actor_id)
);

drop table if exists movie_actor;
create table movie_actor (
movie_id integer,
actor_id integer
);

drop table if exists languages;
create table languages (
language_id integer,
name varchar(50),
primary key (language_id)
);


select * from movies;
select * from finantials;
select * from actors;
select * from movie_actor;
select * from languages;
