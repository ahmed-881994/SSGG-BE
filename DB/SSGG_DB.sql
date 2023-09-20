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
  KEY `attendance_attendance_state_idx` (`attendance_state_id`),
  KEY `attendance_member_idx` (`member_id`),
  KEY `attendance_event_idx` (`event_id`),
  CONSTRAINT `attendance_attendance_state` FOREIGN KEY (`attendance_state_id`) REFERENCES `attendance_states` (`attendance_state_id`),
  CONSTRAINT `attendance_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`),
  CONSTRAINT `attendance_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
INSERT INTO `attendance` VALUES (1,'s123',3,1),(2,'s123',3,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_states`
--

LOCK TABLES `attendance_states` WRITE;
/*!40000 ALTER TABLE `attendance_states` DISABLE KEYS */;
INSERT INTO `attendance_states` VALUES (1,'test','test');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_types`
--

LOCK TABLES `event_types` WRITE;
/*!40000 ALTER TABLE `event_types` DISABLE KEYS */;
INSERT INTO `event_types` VALUES (1,'test','test');
/*!40000 ALTER TABLE `event_types` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (3,1,'test','test','test','2022-09-16','2022-09-16',1,1),(4,1,'test','test','test','2022-09-16','2022-09-16',1,1),(5,1,'test','test','test','2022-09-16','2022-09-16',1,1),(6,1,'test','test','test','2022-09-16','2022-09-16',1,1);
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
  `photo_consent` tinyint(1) DEFAULT NULL,
  `conditions_consent` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES ('S111-04031','Anas Ahmed Mohamed Abdel Aal','أنس احمد محمد عبدالعال','Alexendria','2004-11-30','الاستاد ...شارع البطالسه',NULL,'200607050202',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S111-06032','Mohamed Fawzy Abd Elmoniem ','محمد فوزي عبد المنعم','Alexendria','2006-01-03','الشاطبي، الكورنيش، عمارات الاوقاف عمارة رقم (ب)',NULL,'199210220105','A19058277',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S112-06027','Youssuf El Kak','يوسف محمد عبد اللطيف القاق','Alexendria','2006-08-02','20 شارع الدكتور صابونجي سابا باشا',NULL,'200909080404',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S112-08022','Yassin Islam shereen hamdy','ياسين اسلام شرين حمدي','Alexendria','2008-05-31','وابور المية',NULL,'201209180302',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S113-06020','Akram Diaa Eldin Mohamed Hamed ','اكرم ضياء الدين محمد حامد ','Alexendria','2006-02-15','ااش البطليوسي متفرع من ش المشير',NULL,'200507170303',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S113-07019','Hamza fouad shawky eleshaky','حمزة فواد شوقي الاسحاقي','Alexendria','2007-07-06','183 الومية العربية',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S113-07021','Ziad Elsafty','زياذ احمد شريف حسين','Alexendria','2007-08-08','سموحة شارع كمال الدين صلاح',NULL,'199804220103',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S113-08027','Hamza mohamed farag mohamed Tafour ','حمزة محمد فرج محمد طافور','Alexendria','2008-03-27','١٥ شارع محمود الطوريني كليوباترا ',NULL,'200709110104',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S114-07046','Yehia Mohamed Mohammed Gaballah ','Yehia Mohammed Gaballah ','Alexendria','2007-11-11','٧شارع بورسعيد الشطبي ',NULL,'199101200204',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S114-07049','Karim Ahmed abdlmonem abdlhalem abulnadr','كريم احمد عبد المنعم عبد الحليم ابو النصر','Alexendria','2007-12-07','18شارع خضر التونى كليوباترا الصغرى ',NULL,'200609030500',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S115-08046','YOUSSEF SALAH EL DIN MOSTAFA MOHAMED MAHMOUD SALEM','يوسف صلاح الدين مصطفى محمد محمود سالم','Alexendria','2008-06-28','23 HILTON STREET SMOUHA ALEXANDRIA',NULL,'201107010202','A08555145',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S115-08059','Adel khalad pharouk gougou','عادل خالد فاروق جوجو','Alexendria','2008-03-03','١٤ ش على باشا ذو الفكار ',NULL,'198403240307','.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S119-05022','Adam Ibrahim Elsawy ','آدم ابراهيم الصاوي','Alexendria','2005-09-19','4st ahmed allbon',NULL,'201009260603',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('s123','Ahmed Safwat','احمد صفوت','Alexandria','1994-08-08','string','0','0','string','2003-09-01','string','string','user@example.com','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string',0,0),('s124','Ahmed Safwat','احمد صفوت','Alexandria','1994-08-08','string','0','0','string','2003-09-01','string','string','user@example.com','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string','string',0,0),('S214-04041','Yassin mohamed el sayed ali ','ياسين محمد السيد علي ','Alexendria','2004-01-24','٢٠ ابراهيم العطار',NULL,'199510100102','A21590873',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S214-06052','Amr Mohamed Shabara','عمرو محمد شبارة','Alexendria','2006-11-21','سموحة ش عصام حلمي المصري',NULL,'200607111004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S215-04029','Amr Nematalah','عمرو نعمة الله','Alexendria','2004-03-10','2 norden kafr abdou roshdey ',NULL,'198803210602','A20832947',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S215-04036','AbdelHady Adham AbdelHady Elsayed AbdelMeguid ','عبدالهادى ادهم عبدالهادى السيد ','Alexendria','2004-11-11','٦٤شارع اسماعيل سري سموحة ',NULL,'199503281004','A10216221',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S215-05049','Asser Ahmed abdelaziz megahed','آسر احمد عبدالعزيز مجاهد','Alexendria','2005-07-25','٥٦٨ مكرر طريق الحرية جليم',NULL,'199103231305',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S215-06025','Malek Mohamed Abdelazim Mohamed ','مالك محمد عبدالعظيم محمد','Alexendria','2006-01-01','٩ عمر الفاروق وابور المياه ',NULL,'201209300503','A09916589',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S216-05032','Mohamed walid mohamed mahgoub','محمد وليد محمد محجوب ','Alexendria','2005-04-01','ثروت',NULL,'200507190803','A24541277',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S216-06007','Abdallah mohamed soliman ibrahim elsisy','عبدالله محمد سليمان ابراهيم السيسي','Alexendria','2006-08-28','شارع النقل و الهندسة كومباوند فيروزة سموحة',NULL,'200908120202',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S216-06028','Hassan hossam hassan Youssef','حسن حسام حسن يوسف','Alexendria','2006-03-28','الساحل الشمالي  قريه كرير براديز الكيلو 38',NULL,'200609302102',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S217-07003','Ezzeldin Mostafa hamad','عزالدين مصطفى حمد محمد','Alexendria','2007-12-13','15شارع المرادنى جناكليس',NULL,'199904180803','A02053298',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S218-07057','Abdelrahman Nagy Mohamed Samir Mostafa ','عبد الرحمن ناجي محمد سمير مصطفى ','Alexendria','2007-05-07','٦١ شارع عبد المنعم سند - كامب شيزار ',NULL,'200707080202','A19829510',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S218-08037','Youssef Yasser Farouk Hassan ','يوسف ياسر فاروق حسن ','Alexendria','2008-09-15','سموحة - أسكندرية',NULL,'199503290602',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S310-05051','Ahmad tarek Ahmad  samaha','احمد طارق أحمد  سماحه','Alexendria','2005-11-05','٧٩ عمارات الضباط',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S317-03037','Abdelmeguid mamdouh mohamed abdelaziz ','عبدالمجيد ممدوح محمد عبدالعزيز ','Alexendria','2003-11-27','56 شارع مسجد الهدايا (ستانلي)',NULL,'201409220805',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S317-05038','Hassan amr soliman','حسن عمرو سليمان','Cairo','2005-09-08','سموحة مدينة اسيد بجوار جرين بلازا',NULL,'198803070104',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S318-06062','Yehia Ahmed Abd El-Fattah Mahmoud El-Fakharany','يحيى أحمد عبد الفتاح محمود الفخرانى','Alexendria','2006-07-14','٥٢ شارع عمر المختار جناكليس',NULL,'198403310203',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S319-07032','Yassin motasem Mohamed El banawy ','ياسين معتصم محمد البنوي','Alexendria','2007-05-06','الكندرة اسكندرية ',NULL,'200409220103',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S320-06040','Mamdouh hussein mamdouh abdeldaeim','ممدوح حسين ممدوح عبدالدايم','Alexendria','2006-01-06','18 elpharana street , bab sharq , alexandria',NULL,'199901170303',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S320-07037','Nour el din tarek aly Mohamed',' نور الدين طارق علي محمد','Alexendria','2007-04-14','47 عمارات الضباط مصطفي كامل',NULL,'199802260502',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S418-05012','Ali samir el batikhy','على سمير البطيخي','Alexendria','2005-04-20','Saba pasha/Alexandria',NULL,'198803220503','    ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),('S422-07258','Omar khaled Ahmed Fawzy ','عمر خالد أحمد فوزى عبد السلام','Alexendria','2007-06-28','ش ١٤ مايو سموحة - ابراج سموحة كلاس- برج (ج)',NULL,'201303210302',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0);
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
-- Dumping data for table `team_members`
--

LOCK TABLES `team_members` WRITE;
/*!40000 ALTER TABLE `team_members` DISABLE KEYS */;
INSERT INTO `team_members` VALUES ('S111-04031',7,NULL,NULL,0),('S111-06032',7,NULL,NULL,0),('S112-06027',7,NULL,NULL,0),('S112-08022',7,NULL,NULL,0),('S113-06020',7,NULL,NULL,0),('S113-07019',7,NULL,NULL,0),('S113-07021',7,NULL,NULL,0),('S113-08027',7,NULL,NULL,0),('S114-07046',7,NULL,NULL,0),('S114-07049',7,NULL,NULL,0),('S115-08046',7,NULL,NULL,0),('S115-08059',7,NULL,NULL,0),('S119-05022',7,NULL,NULL,0),('s123',1,'2023-09-14',NULL,0),('s123',7,'2023-09-04',NULL,1),('S214-04041',7,NULL,NULL,0),('S214-06052',7,NULL,NULL,0),('S215-04029',7,NULL,NULL,0),('S215-04036',7,NULL,NULL,0),('S215-05049',7,NULL,NULL,0),('S215-06025',7,NULL,NULL,0),('S216-05032',7,NULL,NULL,0),('S216-06007',7,NULL,NULL,0),('S216-06028',7,NULL,NULL,0),('S217-07003',7,NULL,NULL,0),('S218-07057',7,NULL,NULL,0),('S218-08037',7,NULL,NULL,0),('S310-05051',7,NULL,NULL,0),('S317-03037',7,NULL,NULL,0),('S317-05038',7,NULL,NULL,0),('S318-06062',7,NULL,NULL,0),('S319-07032',7,NULL,NULL,0),('S320-06040',7,NULL,NULL,0),('S320-07037',7,NULL,NULL,0),('S418-05012',7,NULL,NULL,0),('S422-07258',7,NULL,NULL,0);
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-20 12:31:57
