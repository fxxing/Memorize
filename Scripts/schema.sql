create table if not exists `word`(
	`id` integer primary key autoincrement,
	`kana` text,
	`japanese` text,
	`part_of_speech` text,
	`chinese` text,
	`sound` text,
	`list` integer
);

create table if not exists `learned`(
	`id` integer primary key autoincrement,
	`list` integer,
	`date` integer,
	`review` integer
);