-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Erstellungszeit: 18. Sep 2025 um 19:10
-- Server-Version: 8.0.43
-- PHP-Version: 8.2.27

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
  `badge_id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `icon_url` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `Badge`
--

INSERT INTO `Badge` (`badge_id`, `name`, `description`, `icon_url`) VALUES
(1, 'test', 'test', 'https://cdn-icons-png.flaticon.com/512/5182/5182773.png'),
(2, 'test', 'test', 'https://cdn-icons-png.flaticon.com/512/5182/5182773.png');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Challenge`
--

CREATE TABLE `Challenge` (
  `challenge_id` int NOT NULL,
  `group_id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `target` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `end_date` date NOT NULL,
  `created_by` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Challenge_Participant`
--

CREATE TABLE `Challenge_Participant` (
  `challenge_id` int NOT NULL,
  `user_id` int NOT NULL,
  `total_progress` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Comment`
--

CREATE TABLE `Comment` (
  `comment_id` int NOT NULL,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Feed_Post`
--

CREATE TABLE `Feed_Post` (
  `post_id` int NOT NULL,
  `group_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Private_Group`
--

CREATE TABLE `Private_Group` (
  `group_id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_by` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `Private_Group_Member`
--

CREATE TABLE `Private_Group_Member` (
  `group_id` int NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `User`
--

CREATE TABLE `User` (
  `user_id` int NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `User_Badge`
--

CREATE TABLE `User_Badge` (
  `user_id` int NOT NULL,
  `badge_id` int NOT NULL
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
  MODIFY `badge_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT für Tabelle `Challenge`
--
ALTER TABLE `Challenge`
  MODIFY `challenge_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `Comment`
--
ALTER TABLE `Comment`
  MODIFY `comment_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT für Tabelle `Feed_Post`
--
ALTER TABLE `Feed_Post`
  MODIFY `post_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `Private_Group`
--
ALTER TABLE `Private_Group`
  MODIFY `group_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `User`
--
ALTER TABLE `User`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `Challenge`
--
ALTER TABLE `Challenge`
  ADD CONSTRAINT `challenge_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `Private_Group` (`group_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `challenge_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `User` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints der Tabelle `Challenge_Participant`
--
ALTER TABLE `Challenge_Participant`
  ADD CONSTRAINT `challenge_participant_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `Challenge` (`challenge_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `challenge_participant_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints der Tabelle `Comment`
--
ALTER TABLE `Comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `Feed_Post` (`post_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints der Tabelle `Feed_Post`
--
ALTER TABLE `Feed_Post`
  ADD CONSTRAINT `feed_post_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `Private_Group` (`group_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `feed_post_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints der Tabelle `Private_Group`
--
ALTER TABLE `Private_Group`
  ADD CONSTRAINT `private_group_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `User` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints der Tabelle `Private_Group_Member`
--
ALTER TABLE `Private_Group_Member`
  ADD CONSTRAINT `private_group_member_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `Private_Group` (`group_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `private_group_member_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints der Tabelle `User_Badge`
--
ALTER TABLE `User_Badge`
  ADD CONSTRAINT `user_badge_ibfk_1` FOREIGN KEY (`badge_id`) REFERENCES `Badge` (`badge_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `user_badge_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
