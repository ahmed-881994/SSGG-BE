-- MySQL dump 10.13  Distrib 8.0.34, for macos13 (x86_64)
--
-- Host: 0.0.0.0    Database: ssgg
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
-- Dumping data for table `age_groups`
--

LOCK TABLES `age_groups` WRITE;
/*!40000 ALTER TABLE `age_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `age_groups` ENABLE KEYS */;
UNLOCK TABLES;

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
  KEY `attendance_event_idx` (`event_id`),
  KEY `attendance_attendance_state_idx` (`attendance_state_id`),
  KEY `attendance_member_idx` (`member_id`),
  CONSTRAINT `attendance_attendance_state` FOREIGN KEY (`attendance_state_id`) REFERENCES `attendance_states` (`attendance_state_id`),
  CONSTRAINT `attendance_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`),
  CONSTRAINT `attendance_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_states`
--

LOCK TABLES `attendance_states` WRITE;
/*!40000 ALTER TABLE `attendance_states` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance_states` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_types`
--

LOCK TABLES `event_types` WRITE;
/*!40000 ALTER TABLE `event_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `event_id` int NOT NULL,
  `event_type_id` int NOT NULL,
  `event_name_en` varchar(45) DEFAULT NULL,
  `event_name_ar` varchar(45) DEFAULT NULL,
  `event_location` varchar(45) DEFAULT NULL,
  `event_start_date` date NOT NULL,
  `event_end_date` date DEFAULT NULL,
  `is_multi_team` bit(1) DEFAULT b'0',
  `team_id` int NOT NULL,
  PRIMARY KEY (`event_id`),
  KEY `event_event_type_idx` (`event_type_id`),
  KEY `event_team_idx` (`team_id`),
  CONSTRAINT `event_event_type` FOREIGN KEY (`event_type_id`) REFERENCES `event_types` (`event_type_id`),
  CONSTRAINT `event_team` FOREIGN KEY (`team_id`) REFERENCES `teams` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `gender_groups`
--

LOCK TABLES `gender_groups` WRITE;
/*!40000 ALTER TABLE `gender_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `gender_groups` ENABLE KEYS */;
UNLOCK TABLES;

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
  `photo_consent` bit(1) DEFAULT NULL,
  `conditions_consent` bit(1) DEFAULT NULL,
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `stages`
--

LOCK TABLES `stages` WRITE;
/*!40000 ALTER TABLE `stages` DISABLE KEYS */;
INSERT INTO `stages` VALUES (1,'Smurfs','السنافر',NULL,NULL),(2,'Cubs','الاشبال',NULL,NULL),(3,'Scouts','الكشافة',NULL,NULL),(4,'Advanced Scouts','المتقدم',NULL,NULL),(5,'Rovers','الجوالة',NULL,NULL),(6,'Pres Janet','البراعم',NULL,NULL),(7,'Janet','الزهرات',NULL,NULL),(8,'Guides','المرشدات',NULL,NULL),(9,'Guideannes','المتقدمات',NULL,NULL),(10,'Routier','الجوالات',NULL,NULL);
/*!40000 ALTER TABLE `stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_members`
--

DROP TABLE IF EXISTS `team_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team_members` (
  `member_id` varchar(255) NOT NULL,
  `team_id` int DEFAULT NULL,
  `date_from` date DEFAULT NULL,
  `date_to` date DEFAULT NULL,
  `is_leader` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`member_id`),
  KEY `team_member_idx` (`team_id`),
  CONSTRAINT `member_team` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  CONSTRAINT `team_member` FOREIGN KEY (`team_id`) REFERENCES `teams` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_members`
--

LOCK TABLES `team_members` WRITE;
/*!40000 ALTER TABLE `team_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `team_members` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES (1,'Bagera','باجيرا',1),(2,'Raksha','راكشا',1),(3,'Medterranean Sea','بحر متوسط',2),(4,'Red Sea','بحر احمر',2),(5,'Atlantic','اطلنطي',3),(6,'Pacific','هادي',3),(7,'Advanced Scouts','المتقدم',4),(8,'Rovers','الجوالة',5),(9,'Pres janet','',6),(10,'Sunflowers','',7),(11,'Daisy','',7),(12,'Rose','',7),(13,'Guides','',8),(14,'Guideannes','',9),(15,'Routierers','',10);
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-08-26 12:26:01
