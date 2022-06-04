-- Adminer 4.8.1 MySQL 8.0.28 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE DATABASE `vuvuzetlasql1` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `vuvuzetlasql1`;

DROP TABLE IF EXISTS `actions`;
CREATE TABLE `actions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `message_id` bigint unsigned NOT NULL,
  `uuid` varchar(100) NOT NULL,
  `value` tinyint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `actions` (`id`, `message_id`, `uuid`, `value`) VALUES
(1,	1,	'ffwrf33-42534r-324r4f234',	1),
(2,	1,	'ffwrf33-42534r-324r4f234',	1),
(3,	1,	'ffwrf33-42534r-324r4f234',	-1);

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `longitude` double NOT NULL,
  `latitude` double NOT NULL,
  `category` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `messages` (`id`, `uuid`, `username`, `message`, `longitude`, `latitude`, `category`) VALUES
(1,	'r4320-f42f42f-542f245f2',	'test',	'ceci est un message de test',	7.406033439637166,	47.283241532837934,	'NSFW');

-- 2022-03-19 09:10:19
