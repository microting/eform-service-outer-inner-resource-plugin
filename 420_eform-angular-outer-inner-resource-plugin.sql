-- MariaDB dump 10.19  Distrib 10.6.11-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: 420_eform-angular-outer-inner-resource-plugin
-- ------------------------------------------------------
-- Server version	10.6.11-MariaDB-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `InnerResourceVersions`
--

DROP TABLE IF EXISTS `InnerResourceVersions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `InnerResourceVersions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `Name` varchar(250) DEFAULT NULL,
  `Version` int(11) NOT NULL,
  `InnerResourceId` int(11) NOT NULL,
  `ExternalId` int(11) DEFAULT 0,
  PRIMARY KEY (`Id`),
  KEY `IX_InnerResourceVersions_InnerResourceId` (`InnerResourceId`),
  CONSTRAINT `FK_InnerResourceVersions_InnerResources_InnerResourceId` FOREIGN KEY (`InnerResourceId`) REFERENCES `InnerResources` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `InnerResources`
--

DROP TABLE IF EXISTS `InnerResources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `InnerResources` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `Name` varchar(250) DEFAULT NULL,
  `Version` int(11) NOT NULL,
  `ExternalId` int(11) DEFAULT 0,
  PRIMARY KEY (`Id`),
  KEY `IX_Machines_CreatedByUserId` (`CreatedByUserId`),
  KEY `IX_Machines_Name` (`Name`),
  KEY `IX_Machines_UpdatedByUserId` (`UpdatedByUserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OuterInnerResourceSiteVersions`
--

DROP TABLE IF EXISTS `OuterInnerResourceSiteVersions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OuterInnerResourceSiteVersions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `MicrotingSdkeFormId` int(11) NOT NULL,
  `Status` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  `OuterInnerResourceId` int(11) NOT NULL,
  `OuterInnerResourceSiteId` int(11) NOT NULL,
  `MicrotingSdkSiteId` int(11) NOT NULL,
  `MicrotingSdkCaseId` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OuterInnerResourceSites`
--

DROP TABLE IF EXISTS `OuterInnerResourceSites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OuterInnerResourceSites` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `MicrotingSdkeFormId` int(11) NOT NULL,
  `Status` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  `OuterInnerResourceId` int(11) NOT NULL,
  `MicrotingSdkSiteId` int(11) NOT NULL,
  `MicrotingSdkCaseId` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_OuterInnerResourceSites_OuterInnerResourceId` (`OuterInnerResourceId`),
  CONSTRAINT `FK_OuterInnerResourceSites_OuterInnerResources_OuterInnerResour~` FOREIGN KEY (`OuterInnerResourceId`) REFERENCES `OuterInnerResources` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OuterInnerResourceVersions`
--

DROP TABLE IF EXISTS `OuterInnerResourceVersions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OuterInnerResourceVersions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `InnerResourceId` int(11) NOT NULL,
  `OuterResourceId` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  `OuterInnerResourceId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_OuterInnerResourceVersions_InnerResourceId` (`InnerResourceId`),
  KEY `IX_OuterInnerResourceVersions_OuterInnerResourceId` (`OuterInnerResourceId`),
  KEY `IX_OuterInnerResourceVersions_OuterResourceId` (`OuterResourceId`),
  CONSTRAINT `FK_OuterInnerResourceVersions_InnerResources_InnerResourceId` FOREIGN KEY (`InnerResourceId`) REFERENCES `InnerResources` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_OuterInnerResourceVersions_OuterInnerResources_OuterInnerRes~` FOREIGN KEY (`OuterInnerResourceId`) REFERENCES `OuterInnerResources` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_OuterInnerResourceVersions_OuterResources_OuterResourceId` FOREIGN KEY (`OuterResourceId`) REFERENCES `OuterResources` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OuterInnerResources`
--

DROP TABLE IF EXISTS `OuterInnerResources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OuterInnerResources` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `InnerResourceId` int(11) NOT NULL,
  `OuterResourceId` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_OuterInnerResources_InnerResourceId` (`InnerResourceId`),
  KEY `IX_OuterInnerResources_OuterResourceId` (`OuterResourceId`),
  CONSTRAINT `FK_OuterInnerResources_InnerResources_InnerResourceId` FOREIGN KEY (`InnerResourceId`) REFERENCES `InnerResources` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_OuterInnerResources_OuterResources_OuterResourceId` FOREIGN KEY (`OuterResourceId`) REFERENCES `OuterResources` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OuterResourceVersions`
--

DROP TABLE IF EXISTS `OuterResourceVersions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OuterResourceVersions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `Name` varchar(250) DEFAULT NULL,
  `Version` int(11) NOT NULL,
  `OuterResourceId` int(11) NOT NULL,
  `ExternalId` int(11) DEFAULT 0,
  PRIMARY KEY (`Id`),
  KEY `IX_OuterResourceVersions_OuterResourceId` (`OuterResourceId`),
  CONSTRAINT `FK_OuterResourceVersions_OuterResources_OuterResourceId` FOREIGN KEY (`OuterResourceId`) REFERENCES `OuterResources` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OuterResources`
--

DROP TABLE IF EXISTS `OuterResources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OuterResources` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `Name` varchar(250) DEFAULT NULL,
  `Version` int(11) NOT NULL,
  `ExternalId` int(11) DEFAULT 0,
  PRIMARY KEY (`Id`),
  KEY `IX_Areas_CreatedByUserId` (`CreatedByUserId`),
  KEY `IX_Areas_Name` (`Name`),
  KEY `IX_Areas_UpdatedByUserId` (`UpdatedByUserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PluginConfigurationValueVersions`
--

DROP TABLE IF EXISTS `PluginConfigurationValueVersions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PluginConfigurationValueVersions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  `Name` longtext DEFAULT NULL,
  `Value` longtext DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PluginConfigurationValues`
--

DROP TABLE IF EXISTS `PluginConfigurationValues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PluginConfigurationValues` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  `Name` longtext DEFAULT NULL,
  `Value` longtext DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PluginGroupPermissionVersions`
--

DROP TABLE IF EXISTS `PluginGroupPermissionVersions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PluginGroupPermissionVersions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  `GroupId` int(11) NOT NULL,
  `PermissionId` int(11) NOT NULL,
  `IsEnabled` tinyint(1) NOT NULL,
  `PluginGroupPermissionId` int(11) NOT NULL,
  `FK_PluginGroupPermissionVersions_PluginGroupPermissionId` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_PluginGroupPermissionVersions_FK_PluginGroupPermissionVersion` (`FK_PluginGroupPermissionVersions_PluginGroupPermissionId`),
  KEY `IX_PluginGroupPermissionVersions_PermissionId` (`PermissionId`),
  CONSTRAINT `FK_PluginGroupPermissionVersions_PluginGroupPermissions_FK_Plugi` FOREIGN KEY (`FK_PluginGroupPermissionVersions_PluginGroupPermissionId`) REFERENCES `PluginGroupPermissions` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PluginGroupPermissions`
--

DROP TABLE IF EXISTS `PluginGroupPermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PluginGroupPermissions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  `GroupId` int(11) NOT NULL,
  `PermissionId` int(11) NOT NULL,
  `IsEnabled` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  KEY `IX_PluginGroupPermissions_PermissionId` (`PermissionId`),
  CONSTRAINT `FK_PluginGroupPermissions_PluginPermissions_PermissionId` FOREIGN KEY (`PermissionId`) REFERENCES `PluginPermissions` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PluginPermissions`
--

DROP TABLE IF EXISTS `PluginPermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PluginPermissions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  `PermissionName` longtext DEFAULT NULL,
  `ClaimName` longtext DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ResourceTimeRegistrationVersions`
--

DROP TABLE IF EXISTS `ResourceTimeRegistrationVersions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ResourceTimeRegistrationVersions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `InnerResourceId` int(11) NOT NULL,
  `OuterResourceId` int(11) NOT NULL,
  `DoneAt` datetime(6) NOT NULL,
  `SDKCaseId` int(11) NOT NULL,
  `SDKFieldValueId` int(11) NOT NULL,
  `TimeInSeconds` int(11) NOT NULL,
  `TimeInMinutes` int(11) NOT NULL,
  `TimeInHours` int(11) NOT NULL,
  `SDKSiteId` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  `MachineAreaTimeRegistrationId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_MachineAreaTimeRegistrationVersions_MachineAreaTimeRegistrati` (`MachineAreaTimeRegistrationId`),
  KEY `IX_ResourceTimeRegistrationVersions_InnerResourceId` (`InnerResourceId`),
  KEY `IX_ResourceTimeRegistrationVersions_MachineAreaTimeRegistrationI` (`MachineAreaTimeRegistrationId`),
  KEY `IX_ResourceTimeRegistrationVersions_OuterResourceId` (`OuterResourceId`),
  CONSTRAINT `FK_MachineAreaTimeRegistrationVersions_MachineAreaTimeRegistrati` FOREIGN KEY (`MachineAreaTimeRegistrationId`) REFERENCES `ResourceTimeRegistrations` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ResourceTimeRegistrationVersions_InnerResources_InnerResource` FOREIGN KEY (`InnerResourceId`) REFERENCES `InnerResources` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ResourceTimeRegistrationVersions_InnerResources_InnerResourc~` FOREIGN KEY (`InnerResourceId`) REFERENCES `InnerResources` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ResourceTimeRegistrationVersions_OuterResources_OuterResourc~` FOREIGN KEY (`OuterResourceId`) REFERENCES `OuterResources` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ResourceTimeRegistrationVersions_ResourceTimeRegistrations_M~` FOREIGN KEY (`MachineAreaTimeRegistrationId`) REFERENCES `ResourceTimeRegistrations` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ResourceTimeRegistrations`
--

DROP TABLE IF EXISTS `ResourceTimeRegistrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ResourceTimeRegistrations` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `CreatedAt` datetime(6) NOT NULL,
  `UpdatedAt` datetime(6) DEFAULT NULL,
  `WorkflowState` varchar(255) DEFAULT NULL,
  `CreatedByUserId` int(11) NOT NULL,
  `UpdatedByUserId` int(11) NOT NULL,
  `InnerResourceId` int(11) NOT NULL,
  `OuterResourceId` int(11) NOT NULL,
  `DoneAt` datetime(6) NOT NULL,
  `SDKCaseId` int(11) NOT NULL,
  `SDKFieldValueId` int(11) NOT NULL,
  `TimeInSeconds` int(11) NOT NULL,
  `TimeInMinutes` int(11) NOT NULL,
  `TimeInHours` int(11) NOT NULL,
  `SDKSiteId` int(11) NOT NULL,
  `Version` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_ResourceTimeRegistrations_InnerResourceId` (`InnerResourceId`),
  KEY `IX_ResourceTimeRegistrations_OuterResourceId` (`OuterResourceId`),
  CONSTRAINT `FK_ResourceTimeRegistrations_InnerResources_InnerResourceId` FOREIGN KEY (`InnerResourceId`) REFERENCES `InnerResources` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_ResourceTimeRegistrations_OuterResources_OuterResourceId` FOREIGN KEY (`OuterResourceId`) REFERENCES `OuterResources` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `__EFMigrationsHistory`
--

DROP TABLE IF EXISTS `__EFMigrationsHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `__EFMigrationsHistory` (
  `MigrationId` varchar(150) NOT NULL,
  `ProductVersion` varchar(32) NOT NULL,
  PRIMARY KEY (`MigrationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `__EFMigrationsHistory`
--

LOCK TABLES `__EFMigrationsHistory` WRITE;
/*!40000 ALTER TABLE `__EFMigrationsHistory` DISABLE KEYS */;
INSERT INTO `__EFMigrationsHistory` VALUES ('20190218071621_InitialCreate','7.0.2'),('20190304081956_SmallRefactoring','7.0.2'),('20190312083212_AddSettingsTables','7.0.2'),('20190403141446_UpdateBaseEntity','7.0.2'),('20190403141554_UpdateSettingsTables','7.0.2'),('20190426111129_RemovingOldSettings','7.0.2'),('20191007111534_RemovingForeignKeys','7.0.2'),('20191007123706_RenamingTables','7.0.2'),('20191008070052_RenamingForeignKeys','7.0.2'),('20191008110537_AddingBindings','7.0.2'),('20191021160920_PluginPermissions','7.0.2'),('20191030003211_AddPluginPermissionVersion','7.0.2'),('20191111053741_AddingExternalId','7.0.2'),('20191129103757_SettingMicrotingSdkCaseIdToNullable','7.0.2'),('20200728091412_FixingMigrations','7.0.2');
/*!40000 ALTER TABLE `__EFMigrationsHistory` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-01-15 17:47:37
