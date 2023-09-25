CREATE DATABASE  IF NOT EXISTS `ssgg` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ssgg`;
-- MySQL dump 10.13  Distrib 8.0.34, for macos13 (arm64)
--
-- Host: 127.0.0.1    Database: ssgg
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `age_groups`
--

DROP TABLE IF EXISTS `age_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `age_groups` (
  `age_group_id` int NOT NULL AUTO_INCREMENT,
  `age_group_name_en` varchar(255) DEFAULT NULL,
  `age_group_name_ar` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`age_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance` (
  `attendance_id` int NOT NULL AUTO_INCREMENT,
  `member_id` varchar(45) NOT NULL,
  `event_id` int NOT NULL,
  `attendance_state_id` int DEFAULT NULL,
  PRIMARY KEY (`attendance_id`),
  KEY `attendance_attendance_state_idx` (`attendance_state_id`),
  KEY `attendance_member_idx` (`member_id`),
  KEY `attendance_event_idx` (`event_id`),
  CONSTRAINT `attendance_attendance_state` FOREIGN KEY (`attendance_state_id`) REFERENCES `attendance_states` (`attendance_state_id`),
  CONSTRAINT `attendance_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`),
  CONSTRAINT `attendance_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attendance_states`
--

DROP TABLE IF EXISTS `attendance_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_states` (
  `attendance_state_id` int NOT NULL AUTO_INCREMENT,
  `attendance_state_name_en` varchar(45) DEFAULT NULL,
  `attendance_state_name_ar` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`attendance_state_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_types`
--

DROP TABLE IF EXISTS `event_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_types` (
  `event_type_id` int NOT NULL AUTO_INCREMENT,
  `event_type_name_en` varchar(45) DEFAULT NULL,
  `event_type_name_ar` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`event_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `event_id` int NOT NULL AUTO_INCREMENT,
  `event_type_id` int NOT NULL,
  `event_name_en` varchar(45) DEFAULT NULL,
  `event_name_ar` varchar(45) DEFAULT NULL,
  `event_location` varchar(45) DEFAULT NULL,
  `event_start_date` date NOT NULL,
  `event_end_date` date DEFAULT NULL,
  `is_multi_team` tinyint(1) DEFAULT '0',
  `team_id` int NOT NULL,
  PRIMARY KEY (`event_id`),
  KEY `event_event_type_idx` (`event_type_id`),
  KEY `event_team_idx` (`team_id`),
  CONSTRAINT `event_event_type` FOREIGN KEY (`event_type_id`) REFERENCES `event_types` (`event_type_id`),
  CONSTRAINT `event_team` FOREIGN KEY (`team_id`) REFERENCES `teams` (`team_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gender_groups`
--

DROP TABLE IF EXISTS `gender_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gender_groups` (
  `gender_group_id` int NOT NULL AUTO_INCREMENT,
  `gender_group_name_en` varchar(255) DEFAULT NULL,
  `gender_group_name_ar` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`gender_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `member_id` varchar(255) NOT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `name_ar` varchar(255) DEFAULT NULL,
  `place_of_birth` varchar(255) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `national_id_no` varchar(14) DEFAULT NULL,
  `club_id_no` varchar(12) DEFAULT NULL,
  `passport_no` varchar(255) DEFAULT NULL,
  `date_joined` date DEFAULT NULL,
  `mobile_number` varchar(11) DEFAULT NULL,
  `home_contact` varchar(11) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `facebook_url` varchar(255) DEFAULT NULL,
  `school_name` varchar(50) DEFAULT NULL,
  `education_type` varchar(50) DEFAULT NULL,
  `father_name` varchar(255) DEFAULT NULL,
  `father_contact` varchar(255) DEFAULT NULL,
  `father_job` varchar(255) DEFAULT NULL,
  `mother_name` varchar(255) DEFAULT NULL,
  `mother_contact` varchar(255) DEFAULT NULL,
  `mother_job` varchar(255) DEFAULT NULL,
  `guardian_name` varchar(255) DEFAULT NULL,
  `guardian_contact` varchar(255) DEFAULT NULL,
  `guardian_relationship` varchar(255) DEFAULT NULL,
  `hobbies` varchar(255) DEFAULT NULL,
  `health_issues` varchar(255) DEFAULT NULL,
  `medications` varchar(255) DEFAULT NULL,
  `qr_code_url` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `national_id_url` varchar(255) DEFAULT NULL,
  `parent_national_id_url` varchar(255) DEFAULT NULL,
  `club_id_url` varchar(255) DEFAULT NULL,
  `passport_url` varchar(255) DEFAULT NULL,
  `birth_certificate_url` varchar(255) DEFAULT NULL,
  `photo_consent` tinyint(1) DEFAULT NULL,
  `conditions_consent` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stages`
--

DROP TABLE IF EXISTS `stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stages` (
  `stage_id` int NOT NULL AUTO_INCREMENT,
  `stage_name_en` varchar(255) DEFAULT NULL,
  `stage_name_ar` varchar(255) DEFAULT NULL,
  `age_group_id` int DEFAULT NULL,
  `gender_group_id` int DEFAULT NULL,
  PRIMARY KEY (`stage_id`),
  KEY `stage_age_group_idx` (`age_group_id`),
  KEY `stage_gender_group_idx` (`gender_group_id`),
  CONSTRAINT `stage_age_group` FOREIGN KEY (`age_group_id`) REFERENCES `age_groups` (`age_group_id`),
  CONSTRAINT `stage_gender_group` FOREIGN KEY (`gender_group_id`) REFERENCES `gender_groups` (`gender_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_members`
--

DROP TABLE IF EXISTS `team_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team_members` (
  `member_id` varchar(255) NOT NULL,
  `team_id` int NOT NULL,
  `date_from` date DEFAULT NULL,
  `date_to` date DEFAULT NULL,
  `is_leader` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`member_id`,`team_id`),
  KEY `team_member_idx` (`team_id`),
  CONSTRAINT `member_team` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  CONSTRAINT `team_member` FOREIGN KEY (`team_id`) REFERENCES `teams` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `team_id` int NOT NULL AUTO_INCREMENT,
  `team_name_en` varchar(255) DEFAULT NULL,
  `team_name_ar` varchar(255) DEFAULT NULL,
  `stage_id` int DEFAULT NULL,
  PRIMARY KEY (`team_id`),
  KEY `team_stage_idx` (`stage_id`),
  CONSTRAINT `team_stage` FOREIGN KEY (`stage_id`) REFERENCES `stages` (`stage_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'ssgg'
--
/*!50003 DROP PROCEDURE IF EXISTS `AddMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `AddMember`(IN P_member_id VARCHAR(255), 
    IN P_name_en VARCHAR(255), 
    IN P_name_ar VARCHAR(255), 
    IN P_place_of_birth VARCHAR(255), 
    IN P_date_of_birth DATE, 
    IN P_address VARCHAR(255),  
    IN P_national_id_no VARCHAR(14), 
    IN P_club_id_no VARCHAR(12), 
    IN P_passport_no VARCHAR(255), 
    IN P_date_joined DATE, 
    IN P_mobile_number VARCHAR(11), 
    IN P_home_contact VARCHAR(11), 
    IN P_email VARCHAR(50), 
    IN P_facebook_url VARCHAR(255), 
    IN P_school_name VARCHAR(255), 
    IN P_education_type VARCHAR(255), 
    IN P_father_name VARCHAR(255), 
    IN P_father_contact VARCHAR(255), 
    IN P_father_job VARCHAR(255), 
    IN P_mother_name VARCHAR(255), 
    IN P_mother_contact VARCHAR(255), 
    IN P_mother_job VARCHAR(255), 
    IN P_guardian_name VARCHAR(255), 
    IN P_guardian_contact VARCHAR(255), 
    IN P_guardian_relationship VARCHAR(255), 
    IN P_hobbies VARCHAR(255), 
    IN P_health_issues VARCHAR(255), 
    IN P_medications VARCHAR(255), 
    IN P_qr_code_url VARCHAR(255), 
    IN P_image_url VARCHAR(255), 
    IN P_national_id_url VARCHAR(255), 
    IN P_parent_national_id_url VARCHAR(255), 
    IN P_club_id_url VARCHAR(255), 
    IN P_passport_url VARCHAR(255), 
    IN P_birth_certificate_url VARCHAR(255), 
    IN P_photo_consent TINYINT(1), 
    IN P_conditions_consent TINYINT(1))
BEGIN
insert into 
  members (
    member_id, 
    name_en, 
    name_ar, 
    place_of_birth, 
    date_of_birth, 
    address, 
    national_id_no, 
    club_id_no, 
    passport_no, 
    date_joined, 
    mobile_number, 
    home_contact, 
    email, 
    facebook_url, 
    school_name, 
    education_type, 
    father_name, 
    father_contact, 
    father_job, 
    mother_name, 
    mother_contact, 
    mother_job, 
    guardian_name, 
    guardian_contact, 
    guardian_relationship, 
    hobbies, 
    health_issues, 
    medications, 
    qr_code_url, 
    image_url, 
    national_id_url, 
    parent_national_id_url, 
    club_id_url, 
    passport_url, 
    birth_certificate_url, 
    photo_consent, 
    conditions_consent
  )
values
  (
    P_member_id, 
    P_name_en, 
    P_name_ar, 
    P_place_of_birth, 
    P_date_of_birth, 
    P_address, 
    P_national_id_no, 
    P_club_id_no, 
    P_passport_no, 
    P_date_joined, 
    P_mobile_number, 
    P_home_contact, 
    P_email, 
    P_facebook_url, 
    P_school_name, 
    P_education_type, 
    P_father_name, 
    P_father_contact, 
    P_father_job, 
    P_mother_name, 
    P_mother_contact, 
    P_mother_job, 
    P_guardian_name, 
    P_guardian_contact, 
    P_guardian_relationship, 
    P_hobbies, 
    P_health_issues, 
    P_medications, 
    P_qr_code_url, 
    P_image_url, 
    P_national_id_url, 
    P_parent_national_id_url, 
    P_club_id_url, 
    P_passport_url, 
    P_birth_certificate_url, 
    P_photo_consent, 
    P_conditions_consent
  );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddMemberToTeam` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `AddMemberToTeam`(IN P_member_id VARCHAR(255), IN P_team_id INT, IN P_date_from DATE, IN P_is_leader TINYINT(1))
BEGIN
	DECLARE date_from DATE;
	IF P_date_from IS NULL THEN
		SET date_from = current_date();
	ELSE
		SET date_from = P_date_from;
	END IF;
    select date_from;
	INSERT INTO `ssgg`.`team_members`
	(`member_id`,
	`team_id`,
	`date_from`,
	`is_leader`)
	VALUES
	(P_member_id,
	P_team_id,
	date_from,
	P_is_leader);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `CreateEvent`(IN P_event_type INT, IN P_event_name_en VARCHAR(255), IN P_event_name_ar VARCHAR(255), IN P_event_location VARCHAR(255), IN P_event_start_date DATE, IN P_event_end_date DATE, IN P_is_multi_team TINYINT(1), IN P_team_id INT)
BEGIN
	INSERT INTO `ssgg`.`events`
	(`event_type_id`,
	`event_name_en`,
	`event_name_ar`,
	`event_location`,
	`event_start_date`,
	`event_end_date`,
	`is_multi_team`,
	`team_id`)
	VALUES
	(P_event_type,
	P_event_name_en,
	P_event_name_ar,
	P_event_location,
	P_event_start_date,
	P_event_end_date,
	P_is_multi_team,
	P_team_id);
    SELECT LAST_INSERT_ID() AS event_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAttendance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `GetAttendance`(IN P_event_id INT)
BEGIN
	SELECT `attendance`.`attendance_id`,
    `attendance`.`member_id`,
    `attendance`.`event_id`,
    `attendance`.`attendance_state_id`
	FROM `ssgg`.`attendance`
	WHERE `attendance`.`event_id` = P_event_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `GetEvent`(IN P_event_id INT)
BEGIN
	SELECT `events`.`event_id`,
    `events`.`event_type_id`,
    `events`.`event_name_en`,
    `events`.`event_name_ar`,
    `events`.`event_location`,
    `events`.`event_start_date`,
    `events`.`event_end_date`,
    `events`.`is_multi_team`,
    `events`.`team_id`
	FROM `ssgg`.`events`
	WHERE `events`.`event_id` = P_event_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `GetMember`(IN P_member_id varchar(255))
BEGIN
	SELECT
		teams.team_id,
        teams.team_name_en,
        teams.team_name_ar,
        team_members.is_leader,
        members.*
    FROM
        members
    LEFT JOIN
        team_members ON members.member_id = team_members.member_id
    LEFT JOIN
        teams ON team_members.team_id = teams.team_id
    WHERE
        members.member_id = P_member_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetTeamMembers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `GetTeamMembers`(IN P_team_id INTEGER)
BEGIN
	SELECT
		team.team_id,
		team.team_name_en,
		team.team_name_ar,
        team_members.is_leader,
        stages.stage_id,
        stages.stage_name_en,
        stages.stage_name_ar,
		members.member_id,
		members.name_en,
		members.name_ar
	FROM
		teams AS team
	LEFT JOIN
		team_members ON team_members.team_id = team.team_id
	LEFT JOIN
		members ON members.member_id = team_members.member_id
	INNER JOIN
		stages ON stages.stage_id = team.stage_id
	WHERE
		team.team_id = P_team_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SearchMembers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `SearchMembers`(IN P_team_id INT, IN P_member_name varchar(255))
BEGIN
	DECLARE search_pattern VARCHAR(255);

    IF P_member_name IS NULL OR P_member_name = '' THEN
        SET search_pattern = NULL;
    ELSE
        SET search_pattern = CONCAT('%', P_member_name, '%');
    END IF;

    SELECT
		teams.team_id,
        teams.team_name_en,
        teams.team_name_ar,
        t.is_leader,
        members.*
    FROM
        team_members AS t
    INNER JOIN
        members ON members.member_id = t.member_id
    INNER JOIN
        teams ON teams.team_id = t.team_id
    WHERE
        (search_pattern IS NULL OR members.name_en LIKE search_pattern OR members.name_ar LIKE search_pattern)
        AND (P_team_id IS NULL OR t.team_id = P_team_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TakeAttendance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `TakeAttendance`(IN P_member_id VARCHAR(45), IN P_event_id INT, IN P_attendance_state_id INT)
BEGIN
	INSERT INTO `ssgg`.`attendance`
	(`member_id`,
	`event_id`,
	`attendance_state_id`)
	VALUES
	(P_member_id,
	P_event_id,
	P_attendance_state_id);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `UpdateEvent`(IN P_event_id INT, IN P_event_type_id INT, IN P_event_name_en VARCHAR(255), IN P_event_name_ar VARCHAR(255), IN P_event_location VARCHAR(255), IN P_event_start_date DATE, IN P_event_end_date DATE, IN P_is_multi_team TINYINT(1), IN P_team_id INT)
BEGIN
    UPDATE `ssgg`.`events`
	SET
	`event_type_id` = COALESCE(P_event_type_id, event_type_id),
	`event_name_en` = COALESCE(P_event_name_en, event_name_en),
	`event_name_ar` = COALESCE(P_event_name_ar, event_name_ar),
	`event_location` = COALESCE(P_event_location, event_location),
	`event_start_date` = COALESCE(P_event_start_date, event_start_date),
	`event_end_date` = COALESCE(P_event_end_date, event_end_date),
	`is_multi_team` = COALESCE(P_is_multi_team, is_multi_team),
	`team_id` = COALESCE(P_team_id, team_id)
	WHERE `event_id` = P_event_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `UpdateMember`(
	IN P_member_id VARCHAR(255),
    IN P_name_en VARCHAR(255),
    IN P_name_ar VARCHAR(255),
    IN P_place_of_birth VARCHAR(255),
    IN P_date_of_birth DATE,
    IN P_address VARCHAR(255),
    IN P_national_id_no VARCHAR(14),
    IN P_club_id_no VARCHAR(12),
    IN P_passport_no VARCHAR(255),
    IN P_date_joined DATE,
    IN P_mobile_number VARCHAR(11),
    IN P_home_contact VARCHAR(11),
    IN P_email VARCHAR(50),
    IN P_facebook_url VARCHAR(255),
    IN P_school_name VARCHAR(255),
    IN P_education_type VARCHAR(50),
    IN P_father_name VARCHAR(255),
    IN P_father_contact VARCHAR(255),
    IN P_father_job VARCHAR(255),
    IN P_mother_name VARCHAR(255),
    IN P_mother_contact VARCHAR(255),
    IN P_mother_job VARCHAR(255),
    IN P_guardian_name VARCHAR(255),
    IN P_guardian_contact VARCHAR(255),
    IN P_guardian_relationship VARCHAR(255),
    IN P_hobbies VARCHAR(255),
    IN P_health_issues VARCHAR(255),
    IN P_medications VARCHAR(255),
    IN P_qr_code_url VARCHAR(255),
    IN P_image_url VARCHAR(255),
    IN P_national_id_url VARCHAR(255),
    IN P_parent_national_id_url VARCHAR(255),
    IN P_club_id_url VARCHAR(255),
    IN P_passport_url VARCHAR(255),
    IN P_birth_certificate_url VARCHAR(255),
    IN P_photo_consent TINYINT(1),
    IN P_conditions_consent TINYINT(1)
)
BEGIN
    UPDATE ssgg.members
    SET
        name_en = COALESCE(P_name_en, name_en),
        name_ar = COALESCE(P_name_ar, name_ar),
        place_of_birth = COALESCE(P_place_of_birth, place_of_birth),
        date_of_birth = COALESCE(P_date_of_birth, date_of_birth),
        address = COALESCE(P_address, address),
        national_id_no = COALESCE(P_national_id_no, national_id_no),
        club_id_no = COALESCE(P_club_id_no, club_id_no),
        passport_no = COALESCE(P_passport_no, passport_no),
        date_joined = COALESCE(P_date_joined, date_joined),
        mobile_number = COALESCE(P_mobile_number, mobile_number),
        home_contact = COALESCE(P_home_contact, home_contact),
        email = COALESCE(P_email, email),
        facebook_url = COALESCE(P_facebook_url, facebook_url),
        school_name = COALESCE(P_school_name, school_name),
        education_type = COALESCE(P_education_type, education_type),
        father_name = COALESCE(P_father_name, father_name),
        father_contact = COALESCE(P_father_contact, father_contact),
        father_job = COALESCE(P_father_job, father_job),
        mother_name = COALESCE(P_mother_name, mother_name),
        mother_contact = COALESCE(P_mother_contact, mother_contact),
        mother_job = COALESCE(P_mother_job, mother_job),
        guardian_name = COALESCE(P_guardian_name, guardian_name),
        guardian_contact = COALESCE(P_guardian_contact, guardian_contact),
        guardian_relationship = COALESCE(P_guardian_relationship, guardian_relationship),
        hobbies = COALESCE(P_hobbies, hobbies),
        health_issues = COALESCE(P_health_issues, health_issues),
        medications = COALESCE(P_medications, medications),
        qr_code_url = COALESCE(P_qr_code_url, qr_code_url),
        image_url = COALESCE(P_image_url, image_url),
        national_id_url = COALESCE(P_national_id_url, national_id_url),
        parent_national_id_url = COALESCE(P_parent_national_id_url, parent_national_id_url),
        club_id_url = COALESCE(P_club_id_url, club_id_url),
        passport_url = COALESCE(P_passport_url, passport_url),
        birth_certificate_url = COALESCE(P_birth_certificate_url, birth_certificate_url),
        photo_consent = COALESCE(P_photo_consent, photo_consent),
        conditions_consent = COALESCE(P_conditions_consent, conditions_consent)
    WHERE member_id = P_member_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateTest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `updateTest`(IN param INT)
BEGIN
	UPDATE ssgg.members
    SET national_id_no = coalesce(param, national_id_no)
    WHERE member_id= 's124';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-25 14:08:22
