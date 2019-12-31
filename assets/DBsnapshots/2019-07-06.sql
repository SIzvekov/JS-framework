-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 07, 2019 at 05:15 AM
-- Server version: 5.6.35
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `football_project`
--

-- --------------------------------------------------------

--
-- Table structure for table `api_sessions`
--

CREATE TABLE `api_sessions` (
  `id` varchar(36) NOT NULL,
  `api_users_id` varchar(36) NOT NULL,
  `api_token` varchar(255) NOT NULL,
  `date_start` datetime NOT NULL,
  `date_last_use` datetime DEFAULT NULL,
  `date_expire` datetime DEFAULT NULL,
  `user_ip` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `api_users`
--

CREATE TABLE `api_users` (
  `id` varchar(36) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_active` smallint(1) NOT NULL DEFAULT '1',
  `api_secret` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leagues`
--

CREATE TABLE `leagues` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `tag` varchar(255) DEFAULT NULL,
  `active` enum('0','1') NOT NULL DEFAULT '0',
  `Record_Creation_Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `leagues`
--

INSERT INTO `leagues` (`id`, `name`, `url`, `tag`, `active`, `Record_Creation_Date`) VALUES
('0411ea90-9094-11e9-8306-5e26a4c3e32c', 'Playas', 'playas', 'Liga in playas de tijuana', '1', '2019-06-17 00:08:20');

-- --------------------------------------------------------

--
-- Table structure for table `league_config`
--

CREATE TABLE `league_config` (
  `id` varchar(36) NOT NULL,
  `league_id` varchar(36) NOT NULL,
  `param_key` varchar(255) NOT NULL,
  `param_value` varchar(255) DEFAULT NULL,
  `Record_Creation_Date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `league_config`
--

INSERT INTO `league_config` (`id`, `league_id`, `param_key`, `param_value`, `Record_Creation_Date`) VALUES
('', '0411ea90-9094-11e9-8306-5e26a4c3e32c', 'header_title', 'Тестовая лига', '2019-06-22 17:12:49'),
('0422a0e0-954b-11e9-89f9-fb63fece11e7', '0411ea90-9094-11e9-8306-5e26a4c3e32c', 'facebook_url', 'https://www.facebook.com/SergeyIzvekov', '2019-06-22 17:05:10');

-- --------------------------------------------------------

--
-- Table structure for table `league_season_sportsday`
--

CREATE TABLE `league_season_sportsday` (
  `id` varchar(36) NOT NULL,
  `league_id` varchar(36) NOT NULL,
  `season_id` varchar(36) NOT NULL,
  `title` varchar(255) NOT NULL,
  `sort` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `Record_Creation_Date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `league_season_sportsday`
--

INSERT INTO `league_season_sportsday` (`id`, `league_id`, `season_id`, `title`, `sort`, `Record_Creation_Date`) VALUES
('0631e574-9601-11e9-89f9-fb63fece11e7', '0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', 'Jornada #14', 14, '2019-06-17 21:52:11'),
('112e237a-9601-11e9-89f9-fb63fece11e7', '0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', 'Jornada #15', 15, '2019-06-17 21:52:12'),
('d4b7ce62-9184-11e9-8306-5e26a4c3e32c', '0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', 'Jornada #13', 13, '2019-06-17 21:52:10');

-- --------------------------------------------------------

--
-- Table structure for table `league_season_sportsday_game`
--

CREATE TABLE `league_season_sportsday_game` (
  `id` varchar(36) NOT NULL,
  `sportsday_id` varchar(36) NOT NULL,
  `datetime` int(11) NOT NULL,
  `team1_id` varchar(36) NOT NULL,
  `team1_score` smallint(6) DEFAULT NULL,
  `team2_id` varchar(36) NOT NULL,
  `team2_score` smallint(6) DEFAULT NULL,
  `status` enum('scheduled','canceled','completed') NOT NULL DEFAULT 'scheduled',
  `Record_Creation_Date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `league_season_sportsday_game`
--

INSERT INTO `league_season_sportsday_game` (`id`, `sportsday_id`, `datetime`, `team1_id`, `team1_score`, `team2_id`, `team2_score`, `status`, `Record_Creation_Date`) VALUES
('5257ad42-9185-11e9-8306-5e26a4c3e32c', 'd4b7ce62-9184-11e9-8306-5e26a4c3e32c', 1562467899, '540c78c8-9097-11e9-8306-5e26a4c3e32c', 1, '5411d98a-9097-11e9-8306-5e26a4c3e32c', 5, 'completed', '2019-06-17 21:55:40'),
('7a81f034-9608-11e9-89f9-fb63fece11e7', '0631e574-9601-11e9-89f9-fb63fece11e7', 1562467899, '540e1066-9097-11e9-8306-5e26a4c3e32c', 4, '5404045e-9097-11e9-8306-5e26a4c3e32c', 2, 'completed', '2019-06-17 21:55:40'),
('92d366b4-9607-11e9-89f9-fb63fece11e7', '0631e574-9601-11e9-89f9-fb63fece11e7', 1562467899, '540a0ec6-9097-11e9-8306-5e26a4c3e32c', 1, '540758f2-9097-11e9-8306-5e26a4c3e32c', 0, 'completed', '2019-06-17 21:55:40'),
('a3758b1e-9607-11e9-89f9-fb63fece11e7', '112e237a-9601-11e9-89f9-fb63fece11e7', 1563168000, '326b4c4e-9097-11e9-8306-5e26a4c3e32c', NULL, '540880f6-9097-11e9-8306-5e26a4c3e32c', NULL, 'scheduled', '2019-06-17 21:55:40');

-- --------------------------------------------------------

--
-- Table structure for table `league_season_sportsday_game_details`
--

CREATE TABLE `league_season_sportsday_game_details` (
  `id` varchar(36) NOT NULL,
  `game_id` varchar(36) NOT NULL,
  `team_id` varchar(36) NOT NULL,
  `player_id` varchar(36) NOT NULL,
  `player2_id` varchar(36) DEFAULT NULL,
  `time` varchar(255) NOT NULL,
  `type` enum('score','fault','change') DEFAULT NULL,
  `subtype` enum('autogoal','penalty','yellowcard','secondyellowcard','redcard','default') NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `sort` smallint(6) NOT NULL DEFAULT '0',
  `Record_Creation_Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `league_season_sportsday_game_details`
--

INSERT INTO `league_season_sportsday_game_details` (`id`, `game_id`, `team_id`, `player_id`, `player2_id`, `time`, `type`, `subtype`, `note`, `sort`, `Record_Creation_Date`) VALUES
('338cd6ea-a061-11e9-b7e1-867cdcdaaeda', '7a81f034-9608-11e9-89f9-fb63fece11e7', '5404045e-9097-11e9-8306-5e26a4c3e32c', '1c4b9592-9540-11e9-89f9-fb63fece11e7', NULL, '35\'30\'\'', 'score', 'default', NULL, 0, '2019-07-07 08:46:25'),
('338d2d7a-a061-11e9-b7e1-867cdcdaaeda', '7a81f034-9608-11e9-89f9-fb63fece11e7', '5404045e-9097-11e9-8306-5e26a4c3e32c', '1c4b9592-9540-11e9-89f9-fb63fece11e7', '7189a6f6-953c-11e9-89f9-fb63fece11e7', '115', 'change', 'default', NULL, 5, '2019-07-07 08:46:25'),
('338d32d4-a061-11e9-b7e1-867cdcdaaeda', '7a81f034-9608-11e9-89f9-fb63fece11e7', '5404045e-9097-11e9-8306-5e26a4c3e32c', '7189a6f6-953c-11e9-89f9-fb63fece11e7', NULL, '56', 'score', 'penalty', NULL, 2, '2019-07-07 08:46:25'),
('338d363a-a061-11e9-b7e1-867cdcdaaeda', '7a81f034-9608-11e9-89f9-fb63fece11e7', '5404045e-9097-11e9-8306-5e26a4c3e32c', '1c4b9592-9540-11e9-89f9-fb63fece11e7', NULL, '90+2', 'score', 'autogoal', NULL, 4, '2019-07-07 08:46:25'),
('338d398c-a061-11e9-b7e1-867cdcdaaeda', '7a81f034-9608-11e9-89f9-fb63fece11e7', '5404045e-9097-11e9-8306-5e26a4c3e32c', '7189a6f6-953c-11e9-89f9-fb63fece11e7', NULL, '38', 'fault', 'yellowcard', NULL, 1, '2019-07-07 08:46:25'),
('338d3d06-a061-11e9-b7e1-867cdcdaaeda', '7a81f034-9608-11e9-89f9-fb63fece11e7', '5404045e-9097-11e9-8306-5e26a4c3e32c', '1c4b9592-9540-11e9-89f9-fb63fece11e7', NULL, '90+4', 'fault', 'redcard', NULL, 5, '2019-07-07 08:46:25'),
('338d401c-a061-11e9-b7e1-867cdcdaaeda', '7a81f034-9608-11e9-89f9-fb63fece11e7', '5404045e-9097-11e9-8306-5e26a4c3e32c', '7189a6f6-953c-11e9-89f9-fb63fece11e7', NULL, '76', 'fault', 'secondyellowcard', NULL, 3, '2019-07-07 08:46:25'),
('39ce1954-a059-11e9-b7e1-867cdcdaaeda', '92d366b4-9607-11e9-89f9-fb63fece11e7', '540a0ec6-9097-11e9-8306-5e26a4c3e32c', '1c4b9592-9540-11e9-89f9-fb63fece11e7', NULL, '35\'30\'\'', 'score', 'default', NULL, 0, '2019-07-07 01:46:25'),
('8151e416-a060-11e9-b7e1-867cdcdaaeda', '92d366b4-9607-11e9-89f9-fb63fece11e7', '540a0ec6-9097-11e9-8306-5e26a4c3e32c', '1c4b9592-9540-11e9-89f9-fb63fece11e7', '7189a6f6-953c-11e9-89f9-fb63fece11e7', '115', 'change', 'default', NULL, 5, '2019-07-07 01:46:25'),
('c5f231a8-a05f-11e9-b7e1-867cdcdaaeda', '92d366b4-9607-11e9-89f9-fb63fece11e7', '540a0ec6-9097-11e9-8306-5e26a4c3e32c', '7189a6f6-953c-11e9-89f9-fb63fece11e7', NULL, '56', 'score', 'penalty', NULL, 2, '2019-07-07 01:46:25'),
('d0010822-a05f-11e9-b7e1-867cdcdaaeda', '92d366b4-9607-11e9-89f9-fb63fece11e7', '540a0ec6-9097-11e9-8306-5e26a4c3e32c', '1c4b9592-9540-11e9-89f9-fb63fece11e7', NULL, '90+2', 'score', 'autogoal', NULL, 4, '2019-07-07 01:46:25'),
('f1c7c49c-a05e-11e9-b7e1-867cdcdaaeda', '92d366b4-9607-11e9-89f9-fb63fece11e7', '540a0ec6-9097-11e9-8306-5e26a4c3e32c', '7189a6f6-953c-11e9-89f9-fb63fece11e7', NULL, '38', 'fault', 'yellowcard', NULL, 1, '2019-07-07 01:46:25'),
('f201a256-a05f-11e9-b7e1-867cdcdaaeda', '92d366b4-9607-11e9-89f9-fb63fece11e7', '540a0ec6-9097-11e9-8306-5e26a4c3e32c', '1c4b9592-9540-11e9-89f9-fb63fece11e7', NULL, '90+4', 'fault', 'redcard', NULL, 5, '2019-07-07 01:46:25'),
('fae3fb72-a05e-11e9-b7e1-867cdcdaaeda', '92d366b4-9607-11e9-89f9-fb63fece11e7', '540a0ec6-9097-11e9-8306-5e26a4c3e32c', '7189a6f6-953c-11e9-89f9-fb63fece11e7', NULL, '76', 'fault', 'secondyellowcard', NULL, 3, '2019-07-07 01:46:25');

-- --------------------------------------------------------

--
-- Table structure for table `league_season_tableInfo`
--

CREATE TABLE `league_season_tableInfo` (
  `league_id` varchar(36) NOT NULL,
  `season_id` varchar(36) NOT NULL,
  `team_id` varchar(36) NOT NULL,
  `gp` smallint(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Games played',
  `gw` smallint(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Games won',
  `gt` smallint(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Games tied',
  `gl` smallint(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Games lost',
  `pa` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Points manual adjustment',
  `gs` smallint(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Goals Scored',
  `gr` smallint(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Goals Received',
  `score` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Score',
  `position` smallint(6) NOT NULL DEFAULT '999',
  `active` enum('0','1') NOT NULL DEFAULT '0',
  `Record_Creation_Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `league_season_tableInfo`
--

INSERT INTO `league_season_tableInfo` (`league_id`, `season_id`, `team_id`, `gp`, `gw`, `gt`, `gl`, `pa`, `gs`, `gr`, `score`, `position`, `active`, `Record_Creation_Date`) VALUES
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '326b4c4e-9097-11e9-8306-5e26a4c3e32c', 19, 17, 1, 1, 0, 98, 13, 52, 1, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '54018a30-9097-11e9-8306-5e26a4c3e32c', 19, 15, 4, 0, 0, 75, 13, 49, 2, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '5404045e-9097-11e9-8306-5e26a4c3e32c', 18, 14, 1, 3, 0, 67, 22, 43, 3, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '5405b736-9097-11e9-8306-5e26a4c3e32c', 19, 11, 3, 5, 0, 47, 24, 36, 4, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540758f2-9097-11e9-8306-5e26a4c3e32c', 19, 11, 2, 6, -2, 59, 33, 33, 5, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540880f6-9097-11e9-8306-5e26a4c3e32c', 19, 10, 2, 7, 0, 29, 36, 32, 6, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540a0ec6-9097-11e9-8306-5e26a4c3e32c', 20, 9, 4, 7, 0, 28, 31, 31, 7, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540b3f08-9097-11e9-8306-5e26a4c3e32c', 18, 8, 1, 9, 0, 32, 42, 25, 9, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540c78c8-9097-11e9-8306-5e26a4c3e32c', 19, 9, 0, 10, -1, 39, 62, 26, 8, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540e1066-9097-11e9-8306-5e26a4c3e32c', 18, 7, 2, 9, -1, 27, 27, 22, 10, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540f5d22-9097-11e9-8306-5e26a4c3e32c', 15, 6, 1, 8, 0, 21, 37, 19, 11, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '54109b9c-9097-11e9-8306-5e26a4c3e32c', 20, 2, 2, 16, -1, 14, 67, 7, 12, '1', '2019-06-17 00:36:14'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '5411d98a-9097-11e9-8306-5e26a4c3e32c', 19, 1, 1, 17, -3, 15, 87, 1, 13, '1', '2019-06-17 00:36:14');

-- --------------------------------------------------------

--
-- Table structure for table `league_season_teams`
--

CREATE TABLE `league_season_teams` (
  `league_id` varchar(36) NOT NULL,
  `season_id` varchar(36) NOT NULL,
  `team_id` varchar(36) NOT NULL,
  `active` enum('0','1') NOT NULL DEFAULT '0',
  `Record_Creation_Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `league_season_teams`
--

INSERT INTO `league_season_teams` (`league_id`, `season_id`, `team_id`, `active`, `Record_Creation_Date`) VALUES
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '326b4c4e-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:33:33'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '54018a30-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '5404045e-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '5405b736-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540758f2-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540880f6-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540a0ec6-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540b3f08-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540c78c8-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540e1066-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '540f5d22-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '54109b9c-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56'),
('0411ea90-9094-11e9-8306-5e26a4c3e32c', '131d6848-9094-11e9-8306-5e26a4c3e32c', '5411d98a-9097-11e9-8306-5e26a4c3e32c', '1', '2019-06-17 00:34:56');

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `id` varchar(36) NOT NULL,
  `api_user_id` varchar(36) DEFAULT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `active` enum('0','1') NOT NULL DEFAULT '0',
  `Record_Creation_Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `api_user_id`, `first_name`, `last_name`, `active`, `Record_Creation_Date`) VALUES
('1c4b9592-9540-11e9-89f9-fb63fece11e7', NULL, 'Miguel', 'Gaitan', '1', '2019-06-22 22:50:19'),
('7189a6f6-953c-11e9-89f9-fb63fece11e7', NULL, 'Sergey', 'Izvekov', '1', '2019-06-22 22:24:04');

-- --------------------------------------------------------

--
-- Table structure for table `seasons`
--

CREATE TABLE `seasons` (
  `id` varchar(36) NOT NULL,
  `league_id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `current` enum('0','1') NOT NULL DEFAULT '0',
  `active` enum('0','1') NOT NULL DEFAULT '0',
  `Record_Creation_Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `seasons`
--

INSERT INTO `seasons` (`id`, `league_id`, `name`, `current`, `active`, `Record_Creation_Date`) VALUES
('131d6848-9094-11e9-8306-5e26a4c3e32c', '0411ea90-9094-11e9-8306-5e26a4c3e32c', 'Copa Playas 2019', '1', '1', '2019-06-17 00:08:46');

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `active` enum('0','1') NOT NULL DEFAULT '0',
  `Record_Creation_Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`id`, `name`, `active`, `Record_Creation_Date`) VALUES
('326b4c4e-9097-11e9-8306-5e26a4c3e32c', 'Clinica Nueva TJ', '1', '2019-06-17 00:31:07'),
('54018a30-9097-11e9-8306-5e26a4c3e32c', 'Vagos FC', '1', '2019-06-17 00:32:03'),
('5404045e-9097-11e9-8306-5e26a4c3e32c', 'Laureles City', '1', '2019-06-17 00:32:03'),
('5405b736-9097-11e9-8306-5e26a4c3e32c', 'Primos FC', '1', '2019-06-17 00:32:03'),
('540758f2-9097-11e9-8306-5e26a4c3e32c', 'Atletico Tijuana', '1', '2019-06-17 00:32:03'),
('540880f6-9097-11e9-8306-5e26a4c3e32c', 'Chelsea FC', '1', '2019-06-17 00:32:03'),
('540a0ec6-9097-11e9-8306-5e26a4c3e32c', 'Aztec\'s FC', '1', '2019-06-17 00:32:03'),
('540b3f08-9097-11e9-8306-5e26a4c3e32c', 'Minerva FC', '1', '2019-06-17 00:32:03'),
('540c78c8-9097-11e9-8306-5e26a4c3e32c', 'Playas LM', '1', '2019-06-17 00:32:03'),
('540e1066-9097-11e9-8306-5e26a4c3e32c', 'Bayern Munich', '1', '2019-06-17 00:32:03'),
('540f5d22-9097-11e9-8306-5e26a4c3e32c', 'De La Fuente FC', '1', '2019-06-17 00:32:03'),
('54109b9c-9097-11e9-8306-5e26a4c3e32c', 'P S V', '1', '2019-06-17 00:32:03'),
('5411d98a-9097-11e9-8306-5e26a4c3e32c', 'FC Cardenas', '1', '2019-06-17 00:32:03');

-- --------------------------------------------------------

--
-- Table structure for table `team_players`
--

CREATE TABLE `team_players` (
  `team_id` varchar(36) NOT NULL,
  `player_id` varchar(36) NOT NULL,
  `position` varchar(36) DEFAULT NULL,
  `number` smallint(6) DEFAULT NULL,
  `captain` enum('0','1') NOT NULL DEFAULT '0',
  `active` enum('0','1') NOT NULL DEFAULT '0',
  `Record_Creation_Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `team_players`
--

INSERT INTO `team_players` (`team_id`, `player_id`, `position`, `number`, `captain`, `active`, `Record_Creation_Date`) VALUES
('540c78c8-9097-11e9-8306-5e26a4c3e32c', '1c4b9592-9540-11e9-89f9-fb63fece11e7', 'defense', 10, '1', '1', '2019-06-22 22:25:34'),
('540c78c8-9097-11e9-8306-5e26a4c3e32c', '7189a6f6-953c-11e9-89f9-fb63fece11e7', 'goalkeeper', 1, '0', '1', '2019-06-22 22:25:34');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `api_sessions`
--
ALTER TABLE `api_sessions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `api_users`
--
ALTER TABLE `api_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `leagues`
--
ALTER TABLE `leagues`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `league_config`
--
ALTER TABLE `league_config`
  ADD PRIMARY KEY (`id`),
  ADD KEY `league_config_fk0` (`league_id`);

--
-- Indexes for table `league_season_sportsday`
--
ALTER TABLE `league_season_sportsday`
  ADD PRIMARY KEY (`id`),
  ADD KEY `league_season_sportsday_fk0` (`season_id`),
  ADD KEY `league_season_sportsday_fk1` (`league_id`);

--
-- Indexes for table `league_season_sportsday_game`
--
ALTER TABLE `league_season_sportsday_game`
  ADD PRIMARY KEY (`id`),
  ADD KEY `league_season_sportsday_game_fk0` (`team1_id`),
  ADD KEY `league_season_sportsday_game_fk1` (`team2_id`),
  ADD KEY `league_season_sportsday_game_fk2` (`sportsday_id`);

--
-- Indexes for table `league_season_sportsday_game_details`
--
ALTER TABLE `league_season_sportsday_game_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `league_season_sportsday_game_details_fk0` (`game_id`),
  ADD KEY `league_season_sportsday_game_details_fk1` (`team_id`),
  ADD KEY `league_season_sportsday_game_details_fk2` (`player_id`),
  ADD KEY `league_season_sportsday_game_details_fk3` (`player2_id`);

--
-- Indexes for table `league_season_tableInfo`
--
ALTER TABLE `league_season_tableInfo`
  ADD PRIMARY KEY (`league_id`,`season_id`,`team_id`),
  ADD KEY `league_season_tableInfo_fk0` (`team_id`),
  ADD KEY `league_season_tableInfo_fk1` (`season_id`);

--
-- Indexes for table `league_season_teams`
--
ALTER TABLE `league_season_teams`
  ADD PRIMARY KEY (`league_id`,`season_id`,`team_id`),
  ADD KEY `league_season_teams_fk0` (`team_id`),
  ADD KEY `league_season_teams_fk1` (`season_id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `seasons`
--
ALTER TABLE `seasons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `seasons_fk0` (`league_id`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `team_players`
--
ALTER TABLE `team_players`
  ADD PRIMARY KEY (`team_id`,`player_id`),
  ADD KEY `team_players_fk1` (`player_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `league_config`
--
ALTER TABLE `league_config`
  ADD CONSTRAINT `league_config_fk0` FOREIGN KEY (`league_id`) REFERENCES `leagues` (`id`);

--
-- Constraints for table `league_season_sportsday`
--
ALTER TABLE `league_season_sportsday`
  ADD CONSTRAINT `league_season_sportsday_fk0` FOREIGN KEY (`season_id`) REFERENCES `seasons` (`id`),
  ADD CONSTRAINT `league_season_sportsday_fk1` FOREIGN KEY (`league_id`) REFERENCES `leagues` (`id`);

--
-- Constraints for table `league_season_sportsday_game`
--
ALTER TABLE `league_season_sportsday_game`
  ADD CONSTRAINT `league_season_sportsday_game_fk0` FOREIGN KEY (`team1_id`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `league_season_sportsday_game_fk1` FOREIGN KEY (`team2_id`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `league_season_sportsday_game_fk2` FOREIGN KEY (`sportsday_id`) REFERENCES `league_season_sportsday` (`id`);

--
-- Constraints for table `league_season_sportsday_game_details`
--
ALTER TABLE `league_season_sportsday_game_details`
  ADD CONSTRAINT `league_season_sportsday_game_details_fk0` FOREIGN KEY (`game_id`) REFERENCES `league_season_sportsday_game` (`id`),
  ADD CONSTRAINT `league_season_sportsday_game_details_fk1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `league_season_sportsday_game_details_fk2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`),
  ADD CONSTRAINT `league_season_sportsday_game_details_fk3` FOREIGN KEY (`player2_id`) REFERENCES `players` (`id`);

--
-- Constraints for table `league_season_tableInfo`
--
ALTER TABLE `league_season_tableInfo`
  ADD CONSTRAINT `league_season_tableInfo_fk0` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `league_season_tableInfo_fk1` FOREIGN KEY (`season_id`) REFERENCES `seasons` (`id`),
  ADD CONSTRAINT `league_season_tableInfo_fk2` FOREIGN KEY (`league_id`) REFERENCES `leagues` (`id`);

--
-- Constraints for table `league_season_teams`
--
ALTER TABLE `league_season_teams`
  ADD CONSTRAINT `league_season_teams_fk0` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `league_season_teams_fk1` FOREIGN KEY (`season_id`) REFERENCES `seasons` (`id`),
  ADD CONSTRAINT `league_season_teams_fk2` FOREIGN KEY (`league_id`) REFERENCES `leagues` (`id`);

--
-- Constraints for table `seasons`
--
ALTER TABLE `seasons`
  ADD CONSTRAINT `seasons_fk0` FOREIGN KEY (`league_id`) REFERENCES `leagues` (`id`);

--
-- Constraints for table `team_players`
--
ALTER TABLE `team_players`
  ADD CONSTRAINT `team_players_fk0` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `team_players_fk1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
