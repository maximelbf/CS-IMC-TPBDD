-- Question 1
-- Récupère l’année de naissance de l’artiste "Jack Black"
-- Résultat :
-- ========================================
-- birthYear
-- ----------
-- 1969
-- ((1 row affected))
SELECT TOP 10 birthYear
FROM dbo.tArtist
WHERE primaryName = 'Jack Black';


-- Question 2
-- Compte le nombre total d’artistes
-- Résultat :
-- ========================================
-- nbArtistes
-- ----------
-- 82046
-- ((1 row affected))
SELECT TOP 10 COUNT(*) AS nbArtistes
FROM dbo.tArtist;


-- Question 3
-- Récupère les artistes nés en 1960
-- Résultat :
-- ========================================
-- primaryName
-- ---------------------
-- David Duchovny
-- Colin Firth
-- Julianne Moore
-- Jean-Claude Van Damme
-- Scott Baio
-- Hugh Grant
-- Timothy Hutton
-- Richard Linklater
-- Sean Penn
-- Daniel Baldwin
-- ((10 rows affected))
SELECT TOP 10 primaryName
FROM dbo.tArtist
WHERE birthYear = 1960;

-- Compte les artistes nés en 1960
-- Résultat :
-- ========================================
-- nbArtistes1960
-- --------------
-- 203
-- ((1 row affected))
SELECT TOP 10 COUNT(*) AS nbArtistes1960 
FROM dbo.tArtist
WHERE birthYear = 1960;


-- Question 4
-- Années de naissance ayant le plus d’artistes
-- Résultat :
-- ========================================
-- birthYear   nbArtistes
-- ----------  ----------
-- 1980        477
-- 1978        457
-- 1979        455
-- 1986        448
-- 1983        446
-- 1982        443
-- 1976        435
-- 1984        434
-- 1972        429
-- 1981        421
-- ((10 rows affected))
SELECT TOP 10 birthYear, COUNT(*) AS nbArtistes
FROM dbo.tArtist
WHERE birthYear <> 0
GROUP BY birthYear
ORDER BY nbArtistes DESC;


-- Question 5
-- Principe :
-- On relie artistes, métiers et films.
-- On ne garde que les lignes où l’artiste est acteur (category = 'acted in').
-- On regroupe par artiste pour compter le nombre de films joués.
-- On filtre avec HAVING pour garder uniquement ceux ayant joué dans plus d’un film.
-- Résultat :
-- ========================================
-- primaryName     nbFilms
-- --------------  ----------
-- Yogi Babu       22
-- Eric Roberts    20
-- Achyuth Kumar   17
-- Redin Kingsley  16
-- VTV Ganesh      15
-- Rudy Ledbetter  15
-- Guy Walters     14
-- Avinash         13
-- Eso Dike        13
-- Joshua Farmer   13
-- ((10 rows affected))
SELECT TOP 10 a.primaryName, COUNT(*) AS nbFilms
FROM dbo.tArtist a
JOIN dbo.tJob j ON a.idArtist = j.idArtist
JOIN dbo.tFilm f ON f.idFilm = j.idFilm
WHERE j.category = 'acted in'
GROUP BY a.idArtist, a.primaryName
HAVING COUNT(*) > 1
ORDER BY nbFilms DESC;


-- Question 6
-- Principe :
-- On relie les artistes à leurs métiers.
-- Pour chaque artiste, on compte le nombre de catégories de métiers différentes.
-- On garde seulement ceux qui ont exercé plusieurs métiers (HAVING > 1).
-- Résultat :
-- ========================================
-- primaryName      nbJobs
-- ---------------  ----------
-- Jamie Grefe      4
-- Toby Poser       4
-- Eban Schletter   4
-- Evan Samaras     4
-- Robert Burkosky  4
-- Quadeca          4
-- Vinsent Mettel   4
-- Douglas Kyle     4
-- Carter Daniel    4
-- Ciaron Davies    4
-- ((10 rows affected))
SELECT TOP 10 a.primaryName, COUNT(DISTINCT j.category) AS nbJobs
FROM dbo.tArtist a
JOIN dbo.tJob j ON a.idArtist = j.idArtist
GROUP BY a.idArtist, a.primaryName
HAVING COUNT(DISTINCT j.category) > 1
ORDER BY nbJobs DESC;


-- Question 7
-- Principe :
-- On calcule d’abord, pour chaque film, le nombre d’acteurs distincts.
-- Ensuite, on cherche la valeur maximale de ce nombre.
-- On affiche uniquement les films ayant ce maximum d’acteurs.
-- Résultat :
-- ========================================
-- primaryTitle                 nbActors
-- ---------------------------  ----------
-- Kickstarter                  10
-- 825 Forest Road              10
-- Snow White and the 7 Dwarfs  10
-- Terapia                      10
-- Play Dead                    10
-- Jumboo Circus                10
-- The Other Woman              10
-- ((7 rows affected))
WITH filmActors AS (
    SELECT TOP 10 f.primaryTitle, COUNT(DISTINCT j.idArtist) AS nbActors
    FROM dbo.tJob j
    JOIN dbo.tFilm f ON j.idFilm = f.idFilm
    WHERE j.category = 'acted in'
    GROUP BY f.idFilm, f.primaryTitle
)
SELECT TOP 10 primaryTitle, nbActors
FROM filmActors
WHERE nbActors = (SELECT MAX(nbActors) FROM filmActors);


-- Question 8
-- Principe :
-- On relie artistes, films et métiers.
-- On regroupe par couple (artiste, film).
-- On compte le nombre de métiers différents pour chaque couple.
-- On garde uniquement les cas où un artiste a plusieurs rôles dans un même film.
-- Résultat :
-- ========================================
-- primaryName           primaryTitle    nbRoles
-- --------------------  --------------  ----------
-- Rami Malek            The Amateur     2
-- Mel Gibson            Flight Risk     2
-- Prithviraj Sukumaran  L2: Empuraan    2
-- Danny Boyle           28 Years Later  2
-- Kevin Caliber         A Hard Place    2
-- Tom Zembrod           This Is War     2
-- Gilbert Trejo         From a Son      3
-- Andrea Fantauzzi      Black Zone      2
-- Harley Wallen         Finding Nicole  3
-- Kaiti Wallen          Finding Nicole  2
-- ((10 rows affected))
SELECT TOP 10
    a.primaryName,
    f.primaryTitle,
    COUNT(DISTINCT j.category) AS nbRoles
FROM dbo.tJob j
JOIN dbo.tArtist a ON a.idArtist = j.idArtist
JOIN dbo.tFilm f ON f.idFilm = j.idFilm
GROUP BY
    a.idArtist,
    a.primaryName,
    f.idFilm,
    f.primaryTitle
HAVING COUNT(DISTINCT j.category) > 1;

