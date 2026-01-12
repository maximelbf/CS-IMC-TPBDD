 -- Question 1
SELECT birthYear
FROM dbo.tArtist
WHERE primaryName = 'Jack Black';

 -- Question 2
 SELECT COUNT(*) AS nbArtistes
 FROM dbo.tArtist;

 -- Question 3
 SELECT primaryName
 FROM dbo.tArtist
 WHERE birthYear = 1960;

 SELECT COUNT(*) AS nbArtistes1960 
 FROM dbo.tArtist
 WHERE birthYear = 1960;

 -- Question 4
 SELECT TOP 1 birthYear, COUNT(*) as nbArtistes
 FROM dbo.tArtist
 WHERE birthYear <> 0
 GROUP BY birthYear
 ORDER BY nbArtistes DESC;

 -- Question 5
SELECT a.primaryName, COUNT(*) AS nbFilms
FROM dbo.tArtist a
JOIN dbo.tJob j ON a.idArtist = j.idArtist
JOIN dbo.tFilm f ON f.idFilm = j.idFilm
WHERE j.category = 'acted in'
GROUP BY a.idArtist, a.primaryName
HAVING COUNT(*) > 1
ORDER BY nbFilms DESC;

 -- Question 6
SELECT a.primaryName, COUNT(DISTINCT j.category) AS nbJobs
FROM dbo.tArtist a
JOIN dbo.tJob j ON a.idArtist = j.idArtist
GROUP BY a.idArtist, a.primaryName
HAVING COUNT(DISTINCT j.category) > 1
ORDER BY nbJobs DESC;

 -- Question 7
WITH filmActors AS (
    SELECT f.primaryTitle, COUNT(DISTINCT j.idArtist) AS nbActors
    FROM dbo.tJob j
    JOIN dbo.tFilm f ON j.idFilm = f.idFilm
    WHERE j.category = 'acted in'
    GROUP BY f.idFilm, f.primaryTitle
    )
SELECT primaryTitle, nbActors
FROM FilmActors
WHERE nbActors = (SELECT MAX(nbActors) FROM FilmActors);


 -- Question 8
 SELECT
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


