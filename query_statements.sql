-- Add below your SQL statements. 
-- You can create intermediate views (as needed). Remember to drop these views after you have populated the result tables.
-- You can use the "\i a2.sql" command in psql to execute the SQL commands in this file.

-- Query 1 statements
CREATE VIEW neighbourHeight AS
SELECT N.country AS country, N.neighbor AS neighbor, CO.height AS nHeight
FROM neighbour N, country CO
WHERE N.neighbor = CO.cid;

CREATE VIEW highestElevationPoint AS
SELECT A.country, A.neighbor
FROM neighbourHeight A JOIN (select country, max(nHeight) as max from neighbourHeight group by country) as B
ON A.country = B.country AND A.nHeight = B.max
GROUP BY A.country, A.neighbor
ORDER BY A.country ASC;

INSERT INTO query1 (
    SELECT maxH.country AS c1id, CO1.cname AS c1name, CO2.cid AS c2id, CO2.cname AS c2name
    FROM highestElevationPoint maxH INNER JOIN country CO1
    ON maxH.country = CO1.cid INNER JOIN country CO2
    ON maxH.neighbor = CO2.cid
    ORDER BY c1name ASC
);

DROP VIEW highestElevationPoint;
DROP VIEW neighbourHeight;


-- Query 2 statements
INSERT INTO query2 (
    SELECT C.cid, C.cname
    FROM country C
    WHERE C.cname NOT IN (
        SELECT C.cname 
        FROM country C, oceanAccess OA
        WHERE C.cid = OA.cid
    )
    ORDER BY cname ASC
);


-- Query 3 statements
CREATE VIEW landlocked AS
SELECT CO.cid as cid, CO.cname as cname
FROM oceanAccess OA FULL JOIN country CO
ON OA.cid = CO.cid
WHERE OA.oid IS NULL;

CREATE VIEW landlockedCountry AS
SELECT A.cid as c1id, A.cname as c1name, N.neighbor as c2id
FROM landlocked A, neighbour N
WHERE A.cid = N.country;

CREATE VIEW exactlyOne AS
SELECT A.c1id as c1id, A.c1name as c1name, A.c2id as c2id
FROM landlockedCountry A JOIN (select c1id from landlockedCountry group by c1id having count(c1id) = 1) AS B
ON A.c1id = B.c1id;

INSERT INTO query3 (
    SELECT A.c1id AS c1id, A.c1name AS c1name, A.c2id AS c2id, CO.cname as c2name
    FROM exactlyOne A INNER JOIN country CO
    ON A.c2id = CO.cid
    ORDER BY c1name ASC
);

DROP VIEW exactlyOne;
DROP VIEW landlockedCountry;
DROP VIEW landlocked;


-- Query 4 statements
-- Countries that have direct access to the ocean
CREATE VIEW DirectAccess AS 
SELECT OA.cid, OA.oid 
FROM oceanAccess OA;

-- Countries that have indirect access to the ocean
CREATE VIEW InDirectAccess AS 
SELECT N.country AS cid, OA.oid 
FROM neighbour N, oceanAccess OA 
WHERE N.neighbor = OA.cid AND N.neighbor IN (
    SELECT OA.cid FROM oceanAccess OA
);

-- Countries that have direct and indirect access to the ocean
CREATE VIEW HasAccess AS 
SELECT DA.cid, DA.oid 
FROM DirectAccess DA 
UNION ALL 
SELECT IA.cid, IA.oid 
FROM InDirectAccess IA;

INSERT INTO query4 (
    SELECT C.cname, O.oname 
    FROM country C, ocean O, HasAccess HA 
    WHERE C.cid = HA.cid AND O.oid = HA.oid 
    GROUP BY C.cname, O.oname 
    ORDER BY C.cname ASC, O.oname DESC
);

DROP VIEW HasAccess;
DROP VIEW InDirectAccess;
DROP VIEW DirectAccess;


-- Query 5 statements
CREATE VIEW hdiFrom09to13 AS
SELECT cid, year, hdi_score
FROM hdi
WHERE year >= 2009 AND year <= 2013;

INSERT INTO query5 (
    SELECT A.cid AS cid, CO.cname AS cname, avg(hdi_score) as avghdi
    FROM hdiFrom09to13 A, country CO
    WHERE A.cid = CO.cid
    GROUP BY A.cid, CO.cname
    ORDER BY avghdi DESC
    LIMIT 10
);

DROP VIEW hdiFrom09to13;


-- Query 6 statements
CREATE VIEW hdi0910 AS
SELECT A.cid, A.hdi_score as hdi_score
FROM hdi A, hdi B
WHERE A.cid = B.cid AND A.year = 2010 AND B.year = 2009 AND A.hdi_score - B.hdi_score > 0;

CREATE VIEW hdi1011 AS
SELECT A.cid, A.hdi_score as hdi_score
FROM hdi A, hdi0910 B
WHERE A.cid = B.cid AND A.year = 2011 AND A.hdi_score - B.hdi_score > 0;

CREATE VIEW hdi1112 AS
SELECT A.cid, A.hdi_score as hdi_score
FROM hdi A, hdi1011 B
WHERE A.cid = B.cid AND A.year = 2012 AND A.hdi_score - B.hdi_score > 0;

CREATE VIEW hdi1213 AS
SELECT A.cid, A.hdi_score as hdi_score
FROM hdi A, hdi1112 B
WHERE A.cid = B.cid AND A.year = 2013 AND A.hdi_score - B.hdi_score > 0;

INSERT INTO query6 (
    SELECT A.cid as cid, CO.cname as cname
    FROM hdi1213 A, country CO
    WHERE A.cid = CO.cid
    ORDER BY cname ASC
);

DROP VIEW hdi1213;
DROP VIEW hdi1112;
DROP VIEW hdi1011;
DROP VIEW hdi0910;


-- Query 7 statements
CREATE VIEW populationOfReligion AS
SELECT R.cid AS cid, R.rid AS rid, R.rname AS rname, R.rpercentage AS rpercentage, (CO.population * R.rpercentage) AS followersInCountry
FROM religion R, country CO
WHERE R.cid = CO.cid;

INSERT INTO query7 (
    SELECT rid, rname, sum(followersInCountry) AS followers
    FROM populationOfReligion
    GROUP BY rid, rname
    ORDER BY followers DESC
);

DROP VIEW populationOfReligion;


-- Query 8 statements
-- Find each country's most popular language
CREATE VIEW LanguagePercent AS 
SELECT C.cid, max(L.lpercentage) AS popluarlanguage
FROM country C, language L
WHERE C.cid = L.cid
GROUP BY C.cid
ORDER BY C.cid ASC;

CREATE VIEW PopularLanguage1 AS
SELECT LP.cid, L.lname, LP.popluarlanguage
FROM LanguagePercent LP, language L 
WHERE LP.popluarlanguage = l.lpercentage AND LP.cid = L.cid;

-- Make a copy of country's popular language
CREATE VIEW PopularLanguage2 AS
SELECT LP.cid, L.lname, LP.popluarlanguage
FROM LanguagePercent LP, language L 
WHERE LP.popluarlanguage = l.lpercentage AND LP.cid = L.cid;

-- Join bordering countries
CREATE VIEW BorderCountry AS
SELECT C.cname, N.neighbor, PL1.lname AS clang, PL2.lname nlang
FROM country C, neighbour N, PopularLanguage1 PL1, PopularLanguage2 PL2 
WHERE C.cid = N.country AND PL1.cid = C.cid AND PL2.cid = N.neighbor;

INSERT INTO query8 (
    SELECT BC.cname AS c1name, C.cname AS c2name, BC.clang AS lname
    FROM country C, BorderCountry BC 
    WHERE BC.neighbor = C.cid AND BC.clang = BC.nlang
    ORDER BY lname ASC, c1name DESC
);

DROP VIEW BorderCountry;
DROP VIEW PopularLanguage2;
DROP VIEW PopularLanguage1;
DROP VIEW LanguagePercent;



-- Query 9 statements
CREATE VIEW countryDepth AS
SELECT OA.cid AS cid, OA.oid AS oid, O.depth AS depth
FROM oceanAccess OA, ocean O
WHERE OA.oid = O.oid;

CREATE VIEW noAccessToOcean AS
SELECT CO.cname as cname, CO.cid as cid, COALESCE(A.depth, 0) AS depth, CO.height as height
FROM countryDepth A FULL JOIN country CO
ON A.cid = CO.cid;

CREATE VIEW deepestDepth AS
SELECT cname, cid, max(depth) as maxDepth, height
FROM noAccessToOcean 
GROUP BY cname, cid,  height;

INSERT INTO query9 (
    SELECT cname, (height + maxDepth) AS totalspan
    FROM deepestDepth
    ORDER BY totalspan DESC
    LIMIT 1
);


DROP VIEW deepestDepth;
DROP VIEW noAccessToOcean;
DROP VIEW countryDepth;


-- Query 10 statements
INSERT INTO query10 (
    SELECT C.cname, sum(N.length) AS borderslength
    FROM country C, neighbour N 
    WHERE C.cid = N.country
    GROUP BY C.cname
    ORDER BY borderslength DESC LIMIT 1
);
