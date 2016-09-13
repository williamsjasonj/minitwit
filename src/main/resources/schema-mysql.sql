create table IF NOT EXISTS user (
  user_id integer UNSIGNED NOT NULL AUTO_INCREMENT primary key,
  username varchar(50) not null,
  email varchar(50) not null,
  pw varchar(255) not null
) AUTO_INCREMENT = 100;

create table IF NOT EXISTS follower (
  follower_id integer,
  followee_id integer
);

create table IF NOT EXISTS message (
  message_id integer UNSIGNED NOT NULL AUTO_INCREMENT primary key,
  author_id integer not null,
  text varchar(160) not null,
  pub_date timestamp
) AUTO_INCREMENT = 100;
