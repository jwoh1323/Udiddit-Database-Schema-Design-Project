-- Migrate usernames into “users”

WITH temp_usernames AS (
    SELECT DISTINCT username
    FROM "bad_posts"
    UNION ALL
    SELECT DISTINCT username
    FROM "bad_comments"
    UNION ALL
    SELECT DISTINCT regexp_split_to_table(upvotes, ',') as username
    FROM "bad_posts"
    UNION ALL
    SELECT DISTINCT regexp_split_to_table(downvotes, ',') as username
    FROM "bad_posts"
)
INSERT INTO "users" ("username")
SELECT DISTINCT username
FROM temp_usernames
ORDER BY username ASC;


-- Migrate the data into “topics”

INSERT INTO "topics" ("topic")
SELECT DISTINCT topic
FROM bad_posts;


-- Migrate the data into “posts”

INSERT INTO "posts" ("id", "title", "url", "text_content", "user_id", "topic_id")
SELECT
  bp.id,
  SUBSTRING(bp.title, 1, 100) AS title,
  bp.url,
  bp.text_content,
  u.id AS user_id,
  t.id AS topic_id
FROM "bad_posts" bp
INNER JOIN "users" u 
ON bp.username = u.username
INNER JOIN "topics" t 
ON bp.topic = t.topic_name;

-- Migrate the data into “comments”

INSERT INTO "comments" ("comment", "user_id", "post_id")
SELECT
  bc.text_content AS comment,
  u.id AS user_id,
  p.id AS post_id
FROM "bad_comments" bc 
INNER JOIN "posts" p 
ON bc.post_id = p.id 
INNER JOIN "users" u 
ON bc.username = u.username;


-- Migrate the data into “votes”

WITH downvote_ids AS (
  SELECT id, regexp_split_to_table(downvotes, ',') AS downvote
  FROM bad_posts
), upvote_ids AS (
  SELECT id, regexp_split_to_table(upvotes, ',') AS upvote
  FROM bad_posts
)
INSERT INTO votes ("vote", "user_id", "post_id")
SELECT 
 -1 AS vote
 u.id AS user_id,
 dv.id AS post_id,  
FROM downvote_ids dv
INNER JOIN users u 
ON u.username = dv.downvote
UNION ALL
SELECT 
 1 AS vote
 u.id AS user_id, 
 uv.id AS post_id, 
FROM upvote_ids uv
INNER JOIN users u 
ON u.username = uv.upvote;
