-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 09, 2018 at 09:59 AM
-- Server version: 10.1.21-MariaDB
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `maxpro_erp_2`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_role_list_by_group_id` (IN `grp_id` INT(11))  SELECT GROUP_CONCAT(DISTINCT(c.name)) as c_name,r.* FROM mxp_role r join mxp_companies c on(c.id=r.company_id)
where c.group_id=grp_id GROUP BY r.cm_group_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_translation` ()  SELECT tr.*,tk.translation_key FROM mxp_translation_keys tk INNER JOIN mxp_translations tr ON(tr.translation_key_id=tk.translation_key_id)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_translation_with_limit` (IN `startedAt` INT(11), IN `limits` INT(11))  SELECT tr.*,tk.translation_key, ml.lan_name FROM mxp_translation_keys tk INNER JOIN
 mxp_translations tr ON(tr.translation_key_id=tk.translation_key_id) 
 INNER JOIN mxp_languages ml ON(ml.lan_code=tr.lan_code)order by tk.translation_key_id desc limit startedAt,limits$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_child_menu_list` (IN `p_parent_menu_id` INT(11), IN `role_id` INT(11), IN `comp_id` INT(11))  if(comp_id !='') then
SELECT m.* FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE rm.role_id=role_id AND rm.company_id=comp_id AND m.parent_id=p_parent_menu_id order by m.order_id ASC;
else
SELECT m.* FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE rm.role_id=role_id AND m.parent_id=p_parent_menu_id order by m.order_id ASC;
end if$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_companies_by_group_id` (IN `grp_id` INT(11))  select * from mxp_companies where group_id=grp_id and is_active = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_permission` (IN `role_id` INT(11), IN `route` VARCHAR(120), IN `comp_id` INT(11))  if(comp_id !='')then
SELECT COUNT(*) as cnt FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE m.route_name=route AND rm.role_id=role_id AND rm.company_id=comp_id;
else
SELECT COUNT(*) as cnt FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE m.route_name=route AND rm.role_id=role_id ;
end if$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_roles_by_company_id` (IN `cmpny_id` INT(11), IN `cm_grp_id` INT(11))  SELECT rl.name as roleName, cm.name as companyName, cm.id as company_id, rl.cm_group_id, rl.is_active FROM mxp_role rl INNER JOIN mxp_companies cm ON(rl.company_id=cm.id) where cm.group_id = `cmpny_id` and rl.cm_group_id = `cm_grp_id`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_searched_trans_key` (IN `_key` VARCHAR(255))  SELECT distinct(tk.translation_key),tk.translation_key_id, tk.is_active FROM mxp_translation_keys tk
 inner join mxp_translations tr on(tk.translation_key_id = tr.translation_key_id)
 WHERE tk.translation_key LIKE CONCAT('%', _key , '%')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_translations_by_key_id` (IN `key_id` INT)  select translation_id, translation, lan_code from mxp_translations
 where translation_key_id= `key_id` and is_active = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_translations_by_locale` (IN `locale_code` VARCHAR(255))  SELECT tr.translation,tk.translation_key FROM mxp_translation_keys tk INNER JOIN mxp_translations tr ON(tr.translation_key_id=tk.translation_key_id)
WHERE tr.lan_code=locale_code$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_translation_by_key_id` (IN `tr_key_id` INT(11))  SELECT tr.translation,tk.translation_key,tk.translation_key_id,tk.is_active,ln.lan_name FROM mxp_translation_keys tk INNER JOIN mxp_translations tr ON(tr.translation_key_id=tk.translation_key_id)
INNER JOIN mxp_languages ln ON(ln.lan_code=tr.lan_code)
WHERE tr.translation_key_id=tr_key_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_menu_by_role` (IN `role_id` INT(11), IN `comp_id` INT(11))  if(comp_id !='') then
SELECT m.* FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE rm.role_id=role_id AND rm.company_id=comp_id;
else
SELECT m.* FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE rm.role_id=role_id;
end if$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_100000_create_password_resets_table', 1),
(2, '2018_01_11_075242_create_languages_table', 1),
(3, '2018_01_12_081050_create_role_table', 1),
(4, '2018_01_12_084141_create_menu_table', 1),
(5, '2018_01_12_122539_add_column_to_mxp_role', 2),
(6, '2018_01_13_100521_create_mxp_users_table', 2),
(7, '2018_01_15_064427_create_mxp_translation_keys', 3),
(8, '2018_01_15_064518_create_mxp_translations', 3),
(9, '2018_01_15_073009_create_mxp_user_role_menu', 4),
(10, '2018_01_15_081551_update_language_table', 5),
(11, '2018_01_15_130417_create_mxp_trans_keys_table', 6),
(12, '2018_01_15_081806_create_mxp_users_table', 7),
(13, '2018_01_15_095153_add_type_column_after_last_name_of_mxp_users', 7),
(14, '2018_01_16_055331_create_mxp_translation_keys_table', 8),
(15, '2018_01_16_060235_create_mxp_translation_keys_table', 9),
(16, '2018_01_16_064618_update_mxp_translation_keys_table', 10),
(17, '2018_01_22_104053_update_mxp_users_table', 11),
(18, '2018_01_26_060729_add_companyId_to_roles_and_role_menus', 11),
(19, '2018_01_25_130557_create_companies_table', 12),
(20, '2018_01_26_054823_drop_company_column_from_mxp_users_table', 12),
(21, '2018_01_26_071103_add_column_to_mxp_user_table', 13),
(22, '2018_01_26_075012_create_store_pro_get_company_by_group_id', 14),
(24, '2018_01_27_130037_create_store_pro_get_roles_by_company_id', 16),
(25, '2018_01_30_081529_update_mxp_role', 17),
(26, '2018_01_30_093232_create_store_pro_get_all_companies_of_same_name_by_group_id', 17),
(27, '2018_01_30_105605_update_mxp_translations', 17),
(45, '2018_01_27_110718_update_mxp_role_table', 18),
(46, '2018_02_06_100944_create_mxp_taxvats_table', 18),
(47, '2018_02_06_103251_create_mxp_taxvat_cals_table', 18),
(48, '2018_04_04_053741_create_mxp_accounts_heads_table', 19),
(49, '2018_04_05_093858_create_store_procedure_get_all_acc_class', 20),
(50, '2018_04_05_123858_create_mxp_acc_head_sub_classes_table', 20),
(51, '2018_04_06_060320_create_store_pro_get_all_sub_class_name', 20),
(52, '2018_04_06_070031_create_store_pro_get_all_chart_of_accounts', 20),
(53, '2018_04_05_125024_create_mxp_chart_of_acc_heads_table', 21);

-- --------------------------------------------------------

--
-- Table structure for table `mxp_accounts_heads`
--

CREATE TABLE `mxp_accounts_heads` (
  `accounts_heads_id` int(10) UNSIGNED NOT NULL,
  `head_name_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `company_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_deleted` tinyint(4) NOT NULL,
  `is_active` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_accounts_heads`
--

INSERT INTO `mxp_accounts_heads` (`accounts_heads_id`, `head_name_type`, `account_code`, `company_id`, `group_id`, `user_id`, `is_deleted`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Assets', '1010-01', 0, 1, 1, 0, 1, '2018-04-07 03:00:21', '2018-04-07 03:00:56'),
(2, 'Expenses', '1010-02', 0, 1, 1, 0, 1, '2018-04-07 03:01:33', '2018-04-07 03:01:33'),
(3, 'Liability', '1010-03', 0, 1, 1, 0, 1, '2018-04-07 03:02:11', '2018-04-07 03:02:11'),
(4, 'Income', '1010-04', 0, 1, 1, 0, 1, '2018-04-07 03:02:25', '2018-04-07 03:02:25');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_accounts_sub_heads`
--

CREATE TABLE `mxp_accounts_sub_heads` (
  `accounts_sub_heads_id` int(10) UNSIGNED NOT NULL,
  `accounts_heads_id` int(11) UNSIGNED NOT NULL,
  `sub_head` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `company_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_deleted` tinyint(4) NOT NULL,
  `is_active` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_accounts_sub_heads`
--

INSERT INTO `mxp_accounts_sub_heads` (`accounts_sub_heads_id`, `accounts_heads_id`, `sub_head`, `company_id`, `group_id`, `user_id`, `is_deleted`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 'current asset', 0, 1, 1, 1, 1, '2018-04-05 06:24:28', '2018-04-07 03:03:12'),
(2, 1, 'Current Assets', 0, 1, 1, 0, 1, '2018-04-07 03:03:25', '2018-04-07 03:03:25'),
(3, 1, 'Non Current Assets', 0, 1, 1, 0, 1, '2018-04-07 03:05:40', '2018-04-07 03:05:40'),
(4, 3, 'Current Liabilities', 0, 1, 1, 0, 1, '2018-04-07 03:06:03', '2018-04-07 03:06:03'),
(5, 2, 'Ordinary Expense', 0, 1, 1, 0, 1, '2018-04-07 03:06:37', '2018-04-07 03:06:37'),
(6, 4, 'Ordinary Income', 0, 1, 1, 0, 1, '2018-04-07 03:07:09', '2018-04-07 03:07:09');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_acc_classes`
--

CREATE TABLE `mxp_acc_classes` (
  `mxp_acc_classes_id` int(10) UNSIGNED NOT NULL,
  `head_class_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `accounts_heads_id` int(10) UNSIGNED NOT NULL,
  `accounts_sub_heads_id` int(10) UNSIGNED NOT NULL,
  `company_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_deleted` tinyint(4) NOT NULL,
  `is_active` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_acc_classes`
--

INSERT INTO `mxp_acc_classes` (`mxp_acc_classes_id`, `head_class_name`, `accounts_heads_id`, `accounts_sub_heads_id`, `company_id`, `group_id`, `user_id`, `is_deleted`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Cash & cash equivalents', 1, 2, 0, 1, 1, 0, 1, '2018-04-07 03:07:51', '2018-04-07 03:07:51'),
(2, 'Receivables', 1, 2, 0, 1, 1, 0, 1, '2018-04-07 03:08:23', '2018-04-07 03:08:23'),
(3, 'Dircet Expenses', 2, 5, 0, 1, 1, 0, 1, '2018-04-07 03:08:55', '2018-04-07 03:08:55'),
(4, 'Income from Services', 4, 6, 0, 1, 1, 0, 1, '2018-04-07 03:09:23', '2018-04-07 03:09:23');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_companies`
--

CREATE TABLE `mxp_companies` (
  `id` int(10) UNSIGNED NOT NULL,
  `group_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_companies`
--

INSERT INTO `mxp_companies` (`id`, `group_id`, `name`, `description`, `address`, `phone`, `is_active`, `created_at`, `updated_at`) VALUES
(10, 1, 'Company-A', 'dsddsd', 'sddsd', '01673197093', 1, '2018-01-29 06:39:19', '2018-01-29 06:39:19'),
(11, 2, 'Company-B', 'dsddsd', 'sddsd', '0167319709377', 1, '2018-01-29 06:39:31', '2018-01-29 06:39:31'),
(13, 38, 'sumit power-23-A', 'fhfhdhf', '445fdfdf', '01674898148', 1, '2018-01-31 02:57:49', '2018-01-31 02:57:49'),
(14, 38, 'sumit power-23-B', 'fhfhdhf', '445fdfdf', '01674898148', 1, '2018-01-31 02:57:58', '2018-01-31 02:57:58'),
(15, 42, 'New Company', 'Descrip', 'dhaka', '1234567890', 1, '2018-02-09 02:06:45', '2018-02-09 02:06:45'),
(16, 42, 'New Company 2', 'description', 'Bangladesh', '1234567', 1, '2018-02-09 02:09:04', '2018-02-09 02:09:04');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_languages`
--

CREATE TABLE `mxp_languages` (
  `id` int(10) UNSIGNED NOT NULL,
  `lan_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lan_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_languages`
--

INSERT INTO `mxp_languages` (`id`, `lan_name`, `lan_code`, `created_at`, `updated_at`, `is_active`) VALUES
(1, 'English', 'en', '2018-03-06 00:10:25', '2018-03-06 00:10:25', 1),
(2, 'বাংলা', 'bn', '2018-03-06 00:10:57', '2018-03-06 00:10:57', 1);

-- --------------------------------------------------------

--
-- Table structure for table `mxp_menu`
--

CREATE TABLE `mxp_menu` (
  `menu_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `route_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` int(11) DEFAULT '0',
  `is_active` int(11) NOT NULL,
  `order_id` int(11) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_menu`
--

INSERT INTO `mxp_menu` (`menu_id`, `name`, `route_name`, `description`, `parent_id`, `is_active`, `order_id`, `created_at`, `updated_at`) VALUES
(3, 'LANGUAGE', 'language-chooser_view', 'Change Language', 0, 1, 0, NULL, NULL),
(4, 'DASHBOARD', 'dashboard_view', 'Super admin Dashboard', 0, 1, 1, NULL, NULL),
(5, 'SETTINGS', '', 'Settings', 0, 1, 2, NULL, NULL),
(6, 'ROLE', '', 'Role Management ', 0, 1, 2, NULL, NULL),
(7, 'ADD ROLE ACTION', 'add_role_action', 'Add new Role', 0, 1, 0, NULL, NULL),
(8, 'Role List', 'role_list_view', 'Role List and manage option', 6, 1, 2, NULL, NULL),
(9, 'ROLE UPDATE FORM', 'role_update_view', 'Show role update Form', 0, 1, 2, NULL, NULL),
(10, 'ROLE DELETE ACTION', 'role_delete_action', 'Delete role', 0, 1, 0, NULL, NULL),
(11, 'UPDATE ROLE ACTION', 'role_update_action', 'Update Role', 0, 1, 0, NULL, NULL),
(12, 'Role Permission ', 'role_permission_view', 'Set Route Access to Role', 6, 1, 3, NULL, NULL),
(13, 'PERMISSION ROLE ACTION', 'role_permission_action', 'Set Route Access to Role', 0, 1, 0, NULL, NULL),
(16, 'ROLE PERMISSION FORM', 'role_permission_update_view', '0', 0, 1, 0, NULL, NULL),
(18, 'Create User', 'create_user_view', 'User Create Form', 5, 1, 1, NULL, NULL),
(19, 'CREATE USER ACTION', 'create_user_action', '', 0, 1, 0, NULL, NULL),
(20, 'User List', 'user_list_view', '', 5, 1, 2, NULL, NULL),
(21, 'USER UPDATE FORM', 'company_user_update_view', '', 0, 1, 0, NULL, NULL),
(22, 'UPDATE USER ACTION', 'company_user_update_action', '', 0, 1, 0, NULL, NULL),
(23, 'DELETE USER ACTION', 'company_user_delete_action', '', 0, 1, 0, NULL, NULL),
(24, 'Manage Langulage', 'manage_language', 'language add and view', 3, 1, 0, NULL, NULL),
(25, 'ADD LANGUAGE ACTION', 'create_locale_action', 'add language', 0, 1, 0, NULL, NULL),
(26, 'UPDATE LOCALE ACTION', 'update_locale_action', 'update language', 0, 1, 0, NULL, NULL),
(27, 'Manage Translation', 'manage_translation', 'manage transaltion', 3, 1, 2, NULL, NULL),
(28, 'CREATE TRANSLATION ACTION', 'create_translation_action', 'create translation', 0, 1, 0, NULL, NULL),
(29, 'UPDATE TRANSLATION ACTION', 'update_translation_action', 'update translation', 0, 1, 0, NULL, NULL),
(30, 'POST UPDATE TRANSLATION ACTION', 'update_translation_key_action', 'post update translaion', 0, 1, 0, NULL, NULL),
(31, 'DELETE TRANSLATION ACTION', 'delete_translation_action', 'delete translation', 0, 1, 0, NULL, NULL),
(32, 'Upload Language File', 'update_language', 'upload language file', 3, 1, 3, NULL, NULL),
(33, 'USER', '', 'User Management', 0, 1, 1, NULL, NULL),
(34, 'Add New Role', 'add_role_view', 'New role adding form', 6, 1, 1, NULL, NULL),
(35, 'Open Company Acc', 'create_company_acc_view', 'Company Account Opening Form', 5, 1, 3, NULL, NULL),
(36, 'OPEN COMPANY ACCOUNT', 'create_company_acc_action', 'Company Acc opening Action', 5, 1, 2, NULL, NULL),
(37, 'Company List', 'company_list_view', 'Company List View', 5, 1, 4, NULL, NULL),
(38, 'PRODUCT', '', 'Product management', 0, 1, 0, NULL, NULL),
(67, 'Add Client', 'client_com_add_view', '', 0, 1, 0, NULL, NULL),
(68, 'CLIENT ADD', 'client_com_add_action', '', 0, 1, 0, NULL, NULL),
(69, 'Client Update', 'client_com_update_view', '', 0, 1, 0, NULL, NULL),
(70, 'CLIENT UPDATE ACTION', 'client_com_update_action', '', 0, 1, 0, NULL, NULL),
(71, 'CLIENT DELETE ACTION', 'client_com_delete_action', '', 0, 1, 0, NULL, NULL),
(72, 'Client List', 'client_com_list_view', 'Show Client List', 5, 1, 5, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `mxp_role`
--

CREATE TABLE `mxp_role` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `company_id` int(11) NOT NULL,
  `cm_group_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_role`
--

INSERT INTO `mxp_role` (`id`, `name`, `company_id`, `cm_group_id`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'super_admin', 0, '', 1, '2018-01-14 20:58:10', '2018-01-25 04:51:10'),
(20, 'sales mnager for company-A', 10, '', 1, '2018-01-29 06:40:01', '2018-01-29 06:40:01'),
(21, 'sales mnager for company-B', 11, '', 1, '2018-01-29 06:40:16', '2018-01-29 06:40:16'),
(22, 'C-a', 10, '', 1, '2018-01-31 02:33:42', '2018-01-31 02:33:42'),
(23, 'Sals Manager_aa', 10, '', 1, '2018-01-31 02:45:42', '2018-01-31 02:45:42'),
(24, 'Sals Manager_aa', 12, '', 1, '2018-01-31 02:45:42', '2018-01-31 02:45:42'),
(25, 'sumit-role-a', 13, '', 1, '2018-01-31 02:58:27', '2018-01-31 02:58:27'),
(26, 'sumit-role-b', 14, '', 1, '2018-01-31 02:58:38', '2018-01-31 02:58:38'),
(27, 'Manager', 10, '', 1, '2018-03-05 13:01:40', '2018-03-05 13:01:40'),
(29, 'test', 10, '57471', 1, '2018-04-09 01:57:41', '2018-04-09 01:57:41');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_translations`
--

CREATE TABLE `mxp_translations` (
  `translation_id` int(10) UNSIGNED NOT NULL,
  `translation` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `translation_key_id` int(11) DEFAULT NULL,
  `lan_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `same_trans_key_id` int(11) NOT NULL,
  `is_active` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_translations`
--

INSERT INTO `mxp_translations` (`translation_id`, `translation`, `translation_key_id`, `lan_code`, `same_trans_key_id`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'MaxPro E.R.P.', 1, 'en', 0, 1, '2018-03-05 18:12:49', '2018-03-05 19:53:12'),
(2, 'ম্যাক্সপ্রো ই. আর. পি.', 1, 'bn', 0, 1, '2018-03-05 18:12:49', '2018-03-05 19:53:12'),
(3, 'Log In', 2, 'en', 0, 1, '2018-03-05 20:38:51', '2018-03-05 20:39:11'),
(4, 'লগ ইন', 2, 'bn', 0, 1, '2018-03-05 20:38:51', '2018-03-05 20:39:11'),
(5, 'Registration', 3, 'en', 0, 1, '2018-03-05 20:39:27', '2018-03-05 20:41:56'),
(6, 'নিবন্ধন করুন', 3, 'bn', 0, 1, '2018-03-05 20:39:27', '2018-03-05 20:41:56'),
(7, 'Whoops!', 4, 'en', 0, 1, '2018-03-05 20:54:56', '2018-03-05 21:04:24'),
(8, 'উপস!', 4, 'bn', 0, 1, '2018-03-05 20:54:56', '2018-03-05 21:04:24'),
(9, 'There were some problems with your input.', 5, 'en', 0, 1, '2018-03-05 20:56:52', '2018-03-05 21:03:46'),
(10, 'আপনার ইনপুট সঙ্গে কিছু সমস্যা ছিল।', 5, 'bn', 0, 1, '2018-03-05 20:56:52', '2018-03-05 21:03:46'),
(11, 'Or you are not active yet.', 6, 'en', 0, 1, '2018-03-05 20:57:04', '2018-03-05 21:03:01'),
(12, 'অথবা আপনি এখনো সক্রিয় নন', 6, 'bn', 0, 1, '2018-03-05 20:57:04', '2018-03-05 21:03:01'),
(13, 'E-Mail Address', 7, 'en', 0, 1, '2018-03-05 20:57:14', '2018-03-05 20:59:25'),
(14, 'ই-মেইল ঠিকানা', 7, 'bn', 0, 1, '2018-03-05 20:57:14', '2018-03-05 20:59:25'),
(15, 'Password', 8, 'en', 0, 1, '2018-03-05 20:57:22', '2018-03-05 21:00:01'),
(16, 'পাসওয়ার্ড', 8, 'bn', 0, 1, '2018-03-05 20:57:22', '2018-03-05 21:00:01'),
(17, 'Remember me?', 9, 'en', 0, 1, '2018-03-05 20:57:31', '2018-03-05 21:02:15'),
(18, 'আমাকে মনে রাখুন?', 9, 'bn', 0, 1, '2018-03-05 20:57:31', '2018-03-05 21:02:15'),
(19, 'Forgot Your Password?', 10, 'en', 0, 1, '2018-03-05 20:57:39', '2018-03-05 21:00:39'),
(20, 'আপনি কি পাসওয়ার্ড ভুলে গেছেন?', 10, 'bn', 0, 1, '2018-03-05 20:57:39', '2018-03-05 21:00:39'),
(21, 'Dashboard', 11, 'en', 0, 1, '2018-03-05 23:23:51', '2018-03-05 23:32:59'),
(22, 'ড্যাশবোর্ড', 11, 'bn', 0, 1, '2018-03-05 23:23:51', '2018-03-05 23:32:59'),
(23, 'Language List', 12, 'en', 0, 1, '2018-03-05 23:34:35', '2018-03-05 23:35:06'),
(24, 'ভাষা তালিকা', 12, 'bn', 0, 1, '2018-03-05 23:34:35', '2018-03-05 23:35:06'),
(25, 'Serial no.', 13, 'en', 0, 1, '2018-03-05 23:36:43', '2018-03-05 23:37:54'),
(26, 'ক্রমিক নং', 13, 'bn', 0, 1, '2018-03-05 23:36:44', '2018-03-05 23:37:54'),
(27, 'Language Title', 14, 'en', 0, 1, '2018-03-05 23:38:13', '2018-03-05 23:38:37'),
(28, 'ভাষা শিরোনাম', 14, 'bn', 0, 1, '2018-03-05 23:38:13', '2018-03-05 23:38:37'),
(29, 'Language Code', 15, 'en', 0, 1, '2018-03-05 23:38:47', '2018-03-05 23:39:11'),
(30, 'ভাষা কোড', 15, 'bn', 0, 1, '2018-03-05 23:38:47', '2018-03-05 23:39:11'),
(31, 'Status', 16, 'en', 0, 1, '2018-03-05 23:39:23', '2018-03-05 23:40:25'),
(32, 'সাময়িক অবস্থা', 16, 'bn', 0, 1, '2018-03-05 23:39:23', '2018-03-05 23:40:25'),
(33, 'Action', 17, 'en', 0, 1, '2018-03-05 23:40:40', '2018-03-05 23:42:00'),
(34, 'ক্রিয়াকলাপ', 17, 'bn', 0, 1, '2018-03-05 23:40:40', '2018-03-05 23:42:00'),
(35, 'Active', 18, 'en', 0, 1, '2018-03-05 23:43:00', '2018-03-05 23:43:27'),
(36, 'সক্রিয়', 18, 'bn', 0, 1, '2018-03-05 23:43:00', '2018-03-05 23:43:27'),
(37, 'Inactive', 19, 'en', 0, 1, '2018-03-05 23:43:47', '2018-03-05 23:44:13'),
(38, 'নিষ্ক্রিয়', 19, 'bn', 0, 1, '2018-03-05 23:43:47', '2018-03-05 23:44:13'),
(39, 'Add Locale', 20, 'en', 0, 1, '2018-03-05 23:58:03', '2018-03-05 23:59:51'),
(40, 'স্থান যোগ করুন', 20, 'bn', 0, 1, '2018-03-05 23:58:03', '2018-03-05 23:59:52'),
(41, 'edit', 21, 'en', 0, 1, '2018-03-06 00:00:03', '2018-03-06 00:01:53'),
(42, 'পরিবর্তন করুন', 21, 'bn', 0, 1, '2018-03-06 00:00:03', '2018-03-06 00:01:53'),
(43, 'Add new Language', 22, 'en', 0, 1, '2018-03-06 00:14:26', '2018-03-06 00:15:12'),
(44, 'নতুন ভাষা যোগ করুন', 22, 'bn', 0, 1, '2018-03-06 00:14:26', '2018-03-06 00:15:12'),
(45, 'Add Language', 23, 'en', 0, 1, '2018-03-06 00:15:45', '2018-03-06 00:16:16'),
(46, 'ভাষা যোগ করুন', 23, 'bn', 0, 1, '2018-03-06 00:15:45', '2018-03-06 00:16:16'),
(47, 'Enter Language Title', 24, 'en', 0, 1, '2018-03-06 00:16:49', '2018-03-06 00:17:21'),
(48, 'ভাষা শিরোনাম লিখুন', 24, 'bn', 0, 1, '2018-03-06 00:16:49', '2018-03-06 00:17:21'),
(49, 'Enter Language Code', 25, 'en', 0, 1, '2018-03-06 00:17:31', '2018-03-06 00:17:54'),
(50, 'ভাষা কোড লিখুন', 25, 'bn', 0, 1, '2018-03-06 00:17:31', '2018-03-06 00:17:54'),
(51, 'Save', 26, 'en', 0, 1, '2018-03-06 00:18:57', '2018-03-06 00:19:17'),
(52, 'সংরক্ষণ করুন', 26, 'bn', 0, 1, '2018-03-06 00:18:57', '2018-03-06 00:19:17'),
(53, 'Update Locale', 27, 'en', 0, 1, '2018-03-06 00:23:12', '2018-03-06 00:28:13'),
(54, 'লোকেল আপডেট করুন', 27, 'bn', 0, 1, '2018-03-06 00:23:12', '2018-03-06 00:28:13'),
(55, 'Update Language Title', 28, 'en', 0, 1, '2018-03-06 00:28:35', '2018-03-06 00:29:18'),
(56, 'ভাষা শিরোনাম আপডেট করুন', 28, 'bn', 0, 1, '2018-03-06 00:28:36', '2018-03-06 00:29:18'),
(57, 'Update Language Code', 29, 'en', 0, 1, '2018-03-06 00:29:32', '2018-03-06 00:29:55'),
(58, 'ভাষা কোড আপডেট করুন', 29, 'bn', 0, 1, '2018-03-06 00:29:32', '2018-03-06 00:29:55'),
(59, 'Update', 30, 'en', 0, 1, '2018-03-06 00:30:07', '2018-03-06 00:30:52'),
(60, 'পরিবর্তন করুন', 30, 'bn', 0, 1, '2018-03-06 00:30:07', '2018-03-06 00:30:52'),
(61, 'Update Language', 31, 'en', 0, 1, '2018-03-06 00:32:05', '2018-03-06 00:32:45'),
(62, 'ভাষা আপডেট করুন', 31, 'bn', 0, 1, '2018-03-06 00:32:05', '2018-03-06 00:32:45'),
(63, 'Comfirm! you want to upload translation file..', 32, 'en', 0, 1, '2018-03-06 00:34:41', '2018-03-06 00:36:01'),
(64, 'নিশ্চিত করুন! আপনি অনুবাদ ফাইল আপলোড করতে চান ..', 32, 'bn', 0, 1, '2018-03-06 00:34:41', '2018-03-06 00:36:01'),
(65, 'Upload', 33, 'en', 0, 1, '2018-03-06 00:36:42', '2018-03-06 00:37:14'),
(66, 'আপলোড', 33, 'bn', 0, 1, '2018-03-06 00:36:42', '2018-03-06 00:37:14'),
(67, 'Translation List', 34, 'en', 0, 1, '2018-03-06 00:39:26', '2018-03-06 00:49:15'),
(68, 'অনুবাদ তালিকা', 34, 'bn', 0, 1, '2018-03-06 00:39:26', '2018-03-06 00:49:15'),
(69, 'Add new key', 35, 'en', 0, 1, '2018-03-06 00:49:29', '2018-03-06 00:51:01'),
(70, 'নতুন টীকা যোগ করুন', 35, 'bn', 0, 1, '2018-03-06 00:49:29', '2018-03-06 00:51:01'),
(71, 'Search the translation key....', 36, 'en', 0, 1, '2018-03-06 00:51:16', '2018-03-06 00:52:27'),
(72, 'অনুবাদ টীকা অনুসন্ধান করুন ....', 36, 'bn', 0, 1, '2018-03-06 00:51:16', '2018-03-06 00:52:27'),
(73, 'Translation key', 37, 'en', 0, 1, '2018-03-06 00:52:45', '2018-03-06 00:54:17'),
(74, 'অনুবাদ টীকা', 37, 'bn', 0, 1, '2018-03-06 00:52:45', '2018-03-06 00:54:17'),
(75, 'Translation', 38, 'en', 0, 1, '2018-03-06 00:54:31', '2018-03-06 00:55:09'),
(76, 'অনুবাদ', 38, 'bn', 0, 1, '2018-03-06 00:54:31', '2018-03-06 00:55:09'),
(77, 'Language', 39, 'en', 0, 1, '2018-03-06 00:55:21', '2018-03-06 00:55:50'),
(78, 'ভাষা', 39, 'bn', 0, 1, '2018-03-06 00:55:21', '2018-03-06 00:55:50'),
(79, 'Delete', 40, 'en', 0, 1, '2018-03-06 00:56:29', '2018-03-06 00:56:51'),
(80, 'বাদ দিন', 40, 'bn', 0, 1, '2018-03-06 00:56:29', '2018-03-06 00:56:51'),
(81, 'Add new translation key', 41, 'en', 0, 1, '2018-03-06 01:07:29', '2018-03-06 01:08:09'),
(82, 'নতুন অনুবাদ টীকা যোগ করুন', 41, 'bn', 0, 1, '2018-03-06 01:07:29', '2018-03-06 01:08:09'),
(83, 'Enter Translation key', 42, 'en', 0, 1, '2018-03-06 01:08:20', '2018-03-06 01:09:01'),
(84, 'অনুবাদ টীকা প্রবেশ করান', 42, 'bn', 0, 1, '2018-03-06 01:08:20', '2018-03-06 01:09:01'),
(85, 'Update Translation', 43, 'en', 0, 1, '2018-03-06 01:18:54', '2018-03-06 01:19:29'),
(86, 'অনুবাদ আপডেট করুন', 43, 'bn', 0, 1, '2018-03-06 01:18:54', '2018-03-06 01:19:29'),
(87, 'Update Translation key', 44, 'en', 0, 1, '2018-03-06 01:19:50', '2018-03-06 01:20:39'),
(88, 'অনুবাদ টীকা আপডেট করুন', 44, 'bn', 0, 1, '2018-03-06 01:19:50', '2018-03-06 01:20:39'),
(89, 'LANGUAGE', 45, 'en', 0, 1, '2018-03-06 19:21:58', '2018-03-06 19:27:49'),
(90, 'ভাষা', 45, 'bn', 0, 1, '2018-03-06 19:21:58', '2018-03-06 19:27:49'),
(91, 'Manage Language', 46, 'en', 0, 1, '2018-03-06 19:23:15', '2018-03-06 19:24:25'),
(92, 'ভাষা পরিচালনা করুন', 46, 'bn', 0, 1, '2018-03-06 19:23:15', '2018-03-06 19:24:25'),
(93, 'Manage Translation', 47, 'en', 0, 1, '2018-03-06 19:24:37', '2018-03-06 19:25:16'),
(94, 'অনুবাদ পরিচালনা করুন', 47, 'bn', 0, 1, '2018-03-06 19:24:37', '2018-03-06 19:25:17'),
(95, 'Upload Language File', 48, 'en', 0, 1, '2018-03-06 19:25:41', '2018-03-06 19:26:18'),
(96, 'ভাষা ফাইল আপলোড করুন', 48, 'bn', 0, 1, '2018-03-06 19:25:41', '2018-03-06 19:26:18'),
(97, 'ROLE', 49, 'en', 0, 1, '2018-03-06 19:26:59', '2018-03-06 19:27:26'),
(98, 'ভূমিকা', 49, 'bn', 0, 1, '2018-03-06 19:26:59', '2018-03-06 19:27:26'),
(99, 'Add New Role', 50, 'en', 0, 1, '2018-03-06 19:28:03', '2018-03-06 19:29:56'),
(100, 'নতুন ভূমিকা যোগ করুন', 50, 'bn', 0, 1, '2018-03-06 19:28:03', '2018-03-06 19:29:56'),
(101, 'Role List', 51, 'en', 0, 1, '2018-03-06 19:30:11', '2018-03-06 19:30:35'),
(102, 'ভূমিকা তালিকা', 51, 'bn', 0, 1, '2018-03-06 19:30:11', '2018-03-06 19:30:36'),
(103, 'Role Permission', 52, 'en', 0, 1, '2018-03-06 19:30:45', '2018-03-06 19:31:10'),
(104, 'ভূমিকা অনুমতি', 52, 'bn', 0, 1, '2018-03-06 19:30:45', '2018-03-06 19:31:10'),
(105, 'SETTINGS', 53, 'en', 0, 1, '2018-03-06 19:31:22', '2018-03-06 19:31:55'),
(106, 'সেটিংস', 53, 'bn', 0, 1, '2018-03-06 19:31:22', '2018-03-06 19:31:55'),
(107, 'Open Company Account', 54, 'en', 0, 1, '2018-03-06 19:32:15', '2018-03-06 19:34:08'),
(108, 'কোম্পানি অ্যাকাউন্ট খোলা', 54, 'bn', 0, 1, '2018-03-06 19:32:15', '2018-03-06 19:34:08'),
(109, 'Company List', 55, 'en', 0, 1, '2018-03-06 19:34:19', '2018-03-06 19:34:45'),
(110, 'কোম্পানি তালিকা', 55, 'bn', 0, 1, '2018-03-06 19:34:19', '2018-03-06 19:34:45'),
(111, 'Create User', 56, 'en', 0, 1, '2018-03-06 19:34:56', '2018-03-06 19:36:05'),
(112, 'নতুন ব্যবহারকারী সংযোজন', 56, 'bn', 0, 1, '2018-03-06 19:34:56', '2018-03-06 19:36:05'),
(113, 'Create User', 57, 'en', 0, 1, '2018-03-06 19:36:15', '2018-03-06 19:38:03'),
(114, 'নতুন ব্যবহারকারী সংযোজন', 57, 'bn', 0, 1, '2018-03-06 19:36:15', '2018-03-06 19:38:03'),
(115, 'User List', 58, 'en', 0, 1, '2018-03-06 19:39:56', '2018-03-06 19:40:22'),
(116, 'ব্যবহারকারীর তালিকা', 58, 'bn', 0, 1, '2018-03-06 19:39:56', '2018-03-06 19:40:22'),
(117, 'Client List', 59, 'en', 0, 1, '2018-03-06 19:40:33', '2018-03-06 19:41:36'),
(118, 'গ্রাহকের তালিকা', 59, 'bn', 0, 1, '2018-03-06 19:40:33', '2018-03-06 19:41:36'),
(119, 'PRODUCT', 60, 'en', 0, 1, '2018-03-06 19:41:56', '2018-03-06 19:42:18'),
(120, 'পণ্য', 60, 'bn', 0, 1, '2018-03-06 19:41:56', '2018-03-06 19:42:18'),
(121, 'Product\'s Unit', 61, 'en', 0, 1, '2018-03-06 19:42:32', '2018-03-06 19:48:13'),
(122, 'পণ্যের একক', 61, 'bn', 0, 1, '2018-03-06 19:42:32', '2018-03-06 19:48:13'),
(123, 'Product Group', 62, 'en', 0, 1, '2018-03-06 19:48:24', '2018-03-06 19:48:54'),
(124, 'পণ্যের গ্রুপ', 62, 'bn', 0, 1, '2018-03-06 19:48:25', '2018-03-06 19:48:54'),
(125, 'Product Entry', 63, 'en', 0, 1, '2018-03-06 19:49:03', '2018-03-06 19:50:00'),
(126, 'পণ্য সংযোজন', 63, 'bn', 0, 1, '2018-03-06 19:49:03', '2018-03-06 19:50:00'),
(127, 'Product Packing', 64, 'en', 0, 1, '2018-03-06 19:50:09', '2018-03-06 19:50:39'),
(128, 'পণ্য প্যাকেজিং', 64, 'bn', 0, 1, '2018-03-06 19:50:09', '2018-03-06 19:50:39'),
(129, 'Purchase', 65, 'en', 0, 1, '2018-03-06 19:50:54', '2018-03-06 19:51:38'),
(130, 'ক্রয়', 65, 'bn', 0, 1, '2018-03-06 19:50:54', '2018-03-06 19:51:38'),
(131, 'Purchase List', 66, 'en', 0, 1, '2018-03-06 19:51:47', '2018-03-06 19:52:14'),
(132, 'ক্রয় তালিকা', 66, 'bn', 0, 1, '2018-03-06 19:51:48', '2018-03-06 19:52:14'),
(133, 'Update Stock', 67, 'en', 0, 1, '2018-03-06 19:52:27', '2018-03-06 19:53:39'),
(134, 'আপডেট স্টক', 67, 'bn', 0, 1, '2018-03-06 19:52:27', '2018-03-06 19:53:40'),
(135, 'Vat Tax List', 68, 'en', 0, 1, '2018-03-06 19:53:48', '2018-03-06 19:54:15'),
(136, 'ভ্যাট ট্যাক্স তালিকা', 68, 'bn', 0, 1, '2018-03-06 19:53:48', '2018-03-06 19:54:15'),
(137, 'Sale List', 69, 'en', 0, 1, '2018-03-06 19:54:25', '2018-03-06 19:54:55'),
(138, 'বিক্রয় তালিকা', 69, 'bn', 0, 1, '2018-03-06 19:54:25', '2018-03-06 19:54:55'),
(139, 'Save Sale', 70, 'en', 0, 1, '2018-03-06 19:55:15', '2018-03-06 19:56:07'),
(140, 'বিক্রয় যোগ করুন', 70, 'bn', 0, 1, '2018-03-06 19:55:15', '2018-03-06 19:56:07'),
(141, 'Inventory Report', 71, 'en', 0, 1, '2018-03-06 19:56:45', '2018-03-06 19:57:12'),
(142, 'পরিসংখ্যা প্রতিবেদন', 71, 'bn', 0, 1, '2018-03-06 19:56:45', '2018-03-06 19:57:12'),
(143, 'STOCK MANAGEMENT', 72, 'en', 0, 1, '2018-03-06 19:57:21', '2018-03-06 19:57:51'),
(144, 'স্টক ব্যবস্থাপনা', 72, 'bn', 0, 1, '2018-03-06 19:57:21', '2018-03-06 19:57:51'),
(145, 'Store', 73, 'en', 0, 1, '2018-03-06 19:58:01', '2018-03-06 19:58:42'),
(146, 'ভাণ্ডার', 73, 'bn', 0, 1, '2018-03-06 19:58:01', '2018-03-06 19:58:42'),
(147, 'Stock', 74, 'en', 0, 1, '2018-03-06 19:58:53', '2018-03-06 19:59:16'),
(148, 'স্টক', 74, 'bn', 0, 1, '2018-03-06 19:58:53', '2018-03-06 19:59:17'),
(151, 'Company/Client Name', 76, 'en', 0, 1, '2018-03-06 20:57:06', '2018-03-06 20:57:55'),
(152, 'কোম্পানী / গ্রাহকের নাম', 76, 'bn', 0, 1, '2018-03-06 20:57:06', '2018-03-06 20:57:55'),
(153, 'Role Name', 77, 'en', 0, 1, '2018-03-06 21:05:38', '2018-03-06 21:06:30'),
(154, 'ভূমিকার নাম', 77, 'bn', 0, 1, '2018-03-06 21:05:38', '2018-03-06 21:06:30'),
(155, 'Select Company/Client', 78, 'en', 0, 1, '2018-03-06 21:06:59', '2018-03-06 21:07:40'),
(156, 'কোম্পানী / ক্লায়েন্ট নির্বাচন করুন', 78, 'bn', 0, 1, '2018-03-06 21:06:59', '2018-03-06 21:07:40'),
(157, 'Select Role', 79, 'en', 0, 1, '2018-03-06 21:08:51', '2018-03-06 21:09:15'),
(158, 'ভূমিকা নির্বাচন করুন', 79, 'bn', 0, 1, '2018-03-06 21:08:51', '2018-03-06 21:09:15'),
(159, 'Select All', 80, 'en', 0, 1, '2018-03-06 21:11:57', '2018-03-06 21:12:22'),
(160, 'সব নির্বাচন করুন', 80, 'bn', 0, 1, '2018-03-06 21:11:57', '2018-03-06 21:12:23'),
(161, 'Unselect all', 81, 'en', 0, 1, '2018-03-06 21:12:36', '2018-03-06 21:12:57'),
(162, 'সরিয়ে ফেলুন সব', 81, 'bn', 0, 1, '2018-03-06 21:12:36', '2018-03-06 21:12:57'),
(163, 'SET', 82, 'en', 0, 1, '2018-03-06 21:14:03', '2018-03-06 21:14:34'),
(164, 'নিযুক্ত করা', 82, 'bn', 0, 1, '2018-03-06 21:14:03', '2018-03-06 21:14:34'),
(165, 'Assign Role', 83, 'en', 0, 1, '2018-03-06 21:15:41', '2018-03-06 21:16:07'),
(166, 'ভূমিকা অর্পণ', 83, 'bn', 0, 1, '2018-03-06 21:15:41', '2018-03-06 21:16:07'),
(167, 'Role Permission List', 84, 'en', 0, 1, '2018-03-06 21:19:23', '2018-03-06 21:19:45'),
(168, 'ভূমিকা অনুমতি তালিকা', 84, 'bn', 0, 1, '2018-03-06 21:19:23', '2018-03-06 21:19:45'),
(169, 'Permitted Route List', 85, 'en', 0, 1, '2018-03-06 21:19:57', '2018-03-06 21:20:30'),
(170, 'অনুমোদিত রুট তালিকা', 85, 'bn', 0, 1, '2018-03-06 21:19:57', '2018-03-06 21:20:30'),
(171, 'Update Role', 86, 'en', 0, 1, '2018-03-06 21:36:58', '2018-03-06 21:37:20'),
(172, 'আপডেট ভূমিকা', 86, 'bn', 0, 1, '2018-03-06 21:36:58', '2018-03-06 21:37:20'),
(173, 'Add Stock', 87, 'en', 0, 1, '2018-03-06 22:00:58', '2018-03-06 22:01:24'),
(174, 'স্টক যোগ করুন', 87, 'bn', 0, 1, '2018-03-06 22:00:58', '2018-03-06 22:01:24'),
(175, 'Product/Particular Name', 88, 'en', 0, 1, '2018-03-06 22:01:41', '2018-03-06 22:02:19'),
(176, 'পণ্য / বিশেষ নাম', 88, 'bn', 0, 1, '2018-03-06 22:01:41', '2018-03-06 22:02:19'),
(177, 'Product/Particular Group', 89, 'en', 0, 1, '2018-03-06 22:02:40', '2018-03-06 22:03:10'),
(178, 'পণ্য / বিশেষ গ্রুপ', 89, 'bn', 0, 1, '2018-03-06 22:02:40', '2018-03-06 22:03:10'),
(179, 'Quantity', 90, 'en', 0, 1, '2018-03-06 22:03:38', '2018-03-06 22:04:05'),
(180, 'পরিমাণ', 90, 'bn', 0, 1, '2018-03-06 22:03:38', '2018-03-06 22:04:05'),
(181, 'Select Location', 91, 'en', 0, 1, '2018-03-06 22:04:43', '2018-03-06 22:05:00'),
(182, 'স্থান নির্বাচন করুন', 91, 'bn', 0, 1, '2018-03-06 22:04:43', '2018-03-06 22:05:01'),
(187, 'Add new Store', 94, 'en', 0, 1, '2018-03-06 22:21:41', '2018-03-06 22:22:04'),
(188, 'নতুন স্টোর যোগ করুন', 94, 'bn', 0, 1, '2018-03-06 22:21:41', '2018-03-06 22:22:04'),
(189, 'Add store', 95, 'en', 0, 1, '2018-03-06 22:22:14', '2018-03-06 22:22:58'),
(190, 'স্টোর যোগ করুন', 95, 'bn', 0, 1, '2018-03-06 22:22:14', '2018-03-06 22:22:58'),
(191, 'Enter Store Name', 96, 'en', 0, 1, '2018-03-06 22:23:21', '2018-03-06 22:23:42'),
(192, 'স্টোর নাম লিখুন', 96, 'bn', 0, 1, '2018-03-06 22:23:21', '2018-03-06 22:23:42'),
(193, 'Enter Store Location', 97, 'en', 0, 1, '2018-03-06 22:23:51', '2018-03-06 22:24:16'),
(194, 'দোকানের অবস্থান লিখুন', 97, 'bn', 0, 1, '2018-03-06 22:23:51', '2018-03-06 22:24:16'),
(195, 'Update Store', 98, 'en', 0, 1, '2018-03-06 22:27:47', '2018-03-06 22:28:16'),
(196, 'আপডেট স্টোর', 98, 'bn', 0, 1, '2018-03-06 22:27:47', '2018-03-06 22:28:16'),
(199, 'Store List', 100, 'en', 0, 1, '2018-03-06 22:34:46', '2018-03-06 22:36:17'),
(200, 'স্টোর তালিকা', 100, 'bn', 0, 1, '2018-03-06 22:34:46', '2018-03-06 22:36:17'),
(201, 'Store Name', 101, 'en', 0, 1, '2018-03-06 22:36:32', '2018-03-06 22:37:16'),
(202, 'স্টোরের নাম', 101, 'bn', 0, 1, '2018-03-06 22:36:32', '2018-03-06 22:37:16'),
(203, 'Store Location', 102, 'en', 0, 1, '2018-03-06 22:37:36', '2018-03-06 22:38:13'),
(204, 'স্টোরের অবস্থান', 102, 'bn', 0, 1, '2018-03-06 22:37:36', '2018-03-06 22:38:13'),
(205, 'List of Responsible people', 103, 'en', 0, 1, '2018-03-06 22:45:51', '2018-03-06 22:46:15'),
(206, 'দায়ী ব্যক্তিদের তালিকা', 103, 'bn', 0, 1, '2018-03-06 22:45:51', '2018-03-06 22:46:15'),
(207, 'Company/Client Phone Number', 104, 'en', 0, 1, '2018-03-07 21:50:23', '2018-03-07 21:51:13'),
(208, 'কোম্পানী / ক্লায়েন্ট ফোন নম্বর', 104, 'bn', 0, 1, '2018-03-07 21:50:23', '2018-03-07 21:51:13'),
(209, 'Company/Client Address', 105, 'en', 0, 1, '2018-03-07 21:51:29', '2018-03-07 21:51:58'),
(210, 'কোম্পানী / ক্লায়েন্ট ঠিকানা', 105, 'bn', 0, 1, '2018-03-07 21:51:29', '2018-03-07 21:51:58'),
(211, 'Company/Client Description', 106, 'en', 0, 1, '2018-03-07 21:52:22', '2018-03-07 21:52:55'),
(212, 'কোম্পানি / ক্লায়েন্ট বর্ণনা', 106, 'bn', 0, 1, '2018-03-07 21:52:22', '2018-03-07 21:52:55'),
(213, 'Employee Name', 107, 'en', 0, 1, '2018-03-07 23:00:58', '2018-03-07 23:02:22'),
(214, 'কর্মকর্তার নাম', 107, 'bn', 0, 1, '2018-03-07 23:00:58', '2018-03-07 23:02:22'),
(215, 'Personal Phone Number', 108, 'en', 0, 1, '2018-03-07 23:02:33', '2018-03-07 23:03:02'),
(216, 'ব্যক্তিগত ফোন নম্বর', 108, 'bn', 0, 1, '2018-03-07 23:02:33', '2018-03-07 23:03:02'),
(217, 'Employee Address', 109, 'en', 0, 1, '2018-03-07 23:03:16', '2018-03-07 23:03:38'),
(218, 'কর্মচারী ঠিকানা', 109, 'bn', 0, 1, '2018-03-07 23:03:16', '2018-03-07 23:03:38'),
(219, 'Password Confirmation', 110, 'en', 0, 1, '2018-03-07 23:03:52', '2018-03-07 23:04:14'),
(220, 'পাসওয়ার্ড নিশ্চিতকরণ', 110, 'bn', 0, 1, '2018-03-07 23:03:52', '2018-03-07 23:04:14'),
(221, 'Search', 111, 'en', 0, 1, '2018-03-07 23:11:42', '2018-03-07 23:11:59'),
(222, 'অনুসন্ধান', 111, 'bn', 0, 1, '2018-03-07 23:11:43', '2018-03-07 23:11:59'),
(223, 'Company', 112, 'en', 0, 1, '2018-03-07 23:21:05', '2018-03-07 23:21:36'),
(224, 'কোম্পানি', 112, 'bn', 0, 1, '2018-03-07 23:21:05', '2018-03-07 23:21:36'),
(225, 'Add Client/Company', 113, 'en', 0, 1, '2018-03-07 23:52:58', '2018-03-07 23:53:35'),
(226, 'ক্লায়েন্ট / কোম্পানি যোগ করুন', 113, 'bn', 0, 1, '2018-03-07 23:52:58', '2018-03-07 23:53:35'),
(227, 'Update Company/Client', 114, 'en', 0, 1, '2018-03-08 17:19:08', '2018-03-08 17:27:08'),
(228, 'আপডেট কোম্পানী / ক্লায়েন্ট', 114, 'bn', 0, 1, '2018-03-08 17:19:08', '2018-03-08 17:27:08'),
(229, 'Add Packet', 115, 'en', 0, 1, '2018-03-09 17:02:11', '2018-03-09 17:02:56'),
(230, 'প্যাকেট যোগ করুন', 115, 'bn', 0, 1, '2018-03-09 17:02:11', '2018-03-09 17:02:56'),
(231, 'Select Unit', 116, 'en', 0, 1, '2018-03-09 17:04:20', '2018-03-09 17:04:45'),
(232, 'ইউনিট নির্বাচন করুন', 116, 'bn', 0, 1, '2018-03-09 17:04:20', '2018-03-09 17:04:45'),
(233, 'Packet Name', 117, 'en', 0, 1, '2018-03-09 17:06:17', '2018-03-09 17:06:34'),
(234, 'প্যাকেট নাম', 117, 'bn', 0, 1, '2018-03-09 17:06:17', '2018-03-09 17:06:34'),
(235, 'Unit Quantity', 118, 'en', 0, 1, '2018-03-09 17:07:27', '2018-03-09 17:07:48'),
(236, 'একক পরিমাণ', 118, 'bn', 0, 1, '2018-03-09 17:07:27', '2018-03-09 17:07:48'),
(237, 'Update Packet', 119, 'en', 0, 1, '2018-03-09 17:13:42', '2018-03-09 17:14:04'),
(238, 'আপডেট প্যাকেট', 119, 'bn', 0, 1, '2018-03-09 17:13:42', '2018-03-09 17:14:04'),
(239, 'Unit', 120, 'en', 0, 1, '2018-03-09 17:18:32', '2018-03-09 17:18:51'),
(240, 'একক', 120, 'bn', 0, 1, '2018-03-09 17:18:32', '2018-03-09 17:18:51'),
(241, 'Packet List', 121, 'en', 0, 1, '2018-03-09 17:24:19', '2018-03-09 17:24:43'),
(242, 'প্যাকেট তালিকা', 121, 'bn', 0, 1, '2018-03-09 17:24:19', '2018-03-09 17:24:43'),
(243, 'Add new Product', 122, 'en', 0, 1, '2018-03-09 17:52:50', '2018-03-09 17:53:11'),
(244, 'নতুন পণ্য যোগ করুন', 122, 'bn', 0, 1, '2018-03-09 17:52:50', '2018-03-09 17:53:11'),
(245, 'Add Product', 123, 'en', 0, 1, '2018-03-09 17:53:19', '2018-03-09 17:53:41'),
(246, 'পণ্য যোগ করুন', 123, 'bn', 0, 1, '2018-03-09 17:53:19', '2018-03-09 17:53:41'),
(247, 'Packet details', 124, 'en', 0, 1, '2018-03-09 17:56:43', '2018-03-09 17:56:59'),
(248, 'প্যাকেট বিস্তারিত', 124, 'bn', 0, 1, '2018-03-09 17:56:43', '2018-03-09 17:56:59'),
(249, 'Product Code', 125, 'en', 0, 1, '2018-03-09 18:02:50', '2018-03-09 18:03:28'),
(250, 'পণ্য কোড', 125, 'bn', 0, 1, '2018-03-09 18:02:50', '2018-03-09 18:03:28'),
(251, 'Update Product', 126, 'en', 0, 1, '2018-03-09 18:09:32', '2018-03-09 18:10:24'),
(252, 'আপডেট পণ্য', 126, 'bn', 0, 1, '2018-03-09 18:09:33', '2018-03-09 18:10:24'),
(253, 'Edit product', 127, 'en', 0, 1, '2018-03-09 18:10:38', '2018-03-09 18:11:58'),
(254, 'পণ্য সংস্করণ', 127, 'bn', 0, 1, '2018-03-09 18:10:38', '2018-03-09 18:11:58'),
(255, 'Product Group Name', 128, 'en', 0, 1, '2018-03-09 18:26:17', '2018-03-09 18:26:37'),
(256, 'পণ্য গ্রুপ নাম', 128, 'bn', 0, 1, '2018-03-09 18:26:17', '2018-03-09 18:26:37'),
(257, 'Add product group', 129, 'en', 0, 1, '2018-03-09 18:26:52', '2018-03-09 18:27:11'),
(258, 'পণ্য গ্রুপ যোগ করুন', 129, 'bn', 0, 1, '2018-03-09 18:26:52', '2018-03-09 18:27:11'),
(259, 'Add new product group', 130, 'en', 0, 1, '2018-03-09 18:27:22', '2018-03-09 18:27:45'),
(260, 'নতুন পণ্য গ্রুপ যোগ করুন', 130, 'bn', 0, 1, '2018-03-09 18:27:22', '2018-03-09 18:27:45'),
(261, 'Update Product Group', 131, 'en', 0, 1, '2018-03-09 18:34:53', '2018-03-09 18:35:12'),
(262, 'আপডেট পণ্য গ্রুপ', 131, 'bn', 0, 1, '2018-03-09 18:34:53', '2018-03-09 18:35:12'),
(263, 'Edit product group', 132, 'en', 0, 1, '2018-03-09 18:35:57', '2018-03-09 18:36:25'),
(264, 'পণ্য গ্রুপ সম্পাদনা করুন', 132, 'bn', 0, 1, '2018-03-09 18:35:57', '2018-03-09 18:36:25'),
(265, 'Product Group List', 133, 'en', 0, 1, '2018-03-09 18:39:48', '2018-03-09 18:40:05'),
(266, 'পণ্য গ্রুপ তালিকা', 133, 'bn', 0, 1, '2018-03-09 18:39:48', '2018-03-09 18:40:05'),
(267, 'Unit name', 134, 'en', 0, 1, '2018-03-09 19:00:04', '2018-03-09 19:00:25'),
(268, 'ইউনিটের নাম', 134, 'bn', 0, 1, '2018-03-09 19:00:04', '2018-03-09 19:00:25'),
(269, 'Add unit', 135, 'en', 0, 1, '2018-03-09 19:00:51', '2018-03-09 19:01:55'),
(270, 'ইউনিট যোগ করুন', 135, 'bn', 0, 1, '2018-03-09 19:00:51', '2018-03-09 19:01:55'),
(271, 'Add new Unit', 136, 'en', 0, 1, '2018-03-09 19:02:17', '2018-03-09 19:02:40'),
(272, 'নতুন ইউনিট যোগ করুন', 136, 'bn', 0, 1, '2018-03-09 19:02:17', '2018-03-09 19:02:40'),
(273, 'Update Unit', 137, 'en', 0, 1, '2018-03-09 19:04:46', '2018-03-09 19:05:07'),
(274, 'আপডেট ইউনিট', 137, 'bn', 0, 1, '2018-03-09 19:04:46', '2018-03-09 19:05:07'),
(275, 'Edit Unit', 138, 'en', 0, 1, '2018-03-09 19:05:18', '2018-03-09 19:05:36'),
(276, 'ইউনিট সম্পাদনা করুন', 138, 'bn', 0, 1, '2018-03-09 19:05:18', '2018-03-09 19:05:37'),
(277, 'Name', 139, 'en', 0, 1, '2018-03-09 19:09:56', '2018-03-09 19:10:13'),
(278, 'নাম', 139, 'bn', 0, 1, '2018-03-09 19:09:56', '2018-03-09 19:10:13'),
(279, 'Add Vat Tax', 140, 'en', 0, 1, '2018-03-09 19:11:03', '2018-03-09 19:11:22'),
(280, 'ভ্যাট ট্যাক্স যোগ করুন', 140, 'bn', 0, 1, '2018-03-09 19:11:03', '2018-03-09 19:11:22'),
(281, 'Select Product', 141, 'en', 0, 1, '2018-03-09 19:13:30', '2018-03-09 19:20:25'),
(282, 'পণ্য নির্বাচন করুন', 141, 'bn', 0, 1, '2018-03-09 19:13:30', '2018-03-09 19:20:25'),
(283, 'Report', 142, 'en', 0, 1, '2018-03-09 19:18:16', '2018-03-09 19:18:36'),
(284, 'প্রতিবেদন', 142, 'bn', 0, 1, '2018-03-09 19:18:16', '2018-03-09 19:18:36'),
(285, 'Available Quantity', 143, 'en', 0, 1, '2018-03-09 19:24:36', '2018-03-09 19:25:10'),
(286, 'উপলব্ধ পরিমাণ', 143, 'bn', 0, 1, '2018-03-09 19:24:36', '2018-03-09 19:25:10'),
(287, 'Sale Quantity', 144, 'en', 0, 1, '2018-03-09 19:25:47', '2018-03-09 19:26:05'),
(288, 'বিক্রয় পরিমাণ', 144, 'bn', 0, 1, '2018-03-09 19:25:47', '2018-03-09 19:26:05'),
(289, 'Total Quantity', 145, 'en', 0, 1, '2018-03-09 19:26:25', '2018-03-09 19:26:44'),
(290, 'মোট পরিমাণ', 145, 'bn', 0, 1, '2018-03-09 19:26:25', '2018-03-09 19:26:44'),
(291, 'Select Invoice', 146, 'en', 0, 1, '2018-03-09 19:44:45', '2018-03-09 19:45:42'),
(292, 'চালান নির্বাচন করুন', 146, 'bn', 0, 1, '2018-03-09 19:44:45', '2018-03-09 19:45:42'),
(293, 'Search date....', 147, 'en', 0, 1, '2018-03-09 19:45:57', '2018-03-09 19:46:17'),
(294, 'তারিখ অনুসন্ধান করুন ....', 147, 'bn', 0, 1, '2018-03-09 19:45:57', '2018-03-09 19:46:17'),
(295, 'Date', 148, 'en', 0, 1, '2018-03-09 19:47:32', '2018-03-09 19:47:48'),
(296, 'তারিখ', 148, 'bn', 0, 1, '2018-03-09 19:47:32', '2018-03-09 19:47:48'),
(297, 'Challan No', 149, 'en', 0, 1, '2018-03-09 19:48:38', '2018-03-09 19:49:45'),
(298, 'চালান নং', 149, 'bn', 0, 1, '2018-03-09 19:48:38', '2018-03-09 19:49:45'),
(299, 'Quantity/Kg', 150, 'en', 0, 1, '2018-03-09 19:50:42', '2018-03-09 19:50:58'),
(300, 'পরিমাণ / কেজি', 150, 'bn', 0, 1, '2018-03-09 19:50:42', '2018-03-09 19:50:58'),
(301, 'Unit Price/Kg', 151, 'en', 0, 1, '2018-03-09 19:51:26', '2018-03-09 19:51:44'),
(302, 'ইউনিট মূল্য / কেজি', 151, 'bn', 0, 1, '2018-03-09 19:51:26', '2018-03-09 19:51:45'),
(303, 'Total Up to Date Amount', 152, 'en', 0, 1, '2018-03-09 19:52:14', '2018-03-09 19:54:53'),
(304, 'সর্বমোট পরিমাণ', 152, 'bn', 0, 1, '2018-03-09 19:52:14', '2018-03-09 19:54:53'),
(305, 'User List', 153, 'en', 0, 1, '2018-03-11 17:00:41', '2018-03-11 17:01:04'),
(306, 'ব্যবহারকারীর তালিকা', 153, 'bn', 0, 1, '2018-03-11 17:00:41', '2018-03-11 17:01:04'),
(307, 'Local purchase', 154, 'en', 0, 1, '2018-03-21 01:37:13', '2018-03-21 01:37:34'),
(308, NULL, 154, 'bn', 0, 1, '2018-03-21 01:37:13', '2018-03-21 01:37:34'),
(309, 'LC Purchase', 155, 'en', 0, 1, '2018-03-21 01:54:39', '2018-03-21 01:55:01'),
(310, NULL, 155, 'bn', 0, 1, '2018-03-21 01:54:39', '2018-03-21 01:55:01'),
(311, 'view result', 156, 'en', 0, 1, '2018-04-02 06:48:56', '2018-04-02 06:49:13'),
(312, NULL, 156, 'bn', 0, 1, '2018-04-02 06:48:57', '2018-04-02 06:49:14');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_translation_keys`
--

CREATE TABLE `mxp_translation_keys` (
  `translation_key_id` int(10) UNSIGNED NOT NULL,
  `is_active` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `translation_key` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_translation_keys`
--

INSERT INTO `mxp_translation_keys` (`translation_key_id`, `is_active`, `created_at`, `updated_at`, `translation_key`) VALUES
(1, 1, '2018-03-05 18:12:49', '2018-03-05 18:12:49', 'company_name'),
(2, 1, '2018-03-05 20:38:51', '2018-03-05 20:38:51', 'login_label'),
(3, 1, '2018-03-05 20:39:27', '2018-03-05 20:39:27', 'register_label'),
(4, 1, '2018-03-05 20:54:56', '2018-03-05 20:54:56', 'validationerror_woops'),
(5, 1, '2018-03-05 20:56:52', '2018-03-05 20:56:52', 'validationerror_there_were_some_problems_with_your_input'),
(6, 1, '2018-03-05 20:57:04', '2018-03-05 20:57:04', 'validationerror_or_you_are_not_active_yet'),
(7, 1, '2018-03-05 20:57:14', '2018-03-05 20:57:14', 'enter_email_address'),
(8, 1, '2018-03-05 20:57:22', '2018-03-05 20:57:22', 'enter_password'),
(9, 1, '2018-03-05 20:57:31', '2018-03-05 20:57:31', 'login_rememberme_label'),
(10, 1, '2018-03-05 20:57:39', '2018-03-05 20:57:39', 'forgot_your_password'),
(11, 1, '2018-03-05 23:23:50', '2018-03-05 23:23:50', 'dashboard_label'),
(12, 1, '2018-03-05 23:34:35', '2018-03-05 23:34:35', 'language_list_label'),
(13, 1, '2018-03-05 23:36:43', '2018-03-05 23:36:43', 'serial_no_label'),
(14, 1, '2018-03-05 23:38:13', '2018-03-05 23:38:13', 'language_title_label'),
(15, 1, '2018-03-05 23:38:47', '2018-03-05 23:38:47', 'language_code_label'),
(16, 1, '2018-03-05 23:39:23', '2018-03-05 23:39:23', 'status_label'),
(17, 1, '2018-03-05 23:40:40', '2018-03-05 23:40:40', 'action_label'),
(18, 1, '2018-03-05 23:43:00', '2018-03-05 23:43:00', 'action_active_label'),
(19, 1, '2018-03-05 23:43:47', '2018-03-05 23:43:47', 'action_inactive_label'),
(20, 1, '2018-03-05 23:58:03', '2018-03-05 23:58:03', 'add_locale_button'),
(21, 1, '2018-03-06 00:00:03', '2018-03-06 00:00:03', 'edit_button'),
(22, 1, '2018-03-06 00:14:26', '2018-03-06 00:14:26', 'add_new_language_label'),
(23, 1, '2018-03-06 00:15:45', '2018-03-06 00:15:45', 'add_language_label'),
(24, 1, '2018-03-06 00:16:49', '2018-03-06 00:16:49', 'enter_language_title'),
(25, 1, '2018-03-06 00:17:31', '2018-03-06 00:17:31', 'enter_language_code'),
(26, 1, '2018-03-06 00:18:57', '2018-03-06 00:18:57', 'save_button'),
(27, 1, '2018-03-06 00:23:12', '2018-03-06 00:23:12', 'update_locale_label'),
(28, 1, '2018-03-06 00:28:35', '2018-03-06 00:28:35', 'update_language_title'),
(29, 1, '2018-03-06 00:29:32', '2018-03-06 00:29:32', 'update_language_code'),
(30, 1, '2018-03-06 00:30:07', '2018-03-06 00:30:07', 'update_button'),
(31, 1, '2018-03-06 00:32:05', '2018-03-06 00:32:05', 'update_language_label'),
(32, 1, '2018-03-06 00:34:41', '2018-03-06 00:34:41', 'mxp_upload_file_rechecking_label'),
(33, 1, '2018-03-06 00:36:42', '2018-03-06 00:36:42', 'upload_button'),
(34, 1, '2018-03-06 00:39:26', '2018-03-06 00:39:26', 'translation_list_label'),
(35, 1, '2018-03-06 00:49:29', '2018-03-06 00:49:29', 'add_new_key_label'),
(36, 1, '2018-03-06 00:51:16', '2018-03-06 00:51:16', 'search_the_translation_key_placeholder'),
(37, 1, '2018-03-06 00:52:45', '2018-03-06 00:52:45', 'translation_key_label'),
(38, 1, '2018-03-06 00:54:31', '2018-03-06 00:54:31', 'translation_label'),
(39, 1, '2018-03-06 00:55:21', '2018-03-06 00:55:21', 'language_label'),
(40, 1, '2018-03-06 00:56:29', '2018-03-06 00:56:29', 'delete_button'),
(41, 1, '2018-03-06 01:07:29', '2018-03-06 01:07:29', 'add_new_translation_key_label'),
(42, 1, '2018-03-06 01:08:20', '2018-03-06 01:08:20', 'enter_translation_key'),
(43, 1, '2018-03-06 01:18:54', '2018-03-06 01:18:54', 'update_translation_label'),
(44, 1, '2018-03-06 01:19:50', '2018-03-06 01:19:50', 'update_translation_key_label'),
(45, 1, '2018-03-06 19:21:58', '2018-03-06 19:21:58', 'mxp_menu_language'),
(46, 1, '2018-03-06 19:23:15', '2018-03-06 19:23:15', 'mxp_menu_manage_langulage'),
(47, 1, '2018-03-06 19:24:37', '2018-03-06 19:24:37', 'mxp_menu_manage_translation'),
(48, 1, '2018-03-06 19:25:41', '2018-03-06 19:25:41', 'mxp_menu_upload_language_file'),
(49, 1, '2018-03-06 19:26:59', '2018-03-06 19:26:59', 'mxp_menu_role'),
(50, 1, '2018-03-06 19:28:03', '2018-03-06 19:28:03', 'mxp_menu_add_new_role'),
(51, 1, '2018-03-06 19:30:11', '2018-03-06 19:30:11', 'mxp_menu_role_list'),
(52, 1, '2018-03-06 19:30:45', '2018-03-06 19:30:45', 'mxp_menu_role_permission_'),
(53, 1, '2018-03-06 19:31:22', '2018-03-06 19:31:22', 'mxp_menu_settings'),
(54, 1, '2018-03-06 19:32:15', '2018-03-06 19:32:15', 'mxp_menu_open_company_acc'),
(55, 1, '2018-03-06 19:34:19', '2018-03-06 19:34:19', 'mxp_menu_company_list'),
(56, 1, '2018-03-06 19:34:56', '2018-03-06 19:34:56', 'mxp_menu_open_company_account'),
(57, 1, '2018-03-06 19:36:15', '2018-03-06 19:36:15', 'mxp_menu_create_user'),
(58, 1, '2018-03-06 19:39:56', '2018-03-06 19:39:56', 'mxp_menu_user_list'),
(59, 1, '2018-03-06 19:40:33', '2018-03-06 19:40:33', 'mxp_menu_client_list'),
(60, 1, '2018-03-06 19:41:56', '2018-03-06 19:41:56', 'mxp_menu_product'),
(61, 1, '2018-03-06 19:42:32', '2018-03-06 19:42:32', 'mxp_menu_unit'),
(62, 1, '2018-03-06 19:48:24', '2018-03-06 19:48:24', 'mxp_menu_product_group'),
(63, 1, '2018-03-06 19:49:03', '2018-03-06 19:49:03', 'mxp_menu_product_entry'),
(64, 1, '2018-03-06 19:50:09', '2018-03-06 19:50:09', 'mxp_menu_product_packing'),
(65, 1, '2018-03-06 19:50:54', '2018-03-06 19:50:54', 'mxp_menu_purchase'),
(66, 1, '2018-03-06 19:51:47', '2018-03-06 19:51:47', 'mxp_menu_purchase_list'),
(67, 1, '2018-03-06 19:52:27', '2018-03-06 19:52:27', 'mxp_menu_update_stocks_action'),
(68, 1, '2018-03-06 19:53:48', '2018-03-06 19:53:48', 'mxp_menu_vat_tax_list'),
(69, 1, '2018-03-06 19:54:25', '2018-03-06 19:54:25', 'mxp_menu_sale_list'),
(70, 1, '2018-03-06 19:55:15', '2018-03-06 19:55:15', 'mxp_menu_save_sale_'),
(71, 1, '2018-03-06 19:56:45', '2018-03-06 19:56:45', 'mxp_menu_inventory_report'),
(72, 1, '2018-03-06 19:57:21', '2018-03-06 19:57:21', 'mxp_menu_stock_management'),
(73, 1, '2018-03-06 19:58:01', '2018-03-06 19:58:01', 'mxp_menu_store'),
(74, 1, '2018-03-06 19:58:53', '2018-03-06 19:58:53', 'mxp_menu_stock'),
(76, 1, '2018-03-06 20:57:06', '2018-03-06 20:57:06', 'company_name_label'),
(77, 1, '2018-03-06 21:05:38', '2018-03-06 21:05:38', 'role_name_placeholder'),
(78, 1, '2018-03-06 21:06:59', '2018-03-06 21:06:59', 'select_company_option_label'),
(79, 1, '2018-03-06 21:08:51', '2018-03-06 21:08:51', 'select_role_option_label'),
(80, 1, '2018-03-06 21:11:57', '2018-03-06 21:11:57', 'select_all_label'),
(81, 1, '2018-03-06 21:12:36', '2018-03-06 21:12:36', 'unselect_all_label'),
(82, 1, '2018-03-06 21:14:03', '2018-03-06 21:14:03', 'set_button'),
(83, 1, '2018-03-06 21:15:41', '2018-03-06 21:15:41', 'heading_role_assign_label'),
(84, 1, '2018-03-06 21:19:23', '2018-03-06 21:19:23', 'heading_role_permission_list_label'),
(85, 1, '2018-03-06 21:19:57', '2018-03-06 21:19:57', 'option_permitted_route_list_label'),
(86, 1, '2018-03-06 21:36:58', '2018-03-06 21:36:58', 'heading_update_role_label'),
(87, 1, '2018-03-06 22:00:58', '2018-03-06 22:00:58', 'heading_add_stock_label'),
(88, 1, '2018-03-06 22:01:41', '2018-03-06 22:01:41', 'product_name_label'),
(89, 1, '2018-03-06 22:02:40', '2018-03-06 22:02:40', 'product_group_label'),
(90, 1, '2018-03-06 22:03:37', '2018-03-06 22:03:37', 'quantity_label'),
(91, 1, '2018-03-06 22:04:43', '2018-03-06 22:04:43', 'option_select_location_label'),
(94, 1, '2018-03-06 22:21:41', '2018-03-06 22:21:41', 'heading_add_new_stock_label'),
(95, 1, '2018-03-06 22:22:14', '2018-03-06 22:22:14', 'add_stock_label'),
(96, 1, '2018-03-06 22:23:21', '2018-03-06 22:23:21', 'enter_store_name_label'),
(97, 1, '2018-03-06 22:23:51', '2018-03-06 22:23:51', 'enter_store_location_label'),
(98, 1, '2018-03-06 22:27:47', '2018-03-06 22:27:47', 'heading_update_store_label'),
(100, 1, '2018-03-06 22:34:46', '2018-03-06 22:34:46', 'heading_store_list_label'),
(101, 1, '2018-03-06 22:36:32', '2018-03-06 22:36:32', 'store_name_label'),
(102, 1, '2018-03-06 22:37:36', '2018-03-06 22:37:36', 'store_location_label'),
(103, 1, '2018-03-06 22:45:51', '2018-03-06 22:45:51', 'list_of_responsible_person_label'),
(104, 1, '2018-03-07 21:50:23', '2018-03-07 21:50:23', 'company_phone_number_label'),
(105, 1, '2018-03-07 21:51:29', '2018-03-07 21:51:29', 'company_address_label'),
(106, 1, '2018-03-07 21:52:22', '2018-03-07 21:52:22', 'company_description_label'),
(107, 1, '2018-03-07 23:00:57', '2018-03-07 23:00:57', 'employee_name_label'),
(108, 1, '2018-03-07 23:02:33', '2018-03-07 23:02:33', 'personal_phone_number_label'),
(109, 1, '2018-03-07 23:03:16', '2018-03-07 23:03:16', 'employee_address_label'),
(110, 1, '2018-03-07 23:03:52', '2018-03-07 23:03:52', 'password_confirmation_label'),
(111, 1, '2018-03-07 23:11:42', '2018-03-07 23:11:42', 'search_placeholder'),
(112, 1, '2018-03-07 23:21:05', '2018-03-07 23:21:05', 'company_label'),
(113, 1, '2018-03-07 23:52:58', '2018-03-07 23:52:58', 'add_company_label'),
(114, 1, '2018-03-08 17:19:08', '2018-03-08 17:19:08', 'update_company_button'),
(115, 1, '2018-03-09 17:02:10', '2018-03-09 17:02:10', 'add_packet_button'),
(116, 1, '2018-03-09 17:04:20', '2018-03-09 17:04:20', 'option_select_unit_label'),
(117, 1, '2018-03-09 17:06:17', '2018-03-09 17:06:17', 'packet_name_label'),
(118, 1, '2018-03-09 17:07:27', '2018-03-09 17:07:27', 'unit_quantity_label'),
(119, 1, '2018-03-09 17:13:41', '2018-03-09 17:13:41', 'update_packet_button'),
(120, 1, '2018-03-09 17:18:32', '2018-03-09 17:18:32', 'unit_label'),
(121, 1, '2018-03-09 17:24:19', '2018-03-09 17:24:19', 'heading_packet_list'),
(122, 1, '2018-03-09 17:52:50', '2018-03-09 17:52:50', 'heading_add_new_packet_label'),
(123, 1, '2018-03-09 17:53:19', '2018-03-09 17:53:19', 'add_packet_label'),
(124, 1, '2018-03-09 17:56:43', '2018-03-09 17:56:43', 'packet_details_label'),
(125, 1, '2018-03-09 18:02:50', '2018-03-09 18:02:50', 'product_code_label'),
(126, 1, '2018-03-09 18:09:32', '2018-03-09 18:09:32', 'heading_update_product_label'),
(127, 1, '2018-03-09 18:10:38', '2018-03-09 18:10:38', 'edit_product_label'),
(128, 1, '2018-03-09 18:26:17', '2018-03-09 18:26:17', 'product_group_name_label'),
(129, 1, '2018-03-09 18:26:52', '2018-03-09 18:26:52', 'add_product_group_label'),
(130, 1, '2018-03-09 18:27:22', '2018-03-09 18:27:22', 'add_new_product_group_label'),
(131, 1, '2018-03-09 18:34:53', '2018-03-09 18:34:53', 'edit_new_product_group_label'),
(132, 1, '2018-03-09 18:35:57', '2018-03-09 18:35:57', 'edit_product_group_label'),
(133, 1, '2018-03-09 18:39:48', '2018-03-09 18:39:48', 'heading_product_group_list_label'),
(134, 1, '2018-03-09 19:00:04', '2018-03-09 19:00:04', 'unit_name_label'),
(135, 1, '2018-03-09 19:00:51', '2018-03-09 19:00:51', 'add_unit_label'),
(136, 1, '2018-03-09 19:02:17', '2018-03-09 19:02:17', 'add_new_unit_label'),
(137, 1, '2018-03-09 19:04:46', '2018-03-09 19:04:46', 'update_unit_label'),
(138, 1, '2018-03-09 19:05:17', '2018-03-09 19:05:17', 'edit_unit_label'),
(139, 1, '2018-03-09 19:09:55', '2018-03-09 19:09:55', 'name_label'),
(140, 1, '2018-03-09 19:11:03', '2018-03-09 19:11:03', 'add_vat_tax_label'),
(141, 1, '2018-03-09 19:13:30', '2018-03-09 19:13:30', 'option_select_product_label'),
(142, 1, '2018-03-09 19:18:16', '2018-03-09 19:18:16', 'heading_report_label'),
(143, 1, '2018-03-09 19:24:36', '2018-03-09 19:24:36', 'available_quantity_label'),
(144, 1, '2018-03-09 19:25:47', '2018-03-09 19:25:47', 'sale_quantity_label'),
(145, 1, '2018-03-09 19:26:25', '2018-03-09 19:26:25', 'total_quantity_label'),
(146, 1, '2018-03-09 19:44:45', '2018-03-09 19:44:45', 'option_select_invoice_label'),
(147, 1, '2018-03-09 19:45:57', '2018-03-09 19:45:57', 'search_date_placeholder'),
(148, 1, '2018-03-09 19:47:32', '2018-03-09 19:47:32', 'date_label'),
(149, 1, '2018-03-09 19:48:38', '2018-03-09 19:48:38', 'invoice_no_label'),
(150, 1, '2018-03-09 19:50:42', '2018-03-09 19:50:42', 'quantity_per_kg_label'),
(151, 1, '2018-03-09 19:51:26', '2018-03-09 19:51:26', 'unit_price_per_kg_label'),
(152, 1, '2018-03-09 19:52:14', '2018-03-09 19:52:14', 'total_uptodate_quantity_label'),
(153, 1, '2018-03-11 17:00:41', '2018-03-11 17:00:41', 'heading_user_list_label'),
(154, 1, '2018-03-21 01:37:13', '2018-03-21 01:37:13', 'mxp_menu_local_purchase'),
(155, 1, '2018-03-21 01:54:39', '2018-03-21 01:54:39', 'mxp_menu_lc_purchase'),
(156, 1, '2018-04-02 06:48:56', '2018-04-02 06:48:56', 'mxp_view_btn');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_users`
--

CREATE TABLE `mxp_users` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `middle_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `group_id` int(100) NOT NULL DEFAULT '0',
  `company_id` int(11) NOT NULL DEFAULT '0',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `user_role_id` int(11) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `verification_token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_users`
--

INSERT INTO `mxp_users` (`user_id`, `first_name`, `middle_name`, `last_name`, `address`, `type`, `group_id`, `company_id`, `email`, `password`, `phone_no`, `remember_token`, `is_active`, `user_role_id`, `verified`, `verification_token`, `created_at`, `updated_at`) VALUES
(1, 'Super Admin', 'middle', 'last', NULL, 'super_admin', 0, 0, 'sajibg7@gmail.com', '$2y$10$BIvmvrQf1a5G3mrmHlrN9ulYV1fKtgUoJaK968BJ2foPBTkVjWn7S', '123456789', 'W2BAkJhItN3JPmGRSuvUaiFcHEpKQiVdVv2w8P8gVyvXmNvtPUxyNIRnmaPr', 1, 1, 0, '0', '2018-01-15 01:37:15', '2018-03-05 13:29:32'),
(24, 'Beximco user', 'moinul', 'sajibg', NULL, 'super_admin', 0, 0, 'sajibg7+1@gmail.com', '$2y$10$voCXiMsv.R.X.pl6F8DbnuFyIiwyhrpYB.na/FITZNz7ZIGyLVmfC', '01674898148', '5zesn2ucLuXz1fN1tVBETDkjrIEBqG38fFiglfuVQzr4BcAbECNiV67d3xKI', 1, 1, 0, '0', '2018-01-29 06:36:28', '2018-01-29 06:36:28'),
(26, 'company-a-user', NULL, NULL, NULL, 'company_user', 1, 11, 'sajibg7+3@gmail.com', '$2y$10$gxTBxp.V1v2TJphLkJWmLuqIwhdNu0WxUZSDgnkNyc0D/.YnhCkc2', '12143234235', 'TezCzw56wUjAeVkvits9Zkaj5ZVLjRNYAauQDTh0DmT6AdtSiXY5Qs8CcGPu', 1, 21, 0, '0', '2018-01-29 06:44:07', '2018-01-29 06:44:07'),
(27, 'Sumit Power user', 'moinul', 'sajibg', NULL, 'super_admin', 0, 0, 'sajibg7+4@gmail.com', '$2y$10$DYvlonHYz7onBx3U743LoeSQX166D4Y.EFxJDI33WfbUFuHvvUrZ.', '01674898148', 'kcraPAbsogfCaWXXzizdBCRSYOIqrplPy77x3qrT', 0, 1, 0, '0', '2018-01-30 00:16:13', '2018-01-30 00:16:13'),
(36, 'Sumit Power user-2', 'moinul', 'sajibg', NULL, 'super_admin', 0, 0, 'sajibg7+5@gmail.com', '$2y$10$9PUEtsR3rv82eJ7TFyG/wOEuTtbXUbcTJWZ0Wz1EBFRnNLqzHROje', '01674898148', 'kcraPAbsogfCaWXXzizdBCRSYOIqrplPy77x3qrT', 0, 1, 0, '0', '2018-01-30 00:32:37', '2018-01-30 00:32:37'),
(38, 'Sumit Power user-22', 'moinul', 'sajibg', NULL, 'super_admin', 0, 0, 'sajibg7+23@gmail.com', '$2y$10$0.jZXV4ihdxJKIqI3STDb.4QB3.fd2szjsQLUCeijhVXSyuzQw0gy', '01674898148', 'DORz0nqgyRNUEPWahczArNAlVYTil0mFXMniff6BAaVmMLjO2sywBn0BvHS5', 1, 1, 0, '0', '2018-01-31 02:56:31', '2018-01-31 02:56:31'),
(39, 'mxp_name', NULL, NULL, NULL, 'company_user', 38, 13, 'sajibg7+77@gmail.com', '$2y$10$O4ZTP39xhT2NtkYcAE1I1u3ZVfn/CA4PC5954PJVYP92yQ1e3oJSG', '2222222222', 'zJ9Fq0pgJp1Ffo1AljnyQS2IHKDKgD59zDokr5ufo7wzNjjNAG5zHgX2w9kw', 1, 25, 0, '0', '2018-01-31 03:00:36', '2018-01-31 03:00:36'),
(40, 'mxp_name', NULL, NULL, NULL, 'company_user', 38, 14, 'sajibg7+78@gmail.com', '$2y$10$/RIWK3dmNz5i0RO6p.b8h.fIgPVOukwUUVdydW4zuqjDYZgnuFT3y', '2222222222', 'CMIeb4F5GnV3Gvzeq6n7FvUwdCN8DM1NPoEwkVaHyLwYPSnc7U2P52xLfX1R', 1, 26, 0, '0', '2018-01-31 03:00:53', '2018-01-31 03:00:53'),
(41, 'Beximco', NULL, NULL, '56,gazipur', 'client_com', 1, 10, 'beximco@beximco.com', NULL, '21321564654687987', NULL, 1, NULL, 0, '0', '2018-02-02 06:14:45', '2018-02-02 06:14:45'),
(42, 'New Admin', 'Middle', 'Last', NULL, 'super_admin', 0, 0, 'newadmin@mail.com', '$2y$10$x1yzwN3LXrb8fkXSCg9Roeu.EBlSQpJf1U.ouqzdOi1F5z2robRd2', '1234567890', 'I500mFPOncDcawx0KwHnzx35J0rH1TUOIT6m4omT', 1, 1, 0, '0', '2018-02-09 01:58:04', '2018-02-09 01:58:04'),
(43, 'New Client', NULL, NULL, NULL, 'client_com', 42, 16, 'newclient@mail.com', NULL, '1234567890', NULL, 1, NULL, 0, '0', '2018-02-09 02:09:35', '2018-02-09 02:09:35'),
(48, 'test user', NULL, NULL, NULL, 'company_user', 1, 10, 'sajibg7+09@gmail.com', '$2y$10$NItNEFuZfxtXosv7iRoU0utNjKMIijcYPFTj5J/r26AY86hZg2w6W', '123456', NULL, 1, 29, 0, '0', '2018-04-09 01:58:28', '2018-04-09 01:58:28');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_user_role_menu`
--

CREATE TABLE `mxp_user_role_menu` (
  `role_menu_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL DEFAULT '0',
  `is_active` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_user_role_menu`
--

INSERT INTO `mxp_user_role_menu` (`role_menu_id`, `role_id`, `menu_id`, `company_id`, `is_active`, `created_at`, `updated_at`) VALUES
(185, 1, 25, 0, 1, '2018-01-26 12:24:42', '2018-01-26 12:24:42'),
(186, 1, 7, 0, 1, '2018-01-26 12:24:42', '2018-01-26 12:24:42'),
(187, 1, 34, 0, 1, '2018-01-26 12:24:42', '2018-01-26 12:24:42'),
(188, 1, 28, 0, 1, '2018-01-26 12:24:42', '2018-01-26 12:24:42'),
(189, 1, 19, 0, 1, '2018-01-26 12:24:42', '2018-01-26 12:24:42'),
(190, 1, 37, 0, 1, '2018-01-26 12:24:42', '2018-01-26 12:24:42'),
(191, 1, 18, 0, 1, '2018-01-26 12:24:42', '2018-01-26 12:24:42'),
(192, 1, 4, 0, 1, '2018-01-26 12:24:42', '2018-01-26 12:24:42'),
(193, 1, 31, 0, 1, '2018-01-26 12:24:42', '2018-01-26 12:24:42'),
(194, 1, 23, 0, 1, '2018-01-26 12:24:42', '2018-01-26 12:24:42'),
(195, 1, 3, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(196, 1, 24, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(197, 1, 27, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(198, 1, 36, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(199, 1, 35, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(200, 1, 13, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(201, 1, 30, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(202, 1, 6, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(203, 1, 10, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(204, 1, 16, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(205, 1, 9, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(206, 1, 8, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(207, 1, 12, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(208, 1, 5, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(209, 1, 26, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(210, 1, 11, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(211, 1, 29, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(212, 1, 22, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(213, 1, 33, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(214, 1, 21, 0, 1, '2018-01-26 12:24:43', '2018-01-26 12:24:43'),
(313, 21, 4, 0, 1, '2018-01-28 12:42:45', '2018-01-28 12:42:45'),
(314, 21, 31, 0, 1, '2018-01-28 12:42:46', '2018-01-28 12:42:46'),
(315, 21, 3, 0, 1, '2018-01-28 12:42:46', '2018-01-28 12:42:46'),
(316, 21, 24, 0, 1, '2018-01-28 12:42:46', '2018-01-28 12:42:46'),
(317, 21, 27, 0, 1, '2018-01-28 12:42:46', '2018-01-28 12:42:46'),
(318, 21, 5, 0, 1, '2018-01-28 12:42:46', '2018-01-28 12:42:46'),
(319, 21, 32, 0, 1, '2018-01-28 12:42:46', '2018-01-28 12:42:46'),
(349, 26, 34, 14, 1, '2018-01-30 09:00:07', '2018-01-30 09:00:07'),
(350, 26, 13, 14, 1, '2018-01-30 09:00:07', '2018-01-30 09:00:07'),
(351, 26, 6, 14, 1, '2018-01-30 09:00:07', '2018-01-30 09:00:07'),
(352, 26, 10, 14, 1, '2018-01-30 09:00:07', '2018-01-30 09:00:07'),
(353, 26, 16, 14, 1, '2018-01-30 09:00:08', '2018-01-30 09:00:08'),
(354, 26, 9, 14, 1, '2018-01-30 09:00:08', '2018-01-30 09:00:08'),
(355, 26, 8, 14, 1, '2018-01-30 09:00:08', '2018-01-30 09:00:08'),
(356, 26, 12, 14, 1, '2018-01-30 09:00:08', '2018-01-30 09:00:08'),
(357, 26, 11, 14, 1, '2018-01-30 09:00:08', '2018-01-30 09:00:08'),
(358, 25, 19, 13, 1, '2018-01-30 10:23:24', '2018-01-30 10:23:24'),
(359, 25, 37, 13, 1, '2018-01-30 10:23:24', '2018-01-30 10:23:24'),
(360, 25, 18, 13, 1, '2018-01-30 10:23:24', '2018-01-30 10:23:24'),
(361, 25, 5, 13, 1, '2018-01-30 10:23:24', '2018-01-30 10:23:24'),
(362, 25, 22, 13, 1, '2018-01-30 10:23:24', '2018-01-30 10:23:24'),
(363, 25, 33, 13, 1, '2018-01-30 10:23:25', '2018-01-30 10:23:25'),
(364, 25, 21, 13, 1, '2018-01-30 10:23:25', '2018-01-30 10:23:25'),
(365, 25, 20, 13, 1, '2018-01-30 10:23:25', '2018-01-30 10:23:25'),
(366, 1, 32, 0, 1, NULL, NULL),
(367, 1, 20, 0, 1, '2018-01-30 10:23:25', '2018-01-30 10:23:25'),
(401, 1, 38, 0, 1, NULL, NULL),
(402, 1, 39, 0, 1, NULL, NULL),
(403, 1, 40, 0, 1, NULL, NULL),
(404, 1, 41, 0, 1, NULL, NULL),
(405, 1, 42, 0, 1, NULL, NULL),
(406, 1, 43, 0, 1, NULL, NULL),
(407, 1, 44, 0, 1, NULL, NULL),
(414, 1, 52, 0, 1, '2018-01-31 06:00:00', '2018-01-31 06:00:00'),
(415, 1, 53, 0, 1, '2018-01-31 06:00:00', '2018-01-31 06:00:00'),
(416, 1, 54, 0, 1, '2018-01-31 06:00:00', '2018-01-31 06:00:00'),
(417, 1, 55, 0, 1, '2018-01-31 06:00:00', '2018-01-31 06:00:00'),
(418, 1, 56, 0, 1, '2018-01-31 06:00:00', '2018-01-31 06:00:00'),
(419, 1, 54, 0, 1, '2018-01-31 06:00:00', '2018-01-31 06:00:00'),
(420, 1, 57, 0, 1, '2018-01-31 06:00:00', '2018-01-31 06:00:00'),
(421, 1, 58, 0, 1, '2018-01-31 06:00:00', '2018-01-31 06:00:00'),
(422, 1, 59, 0, 1, '2018-01-31 06:00:00', '2018-01-31 06:00:00'),
(423, 1, 60, 0, 1, '2018-01-31 06:00:00', '2018-01-31 06:00:00'),
(424, 1, 61, 0, 1, NULL, NULL),
(425, 1, 62, 0, 1, NULL, NULL),
(426, 1, 63, 0, 1, NULL, NULL),
(427, 1, 64, 0, 1, NULL, NULL),
(428, 1, 65, 0, 1, NULL, NULL),
(429, 1, 66, 0, 1, NULL, NULL),
(430, 1, 67, 0, 1, NULL, NULL),
(431, 1, 68, 0, 1, NULL, NULL),
(432, 1, 69, 0, 1, NULL, NULL),
(433, 1, 70, 0, 1, NULL, NULL),
(434, 1, 71, 0, 1, NULL, NULL),
(435, 1, 72, 0, 1, NULL, NULL),
(482, 1, 73, 0, 1, NULL, NULL),
(486, 1, 77, 0, 1, NULL, NULL),
(487, 1, 78, 0, 1, NULL, NULL),
(488, 1, 79, 0, 1, NULL, NULL),
(489, 1, 80, 0, 1, NULL, NULL),
(490, 1, 81, 0, 1, NULL, NULL),
(491, 1, 82, 0, 1, NULL, NULL),
(492, 1, 83, 0, 1, NULL, NULL),
(493, 1, 88, 0, 1, NULL, NULL),
(494, 1, 89, 0, 1, NULL, NULL),
(495, 1, 90, 0, 1, NULL, NULL),
(496, 1, 91, 0, 1, NULL, NULL),
(497, 1, 92, 0, 1, NULL, NULL),
(498, 1, 84, 0, 1, NULL, NULL),
(499, 1, 93, 0, 1, NULL, NULL),
(500, 1, 94, 0, 1, NULL, NULL),
(501, 1, 95, 0, 1, NULL, NULL),
(502, 1, 96, 0, 1, NULL, NULL),
(503, 1, 97, 0, 1, NULL, NULL),
(504, 1, 98, 0, 1, NULL, NULL),
(505, 1, 99, 0, 1, NULL, NULL),
(506, 1, 100, 0, 1, NULL, NULL),
(507, 1, 101, 0, 1, NULL, NULL),
(508, 1, 102, 0, 1, NULL, NULL),
(509, 27, 102, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(510, 27, 98, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(511, 27, 43, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(512, 27, 25, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(513, 27, 57, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(514, 27, 90, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(515, 27, 67, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(516, 27, 56, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(517, 27, 54, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(518, 27, 53, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(519, 27, 44, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(520, 27, 41, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(521, 27, 40, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(522, 27, 89, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(523, 27, 68, 10, 1, '2018-04-02 00:40:56', '2018-04-02 00:40:56'),
(524, 27, 71, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(525, 27, 70, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(526, 27, 28, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(527, 27, 19, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(528, 27, 72, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(529, 27, 69, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(530, 27, 18, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(531, 27, 4, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(532, 27, 58, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(533, 27, 66, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(534, 27, 31, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(535, 27, 63, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(536, 27, 91, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(537, 27, 99, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(538, 27, 101, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(539, 27, 3, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(540, 27, 100, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(541, 27, 73, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(542, 27, 24, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(543, 27, 27, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(544, 27, 30, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(545, 27, 38, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(546, 27, 74, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(547, 27, 76, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(548, 27, 52, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(549, 27, 42, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(550, 27, 55, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(551, 27, 75, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(552, 27, 92, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(553, 27, 6, 10, 1, '2018-04-02 00:40:57', '2018-04-02 00:40:57'),
(554, 27, 8, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(555, 27, 93, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(556, 27, 5, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(557, 27, 83, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(558, 27, 79, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(559, 27, 82, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(560, 27, 81, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(561, 27, 96, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(562, 27, 97, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(563, 27, 84, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(564, 27, 77, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(565, 27, 78, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(566, 27, 80, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(567, 27, 26, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(568, 27, 60, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(569, 27, 65, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(570, 27, 95, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(571, 27, 29, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(572, 27, 62, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(573, 27, 33, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(574, 27, 39, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(575, 27, 64, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(576, 27, 94, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(577, 27, 61, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(578, 27, 32, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(579, 27, 20, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(580, 27, 59, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(581, 27, 88, 10, 1, '2018-04-02 00:40:58', '2018-04-02 00:40:58'),
(728, 20, 102, 10, 1, '2018-04-02 00:51:20', '2018-04-02 00:51:20'),
(729, 20, 98, 10, 1, '2018-04-02 00:51:20', '2018-04-02 00:51:20'),
(730, 20, 43, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(731, 20, 25, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(732, 20, 57, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(733, 20, 90, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(734, 20, 67, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(735, 20, 56, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(736, 20, 54, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(737, 20, 53, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(738, 20, 44, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(739, 20, 41, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(740, 20, 40, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(741, 20, 89, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(742, 20, 68, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(743, 20, 71, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(744, 20, 70, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(745, 20, 28, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(746, 20, 19, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(747, 20, 72, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(748, 20, 69, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(749, 20, 18, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(750, 20, 4, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(751, 20, 58, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(752, 20, 66, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(753, 20, 31, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(754, 20, 63, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(755, 20, 91, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(756, 20, 99, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(757, 20, 101, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(758, 20, 3, 10, 1, '2018-04-02 00:51:21', '2018-04-02 00:51:21'),
(759, 20, 100, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(760, 20, 73, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(761, 20, 24, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(762, 20, 27, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(763, 20, 30, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(764, 20, 38, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(765, 20, 74, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(766, 20, 76, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(767, 20, 52, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(768, 20, 42, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(769, 20, 55, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(770, 20, 75, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(771, 20, 92, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(772, 20, 6, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(773, 20, 8, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(774, 20, 93, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(775, 20, 5, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(776, 20, 83, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(777, 20, 79, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(778, 20, 82, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(779, 20, 81, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(780, 20, 96, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(781, 20, 97, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(782, 20, 84, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(783, 20, 77, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(784, 20, 78, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(785, 20, 80, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(786, 20, 26, 10, 1, '2018-04-02 00:51:22', '2018-04-02 00:51:22'),
(787, 20, 60, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(788, 20, 65, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(789, 20, 95, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(790, 20, 29, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(791, 20, 62, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(792, 20, 33, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(793, 20, 39, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(794, 20, 64, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(795, 20, 94, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(796, 20, 61, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(797, 20, 32, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(798, 20, 20, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(799, 20, 59, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(800, 20, 88, 10, 1, '2018-04-02 00:51:23', '2018-04-02 00:51:23'),
(801, 1, 103, 0, 1, NULL, NULL),
(802, 1, 104, 0, 1, NULL, NULL),
(805, 1, 105, 0, 1, NULL, NULL),
(806, 1, 105, 0, 1, NULL, NULL),
(807, 1, 105, 0, 1, NULL, NULL),
(808, 1, 105, 0, 1, NULL, NULL),
(809, 1, 105, 0, 1, NULL, NULL),
(810, 1, 105, 0, 1, NULL, NULL),
(811, 1, 106, 0, 1, NULL, NULL),
(812, 1, 107, 0, 1, NULL, NULL),
(813, 1, 108, 0, 1, NULL, NULL),
(814, 1, 109, 0, 1, NULL, NULL),
(815, 1, 110, 0, 1, NULL, NULL),
(816, 1, 111, 0, 1, NULL, NULL),
(817, 1, 112, 0, 1, NULL, NULL),
(818, 1, 113, 0, 1, NULL, NULL),
(819, 1, 114, 0, 1, NULL, NULL),
(820, 1, 115, 0, 1, NULL, NULL),
(821, 1, 116, 0, 1, NULL, NULL),
(822, 1, 116, 0, 1, NULL, NULL),
(823, 1, 118, 0, 1, NULL, NULL),
(824, 1, 119, 0, 1, NULL, NULL),
(825, 1, 120, 0, 1, NULL, NULL),
(826, 1, 121, 0, 1, NULL, NULL),
(827, 1, 122, 0, 1, NULL, NULL),
(828, 1, 123, 0, 1, NULL, NULL),
(829, 1, 124, 0, 1, NULL, NULL),
(830, 1, 125, 0, 1, NULL, NULL),
(831, 1, 126, 0, 1, NULL, NULL),
(832, 1, 127, 0, 1, NULL, NULL),
(833, 1, 128, 0, 1, NULL, NULL),
(834, 1, 129, 0, 1, NULL, NULL),
(835, 1, 130, 0, 1, NULL, NULL),
(836, 1, 131, 0, 1, NULL, NULL),
(837, 1, 132, 0, 1, NULL, NULL),
(838, 1, 133, 0, 1, NULL, NULL),
(839, 1, 134, 0, 1, NULL, NULL),
(840, 1, 135, 0, 1, NULL, NULL),
(841, 1, 136, 0, 1, NULL, NULL),
(842, 1, 137, 0, 1, NULL, NULL),
(843, 1, 138, 0, 1, NULL, NULL),
(844, 29, 25, 10, 1, '2018-04-09 01:57:55', '2018-04-09 01:57:55'),
(845, 29, 67, 10, 1, '2018-04-09 01:57:56', '2018-04-09 01:57:56'),
(846, 29, 68, 10, 1, '2018-04-09 01:57:56', '2018-04-09 01:57:56'),
(847, 29, 71, 10, 1, '2018-04-09 01:57:56', '2018-04-09 01:57:56'),
(848, 29, 70, 10, 1, '2018-04-09 01:57:56', '2018-04-09 01:57:56'),
(849, 29, 28, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(850, 29, 19, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(851, 29, 72, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(852, 29, 69, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(853, 29, 18, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(854, 29, 4, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(855, 29, 31, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(856, 29, 3, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(857, 29, 24, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(858, 29, 27, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(859, 29, 30, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(860, 29, 38, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(861, 29, 6, 10, 1, '2018-04-09 01:57:57', '2018-04-09 01:57:57'),
(862, 29, 8, 10, 1, '2018-04-09 01:57:58', '2018-04-09 01:57:58'),
(863, 29, 5, 10, 1, '2018-04-09 01:57:58', '2018-04-09 01:57:58'),
(864, 29, 26, 10, 1, '2018-04-09 01:57:58', '2018-04-09 01:57:58'),
(865, 29, 29, 10, 1, '2018-04-09 01:57:58', '2018-04-09 01:57:58'),
(866, 29, 33, 10, 1, '2018-04-09 01:57:58', '2018-04-09 01:57:58'),
(867, 29, 32, 10, 1, '2018-04-09 01:57:58', '2018-04-09 01:57:58'),
(868, 29, 20, 10, 1, '2018-04-09 01:57:58', '2018-04-09 01:57:58');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_accounts_heads`
--
ALTER TABLE `mxp_accounts_heads`
  ADD PRIMARY KEY (`accounts_heads_id`);

--
-- Indexes for table `mxp_accounts_sub_heads`
--
ALTER TABLE `mxp_accounts_sub_heads`
  ADD PRIMARY KEY (`accounts_sub_heads_id`);

--
-- Indexes for table `mxp_acc_classes`
--
ALTER TABLE `mxp_acc_classes`
  ADD PRIMARY KEY (`mxp_acc_classes_id`);

--
-- Indexes for table `mxp_companies`
--
ALTER TABLE `mxp_companies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_languages`
--
ALTER TABLE `mxp_languages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_menu`
--
ALTER TABLE `mxp_menu`
  ADD PRIMARY KEY (`menu_id`);

--
-- Indexes for table `mxp_role`
--
ALTER TABLE `mxp_role`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_translations`
--
ALTER TABLE `mxp_translations`
  ADD PRIMARY KEY (`translation_id`);

--
-- Indexes for table `mxp_translation_keys`
--
ALTER TABLE `mxp_translation_keys`
  ADD PRIMARY KEY (`translation_key_id`);

--
-- Indexes for table `mxp_users`
--
ALTER TABLE `mxp_users`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `mxp_user_role_menu`
--
ALTER TABLE `mxp_user_role_menu`
  ADD PRIMARY KEY (`role_menu_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;
--
-- AUTO_INCREMENT for table `mxp_accounts_heads`
--
ALTER TABLE `mxp_accounts_heads`
  MODIFY `accounts_heads_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `mxp_accounts_sub_heads`
--
ALTER TABLE `mxp_accounts_sub_heads`
  MODIFY `accounts_sub_heads_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `mxp_acc_classes`
--
ALTER TABLE `mxp_acc_classes`
  MODIFY `mxp_acc_classes_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `mxp_companies`
--
ALTER TABLE `mxp_companies`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `mxp_languages`
--
ALTER TABLE `mxp_languages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `mxp_menu`
--
ALTER TABLE `mxp_menu`
  MODIFY `menu_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=139;
--
-- AUTO_INCREMENT for table `mxp_role`
--
ALTER TABLE `mxp_role`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;
--
-- AUTO_INCREMENT for table `mxp_translations`
--
ALTER TABLE `mxp_translations`
  MODIFY `translation_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=313;
--
-- AUTO_INCREMENT for table `mxp_translation_keys`
--
ALTER TABLE `mxp_translation_keys`
  MODIFY `translation_key_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=157;
--
-- AUTO_INCREMENT for table `mxp_users`
--
ALTER TABLE `mxp_users`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;
--
-- AUTO_INCREMENT for table `mxp_user_role_menu`
--
ALTER TABLE `mxp_user_role_menu`
  MODIFY `role_menu_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=869;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
