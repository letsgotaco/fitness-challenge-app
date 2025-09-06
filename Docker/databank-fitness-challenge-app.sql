-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Erstellungszeit: 06. Sep 2025 um 22:49
-- Server-Version: 10.4.28-MariaDB
-- PHP-Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `databank-fitness-challenge-app`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Badge`
--

CREATE TABLE `Badge` (
  `badge_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `icon_url` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Challenge`
--

CREATE TABLE `Challenge` (
  `challenge_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `target` varchar(255) NOT NULL,
  `end_date` date NOT NULL,
  `created_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Challenge_Participant`
--

CREATE TABLE `Challenge_Participant` (
  `challenge_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total_progress` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Comment`
--

CREATE TABLE `Comment` (
  `comment_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Feed_Post`
--

CREATE TABLE `Feed_Post` (
  `post_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Private_Group`
--

CREATE TABLE `Private_Group` (
  `group_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `created_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Private_Group_Member`
--

CREATE TABLE `Private_Group_Member` (
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Progress`
--

CREATE TABLE `Progress` (
  `Progress_id` int(11) NOT NULL,
  `challenge_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `value` varchar(255) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `User`
--

CREATE TABLE `User` (
  `user_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `User_Badge`
--

CREATE TABLE `User_Badge` (
  `user_id` int(11) NOT NULL,
  `badge_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `Badge`
--
ALTER TABLE `Badge`
  ADD PRIMARY KEY (`badge_id`);

--
-- Indizes für die Tabelle `Challenge`
--
ALTER TABLE `Challenge`
  ADD PRIMARY KEY (`challenge_id`),
  ADD KEY `group_id` (`group_id`,`created_by`),
  ADD KEY `created_by` (`created_by`);

--
-- Indizes für die Tabelle `Challenge_Participant`
--
ALTER TABLE `Challenge_Participant`
  ADD PRIMARY KEY (`challenge_id`,`user_id`),
  ADD KEY `challenge_id` (`challenge_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indizes für die Tabelle `Comment`
--
ALTER TABLE `Comment`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `post_id` (`post_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indizes für die Tabelle `Feed_Post`
--
ALTER TABLE `Feed_Post`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `group_id` (`group_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indizes für die Tabelle `Private_Group`
--
ALTER TABLE `Private_Group`
  ADD PRIMARY KEY (`group_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indizes für die Tabelle `Private_Group_Member`
--
ALTER TABLE `Private_Group_Member`
  ADD PRIMARY KEY (`group_id`,`user_id`),
  ADD KEY `group_id` (`group_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indizes für die Tabelle `Progress`
--
ALTER TABLE `Progress`
  ADD PRIMARY KEY (`Progress_id`),
  ADD KEY `challenge_id` (`challenge_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indizes für die Tabelle `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`user_id`);

--
-- Indizes für die Tabelle `User_Badge`
--
ALTER TABLE `User_Badge`
  ADD PRIMARY KEY (`user_id`,`badge_id`),
  ADD KEY `user_id` (`user_id`,`badge_id`),
  ADD KEY `badge_id` (`badge_id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `Badge`
--
ALTER TABLE `Badge`
  MODIFY `badge_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `Challenge`
--
ALTER TABLE `Challenge`
  MODIFY `challenge_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `Comment`
--
ALTER TABLE `Comment`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `Feed_Post`
--
ALTER TABLE `Feed_Post`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `Private_Group`
--
ALTER TABLE `Private_Group`
  MODIFY `group_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `Progress`
--
ALTER TABLE `Progress`
  MODIFY `Progress_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `User`
--
ALTER TABLE `User`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `Challenge`
--
ALTER TABLE `Challenge`
  ADD CONSTRAINT `challenge_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `Private_Group` (`group_id`),
  ADD CONSTRAINT `challenge_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `User` (`user_id`);

--
-- Constraints der Tabelle `Challenge_Participant`
--
ALTER TABLE `Challenge_Participant`
  ADD CONSTRAINT `challenge_participant_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `Challenge` (`challenge_id`),
  ADD CONSTRAINT `challenge_participant_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`);

--
-- Constraints der Tabelle `Comment`
--
ALTER TABLE `Comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `Feed_Post` (`post_id`),
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`);

--
-- Constraints der Tabelle `Feed_Post`
--
ALTER TABLE `Feed_Post`
  ADD CONSTRAINT `feed_post_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `Private_Group` (`group_id`),
  ADD CONSTRAINT `feed_post_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`);

--
-- Constraints der Tabelle `Private_Group`
--
ALTER TABLE `Private_Group`
  ADD CONSTRAINT `private_group_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `User` (`user_id`);

--
-- Constraints der Tabelle `Private_Group_Member`
--
ALTER TABLE `Private_Group_Member`
  ADD CONSTRAINT `private_group_member_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `Private_Group` (`group_id`),
  ADD CONSTRAINT `private_group_member_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`);

--
-- Constraints der Tabelle `Progress`
--
ALTER TABLE `Progress`
  ADD CONSTRAINT `progress_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `Challenge` (`challenge_id`),
  ADD CONSTRAINT `progress_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`);

--
-- Constraints der Tabelle `User_Badge`
--
ALTER TABLE `User_Badge`
  ADD CONSTRAINT `user_badge_ibfk_1` FOREIGN KEY (`badge_id`) REFERENCES `Badge` (`badge_id`),
  ADD CONSTRAINT `user_badge_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
