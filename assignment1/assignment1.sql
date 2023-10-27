# 1.
SELECT name
FROM Pokemon
WHERE type='Grass'
ORDER BY name;

# 2.
SELECT name
FROM Trainer
WHERE hometown IN ('Brown City', 'Rainbow City')
ORDER BY name;

# 3.
SELECT DISTINCT type
FROM Pokemon
ORDER BY type;

# 4.
SELECT name 
FROM City 
WHERE name LIKE 'B%' 
ORDER BY name;

# 5.
SELECT hometown
FROM Trainer
WHERE name NOT LIKE 'M%'
ORDER BY hometown;

# 6.
SELECT nickname
FROM CatchedPokemon
WHERE level = (
	SELECT max(level)
	FROM CatchedPokemon
	)
ORDER BY nickname;

# 7.
SELECT name
FROM Pokemon
WHERE name LIKE 'A%' OR name LIKE 'E%' OR name LIKE 'I%' OR name LIKE 'O%' OR name LIKE 'U%'
ORDER BY name;

# 8.
SELECT avg(level)
FROM CatchedPokemon;

# 9. 
SELECT max(level)
FROM CatchedPokemon
WHERE owner_id = (
	SELECT id
    FROM Trainer
    WHERE name = 'Yellow'
    );
    
# 10.
SELECT DISTINCT hometown
FROM Trainer
ORDER BY hometown;

# 11.
SELECT name, nickname
FROM Trainer JOIN CatchedPokemon ON Trainer.id = owner_id
WHERE nickname LIKE 'A%'
ORDER BY name;

# 12.
SELECT Trainer.name
FROM Trainer JOIN Gym JOIN City ON id = leader_id AND city = City.name
WHERE description = 'AMAZON';

# 13.
WITH catched_by_trainer (owner_id, cnt) AS (
	SELECT owner_id, COUNT(pid)
    FROM Trainer JOIN Pokemon JOIN CatchedPokemon ON Trainer.id = owner_id AND pid = Pokemon.id
    WHERE type = 'Fire'
    GROUP BY owner_id
    )
SELECT owner_id, cnt
FROM catched_by_trainer
WHERE cnt = (
	SELECT MAX(cnt)
    FROM catched_by_trainer
    );

# 14.
SELECT DISTINCT type
FROM Pokemon
WHERE id LIKE '_'
ORDER BY id DESC;

# 15.
SELECT COUNT(id)
FROM Pokemon
WHERE type != 'Fire';

# 16.
SELECT name
FROM Pokemon JOIN Evolution ON before_id = id
WHERE before_id > after_id
ORDER BY name;

# 17.
SELECT AVG(level)
FROM CatchedPokemon JOIN Pokemon ON pid = Pokemon.id
WHERE type = 'Water';

# 18.
WITH catched_by_leader (nickname, owner_id, level) AS (
	SELECT nickname, owner_id, level
	FROM CatchedPokemon JOIN Gym ON leader_id = owner_id
    )
SELECT nickname
FROM catched_by_leader
WHERE level = (
	SELECT MAX(level)
    FROM catched_by_leader
    );
    
# 19.
WITH trainer_catchedpokemon (trainer_id, name, avg_level) AS (
	SELECT Trainer.id, name, AVG(level)
    FROM CatchedPokemon JOIN Trainer ON owner_id = Trainer.id
    WHERE hometown = 'Blue City'
    GROUP BY Trainer.id
	)
SELECT name
FROM trainer_catchedpokemon
WHERE avg_level = (
	SELECT max(avg_level)
    FROM trainer_catchedpokemon
    )
ORDER BY name;

# 20.
SELECT Pokemon.name
FROM CatchedPokemon JOIN Pokemon JOIN (
	SELECT *
    FROM Trainer
    WHERE id NOT IN (
		SELECT DISTINCT A.id
        FROM Trainer as A JOIN Trainer as B ON A.id <> B.id
        WHERE A.hometown = B.hometown
        ) 
    ) AS alone_trainer
    ON owner_id = alone_trainer.id AND pid = Pokemon.id
WHERE type = 'Electric' AND Pokemon.id in (
	SELECT before_id
    FROM Evolution
    );
    
# 21.
SELECT name, SUM(level)
FROM Gym JOIN Trainer JOIN CatchedPokemon ON leader_id = Trainer.id AND Trainer.id = CatchedPokemon.id
GROUP BY Trainer.id
ORDER BY SUM(level) DESC;

# 22.
WITH hometown_cnt (hometown, cnt) AS (
	SELECT hometown, COUNT(id)
    FROM Trainer
    GROUP BY hometown
    )
SELECT hometown
FROM hometown_cnt
WHERE cnt = (
	SELECT MAX(cnt)
    FROM hometown_cnt
    );
    
# 23.
WITH sangnok_trainer_pokemon (id, name) AS (
	SELECT Pokemon.id, Pokemon.name
    FROM Trainer JOIN CatchedPokemon JOIN Pokemon ON Trainer.id = owner_id AND pid = Pokemon.id
    WHERE hometown = 'Sangnok City'
), 
brown_trainer_pokemon (id, name) AS (
	SELECT Pokemon.id, Pokemon.name
    FROM Trainer JOIN CatchedPokemon JOIN Pokemon ON Trainer.id = owner_id AND pid = Pokemon.id
    WHERE hometown = 'Brown City'
)
SELECT DISTINCT A.name
FROM sangnok_trainer_pokemon AS A, brown_trainer_pokemon AS B
WHERE A.id = B.id
ORDER BY A.name;

# 24.
SELECT name
FROM Trainer
WHERE id IN (
	SELECT DISTINCT Trainer.id
	FROM Pokemon JOIN CatchedPokemon JOIN Trainer ON owner_id = Trainer.id AND pid = Pokemon.id
	WHERE Pokemon.name LIKE 'P%' AND hometown = 'Sangnok City'
    )
ORDER BY name;

# 25.
SELECT Trainer.name, Pokemon.name
FROM Trainer JOIN CatchedPokemon JOIN Pokemon ON owner_id = Trainer.id AND pid = Pokemon.id
ORDER BY Trainer.name, Pokemon.name;

# 26.
SELECT name
FROM Pokemon
WHERE id IN (
    SELECT DISTINCT id
    FROM Pokemon JOIN Evolution ON id = before_id
    WHERE after_id NOT IN (
		SELECT before_id
        FROM Evolution
		)
    )
    AND id NOT IN (
		SELECT after_id
        FROM Evolution
        )
ORDER BY name;

# 27. 
SELECT nickname
FROM GYM JOIN Trainer JOIN CatchedPokemon JOIN Pokemon ON Pokemon.id = pid AND owner_id = Trainer.id AND Trainer.id = leader_id
WHERE city = 'Sangnok City' AND type = 'WATER'
ORDER BY nickname; 

# 28.
WITH A(name, cnt) AS (
	SELECT Trainer.name, COUNT(pid)
	FROM Trainer JOIN CatchedPokemon JOIN Pokemon ON owner_id = Trainer.id AND Pokemon.id = pid
    WHERE pid IN (
		SELECT after_id
		FROM Evolution
		)
    GROUP BY Trainer.id
    )
SELECT name
FROM A
WHERE cnt >= 3
ORDER BY name;

# 29.
SELECT name
FROM Pokemon
WHERE id NOT IN (
	SELECT DISTINCT pid
    FROM CatchedPokemon
    )
ORDER BY name;

# 30.
SELECT MAX(level)
FROM CatchedPokemon JOIN Trainer ON Trainer.id = owner_id
GROUP BY hometown
ORDER BY MAX(level) DESC;

# 31.
SELECT E.id, E.name, C.name, D.name
FROM Pokemon AS E JOIN Pokemon AS C JOIN Pokemon AS D JOIN Evolution AS A JOIN Evolution AS B ON A.before_id = E.id 
AND A.after_id = B.before_id AND C.id = A.after_id AND D.id = B.after_id
