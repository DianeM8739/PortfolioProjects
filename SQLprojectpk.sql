---Create projpokedex table
CREATE TABLE projpokedex (
	name INT PRIMARY KEY,
	pokedex CHARACTER VARYING,
	type CHARACTER VARYING,
	subtype CHARACTER VARYING,
	total INTEGER,
	hp INTEGER,
	attack INTEGER,
	defense INTEGER,
	sp_atk INTEGER,
	sp_def INTEGER,
	speed INTEGER
);

---Create pkmoveset table
CREATE TABLE pkmoveset (
	move INT PRIMARY KEY,
	type CHARACTER VARYING,
	category CHARACTER VARYING,
	pp INTEGER,
	power INTEGER,
	accuracy INTEGER,
	gen INTEGER
);

---pull entire table ordered by pokedex number
SELECT *
FROM projpokedex
ORDER BY pokedex;

---Highest defense descending
SELECT name, defense
FROM projpokedex
ORDER BY defense DESC;

---Highest attack descending
SELECT name, attack
FROM projpokedex
ORDER BY attack DESC;

---Top pokemon with highest attack and defense
SELECT Name, MAX(Attack) as Highest_Attack, MAX(Defense) as Highest_Defense
FROM projpokedex
GROUP BY Name
ORDER BY MAX(Attack) DESC, MAX(Defense) DESC
LIMIT 1;

---Top pokemon overall
SELECT Name, MAX(attack) as Attack, MAX(defense) as Defense, MAX(sp_atk) as Special_Attack, MAX(sp_def) as Special_Defense
FROM projpokedex
GROUP BY Name
ORDER BY MAX(attack) DESC, MAX(defense) DESC, MAX(sp_atk) DESC, MAX(sp_def) DESC
LIMIT 1;

---Number of types
SELECT Type, COUNT(*) as number_pokemon
FROM projpokedex
GROUP BY type
ORDER BY COUNT(*) DESC;

---Number of subtypes
SELECT 
CASE 
    WHEN subtype IS NULL THEN 'No Subtype'
    ELSE subtype
END AS "Subtype",
COUNT(*) as Count_Subtype
FROM projpokedex
GROUP BY subtype
ORDER BY COUNT(*) DESC;

---Pulls all the pokemon that can do fire type moves including type, subtype, and category of move 
SELECT p.name, m.move, m.type, 
CASE 
	WHEN p.subtype IS NULL THEN 'No Subtype'
	ELSE p.subtype
	END as subtype,
	m.category
FROM projpokedex p
JOIN pkmoveset m ON p.type = m.type
WHERE p.type = 'Fire' OR p.subtype = 'Fire';


---Pulls Pokemon with a fire type that can do status category moves
SELECT p.name, p.pokedex, p.type, 
CASE 
	WHEN p.subtype IS NULL THEN 'No Subtype'
	ELSE p.subtype
	END as subtype
FROM projpokedex AS p
JOIN pkmoveset AS m ON p.type = m.type
WHERE m.category = 'Status' AND (p.type = 'Fire' OR p.subtype = 'Fire')

---Pulls percentage of pokemon that can do ice type moves
WITH total_pokemon AS (SELECT COUNT(DISTINCT name) as total FROM projpokedex),
ice_moves AS (SELECT COUNT(DISTINCT p.name) as ice_count
FROM projpokedex p
JOIN pkmoveset m ON p.type = m.type
WHERE m.type = 'Ice' OR p.subtype = 'Ice')
SELECT (ice_moves.ice_count * 100.0 / total_pokemon.total) as percentage
FROM ice_moves, total_pokemon;

---type and move with the highest power
SELECT type, MAX(power) as max_power, move
FROM pkmoveset
WHERE power IS NOT NULL
GROUP BY type, move
ORDER BY max_power DESC;






