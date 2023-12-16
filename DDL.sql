CREATE TABLE "users" (

"id" SERIAL PRIMARY KEY,
"username" VARCHAR(25) UNIQUE NOT NULL,
"login_date" TIMESTAMP,
CONSTRAINT "check_username_empty" CHECK(LENGTH(TRIM(“username”))>0) 

);

-- 2.c.Find a user by their username

CREATE INDEX "find_username" ON "users" ("username" VARCHAR_PATTERN_OPS);

-- 2.a.List all users who haven’t logged in in the last year

CREATE INDEX "find_login" ON "users" ("login_date");

CREATE TABLE "topics" (

"id" SERIAL PRIMARY KEY,
"topic" VARCHAR(30) UNIQUE NOT NULL,
"description" VARCHAR(500),
CONSTRAINT "check_topic_empty" CHECK(LENGTH(TRIM("topic"))>0) 

);

-- 2.e.Find a topic by its name

CREATE INDEX "find_topic" ON "topics" ("topic");

CREATE TABLE "posts" (

"id" SERIAL PRIMARY KEY,
"title" VARCHAR(100),
"url" TEXT,
"text_content" TEXT,
"post_date" TIMESTAMP,
"user_id" INTEGER REFERENCES "users" ON DELETE SET NULL,
"topic_id" INTEGER REFERENCES "topics" ON DELETE CASCADE,
CONSTRAINT "check_title_empty" CHECK(LENGTH(TRIM("title"))>0),
CONSTRAINT "url_or_text" CHECK((("url") IS NULL AND ("text_content") IS NOT NULL) OR (("url") IS NOT NULL AND ("text_content") IS NULL))

);


-- 2.b.List all users who haven’t created any post

CREATE INDEX "find_user_id" ON "posts" ("user_id");

-- 2.d.List all topics that don’t have any posts.

CREATE INDEX "find_topic_id" ON "posts" ("topic_id");

-- 2.f.List the latest 20 posts for a given topic.

CREATE INDEX "find_latest_by_topic" ON "posts" ("id", "post_date", "topic_id");

-- 2. g.List the latest 20 posts made by a given user.

CREATE INDEX "find_latest_by_user" ON "posts" ("id", "post_date", "user_id");

-- 2. h.Find all posts that link to a specific URL, for moderation purposes.

CREATE INDEX "find_posts_by_URL" ON "posts" ("id", "url");


CREATE TABLE "comments" (

"id" SERIAL PRIMARY KEY,
"comment" TEXT NOT NULL,
"parent_id" INTEGER REFERENCES "comments" ON DELETE CASCADE,
"user_id" INTEGER REFERENCES "users" ON DELETE SET NULL,
"post_id" INTEGER REFERENCES "posts" ON DELETE CASCADE,
"comment_date" TIMESTAMP,
CONSTRAINT "check_comment_empty" CHECK(LENGTH(TRIM("comment"))>0) 

);


-- 2. i.List all the top-level comments (those that don’t have a parent comment) for a given post.

CREATE INDEX "find_comment_by_post" ON "comments" ("id", "parent_id", "post_id");

-- 2. j.List all the direct children of a parent comment.

CREATE INDEX "find_direct_children" ON "comments" ("id", "parent_id");

-- 2. k.List the latest 20 comments made by a given user.

CREATE INDEX "find_latest_comments" ON "comments" ("id", "comment_date", "user_id");

CREATE TABLE "votes" (

"id" SERIAL PRIMARY KEY,
"vote" INTEGER,
"user_id" INTEGER REFERENCES "users" ON DELETE SET NULL,
"post_id" INTEGER REFERENCES "posts" ON DELETE CASCADE,
CONSTRAINT "check_vote" CHECK ("vote" = 1 OR "vote" = -1)

);

-- 2. l.Compute the score of a post, defined as the difference between the number of upvotes and the number of downvotes

CREATE INDEX "compute_post_score" ON "votes" ("post_id", "vote");

