CREATE TABLE sneakers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(400) NOT NULL,
  img_url TEXT,
  size INTEGER,
  price INTEGER
  -- type VARCHAR(200) NOT NULL
);

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  email VARCHAR(400) NOT NULL,
  password_digest VARCHAR(400),
  name VARCHAR(400) NOT NULL
);

CREATE TABLE comments (
  id SERIAL4 PRIMARY KEY,
  body TEXT,
  user_id INTEGER
);

-- ALTER TABLE comments ADD user_id INTEGER
