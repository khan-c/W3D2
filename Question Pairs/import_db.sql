DROP TABLE if exists users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(100) NOT NULL,
  lname VARCHAR(100) NOT NULL
);

DROP TABLE if exists questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE if exists question_follows;

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL
);

DROP TABLE if exists replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  reply_id INTEGER,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id)
);

DROP TABLE if exists question_likes;

CREATE TABLE question_likes(
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Jeff', 'Fiddler');

INSERT INTO
  users (fname, lname)
VALUES
  ('Haseeb', 'Qurashi');

INSERT INTO
  users (fname, lname)
VALUES
  ('Elliot', 'Humphrey');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('How do I do this?', 'What is sql and what is import_db.sql?', 1);

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('How do I do this again?', 'What is sql and what is import_db.sql?', 1);

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Where am I?', 'It''s dark and I can''t see. Help!', 2);

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('1 + 1?', 'I think it''s 3 but can someone double check?', 3);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 2);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (2, 2);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (3, 1);

INSERT INTO
  replies (user_id, question_id, reply_id, body)
VALUES
  (1, 1, NULL, 'Im a reply');

INSERT INTO
  replies (user_id, question_id, reply_id, body)
VALUES
  (1, 1, 1, 'Im also a reply');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 1);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (2, 1);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (3, 1);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (3, 3);
