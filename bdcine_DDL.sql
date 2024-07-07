-- Active: 1719957479947@@localhost@3306@cinema
-- MySQL dump 10.13  Distrib 5.5.27, for Win64 (x86)
--
-- Host: localhost    Database: cinema
-- ------------------------------------------------------
-- Server version	5.5.27

USE cinema;

--
-- Table structure for table acteur
--

DROP TABLE IF EXISTS acteur;
CREATE TABLE acteur (
  num_act INT NOT NULL,
  nom_act VARCHAR(40) NOT NULL,
  anNais_act INT
  -- num_act_parrain INT
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Table structure for table realisateur
--

DROP TABLE IF EXISTS realisateur;
CREATE TABLE realisateur (
  num_real INT NOT NULL,
  nom_real VARCHAR(40) NOT NULL,
  anNais_real INT 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table salle
--

DROP TABLE IF EXISTS salle;
CREATE TABLE salle (
  num_salle INT NOT NULL,
  nbPlaces_salle INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table film
--

DROP TABLE IF EXISTS film;
CREATE TABLE film (
  num_film INT NOT NULL,
  titre_film VARCHAR(40) NOT NULL,
  anSortie_film INT ,
  budget_film INT ,
  genre_film VARCHAR(40) ,
  num_real INT NOT NULL,
  resume_film text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS jouer;
CREATE TABLE jouer (
  num_act INT NOT NULL,
  num_film INT NOT NULL,
  role_jouer VARCHAR(40) ,
  cachet_jouer INT 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table projection
--

DROP TABLE IF EXISTS projection;
CREATE TABLE projection (
  date_projection DATE NOT NULL,
  heure_projection TIME NOT NULL,
  tarif_projection DECIMAL(4,2)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table projeter
--

DROP TABLE IF EXISTS projeter;
CREATE TABLE projeter (
  num_film INT NOT NULL,
  num_salle INT NOT NULL,
  date_projection DATE NOT NULL,
  heure_projection TIME NOT NULL,
  nbSpectateurs_proj INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- CONTRAINTES
-- 

ALTER TABLE acteur
  ADD CONSTRAINT pk_acteur PRIMARY KEY (num_act);


ALTER TABLE realisateur
  ADD CONSTRAINT pk_realisateur PRIMARY KEY (num_real);

ALTER TABLE salle
  ADD CONSTRAINT pk_salle PRIMARY KEY (num_salle);

ALTER TABLE film
  ADD CONSTRAINT pk_film PRIMARY KEY (num_film),
  ADD CONSTRAINT fk_film_realisateur FOREIGN KEY (num_real) REFERENCES realisateur (num_real);

ALTER TABLE jouer
  ADD CONSTRAINT pk_jouer PRIMARY KEY (num_act,num_film),
  ADD CONSTRAINT fk_jouer_film FOREIGN KEY (num_film) REFERENCES film (num_film);

ALTER TABLE projection
  ADD CONSTRAINT pk_projection PRIMARY KEY (date_projection,heure_projection);
  
ALTER TABLE projeter
  ADD CONSTRAINT pk_projeter PRIMARY KEY (num_salle,date_projection,heure_projection,num_film),
  ADD CONSTRAINT fk_projeter_film FOREIGN KEY (num_film) 
	REFERENCES film (num_film),
  ADD CONSTRAINT fk_projeter_projection FOREIGN KEY (date_projection, heure_projection) 
	REFERENCES projection (date_projection, heure_projection) ON UPDATE CASCADE,
  ADD CONSTRAINT fk_projeter_salle FOREIGN KEY (num_salle) 
	REFERENCES salle (num_salle);

DESCRIBE projeter;
