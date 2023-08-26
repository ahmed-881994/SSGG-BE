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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-08-26 12:25:05
