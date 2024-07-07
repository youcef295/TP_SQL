-- NOM : 
-- PRENOM :
-- DATE : AAAA-MM-JJ
-- --------------------------------------------
-- cf server SQL modes http://dev.mysql.com/doc/refman/5.0/en/server-sql-mode.html
-- pour modifier un param�tre du SGBD afin d'effectuer des contr�les
-- plus stricts (et ne pas prendre d'options par d�faut : par exemple 0 pour une zone num�rique num�rique)
--
-- SET GLOBAL sql_mode='STRICT_ALL_TABLES,NO_AUTO_VALUE_ON_ZERO';
use cinema;

--
-- VIDER LES TABLES
--
-- ATTENTION : l'ordre des tables � vider en premier lieu
--  doit tenir compte des cles �trang�res qui pourraient
--  cibler ces tables (contr�le d'int�grit� r�f�rentielle)
--
DELETE FROM jouer;

DELETE FROM projeter;

DELETE FROM film;

DELETE FROM projection;

DELETE FROM acteur;

DELETE FROM realisateur;

DELETE FROM salle;

--
-- CHARGER LES FICHIERS 
-- non SQL : LOAD DATA INFILE
--
SHOW VARIABLES LIKE 'secure_file_priv';

-- LOAD DATA LOCAL INFILE '~/tpsql/salle.csv' -- linux, sgbd serveur
LOAD DATA INFILE '/var/lib/mysql-files/cinema/salle.csv' INTO TABLE salle FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;

SELECT
    *
FROM
    salle;

LOAD DATA INFILE '/var/lib/mysql-files/cinema/realisateur.csv' INTO TABLE realisateur FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/cinema/acteur_utf8.csv' INTO TABLE acteur FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/cinema/film.csv' INTO TABLE film FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/cinema/projection.csv' INTO TABLE projection FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/cinema/projeter.csv' INTO TABLE projeter FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/cinema/jouer.csv' INTO TABLE jouer FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;

-- DELETE A COLONNE 
ALTER TABLE film
DROP COLUMN resume_film;

*
-- ADD a line 
INSERT INTO
    realisateur (num_real, nom_real, anNais_real)
VALUES
    (14, "Georges Lucas", NULL);

-- Q10 ajouter les films de Georges Lucas suivants : 13, red Tails, sortie en 2012, et 14, Star
--wars et 15, Indiana jones4 sortis en 2008 ; on ne connait ni le budget, ni des ré sumé s
--de ces 3 films (valeurs null)
INSERT INTO
    film (
        num_film,
        titre_film,
        anSortie_film,
        budget_film,
        genre_film,
        num_real
    )
VALUES
    (14, 'Star wars', NULL, NULL, NULL, 14),
    (15, 'Indiana jones4', 2008, NULL, NULL, 14);

-- SELECTION 
--L1. ister les film dont le numé ro de ré alisateur est 1, 4, 7, ou 14 ou 2540
SELECT
    *
FROM
    film
WHERE
    num_real IN (1, 4, 7, 14, 2540);

--2. Lister les acteurs dont le nom commence par ’isa’
SELECT
    *
FROM
    acteur
WHERE
    nom_act LIKE 'isa%';

-- 3. Lister les acteurs dont le nom se termine par ’ani’
SELECT
    *
FROM
    acteur
WHERE
    nom_act LIKE '%ani';

--4. Lister les acteurs dont le nom contient ’ol’ et ne contient pas ’go’
SELECT
    *
FROM
    acteur
WHERE
    nom_act LIKE '%ol%'
    AND nom_act NOT LIKE '%go%';

--5. Lister les acteurs dont le nom comporte la lettre ’n’ en 3è me position
SELECT
    *
FROM
    acteur
WHERE
    nom_act LIKE '__n%';

--6. Lister le numé ro de film, son titre et le numé ro de ré alisateur du film dont le titre est ’home’
SELECT
    num_film,
    titre_film,
    num_real
FROM
    film
WHERE
    titre_film = 'home';

--7. Lister les acteurs né s avant 1950 ou aprè s 1960 et dont le nom contient l’une des syllabes
--suivantes : ’cru’, ’roc’ et ’cor’
SELECT
    *
FROM
    acteur
WHERE
    (
        anNais_act < 1950
        OR anNais_act > 1960
    )
    AND (
        nom_act LIKE '%cru%'
        OR nom_act LIKE '%roc%'
        OR nom_act LIKE '%cor%'
    );

--8. Lister les ré alisateurs dont l’anné e de naissance n’est pas renseigné e
SELECT
    *
FROM
    realisateur
WHERE
    anNais_real IS NULL;

-- 9. Lister les films sortis en 2005 ou aprè s, ayant un numé ro pair et dont le genre ne contient
-- pas ’drame’ (il existe un opé rateur modulo commen C/C++)
--SELECT * FROM film WHERE anSortie_film>=2005 AND (num_film % 2 = 0) AND genre_film NOT LIKE '%Drame%';
-- 10. utiliser les fonctions SQL month et now : select month(now) from dual; 
--(remarquer le format de la date : aaaa-mm-jj)
SELECT
    NOW (),
    MONTH (NOW ()),
    YEAR (now ())
FROM
    realisateur;

--11. Lister les projections de films en mars 2017 classé es par numé ro de film
SELECT
    *
FROM
    projection
WHERE
    date_projection >= '2017-05-01'
    AND date_projection <= '2017-05-31';

--13. Lister le nom et la longueur du nom des acteurs : nommer cette derniè re colonne
--’longueur’ (cf. alias de colonne, opé ration de renommage)(il existe une fonction length qui
--retourne la longueur d’une chaine
SELECT
    nom_act,
    LENGTH (nom_act) AS longueur
FROM
    acteur;

--14. Lister les acteurs dont la longueur du nom est supé rieur à 15 caractè res
SELECT
    *
FROM
    acteur
WHERE
    LENGTH (nom_act) > 15;

--15. Lister les noms des ré alisateurs en lettres capitales
SELECT
    UPPER(nom_real) AS 'UPPER(nom_real)'
FROM
    realisateur;

-- 16. Lister les pré nom et nom des acteurs (le pré nom est situé avant le 1er espace de nom_act,
-- le nom aprè s...) (Indice : fonctions locate, substring et length)
SELECT
    SUBSTRING(nom_act, 1, LOCATE (' ', nom_act) - 1) AS prenom,
    SUBSTRING(
        nom_act,
        LOCATE (' ', nom_act) + 1,
        LENGTH (nom_act)
    ) AS nom
FROM
    acteur
WHERE
    LOCATE (' ', nom_act) > 0;

-- 17. Lister les acteurs classé s par anné e de naissance (croissant) puis par nom (croissant)
SELECT
    *
FROM
    acteur
ORDER BY
    anNais_act ASC,
    nom_act ASC;

-- 18. Lister les projections classé es par tarif, puis heure de projection dé croissante et date de
-- projection dé croissante
SELECT
    *
FROM
    projection
ORDER BY
    tarif_projection,
    heure_projection DESC,
    date_projection ASC;

-- 1. cré er la table ’mots’ comportant une colonne ’mot’ de type chaine variable de longueur
-- maximale 4
CREATE Table
    IF NOT EXISTS mots (mot VARCHAR(4)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

--2. ajouter les mots suivants dans la table : ’info’,’tech’,’net’,’comm’
INSERT INTO
    mots (mot)
VALUES
    ('info'),
    ('tech'),
    ('net'),
    ('comm');

--3. cré er une requê te donnant toutes les combinaison possibles de 2 mots
SELECT
    m1.mot word1,
    m2.mot word2
FROM
    mots m1
    JOIN mots m2 ON m1.mot != m2.mot;

-- 4. modifier la requê te pré cé dente en dé finissant une seule colonne ré sultat (indice :
-- fonction concat)
SELECT
    CONCAT (m1.mot, m2.mot) entreprise
FROM
    mots m1
    JOIN mots m2 ON m1.mot != m2.mot;

-- 6. cré er une requê te donnant tous les agencements possibles de 3 mots diffé rents
SELECT
    CONCAT (m1.mot, m2.mot, m3.mot) entreprise
FROM
    mots m1
    JOIN mots m2 ON m1.mot != m2.mot
    JOIN mots m3 ON m2.mot != m3.mot
    AND m1.mot != m3.mot;

--cré er une requê te donnant tous les agencements possibles de 2 ou 3 mots classé s
--alphabé tiquement (indice : union)
SELECT
    CONCAT (m1.mot, m2.mot) entreprise
FROM
    mots m1
    JOIN mots m2 ON m1.mot != m2.mot
UNION
SELECT
    CONCAT (m1.mot, m2.mot, m3.mot) entreprise
FROM
    mots m1
    JOIN mots m2 ON m1.mot != m2.mot
    JOIN mots m3 ON m2.mot != m3.mot
    AND m1.mot != m3.mot
ORDER BY
    entreprise ASC;

--1. cré er la table ’termes’ comportant une colonne ’terme’ de type chaine variable de
-- longueur maximale 16
CREATE TABLE
    IF NOT EXISTS termes (terme VARCHAR(16)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- 2. ajouter les mots suivants dans la table : ’belle marquise ’,’vos beaux yeux ’,’me font
-- ’,’mourir’, "d’amour"
DROP Table termes;

INSERT INTO
    termes (terme)
VALUES
    ('belle marquise'),
    ('vos beaux yeux'),
    ('me font'),
    ('d amour');

SELECT
    CONCAT (t1.terme, t2.terme) permutation
FROM
    termes t1
    JOIN termes t2 ON t1.terme != t2.terme
    JOIN termes t3 ON t2.terme != t3.terme
    AND t1.terme != t3.terme
    JOIN termes t4 ON t3.terme != t4.terme
    AND t2.terme != t4.terme
    AND t1.terme != t4.terme
ORDER BY
    permutation;

-- Lister les noms des réalisateurs et les titres de leurs films classé par nom de réalisateur et titre
SELECT
    realisateur.nom_real,
    film.titre_film
FROM
    realisateur
    JOIN film ON realisateur.num_real = film.num_real
ORDER BY
    nom_real,
    titre_film;

-- 2. Lister les titres des films et les noms et rôles des acteurs qui ont joué dans ces films, classé
-- par titre et nom
SELECT
    film.titre_film,
    acteur.nom_act,
    jouer.role_jouer
FROM
    jouer
    JOIN acteur ON jouer.num_act = acteur.num_act
    JOIN film ON jouer.num_film = film.num_film
ORDER BY
    titre_film,
    nom_act;

-- 3. Lister les différents noms de réalisateurs et les noms des acteurs qu’ils ont dirigés dans les
-- films qu’ils ont réalisés, classé par nom de réalisateur et nom d’acteur
SELECT
    realisateur.nom_real,
    acteur.nom_act
FROM
    realisateur
    JOIN film ON realisateur.num_real = film.num_real
    JOIN jouer ON jouer.num_film = film.num_film
    JOIN acteur ON acteur.num_act = jouer.num_act
ORDER BY
    nom_real,
    nom_act;

-- 4. Lister les numéro, titre et budget des films dans lesquels ont joué des acteurs nés après 1950,
-- classé par titre de film
SELECT DISTINCT
    film.num_film,
    film.titre_film,
    film.budget_film
FROM
    film
    JOIN jouer ON film.num_film = jouer.num_film
    JOIN acteur ON jouer.num_act = acteur.num_act
WHERE
    acteur.anNais_act > 1950
ORDER BY
    film.titre_film;

-- 5. Lister les noms des acteurs qui sont aussi réalisateurs (ils portent le même nom et le même
-- prénom...), classé par nom
SELECT
    realisateur.nom_real AS acteurRealisateur
FROM
    realisateur
    JOIN acteur ON nom_act = nom_real;

-- 1. afficher la date du jour et la date décalée de 5 jours (fonctions : now et date_add)
SELECT
    NOW () AS aujourdhui,
    DATE_ADD (NOW (), INTERVAL 5 DAY) AS plus5jours;

--2. afficher la date du jour et la date décalée de 5 mois (fonctions : now et date_add)
SELECT
    NOW () AS aujourdhui,
    DATE_ADD (NOW (), INTERVAL 5 MONTH) AS plus5mois;

-- 4. lister des dates de projection décalées de 5 mois
SELECT
    projection.date_projection,
    DATE_ADD (projection.date_projection, INTERVAL 5 MONTH) AS dans5mois
FROM
    projection;

/*5. lister des écarts entre les dates de projection et aujourd’hui (fonction MySQL : now et
datediff)*/
SELECT
    projection.date_projection,
    now () as now,
    DATEDIFF (NOW (), projection.date_projection) AS ecart
FROM
    projection;

-- 6. rechercher le plus grand écart entre une date de projection et aujourd’hui (fonctions now et
-- datediff, et fonction d’agrégat max)
SELECT
    MAX(DATEDIFF (NOW (), date_projection))
FROM
    projection;

--7. lister le jour de la semaine, le jour du moins, le mois de l’année et l’année de la date du jour
SELECT
    WEEKDAY (NOW ()) as jourSemaine,
    DAYOFMONTH (NOW ()) as jourMois,
    MONTH (NOW ()) as moisAnnee,
    YEAR (NOW ()) as annee;

--8. Lister les acteurs qu’on a pu voir un jeudi dans une salle qui a plus de 300 places , classé par
-- nom d’acteur
SELECT
    acteur.*,
    WEEKDAY (projeter.date_projection) as jourSemaine
FROM
    acteur
    JOIN jouer on acteur.num_act = jouer.num_act
    JOIN projeter on jouer.num_film = projeter.num_film
    JOIN salle on salle.num_salle = projeter.num_salle
WHERE
    WEEKDAY (date_projection) = 3
    AND salle.nbPlaces_salle > 300
ORDER BY
    nom_act;

-- Lister les titres des films, le nom de leur réalisateur et leur année de naissance, classé par
--année de naissance puis nom de réalisateur puis titre de film ; si un réalisateur n’a pas
--d’année de naissance, on aura ’** non fournie **’ pour la valeur de cette colonne (indice : la
--fonction coalesce pourra être utilisée)
SELECT
    film.titre_film,
    realisateur.nom_real,
    IFNULL (realisateur.anNais_real, '** non fournie **') AS neLe
FROM
    film
    JOIN realisateur ON film.num_real = realisateur.num_real
ORDER BY
    anNais_real,
    nom_real,
    titre_film;

-- 10. lister les noms d’acteurs qui sonnent comme ’bnstlr’ ou comme ’isbldjn’, classé par nom
-- (Indice : la fonction soundex pourra être utilisée)
SELECT
    nom_act
FROM
    acteur ()
WHERE
    SOUNDEX (nom_act) = SOUNDEX ('bnstlr')
    OR SOUNDEX (nom_act) = SOUNDEX ('isbldjn');

-- 11. lister le planning des projections du mois de février 2017, classé par numéro du jour de la
-- semaine, salle, date et heure ; Indices :
SELECT
    CASE DAYOFWEEK (projeter.date_projection)
        WHEN 1 THEN 'Lundi'
        WHEN 2 THEN 'Mardi'
        WHEN 3 THEN 'Mercredi'
        WHEN 4 THEN 'Jeudi'
        WHEN 5 THEN 'Vendredi'
        WHEN 6 THEN 'Samedi'
        WHEN 7 THEN 'Dimanche'
    END AS jour,
    projeter.num_salle,
    projeter.date_projection,
    projeter.heure_projection,
    film.titre_film
FROM
    projeter
    JOIN film ON projeter.num_film = film.num_film
ORDER BY
    DAYOFWEEK (projeter.date_projection),
    projeter.num_salle,
    projeter.date_projection,
    projeter.heure_projection;

-- test
SHOW TABLES;

SELECT
    *
FROM
    film;


-- Just a test for the commit and the push
-- Just to be sure 