-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 07, 2018 at 12:09 PM
-- Server version: 10.1.34-MariaDB
-- PHP Version: 7.1.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `maxpronewerp`
--

DELIMITER $$
--
-- Procedures
--
CREATE PROCEDURE `getBookinAndBuyerDeatils` (IN `booking_order_id` VARCHAR(247))  NO SQL
SELECT mb.erp_code,mb.item_code,mb.item_price,mb.item_description, mb.orderDate,mb.orderNo,mb.shipmentDate,mb.poCatNo,mb.others_color ,GROUP_CONCAT(mb.item_size) as itemSize,GROUP_CONCAT(mb.gmts_color) as gmtsColor,GROUP_CONCAT(mb.item_quantity) as quantity, mbd.* from mxp_booking mb INNER JOIN mxp_bookingBuyer_details mbd on(mbd.booking_order_id = mb.booking_order_id) WHERE mb.booking_order_id = booking_order_id GROUP BY mb.item_code ORDER BY id ASC$$

CREATE PROCEDURE `getProductSizeQuantity` (IN `product_code` VARCHAR(247), IN `order_id` VARCHAR(247))  select mo.item_code,mo.oss,mo.style, mp.unit_price, mp.weight_qty, mp.erp_code, GROUP_CONCAT(mo.item_size) as item_size, GROUP_CONCAT(mo.quantity) as quantity, mo.order_id from mxp_order mo INNER JOIN mxp_product mp on(mo.item_code = mp.product_code) where mo.item_code = product_code AND mo.order_id = order_id GROUP by mo.item_code$$

CREATE PROCEDURE `getProductSizeQuantitybyPrice` (IN `booking_order_id` VARCHAR(100))  NO SQL
SELECT mb.erp_code,mb.item_code,mb.item_price,mb.orderDate,mb.orderNo,mb.shipmentDate,mb.poCatNo,mb.others_color ,GROUP_CONCAT(mb.item_size) as itemSize,GROUP_CONCAT(mb.gmts_color) as gmtsColor,GROUP_CONCAT(mb.item_quantity) as quantity, mbd.* from mxp_booking mb INNER JOIN mxp_bookingBuyer_details mbd on(mbd.booking_order_id = mb.booking_order_id) INNER JOIN mxp_product mp on( mb.item_code = mp.product_code) WHERE mb.booking_order_id = booking_order_id GROUP BY mb.item_code$$

CREATE PROCEDURE `getProductSizeQuantityWithConcat` (IN `product_code` VARCHAR(247))  NO SQL
SELECT mp.erp_code,mp.product_id,mp.unit_price,mp.product_name,mp.others_color,mp.product_description ,GROUP_CONCAT(mps.product_size order by product_size) as size,GROUP_CONCAT(mgs.color_name) as color   FROM mxp_product mp 
LEFT JOIN mxp_productSize mps ON (mps.product_code = mp.product_code)
LEFT JOIN mxp_gmts_color mgs ON (mgs.item_code = mps.product_code)
WHERE mp.product_code = product_code and mp.status = 1 GROUP BY mps.product_code, mgs.item_code$$

CREATE PROCEDURE `get_all_role_list_by_group_id` (IN `grp_id` INT(11))  SELECT GROUP_CONCAT(DISTINCT(c.name)) as c_name,r.* FROM mxp_role r join mxp_companies c on(c.id=r.company_id)
where c.group_id=grp_id GROUP BY r.cm_group_id$$

CREATE PROCEDURE `get_all_translation` ()  SELECT tr.*,tk.translation_key FROM mxp_translation_keys tk INNER JOIN mxp_translations tr ON(tr.translation_key_id=tk.translation_key_id)$$

CREATE PROCEDURE `get_all_translation_with_limit` (IN `startedAt` INT(11), IN `limits` INT(11))  SELECT tr.*,tk.translation_key, ml.lan_name FROM mxp_translation_keys tk INNER JOIN
 mxp_translations tr ON(tr.translation_key_id=tk.translation_key_id) 
 INNER JOIN mxp_languages ml ON(ml.lan_code=tr.lan_code)order by tk.translation_key_id desc limit startedAt,limits$$

CREATE PROCEDURE `get_child_menu_list` (IN `p_parent_menu_id` INT(11), IN `role_id` INT(11), IN `comp_id` INT(11))  if(comp_id !='') then
SELECT m.* FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE rm.role_id=role_id AND rm.company_id=comp_id AND m.parent_id=p_parent_menu_id order by m.order_id ASC;
else
SELECT m.* FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE rm.role_id=role_id AND m.parent_id=p_parent_menu_id order by m.order_id ASC;
end if$$

CREATE PROCEDURE `get_companies_by_group_id` (IN `grp_id` INT(11))  select * from mxp_companies where group_id=grp_id and is_active = 1$$

CREATE PROCEDURE `get_permission` (IN `role_id` INT(11), IN `route` VARCHAR(120), IN `comp_id` INT(11))  if(comp_id !='')then
SELECT COUNT(*) as cnt FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE m.route_name=route AND rm.role_id=role_id AND rm.company_id=comp_id;
else
SELECT COUNT(*) as cnt FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE m.route_name=route AND rm.role_id=role_id ;
end if$$

CREATE PROCEDURE `get_roles_by_company_id` (IN `cmpny_id` INT(11), IN `cm_grp_id` INT(11))  SELECT rl.name as roleName, cm.name as companyName, cm.id as company_id, rl.cm_group_id, rl.is_active FROM mxp_role rl INNER JOIN mxp_companies cm ON(rl.company_id=cm.id) where cm.group_id = `cmpny_id` and rl.cm_group_id = `cm_grp_id`$$

CREATE PROCEDURE `get_searched_trans_key` (IN `_key` VARCHAR(255))  SELECT distinct(tk.translation_key),tk.translation_key_id, tk.is_active FROM mxp_translation_keys tk
 inner join mxp_translations tr on(tk.translation_key_id = tr.translation_key_id)
 WHERE tk.translation_key LIKE CONCAT('%', _key , '%')$$

CREATE PROCEDURE `get_translations_by_key_id` (IN `key_id` INT)  select translation_id, translation, lan_code from mxp_translations
 where translation_key_id= `key_id` and is_active = 1$$

CREATE PROCEDURE `get_translations_by_locale` (IN `locale_code` VARCHAR(255))  SELECT tr.translation,tk.translation_key FROM mxp_translation_keys tk INNER JOIN mxp_translations tr ON(tr.translation_key_id=tk.translation_key_id)
WHERE tr.lan_code=locale_code$$

CREATE PROCEDURE `get_translation_by_key_id` (IN `tr_key_id` INT(11))  SELECT tr.translation,tk.translation_key,tk.translation_key_id,tk.is_active,ln.lan_name FROM mxp_translation_keys tk INNER JOIN mxp_translations tr ON(tr.translation_key_id=tk.translation_key_id)
INNER JOIN mxp_languages ln ON(ln.lan_code=tr.lan_code)
WHERE tr.translation_key_id=tr_key_id$$

CREATE PROCEDURE `get_user_menu_by_role` (IN `role_id` INT(11), IN `comp_id` INT(11))  if(comp_id !='') then
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
(46, '2018_02_06_100944_create_mxp_taxvats_table', 18),
(47, '2018_02_06_103251_create_mxp_taxvat_cals_table', 18),
(48, '2018_04_04_053741_create_mxp_accounts_heads_table', 19),
(49, '2018_04_05_093858_create_store_procedure_get_all_acc_class', 20),
(50, '2018_04_05_123858_create_mxp_acc_head_sub_classes_table', 20),
(51, '2018_04_06_060320_create_store_pro_get_all_sub_class_name', 20),
(52, '2018_04_06_070031_create_store_pro_get_all_chart_of_accounts', 20),
(53, '2018_04_05_125024_create_mxp_chart_of_acc_heads_table', 21),
(78, '2018_01_27_110718_update_mxp_role_table', 22),
(79, '2018_04_10_112500_create_party_product_tablee', 22),
(82, '2018_04_12_130615_create_page_footer_table', 22),
(83, '2018_04_12_130725_create_page_report_footer_table', 22),
(84, '2018_04_16_070741_create_brand_table', 22),
(89, '2018_04_16_095019_create_productSize_table', 23),
(143, '2018_04_11_065758_create_party_table', 24),
(145, '2018_04_23_111907_create_excel_emport_table', 24),
(146, '2018_04_25_164456_create_bill_table', 24),
(147, '2018_05_04_081744_create_challan_table', 24),
(148, '2018_05_04_121456_create_multiple_challan_table', 24),
(150, '2018_05_25_071327_create_order_input_new_table', 24),
(152, '2018_06_06_065708_create_gmts_color_table', 24),
(166, '2018_04_12_130515_create_page_header_table', 25),
(221, '2018_06_21_064357_create_pi_format_data_table_info', 27),
(239, '2018_06_01_090140_create_new_booking_list_table', 28),
(240, '2018_06_08_045630_booking_buyer_deatils_table_create', 28),
(241, '2018_06_23_094814_create_booking_challan_table', 28),
(246, '2018_05_07_060534_create_mxp_ipo_table', 29),
(247, '2018_06_23_131029_create_booking_multiple_challan_table', 29),
(248, '2018_07_10_081809_create_mxp_MRF_table', 29),
(249, '2018_07_17_093951_create_vendor_prices_table', 30),
(250, '2018_07_17_103743_create_mxp_task_table', 30),
(251, '2018_07_18_123833_create_mxp_task_role_table', 30),
(252, '2018_07_19_103016_create_suppliers_table', 30),
(253, '2018_07_20_054043_add_is+delete_column_at_supplier', 30),
(254, '2018_07_20_062001_create_mxp_supplier_prices_table', 30),
(255, '2018_07_17_105255_modify_mxp_vendor_prices', 31),
(256, '2018_07_18_094352_add_column_in_vendor_price', 31),
(257, '2018_07_24_072145_create_mxp_items_qnty_by_booking_challan', 32),
(258, '2018_07_24_073844_create_create_mxp_items_qnty_by_booking_challans_table', 33),
(259, '2018_07_27_121336_update_getProductSizeQuantityWithConcat_store_porceduer', 34),
(260, '2018_07_23_064442_add_product_type_column_at_mxp_product_table', 35),
(261, '2018_07_23_081335_add_supplier_id_mxp_MRF_table', 35),
(262, '2018_07_23_103343_add_booking_status_column_at_mxp_bookingBuyer_details', 35),
(263, '2018_07_30_070914_create_mxp_purchase_orders_table', 36);

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
-- Table structure for table `mxp_booking`
--

CREATE TABLE `mxp_booking` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `booking_order_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `matarial` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gmts_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `others_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderDate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderNo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipmentDate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `poCatNo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_booking`
--

INSERT INTO `mxp_booking` (`id`, `user_id`, `booking_order_id`, `erp_code`, `item_code`, `item_size`, `item_description`, `item_quantity`, `item_price`, `matarial`, `gmts_color`, `others_color`, `orderDate`, `orderNo`, `shipmentDate`, `poCatNo`, `sku`, `created_at`, `updated_at`) VALUES
(1, 49, 'INVO-23062018-Mi-0001', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-06-23 06:18:01', '2018-06-23 06:18:01'),
(2, 49, 'INVO-23062018-Mi-0001', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-06-23 06:18:01', '2018-06-23 06:18:01'),
(3, 49, 'INVO-23062018-Mi-0001', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '2', '0.3', NULL, 'SEAL GREY', 'CORD COLOR', NULL, NULL, NULL, NULL, '', '2018-06-23 06:18:01', '2018-06-23 06:18:01'),
(4, 49, 'INVO-23062018-Mi-0001', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'DARK STEEL', '0', '2', '0.3', NULL, 'SEAL GREY', 'CORD COLOR', NULL, NULL, NULL, NULL, '', '2018-06-23 06:18:01', '2018-06-23 06:18:01'),
(5, 49, 'INVO-23062018-CSF-0002', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:20:39', '2018-06-23 07:20:39'),
(6, 49, 'INVO-23062018-CSF-0002', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:20:39', '2018-06-23 07:20:39'),
(7, 49, 'INVO-23062018-CSF-0002', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:20:39', '2018-06-23 07:20:39'),
(8, 49, 'INVO-23062018-CSF-0002', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU XS CN 160/84A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:20:39', '2018-06-23 07:20:39'),
(9, 49, 'INVO-23062018-CSF-0002', '22322', 'CSO04369 - REGETTA GREAT', '4XL', '0', '122', '0.6', NULL, 'DARK KHAKI', '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:20:39', '2018-06-23 07:20:39'),
(10, 49, 'INVO-23062018-CSF-0002', '22322', 'CSO04369 - REGETTA GREAT', '5XL', '0', '122', '0.6', NULL, 'DARK KHAKI', '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:20:39', '2018-06-23 07:20:39'),
(11, 49, 'INVO-23062018-CSF-0002', '22322', 'CSO04369 - REGETTA GREAT', 'm', '0', '122', '0.6', NULL, 'DARK KHAKI', '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:20:39', '2018-06-23 07:20:39'),
(12, 49, 'INVO-23062018-CSF-0003', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '122', '0.002', NULL, NULL, '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:24:55', '2018-06-23 07:24:55'),
(13, 49, 'INVO-23062018-CSF-0003', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '1225', '0.002', NULL, NULL, '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:24:55', '2018-06-23 07:24:55'),
(14, 49, 'INVO-23062018-CSF-0003', '22322', 'CSO04369 - REGETTA GREAT', '4XL', '0', '1234', '0.6', NULL, 'NAVY', '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:24:55', '2018-06-23 07:24:55'),
(15, 49, 'INVO-23062018-CSF-0003', '22322', 'CSO04369 - REGETTA GREAT', '5XL', '0', '1234', '0.6', NULL, 'NAVY', '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:24:55', '2018-06-23 07:24:55'),
(16, 49, 'INVO-25062018-CSF-0004', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-06-19', '111111', '2018-06-27', '111111', '', '2018-06-24 22:53:31', '2018-06-24 22:53:31'),
(17, 49, 'INVO-25062018-CSF-0004', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-06-19', '111111', '2018-06-27', '111111', '', '2018-06-24 22:53:31', '2018-06-24 22:53:31'),
(18, 49, 'INVO-25062018-ACL-0005', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '2', '0.002', NULL, NULL, '0', '2018-06-28', '111111', '2018-06-27', '111111', '', '2018-06-24 22:57:41', '2018-06-24 22:57:41'),
(19, 49, 'INVO-25062018-ACL-0005', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '2', '0.002', NULL, NULL, '0', '2018-06-28', '111111', '2018-06-27', '111111', '', '2018-06-24 22:57:41', '2018-06-24 22:57:41'),
(20, 49, 'INVO-25062018-ACL-0005', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '2', '0.002', NULL, NULL, '0', '2018-06-28', '111111', '2018-06-27', '111111', '', '2018-06-24 22:57:41', '2018-06-24 22:57:41'),
(21, 49, 'INVO-25062018-ACL-0005', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '1234', '.08', NULL, NULL, '0', '2018-06-28', '111111', '2018-06-27', '111111', '', '2018-06-24 22:57:41', '2018-06-24 22:57:41'),
(22, 49, 'INVO-25062018-ACL-0005', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '1234', '.08', NULL, NULL, '0', '2018-06-28', '111111', '2018-06-27', '111111', '', '2018-06-24 22:57:41', '2018-06-24 22:57:41'),
(23, 49, 'INVO-25062018-ACL-0005', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF S CN 165/88A', 'aaa', '1234', '.08', NULL, NULL, '0', '2018-06-28', '111111', '2018-06-27', '111111', '', '2018-06-24 22:57:41', '2018-06-24 22:57:41'),
(24, 49, 'INVO-05072018-Mi-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 02:54:44', '2018-07-05 02:54:44'),
(25, 49, 'INVO-05072018-Mi-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 02:54:44', '2018-07-05 02:54:44'),
(26, 49, 'INVO-05072018-Mi-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '140', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 02:54:44', '2018-07-05 02:54:44'),
(27, 49, 'INVO-05072018-CSF-0007', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 03:29:47', '2018-07-05 03:29:47'),
(28, 49, 'INVO-05072018-CSF-0007', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '130', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 03:29:47', '2018-07-05 03:29:47'),
(29, 49, 'INVO-05072018-CD-0008', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-05', '1', '2018-07-05', '12', '', '2018-07-05 06:03:07', '2018-07-05 06:03:07'),
(30, 49, 'INVO-05072018-CD-0008', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-05', '1', '2018-07-05', '12', '', '2018-07-05 06:03:07', '2018-07-05 06:03:07'),
(31, 49, 'INVO-05072018-CD-0008', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '130', '.08', NULL, NULL, '0', '2018-07-05', '1', '2018-07-05', '12', '', '2018-07-05 06:03:07', '2018-07-05 06:03:07'),
(32, 49, 'INVO-05072018-CD-0008', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '140', '.08', NULL, NULL, '0', '2018-07-05', '1', '2018-07-05', '12', '', '2018-07-05 06:03:07', '2018-07-05 06:03:07'),
(33, 49, 'INVO-05072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '100', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:12:08', '2018-07-05 06:12:08'),
(34, 49, 'INVO-05072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '100', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:12:08', '2018-07-05 06:12:08'),
(35, 49, 'INVO-05072018-CSF-0009', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '100', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:12:08', '2018-07-05 06:12:08'),
(36, 49, 'INVO-05072018-CSF-0009', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '100', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:12:08', '2018-07-05 06:12:08'),
(37, 49, 'INVO-05072018-CSF-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '100', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:13:53', '2018-07-05 06:13:53'),
(38, 49, 'INVO-05072018-CSF-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '100', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:13:54', '2018-07-05 06:13:54'),
(39, 49, 'INVO-05072018-CSF-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '100', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:13:54', '2018-07-05 06:13:54'),
(40, 49, 'INVO-05072018-CSF-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '100', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:13:54', '2018-07-05 06:13:54'),
(41, 49, 'INVO-05072018-CSF-0011', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '100', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:16:12', '2018-07-05 06:16:12'),
(42, 49, 'INVO-05072018-CSF-0011', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '100', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:16:12', '2018-07-05 06:16:12'),
(43, 49, 'INVO-05072018-CSF-0012', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '100', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:17:55', '2018-07-05 06:17:55'),
(44, 49, 'INVO-05072018-CSF-0012', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '100', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:17:55', '2018-07-05 06:17:55'),
(45, 49, 'INVO-05072018-CSF-0012', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '100', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:17:55', '2018-07-05 06:17:55'),
(46, 49, 'INVO-05072018-CSF-0012', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '100', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:17:55', '2018-07-05 06:17:55'),
(47, 49, 'INVO-06072018-CSF-0013', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-06 06:18:07', '2018-07-06 06:18:07'),
(48, 49, 'INVO-06072018-CSF-0013', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-06 06:18:07', '2018-07-06 06:18:07'),
(49, 49, 'INVO-06072018-CSF-0013', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-06 06:18:08', '2018-07-06 06:18:08'),
(50, 49, 'INVO-07072018-Mi-0014', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-11', '01', '2018-07-25', '111', '', '2018-07-06 22:23:46', '2018-07-06 22:23:46'),
(51, 49, 'INVO-07072018-Mi-0014', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-11', '01', '2018-07-25', '111', '', '2018-07-06 22:23:46', '2018-07-06 22:23:46'),
(52, 49, 'INVO-07072018-Mi-0014', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '130', '.08', NULL, NULL, '0', '2018-07-11', '01', '2018-07-25', '111', '', '2018-07-06 22:23:46', '2018-07-06 22:23:46'),
(53, 49, 'INVO-07072018-Mi-0014', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '140', '.08', NULL, NULL, '0', '2018-07-11', '01', '2018-07-25', '111', '', '2018-07-06 22:23:46', '2018-07-06 22:23:46'),
(54, 49, 'INVO-07072018-CSF-0015', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '2000', '0.08', NULL, NULL, '0', '2018-07-07', '008', '2018-07-24', '7655434', '', '2018-07-06 23:52:02', '2018-07-06 23:52:02'),
(55, 49, 'INVO-07072018-CSF-0015', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '600', '0.0802', NULL, NULL, '0', '2018-07-07', '008', '2018-07-24', '7655434', '', '2018-07-06 23:52:02', '2018-07-06 23:52:02'),
(56, 49, 'INVO-07072018-CSF-0015', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '300', '.08', NULL, NULL, '0', '2018-07-07', '008', '2018-07-24', '7655434', '', '2018-07-06 23:52:02', '2018-07-06 23:52:02'),
(57, 49, 'INVO-10072018-CSF-0016', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '111', '.08', NULL, NULL, 'others_color', NULL, NULL, NULL, NULL, '', '2018-07-10 01:43:00', '2018-07-10 01:43:00'),
(58, 49, 'INVO-10072018-CSF-0017', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '2333', '.08', NULL, NULL, 'others_color', NULL, NULL, NULL, NULL, '', '2018-07-10 01:46:26', '2018-07-10 01:46:26'),
(59, 49, 'INVO-10072018-CSF-0018', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '2333', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-10 01:46:42', '2018-07-10 01:46:42'),
(60, 49, 'INVO-10072018-CSF-0019', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '12', '.08', NULL, NULL, 'aaaaa', NULL, NULL, NULL, NULL, '', '2018-07-10 01:53:34', '2018-07-10 01:53:34'),
(61, 49, 'INVO-10072018-CSF-0020', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '12', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-10 01:55:34', '2018-07-10 01:55:34'),
(62, 49, 'INVO-11072018-CSF-0021', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-19', '12', '2018-07-25', '121', '', '2018-07-10 23:44:02', '2018-07-10 23:44:02'),
(63, 49, 'INVO-11072018-CSF-0021', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-19', '12', '2018-07-25', '121', '', '2018-07-10 23:44:02', '2018-07-10 23:44:02'),
(64, 49, 'INVO-11072018-CSF-0021', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-19', '12', '2018-07-25', '121', '', '2018-07-10 23:44:02', '2018-07-10 23:44:02'),
(65, 49, 'INVO-11072018-CSF-0021', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU XS CN 160/84A', '2L.ML-TA.001', '140', '0.002', NULL, NULL, '0', '2018-07-19', '12', '2018-07-25', '121', '', '2018-07-10 23:44:02', '2018-07-10 23:44:02'),
(77, 49, 'INVO-11072018-CSF-0001', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 06:54:40', '2018-07-11 06:54:40'),
(78, 49, 'INVO-11072018-CSF-0001', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 06:54:41', '2018-07-11 06:54:41'),
(79, 49, 'INVO-11072018-CSF-0001', '04-OST2LSLTA001X-01', '2L.SL-TA.001', '0', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 06:54:41', '2018-07-11 06:54:41'),
(80, 49, 'INVO-11072018-CSF-0001', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '220', '.08', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 06:54:41', '2018-07-11 06:54:41'),
(81, 49, 'INVO-11072018-CSF-0001', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '230', '.08', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 06:54:41', '2018-07-11 06:54:41'),
(82, 49, 'INVO-11072018-ACL-0002', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 07:02:45', '2018-07-11 07:02:45'),
(83, 49, 'INVO-11072018-ACL-0002', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 07:02:45', '2018-07-11 07:02:45'),
(84, 49, 'INVO-11072018-ACL-0002', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 07:02:45', '2018-07-11 07:02:45'),
(85, 49, 'INVO-11072018-ACL-0002', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU XS CN 160/84A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 07:02:45', '2018-07-11 07:02:45'),
(86, 49, 'INVO-12072018-CSF-0003', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-11 23:18:32', '2018-07-11 23:18:32'),
(87, 49, 'INVO-12072018-CSF-0003', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-11 23:18:32', '2018-07-11 23:18:32'),
(88, 49, 'INVO-12072018-CSF-0003', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-11 23:18:32', '2018-07-11 23:18:32'),
(89, 49, 'INVO-12072018-CSF-0004', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-11 23:33:49', '2018-07-11 23:33:49'),
(90, 49, 'INVO-12072018-CSF-0004', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-11 23:33:49', '2018-07-11 23:33:49'),
(91, 49, 'INVO-12072018-CSF-0004', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-11 23:33:50', '2018-07-11 23:33:50'),
(92, 49, 'INVO-12072018-CSF-0004', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '210', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-11 23:33:50', '2018-07-11 23:33:50'),
(93, 49, 'INVO-12072018-CSF-0004', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '220', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-11 23:33:50', '2018-07-11 23:33:50'),
(94, 49, 'INVO-12072018-CSF-0004', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF S CN 165/88A', 'aaa', '230', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-11 23:33:50', '2018-07-11 23:33:50'),
(95, 49, 'INVO-12072018-CSF-0005', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-12 00:00:12', '2018-07-12 00:00:12'),
(96, 49, 'INVO-12072018-CSF-0005', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-12 00:00:12', '2018-07-12 00:00:12'),
(97, 49, 'INVO-12072018-CSF-0005', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU XS CN 160/84A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-12 00:00:12', '2018-07-12 00:00:12'),
(98, 49, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-12', '12', '2018-07-26', '111111', '', '2018-07-12 00:31:06', '2018-07-12 00:31:06'),
(99, 49, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-12', '12', '2018-07-26', '111111', '', '2018-07-12 00:31:06', '2018-07-12 00:31:06'),
(100, 49, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-12', '12', '2018-07-26', '111111', '', '2018-07-12 00:31:06', '2018-07-12 00:31:06'),
(101, 49, 'INVO-12072018-CSF-0007', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-19', '111111', '', '2018-07-12 01:54:44', '2018-07-12 01:54:44'),
(102, 49, 'INVO-12072018-CSF-0007', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-19', '111111', '', '2018-07-12 01:54:44', '2018-07-12 01:54:44'),
(103, 49, 'INVO-12072018-CSF-0007', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-19', '111111', '', '2018-07-12 01:54:44', '2018-07-12 01:54:44'),
(104, 49, 'INVO-12072018-CSF-0007', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '210', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-19', '111111', '', '2018-07-12 01:54:44', '2018-07-12 01:54:44'),
(105, 49, 'INVO-12072018-CSF-0007', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '220', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-19', '111111', '', '2018-07-12 01:54:45', '2018-07-12 01:54:45'),
(106, 49, 'INVO-12072018-CD-0008', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-07-12', NULL, NULL, NULL, '', '2018-07-12 03:03:49', '2018-07-12 03:03:49'),
(107, 49, 'INVO-12072018-CD-0008', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-07-12', NULL, NULL, NULL, '', '2018-07-12 03:03:50', '2018-07-12 03:03:50'),
(108, 49, 'INVO-12072018-CD-0008', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '1234', '0.002', NULL, NULL, '0', '2018-07-12', NULL, NULL, NULL, '', '2018-07-12 03:03:50', '2018-07-12 03:03:50'),
(109, 49, 'INVO-12072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', NULL, NULL, '2018-07-25', NULL, '', '2018-07-12 06:09:12', '2018-07-12 06:09:12'),
(110, 49, 'INVO-12072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', NULL, NULL, '2018-07-25', NULL, '', '2018-07-12 06:09:12', '2018-07-12 06:09:12'),
(111, 49, 'INVO-12072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '140', '0.002', NULL, NULL, '0', NULL, NULL, '2018-07-25', NULL, '', '2018-07-12 06:09:12', '2018-07-12 06:09:12'),
(112, 49, 'INVO-13072018-CD-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-26', '111111', '', '2018-07-13 00:31:12', '2018-07-13 00:31:12'),
(113, 49, 'INVO-13072018-CD-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-26', '111111', '', '2018-07-13 00:31:12', '2018-07-13 00:31:12'),
(114, 49, 'INVO-13072018-CD-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-26', '111111', '', '2018-07-13 00:31:12', '2018-07-13 00:31:12'),
(115, 49, 'INVO-13072018-CD-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '210', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-26', '111111', '', '2018-07-13 00:31:12', '2018-07-13 00:31:12'),
(116, 49, 'INVO-13072018-CD-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '220', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-26', '111111', '', '2018-07-13 00:31:12', '2018-07-13 00:31:12'),
(117, 49, 'INVO-13072018-CD-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF S CN 165/88A', 'aaa', '230', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-26', '111111', '', '2018-07-13 00:31:12', '2018-07-13 00:31:12'),
(118, 49, 'INVO-13072018-CSF-0011', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-13 03:32:49', '2018-07-13 03:32:49'),
(119, 49, 'INVO-13072018-CSF-0011', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-13 03:32:49', '2018-07-13 03:32:49'),
(120, 49, 'INVO-13072018-CSF-0011', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-13 03:32:49', '2018-07-13 03:32:49'),
(121, 49, 'INVO-13072018-CSF-0011', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '210', '.08', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-13 03:32:49', '2018-07-13 03:32:49'),
(122, 49, 'INVO-13072018-CSF-0011', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '220', '.08', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-13 03:32:49', '2018-07-13 03:32:49'),
(123, 49, 'INVO-13072018-CSF-0011', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF S CN 165/88A', 'aaa', '230', '.08', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-13 03:32:49', '2018-07-13 03:32:49'),
(124, 49, 'INVO-13072018-CSF-0012', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-13 05:42:09', '2018-07-13 05:42:09'),
(125, 49, 'INVO-13072018-CSF-0012', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-13 05:42:09', '2018-07-13 05:42:09'),
(126, 49, 'INVO-13072018-CSF-0012', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-13 05:42:09', '2018-07-13 05:42:09'),
(127, 49, 'INVO-13072018-CSF-0012', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '120', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-13 05:42:09', '2018-07-13 05:42:09'),
(128, 49, 'INVO-13072018-CSF-0013', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-24', '99', '', '2018-07-13 06:49:39', '2018-07-13 06:49:39'),
(129, 49, 'INVO-13072018-CSF-0013', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-24', '99', '', '2018-07-13 06:49:39', '2018-07-13 06:49:39'),
(130, 49, 'INVO-13072018-CSF-0013', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-24', '99', '', '2018-07-13 06:49:39', '2018-07-13 06:49:39'),
(131, 49, 'INVO-13072018-CSF-0013', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '210', '.08', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-24', '99', '', '2018-07-13 06:49:39', '2018-07-13 06:49:39'),
(132, 49, 'INVO-13072018-CSF-0013', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '220', '.08', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-24', '99', '', '2018-07-13 06:49:39', '2018-07-13 06:49:39'),
(133, 49, 'INVO-13072018-CSF-0013', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF S CN 165/88A', 'aaa', '230', '.08', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-24', '99', '', '2018-07-13 06:49:39', '2018-07-13 06:49:39'),
(134, 49, 'INVO-13072018-CSF-0035', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-18', '111111', '2018-07-25', '12', '', '2018-07-13 08:58:29', '2018-07-13 08:58:29'),
(135, 49, 'INVO-13072018-CSF-0035', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-18', '111111', '2018-07-25', '12', '', '2018-07-13 08:58:30', '2018-07-13 08:58:30'),
(136, 49, 'INVO-13072018-CSF-0035', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-18', '111111', '2018-07-25', '12', '', '2018-07-13 08:58:30', '2018-07-13 08:58:30'),
(137, 49, 'INVO-13072018-CSF-0035', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '210', '.08', NULL, NULL, '0', '2018-07-18', '111111', '2018-07-25', '12', '', '2018-07-13 08:58:30', '2018-07-13 08:58:30'),
(138, 49, 'INVO-13072018-CSF-0035', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '220', '.08', NULL, NULL, '0', '2018-07-18', '111111', '2018-07-25', '12', '', '2018-07-13 08:58:30', '2018-07-13 08:58:30'),
(139, 49, 'INVO-13072018-CSF-0035', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF S CN 165/88A', 'aaa', '230', '.08', NULL, NULL, '0', '2018-07-18', '111111', '2018-07-25', '12', '', '2018-07-13 08:58:30', '2018-07-13 08:58:30'),
(140, 49, 'INVO-13072018-CSF-0036', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-17', '99', '', '2018-07-13 09:10:36', '2018-07-13 09:10:36'),
(141, 49, 'INVO-13072018-CSF-0036', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-17', '99', '', '2018-07-13 09:10:36', '2018-07-13 09:10:36'),
(142, 49, 'INVO-13072018-CSF-0036', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '130', '0.002', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-17', '99', '', '2018-07-13 09:10:36', '2018-07-13 09:10:36'),
(143, 49, 'BK-13072018-CSF-0037', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '1234', '.05', NULL, NULL, '0', NULL, '34343', '2018-07-31', '343434', 'fddf', '2018-07-13 09:56:27', '2018-07-13 09:56:27'),
(144, 49, 'BK-13072018-CSF-0037', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '2000', '.05', NULL, NULL, '0', NULL, '34343', '2018-07-31', '343434', 'fddf', '2018-07-13 09:56:27', '2018-07-13 09:56:27'),
(145, 49, 'BK-13072018-CSF-0037', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '899', '0.3', NULL, 'DARK KHAKI', '0', NULL, '34343', '2018-07-31', '343434', 'fddf', '2018-07-13 09:56:27', '2018-07-13 09:56:27'),
(146, 49, 'BK-24072018-CSF-0039', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:54:18', '2018-07-24 01:54:18'),
(147, 49, 'BK-24072018-CSF-0039', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1200', '1.01', NULL, 'WWWWWWW', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:54:18', '2018-07-24 01:54:18'),
(148, 49, 'BK-24072018-CSF-0039', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '500', '.05', NULL, NULL, '0', '2018-07-24', '14254', '2018-07-26', '1425', '145245', '2018-07-24 01:54:18', '2018-07-24 01:54:18'),
(149, 49, 'BK-24072018-CSF-0040', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:55:06', '2018-07-24 01:55:06'),
(150, 49, 'BK-24072018-CSF-0040', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1200', '1.01', NULL, 'WWWWWWW', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:55:06', '2018-07-24 01:55:06'),
(151, 49, 'BK-24072018-CSF-0040', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '500', '.05', NULL, NULL, '0', '2018-07-24', '14254', '2018-07-26', '1425', '145245', '2018-07-24 01:55:06', '2018-07-24 01:55:06'),
(152, 49, 'BK-24072018-CSF-0041', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:55:52', '2018-07-24 01:55:52'),
(153, 49, 'BK-24072018-CSF-0041', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1200', '1.01', NULL, 'WWWWWWW', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:55:52', '2018-07-24 01:55:52'),
(154, 49, 'BK-24072018-CSF-0041', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '500', '.05', NULL, NULL, '0', '2018-07-24', '14254', '2018-07-26', '1425', '145245', '2018-07-24 01:55:52', '2018-07-24 01:55:52'),
(155, 49, 'BK-24072018-CSF-0042', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:57:16', '2018-07-24 01:57:16'),
(156, 49, 'BK-24072018-CSF-0042', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1200', '1.01', NULL, 'WWWWWWW', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:57:16', '2018-07-24 01:57:16'),
(157, 49, 'BK-24072018-CSF-0042', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '500', '.05', NULL, NULL, '0', '2018-07-24', '14254', '2018-07-26', '1425', '145245', '2018-07-24 01:57:16', '2018-07-24 01:57:16'),
(158, 49, 'BK-24072018-CD-0043', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-24', '1221', '2018-07-27', '1424', '1412', '2018-07-24 01:59:01', '2018-07-24 01:59:01'),
(159, 49, 'BK-24072018-CD-0043', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1200', '1.01', NULL, 'WWWWWWW', '0', '2018-07-24', '1221', '2018-07-27', '1424', '1412', '2018-07-24 01:59:01', '2018-07-24 01:59:01'),
(160, 49, 'BK-24072018-CD-0043', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '1400', '.05', NULL, NULL, '0', '2018-07-24', '1221', '2018-07-27', '1424', '12452', '2018-07-24 01:59:01', '2018-07-24 01:59:01'),
(161, 49, 'BK-24072018-CD-0044', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-24', '121', '2018-07-26', '121', '1242', '2018-07-24 02:03:15', '2018-07-24 02:03:15'),
(162, 49, 'BK-24072018-CD-0044', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1050', '1.01', NULL, 'WWWWWWW', '0', '2018-07-24', '121', '2018-07-26', '121', '1242', '2018-07-24 02:03:15', '2018-07-24 02:03:15'),
(163, 49, 'BK-24072018-CD-0044', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '500', '.05', NULL, NULL, '0', '2018-07-24', '121', '2018-07-26', '121', '1424', '2018-07-24 02:03:15', '2018-07-24 02:03:15'),
(164, 49, 'BK-24072018-CSF-0045', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '500', '.08', NULL, NULL, '0', '2018-07-24', '4514', '2018-07-27', '415241', '2141', '2018-07-24 02:05:28', '2018-07-24 02:05:28'),
(165, 49, 'BK-24072018-CD-0046', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-24', '41254', '2018-07-26', '454', '101', '2018-07-24 02:29:26', '2018-07-24 02:29:26'),
(166, 49, 'BK-24072018-CD-0046', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1200', '1.01', NULL, 'WWWWWWW', '0', '2018-07-24', '41254', '2018-07-26', '454', '101', '2018-07-24 02:29:26', '2018-07-24 02:29:26'),
(167, 49, 'BK-24072018-CD-0046', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '1000', '.05', NULL, NULL, '0', '2018-07-24', '41254', '2018-07-26', '454', '415', '2018-07-24 02:29:26', '2018-07-24 02:29:26'),
(168, 49, 'BK-24072018-rga-0047', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-11', '454', '2018-07-10', '1254', '12541', '2018-07-24 04:11:03', '2018-07-24 04:11:03'),
(169, 49, 'BK-24072018-rga-0047', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '800', '1.01', NULL, 'WWWWWWW', '0', '2018-07-11', '454', '2018-07-10', '1254', '12541', '2018-07-24 04:11:03', '2018-07-24 04:11:03'),
(170, 49, 'BK-24072018-rga-0047', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '500', '.05', NULL, NULL, '0', '2018-07-11', '454', '2018-07-10', '1254', '1441', '2018-07-24 04:11:03', '2018-07-24 04:11:03'),
(171, 49, 'BK-25072018-CSF-0048', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '52415', '2018-07-27', '4545', '245', '2018-07-25 04:55:34', '2018-07-25 04:55:34'),
(172, 49, 'BK-25072018-CSF-0048', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', '2018-07-25', '52415', '2018-07-27', '4545', '245', '2018-07-25 04:55:34', '2018-07-25 04:55:34'),
(173, 49, 'BK-25072018-CSF-0048', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', '52415', '2018-07-27', '4545', '1244', '2018-07-25 04:55:34', '2018-07-25 04:55:34'),
(174, 49, 'BK-25072018-CSF-0048', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'DARK STEEL', '0', '100', '0.3', NULL, 'BLACK (BLACK BACKING)', '0', '2018-07-25', '52415', '2018-07-27', '4545', '2145', '2018-07-25 04:55:34', '2018-07-25 04:55:34'),
(175, 49, 'BK-25072018-CSF-0049', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '100', '.05', NULL, NULL, '0', '2018-07-25', '42124', '2018-07-28', '412', '414', '2018-07-25 04:57:12', '2018-07-25 04:57:12'),
(176, 49, 'BK-25072018-CSF-0049', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', '2018-07-25', '42124', '2018-07-28', '412', '41524', '2018-07-25 04:57:12', '2018-07-25 04:57:12'),
(177, 49, 'BK-25072018-CSF-0049', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '4100', '1.01', NULL, '00XXX', '0', '2018-07-25', '42124', '2018-07-28', '412', '414', '2018-07-25 04:57:12', '2018-07-25 04:57:12'),
(178, 49, 'BK-25072018-CSF-0050', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '21231', '2018-07-28', '1241', '454', '2018-07-25 05:01:51', '2018-07-25 05:01:51'),
(179, 49, 'BK-25072018-CSF-0050', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '21231', '2018-07-28', '1241', '454', '2018-07-25 05:01:51', '2018-07-25 05:01:51'),
(180, 49, 'BK-25072018-CSF-0050', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', '2018-07-25', '21231', '2018-07-28', '1241', '454', '2018-07-25 05:01:51', '2018-07-25 05:01:51'),
(181, 49, 'BK-25072018-CSF-0050', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', '21231', '2018-07-28', '1241', '1452', '2018-07-25 05:01:51', '2018-07-25 05:01:51'),
(182, 49, 'BK-25072018-CSF-0051', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '415241', '2018-07-27', '4524', '1524', '2018-07-25 05:02:56', '2018-07-25 05:02:56'),
(183, 49, 'BK-25072018-CSF-0051', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '415241', '2018-07-27', '4524', '1524', '2018-07-25 05:02:56', '2018-07-25 05:02:56'),
(184, 49, 'BK-25072018-CSF-0051', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', '415241', '2018-07-27', '4524', '1452', '2018-07-25 05:02:56', '2018-07-25 05:02:56'),
(185, 49, 'BK-25072018-CSF-0052', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '415241', '2018-07-27', '4524', '1524', '2018-07-25 05:07:26', '2018-07-25 05:07:26'),
(186, 49, 'BK-25072018-CSF-0052', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '415241', '2018-07-27', '4524', '1524', '2018-07-25 05:07:26', '2018-07-25 05:07:26'),
(187, 49, 'BK-25072018-CSF-0052', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', '415241', '2018-07-27', '4524', '1452', '2018-07-25 05:07:26', '2018-07-25 05:07:26'),
(188, 49, 'BK-25072018-CSF-0053', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '21231', '2018-07-28', '1241', '454', '2018-07-25 05:07:31', '2018-07-25 05:07:31'),
(189, 49, 'BK-25072018-CSF-0053', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '21231', '2018-07-28', '1241', '454', '2018-07-25 05:07:31', '2018-07-25 05:07:31'),
(190, 49, 'BK-25072018-CSF-0053', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', '2018-07-25', '21231', '2018-07-28', '1241', '454', '2018-07-25 05:07:31', '2018-07-25 05:07:31'),
(191, 49, 'BK-25072018-CSF-0053', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', '21231', '2018-07-28', '1241', '1452', '2018-07-25 05:07:31', '2018-07-25 05:07:31'),
(192, 49, 'BK-25072018-CSF-0054', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '100', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-24', '1245', '2018-07-28', '1452', '145', '2018-07-25 05:09:35', '2018-07-25 05:09:35'),
(193, 49, 'BK-25072018-CSF-0054', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'DARK STEEL', '0', '100', '0.3', NULL, 'NAVY', '0', '2018-07-24', '1245', '2018-07-28', '1452', '145', '2018-07-25 05:09:35', '2018-07-25 05:09:35'),
(194, 49, 'BK-25072018-CSF-0055', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-24', '45', '2018-07-28', '4524', '41524', '2018-07-25 05:10:29', '2018-07-25 05:10:29'),
(195, 49, 'BK-25072018-CSF-0055', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'DARK STEEL', '0', '1000', '0.3', NULL, 'NAVY', '0', '2018-07-24', '45', '2018-07-28', '4524', '41524', '2018-07-25 05:10:29', '2018-07-25 05:10:29'),
(196, 49, 'BK-25072018-CD-0056', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '100', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-01', '152415', '2018-07-28', '45241', '54152', '2018-07-25 05:24:41', '2018-07-25 05:24:41'),
(197, 49, 'BK-25072018-CD-0056', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'DARK STEEL', '0', '100', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-01', '152415', '2018-07-28', '45241', '54152', '2018-07-25 05:24:41', '2018-07-25 05:24:41'),
(198, 49, 'BK-25072018-CD-0056', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '100', '1.01', NULL, '00XXX', '0', '2018-07-01', '152415', '2018-07-28', '45241', '4154', '2018-07-25 05:24:41', '2018-07-25 05:24:41'),
(199, 49, 'BK-25072018-CD-0056', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '100', '1.01', NULL, 'WWWWWWW', '0', '2018-07-01', '152415', '2018-07-28', '45241', '4154', '2018-07-25 05:24:41', '2018-07-25 05:24:41'),
(200, 49, 'BK-25072018-CD-0057', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '100', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', '15245', '2018-07-28', '452415', '1521', '2018-07-25 05:27:01', '2018-07-25 05:27:01'),
(201, 49, 'BK-25072018-CD-0057', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '100', '0.3', NULL, 'NAVY', '0', '2018-07-25', '15245', '2018-07-28', '452415', '1521', '2018-07-25 05:27:01', '2018-07-25 05:27:01'),
(202, 49, 'BK-25072018-CD-0057', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '100', '1.01', NULL, '00XXX', '0', '2018-07-25', '15245', '2018-07-28', '452415', '14524', '2018-07-25 05:27:01', '2018-07-25 05:27:01'),
(203, 49, 'BK-25072018-CD-0058', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-24', 'ghjnfg', '2018-07-28', 'gfhfg', '1524152', '2018-07-25 05:40:34', '2018-07-25 05:40:34'),
(204, 49, 'BK-25072018-CD-0058', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'DARK STEEL', '0', '1000', '0.3', NULL, 'NAVY', '0', '2018-07-24', 'ghjnfg', '2018-07-28', 'gfhfg', '1524152', '2018-07-25 05:40:34', '2018-07-25 05:40:34'),
(205, 49, 'BK-25072018-CD-0058', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-24', 'ghjnfg', '2018-07-28', 'gfhfg', '545', '2018-07-25 05:40:35', '2018-07-25 05:40:35'),
(206, 49, 'BK-25072018-CD-0059', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', 'fdgd', '2018-07-28', 'cvbgfc', '15245', '2018-07-25 05:41:39', '2018-07-25 05:41:39'),
(207, 49, 'BK-25072018-CD-0059', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'DARK STEEL', '0', '1000', '0.3', NULL, 'NAVY', '0', '2018-07-25', 'fdgd', '2018-07-28', 'cvbgfc', '15245', '2018-07-25 05:41:39', '2018-07-25 05:41:39'),
(208, 49, 'BK-25072018-CD-0059', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '1000', '.05', NULL, NULL, '0', '2018-07-25', 'fdgd', '2018-07-28', 'cvbgfc', '415', '2018-07-25 05:41:39', '2018-07-25 05:41:39'),
(209, 49, 'BK-25072018-CSF-0060', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '100', '0.002', NULL, NULL, '0', '2018-07-12', '52415', '2018-07-26', '4545', '111', '2018-07-25 06:37:18', '2018-07-25 06:37:18'),
(210, 49, 'BK-25072018-CSF-0060', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-12', '52415', '2018-07-26', '4545', '111', '2018-07-25 06:37:18', '2018-07-25 06:37:18'),
(211, 49, 'BK-25072018-CSF-0060', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-12', '52415', '2018-07-26', '4545', '111', '2018-07-25 06:37:18', '2018-07-25 06:37:18'),
(212, 49, 'BK-25072018-CSF-0060', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '200', '1.01', NULL, '00XXX', '0', '2018-07-12', '52415', '2018-07-26', '4545', '333', '2018-07-25 06:37:18', '2018-07-25 06:37:18'),
(213, 49, 'BK-25072018-CSF-0060', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '210', '1.01', NULL, 'WWWWWWW', '0', '2018-07-12', '52415', '2018-07-26', '4545', '333', '2018-07-25 06:37:18', '2018-07-25 06:37:18'),
(214, 49, 'BK-25072018-CD-0061', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '300', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-26', '52415', '2018-07-30', '1452', '5453', '2018-07-25 06:40:03', '2018-07-25 06:40:03'),
(215, 49, 'BK-25072018-CD-0061', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'DARK STEEL', '0', '310', '0.3', NULL, 'NAVY', '0', '2018-07-26', '52415', '2018-07-30', '1452', '5453', '2018-07-25 06:40:03', '2018-07-25 06:40:03'),
(216, 49, 'BK-25072018-CD-0061', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '250', '0.002', NULL, NULL, '0', '2018-07-26', '52415', '2018-07-30', '1452', '5454', '2018-07-25 06:40:03', '2018-07-25 06:40:03'),
(217, 49, 'BK-25072018-CD-0061', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '200', '0.002', NULL, NULL, '0', '2018-07-26', '52415', '2018-07-30', '1452', '656565', '2018-07-25 06:40:03', '2018-07-25 06:40:03'),
(218, 49, 'BK-25072018-CD-0061', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '300', '0.002', NULL, NULL, '0', '2018-07-26', '52415', '2018-07-30', '1452', '5453', '2018-07-25 06:40:03', '2018-07-25 06:40:03'),
(219, 49, 'BK-25072018-ACL-0062', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '100', '0.002', NULL, NULL, '0', '2018-07-26', '1245', '2018-07-31', '412', '100', '2018-07-25 06:46:31', '2018-07-25 06:46:31'),
(220, 49, 'BK-25072018-ACL-0062', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-26', '1245', '2018-07-31', '412', '100', '2018-07-25 06:46:31', '2018-07-25 06:46:31'),
(221, 49, 'BK-26072018-CSF-0063', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '41524', '2018-07-30', '2412', '1242', '2018-07-25 23:15:13', '2018-07-25 23:15:13'),
(222, 49, 'BK-26072018-CSF-0063', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', '2018-07-25', '41524', '2018-07-30', '2412', '454', '2018-07-25 23:15:13', '2018-07-25 23:15:13'),
(223, 49, 'BK-26072018-CSF-0063', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '41524', '2018-07-30', '2412', '1242', '2018-07-25 23:15:13', '2018-07-25 23:15:13'),
(224, 49, 'BK-26072018-CSF-0064', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-26', '241fgh', '2018-07-28', '15241', '15241', '2018-07-25 23:39:21', '2018-07-25 23:39:21'),
(225, 49, 'BK-26072018-CSF-0064', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', '2018-07-26', '241fgh', '2018-07-28', '15241', '15241', '2018-07-25 23:39:21', '2018-07-25 23:39:21'),
(226, 49, 'BK-26072018-CSF-0064', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-26', '241fgh', '2018-07-28', '15241', '15241', '2018-07-25 23:39:21', '2018-07-25 23:39:21'),
(227, 49, 'BK-26072018-CSF-0064', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '500', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-26', '241fgh', '2018-07-28', '15241', '1251', '2018-07-25 23:39:21', '2018-07-25 23:39:21');
INSERT INTO `mxp_booking` (`id`, `user_id`, `booking_order_id`, `erp_code`, `item_code`, `item_size`, `item_description`, `item_quantity`, `item_price`, `matarial`, `gmts_color`, `others_color`, `orderDate`, `orderNo`, `shipmentDate`, `poCatNo`, `sku`, `created_at`, `updated_at`) VALUES
(228, 49, 'BK-26072018-CSF-0065', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', '524', '2018-07-27', '54', '24', '2018-07-25 23:50:25', '2018-07-25 23:50:25'),
(229, 49, 'BK-26072018-CSF-0065', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'NAVY', '0', '2018-07-25', '524', '2018-07-27', '54', '555', '2018-07-25 23:50:25', '2018-07-25 23:50:25'),
(230, 49, 'BK-26072018-CSF-0065', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '524', '2018-07-27', '54', '54', '2018-07-25 23:50:25', '2018-07-25 23:50:25'),
(231, 49, 'BK-26072018-CSF-0066', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-26', '24152', '2018-07-26', '14241', '145', '2018-07-26 01:35:15', '2018-07-26 01:35:15'),
(232, 49, 'BK-26072018-CSF-0067', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '10000', '1.01', NULL, '00XXX', '0', '2018-07-26', '4524', '2018-07-19', '454', '41524', '2018-07-26 01:38:01', '2018-07-26 01:38:01'),
(233, 49, 'BK-26072018-CSF-0068', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-27', '1241', '2018-07-28', '45241', '14524', '2018-07-26 01:55:49', '2018-07-26 01:55:49'),
(234, 49, 'BK-26072018-CSF-0068', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', '2018-07-27', '1241', '2018-07-28', '45241', '14524', '2018-07-26 01:55:49', '2018-07-26 01:55:49'),
(235, 49, 'BK-26072018-CSF-0068', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-27', '1241', '2018-07-28', '45241', '14524', '2018-07-26 01:55:50', '2018-07-26 01:55:50'),
(236, 49, 'BK-26072018-CSF-0068', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '500', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-27', '1241', '2018-07-28', '45241', '145', '2018-07-26 01:55:50', '2018-07-26 01:55:50'),
(237, 49, 'BK-26072018-CSF-0068', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'DARK STEEL', '0', '500', '0.3', NULL, 'NAVY', '0', '2018-07-27', '1241', '2018-07-28', '45241', '4154', '2018-07-26 01:55:50', '2018-07-26 01:55:50'),
(238, 49, 'BK-26072018-CSF-0069', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-27', '4545', '2018-07-28', '4545', '45241', '2018-07-26 01:57:03', '2018-07-26 01:57:03'),
(239, 49, 'BK-26072018-CSF-0069', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', '2018-07-27', '4545', '2018-07-28', '4545', '45241', '2018-07-26 01:57:03', '2018-07-26 01:57:03'),
(240, 49, 'BK-26072018-CSF-0069', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '500', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-27', '4545', '2018-07-28', '4545', '415245', '2018-07-26 01:57:03', '2018-07-26 01:57:03'),
(241, 49, 'BK-26072018-CSF-0070', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '100', '0.002', NULL, NULL, '0', '2018-07-12', '52415', '2018-07-11', '4545', '415', '2018-07-26 02:10:19', '2018-07-26 02:10:19'),
(242, 49, 'BK-26072018-CSF-0070', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M', '2L.ML-TA.001', '110', '0.002', NULL, NULL, '0', '2018-07-12', '52415', '2018-07-11', '4545', '415', '2018-07-26 02:10:19', '2018-07-26 02:10:19'),
(243, 49, 'BK-26072018-CSF-0070', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '120', '0.002', NULL, NULL, '0', '2018-07-12', '52415', '2018-07-11', '4545', '415', '2018-07-26 02:10:19', '2018-07-26 02:10:19'),
(244, 49, 'BK-26072018-rga-0071', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '500', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '415', '2018-07-26 02:11:39', '2018-07-26 02:11:39'),
(245, 49, 'BK-26072018-rga-0071', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '500', '1.01', NULL, 'WWWWWWW', '0', NULL, NULL, '2018-07-27', NULL, '415', '2018-07-26 02:11:39', '2018-07-26 02:11:39'),
(246, 49, 'BK-26072018-rga-0071', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '200', '0.002', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '415', '2018-07-26 02:11:39', '2018-07-26 02:11:39'),
(247, 49, 'BK-26072018-CSF-0072', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '100', '1.01', NULL, '00XXX', '0', '2018-07-26', NULL, '2018-07-26', NULL, '150', '2018-07-26 02:18:51', '2018-07-26 02:18:51'),
(248, 49, 'BK-26072018-CSF-0072', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '110', '1.01', NULL, 'WWWWWWW', '0', '2018-07-26', NULL, '2018-07-26', NULL, '150', '2018-07-26 02:18:51', '2018-07-26 02:18:51'),
(249, 49, 'BK-26072018-CSF-0073', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '800', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-26', NULL, '222', '2018-07-26 02:20:14', '2018-07-26 02:20:14'),
(250, 49, 'BK-26072018-CSF-0073', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '500', '1.01', NULL, 'WWWWWWW', '0', NULL, NULL, '2018-07-26', NULL, '222', '2018-07-26 02:20:14', '2018-07-26 02:20:14'),
(251, 49, 'BK-26072018-CSF-0074', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-18', NULL, '4152', '2018-07-26 02:50:25', '2018-07-26 02:50:25'),
(252, 49, 'BK-26072018-CSF-0074', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-18', NULL, '45', '2018-07-26 02:50:25', '2018-07-26 02:50:25'),
(253, 49, 'BK-26072018-CSF-0074', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L KN 175/96', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-18', NULL, '4545', '2018-07-26 02:50:25', '2018-07-26 02:50:25'),
(254, 49, 'BK-26072018-CSF-0074', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-18', NULL, '454', '2018-07-26 02:50:25', '2018-07-26 02:50:25'),
(255, 49, 'BK-26072018-CSF-0075', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-19', NULL, '4545', '2018-07-26 02:51:44', '2018-07-26 02:51:44'),
(256, 49, 'BK-26072018-CSF-0075', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', NULL, NULL, '2018-07-19', NULL, '4545', '2018-07-26 02:51:44', '2018-07-26 02:51:44'),
(257, 49, 'BK-26072018-CSF-0075', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-19', NULL, '4524', '2018-07-26 02:51:44', '2018-07-26 02:51:44'),
(258, 49, 'BK-26072018-CSF-0075', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-19', NULL, '45241', '2018-07-26 02:51:44', '2018-07-26 02:51:44'),
(259, 49, 'BK-26072018-CSF-0075', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-19', NULL, '41524', '2018-07-26 02:51:44', '2018-07-26 02:51:44'),
(260, 49, 'BK-26072018-CSF-0076', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-19', NULL, '145', '2018-07-26 03:09:22', '2018-07-26 03:09:22'),
(261, 49, 'BK-26072018-CSF-0076', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', NULL, NULL, '2018-07-19', NULL, '145', '2018-07-26 03:09:22', '2018-07-26 03:09:22'),
(262, 49, 'BK-26072018-CSF-0077', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '15241', '2018-07-26 03:44:00', '2018-07-26 03:44:00'),
(263, 49, 'BK-26072018-CSF-0077', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '15241', '2018-07-26 03:44:00', '2018-07-26 03:44:00'),
(264, 49, 'BK-26072018-CSF-0077', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '500', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-28', NULL, '101', '2018-07-26 03:44:00', '2018-07-26 03:44:00'),
(265, 49, 'BK-26072018-CSF-0077', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-28', NULL, '1014', '2018-07-26 03:44:00', '2018-07-26 03:44:00'),
(266, 49, 'BK-26072018-CSF-0077', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-28', NULL, '451', '2018-07-26 03:44:00', '2018-07-26 03:44:00'),
(267, 49, 'BK-26072018-CSF-0078', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-28', NULL, '5445', '2018-07-26 03:45:13', '2018-07-26 03:45:13'),
(268, 49, 'BK-26072018-CSF-0078', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', NULL, NULL, '2018-07-28', NULL, '5445', '2018-07-26 03:45:13', '2018-07-26 03:45:13'),
(269, 49, 'BK-26072018-CSF-0078', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '1414', '2018-07-26 03:45:13', '2018-07-26 03:45:13'),
(270, 49, 'BK-26072018-CSF-0079', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '500', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-28', NULL, '14421', '2018-07-26 03:46:08', '2018-07-26 03:46:08'),
(271, 49, 'BK-26072018-CSF-0079', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L KN 175/96', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '1444412', '2018-07-26 03:46:08', '2018-07-26 03:46:08'),
(272, 49, 'BK-26072018-CSF-0079', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '4512421', '2018-07-26 03:46:08', '2018-07-26 03:46:08'),
(273, 49, 'BK-26072018-CSF-0080', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '4524', '2018-07-26 05:20:40', '2018-07-26 05:20:40'),
(274, 49, 'BK-26072018-CSF-0080', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', NULL, NULL, '2018-07-27', NULL, '4524', '2018-07-26 05:20:40', '2018-07-26 05:20:40'),
(275, 49, 'BK-26072018-CSF-0081', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-12', NULL, '545', '2018-07-26 05:23:38', '2018-07-26 05:23:38'),
(276, 49, 'BK-26072018-CSF-0081', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-12', NULL, '545', '2018-07-26 05:23:38', '2018-07-26 05:23:38'),
(277, 49, 'BK-26072018-CSF-0081', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L KN 175/96', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-12', NULL, '545', '2018-07-26 05:23:38', '2018-07-26 05:23:38'),
(278, 49, 'BK-26072018-CSF-0082', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-05', NULL, '452', '2018-07-26 05:49:11', '2018-07-26 05:49:11'),
(279, 49, 'BK-26072018-CSF-0082', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L KN 175/96', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-05', NULL, '452', '2018-07-26 05:49:11', '2018-07-26 05:49:11'),
(280, 49, 'BK-26072018-CSF-0082', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '500', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-05', NULL, '415241', '2018-07-26 05:49:11', '2018-07-26 05:49:11'),
(281, 49, 'BK-26072018-CSF-0083', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '4152', '2018-07-26 05:50:05', '2018-07-26 05:50:05'),
(282, 49, 'BK-26072018-CSF-0083', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L KN 175/96', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '4152', '2018-07-26 05:50:05', '2018-07-26 05:50:05'),
(283, 49, 'BK-26072018-CSF-0083', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '500', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-28', NULL, '1422', '2018-07-26 05:50:05', '2018-07-26 05:50:05'),
(284, 49, 'BK-27072018--0084', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '521', '2018-07-26 23:26:57', '2018-07-26 23:26:57'),
(285, 49, 'BK-27072018-CSF-0084', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '1000', '.08', NULL, NULL, '0', NULL, NULL, '2018-07-27', 'kjlj', '142', '2018-07-26 23:27:45', '2018-07-26 23:27:45'),
(286, 49, 'BK-27072018-CD-0085', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '1000', '.08', NULL, NULL, '0', NULL, NULL, '2018-07-20', '1421', '4124', '2018-07-26 23:28:10', '2018-07-26 23:28:10'),
(287, 49, 'BK-27072018-CD-0086', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '1521', '2018-07-27 00:15:45', '2018-07-27 00:15:45'),
(288, 49, 'BK-27072018-CD-0086', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, 'WWWWWWW', '0', NULL, NULL, '2018-07-27', NULL, '1521', '2018-07-27 00:15:45', '2018-07-27 00:15:45'),
(289, 49, 'BK-27072018-CD-0087', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-26', NULL, '15241', '2018-07-27 00:16:14', '2018-07-27 00:16:14'),
(290, 49, 'BK-27072018-CSF-0088', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '1000', '0.002', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '45', '2018-07-27 01:28:31', '2018-07-27 01:28:31'),
(291, 49, 'BK-27072018-CSF-0088', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU S CN 165/88A', '2L.ML-TA.001', '1000', '0.002', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '45', '2018-07-27 01:28:31', '2018-07-27 01:28:31'),
(292, 49, 'BK-27072018-CSF-0089', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '1214', '2018-07-27 02:47:51', '2018-07-27 02:47:51'),
(293, 49, 'BK-27072018-CSF-0089', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '141', '2018-07-27 02:47:51', '2018-07-27 02:47:51'),
(294, 49, 'BK-27072018-CSF-0089', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L KN 175/96', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '1452', '2018-07-27 02:47:51', '2018-07-27 02:47:51'),
(295, 49, 'BK-27072018-CSF-0090', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-27', NULL, '412', '2018-07-27 02:49:13', '2018-07-27 02:49:13'),
(296, 49, 'BK-27072018-CSF-0090', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'NAVY', '0', NULL, NULL, '2018-07-27', NULL, '412', '2018-07-27 02:49:13', '2018-07-27 02:49:13'),
(297, 49, 'BK-27072018-CSF-0090', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '245', '2018-07-27 02:49:13', '2018-07-27 02:49:13'),
(298, 49, 'BK-27072018-CSF-0090', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '2424', '2018-07-27 02:49:13', '2018-07-27 02:49:13'),
(299, 49, 'BK-27072018-CSF-0091', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'NAVY', '0', NULL, NULL, '2018-07-27', NULL, '2142', '2018-07-27 02:50:15', '2018-07-27 02:50:15'),
(300, 49, 'BK-27072018-CSF-0091', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '214', '2018-07-27 02:50:15', '2018-07-27 02:50:15'),
(301, 49, 'BK-27072018-CSF-0092', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '1000', '.08', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '4152', '2018-07-27 02:50:45', '2018-07-27 02:50:45'),
(302, 49, 'BK-27072018-CSF-0092', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M', 'aaa', '1000', '.08', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '4152', '2018-07-27 02:50:45', '2018-07-27 02:50:45'),
(303, 49, 'BK-27072018-CSF-0093', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-27', NULL, '412', '2018-07-27 02:57:43', '2018-07-27 02:57:43'),
(304, 49, 'BK-27072018-CSF-0093', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'NAVY', '0', NULL, NULL, '2018-07-27', NULL, '412', '2018-07-27 02:57:43', '2018-07-27 02:57:43'),
(305, 49, 'BK-27072018-CSF-0093', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '245', '2018-07-27 02:57:43', '2018-07-27 02:57:43'),
(306, 49, 'BK-27072018-CSF-0093', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '2424', '2018-07-27 02:57:43', '2018-07-27 02:57:43'),
(307, 49, 'BK-27072018-CSF-0094', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-27', NULL, '412', '2018-07-27 02:57:46', '2018-07-27 02:57:46'),
(308, 49, 'BK-27072018-CSF-0094', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'NAVY', '0', NULL, NULL, '2018-07-27', NULL, '412', '2018-07-27 02:57:46', '2018-07-27 02:57:46'),
(309, 49, 'BK-27072018-CSF-0094', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '245', '2018-07-27 02:57:46', '2018-07-27 02:57:46'),
(310, 49, 'BK-27072018-CSF-0094', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '2424', '2018-07-27 02:57:46', '2018-07-27 02:57:46'),
(311, 49, 'BK-27072018-CSF-0095', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-27', NULL, '1001', '2018-07-27 03:17:04', '2018-07-27 03:17:04'),
(312, 49, 'BK-27072018-CSF-0095', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'NAVY', '0', NULL, NULL, '2018-07-27', NULL, '1001', '2018-07-27 03:17:04', '2018-07-27 03:17:04'),
(313, 49, 'BK-27072018-CSF-0095', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '141', '2018-07-27 03:17:04', '2018-07-27 03:17:04'),
(314, 49, 'BK-27072018-CD-0096', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-28', NULL, '1212', '2018-07-27 03:33:56', '2018-07-27 03:33:56'),
(315, 49, 'BK-27072018-CD-0096', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-28', NULL, '11114124', '2018-07-27 03:33:56', '2018-07-27 03:33:56'),
(316, 49, 'BK-27072018-CD-0096', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'NAVY', '0', NULL, NULL, '2018-07-28', NULL, '142', '2018-07-27 03:33:56', '2018-07-27 03:33:56'),
(317, 49, 'BK-07082018-CSF-0097', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.1', NULL, '00XXX', '0', '2018-08-06', '41524', '2018-08-16', '4152415', '1000', '2018-08-07 00:31:13', '2018-08-07 00:31:13');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_bookingBuyer_details`
--

CREATE TABLE `mxp_bookingBuyer_details` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `booking_order_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Company_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `C_sort_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_part1_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_part2_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attention_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fax_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_part1_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_part2_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attention_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fax_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_complete` int(11) NOT NULL,
  `booking_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_bookingBuyer_details`
--

INSERT INTO `mxp_bookingBuyer_details` (`id`, `user_id`, `booking_order_id`, `Company_name`, `C_sort_name`, `buyer_name`, `address_part1_invoice`, `address_part2_invoice`, `attention_invoice`, `mobile_invoice`, `telephone_invoice`, `fax_invoice`, `address_part1_delivery`, `address_part2_delivery`, `attention_delivery`, `mobile_delivery`, `telephone_delivery`, `fax_delivery`, `is_complete`, `booking_status`, `created_at`, `updated_at`) VALUES
(1, 49, 'INVO-23062018-Mi-0001', 'Maxpro It', 'Mi', 'Ostin\'s', 'Section -1', 'Section-2', 'md Hanif', '01792828282', NULL, NULL, 'Section-1', 'Section-2', 'Md hanif', '01792828282', NULL, NULL, 0, NULL, '2018-06-23 06:18:01', '2018-06-23 06:18:01'),
(2, 49, 'INVO-23062018-CSF-0002', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-06-23 07:20:39', '2018-06-23 07:20:39'),
(3, 49, 'INVO-23062018-CSF-0003', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-06-23 07:24:55', '2018-06-23 07:24:55'),
(4, 49, 'INVO-25062018-CSF-0004', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-06-24 22:53:31', '2018-06-24 22:53:31'),
(5, 49, 'INVO-25062018-ACL-0005', 'ALPHA CLOTHING LTD', 'ACL', 'REGATTA', 'Section -1', 'Section- 2', 'aaaa', '01685-696806', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-06-24 22:57:41', '2018-06-24 22:57:41'),
(6, 49, 'INVO-05072018-Mi-0006', 'Maxpro It', 'Mi', 'Ostin\'s', 'Section -1', 'Section-2', 'md Hanif', '01792828282', NULL, NULL, 'Section-1', 'Section-2', 'Md hanif', '01792828282', NULL, NULL, 0, NULL, '2018-07-05 02:54:43', '2018-07-05 02:54:43'),
(7, 49, 'INVO-05072018-CSF-0007', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-05 03:29:46', '2018-07-05 03:29:46'),
(8, 49, 'INVO-05072018-CD-0008', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-05 06:03:07', '2018-07-05 06:03:07'),
(9, 49, 'INVO-05072018-CSF-0009', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-05 06:12:08', '2018-07-05 06:12:08'),
(10, 49, 'INVO-05072018-CSF-0010', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-05 06:13:53', '2018-07-05 06:13:53'),
(11, 49, 'INVO-05072018-CSF-0011', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-05 06:16:12', '2018-07-05 06:16:12'),
(12, 49, 'INVO-05072018-CSF-0012', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-05 06:17:54', '2018-07-05 06:17:54'),
(13, 49, 'INVO-06072018-CSF-0013', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-06 06:18:07', '2018-07-06 06:18:07'),
(14, 49, 'INVO-07072018-Mi-0014', 'Maxpro It', 'Mi', 'Ostin\'s', 'Section -1', 'Section-2', 'md Hanif', '01792828282', NULL, NULL, 'Section-1', 'Section-2', 'Md hanif', '01792828282', NULL, NULL, 0, NULL, '2018-07-06 22:23:46', '2018-07-06 22:23:46'),
(15, 49, 'INVO-07072018-CSF-0015', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-06 23:52:01', '2018-07-06 23:52:01'),
(16, 49, 'INVO-10072018-CSF-0016', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-10 01:42:59', '2018-07-10 01:42:59'),
(17, 49, 'INVO-10072018-CSF-0017', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-10 01:46:26', '2018-07-10 01:46:26'),
(18, 49, 'INVO-10072018-CSF-0018', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-10 01:46:42', '2018-07-10 01:46:42'),
(19, 49, 'INVO-10072018-CSF-0019', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-10 01:53:34', '2018-07-10 01:53:34'),
(20, 49, 'INVO-10072018-CSF-0020', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-10 01:55:34', '2018-07-10 01:55:34'),
(21, 49, 'INVO-11072018-CSF-0021', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-10 23:44:02', '2018-07-10 23:44:02'),
(24, 49, 'INVO-11072018-CSF-0001', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-11 06:54:40', '2018-07-11 06:54:40'),
(25, 49, 'INVO-11072018-ACL-0002', 'ALPHA CLOTHING LTD', 'ACL', 'REGATTA', 'Section -1', 'Section- 2', 'aaaa', '01685-696806', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-11 07:02:45', '2018-07-11 07:02:45'),
(26, 49, 'INVO-12072018-CSF-0003', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-11 23:18:32', '2018-07-11 23:18:32'),
(27, 49, 'INVO-12072018-CSF-0004', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-11 23:33:49', '2018-07-11 23:33:49'),
(28, 49, 'INVO-12072018-CSF-0005', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-12 00:00:12', '2018-07-12 00:00:12'),
(29, 49, 'INVO-12072018-CSF-0006', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-12 00:31:06', '2018-07-12 00:31:06'),
(30, 49, 'INVO-12072018-CSF-0007', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-12 01:54:44', '2018-07-12 01:54:44'),
(31, 49, 'INVO-12072018-CD-0008', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-12 03:03:49', '2018-07-12 03:03:49'),
(32, 49, 'INVO-12072018-CSF-0009', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-12 06:09:12', '2018-07-12 06:09:12'),
(33, 49, 'INVO-13072018-CD-0010', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-13 00:31:12', '2018-07-13 00:31:12'),
(34, 49, 'INVO-13072018-CSF-0011', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-13 03:32:49', '2018-07-13 03:32:49'),
(35, 49, 'INVO-13072018-CSF-0012', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-13 05:42:09', '2018-07-13 05:42:09'),
(36, 49, 'INVO-13072018-CSF-0013', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-13 06:49:39', '2018-07-13 06:49:39'),
(37, 49, 'INVO-13072018-CSF-0035', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-13 08:58:29', '2018-07-13 08:58:29'),
(38, 49, 'INVO-13072018-CSF-0036', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-13 09:10:36', '2018-07-13 09:10:36'),
(39, 49, 'BK-13072018-CSF-0037', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-13 09:56:27', '2018-07-13 09:56:27'),
(40, 49, 'BK-24072018-abc-0038', 'abc', 'abc', 'aaa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-24 00:39:25', '2018-07-24 00:39:25'),
(41, 49, 'BK-24072018-CSF-0039', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-24 01:54:18', '2018-07-24 01:54:18'),
(42, 49, 'BK-24072018-CSF-0040', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-24 01:55:06', '2018-07-24 01:55:06'),
(43, 49, 'BK-24072018-CSF-0041', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-24 01:55:52', '2018-07-24 01:55:52'),
(44, 49, 'BK-24072018-CSF-0042', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-24 01:57:16', '2018-07-24 01:57:16'),
(45, 49, 'BK-24072018-CD-0043', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-24 01:59:01', '2018-07-24 01:59:01'),
(46, 49, 'BK-24072018-CD-0044', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-24 02:03:15', '2018-07-24 02:03:15'),
(47, 49, 'BK-24072018-CSF-0045', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-24 02:05:28', '2018-07-24 02:05:28'),
(48, 49, 'BK-24072018-CD-0046', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-24 02:29:26', '2018-07-24 02:29:26'),
(49, 49, 'BK-24072018-rga-0047', 'maximumregada', 'rga', 'abc', 'mirpur', 'dhaka', 'abced', '123466', '2345678', NULL, 'village: kalikabari danggapara, Union : Boro Chondipur (5), Post :Havra', 'dhakaq', NULL, '1234567', '2345678', NULL, 0, NULL, '2018-07-24 04:11:03', '2018-07-24 04:11:03'),
(50, 49, 'BK-25072018-CSF-0048', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 04:55:34', '2018-07-25 04:55:34'),
(51, 49, 'BK-25072018-CSF-0049', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 04:57:12', '2018-07-25 04:57:12'),
(52, 49, 'BK-25072018-CSF-0050', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 05:01:51', '2018-07-25 05:01:51'),
(53, 49, 'BK-25072018-CSF-0051', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 05:02:56', '2018-07-25 05:02:56'),
(54, 49, 'BK-25072018-CSF-0052', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 05:07:26', '2018-07-25 05:07:26'),
(55, 49, 'BK-25072018-CSF-0053', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 05:07:31', '2018-07-25 05:07:31'),
(56, 49, 'BK-25072018-CSF-0054', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 05:09:35', '2018-07-25 05:09:35'),
(57, 49, 'BK-25072018-CSF-0055', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 05:10:29', '2018-07-25 05:10:29'),
(58, 49, 'BK-25072018-CD-0056', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 05:24:41', '2018-07-25 05:24:41'),
(59, 49, 'BK-25072018-CD-0057', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 05:27:01', '2018-07-25 05:27:01'),
(60, 49, 'BK-25072018-CD-0058', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 05:40:34', '2018-07-25 05:40:34'),
(61, 49, 'BK-25072018-CD-0059', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 05:41:39', '2018-07-25 05:41:39'),
(62, 49, 'BK-25072018-CSF-0060', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 06:37:18', '2018-07-25 06:37:18'),
(63, 49, 'BK-25072018-CD-0061', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 06:40:03', '2018-07-25 06:40:03'),
(64, 49, 'BK-25072018-ACL-0062', 'ALPHA CLOTHING LTD', 'ACL', 'REGATTA', 'Section -1', 'Section- 2', 'aaaa', '01685-696806', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 06:46:31', '2018-07-25 06:46:31'),
(65, 49, 'BK-26072018-CSF-0063', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 23:15:13', '2018-07-25 23:15:13'),
(66, 49, 'BK-26072018-CSF-0064', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 23:39:21', '2018-07-25 23:39:21'),
(67, 49, 'BK-26072018-CSF-0065', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-25 23:50:25', '2018-07-25 23:50:25'),
(68, 49, 'BK-26072018-CSF-0066', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 01:35:15', '2018-07-26 01:35:15'),
(69, 49, 'BK-26072018-CSF-0067', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 01:38:01', '2018-07-26 01:38:01'),
(70, 49, 'BK-26072018-CSF-0068', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 01:55:49', '2018-07-26 01:55:49'),
(71, 49, 'BK-26072018-CSF-0069', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 01:57:03', '2018-07-26 01:57:03'),
(72, 49, 'BK-26072018-CSF-0070', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 02:10:19', '2018-07-26 02:10:19'),
(73, 49, 'BK-26072018-rga-0071', 'maximumregada', 'rga', 'abc', 'mirpur', 'dhaka', 'abced', '123466', '2345678', NULL, 'village: kalikabari danggapara, Union : Boro Chondipur (5), Post :Havra', 'dhakaq', NULL, '1234567', '2345678', NULL, 0, NULL, '2018-07-26 02:11:39', '2018-07-26 02:11:39'),
(74, 49, 'BK-26072018-CSF-0072', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 02:18:51', '2018-07-26 02:18:51'),
(75, 49, 'BK-26072018-CSF-0073', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 02:20:14', '2018-07-26 02:20:14'),
(76, 49, 'BK-26072018-CSF-0074', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 02:50:25', '2018-07-26 02:50:25'),
(77, 49, 'BK-26072018-CSF-0075', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 02:51:44', '2018-07-26 02:51:44'),
(78, 49, 'BK-26072018-CSF-0076', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 03:09:22', '2018-07-26 03:09:22'),
(79, 49, 'BK-26072018-CSF-0077', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 03:44:00', '2018-07-26 03:44:00'),
(80, 49, 'BK-26072018-CSF-0078', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 03:45:13', '2018-07-26 03:45:13'),
(81, 49, 'BK-26072018-CSF-0079', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 03:46:08', '2018-07-26 03:46:08'),
(82, 49, 'BK-26072018-CSF-0080', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 05:20:40', '2018-07-26 05:20:40'),
(83, 49, 'BK-26072018-CSF-0081', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 05:23:38', '2018-07-26 05:23:38'),
(84, 49, 'BK-26072018-CSF-0082', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 05:49:11', '2018-07-26 05:49:11'),
(85, 49, 'BK-26072018-CSF-0083', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 05:50:05', '2018-07-26 05:50:05'),
(86, 49, 'BK-27072018-CSF-0084', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 23:27:45', '2018-07-26 23:27:45'),
(87, 49, 'BK-27072018-CD-0085', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-26 23:28:10', '2018-07-26 23:28:10'),
(88, 49, 'BK-27072018-CD-0086', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-27 00:15:45', '2018-07-27 00:15:45'),
(89, 49, 'BK-27072018-CD-0087', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-27 00:16:14', '2018-07-27 00:16:14'),
(90, 49, 'BK-27072018-CSF-0088', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-27 01:28:31', '2018-07-27 01:28:31'),
(91, 49, 'BK-27072018-CSF-0089', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-27 02:47:51', '2018-07-27 02:47:51'),
(92, 49, 'BK-27072018-CSF-0090', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-27 02:49:13', '2018-07-27 02:49:13'),
(93, 49, 'BK-27072018-CSF-0091', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-27 02:50:15', '2018-07-27 02:50:15'),
(94, 49, 'BK-27072018-CSF-0092', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-27 02:50:45', '2018-07-27 02:50:45'),
(95, 49, 'BK-27072018-CSF-0093', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-27 02:57:43', '2018-07-27 02:57:43'),
(96, 49, 'BK-27072018-CSF-0094', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-27 02:57:46', '2018-07-27 02:57:46'),
(97, 49, 'BK-27072018-CSF-0095', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-27 03:17:04', '2018-07-27 03:17:04'),
(98, 49, 'BK-27072018-CD-0096', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2018-07-27 03:33:56', '2018-07-27 03:33:56'),
(99, 49, 'BK-07082018-CSF-0097', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'Booked', '2018-08-07 00:31:13', '2018-08-07 00:31:13'),
(100, 49, 'BK-07082018-CSF-0098', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'Booked', '2018-08-07 02:31:31', '2018-08-07 02:31:31');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_booking_challan`
--

CREATE TABLE `mxp_booking_challan` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `booking_order_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `matarial` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gmts_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `others_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderDate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderNo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipmentDate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `poCatNo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `mrf_quantity` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_booking_challan`
--

INSERT INTO `mxp_booking_challan` (`id`, `user_id`, `booking_order_id`, `erp_code`, `item_code`, `item_size`, `item_description`, `item_quantity`, `item_price`, `matarial`, `gmts_color`, `others_color`, `orderDate`, `orderNo`, `shipmentDate`, `poCatNo`, `sku`, `created_at`, `updated_at`, `mrf_quantity`) VALUES
(1, 49, 'INVO-23062018-Mi-0001', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-06-23 06:18:01', '2018-06-23 06:51:09', NULL),
(2, 49, 'INVO-23062018-Mi-0001', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,DARK STEEL', '0', '0,0', '0.3', NULL, 'SEAL GREY,SEAL GREY', 'CORD COLOR', NULL, NULL, NULL, NULL, '', '2018-06-23 06:18:01', '2018-06-23 06:51:09', NULL),
(3, 49, 'INVO-23062018-CSF-0002', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A,EU XS CN 160/84A', '2L.ML-TA.001', '0,0,0,0', '0.002', NULL, NULL, '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:20:39', '2018-06-23 07:21:55', NULL),
(4, 49, 'INVO-23062018-CSF-0002', '22322', 'CSO04369 - REGETTA GREAT', '4XL,5XL,m', '0', '0,0,0', '0.6', NULL, 'DARK KHAKI,DARK KHAKI,DARK KHAKI', '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:20:40', '2018-06-23 07:21:32', NULL),
(5, 49, 'INVO-23062018-CSF-0003', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU L CN 175/96A', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:24:55', '2018-06-23 07:25:26', NULL),
(6, 49, 'INVO-23062018-CSF-0003', '22322', 'CSO04369 - REGETTA GREAT', '4XL,5XL', '0', '0,0', '0.6', NULL, 'NAVY,NAVY', '0', '2018-06-23', '111111', '2018-06-28', '12', '', '2018-06-23 07:24:56', '2018-06-24 22:48:55', NULL),
(7, 49, 'INVO-25062018-CSF-0004', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', '2018-06-19', '111111', '2018-06-27', '111111', '', '2018-06-24 22:53:31', '2018-06-24 22:54:41', NULL),
(8, 49, 'INVO-25062018-ACL-0005', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF M CN 170/92M,EF L CN 175/96A,EF S CN 165/88A', 'aaa', '1212,-10,-1', '.08', NULL, NULL, '0', '2018-06-28', '111111', '2018-06-27', '111111', '', '2018-06-24 22:57:41', '2018-07-09 02:48:25', NULL),
(9, 49, 'INVO-25062018-ACL-0005', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '0,0,0', '0.002', NULL, NULL, '0', '2018-06-28', '111111', '2018-06-27', '111111', '', '2018-06-24 22:57:42', '2018-07-09 02:46:41', NULL),
(10, 49, 'INVO-05072018-Mi-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '120,130,140', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 02:54:44', '2018-07-05 02:54:44', NULL),
(11, 49, 'INVO-05072018-CSF-0007', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '-68', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 03:29:47', '2018-07-05 06:01:34', NULL),
(12, 49, 'INVO-05072018-CSF-0007', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '-77', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 03:29:47', '2018-07-05 06:01:34', NULL),
(13, 49, 'INVO-05072018-CD-0008', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '-110,-50', '.08', NULL, NULL, '0', '2018-07-05', '1', '2018-07-05', '12', '', '2018-07-05 06:03:07', '2018-07-09 02:43:31', NULL),
(14, 49, 'INVO-05072018-CD-0008', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', '2018-07-05', '1', '2018-07-05', '12', '', '2018-07-05 06:03:07', '2018-07-09 02:38:38', NULL),
(15, 49, 'INVO-05072018-CSF-0009', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '90,0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:12:08', '2018-07-05 06:12:46', NULL),
(16, 49, 'INVO-05072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:12:08', '2018-07-05 06:12:46', NULL),
(17, 49, 'INVO-05072018-CSF-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '90,0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:13:54', '2018-07-05 06:14:32', NULL),
(18, 49, 'INVO-05072018-CSF-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:13:54', '2018-07-05 06:14:32', NULL),
(19, 49, 'INVO-05072018-CSF-0011', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M,EU M CN 170/92M', '2L.ML-TA.001', '0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:16:12', '2018-07-09 02:44:22', NULL),
(20, 49, 'INVO-05072018-CSF-0012', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '90,0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:17:55', '2018-07-05 06:18:27', NULL),
(21, 49, 'INVO-05072018-CSF-0012', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-05 06:17:55', '2018-07-05 06:18:27', NULL),
(22, 49, 'INVO-06072018-CSF-0013', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '90,90,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-06 06:18:08', '2018-07-06 06:19:35', NULL),
(23, 49, 'INVO-07072018-Mi-0014', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '0,0', '.08', NULL, NULL, '0', '2018-07-11', '01', '2018-07-25', '111', '', '2018-07-06 22:23:46', '2018-07-09 02:28:39', NULL),
(24, 49, 'INVO-07072018-Mi-0014', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', '2018-07-11', '01', '2018-07-25', '111', '', '2018-07-06 22:23:46', '2018-07-09 02:28:39', NULL),
(25, 49, 'INVO-07072018-CSF-0015', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '-400', '.08', NULL, NULL, '0', '2018-07-07', '008', '2018-07-24', '7655434', '', '2018-07-06 23:52:02', '2018-07-09 02:21:47', NULL),
(26, 49, 'INVO-07072018-CSF-0015', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '-300,0', '0.08', NULL, NULL, '0', '2018-07-07', '008', '2018-07-24', '7655434', '', '2018-07-06 23:52:02', '2018-07-09 02:21:47', NULL),
(27, 49, 'INVO-10072018-CSF-0016', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '111', '.08', NULL, NULL, 'others_color', NULL, NULL, NULL, NULL, '', '2018-07-10 01:43:00', '2018-07-10 01:43:00', NULL),
(28, 49, 'INVO-10072018-CSF-0017', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '2333', '.08', NULL, NULL, 'others_color', NULL, NULL, NULL, NULL, '', '2018-07-10 01:46:27', '2018-07-10 01:46:27', NULL),
(29, 49, 'INVO-10072018-CSF-0018', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '2333', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-10 01:46:42', '2018-07-10 01:46:42', NULL),
(30, 49, 'INVO-10072018-CSF-0019', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '12', '.08', NULL, NULL, 'aaaaa', NULL, NULL, NULL, NULL, '', '2018-07-10 01:53:34', '2018-07-10 01:53:34', NULL),
(31, 49, 'INVO-10072018-CSF-0020', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, '', '2018-07-10 01:55:34', '2018-07-10 06:54:22', NULL),
(32, 49, 'INVO-11072018-CSF-0021', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A,EU XS CN 160/84A', '2L.ML-TA.001', '110,120,130,140', '0.002', NULL, NULL, '0', '2018-07-19', '12', '2018-07-25', '121', '', '2018-07-10 23:44:02', '2018-07-10 23:44:02', NULL),
(37, 49, 'INVO-11072018-CSF-0001', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '220,230', '.08', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 06:54:41', '2018-07-11 06:54:41', NULL),
(38, 49, 'INVO-11072018-CSF-0001', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,0', '2L.ML-TA.001', '110,120,130', '0.002', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 06:54:41', '2018-07-11 06:54:41', NULL),
(39, 49, 'INVO-11072018-ACL-0002', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A,EU XS CN 160/84A', '2L.ML-TA.001', '1233,0,0,0', '0.002', NULL, NULL, '0', '2018-07-11', '111111', '2018-07-25', '12', '', '2018-07-11 07:02:46', '2018-07-11 23:01:09', '1,1,1,1'),
(40, 49, 'INVO-12072018-CSF-0003', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '110,120,130', '0.002', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-11 23:18:32', '2018-07-11 23:18:32', NULL),
(41, 49, 'INVO-12072018-CSF-0004', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', 'aaa', '202,209,216', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-11 23:33:50', '2018-07-12 01:47:36', '1,1,1'),
(42, 49, 'INVO-12072018-CSF-0004', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '0,0,0', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-11 23:33:50', '2018-07-12 01:46:53', '0,0,0'),
(43, 49, 'INVO-12072018-CSF-0005', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU M CN 170/92M,EU L CN 175/96A,EU XS CN 160/84A', '2L.ML-TA.001', '0,-21,-32,-1201,-1201,-1201,-1190,-1190,-1190', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-12 00:00:12', '2018-07-12 02:52:55', '1222,1222,1222,1201,1201,1201,1190,1190,1190'),
(44, 49, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '73,69,65', '0.002', NULL, NULL, '0', '2018-07-12', '12', '2018-07-26', '111111', '', '2018-07-12 00:31:06', '2018-07-12 06:01:01', '1,2,3'),
(45, 49, 'INVO-12072018-CSF-0007', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '0,0', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-19', '111111', '', '2018-07-12 01:54:45', '2018-07-12 02:02:51', '0,0'),
(46, 49, 'INVO-12072018-CSF-0007', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '0,0,0', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-19', '111111', '', '2018-07-12 01:54:45', '2018-07-12 01:58:14', '0,0,0'),
(47, 49, 'INVO-12072018-CD-0008', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '0,0,0', '0.002', NULL, NULL, '0', '2018-07-12', NULL, NULL, NULL, '', '2018-07-12 03:03:50', '2018-07-12 04:50:52', '1229,1225,1225'),
(48, 49, 'INVO-12072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '110,110,110', '0.002', NULL, NULL, '0', NULL, NULL, '2018-07-25', NULL, '', '2018-07-12 06:09:12', '2018-07-12 06:09:54', '10,20,30'),
(49, 49, 'INVO-13072018-CD-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', 'aaa', '200,206,98', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-26', '111111', '', '2018-07-13 00:31:13', '2018-07-13 03:30:32', '18,16,23'),
(50, 49, 'INVO-13072018-CD-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '0,0,0', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-26', '111111', '', '2018-07-13 00:31:13', '2018-07-13 03:19:58', '232,110,132'),
(51, 49, 'INVO-13072018-CSF-0011', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', 'aaa', '205,211,217', '.08', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-13 03:32:49', '2018-07-13 06:29:23', '4,7,10'),
(52, 49, 'INVO-13072018-CSF-0011', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '97,104,111', '0.002', NULL, NULL, '0', '2018-07-26', '111111', '2018-07-25', '111111', '', '2018-07-13 03:32:49', '2018-07-13 06:27:09', '9,11,13'),
(53, 49, 'INVO-13072018-CSF-0012', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '98', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-13 05:42:09', '2018-07-13 05:57:16', '22'),
(54, 49, 'INVO-13072018-CSF-0012', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '77,104,112', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-25', '111111', '', '2018-07-13 05:42:09', '2018-07-13 05:57:16', '33,16,18'),
(55, 49, 'INVO-13072018-CSF-0013', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', 'aaa', '209,218,227', '.08', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-24', '99', '', '2018-07-13 06:49:40', '2018-07-13 06:50:32', '1,2,3'),
(56, 49, 'INVO-13072018-CSF-0013', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '106,115,124', '0.002', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-24', '99', '', '2018-07-13 06:49:40', '2018-07-13 06:50:32', '4,5,6'),
(57, 49, 'INVO-13072018-CSF-0035', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', 'aaa', '206,214,222', '.08', NULL, NULL, '0', '2018-07-18', '111111', '2018-07-25', '12', '', '2018-07-13 08:58:30', '2018-07-13 09:00:43', '4,6,8'),
(58, 49, 'INVO-13072018-CSF-0035', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '94,99,111', '0.002', NULL, NULL, '0', '2018-07-18', '111111', '2018-07-25', '12', '', '2018-07-13 08:58:30', '2018-07-13 09:02:59', '16,21,19'),
(59, 49, 'INVO-13072018-CSF-0036', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '80,80,80', '0.002', NULL, NULL, '0', '2018-07-18', '8888', '2018-07-17', '99', '', '2018-07-13 09:10:36', '2018-07-13 09:31:50', NULL),
(60, 49, 'BK-13072018-CSF-0037', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A,EF L CN 175/96A3', 'nai', '990,1610', '.05', NULL, NULL, '0', NULL, '34343', '2018-07-31', '343434', 'fddf', '2018-07-13 09:56:27', '2018-07-19 04:18:23', '133,210'),
(61, 49, 'BK-13072018-CSF-0037', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '767', '0.3', NULL, 'DARK KHAKI', '0', NULL, '34343', '2018-07-31', '343434', 'fddf', '2018-07-13 09:56:27', '2018-07-19 04:18:23', '43'),
(62, 49, 'BK-24072018-CSF-0039', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '1000,1200', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:54:18', '2018-07-24 01:54:18', NULL),
(63, 49, 'BK-24072018-CSF-0040', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '1000,1200', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:55:06', '2018-07-24 01:55:06', NULL),
(64, 49, 'BK-24072018-CSF-0041', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '1000,1200', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:55:52', '2018-07-24 01:55:52', NULL),
(65, 49, 'BK-24072018-CSF-0042', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '1000,1200', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-24', '14254', '2018-07-26', '1425', '14524', '2018-07-24 01:57:16', '2018-07-24 01:57:16', NULL),
(66, 49, 'BK-24072018-CSF-0042', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '500', '.05', NULL, NULL, '0', '2018-07-24', '14254', '2018-07-26', '1425', '145245', '2018-07-24 01:57:16', '2018-07-24 01:57:16', NULL),
(67, 49, 'BK-24072018-CD-0043', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '1000,1200', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-24', '1221', '2018-07-27', '1424', '1412', '2018-07-24 01:59:01', '2018-07-24 01:59:01', NULL),
(68, 49, 'BK-24072018-CD-0043', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '1400', '.05', NULL, NULL, '0', '2018-07-24', '1221', '2018-07-27', '1424', '12452', '2018-07-24 01:59:01', '2018-07-24 01:59:01', NULL),
(69, 49, 'BK-24072018-CD-0044', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '0,0', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-24', '121', '2018-07-26', '121', '1242', '2018-07-24 02:03:15', '2018-07-25 03:00:05', NULL),
(70, 49, 'BK-24072018-CD-0044', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '0', '.05', NULL, NULL, '0', '2018-07-24', '121', '2018-07-26', '121', '1424', '2018-07-24 02:03:15', '2018-07-25 03:00:05', NULL),
(71, 49, 'BK-24072018-CSF-0045', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '500', '.08', NULL, NULL, '0', '2018-07-24', '4514', '2018-07-27', '415241', '2141', '2018-07-24 02:05:28', '2018-07-24 02:05:28', NULL),
(72, 49, 'BK-24072018-CD-0046', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '0,0', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-24', '41254', '2018-07-26', '454', '101', '2018-07-24 02:29:26', '2018-07-25 03:00:05', NULL),
(73, 49, 'BK-24072018-CD-0046', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '0', '.05', NULL, NULL, '0', '2018-07-24', '41254', '2018-07-26', '454', '415', '2018-07-24 02:29:26', '2018-07-25 04:19:19', NULL),
(74, 49, 'BK-24072018-rga-0047', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '640,490', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-11', '454', '2018-07-10', '1254', '12541', '2018-07-24 04:11:04', '2018-07-25 04:45:27', NULL),
(75, 49, 'BK-24072018-rga-0047', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '390', '.05', NULL, NULL, '0', '2018-07-11', '454', '2018-07-10', '1254', '1441', '2018-07-24 04:11:04', '2018-07-25 04:45:28', NULL),
(76, 49, 'BK-25072018-CSF-0048', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW,WWWW', 'sadsads', '1000,1000', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-25', '52415', '2018-07-27', '4545', '245', '2018-07-25 04:55:34', '2018-07-25 04:55:34', NULL),
(77, 49, 'BK-25072018-CSF-0048', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,DARK STEEL', '0', '1000,100', '0.3', NULL, 'DARK KHAKI,BLACK (BLACK BACKING)', '0', '2018-07-25', '52415', '2018-07-27', '4545', '1244', '2018-07-25 04:55:34', '2018-07-25 04:55:34', NULL),
(78, 49, 'BK-25072018-CSF-0049', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW,WWWW', 'sadsads', '1000,4100', '1.01', NULL, 'WWWWWWW,00XXX', '0', '2018-07-25', '42124', '2018-07-28', '412', '41524', '2018-07-25 04:57:12', '2018-07-25 04:57:12', NULL),
(79, 49, 'BK-25072018-CSF-0049', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '100', '.05', NULL, NULL, '0', '2018-07-25', '42124', '2018-07-28', '412', '414', '2018-07-25 04:57:12', '2018-07-25 04:57:12', NULL),
(80, 49, 'BK-25072018-CSF-0050', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW,WWWW', 'sadsads', '1000,1000,1000', '1.01', NULL, '00XXX,00XXX,WWWWWWW', '0', '2018-07-25', '21231', '2018-07-28', '1241', '454', '2018-07-25 05:01:51', '2018-07-25 05:01:51', NULL),
(81, 49, 'BK-25072018-CSF-0050', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', '21231', '2018-07-28', '1241', '1452', '2018-07-25 05:01:51', '2018-07-25 05:01:51', NULL),
(82, 49, 'BK-25072018-CSF-0051', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '1000,1000', '1.01', NULL, '00XXX,00XXX', '0', '2018-07-25', '415241', '2018-07-27', '4524', '1524', '2018-07-25 05:02:56', '2018-07-25 05:02:56', NULL),
(83, 49, 'BK-25072018-CSF-0051', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', '415241', '2018-07-27', '4524', '1452', '2018-07-25 05:02:56', '2018-07-25 05:02:56', NULL),
(84, 49, 'BK-25072018-CSF-0052', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '1000,1000', '1.01', NULL, '00XXX,00XXX', '0', '2018-07-25', '415241', '2018-07-27', '4524', '1524', '2018-07-25 05:07:26', '2018-07-25 05:07:26', NULL),
(85, 49, 'BK-25072018-CSF-0052', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', '415241', '2018-07-27', '4524', '1452', '2018-07-25 05:07:26', '2018-07-25 05:07:26', NULL),
(86, 49, 'BK-25072018-CSF-0053', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW,WWWW', 'sadsads', '1000,1000,1000', '1.01', NULL, '00XXX,00XXX,WWWWWWW', '0', '2018-07-25', '21231', '2018-07-28', '1241', '454', '2018-07-25 05:07:31', '2018-07-25 05:07:31', NULL),
(87, 49, 'BK-25072018-CSF-0053', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '1000', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-25', '21231', '2018-07-28', '1241', '1452', '2018-07-25 05:07:31', '2018-07-25 05:07:31', NULL),
(88, 49, 'BK-25072018-CSF-0054', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,DARK STEEL', '0', '0,0', '0.3', NULL, 'DARK KHAKI,NAVY', '0', '2018-07-24', '1245', '2018-07-28', '1452', '145', '2018-07-25 05:09:35', '2018-07-25 05:11:30', NULL),
(89, 49, 'BK-25072018-CSF-0055', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,DARK STEEL', '0', '0,0', '0.3', NULL, 'DARK KHAKI,NAVY', '0', '2018-07-24', '45', '2018-07-28', '4524', '41524', '2018-07-25 05:10:29', '2018-07-25 05:22:09', NULL),
(90, 49, 'BK-25072018-CD-0056', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '0,100,50,100,0,100,50,100,0,100,50,100,0,100,50,100', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-01', '152415', '2018-07-28', '45241', '4154', '2018-07-25 05:24:41', '2018-07-25 05:29:49', NULL),
(91, 49, 'BK-25072018-CD-0056', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,DARK STEEL', '0', '0,100,50,100,0,100,50,100,0,100,50,100,0,100,50,100', '0.3', NULL, 'DARK KHAKI,DARK KHAKI', '0', '2018-07-01', '152415', '2018-07-28', '45241', '54152', '2018-07-25 05:24:41', '2018-07-25 05:29:49', NULL),
(92, 49, 'BK-25072018-CD-0057', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '50', '1.01', NULL, '00XXX', '0', '2018-07-25', '15245', '2018-07-28', '452415', '14524', '2018-07-25 05:27:01', '2018-07-25 05:29:49', NULL),
(93, 49, 'BK-25072018-CD-0057', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', '0', '50,100,50,100,50,100,50,100,50,100,50,100,50,100,50,100', '0.3', NULL, 'DARK KHAKI,NAVY', '0', '2018-07-25', '15245', '2018-07-28', '452415', '1521', '2018-07-25 05:27:01', '2018-07-25 05:29:49', NULL),
(94, 49, 'BK-25072018-CD-0058', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '480', '1.01', NULL, '00XXX', '0', '2018-07-24', 'ghjnfg', '2018-07-28', 'gfhfg', '545', '2018-07-25 05:40:35', '2018-07-25 05:57:13', NULL),
(95, 49, 'BK-25072018-CD-0058', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,DARK STEEL', '0', '0,0', '0.3', NULL, 'DARK KHAKI,NAVY', '0', '2018-07-24', 'ghjnfg', '2018-07-28', 'gfhfg', '1524152', '2018-07-25 05:40:35', '2018-07-25 05:44:36', NULL),
(96, 49, 'BK-25072018-CD-0059', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '480', '.05', NULL, NULL, '0', '2018-07-25', 'fdgd', '2018-07-28', 'cvbgfc', '415', '2018-07-25 05:41:39', '2018-07-25 05:57:14', NULL),
(97, 49, 'BK-25072018-CD-0059', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,DARK STEEL', '0', '960,960', '0.3', NULL, 'DARK KHAKI,NAVY', '0', '2018-07-25', 'fdgd', '2018-07-28', 'cvbgfc', '15245', '2018-07-25 05:41:39', '2018-07-25 05:57:13', NULL),
(98, 49, 'BK-25072018-CSF-0060', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '180,190', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-12', '52415', '2018-07-26', '4545', '333', '2018-07-25 06:37:18', '2018-07-25 06:43:37', NULL),
(99, 49, 'BK-25072018-CSF-0060', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '90,98,106', '0.002', NULL, NULL, '0', '2018-07-12', '52415', '2018-07-26', '4545', '111', '2018-07-25 06:37:18', '2018-07-25 06:43:37', NULL),
(100, 49, 'BK-25072018-CD-0061', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '50,200,300,250,200,300,100,200,300,150,200,300,250,200,300,100,200,300,130,200,300,250,200,300,100,200,300,100,200,300,250,200,300,100,200,300,150,200,300,250,200,300,100,200,300,130,200,300,250,200,300,100,200,300,0,200,300,250,200,300,100,200,300,150,20', '0.002', NULL, NULL, '0', '2018-07-26', '52415', '2018-07-30', '1452', '5454', '2018-07-25 06:40:03', '2018-07-25 07:21:56', NULL),
(101, 49, 'BK-25072018-CD-0061', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,DARK STEEL', '0', '150,150', '0.3', NULL, 'DARK KHAKI,NAVY', '0', '2018-07-26', '52415', '2018-07-30', '1452', '5453', '2018-07-25 06:40:03', '2018-07-25 07:21:57', NULL),
(102, 49, 'BK-25072018-ACL-0062', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '100,120,100,120,100,120,100,120,100,120,100,120,100,120,100,120', '0.002', NULL, NULL, '0', '2018-07-26', '1245', '2018-07-31', '412', '100', '2018-07-25 06:46:31', '2018-07-25 07:21:56', NULL),
(103, 49, 'BK-26072018-CSF-0063', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,SSS,WWWW', 'sadsads', '800,1000,1000,900,900,1000', '1.01', NULL, '00XXX,WWWWWWW,00XXX', '0', '2018-07-25', '41524', '2018-07-30', '2412', '1242', '2018-07-25 23:15:13', '2018-07-26 00:02:42', NULL),
(104, 49, 'BK-26072018-CSF-0064', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW,WWWW', 'sadsads', '1000,1000,1000', '1.01', NULL, '00XXX,WWWWWWW,00XXX', '0', '2018-07-26', '241fgh', '2018-07-28', '15241', '15241', '2018-07-25 23:39:21', '2018-07-25 23:39:21', NULL),
(105, 49, 'BK-26072018-CSF-0064', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '500', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-26', '241fgh', '2018-07-28', '15241', '1251', '2018-07-25 23:39:21', '2018-07-25 23:39:21', NULL),
(106, 49, 'BK-26072018-CSF-0065', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-25', '524', '2018-07-27', '54', '54', '2018-07-25 23:50:25', '2018-07-25 23:50:25', NULL),
(107, 49, 'BK-26072018-CSF-0065', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', '0', '900,900', '0.3', NULL, 'DARK KHAKI,NAVY', '0', '2018-07-25', '524', '2018-07-27', '54', '24', '2018-07-25 23:50:25', '2018-07-26 00:02:42', NULL),
(108, 49, 'BK-26072018-CSF-0066', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', '2018-07-26', '24152', '2018-07-26', '14241', '145', '2018-07-26 01:35:15', '2018-07-26 01:35:15', NULL),
(109, 49, 'BK-26072018-CSF-0067', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '3', '1.01', NULL, '00XXX', '0', '2018-07-26', '4524', '2018-07-19', '454', '41524', '2018-07-26 01:38:01', '2018-07-26 01:53:31', NULL),
(110, 49, 'BK-26072018-CSF-0068', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,SSS,WWWW', 'sadsads', '0,0,450', '1.01', NULL, '00XXX,WWWWWWW,00XXX', '0', '2018-07-27', '1241', '2018-07-28', '45241', '14524', '2018-07-26 01:55:50', '2018-07-26 02:06:41', NULL),
(111, 49, 'BK-26072018-CSF-0068', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,DARK STEEL', '0', '0,180', '0.3', NULL, 'DARK KHAKI,NAVY', '0', '2018-07-27', '1241', '2018-07-28', '45241', '145', '2018-07-26 01:55:50', '2018-07-26 02:06:41', NULL),
(112, 49, 'BK-26072018-CSF-0069', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,SSS', 'sadsads', '900,900', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-27', '4545', '2018-07-28', '4545', '45241', '2018-07-26 01:57:03', '2018-07-26 02:06:41', NULL),
(113, 49, 'BK-26072018-CSF-0069', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '450', '0.3', NULL, 'DARK KHAKI', '0', '2018-07-27', '4545', '2018-07-28', '4545', '415245', '2018-07-26 01:57:03', '2018-07-26 02:06:41', NULL),
(114, 49, 'BK-26072018-CSF-0070', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '0,60,60', '0.002', NULL, NULL, '0', '2018-07-12', '52415', '2018-07-11', '4545', '415', '2018-07-26 02:10:19', '2018-07-26 02:40:38', NULL),
(115, 49, 'BK-26072018-rga-0071', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '250,250', '1.01', NULL, '00XXX,WWWWWWW', '0', NULL, NULL, '2018-07-27', NULL, '415', '2018-07-26 02:11:39', '2018-07-26 02:40:38', NULL),
(116, 49, 'BK-26072018-rga-0071', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A', '2L.ML-TA.001', '150', '0.002', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '415', '2018-07-26 02:11:39', '2018-07-26 02:40:38', NULL),
(117, 49, 'BK-26072018-CSF-0072', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW,SSS', 'sadsads', '0,0', '1.01', NULL, '00XXX,WWWWWWW', '0', '2018-07-26', NULL, '2018-07-26', NULL, '150', '2018-07-26 02:18:51', '2018-07-26 02:21:42', NULL),
(118, 49, 'BK-26072018-CSF-0073', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW,SSS', 'sadsads', '300,200', '1.01', NULL, '00XXX,WWWWWWW', '0', NULL, NULL, '2018-07-26', NULL, '222', '2018-07-26 02:20:14', '2018-07-26 02:24:28', NULL),
(119, 49, 'BK-26072018-CSF-0074', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '0', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-18', NULL, '454', '2018-07-26 02:50:25', '2018-07-26 02:52:28', NULL),
(120, 49, 'BK-26072018-CSF-0074', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3,EG L CN 175/96A,EG L KN 175/96', 'nai', '0,0,500', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-18', NULL, '4152', '2018-07-26 02:50:25', '2018-07-26 02:52:29', NULL),
(121, 49, 'BK-26072018-CSF-0075', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,SSS', 'sadsads', '500,1000', '1.01', NULL, 'WWWWWWW,00XXX', '0', NULL, NULL, '2018-07-19', NULL, '4545', '2018-07-26 02:51:44', '2018-07-26 02:52:28', NULL),
(122, 49, 'BK-26072018-CSF-0075', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3,EG L CN 175/96A', 'nai', '1000,1000', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-19', NULL, '4524', '2018-07-26 02:51:44', '2018-07-26 02:51:44', NULL),
(123, 49, 'BK-26072018-CSF-0075', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '500', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-19', NULL, '41524', '2018-07-26 02:51:45', '2018-07-26 02:52:29', NULL),
(124, 49, 'BK-26072018-CSF-0076', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '0,75', '1.01', NULL, '00XXX,WWWWWWW', '0', NULL, NULL, '2018-07-19', NULL, '145', '2018-07-26 03:09:22', '2018-07-26 05:07:40', NULL),
(125, 49, 'BK-26072018-CSF-0077', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '0,100', '1.01', NULL, '00XXX,00XXX', '0', NULL, NULL, '2018-07-28', NULL, '1014', '2018-07-26 03:44:00', '2018-07-26 05:07:40', NULL),
(126, 49, 'BK-26072018-CSF-0077', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3,EG L CN 175/96A', 'nai', '0,0', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '15241', '2018-07-26 03:44:00', '2018-07-26 04:12:20', NULL),
(127, 49, 'BK-26072018-CSF-0077', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '0', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-28', NULL, '101', '2018-07-26 03:44:00', '2018-07-26 04:12:20', NULL),
(128, 49, 'BK-26072018-CSF-0078', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,SSS', 'sadsads', '75,110', '1.01', NULL, '00XXX,WWWWWWW', '0', NULL, NULL, '2018-07-28', NULL, '5445', '2018-07-26 03:45:13', '2018-07-26 05:07:40', NULL),
(129, 49, 'BK-26072018-CSF-0078', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3', 'nai', '200', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '1414', '2018-07-26 03:45:13', '2018-07-26 05:07:40', NULL),
(130, 49, 'BK-26072018-CSF-0079', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L KN 175/96,EG L CN 175/96A', 'nai', '70,200', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '1444412', '2018-07-26 03:46:08', '2018-07-26 05:07:40', NULL),
(131, 49, 'BK-26072018-CSF-0079', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '100', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-28', NULL, '14421', '2018-07-26 03:46:08', '2018-07-26 05:07:40', NULL),
(132, 49, 'BK-26072018-CSF-0080', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '960,960', '1.01', NULL, '00XXX,WWWWWWW', '0', NULL, NULL, '2018-07-27', NULL, '4524', '2018-07-26 05:20:41', '2018-07-26 05:22:35', NULL),
(133, 49, 'BK-26072018-CSF-0081', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3,EG L CN 175/96A,EG L KN 175/96', 'nai', '0,0,0', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-12', NULL, '545', '2018-07-26 05:23:38', '2018-07-27 00:58:29', NULL),
(134, 49, 'BK-26072018-CSF-0082', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3,EG L KN 175/96', 'nai', '0,0', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-05', NULL, '452', '2018-07-26 05:49:11', '2018-07-27 00:58:29', NULL),
(135, 49, 'BK-26072018-CSF-0082', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '0', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-05', NULL, '415241', '2018-07-26 05:49:11', '2018-07-26 05:50:47', NULL),
(136, 49, 'BK-26072018-CSF-0083', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A,EG L KN 175/96', 'nai', '0,0', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '4152', '2018-07-26 05:50:05', '2018-07-27 00:58:29', NULL),
(137, 49, 'BK-26072018-CSF-0083', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '0', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-28', NULL, '1422', '2018-07-26 05:50:05', '2018-07-27 00:58:29', NULL),
(138, 49, 'BK-27072018--0084', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '521', '2018-07-26 23:26:57', '2018-07-26 23:26:57', NULL),
(139, 49, 'BK-27072018-CSF-0084', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '0', '.08', NULL, NULL, '0', NULL, NULL, '2018-07-27', 'kjlj', '142', '2018-07-26 23:27:45', '2018-07-29 00:19:49', NULL),
(140, 49, 'BK-27072018-CD-0085', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', 'aaa', '900', '.08', NULL, NULL, '0', NULL, NULL, '2018-07-20', '1421', '4124', '2018-07-26 23:28:10', '2018-07-27 00:01:22', NULL),
(141, 49, 'BK-27072018-CD-0086', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS,WWWW', 'sadsads', '0,0', '1.01', NULL, '00XXX,WWWWWWW', '0', NULL, NULL, '2018-07-27', NULL, '1521', '2018-07-27 00:15:45', '2018-07-27 00:41:41', NULL),
(142, 49, 'BK-27072018-CD-0087', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'WWWW', 'sadsads', '0', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-26', NULL, '15241', '2018-07-27 00:16:14', '2018-07-27 00:41:41', NULL),
(143, 49, 'BK-27072018-CSF-0088', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU S CN 165/88A', '2L.ML-TA.001', '900,0', '0.002', NULL, NULL, '0', NULL, NULL, '2018-07-28', NULL, '45', '2018-07-27 01:28:31', '2018-07-27 01:37:46', NULL),
(144, 49, 'BK-27072018-CSF-0089', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '0', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '1214', '2018-07-27 02:47:51', '2018-07-27 03:32:45', NULL),
(145, 49, 'BK-27072018-CSF-0089', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EF L CN 175/96A3,EG L KN 175/96', 'nai', '0,0', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '141', '2018-07-27 02:47:51', '2018-07-27 03:32:45', NULL),
(146, 49, 'BK-27072018-CSF-0090', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '0', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '245', '2018-07-27 02:49:13', '2018-07-27 02:59:32', NULL),
(147, 49, 'BK-27072018-CSF-0090', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '0', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '2424', '2018-07-27 02:49:13', '2018-07-27 03:32:44', NULL),
(148, 49, 'BK-27072018-CSF-0090', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', '0', '0,0', '0.3', NULL, 'DARK KHAKI,NAVY', '0', NULL, NULL, '2018-07-27', NULL, '412', '2018-07-27 02:49:13', '2018-07-27 03:32:45', NULL),
(149, 49, 'BK-27072018-CSF-0091', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '0', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '214', '2018-07-27 02:50:15', '2018-07-27 02:59:32', NULL),
(150, 49, 'BK-27072018-CSF-0091', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '0', '0.3', NULL, 'NAVY', '0', NULL, NULL, '2018-07-27', NULL, '2142', '2018-07-27 02:50:15', '2018-07-27 02:59:32', NULL),
(151, 49, 'BK-27072018-CSF-0092', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '0,0', '.08', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '4152', '2018-07-27 02:50:45', '2018-07-27 03:32:44', NULL),
(152, 49, 'BK-27072018-CSF-0093', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '0', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '245', '2018-07-27 02:57:43', '2018-07-30 07:06:42', '1000'),
(153, 49, 'BK-27072018-CSF-0093', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '0', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '2424', '2018-07-27 02:57:43', '2018-07-30 07:06:42', '1000'),
(154, 49, 'BK-27072018-CSF-0093', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', '0', '0', '0.3', NULL, 'DARK KHAKI,NAVY', '0', NULL, NULL, '2018-07-27', NULL, '412', '2018-07-27 02:57:43', '2018-07-30 07:06:42', '1000'),
(155, 49, 'BK-27072018-CSF-0094', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '0', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '245', '2018-07-27 02:57:46', '2018-07-30 07:07:01', '1000'),
(156, 49, 'BK-27072018-CSF-0094', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', 'nai', '0', '.05', NULL, NULL, '0', NULL, NULL, '2018-07-27', NULL, '2424', '2018-07-27 02:57:46', '2018-07-30 07:07:01', '1000'),
(157, 49, 'BK-27072018-CSF-0094', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', '0', '0', '0.3', NULL, 'DARK KHAKI,NAVY', '0', NULL, NULL, '2018-07-27', NULL, '412', '2018-07-27 02:57:46', '2018-07-30 07:07:01', '1000'),
(158, 49, 'BK-27072018-CSF-0095', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '0', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-27', NULL, '141', '2018-07-27 03:17:04', '2018-07-27 03:31:16', NULL),
(159, 49, 'BK-27072018-CSF-0095', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', '0', '0,0', '0.3', NULL, 'DARK KHAKI,NAVY', '0', NULL, NULL, '2018-07-27', NULL, '1001', '2018-07-27 03:17:04', '2018-07-27 03:31:17', NULL),
(160, 49, 'BK-27072018-CD-0096', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '0', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-28', NULL, '1212', '2018-07-27 03:33:56', '2018-08-07 00:26:36', '800'),
(161, 49, 'BK-27072018-CD-0096', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', '0', '0', '0.3', NULL, 'DARK KHAKI,NAVY', '0', NULL, NULL, '2018-07-28', NULL, '11114124', '2018-07-27 03:33:56', '2018-08-07 00:26:36', '800'),
(162, 49, 'BK-07082018-CSF-0097', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '491', '1.1', NULL, '00XXX', '0', '2018-08-06', '41524', '2018-08-16', '4152415', '1000', '2018-08-07 00:31:13', '2018-08-07 02:32:37', '509');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_booking_multiplechallan`
--

CREATE TABLE `mxp_booking_multiplechallan` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `challan_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `booking_order_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `matarial` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gmts_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `others_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderDate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderNo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipmentDate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `poCatNo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_booking_multiplechallan`
--

INSERT INTO `mxp_booking_multiplechallan` (`id`, `user_id`, `challan_id`, `booking_order_id`, `erp_code`, `item_code`, `item_size`, `item_description`, `item_quantity`, `item_price`, `matarial`, `gmts_color`, `others_color`, `orderDate`, `orderNo`, `shipmentDate`, `poCatNo`, `status`, `created_at`, `updated_at`) VALUES
(1, 49, 'M-CHA-11072018-CSF-0001', 'INVO-05072018-CSF-0009', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '79,0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:28:00', '2018-07-11 05:28:00'),
(2, 49, 'M-CHA-11072018-CSF-0001', 'INVO-05072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:28:00', '2018-07-11 05:28:00'),
(3, 49, 'M-CHA-11072018-CSF-0003', 'INVO-05072018-CSF-0009', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '68,0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:29:27', '2018-07-11 05:29:27'),
(4, 49, 'M-CHA-11072018-CSF-0003', 'INVO-05072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:29:27', '2018-07-11 05:29:27'),
(5, 49, 'M-CHA-11072018-CSF-0005', 'INVO-05072018-CSF-0009', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '57,0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:29:43', '2018-07-11 05:29:43'),
(6, 49, 'M-CHA-11072018-CSF-0005', 'INVO-05072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:29:44', '2018-07-11 05:29:44'),
(7, 49, 'M-CHA-11072018-CSF-0007', 'INVO-05072018-CSF-0009', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '46,0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:30:56', '2018-07-11 05:30:56'),
(8, 49, 'M-CHA-11072018-CSF-0007', 'INVO-05072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:30:56', '2018-07-11 05:30:56'),
(9, 49, 'M-CHA-11072018-CSF-0009', 'INVO-05072018-CSF-0009', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '35,0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:31:16', '2018-07-11 05:31:16'),
(10, 49, 'M-CHA-11072018-CSF-0009', 'INVO-05072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:31:16', '2018-07-11 05:31:16'),
(11, 49, 'M-CHA-11072018-CSF-0011', 'INVO-05072018-CSF-0009', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '34,0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:31:33', '2018-07-11 05:31:33'),
(12, 49, 'M-CHA-11072018-CSF-0011', 'INVO-05072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:31:33', '2018-07-11 05:31:33'),
(13, 49, 'M-CHA-11072018-CSF-0013', 'INVO-05072018-CSF-0009', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '33,0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:32:00', '2018-07-11 05:32:00'),
(14, 49, 'M-CHA-11072018-CSF-0013', 'INVO-05072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:32:00', '2018-07-11 05:32:00'),
(15, 49, 'M-CHA-11072018-CSF-0015', 'INVO-05072018-CSF-0009', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '0,0', '.08', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:32:10', '2018-07-11 05:32:10'),
(16, 49, 'M-CHA-11072018-CSF-0015', 'INVO-05072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M', '2L.ML-TA.001', '0,0', '0.002', NULL, NULL, '0', NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:32:10', '2018-07-11 05:32:10');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_brand`
--

CREATE TABLE `mxp_brand` (
  `brand_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `brand_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_brand`
--

INSERT INTO `mxp_brand` (`brand_id`, `user_id`, `brand_name`, `action`, `status`, `created_at`, `updated_at`) VALUES
(1, 49, 'dhamaka', 'update', '1', '2018-04-17 00:15:44', '2018-07-10 02:06:35'),
(2, 49, 'abc', 'update', '0', '2018-04-17 01:31:00', '2018-07-10 02:06:39'),
(3, 49, 'apex', 'create', '1', '2018-04-17 02:24:38', '2018-04-17 02:24:38'),
(4, 49, 'branda', 'create', '1', '2018-07-06 23:18:03', '2018-07-06 23:18:03'),
(5, 49, 'abc', 'create', '1', '2018-07-13 00:12:31', '2018-07-13 00:12:31'),
(6, 49, 'abcd', 'create', '1', '2018-07-13 00:12:45', '2018-07-13 00:12:45'),
(7, 49, 'kamrul', 'create', '1', '2018-07-13 10:00:23', '2018-07-13 10:00:23');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_challan`
--

CREATE TABLE `mxp_challan` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bill_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `oss` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `style` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `party_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_buyer` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attention_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `count_challan` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
(16, 42, 'New Company 2', 'description', 'Bangladesh', '1234567', 1, '2018-02-09 02:09:04', '2018-02-09 02:09:04'),
(17, 49, '1st Company', 'rgfdegfwe', 'xsdsds', '01792755683', 1, '2018-05-03 02:39:47', '2018-05-19 01:19:23'),
(18, 49, 'S Companuyq', 'sfg sfds sdf s', 'sdvgdf dfg dfg dfg', '1234567890', 1, '2018-05-10 00:06:27', '2018-05-10 00:06:27');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_gmts_color`
--

CREATE TABLE `mxp_gmts_color` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `action` int(6) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_gmts_color`
--

INSERT INTO `mxp_gmts_color` (`id`, `user_id`, `item_code`, `color_name`, `status`, `created_at`, `updated_at`, `action`) VALUES
(3, 49, 'CSO04369 - REGETTA GREAT', 'SEAL GREY', '1', '2018-06-06 01:48:42', '2018-07-10 02:10:14', 0),
(7, 49, 'CSO04369 - REGETTA GREAT', 'NAVY', '1', '2018-06-06 02:37:43', '2018-07-10 02:11:00', 0),
(11, 49, 'CSO04369 - REGETTA GREAT', 'DARK KHAKI', 'create', '2018-06-08 01:55:14', '2018-06-08 01:55:14', 1),
(12, 49, 'CSO04369 - REGETTA GREAT', 'BLACK (BLACK BACKING)', 'create', '2018-06-08 01:55:50', '2018-06-08 01:55:50', 1),
(13, 49, 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'SEAL GREY', 'update', '2018-06-08 02:03:52', '2018-06-08 02:04:02', 1),
(14, 49, 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'NAVY', 'create', '2018-06-08 02:04:16', '2018-06-08 02:04:16', 1),
(15, 49, 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'DARK KHAKI', 'create', '2018-06-08 02:04:29', '2018-06-08 02:04:29', 1),
(16, 49, 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'BLACK (BLACK BACKING)', 'create', '2018-06-08 02:04:37', '2018-06-08 02:04:37', 1),
(17, 49, '5250', 'gren', 'create', '2018-06-13 02:06:04', '2018-06-13 02:06:04', 1),
(19, 49, 'ASAASD', 'BlueBlue', '1', '2018-07-12 02:08:09', '2018-07-13 05:39:30', 0),
(20, 49, '', 'Grey', '1', '2018-07-12 02:13:24', '2018-07-12 02:13:24', 0),
(21, 49, NULL, 'Color Ajax', '1', '2018-07-13 02:38:13', '2018-08-07 02:30:39', 0),
(22, 49, NULL, 'MMMMM', '1', '2018-07-13 02:46:42', '2018-07-13 08:49:38', 0),
(23, 49, NULL, 'qweqwe', '1', '2018-07-13 02:47:11', '2018-07-13 02:47:11', 0),
(24, 49, NULL, 'New Color', '1', '2018-07-13 03:02:36', '2018-07-13 03:02:36', 0),
(25, 49, NULL, '00XXX', '1', '2018-07-13 03:13:49', '2018-07-13 05:45:29', 0),
(26, 49, 'aasdsa', '21', '1', '2018-07-13 03:36:13', '2018-07-13 03:36:13', 0),
(27, 49, 'aasdsa', '22', '1', '2018-07-13 03:36:13', '2018-07-13 03:36:13', 0),
(28, 49, 'saaS', 'Color Ajax', '1', '2018-07-13 03:46:29', '2018-07-13 03:46:29', 0),
(29, 49, 'saaS', 'qweqwe', '1', '2018-07-13 03:46:30', '2018-07-13 03:46:30', 0),
(33, 49, 'qqq', 'Color Ajax', '1', '2018-07-13 05:35:29', '2018-07-13 05:35:29', 0),
(37, 49, 'Ajax CoTest', 'Color Ajax', '1', '2018-07-13 05:38:44', '2018-07-13 05:38:44', 0),
(38, 49, 'Ajax CoTest', 'qweqwe', '1', '2018-07-13 05:38:45', '2018-07-13 05:38:45', 0),
(40, 49, 'last_check', 'New Color', '1', '2018-07-13 05:50:42', '2018-07-13 05:50:42', 0),
(41, 49, 'last_check', '00XXX', '1', '2018-07-13 05:50:42', '2018-07-13 05:50:42', 0),
(42, 49, NULL, 'added c', '1', '2018-07-13 05:50:55', '2018-07-13 05:50:55', 0),
(43, 49, NULL, 'WQWQWQWQWQW', '1', '2018-07-13 05:53:03', '2018-07-13 05:53:03', 0),
(52, 49, NULL, 'EEEE', '1', '2018-07-13 08:52:38', '2018-07-13 08:52:38', 0),
(55, 49, 'check', 'EEEE', '1', '2018-07-13 08:53:45', '2018-07-13 08:53:45', 0),
(56, 49, NULL, 'NAVY', '1', '2018-07-13 08:55:05', '2018-07-13 08:55:11', 0),
(57, 49, NULL, 'kamrul', '1', '2018-07-13 10:00:34', '2018-07-13 10:00:34', 0),
(58, 49, 'dfgd', 'Color Ajax', '1', '2018-07-13 10:01:02', '2018-07-13 10:01:02', 0),
(59, 49, 'dfgd', 'kamrul', '1', '2018-07-13 10:01:02', '2018-07-13 10:01:02', 0),
(60, 49, '2L.HT-CR.001', 'MMMMM', '1', '2018-07-27 03:49:55', '2018-07-27 03:49:55', 0),
(61, 49, '2L.HT-CR.001', '00XXX', '1', '2018-07-27 03:49:55', '2018-07-27 03:49:55', 0);

-- --------------------------------------------------------

--
-- Table structure for table `mxp_header`
--

CREATE TABLE `mxp_header` (
  `header_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `header_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `header_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `header_fontsize` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `header_fontstyle` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `header_colour` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo_allignment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address3` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cell_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attention` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_header`
--

INSERT INTO `mxp_header` (`header_id`, `user_id`, `header_type`, `header_title`, `header_fontsize`, `header_fontstyle`, `header_colour`, `logo`, `logo_allignment`, `address1`, `address2`, `address3`, `cell_number`, `attention`, `status`, `action`, `created_at`, `updated_at`) VALUES
(1, 49, '11', 'Maxim Label & packaging Bangladesh Pvt; Ltd', 'x-small', 'normal', 'blue', NULL, NULL, 'Mollik Tower, 11F', '13-14 Zoo Road Mirpur-1', 'Dhaka, Bangladesh', '0170000001', 'MS.Rita / Mr.Shovon', '', 'create', '2018-06-10 23:07:08', '2018-06-10 23:07:08'),
(2, 49, '12', 'Maxim Label & packaging Bangladesh Pvt; Ltd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 'create', '2018-06-22 23:33:41', '2018-06-22 23:33:41');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_ipo`
--

CREATE TABLE `mxp_ipo` (
  `id` int(10) UNSIGNED NOT NULL,
  `ipo_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `booking_order_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `initial_increase` int(11) NOT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `matarial` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gmts_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `others_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderDate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderNo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipmentDate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `poCatNo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_ipo`
--

INSERT INTO `mxp_ipo` (`id`, `ipo_id`, `user_id`, `booking_order_id`, `initial_increase`, `erp_code`, `item_code`, `item_size`, `item_description`, `item_quantity`, `item_price`, `matarial`, `gmts_color`, `others_color`, `orderDate`, `orderNo`, `shipmentDate`, `poCatNo`, `status`, `created_at`, `updated_at`) VALUES
(1, 'RGA12072018-ACL-02-54987', 49, 'INVO-12072018-CSF-0007', 3, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M', 'aaa', '210,220', '.08', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-19', '111111', 'create', '2018-07-12 01:56:26', '2018-07-12 01:56:26'),
(2, 'RGA12072018-ACL-02-54987', 49, 'INVO-12072018-CSF-0007', 3, '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '110,120,130', '0.002', NULL, NULL, '0', '2018-07-12', '111111', '2018-07-19', '111111', 'create', '2018-07-12 01:56:26', '2018-07-12 01:56:26'),
(3, 'RGA13072018-ACL-02-75367', 49, 'INVO-13072018-CSF-0035', 3, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', 'aaa', '210,220,230', '.08', NULL, NULL, '0', '2018-07-18', '111111', '2018-07-25', '12', 'create', '2018-07-13 08:59:23', '2018-07-13 08:59:23'),
(4, 'RGA13072018-ACL-02-75367', 49, 'INVO-13072018-CSF-0035', 3, '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '2L.ML-TA.001', '110,120,130', '0.002', NULL, NULL, '0', '2018-07-18', '111111', '2018-07-25', '12', 'create', '2018-07-13 08:59:23', '2018-07-13 08:59:23'),
(5, 'RGA13072018-ACL-02-25850', 49, 'BK-13072018-CSF-0037', 3, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A,EF L CN 175/96A3', 'nai', '1234,2000', '.05', NULL, NULL, '0', NULL, '34343', '2018-07-31', '343434', 'create', '2018-07-13 09:57:21', '2018-07-13 09:57:21'),
(6, 'RGA13072018-ACL-02-25850', 49, 'BK-13072018-CSF-0037', 3, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '0', '899', '0.3', NULL, 'DARK KHAKI', '0', NULL, '34343', '2018-07-31', '343434', 'create', '2018-07-13 09:57:21', '2018-07-13 09:57:21'),
(7, 'RGA29072018-ACL-02-66122', 49, 'BK-27072018-CD-0096', 0, '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-28', NULL, 'create', '2018-07-29 01:26:43', '2018-07-29 01:26:43'),
(8, 'RGA29072018-ACL-02-66122', 49, 'BK-27072018-CD-0096', 0, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', '0', '1000,1000', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-28', NULL, 'create', '2018-07-29 01:26:43', '2018-07-29 01:26:43'),
(9, 'RGA29072018-ACL-02-58528', 49, 'BK-27072018-CD-0096', 0, '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.01', NULL, '00XXX', '0', NULL, NULL, '2018-07-28', NULL, 'create', '2018-07-29 01:30:15', '2018-07-29 01:30:15'),
(10, 'RGA29072018-ACL-02-58528', 49, 'BK-27072018-CD-0096', 0, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', '0', '1000,1000', '0.3', NULL, 'DARK KHAKI', '0', NULL, NULL, '2018-07-28', NULL, 'create', '2018-07-29 01:30:15', '2018-07-29 01:30:15'),
(11, 'RGA07082018-ACL-02-91639', 49, 'BK-07082018-CSF-0097', 6, '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', 'sadsads', '1000', '1.1', NULL, '00XXX', '0', '2018-08-06', '41524', '2018-08-16', '4152415', 'create', '2018-08-07 02:31:03', '2018-08-07 02:31:09');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_items_details_by_booking_challan`
--

CREATE TABLE `mxp_items_details_by_booking_challan` (
  `items_details_id` int(10) UNSIGNED NOT NULL,
  `booking_challan_id` int(11) NOT NULL,
  `booking_order_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gmts_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_items_details_by_booking_challan`
--

INSERT INTO `mxp_items_details_by_booking_challan` (`items_details_id`, `booking_challan_id`, `booking_order_id`, `item_code`, `erp_code`, `item_size`, `item_quantity`, `gmts_color`, `created_at`, `updated_at`) VALUES
(1, 65, 'BK-24072018-CSF-0042', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '1000', '00XXX', '2018-07-24 01:57:16', '2018-07-24 01:57:16'),
(2, 65, 'BK-24072018-CSF-0042', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '1200', 'WWWWWWW', '2018-07-24 01:57:16', '2018-07-24 01:57:16'),
(3, 65, 'BK-24072018-CSF-0042', '2L.HT-CR.001', '21-OST2LHTCR001X-02', NULL, NULL, NULL, '2018-07-24 01:57:16', '2018-07-24 01:57:16'),
(4, 66, 'BK-24072018-CSF-0042', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '500', '', '2018-07-24 01:57:16', '2018-07-24 01:57:16'),
(5, 66, 'BK-24072018-CSF-0042', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', NULL, NULL, NULL, '2018-07-24 01:57:16', '2018-07-24 01:57:16'),
(6, 66, 'BK-24072018-CSF-0042', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', NULL, NULL, NULL, '2018-07-24 01:57:16', '2018-07-24 01:57:16'),
(7, 67, 'BK-24072018-CD-0043', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '1000', '00XXX', '2018-07-24 01:59:01', '2018-07-24 01:59:01'),
(8, 67, 'BK-24072018-CD-0043', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '1200', 'WWWWWWW', '2018-07-24 01:59:01', '2018-07-24 01:59:01'),
(9, 67, 'BK-24072018-CD-0043', '2L.HT-CR.001', '21-OST2LHTCR001X-02', NULL, NULL, NULL, '2018-07-24 01:59:01', '2018-07-24 01:59:01'),
(10, 68, 'BK-24072018-CD-0043', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '1400', '', '2018-07-24 01:59:01', '2018-07-24 01:59:01'),
(11, 68, 'BK-24072018-CD-0043', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', NULL, NULL, NULL, '2018-07-24 01:59:01', '2018-07-24 01:59:01'),
(12, 68, 'BK-24072018-CD-0043', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', NULL, NULL, NULL, '2018-07-24 01:59:01', '2018-07-24 01:59:01'),
(13, 69, 'BK-24072018-CD-0044', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-24 02:03:15', '2018-07-25 04:45:27'),
(14, 69, 'BK-24072018-CD-0044', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '0', 'WWWWWWW', '2018-07-24 02:03:15', '2018-07-25 04:45:27'),
(15, 70, 'BK-24072018-CD-0044', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '0', '', '2018-07-24 02:03:15', '2018-07-25 04:45:28'),
(16, 71, 'BK-24072018-CSF-0045', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF L CN 175/96A', '500', '', '2018-07-24 02:05:28', '2018-07-24 02:05:28'),
(17, 72, 'BK-24072018-CD-0046', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-24 02:29:26', '2018-07-25 04:45:27'),
(18, 72, 'BK-24072018-CD-0046', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '0', 'WWWWWWW', '2018-07-24 02:29:26', '2018-07-25 04:45:27'),
(19, 73, 'BK-24072018-CD-0046', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '800', '', '2018-07-24 02:29:26', '2018-07-26 01:15:58'),
(20, 74, 'BK-24072018-rga-0047', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '1000', '00XXX', '2018-07-24 04:11:04', '2018-07-26 01:15:58'),
(21, 74, 'BK-24072018-rga-0047', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '1000', 'WWWWWWW', '2018-07-24 04:11:04', '2018-07-26 01:15:58'),
(22, 75, 'BK-24072018-rga-0047', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '1000', '', '2018-07-24 04:11:04', '2018-07-26 01:15:58'),
(23, 76, 'BK-25072018-CSF-0048', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '1000', '00XXX', '2018-07-25 04:55:34', '2018-07-25 04:55:34'),
(24, 76, 'BK-25072018-CSF-0048', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '1000', 'WWWWWWW', '2018-07-25 04:55:34', '2018-07-25 04:55:34'),
(25, 77, 'BK-25072018-CSF-0048', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '1000', 'DARK KHAKI', '2018-07-25 04:55:34', '2018-07-25 04:55:34'),
(26, 77, 'BK-25072018-CSF-0048', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'DARK STEEL', '100', 'BLACK (BLACK BACKING)', '2018-07-25 04:55:34', '2018-07-25 04:55:34'),
(27, 78, 'BK-25072018-CSF-0049', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '1000', 'WWWWWWW', '2018-07-25 04:57:12', '2018-07-25 04:57:12'),
(28, 78, 'BK-25072018-CSF-0049', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '4100', '00XXX', '2018-07-25 04:57:12', '2018-07-25 04:57:12'),
(29, 79, 'BK-25072018-CSF-0049', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '100', '', '2018-07-25 04:57:12', '2018-07-25 04:57:12'),
(30, 80, 'BK-25072018-CSF-0050', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '1000', '00XXX', '2018-07-25 05:01:51', '2018-07-26 01:15:58'),
(31, 80, 'BK-25072018-CSF-0050', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '1000', '00XXX', '2018-07-25 05:01:51', '2018-07-26 01:15:58'),
(32, 80, 'BK-25072018-CSF-0050', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '1000', 'WWWWWWW', '2018-07-25 05:01:51', '2018-07-26 01:15:58'),
(33, 81, 'BK-25072018-CSF-0050', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '900', 'DARK KHAKI', '2018-07-25 05:01:52', '2018-07-26 01:15:58'),
(34, 82, 'BK-25072018-CSF-0051', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '900', '00XXX', '2018-07-25 05:02:56', '2018-07-26 01:15:58'),
(35, 82, 'BK-25072018-CSF-0051', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '900', '00XXX', '2018-07-25 05:02:56', '2018-07-26 01:15:58'),
(36, 83, 'BK-25072018-CSF-0051', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '1000', 'DARK KHAKI', '2018-07-25 05:02:56', '2018-07-25 05:02:56'),
(37, 84, 'BK-25072018-CSF-0052', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '1000', '00XXX', '2018-07-25 05:07:26', '2018-07-25 05:07:26'),
(38, 84, 'BK-25072018-CSF-0052', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '1000', '00XXX', '2018-07-25 05:07:26', '2018-07-25 05:07:26'),
(39, 85, 'BK-25072018-CSF-0052', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '1000', 'DARK KHAKI', '2018-07-25 05:07:26', '2018-07-25 05:07:26'),
(40, 86, 'BK-25072018-CSF-0053', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '1000', '00XXX', '2018-07-25 05:07:31', '2018-07-25 05:07:31'),
(41, 86, 'BK-25072018-CSF-0053', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '1000', '00XXX', '2018-07-25 05:07:31', '2018-07-25 05:07:31'),
(42, 86, 'BK-25072018-CSF-0053', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '1000', 'WWWWWWW', '2018-07-25 05:07:31', '2018-07-25 05:07:31'),
(43, 87, 'BK-25072018-CSF-0053', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '1000', 'DARK KHAKI', '2018-07-25 05:07:31', '2018-07-25 05:07:31'),
(44, 88, 'BK-25072018-CSF-0054', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-25 05:09:35', '2018-07-25 05:22:09'),
(45, 88, 'BK-25072018-CSF-0054', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'DARK STEEL', '0', 'NAVY', '2018-07-25 05:09:35', '2018-07-25 05:22:09'),
(46, 89, 'BK-25072018-CSF-0055', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-25 05:10:29', '2018-07-25 05:22:09'),
(47, 89, 'BK-25072018-CSF-0055', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'DARK STEEL', '0', 'NAVY', '2018-07-25 05:10:29', '2018-07-25 05:22:09'),
(48, 90, 'BK-25072018-CD-0056', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-25 05:24:41', '2018-07-25 05:29:49'),
(49, 90, 'BK-25072018-CD-0056', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '100', 'WWWWWWW', '2018-07-25 05:24:41', '2018-07-25 05:29:49'),
(50, 91, 'BK-25072018-CD-0056', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-25 05:24:41', '2018-07-25 05:29:49'),
(51, 91, 'BK-25072018-CD-0056', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'DARK STEEL', '100', 'DARK KHAKI', '2018-07-25 05:24:41', '2018-07-25 05:29:49'),
(52, 92, 'BK-25072018-CD-0057', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '50', '00XXX', '2018-07-25 05:27:01', '2018-07-25 05:29:49'),
(53, 93, 'BK-25072018-CD-0057', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '50', 'DARK KHAKI', '2018-07-25 05:27:01', '2018-07-25 05:29:49'),
(54, 93, 'BK-25072018-CD-0057', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '100', 'NAVY', '2018-07-25 05:27:01', '2018-07-25 05:29:49'),
(55, 94, 'BK-25072018-CD-0058', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '480', '00XXX', '2018-07-25 05:40:35', '2018-07-25 05:57:13'),
(56, 95, 'BK-25072018-CD-0058', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-25 05:40:35', '2018-07-25 05:57:13'),
(57, 95, 'BK-25072018-CD-0058', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'DARK STEEL', '0', 'NAVY', '2018-07-25 05:40:35', '2018-07-25 05:57:13'),
(58, 96, 'BK-25072018-CD-0059', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '480', '', '2018-07-25 05:41:39', '2018-07-25 05:57:14'),
(59, 97, 'BK-25072018-CD-0059', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '960', 'DARK KHAKI', '2018-07-25 05:41:39', '2018-07-25 05:57:14'),
(60, 97, 'BK-25072018-CD-0059', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'DARK STEEL', '960', 'NAVY', '2018-07-25 05:41:39', '2018-07-25 05:57:14'),
(61, 98, 'BK-25072018-CSF-0060', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '180', '00XXX', '2018-07-25 06:37:18', '2018-07-25 06:43:37'),
(62, 98, 'BK-25072018-CSF-0060', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '190', 'WWWWWWW', '2018-07-25 06:37:18', '2018-07-25 06:43:37'),
(63, 99, 'BK-25072018-CSF-0060', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '90', '', '2018-07-25 06:37:18', '2018-07-25 06:43:37'),
(64, 99, 'BK-25072018-CSF-0060', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '98', NULL, '2018-07-25 06:37:18', '2018-07-25 06:43:37'),
(65, 99, 'BK-25072018-CSF-0060', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '106', NULL, '2018-07-25 06:37:18', '2018-07-25 06:43:37'),
(66, 100, 'BK-25072018-CD-0061', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '50', '', '2018-07-25 06:40:03', '2018-07-25 07:21:56'),
(67, 100, 'BK-25072018-CD-0061', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '200', NULL, '2018-07-25 06:40:03', '2018-07-25 07:21:56'),
(68, 100, 'BK-25072018-CD-0061', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '300', NULL, '2018-07-25 06:40:03', '2018-07-25 07:21:56'),
(69, 101, 'BK-25072018-CD-0061', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '150', 'DARK KHAKI', '2018-07-25 06:40:03', '2018-07-25 07:21:57'),
(70, 101, 'BK-25072018-CD-0061', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'DARK STEEL', '150', 'NAVY', '2018-07-25 06:40:03', '2018-07-25 07:21:57'),
(71, 102, 'BK-25072018-ACL-0062', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '100', '', '2018-07-25 06:46:31', '2018-07-25 07:21:56'),
(72, 102, 'BK-25072018-ACL-0062', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '120', NULL, '2018-07-25 06:46:31', '2018-07-25 07:21:56'),
(73, 103, 'BK-26072018-CSF-0063', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-25 23:15:13', '2018-07-26 01:28:43'),
(74, 103, 'BK-26072018-CSF-0063', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', 'WWWWWWW', '2018-07-25 23:15:13', '2018-07-26 01:28:43'),
(75, 103, 'BK-26072018-CSF-0063', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '0', '00XXX', '2018-07-25 23:15:13', '2018-07-26 01:28:43'),
(76, 104, 'BK-26072018-CSF-0064', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-25 23:39:21', '2018-07-26 01:33:49'),
(77, 104, 'BK-26072018-CSF-0064', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '0', 'WWWWWWW', '2018-07-25 23:39:21', '2018-07-26 01:33:49'),
(78, 104, 'BK-26072018-CSF-0064', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '0', '00XXX', '2018-07-25 23:39:21', '2018-07-26 01:33:49'),
(79, 105, 'BK-26072018-CSF-0064', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-25 23:39:21', '2018-07-26 01:33:49'),
(80, 106, 'BK-26072018-CSF-0065', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-25 23:50:25', '2018-07-26 01:28:43'),
(81, 107, 'BK-26072018-CSF-0065', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-25 23:50:25', '2018-07-26 01:28:43'),
(82, 107, 'BK-26072018-CSF-0065', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'NAVY', '2018-07-25 23:50:25', '2018-07-26 01:28:43'),
(83, 108, 'BK-26072018-CSF-0066', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-26 01:35:15', '2018-07-26 01:36:38'),
(84, 109, 'BK-26072018-CSF-0067', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '3', '00XXX', '2018-07-26 01:38:01', '2018-07-26 01:53:31'),
(85, 110, 'BK-26072018-CSF-0068', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-26 01:55:50', '2018-07-26 01:57:56'),
(86, 110, 'BK-26072018-CSF-0068', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', 'WWWWWWW', '2018-07-26 01:55:50', '2018-07-26 01:57:56'),
(87, 110, 'BK-26072018-CSF-0068', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '450', '00XXX', '2018-07-26 01:55:50', '2018-07-26 02:06:41'),
(88, 111, 'BK-26072018-CSF-0068', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-26 01:55:50', '2018-07-26 01:57:56'),
(89, 111, 'BK-26072018-CSF-0068', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'DARK STEEL', '180', 'NAVY', '2018-07-26 01:55:50', '2018-07-26 02:06:41'),
(90, 112, 'BK-26072018-CSF-0069', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '900', '00XXX', '2018-07-26 01:57:03', '2018-07-26 02:06:41'),
(91, 112, 'BK-26072018-CSF-0069', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '900', 'WWWWWWW', '2018-07-26 01:57:03', '2018-07-26 02:06:41'),
(92, 113, 'BK-26072018-CSF-0069', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '450', 'DARK KHAKI', '2018-07-26 01:57:03', '2018-07-26 02:06:41'),
(93, 114, 'BK-26072018-CSF-0070', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '0', '', '2018-07-26 02:10:19', '2018-07-26 02:40:38'),
(94, 114, 'BK-26072018-CSF-0070', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '60', NULL, '2018-07-26 02:10:19', '2018-07-26 02:40:38'),
(95, 114, 'BK-26072018-CSF-0070', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '60', NULL, '2018-07-26 02:10:19', '2018-07-26 02:40:38'),
(96, 115, 'BK-26072018-rga-0071', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '250', '00XXX', '2018-07-26 02:11:39', '2018-07-26 02:40:38'),
(97, 115, 'BK-26072018-rga-0071', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '250', 'WWWWWWW', '2018-07-26 02:11:39', '2018-07-26 02:40:38'),
(98, 116, 'BK-26072018-rga-0071', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '150', '', '2018-07-26 02:11:39', '2018-07-26 02:40:38'),
(99, 117, 'BK-26072018-CSF-0072', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '0', '00XXX', '2018-07-26 02:18:51', '2018-07-26 02:21:42'),
(100, 117, 'BK-26072018-CSF-0072', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', 'WWWWWWW', '2018-07-26 02:18:51', '2018-07-26 02:21:42'),
(101, 118, 'BK-26072018-CSF-0073', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '300', '00XXX', '2018-07-26 02:20:14', '2018-07-26 02:24:28'),
(102, 118, 'BK-26072018-CSF-0073', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '200', 'WWWWWWW', '2018-07-26 02:20:14', '2018-07-26 02:24:28'),
(103, 119, 'BK-26072018-CSF-0074', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-26 02:50:25', '2018-07-26 02:52:28'),
(104, 120, 'BK-26072018-CSF-0074', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '0', '', '2018-07-26 02:50:25', '2018-07-26 02:52:29'),
(105, 120, 'BK-26072018-CSF-0074', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '0', NULL, '2018-07-26 02:50:25', '2018-07-26 02:52:29'),
(106, 120, 'BK-26072018-CSF-0074', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L KN 175/96', '500', NULL, '2018-07-26 02:50:25', '2018-07-26 02:52:29'),
(107, 121, 'BK-26072018-CSF-0075', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '500', 'WWWWWWW', '2018-07-26 02:51:44', '2018-07-26 02:52:28'),
(108, 121, 'BK-26072018-CSF-0075', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '1000', '00XXX', '2018-07-26 02:51:44', '2018-07-26 02:51:44'),
(109, 122, 'BK-26072018-CSF-0075', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '1000', '', '2018-07-26 02:51:45', '2018-07-26 02:51:45'),
(110, 122, 'BK-26072018-CSF-0075', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '1000', NULL, '2018-07-26 02:51:45', '2018-07-26 02:51:45'),
(111, 123, 'BK-26072018-CSF-0075', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '500', 'DARK KHAKI', '2018-07-26 02:51:45', '2018-07-26 02:52:29'),
(112, 124, 'BK-26072018-CSF-0076', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-26 03:09:22', '2018-07-26 05:06:15'),
(113, 124, 'BK-26072018-CSF-0076', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '75', 'WWWWWWW', '2018-07-26 03:09:22', '2018-07-26 05:07:40'),
(114, 125, 'BK-26072018-CSF-0077', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-26 03:44:00', '2018-07-26 04:12:19'),
(115, 125, 'BK-26072018-CSF-0077', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '100', '00XXX', '2018-07-26 03:44:00', '2018-07-26 05:07:40'),
(116, 126, 'BK-26072018-CSF-0077', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '0', '', '2018-07-26 03:44:00', '2018-07-26 04:12:19'),
(117, 126, 'BK-26072018-CSF-0077', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '0', NULL, '2018-07-26 03:44:00', '2018-07-26 04:12:20'),
(118, 127, 'BK-26072018-CSF-0077', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-26 03:44:00', '2018-07-26 04:12:20'),
(119, 128, 'BK-26072018-CSF-0078', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '75', '00XXX', '2018-07-26 03:45:13', '2018-07-26 05:07:40'),
(120, 128, 'BK-26072018-CSF-0078', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '110', 'WWWWWWW', '2018-07-26 03:45:13', '2018-07-26 05:06:15'),
(121, 129, 'BK-26072018-CSF-0078', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '200', '', '2018-07-26 03:45:13', '2018-07-26 05:07:40'),
(122, 130, 'BK-26072018-CSF-0079', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L KN 175/96', '70', '', '2018-07-26 03:46:08', '2018-07-26 05:07:40'),
(123, 130, 'BK-26072018-CSF-0079', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '200', NULL, '2018-07-26 03:46:08', '2018-07-26 05:07:40'),
(124, 131, 'BK-26072018-CSF-0079', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '100', 'DARK KHAKI', '2018-07-26 03:46:08', '2018-07-26 05:07:40'),
(125, 132, 'BK-26072018-CSF-0080', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '960', '00XXX', '2018-07-26 05:20:41', '2018-07-26 05:22:35'),
(126, 132, 'BK-26072018-CSF-0080', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '960', 'WWWWWWW', '2018-07-26 05:20:41', '2018-07-26 05:22:35'),
(127, 133, 'BK-26072018-CSF-0081', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '0', '', '2018-07-26 05:23:38', '2018-07-27 00:58:29'),
(128, 133, 'BK-26072018-CSF-0081', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '0', NULL, '2018-07-26 05:23:38', '2018-07-27 00:58:29'),
(129, 133, 'BK-26072018-CSF-0081', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L KN 175/96', '0', NULL, '2018-07-26 05:23:38', '2018-07-27 00:58:29'),
(130, 134, 'BK-26072018-CSF-0082', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '0', '', '2018-07-26 05:49:11', '2018-07-27 00:58:29'),
(131, 134, 'BK-26072018-CSF-0082', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L KN 175/96', '0', NULL, '2018-07-26 05:49:11', '2018-07-26 05:50:47'),
(132, 135, 'BK-26072018-CSF-0082', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-26 05:49:11', '2018-07-26 05:50:47'),
(133, 136, 'BK-26072018-CSF-0083', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '0', '', '2018-07-26 05:50:05', '2018-07-27 00:58:29'),
(134, 136, 'BK-26072018-CSF-0083', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L KN 175/96', '0', NULL, '2018-07-26 05:50:05', '2018-07-27 00:58:29'),
(135, 137, 'BK-26072018-CSF-0083', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-26 05:50:05', '2018-07-27 00:58:29'),
(136, 138, 'BK-27072018--0084', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '1000', '00XXX', '2018-07-26 23:26:57', '2018-07-26 23:26:57'),
(137, 139, 'BK-27072018-CSF-0084', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF L CN 175/96A', '0', '', '2018-07-26 23:27:45', '2018-07-29 00:19:49'),
(138, 140, 'BK-27072018-CD-0085', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF L CN 175/96A', '900', '', '2018-07-26 23:28:10', '2018-07-27 00:01:22'),
(139, 141, 'BK-27072018-CD-0086', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-27 00:15:45', '2018-07-27 00:41:41'),
(140, 141, 'BK-27072018-CD-0086', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '0', 'WWWWWWW', '2018-07-27 00:15:45', '2018-07-27 00:41:41'),
(141, 142, 'BK-27072018-CD-0087', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'WWWW', '0', '00XXX', '2018-07-27 00:16:14', '2018-07-27 00:41:41'),
(142, 143, 'BK-27072018-CSF-0088', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '900', '', '2018-07-27 01:28:31', '2018-07-27 01:37:46'),
(143, 143, 'BK-27072018-CSF-0088', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '0', NULL, '2018-07-27 01:28:31', '2018-07-27 01:37:46'),
(144, 144, 'BK-27072018-CSF-0089', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-27 02:47:51', '2018-07-27 03:32:45'),
(145, 145, 'BK-27072018-CSF-0089', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '0', '', '2018-07-27 02:47:51', '2018-07-27 03:32:45'),
(146, 145, 'BK-27072018-CSF-0089', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L KN 175/96', '0', NULL, '2018-07-27 02:47:51', '2018-07-27 03:32:45'),
(147, 146, 'BK-27072018-CSF-0090', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-27 02:49:13', '2018-07-27 02:59:32'),
(148, 147, 'BK-27072018-CSF-0090', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '0', '', '2018-07-27 02:49:13', '2018-07-27 03:32:44'),
(149, 148, 'BK-27072018-CSF-0090', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-27 02:49:13', '2018-07-27 03:32:45'),
(150, 148, 'BK-27072018-CSF-0090', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'NAVY', '2018-07-27 02:49:13', '2018-07-27 03:32:45'),
(151, 149, 'BK-27072018-CSF-0091', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '0', '', '2018-07-27 02:50:15', '2018-07-27 02:59:32'),
(152, 150, 'BK-27072018-CSF-0091', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'NAVY', '2018-07-27 02:50:15', '2018-07-27 02:59:32'),
(153, 151, 'BK-27072018-CSF-0092', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF L CN 175/96A', '0', '', '2018-07-27 02:50:45', '2018-07-27 03:32:44'),
(154, 151, 'BK-27072018-CSF-0092', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF M CN 170/92M', '0', NULL, '2018-07-27 02:50:45', '2018-07-27 03:32:44'),
(155, 152, 'BK-27072018-CSF-0093', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '1000', '00XXX', '2018-07-27 02:57:43', '2018-07-27 02:57:43'),
(156, 153, 'BK-27072018-CSF-0093', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '1000', '', '2018-07-27 02:57:43', '2018-07-27 02:57:43'),
(157, 154, 'BK-27072018-CSF-0093', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '1000', 'DARK KHAKI', '2018-07-27 02:57:43', '2018-07-27 02:57:43'),
(158, 154, 'BK-27072018-CSF-0093', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '1000', 'NAVY', '2018-07-27 02:57:43', '2018-07-27 02:57:43'),
(159, 155, 'BK-27072018-CSF-0094', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '1000', '00XXX', '2018-07-27 02:57:46', '2018-07-27 02:57:46'),
(160, 156, 'BK-27072018-CSF-0094', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '1000', '', '2018-07-27 02:57:46', '2018-07-27 02:57:46'),
(161, 157, 'BK-27072018-CSF-0094', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '1000', 'DARK KHAKI', '2018-07-27 02:57:46', '2018-07-27 02:57:46'),
(162, 157, 'BK-27072018-CSF-0094', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '1000', 'NAVY', '2018-07-27 02:57:46', '2018-07-27 02:57:46'),
(163, 158, 'BK-27072018-CSF-0095', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', '2018-07-27 03:17:04', '2018-07-27 03:31:16'),
(164, 159, 'BK-27072018-CSF-0095', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', '2018-07-27 03:17:05', '2018-07-27 03:31:17'),
(165, 159, 'BK-27072018-CSF-0095', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'NAVY', '2018-07-27 03:17:05', '2018-07-27 03:31:17'),
(166, 160, 'BK-27072018-CD-0096', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '350', '00XXX', '2018-07-27 03:33:56', '2018-07-29 00:19:04'),
(167, 161, 'BK-27072018-CD-0096', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '350', 'DARK KHAKI', '2018-07-27 03:33:56', '2018-07-29 00:19:04'),
(168, 161, 'BK-27072018-CD-0096', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '350', 'NAVY', '2018-07-27 03:33:56', '2018-07-29 00:19:04'),
(169, 162, 'BK-07082018-CSF-0097', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '1000', '00XXX', '2018-08-07 00:31:13', '2018-08-07 00:31:13');

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
-- Table structure for table `mxp_maximbill`
--

CREATE TABLE `mxp_maximbill` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bill_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `oss` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `style` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `party_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_buyer` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attention_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_maximbill`
--

INSERT INTO `mxp_maximbill` (`id`, `user_id`, `order_id`, `bill_id`, `erp_code`, `item_code`, `oss`, `style`, `item_size`, `quantity`, `unit_price`, `total_price`, `party_id`, `name_buyer`, `name`, `sort_name`, `address`, `attention_invoice`, `mobile_invoice`, `status`, `created_at`, `updated_at`) VALUES
(1, 49, '5b2a4291e1189', 'INV-20180620-Mi-001', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'abc', 'fff', NULL, '22', '1.01', '1.0201', '123', 'Ostin\'s', 'Maxpro It', 'Mi', 'Section -1Section-2', 'md Hanif', '01792828282', 'create', '2018-06-20 06:03:31', '2018-06-20 06:03:31'),
(2, 49, '5b2a4291e1189', 'INV-20180620-Mi-001', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'abc', 'tt', 'EF M CN 170/92M,EF L CN 175/96A,EF S CN 165/88A', '1201,1200,1202', '.08', '0.0064', '123', 'Ostin\'s', 'Maxpro It', 'Mi', 'Section -1Section-2', 'md Hanif', '01792828282', 'create', '2018-06-20 06:03:31', '2018-06-20 06:03:31'),
(3, 49, '5b2a4291e1189', 'INV-20180620-Mi-001', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'abc', NULL, 'EU S CN 165/88A,EU L CN 175/96A,EU XS CN 160/84A,EU M CN 170/92M', '2001,2003,2000,2002', '0.002', '0.000004', '123', 'Ostin\'s', 'Maxpro It', 'Mi', 'Section -1Section-2', 'md Hanif', '01792828282', 'create', '2018-06-20 06:03:31', '2018-06-20 06:03:31'),
(4, 49, '5b2a4291e1189', 'INV-20180620-Mi-001', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'abc', NULL, 'EG L KN 175/96,EG L CN 175/96A', '1001,1000', '.05', '0.0025000000000000005', '123', 'Ostin\'s', 'Maxpro It', 'Mi', 'Section -1Section-2', 'md Hanif', '01792828282', 'create', '2018-06-20 06:03:31', '2018-06-20 06:03:31'),
(5, 49, '5b2cc4ba18a40', 'INV-20180622-ACL-002', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'abc', 'fff', NULL, '22', '1.01', '1.0201', '3232', 'REGATTA', 'ALPHA CLOTHING LTD', 'ACL', 'Section -1Section- 2', 'aaaa', '01685-696806', 'create', '2018-06-22 03:43:23', '2018-06-22 03:43:23'),
(6, 49, '5b2cc4ba18a40', 'INV-20180622-ACL-002', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'abc', 'tt', 'EF M CN 170/92M,EF L CN 175/96A,EF S CN 165/88A', '1201,1200,1202', '.08', '0.0064', '3232', 'REGATTA', 'ALPHA CLOTHING LTD', 'ACL', 'Section -1Section- 2', 'aaaa', '01685-696806', 'create', '2018-06-22 03:43:23', '2018-06-22 03:43:23'),
(7, 49, '5b2cc4ba18a40', 'INV-20180622-ACL-002', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'abc', NULL, 'EU S CN 165/88A,EU L CN 175/96A,EU XS CN 160/84A,EU M CN 170/92M', '2001,2003,2000,2002', '0.002', '0.000004', '3232', 'REGATTA', 'ALPHA CLOTHING LTD', 'ACL', 'Section -1Section- 2', 'aaaa', '01685-696806', 'create', '2018-06-22 03:43:23', '2018-06-22 03:43:23'),
(8, 49, '5b2cc4ba18a40', 'INV-20180622-ACL-002', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'abc', NULL, 'EG L KN 175/96,EG L CN 175/96A', '1001,1000', '.05', '0.0025000000000000005', '3232', 'REGATTA', 'ALPHA CLOTHING LTD', 'ACL', 'Section -1Section- 2', 'aaaa', '01685-696806', 'create', '2018-06-22 03:43:23', '2018-06-22 03:43:23');

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
(72, 'Client List', 'client_com_list_view', 'Show Client List', 5, 1, 5, NULL, NULL),
(75, 'management', '', '', 0, 1, 4, NULL, NULL),
(76, 'Product List', 'product_list_view', '', 75, 1, 1, NULL, NULL),
(78, 'party list', 'party_list_view', '', 75, 1, 0, NULL, NULL),
(83, 'page', '', '', 0, 1, 0, NULL, NULL),
(84, 'page header', 'page_header_view', '', 83, 1, 0, NULL, NULL),
(85, 'page footer', 'page_footer_view', '', 83, 1, 2, NULL, NULL),
(86, 'report footer', 'report_footer_view', '', 83, 1, 3, NULL, NULL),
(87, 'brand', 'brand_list_view', '', 75, 1, 3, NULL, NULL),
(88, 'Product_size', 'product_size_view', '', 75, 1, 4, NULL, NULL),
(89, 'PRINT', '', 'there r all print file avialbe', 0, 1, 0, NULL, NULL),
(90, 'Bill_copy', 'bill_copy_view', '', 89, 1, 1, NULL, NULL),
(91, 'all_bill_view', 'all_bill_view', '', 89, 1, 3, NULL, NULL),
(92, 'challan_boxing_list', 'challan_boxing_list_view', '', 89, 1, 4, NULL, NULL),
(93, 'order_list_view', 'order_list_view', '', 89, 1, 2, NULL, NULL),
(94, 'ipo_view', 'ipo_view', '', 89, 1, 5, NULL, NULL),
(95, 'Order Input', 'order_input_view', '', 89, 1, 0, NULL, NULL),
(96, 'GMTS Color', 'gmts_color_view', '', 75, 1, 5, NULL, NULL),
(97, 'Production', '', '', 0, 1, 0, NULL, NULL),
(98, 'Booking', 'booking_list_view', '', 97, 1, 1, NULL, NULL),
(99, 'MRF List', 'mrf_list_view', 'show all MRF list', 97, 1, 2, NULL, NULL),
(100, 'Challan List', 'challan_list_view', '', 97, 1, 3, NULL, NULL),
(101, 'Suppliers', 'supplier_list_view', '', 75, 1, 0, NULL, NULL),
(102, 'Add Supplier', 'supplier_add_view', '', 0, 1, 0, NULL, NULL),
(103, 'Add Supplier', 'supplier_add_action', '', 0, 1, 0, NULL, NULL),
(104, 'Update', 'supplier_update', '', 0, 1, 0, NULL, NULL),
(105, 'Update', 'supplier_update_action', '', 0, 1, 0, NULL, NULL),
(106, 'Delete', 'supplier_delete_action', '', 0, 1, 0, NULL, NULL),
(107, 'permission task assign', 'permission_task_assign', '', 6, 1, 0, NULL, NULL),
(108, 'Purchase Order', 'generate_purchase_order', 'purchase order list', 97, 1, 4, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `mxp_MRF_table`
--

CREATE TABLE `mxp_MRF_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `mrf_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `booking_order_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `matarial` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gmts_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `others_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderDate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderNo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipmentDate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `poCatNo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `mrf_quantity` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mrf_person_name` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_MRF_table`
--

INSERT INTO `mxp_MRF_table` (`id`, `user_id`, `mrf_id`, `supplier_id`, `booking_order_id`, `erp_code`, `item_code`, `item_size`, `item_description`, `item_quantity`, `item_price`, `matarial`, `gmts_color`, `others_color`, `orderDate`, `orderNo`, `shipmentDate`, `poCatNo`, `status`, `action`, `created_at`, `updated_at`, `mrf_quantity`, `mrf_person_name`) VALUES
(34, 49, 'MRF-12072018-0001', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '95,100,105', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-12', '111111', NULL, 'create', '2018-07-12 05:24:38', '2018-07-12 05:24:38', '1,2,3', 'www'),
(35, 49, 'MRF-12072018-0002', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '94,99,104', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-19', '111111', NULL, 'create', '2018-07-12 05:31:17', '2018-07-12 05:31:17', '1,1,1', 'maxim'),
(36, 49, 'MRF-12072018-0003', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '93,98,103', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-19', '111111', NULL, 'create', '2018-07-12 05:31:57', '2018-07-12 05:31:57', '1,1,1', 'maxim'),
(37, 49, 'MRF-12072018-0004', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '92,97,102', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-19', '111111', NULL, 'create', '2018-07-12 05:32:22', '2018-07-12 05:32:22', '1,1,1', 'maxim'),
(38, 49, 'MRF-12072018-0005', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '91,96,101', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-19', '111111', NULL, 'create', '2018-07-12 05:32:40', '2018-07-12 05:32:40', '1,1,1', 'maxim'),
(39, 49, 'MRF-12072018-0006', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '90,95,100', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-19', '111111', NULL, 'create', '2018-07-12 05:32:56', '2018-07-12 05:32:56', '1,1,1', 'maxim'),
(40, 49, 'MRF-12072018-0007', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '89,94,99', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-19', '111111', NULL, 'create', '2018-07-12 05:33:18', '2018-07-12 05:33:18', '1,1,1', 'maxim'),
(41, 49, 'MRF-12072018-0008', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '87,92,97', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-19', '111111', NULL, 'create', '2018-07-12 05:35:54', '2018-07-12 05:35:54', '1,1,1', 'maxim'),
(42, 49, 'MRF-12072018-0009', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '86,91,96', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-19', '111111', NULL, 'create', '2018-07-12 05:36:14', '2018-07-12 05:36:14', '1,1,1', 'maxim'),
(43, 49, 'MRF-12072018-0010', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '85,90,95', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-19', '111111', NULL, 'create', '2018-07-12 05:36:33', '2018-07-12 05:36:33', '1,1,1', 'maxim'),
(44, 49, 'MRF-12072018-0011', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '84,89,94', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-19', '111111', NULL, 'create', '2018-07-12 05:37:05', '2018-07-12 05:37:05', '1,1,1', 'maxim'),
(45, 49, 'MRF-12072018-0012', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '83,88,93', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-19', '111111', NULL, 'create', '2018-07-12 05:37:18', '2018-07-12 05:37:18', '1,1,1', 'maxim'),
(46, 49, 'MRF-12072018-0013', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '81,85,89', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-12', '111111', NULL, 'create', '2018-07-12 05:39:20', '2018-07-12 05:39:20', '2,3,4', 'www'),
(47, 49, 'MRF-12072018-0014', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '80,83,86', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-26', '111111', NULL, 'create', '2018-07-12 05:45:50', '2018-07-12 05:45:50', '1,2,3', 'maxim'),
(48, 49, 'MRF-12072018-0015', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '79,81,83', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-26', '111111', NULL, 'create', '2018-07-12 05:46:20', '2018-07-12 05:46:20', '1,2,3', 'maxim'),
(49, 49, 'MRF-12072018-0016', 1, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '78,79,80', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-26', '111111', NULL, 'create', '2018-07-12 05:46:40', '2018-07-12 05:46:40', '1,2,3', 'maxim'),
(50, 49, 'MRF-12072018-0017', NULL, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '77,77,77', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-26', '111111', NULL, 'create', '2018-07-12 05:47:02', '2018-07-12 05:47:02', '1,2,3', 'maxim'),
(51, 49, 'MRF-12072018-0018', NULL, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '76,75,74', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-26', '111111', NULL, 'create', '2018-07-12 05:47:38', '2018-07-12 05:47:38', '1,2,3', 'maxim'),
(52, 49, 'MRF-12072018-0019', NULL, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '75,73,71', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-26', '111111', NULL, 'create', '2018-07-12 05:58:18', '2018-07-12 05:58:18', '1,2,3', 'maxim'),
(53, 49, 'MRF-12072018-0020', NULL, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '74,71,68', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-26', '111111', NULL, 'create', '2018-07-12 05:58:59', '2018-07-12 05:58:59', '1,2,3', 'maxim'),
(54, 49, 'MRF-12072018-0021', NULL, 'INVO-12072018-CSF-0006', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '73,69,65', '0.002', NULL, NULL, NULL, '2018-07-12', '12', '2018-07-26', '111111', NULL, 'create', '2018-07-12 06:01:01', '2018-07-12 06:01:01', '1,2,3', 'maxim'),
(55, 49, 'MRF-12072018-0022', 1, 'INVO-12072018-CSF-0009', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '110,110,110', '0.002', NULL, NULL, NULL, NULL, NULL, '2018-07-25', NULL, NULL, 'create', '2018-07-12 06:09:54', '2018-07-12 06:09:54', '10,20,30', 'maxim'),
(56, 49, 'MRF-13072018-0023', NULL, 'INVO-13072018-CD-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '208,217,226', '.08', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-26', '111111', NULL, 'create', '2018-07-13 00:34:27', '2018-07-13 00:34:27', '2,3,4', 'www'),
(57, 49, 'MRF-13072018-0023', NULL, 'INVO-13072018-CD-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '105,114,123', '0.002', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-26', '111111', NULL, 'create', '2018-07-13 00:34:27', '2018-07-13 00:34:27', '5,6,7', 'www'),
(58, 49, 'MRF-13072018-0025', 1, 'INVO-13072018-CD-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '206,214,222', '.08', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-26', '111111', NULL, 'create', '2018-07-13 02:22:58', '2018-07-13 02:22:58', '12,8,10', 'www'),
(59, 49, 'MRF-13072018-0025', NULL, 'INVO-13072018-CD-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '100,108,116', '0.002', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-26', '111111', NULL, 'create', '2018-07-13 02:22:58', '2018-07-13 02:22:58', '10,13,16', 'www'),
(60, 49, 'MRF-13072018-0027', NULL, 'INVO-13072018-CD-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '204,212,220', '.08', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-25', '111111', NULL, 'create', '2018-07-13 02:23:34', '2018-07-13 02:23:34', '14,10,12', 'maxim'),
(61, 49, 'MRF-13072018-0027', NULL, 'INVO-13072018-CD-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '98,106,114', '0.002', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-25', '111111', NULL, 'create', '2018-07-13 02:23:34', '2018-07-13 02:23:34', '12,15,18', 'maxim'),
(62, 49, 'MRF-13072018-0029', NULL, 'INVO-13072018-CD-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '202,210,104', '.08', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-20', '111111', NULL, 'create', '2018-07-13 02:28:04', '2018-07-13 02:28:04', '16,12,17', 'maxim'),
(63, 49, 'MRF-13072018-0029', NULL, 'INVO-13072018-CD-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '219,97,111', '0.002', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-20', '111111', NULL, 'create', '2018-07-13 02:28:04', '2018-07-13 02:28:04', '13,13,21', 'maxim'),
(64, 49, 'MRF-13072018-0031', NULL, 'INVO-13072018-CD-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '201,208,101', '.08', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-19', '111111', NULL, 'create', '2018-07-13 03:19:59', '2018-07-13 03:19:59', '17,14,20', 'maxim'),
(65, 49, 'MRF-13072018-0031', NULL, 'INVO-13072018-CD-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '0,0,0', '0.002', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-19', '111111', NULL, 'create', '2018-07-13 03:19:59', '2018-07-13 03:19:59', '232,110,132', 'maxim'),
(66, 49, 'MRF-13072018-0033', NULL, 'INVO-13072018-CD-0010', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '200,206,98', '.08', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-20', '111111', NULL, 'create', '2018-07-13 03:30:32', '2018-07-13 03:30:32', '1,2,3', 'maxim'),
(67, 49, 'MRF-13072018-0033', NULL, 'INVO-13072018-CD-0010', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '0,0,0', '0.002', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-20', '111111', NULL, 'create', '2018-07-13 03:30:32', '2018-07-13 03:30:32', '0,0,0', 'maxim'),
(68, 49, 'MRF-13072018-0035', NULL, 'INVO-13072018-CSF-0011', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '208,216,224', '.08', NULL, NULL, NULL, '2018-07-26', '111111', '2018-07-20', '111111', NULL, 'create', '2018-07-13 05:40:29', '2018-07-13 05:40:29', '1,2,3', 'maxim'),
(69, 49, 'MRF-13072018-0035', NULL, 'INVO-13072018-CSF-0011', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '102,110,118', '0.002', NULL, NULL, NULL, '2018-07-26', '111111', '2018-07-20', '111111', NULL, 'create', '2018-07-13 05:40:30', '2018-07-13 05:40:30', '4,5,6', 'maxim'),
(70, 49, 'MRF-13072018-0037', NULL, 'INVO-13072018-CSF-0012', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', NULL, '119', '.08', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-19', '111111', NULL, 'create', '2018-07-13 05:47:21', '2018-07-13 05:47:21', '1', 'maxim'),
(71, 49, 'MRF-13072018-0037', NULL, 'INVO-13072018-CSF-0012', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '108,117,126', '0.002', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-19', '111111', NULL, 'create', '2018-07-13 05:47:21', '2018-07-13 05:47:21', '2,3,4', 'maxim'),
(72, 49, 'MRF-13072018-0039', NULL, 'INVO-13072018-CSF-0012', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', NULL, '118', '.08', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-20', '111111', NULL, 'create', '2018-07-13 05:56:37', '2018-07-13 05:56:37', '1', 'maxim'),
(73, 49, 'MRF-13072018-0039', NULL, 'INVO-13072018-CSF-0012', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '106,114,122', '0.002', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-20', '111111', NULL, 'create', '2018-07-13 05:56:37', '2018-07-13 05:56:37', '2,3,4', 'maxim'),
(74, 49, 'MRF-13072018-0041', NULL, 'INVO-13072018-CSF-0012', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A', NULL, '98', '.08', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-26', '111111', NULL, 'create', '2018-07-13 05:57:17', '2018-07-13 05:57:17', '20', 'maxim'),
(75, 49, 'MRF-13072018-0041', NULL, 'INVO-13072018-CSF-0012', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '77,104,112', '0.002', NULL, NULL, NULL, '2018-07-12', '111111', '2018-07-26', '111111', NULL, 'create', '2018-07-13 05:57:17', '2018-07-13 05:57:17', '29,10,10', 'maxim'),
(76, 49, 'MRF-13072018-0043', NULL, 'INVO-13072018-CSF-0011', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '206,213,220', '.08', NULL, NULL, NULL, '2018-07-26', '111111', '2018-07-25', '111111', NULL, 'create', '2018-07-13 06:27:10', '2018-07-13 06:27:10', '2,3,4', 'dd'),
(77, 49, 'MRF-13072018-0043', NULL, 'INVO-13072018-CSF-0011', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '97,104,111', '0.002', NULL, NULL, NULL, '2018-07-26', '111111', '2018-07-25', '111111', NULL, 'create', '2018-07-13 06:27:10', '2018-07-13 06:27:10', '5,6,7', 'dd'),
(78, 49, 'MRF-13072018-0045', NULL, 'INVO-13072018-CSF-0011', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '205,211,217', '.08', NULL, NULL, NULL, '2018-07-26', '111111', '2018-07-18', '111111', NULL, 'create', '2018-07-13 06:29:24', '2018-07-13 06:29:24', '1,2,3', 'dd'),
(79, 49, 'MRF-13072018-0045', NULL, 'INVO-13072018-CSF-0011', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '97,104,111', '0.002', NULL, NULL, NULL, '2018-07-26', '111111', '2018-07-18', '111111', NULL, 'create', '2018-07-13 06:29:24', '2018-07-13 06:29:24', '0,0,0', 'dd'),
(80, 49, 'MRF-13072018-0047', NULL, 'INVO-13072018-CSF-0013', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '209,218,227', '.08', NULL, NULL, NULL, '2018-07-18', '8888', '2018-07-25', '99', NULL, 'create', '2018-07-13 06:50:32', '2018-07-13 06:50:32', '1,2,3', 'qwe'),
(81, 49, 'MRF-13072018-0047', NULL, 'INVO-13072018-CSF-0013', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '106,115,124', '0.002', NULL, NULL, NULL, '2018-07-18', '8888', '2018-07-25', '99', NULL, 'create', '2018-07-13 06:50:32', '2018-07-13 06:50:32', '4,5,6', 'qwe'),
(82, 49, 'MRF-13072018-0049', NULL, 'INVO-13072018-CSF-0035', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '209,218,227', '.08', NULL, NULL, NULL, '2018-07-18', '111111', '2018-07-25', '12', NULL, 'create', '2018-07-13 08:59:56', '2018-07-13 08:59:56', '1,2,3', 'maxim'),
(83, 49, 'MRF-13072018-0049', NULL, 'INVO-13072018-CSF-0035', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '106,115,124', '0.002', NULL, NULL, NULL, '2018-07-18', '111111', '2018-07-25', '12', NULL, 'create', '2018-07-13 08:59:56', '2018-07-13 08:59:56', '4,5,6', 'maxim'),
(84, 49, 'MRF-13072018-0051', NULL, 'INVO-13072018-CSF-0035', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '206,214,222', '.08', NULL, NULL, NULL, '2018-07-18', '111111', '2018-07-25', '12', NULL, 'create', '2018-07-13 09:00:43', '2018-07-13 09:00:43', '3,4,5', 'www'),
(85, 49, 'MRF-13072018-0051', NULL, 'INVO-13072018-CSF-0035', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '99,107,115', '0.002', NULL, NULL, NULL, '2018-07-18', '111111', '2018-07-25', '12', NULL, 'create', '2018-07-13 09:00:43', '2018-07-13 09:00:43', '7,8,9', 'www'),
(86, 49, 'MRF-13072018-0053', NULL, 'INVO-13072018-CSF-0035', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', NULL, '206,214,222', '.08', NULL, NULL, NULL, '2018-07-18', '111111', '2018-07-25', '12', NULL, 'create', '2018-07-13 09:02:59', '2018-07-13 09:02:59', '0,0,0', 'www'),
(87, 49, 'MRF-13072018-0053', NULL, 'INVO-13072018-CSF-0035', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', NULL, '94,99,111', '0.002', NULL, NULL, NULL, '2018-07-18', '111111', '2018-07-25', '12', NULL, 'create', '2018-07-13 09:02:59', '2018-07-13 09:02:59', '5,8,4', 'www'),
(88, 49, 'MRF-13072018-0055', NULL, 'BK-13072018-CSF-0037', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A,EF L CN 175/96A3', NULL, '1111,1800', '.05', NULL, NULL, NULL, NULL, '34343', '2018-07-20', '343434', NULL, 'create', '2018-07-13 09:57:53', '2018-07-13 09:57:53', '123,200', 'xdsfsdsf'),
(89, 49, 'MRF-13072018-0055', 1, 'BK-13072018-CSF-0037', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', NULL, '899', '0.3', NULL, 'DARK KHAKI', NULL, NULL, '34343', '2018-07-20', '343434', NULL, 'create', '2018-07-13 09:57:53', '2018-07-13 09:57:53', '0', 'xdsfsdsf'),
(90, 49, 'MRF-19072018-0057', 1, 'BK-13072018-CSF-0037', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A,EF L CN 175/96A3', NULL, '990,1610', '.05', NULL, NULL, NULL, NULL, '34343', '2018-07-25', '343434', NULL, 'create', '2018-07-19 04:18:24', '2018-07-19 04:18:24', '10,10', 'fff'),
(91, 49, 'MRF-19072018-0057', 1, 'BK-13072018-CSF-0037', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', NULL, '767', '0.3', NULL, 'DARK KHAKI', NULL, NULL, '34343', '2018-07-25', '343434', NULL, 'create', '2018-07-19 04:18:24', '2018-07-19 04:18:24', '43', 'fff'),
(92, 49, 'MRF-27072018-0059', NULL, 'BK-27072018-CD-0096', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', NULL, '0', '1.01', NULL, '00XXX', NULL, NULL, NULL, '2018-07-27', NULL, NULL, 'create', '2018-07-27 03:55:41', '2018-07-27 03:55:41', '450', 'yrtyryrtr'),
(93, 49, 'MRF-27072018-0059', NULL, 'BK-27072018-CD-0096', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', NULL, '0', '0.3', NULL, 'DARK KHAKI,NAVY', NULL, NULL, NULL, '2018-07-27', NULL, NULL, 'create', '2018-07-27 03:55:42', '2018-07-27 03:55:42', '450', 'yrtyryrtr'),
(94, 49, 'MRF-30072018-0061', 1, 'BK-27072018-CSF-0093', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', NULL, '0', '1.01', NULL, '00XXX', NULL, NULL, NULL, '2018-07-31', NULL, NULL, 'create', '2018-07-30 07:06:42', '2018-07-30 07:06:42', '1000', NULL),
(95, 49, 'MRF-30072018-0061', 1, 'BK-27072018-CSF-0093', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', NULL, '0', '.05', NULL, NULL, NULL, NULL, NULL, '2018-07-31', NULL, NULL, 'create', '2018-07-30 07:06:42', '2018-07-30 07:06:42', '1000', NULL),
(96, 49, 'MRF-30072018-0061', 1, 'BK-27072018-CSF-0093', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', NULL, '0', '0.3', NULL, 'DARK KHAKI,NAVY', NULL, NULL, NULL, '2018-07-31', NULL, NULL, 'create', '2018-07-30 07:06:42', '2018-07-30 07:06:42', '1000', NULL),
(97, 49, 'MRF-30072018-0064', 1, 'BK-27072018-CSF-0094', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', NULL, '0', '1.01', NULL, '00XXX', NULL, NULL, NULL, '2018-07-31', NULL, NULL, 'create', '2018-07-30 07:07:01', '2018-07-30 07:07:01', '1000', NULL),
(98, 49, 'MRF-30072018-0064', 1, 'BK-27072018-CSF-0094', '05-OST2LHTCR001X-02', '2L.SLT-TA.001', 'EG L CN 175/96A', NULL, '0', '.05', NULL, NULL, NULL, NULL, NULL, '2018-07-31', NULL, NULL, 'create', '2018-07-30 07:07:02', '2018-07-30 07:07:02', '1000', NULL),
(99, 49, 'MRF-30072018-0064', 1, 'BK-27072018-CSF-0094', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', NULL, '0', '0.3', NULL, 'DARK KHAKI,NAVY', NULL, NULL, NULL, '2018-07-31', NULL, NULL, 'create', '2018-07-30 07:07:02', '2018-07-30 07:07:02', '1000', NULL),
(100, 49, 'MRF-07082018-0067', 2, 'BK-27072018-CD-0096', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', NULL, '0', '1.01', NULL, '00XXX', NULL, NULL, NULL, '2018-08-22', NULL, NULL, 'create', '2018-08-07 00:26:36', '2018-08-07 00:26:36', '350', NULL),
(101, 49, 'MRF-07082018-0067', 2, 'BK-27072018-CD-0096', 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS,ANTIQUE BRASS', NULL, '0', '0.3', NULL, 'DARK KHAKI,NAVY', NULL, NULL, NULL, '2018-08-22', NULL, NULL, 'create', '2018-08-07 00:26:36', '2018-08-07 00:26:36', '350', NULL),
(102, 49, 'MRF-07082018-0069', 2, 'BK-07082018-CSF-0097', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', NULL, '500', '1.1', NULL, '00XXX', NULL, '2018-08-06', '41524', '2018-08-06', '4152415', NULL, 'create', '2018-08-07 00:31:45', '2018-08-07 00:31:45', '500', NULL),
(103, 49, 'MRF-07082018-0070', 2, 'BK-07082018-CSF-0097', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'SSS', NULL, '491', '1.1', NULL, '00XXX', NULL, '2018-08-06', '41524', '2018-08-16', '4152415', NULL, 'create', '2018-08-07 02:32:37', '2018-08-07 02:32:37', '9', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Mxp_multipleChallan`
--

CREATE TABLE `Mxp_multipleChallan` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `challan_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `checking_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bill_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `oss` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `style` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `party_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_buyer` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attention_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `incrementValue` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Mxp_multipleChallan`
--

INSERT INTO `Mxp_multipleChallan` (`id`, `user_id`, `challan_id`, `checking_id`, `bill_id`, `erp_code`, `item_code`, `oss`, `style`, `item_size`, `quantity`, `unit_price`, `total_price`, `party_id`, `name_buyer`, `name`, `sort_name`, `address`, `attention_invoice`, `mobile_invoice`, `incrementValue`, `status`, `created_at`, `updated_at`) VALUES
(41, 49, 'CHA-20180705--001', 'CHK-20180705--001', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M', '10,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '001', 'create', '2018-07-05 06:18:27', '2018-07-05 06:18:27'),
(42, 49, 'CHA-20180705--001', 'CHK-20180705--001', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '10,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '001', 'create', '2018-07-05 06:18:28', '2018-07-05 06:18:28'),
(43, 49, 'CHA-20180706--002', 'CHK-20180706--002', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '10,12,13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '002', 'create', '2018-07-06 06:18:46', '2018-07-06 06:18:46'),
(44, 49, 'CHA-20180706--003', 'CHK-20180706--003', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '10,8,17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '003', 'create', '2018-07-06 06:19:12', '2018-07-06 06:19:12'),
(45, 49, 'CHA-20180706--004', 'CHK-20180706--004', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '0,10,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '004', 'create', '2018-07-06 06:19:35', '2018-07-06 06:19:35'),
(46, 49, 'CHA-20180707--005', 'CHK-20180707--005', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M', '10,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '005', 'create', '2018-07-06 22:25:40', '2018-07-06 22:25:40'),
(47, 49, 'CHA-20180707--005', 'CHK-20180707--005', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '10,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '005', 'create', '2018-07-06 22:25:40', '2018-07-06 22:25:40'),
(48, 49, 'CHA-20180707--006', 'CHK-20180707--006', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A', '200', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '006', 'create', '2018-07-07 00:06:10', '2018-07-07 00:06:10'),
(49, 49, 'CHA-20180707--006', 'CHK-20180707--006', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '1000,300', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '006', 'create', '2018-07-07 00:06:10', '2018-07-07 00:06:10'),
(50, 49, 'CHA-20180709--007', 'CHK-20180709--007', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '007', 'create', '2018-07-09 02:19:37', '2018-07-09 02:19:37'),
(51, 49, 'CHA-20180709--007', 'CHK-20180709--007', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '1000,300', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '007', 'create', '2018-07-09 02:19:37', '2018-07-09 02:19:37'),
(52, 49, 'CHA-20180709--008', 'CHK-20180709--008', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '008', 'create', '2018-07-09 02:21:15', '2018-07-09 02:21:15'),
(53, 49, 'CHA-20180709--008', 'CHK-20180709--008', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '1000,300', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '008', 'create', '2018-07-09 02:21:15', '2018-07-09 02:21:15'),
(54, 49, 'CHA-20180709--009', 'CHK-20180709--009', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '009', 'create', '2018-07-09 02:21:47', '2018-07-09 02:21:47'),
(55, 49, 'CHA-20180709--009', 'CHK-20180709--009', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '1000,300', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '009', 'create', '2018-07-09 02:21:47', '2018-07-09 02:21:47'),
(56, 49, 'CHA-20180709--010', 'CHK-20180709--010', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M', '120,130', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '010', 'create', '2018-07-09 02:28:39', '2018-07-09 02:28:39'),
(57, 49, 'CHA-20180709--010', 'CHK-20180709--010', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '100,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '010', 'create', '2018-07-09 02:28:39', '2018-07-09 02:28:39'),
(58, 49, 'M-CHA-09072018--0023', NULL, NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M', '60,70', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-09 02:38:38', '2018-07-09 02:38:38'),
(59, 49, 'M-CHA-09072018--0023', NULL, NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '40,50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-09 02:38:38', '2018-07-09 02:38:38'),
(60, 49, 'M-CHA-09072018--0023', NULL, NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M', '60,70', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-09 02:40:57', '2018-07-09 02:40:57'),
(61, 49, 'M-CHA-09072018--0023', NULL, NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '40,50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-09 02:40:57', '2018-07-09 02:40:57'),
(62, 49, 'M-CHA-09072018--0023', NULL, NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M', '60,70', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-09 02:43:31', '2018-07-09 02:43:31'),
(63, 49, 'M-CHA-09072018--0023', NULL, NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '40,50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-09 02:43:31', '2018-07-09 02:43:31'),
(64, 49, 'M-CHA-09072018--0023', NULL, NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU M CN 170/92M,EU M CN 170/92M', '10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-09 02:44:22', '2018-07-09 02:44:22'),
(65, 49, 'M-CHA-09072018--0025', NULL, NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF M CN 170/92M,EF L CN 175/96A,EF S CN 165/88A', '11,11,11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-09 02:46:41', '2018-07-09 02:46:41'),
(66, 49, 'M-CHA-09072018--0025', NULL, NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '1,1,1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-09 02:46:41', '2018-07-09 02:46:41'),
(67, 49, 'M-CHA-09072018-ACL-0027', NULL, NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF M CN 170/92M,EF L CN 175/96A,EF S CN 165/88A', '11,11,11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-09 02:48:25', '2018-07-09 02:48:25'),
(68, 49, 'M-CHA-09072018-ACL-0027', NULL, NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '1,1,1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-09 02:48:25', '2018-07-09 02:48:25'),
(69, 49, 'M-CHA-10072018-CSF-0029', NULL, NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A', '12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-10 06:54:22', '2018-07-10 06:54:22'),
(70, 49, 'M-CHA-11072018-CSF-0030', 'M-CHA-11072018-CSF-0030', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A,EU XS CN 160/84A', '110,120,130,140', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:25:16', '2018-07-11 05:25:16'),
(71, 49, 'M-CHA-11072018-CSF-0031', 'M-CHA-11072018-CSF-0031', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M', '20,30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:55:55', '2018-07-11 05:55:55'),
(72, 49, 'M-CHA-11072018-CSF-0031', 'M-CHA-11072018-CSF-0031', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '10,20,30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-11 05:55:55', '2018-07-11 05:55:55'),
(73, 49, 'M-CHA-12072018-CSF-0033', 'M-CHA-12072018-CSF-0033', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M', '110,120', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-12 01:58:14', '2018-07-12 01:58:14'),
(74, 49, 'M-CHA-12072018-CSF-0033', 'M-CHA-12072018-CSF-0033', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '110,120,130', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-12 01:58:14', '2018-07-12 01:58:14'),
(75, 49, 'M-CHA-13072018-CSF-0035', 'INVO-13072018-CSF-0011', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M,EF S CN 165/88A', '1,2,3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-13 05:16:54', '2018-07-13 05:16:54'),
(76, 49, 'M-CHA-13072018-CSF-0035', 'INVO-13072018-CSF-0011', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '4,5,6', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-13 05:16:54', '2018-07-13 05:16:54'),
(77, 49, 'M-CHA-13072018-CSF-0037', 'INVO-13072018-CSF-0036', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '10,20,30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-13 09:31:20', '2018-07-13 09:31:20'),
(78, 49, 'M-CHA-13072018-CSF-0038', 'INVO-13072018-CSF-0036', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '20,20,20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-13 09:31:50', '2018-07-13 09:31:50'),
(79, 49, 'M-CHA-13072018-CSF-0039', 'BK-13072018-CSF-0037', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A,EF L CN 175/96A3', '111,180', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-13 09:59:06', '2018-07-13 09:59:06'),
(80, 49, 'M-CHA-13072018-CSF-0039', 'BK-13072018-CSF-0037', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '89', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-13 09:59:06', '2018-07-13 09:59:06'),
(81, 49, 'M-CHA-24072018-CD-0041', 'BK-24072018-CD-0044', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '500,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-24 02:25:13', '2018-07-24 02:25:13'),
(82, 49, 'M-CHA-24072018-CD-0041', 'BK-24072018-CD-0044', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '250', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-24 02:25:13', '2018-07-24 02:25:13'),
(83, 49, 'M-CHA-24072018-CD-0043', 'BK-24072018-CD-0046', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '500,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-24 02:30:12', '2018-07-24 02:30:12'),
(84, 49, 'M-CHA-24072018-CD-0043', 'BK-24072018-CD-0046', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-24 02:30:12', '2018-07-24 02:30:12'),
(85, 49, 'M-CHA-24072018-CD-0045', 'BK-24072018-CD-0046', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '200,400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-24 02:32:13', '2018-07-24 02:32:13'),
(86, 49, 'M-CHA-24072018-CD-0045', 'BK-24072018-CD-0046', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '200', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-24 02:32:13', '2018-07-24 02:32:13'),
(87, 49, 'M-CHA-25072018-rga-0047', 'BK-24072018-rga-0047', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '700,550', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:02:59', '2018-07-25 04:02:59'),
(88, 49, 'M-CHA-25072018-rga-0047', 'BK-24072018-rga-0047', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:02:59', '2018-07-25 04:02:59'),
(89, 49, 'M-CHA-25072018-rga-0049', 'BK-24072018-rga-0047', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '700,550', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:04:47', '2018-07-25 04:04:47'),
(90, 49, 'M-CHA-25072018-rga-0049', 'BK-24072018-rga-0047', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:04:47', '2018-07-25 04:04:47'),
(91, 49, 'M-CHA-25072018-rga-0051', 'BK-24072018-rga-0047', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '700,550', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:05:13', '2018-07-25 04:05:13'),
(92, 49, 'M-CHA-25072018-rga-0051', 'BK-24072018-rga-0047', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:05:13', '2018-07-25 04:05:13'),
(93, 49, 'M-CHA-25072018-rga-0053', 'BK-24072018-rga-0047', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '700,550', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:05:37', '2018-07-25 04:05:37'),
(94, 49, 'M-CHA-25072018-rga-0053', 'BK-24072018-rga-0047', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:05:37', '2018-07-25 04:05:37'),
(95, 49, 'M-CHA-25072018-rga-0055', 'BK-24072018-rga-0047', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '700,550', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:07:51', '2018-07-25 04:07:51'),
(96, 49, 'M-CHA-25072018-rga-0055', 'BK-24072018-rga-0047', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:07:51', '2018-07-25 04:07:51'),
(97, 49, 'M-CHA-25072018-rga-0057', 'BK-24072018-rga-0047', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '700,550', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:14:52', '2018-07-25 04:14:52'),
(98, 49, 'M-CHA-25072018-rga-0057', 'BK-24072018-rga-0047', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:14:52', '2018-07-25 04:14:52'),
(99, 49, 'M-CHA-25072018-rga-0059', 'BK-24072018-CD-0044', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:41:51', '2018-07-25 04:41:51'),
(100, 49, 'M-CHA-25072018-rga-0059', 'BK-24072018-CD-0046', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:41:51', '2018-07-25 04:41:51'),
(101, 49, 'M-CHA-25072018-rga-0059', 'BK-24072018-rga-0047', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '670,520', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:41:51', '2018-07-25 04:41:51'),
(102, 49, 'M-CHA-25072018-rga-0059', 'BK-24072018-CD-0044', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:41:51', '2018-07-25 04:41:51'),
(103, 49, 'M-CHA-25072018-rga-0059', 'BK-24072018-CD-0046', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:41:51', '2018-07-25 04:41:51'),
(104, 49, 'M-CHA-25072018-rga-0059', 'BK-24072018-rga-0047', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '420', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:41:52', '2018-07-25 04:41:52'),
(105, 49, 'M-CHA-25072018-rga-0065', 'BK-24072018-CD-0044', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:44:54', '2018-07-25 04:44:54'),
(106, 49, 'M-CHA-25072018-rga-0065', 'BK-24072018-CD-0046', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:44:54', '2018-07-25 04:44:54'),
(107, 49, 'M-CHA-25072018-rga-0065', 'BK-24072018-rga-0047', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '660,510', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:44:54', '2018-07-25 04:44:54'),
(108, 49, 'M-CHA-25072018-rga-0065', 'BK-24072018-CD-0044', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:44:54', '2018-07-25 04:44:54'),
(109, 49, 'M-CHA-25072018-rga-0065', 'BK-24072018-CD-0046', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:44:54', '2018-07-25 04:44:54'),
(110, 49, 'M-CHA-25072018-rga-0065', 'BK-24072018-rga-0047', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '410', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:44:54', '2018-07-25 04:44:54'),
(111, 49, 'M-CHA-25072018-rga-0071', 'BK-24072018-CD-0044', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:11', '2018-07-25 04:45:11'),
(112, 49, 'M-CHA-25072018-rga-0071', 'BK-24072018-CD-0046', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:11', '2018-07-25 04:45:11'),
(113, 49, 'M-CHA-25072018-rga-0071', 'BK-24072018-rga-0047', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '650,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:11', '2018-07-25 04:45:11'),
(114, 49, 'M-CHA-25072018-rga-0071', 'BK-24072018-CD-0044', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:11', '2018-07-25 04:45:11'),
(115, 49, 'M-CHA-25072018-rga-0071', 'BK-24072018-CD-0046', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:11', '2018-07-25 04:45:11'),
(116, 49, 'M-CHA-25072018-rga-0071', 'BK-24072018-rga-0047', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:11', '2018-07-25 04:45:11'),
(117, 49, 'M-CHA-25072018-rga-0077', 'BK-24072018-CD-0044', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:28', '2018-07-25 04:45:28'),
(118, 49, 'M-CHA-25072018-rga-0077', 'BK-24072018-CD-0046', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:28', '2018-07-25 04:45:28'),
(119, 49, 'M-CHA-25072018-rga-0077', 'BK-24072018-rga-0047', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '640,490', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:28', '2018-07-25 04:45:28'),
(120, 49, 'M-CHA-25072018-rga-0077', 'BK-24072018-CD-0044', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:28', '2018-07-25 04:45:28'),
(121, 49, 'M-CHA-25072018-rga-0077', 'BK-24072018-CD-0046', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:28', '2018-07-25 04:45:28'),
(122, 49, 'M-CHA-25072018-rga-0077', 'BK-24072018-rga-0047', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '390', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 04:45:28', '2018-07-25 04:45:28'),
(123, 49, 'M-CHA-25072018-CSF-0083', 'BK-25072018-CSF-0054', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:11:30', '2018-07-25 05:11:30'),
(124, 49, 'M-CHA-25072018-CSF-0083', 'BK-25072018-CSF-0055', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '500,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:11:30', '2018-07-25 05:11:30'),
(125, 49, 'M-CHA-25072018-CSF-0085', 'BK-25072018-CSF-0054', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:22:09', '2018-07-25 05:22:09'),
(126, 49, 'M-CHA-25072018-CSF-0085', 'BK-25072018-CSF-0055', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:22:09', '2018-07-25 05:22:09'),
(127, 49, 'M-CHA-25072018-CD-0087', 'BK-25072018-CD-0056', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '50,100,50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:28:24', '2018-07-25 05:28:24'),
(128, 49, 'M-CHA-25072018-CD-0087', 'BK-25072018-CD-0057', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:28:24', '2018-07-25 05:28:24'),
(129, 49, 'M-CHA-25072018-CD-0087', 'BK-25072018-CD-0056', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '50,100,50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:28:24', '2018-07-25 05:28:24'),
(130, 49, 'M-CHA-25072018-CD-0087', 'BK-25072018-CD-0057', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '100,100,50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:28:24', '2018-07-25 05:28:24'),
(131, 49, 'M-CHA-25072018-CD-0091', 'BK-25072018-CD-0056', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,100,50,100,0,100,50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:29:07', '2018-07-25 05:29:07'),
(132, 49, 'M-CHA-25072018-CD-0091', 'BK-25072018-CD-0057', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:29:07', '2018-07-25 05:29:07'),
(133, 49, 'M-CHA-25072018-CD-0091', 'BK-25072018-CD-0056', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '0,100,50,100,0,100,50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:29:07', '2018-07-25 05:29:07'),
(134, 49, 'M-CHA-25072018-CD-0091', 'BK-25072018-CD-0057', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '100,100,50,100,50,100,50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:29:07', '2018-07-25 05:29:07'),
(135, 49, 'M-CHA-25072018-CD-0095', 'BK-25072018-CD-0056', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,100,50,100,0,100,50,100,0,100,50,100,0,100,50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:29:49', '2018-07-25 05:29:49'),
(136, 49, 'M-CHA-25072018-CD-0095', 'BK-25072018-CD-0057', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:29:49', '2018-07-25 05:29:49'),
(137, 49, 'M-CHA-25072018-CD-0095', 'BK-25072018-CD-0056', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '0,100,50,100,0,100,50,100,0,100,50,100,0,100,50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:29:50', '2018-07-25 05:29:50'),
(138, 49, 'M-CHA-25072018-CD-0095', 'BK-25072018-CD-0057', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '50,100,50,100,50,100,50,100,50,100,50,100,50,100,50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:29:50', '2018-07-25 05:29:50'),
(139, 49, 'M-CHA-25072018-CD-0099', 'BK-25072018-CD-0058', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:44:36', '2018-07-25 05:44:36'),
(140, 49, 'M-CHA-25072018-CD-0099', 'BK-25072018-CD-0058', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:44:36', '2018-07-25 05:44:36'),
(141, 49, 'M-CHA-25072018-CD-0099', 'BK-25072018-CD-0059', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '1000,1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:44:36', '2018-07-25 05:44:36'),
(142, 49, 'M-CHA-25072018-CD-0099', 'BK-25072018-CD-0059', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:44:36', '2018-07-25 05:44:36'),
(143, 49, 'M-CHA-25072018-CD-0103', 'BK-25072018-CD-0058', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '490', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:46:11', '2018-07-25 05:46:11'),
(144, 49, 'M-CHA-25072018-CD-0103', 'BK-25072018-CD-0058', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:46:12', '2018-07-25 05:46:12'),
(145, 49, 'M-CHA-25072018-CD-0103', 'BK-25072018-CD-0059', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '980,980', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:46:12', '2018-07-25 05:46:12'),
(146, 49, 'M-CHA-25072018-CD-0103', 'BK-25072018-CD-0059', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '490', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:46:12', '2018-07-25 05:46:12'),
(147, 49, 'M-CHA-25072018-CD-0107', 'BK-25072018-CD-0058', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '480', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:57:14', '2018-07-25 05:57:14'),
(148, 49, 'M-CHA-25072018-CD-0107', 'BK-25072018-CD-0058', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:57:14', '2018-07-25 05:57:14'),
(149, 49, 'M-CHA-25072018-CD-0107', 'BK-25072018-CD-0059', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '960,960', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:57:14', '2018-07-25 05:57:14'),
(150, 49, 'M-CHA-25072018-CD-0107', 'BK-25072018-CD-0059', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '480', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 05:57:14', '2018-07-25 05:57:14'),
(151, 49, 'M-CHA-25072018-CD-0111', 'BK-25072018-CD-0058', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:04:31', '2018-07-25 06:04:31'),
(152, 49, 'M-CHA-25072018-CD-0111', 'BK-25072018-CD-0058', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:04:31', '2018-07-25 06:04:31'),
(153, 49, 'M-CHA-25072018-CD-0111', 'BK-25072018-CD-0059', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:04:31', '2018-07-25 06:04:31'),
(154, 49, 'M-CHA-25072018-CD-0111', 'BK-25072018-CD-0059', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:04:31', '2018-07-25 06:04:31'),
(155, 49, 'M-CHA-25072018-CD-0115', 'BK-25072018-CD-0058', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:05:44', '2018-07-25 06:05:44'),
(156, 49, 'M-CHA-25072018-CD-0115', 'BK-25072018-CD-0058', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '60', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:05:44', '2018-07-25 06:05:44'),
(157, 49, 'M-CHA-25072018-CD-0115', 'BK-25072018-CD-0059', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '60', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:05:44', '2018-07-25 06:05:44'),
(158, 49, 'M-CHA-25072018-CD-0115', 'BK-25072018-CD-0059', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:05:44', '2018-07-25 06:05:44'),
(159, 49, 'M-CHA-25072018-CSF-0119', 'BK-25072018-CSF-0060', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '190,200', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:42:09', '2018-07-25 06:42:09'),
(160, 49, 'M-CHA-25072018-CSF-0119', 'BK-25072018-CSF-0060', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '95,104,113', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:42:09', '2018-07-25 06:42:09'),
(161, 49, 'M-CHA-25072018-CSF-0121', 'BK-25072018-CSF-0060', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '180,190', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:43:37', '2018-07-25 06:43:37'),
(162, 49, 'M-CHA-25072018-CSF-0121', 'BK-25072018-CSF-0060', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M,EU S CN 165/88A', '90,98,106', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 06:43:37', '2018-07-25 06:43:37'),
(163, 49, 'M-CHA-25072018-CD-0123', 'BK-25072018-CD-0061', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU L CN 175/96A,EU M CN 170/92M', '150,200,300,250,200,300,100,200,300', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 07:08:14', '2018-07-25 07:08:14'),
(164, 49, 'M-CHA-25072018-CD-0123', 'BK-25072018-ACL-0062', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '100,120,100,120', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 07:08:14', '2018-07-25 07:08:14'),
(165, 49, 'M-CHA-25072018-CD-0123', 'BK-25072018-CD-0061', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '250,250', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 07:08:14', '2018-07-25 07:08:14'),
(166, 49, 'M-CHA-25072018-CD-0126', 'BK-25072018-CD-0061', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU L CN 175/96A,EU M CN 170/92M', '100,200,300,250,200,300,100,200,300,150,200,300,250,200,300,100,200,300,130,200,300,250,200,300,100,200,300', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 07:17:10', '2018-07-25 07:17:10'),
(167, 49, 'M-CHA-25072018-CD-0126', 'BK-25072018-ACL-0062', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '100,120,100,120,100,120,100,120', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 07:17:10', '2018-07-25 07:17:10'),
(168, 49, 'M-CHA-25072018-CD-0126', 'BK-25072018-CD-0061', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '200,200', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 07:17:10', '2018-07-25 07:17:10'),
(169, 49, 'M-CHA-25072018-CD-0129', 'BK-25072018-CD-0061', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU L CN 175/96A,EU M CN 170/92M', '50,200,300,250,200,300,100,200,300,150,200,300,250,200,300,100,200,300,130,200,300,250,200,300,100,200,300,100,200,300,250,200,300,100,200,300,150,200,300,250,200,300,100,200,300,130,200,300,250,200,300,100,200,300,0,200,300,250,200,300,100,200,300,150,20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 07:21:57', '2018-07-25 07:21:57'),
(170, 49, 'M-CHA-25072018-CD-0129', 'BK-25072018-ACL-0062', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU M CN 170/92M', '100,120,100,120,100,120,100,120,100,120,100,120,100,120,100,120', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 07:21:57', '2018-07-25 07:21:57'),
(171, 49, 'M-CHA-25072018-CD-0129', 'BK-25072018-CD-0061', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '150,150', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-25 07:21:57', '2018-07-25 07:21:57'),
(172, 49, 'M-CHA-26072018-CSF-0132', 'BK-26072018-CSF-0063', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,SSS,WWWW', '800,1000,1000,900,900,1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 00:02:42', '2018-07-26 00:02:42'),
(173, 49, 'M-CHA-26072018-CSF-0132', 'BK-26072018-CSF-0065', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 00:02:42', '2018-07-26 00:02:42'),
(174, 49, 'M-CHA-26072018-CSF-0132', 'BK-26072018-CSF-0065', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '900,900', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 00:02:42', '2018-07-26 00:02:42'),
(175, 49, 'M-CHA-26072018-CSF-0135', 'BK-26072018-CSF-0076', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '500,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 03:09:41', '2018-07-26 03:09:41'),
(176, 49, 'M-CHA-26072018-CSF-0136', 'BK-26072018-CSF-0076', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '300,300', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 03:10:14', '2018-07-26 03:10:14'),
(177, 49, 'M-CHA-26072018-CSF-0137', 'BK-26072018-CSF-0076', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 03:23:01', '2018-07-26 03:23:01'),
(178, 49, 'M-CHA-26072018-CSF-0138', 'BK-26072018-CSF-0076', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 03:23:22', '2018-07-26 03:23:22'),
(179, 49, 'M-CHA-26072018-CSF-0139', 'BK-26072018-CSF-0076', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '90,90', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 03:26:48', '2018-07-26 03:26:48'),
(180, 49, 'M-CHA-26072018-CSF-0140', 'BK-26072018-CSF-0077', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:12:20', '2018-07-26 04:12:20'),
(181, 49, 'M-CHA-26072018-CSF-0140', 'BK-26072018-CSF-0078', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,SSS', '1000,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:12:20', '2018-07-26 04:12:20'),
(182, 49, 'M-CHA-26072018-CSF-0140', 'BK-26072018-CSF-0077', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L CN 175/96A', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:12:20', '2018-07-26 04:12:20'),
(183, 49, 'M-CHA-26072018-CSF-0140', 'BK-26072018-CSF-0078', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:12:20', '2018-07-26 04:12:20'),
(184, 49, 'M-CHA-26072018-CSF-0140', 'BK-26072018-CSF-0079', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L KN 175/96,EG L CN 175/96A', '500,1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:12:20', '2018-07-26 04:12:20'),
(185, 49, 'M-CHA-26072018-CSF-0140', 'BK-26072018-CSF-0077', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:12:20', '2018-07-26 04:12:20'),
(186, 49, 'M-CHA-26072018-CSF-0140', 'BK-26072018-CSF-0079', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:12:20', '2018-07-26 04:12:20'),
(187, 49, 'M-CHA-26072018-CSF-0147', 'BK-26072018-CSF-0077', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,250', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:34:57', '2018-07-26 04:34:57'),
(188, 49, 'M-CHA-26072018-CSF-0147', 'BK-26072018-CSF-0078', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,SSS', '500,250', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:34:58', '2018-07-26 04:34:58'),
(189, 49, 'M-CHA-26072018-CSF-0147', 'BK-26072018-CSF-0077', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L CN 175/96A', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:34:58', '2018-07-26 04:34:58'),
(190, 49, 'M-CHA-26072018-CSF-0147', 'BK-26072018-CSF-0078', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:34:58', '2018-07-26 04:34:58'),
(191, 49, 'M-CHA-26072018-CSF-0147', 'BK-26072018-CSF-0079', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L KN 175/96,EG L CN 175/96A', '250,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:34:58', '2018-07-26 04:34:58'),
(192, 49, 'M-CHA-26072018-CSF-0147', 'BK-26072018-CSF-0077', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:34:58', '2018-07-26 04:34:58'),
(193, 49, 'M-CHA-26072018-CSF-0147', 'BK-26072018-CSF-0079', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '250', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:34:58', '2018-07-26 04:34:58'),
(194, 49, 'M-CHA-26072018-CSF-0154', 'BK-26072018-CSF-0077', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:55:47', '2018-07-26 04:55:47'),
(195, 49, 'M-CHA-26072018-CSF-0154', 'BK-26072018-CSF-0078', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,SSS', '-400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:55:47', '2018-07-26 04:55:47'),
(196, 49, 'M-CHA-26072018-CSF-0154', 'BK-26072018-CSF-0077', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L CN 175/96A', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:55:47', '2018-07-26 04:55:47'),
(197, 49, 'M-CHA-26072018-CSF-0154', 'BK-26072018-CSF-0078', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '-400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:55:47', '2018-07-26 04:55:47'),
(198, 49, 'M-CHA-26072018-CSF-0154', 'BK-26072018-CSF-0079', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L KN 175/96,EG L CN 175/96A', '-200', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:55:47', '2018-07-26 04:55:47'),
(199, 49, 'M-CHA-26072018-CSF-0154', 'BK-26072018-CSF-0077', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:55:47', '2018-07-26 04:55:47'),
(200, 49, 'M-CHA-26072018-CSF-0154', 'BK-26072018-CSF-0079', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '-200', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:55:47', '2018-07-26 04:55:47'),
(201, 49, 'M-CHA-26072018-CSF-0161', 'BK-26072018-CSF-0077', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:56:51', '2018-07-26 04:56:51'),
(202, 49, 'M-CHA-26072018-CSF-0161', 'BK-26072018-CSF-0078', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,SSS', '-350', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:56:51', '2018-07-26 04:56:51'),
(203, 49, 'M-CHA-26072018-CSF-0161', 'BK-26072018-CSF-0077', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L CN 175/96A', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:56:52', '2018-07-26 04:56:52'),
(204, 49, 'M-CHA-26072018-CSF-0161', 'BK-26072018-CSF-0078', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '-350', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:56:52', '2018-07-26 04:56:52'),
(205, 49, 'M-CHA-26072018-CSF-0161', 'BK-26072018-CSF-0079', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L KN 175/96,EG L CN 175/96A', '-150', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:56:52', '2018-07-26 04:56:52'),
(206, 49, 'M-CHA-26072018-CSF-0161', 'BK-26072018-CSF-0077', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:56:52', '2018-07-26 04:56:52'),
(207, 49, 'M-CHA-26072018-CSF-0161', 'BK-26072018-CSF-0079', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '-175', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 04:56:52', '2018-07-26 04:56:52'),
(208, 49, 'M-CHA-26072018-CSF-0168', 'BK-26072018-CSF-0077', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:03:16', '2018-07-26 05:03:16'),
(209, 49, 'M-CHA-26072018-CSF-0168', 'BK-26072018-CSF-0078', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,SSS', '0,15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:03:16', '2018-07-26 05:03:16'),
(210, 49, 'M-CHA-26072018-CSF-0168', 'BK-26072018-CSF-0077', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L CN 175/96A', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:03:16', '2018-07-26 05:03:16'),
(211, 49, 'M-CHA-26072018-CSF-0168', 'BK-26072018-CSF-0078', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:03:16', '2018-07-26 05:03:16'),
(212, 49, 'M-CHA-26072018-CSF-0168', 'BK-26072018-CSF-0079', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L KN 175/96,EG L CN 175/96A', '10,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:03:16', '2018-07-26 05:03:16'),
(213, 49, 'M-CHA-26072018-CSF-0168', 'BK-26072018-CSF-0077', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:03:16', '2018-07-26 05:03:16'),
(214, 49, 'M-CHA-26072018-CSF-0168', 'BK-26072018-CSF-0079', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:03:16', '2018-07-26 05:03:16'),
(215, 49, 'M-CHA-26072018-CSF-0175', 'BK-26072018-CSF-0076', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:06:16', '2018-07-26 05:06:16'),
(216, 49, 'M-CHA-26072018-CSF-0175', 'BK-26072018-CSF-0077', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:06:16', '2018-07-26 05:06:16'),
(217, 49, 'M-CHA-26072018-CSF-0175', 'BK-26072018-CSF-0078', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,SSS', '0,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:06:16', '2018-07-26 05:06:16'),
(218, 49, 'M-CHA-26072018-CSF-0175', 'BK-26072018-CSF-0077', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L CN 175/96A', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:06:16', '2018-07-26 05:06:16'),
(219, 49, 'M-CHA-26072018-CSF-0175', 'BK-26072018-CSF-0078', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:06:16', '2018-07-26 05:06:16'),
(220, 49, 'M-CHA-26072018-CSF-0175', 'BK-26072018-CSF-0079', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L KN 175/96,EG L CN 175/96A', '5,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:06:16', '2018-07-26 05:06:16'),
(221, 49, 'M-CHA-26072018-CSF-0175', 'BK-26072018-CSF-0077', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:06:16', '2018-07-26 05:06:16'),
(222, 49, 'M-CHA-26072018-CSF-0175', 'BK-26072018-CSF-0079', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:06:16', '2018-07-26 05:06:16');
INSERT INTO `Mxp_multipleChallan` (`id`, `user_id`, `challan_id`, `checking_id`, `bill_id`, `erp_code`, `item_code`, `oss`, `style`, `item_size`, `quantity`, `unit_price`, `total_price`, `party_id`, `name_buyer`, `name`, `sort_name`, `address`, `attention_invoice`, `mobile_invoice`, `incrementValue`, `status`, `created_at`, `updated_at`) VALUES
(223, 49, 'M-CHA-26072018-CSF-0183', 'BK-26072018-CSF-0076', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:07:40', '2018-07-26 05:07:40'),
(224, 49, 'M-CHA-26072018-CSF-0183', 'BK-26072018-CSF-0077', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:07:40', '2018-07-26 05:07:40'),
(225, 49, 'M-CHA-26072018-CSF-0183', 'BK-26072018-CSF-0078', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,SSS', '5,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:07:40', '2018-07-26 05:07:40'),
(226, 49, 'M-CHA-26072018-CSF-0183', 'BK-26072018-CSF-0077', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L CN 175/96A', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:07:40', '2018-07-26 05:07:40'),
(227, 49, 'M-CHA-26072018-CSF-0183', 'BK-26072018-CSF-0078', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3', '20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:07:40', '2018-07-26 05:07:40'),
(228, 49, 'M-CHA-26072018-CSF-0183', 'BK-26072018-CSF-0079', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L KN 175/96,EG L CN 175/96A', '5,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:07:40', '2018-07-26 05:07:40'),
(229, 49, 'M-CHA-26072018-CSF-0183', 'BK-26072018-CSF-0077', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:07:40', '2018-07-26 05:07:40'),
(230, 49, 'M-CHA-26072018-CSF-0183', 'BK-26072018-CSF-0079', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:07:40', '2018-07-26 05:07:40'),
(231, 49, 'M-CHA-26072018-CSF-0191', 'BK-26072018-CSF-0080', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:21:05', '2018-07-26 05:21:05'),
(232, 49, 'M-CHA-26072018-CSF-0192', 'BK-26072018-CSF-0080', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '980,980', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:21:51', '2018-07-26 05:21:51'),
(233, 49, 'M-CHA-26072018-CSF-0193', 'BK-26072018-CSF-0080', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '970,970', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:22:18', '2018-07-26 05:22:18'),
(234, 49, 'M-CHA-26072018-CSF-0194', 'INVO-23062018-Mi-0001', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,DARK STEEL', '10,10,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:42:05', '2018-07-26 05:42:05'),
(235, 49, 'M-CHA-26072018-CSF-0195', 'BK-26072018-CSF-0081', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L CN 175/96A,EG L KN 175/96', '10,10,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:43:51', '2018-07-26 05:43:51'),
(236, 49, 'M-CHA-26072018-CSF-0196', 'BK-26072018-CSF-0081', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L CN 175/96A,EG L KN 175/96', '10,10,10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:45:39', '2018-07-26 05:45:39'),
(237, 49, 'M-CHA-26072018-CSF-0197', 'BK-26072018-CSF-0082', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L KN 175/96', '500,1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:50:47', '2018-07-26 05:50:47'),
(238, 49, 'M-CHA-26072018-CSF-0197', 'BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A,EG L KN 175/96', '500,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:50:47', '2018-07-26 05:50:47'),
(239, 49, 'M-CHA-26072018-CSF-0197', 'BK-26072018-CSF-0082', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:50:47', '2018-07-26 05:50:47'),
(240, 49, 'M-CHA-26072018-CSF-0197', 'BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:50:47', '2018-07-26 05:50:47'),
(241, 49, 'M-CHA-26072018-CSF-0201', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L KN 175/96', '50,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:59:00', '2018-07-26 05:59:00'),
(242, 49, 'M-CHA-26072018-CSF-0201', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A,EG L KN 175/96', '50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:59:00', '2018-07-26 05:59:00'),
(243, 49, 'M-CHA-26072018-CSF-0201', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:59:00', '2018-07-26 05:59:00'),
(244, 49, 'M-CHA-26072018-CSF-0201', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 05:59:00', '2018-07-26 05:59:00'),
(245, 49, 'M-CHA-26072018-CSF-0205', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L KN 175/96', '50,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:01:41', '2018-07-26 06:01:41'),
(246, 49, 'M-CHA-26072018-CSF-0205', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A,EG L KN 175/96', '50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:01:41', '2018-07-26 06:01:41'),
(247, 49, 'M-CHA-26072018-CSF-0205', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:01:41', '2018-07-26 06:01:41'),
(248, 49, 'M-CHA-26072018-CSF-0205', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:01:41', '2018-07-26 06:01:41'),
(249, 49, 'M-CHA-26072018-CSF-0209', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L KN 175/96', '50,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:10:11', '2018-07-26 06:10:11'),
(250, 49, 'M-CHA-26072018-CSF-0209', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A,EG L KN 175/96', '100,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:10:11', '2018-07-26 06:10:11'),
(251, 49, 'M-CHA-26072018-CSF-0209', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:10:11', '2018-07-26 06:10:11'),
(252, 49, 'M-CHA-26072018-CSF-0209', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:10:11', '2018-07-26 06:10:11'),
(253, 49, 'M-CHA-26072018-CSF-0213', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L KN 175/96', '50,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:13:57', '2018-07-26 06:13:57'),
(254, 49, 'M-CHA-26072018-CSF-0213', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A,EG L KN 175/96', '50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:13:57', '2018-07-26 06:13:57'),
(255, 49, 'M-CHA-26072018-CSF-0213', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:13:57', '2018-07-26 06:13:57'),
(256, 49, 'M-CHA-26072018-CSF-0213', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:13:57', '2018-07-26 06:13:57'),
(257, 49, 'M-CHA-26072018-CSF-0217', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L KN 175/96', '20,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:16:36', '2018-07-26 06:16:36'),
(258, 49, 'M-CHA-26072018-CSF-0217', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A,EG L KN 175/96', '25,50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:16:36', '2018-07-26 06:16:36'),
(259, 49, 'M-CHA-26072018-CSF-0217', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:16:36', '2018-07-26 06:16:36'),
(260, 49, 'M-CHA-26072018-CSF-0217', 'BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-26 06:16:36', '2018-07-26 06:16:36'),
(261, 49, 'M-CHA-27072018-CSF-0221', 'BK-27072018-CSF-0084', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:00:51', '2018-07-27 00:00:51'),
(262, 49, 'M-CHA-27072018-CD-0222', 'BK-27072018-CD-0085', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:01:22', '2018-07-27 00:01:22'),
(263, 49, 'M-CHA-27072018-CD-0223', 'BK-27072018-CD-0086, BK-27072018-CD-0087', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '100,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:41:18', '2018-07-27 00:41:18'),
(264, 49, 'M-CHA-27072018-CD-0223', 'BK-27072018-CD-0086, BK-27072018-CD-0087', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'WWWW', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:41:18', '2018-07-27 00:41:18'),
(265, 49, 'M-CHA-27072018-CD-0225', 'BK-27072018-CD-0086, BK-27072018-CD-0087', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '900,900', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:41:41', '2018-07-27 00:41:41'),
(266, 49, 'M-CHA-27072018-CD-0225', 'BK-27072018-CD-0086, BK-27072018-CD-0087', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'WWWW', '900', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:41:41', '2018-07-27 00:41:41'),
(267, 49, 'M-CHA-27072018-CD-0227', 'BK-27072018-CD-0086, BK-27072018-CD-0087', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:46:39', '2018-07-27 00:46:39'),
(268, 49, 'M-CHA-27072018-CD-0227', 'BK-27072018-CD-0086, BK-27072018-CD-0087', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'WWWW', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:46:39', '2018-07-27 00:46:39'),
(269, 49, 'M-CHA-27072018-CSF-0229', 'BK-26072018-CSF-0081, BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L CN 175/96A,EG L KN 175/96', '900,900,900', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:58:29', '2018-07-27 00:58:29'),
(270, 49, 'M-CHA-27072018-CSF-0229', 'BK-26072018-CSF-0081, BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L KN 175/96', '180,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:58:29', '2018-07-27 00:58:29'),
(271, 49, 'M-CHA-27072018-CSF-0229', 'BK-26072018-CSF-0081, BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A,EG L KN 175/96', '225,450', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:58:29', '2018-07-27 00:58:29'),
(272, 49, 'M-CHA-27072018-CSF-0229', 'BK-26072018-CSF-0081, BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:58:29', '2018-07-27 00:58:29'),
(273, 49, 'M-CHA-27072018-CSF-0229', 'BK-26072018-CSF-0081, BK-26072018-CSF-0082, BK-26072018-CSF-0083', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '225', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 00:58:29', '2018-07-27 00:58:29'),
(274, 49, 'M-CHA-27072018-CD-0234', 'BK-27072018-CD-0085, BK-27072018-CD-0086', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 01:27:48', '2018-07-27 01:27:48'),
(275, 49, 'M-CHA-27072018-CD-0234', 'BK-27072018-CD-0085, BK-27072018-CD-0086', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS,WWWW', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 01:27:48', '2018-07-27 01:27:48'),
(276, 49, 'M-CHA-27072018-CSF-0236', 'BK-27072018-CSF-0088', NULL, '04-OST2LSLTA001X-01', '2L.SL-TA.001', NULL, NULL, 'EU L CN 175/96A,EU S CN 165/88A', '100,1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 01:37:46', '2018-07-27 01:37:46'),
(277, 49, 'M-CHA-27072018-CSF-0237', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M', '500,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 02:59:33', '2018-07-27 02:59:33'),
(278, 49, 'M-CHA-27072018-CSF-0237', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A', '1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 02:59:33', '2018-07-27 02:59:33'),
(279, 49, 'M-CHA-27072018-CSF-0237', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 02:59:33', '2018-07-27 02:59:33'),
(280, 49, 'M-CHA-27072018-CSF-0237', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 02:59:33', '2018-07-27 02:59:33'),
(281, 49, 'M-CHA-27072018-CSF-0237', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '500,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 02:59:33', '2018-07-27 02:59:33'),
(282, 49, 'M-CHA-27072018-CSF-0237', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 02:59:33', '2018-07-27 02:59:33'),
(283, 49, 'M-CHA-27072018-CSF-0237', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 02:59:33', '2018-07-27 02:59:33'),
(284, 49, 'M-CHA-27072018-CSF-0237', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L KN 175/96', '500,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 02:59:33', '2018-07-27 02:59:33'),
(285, 49, 'M-CHA-27072018-CSF-0245', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M', '50,50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:15:55', '2018-07-27 03:15:55'),
(286, 49, 'M-CHA-27072018-CSF-0245', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:15:55', '2018-07-27 03:15:55'),
(287, 49, 'M-CHA-27072018-CSF-0245', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:15:55', '2018-07-27 03:15:55'),
(288, 49, 'M-CHA-27072018-CSF-0245', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:15:55', '2018-07-27 03:15:55'),
(289, 49, 'M-CHA-27072018-CSF-0245', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '50,100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:15:55', '2018-07-27 03:15:55'),
(290, 49, 'M-CHA-27072018-CSF-0245', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:15:55', '2018-07-27 03:15:55'),
(291, 49, 'M-CHA-27072018-CSF-0245', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:15:55', '2018-07-27 03:15:55'),
(292, 49, 'M-CHA-27072018-CSF-0245', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L KN 175/96', '50,50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:15:55', '2018-07-27 03:15:55'),
(293, 49, 'M-CHA-27072018-CSF-0253', 'BK-27072018-CSF-0095', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:17:29', '2018-07-27 03:17:29'),
(294, 49, 'M-CHA-27072018-CSF-0253', 'BK-27072018-CSF-0095', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '500,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:17:29', '2018-07-27 03:17:29'),
(295, 49, 'M-CHA-27072018-CSF-0255', 'BK-27072018-CSF-0095', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:25:53', '2018-07-27 03:25:53'),
(296, 49, 'M-CHA-27072018-CSF-0255', 'BK-27072018-CSF-0095', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '50,50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:25:53', '2018-07-27 03:25:53'),
(297, 49, 'M-CHA-27072018-CSF-0257', 'BK-27072018-CSF-0095', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:31:17', '2018-07-27 03:31:17'),
(298, 49, 'M-CHA-27072018-CSF-0257', 'BK-27072018-CSF-0095', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '400,400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:31:17', '2018-07-27 03:31:17'),
(299, 49, 'M-CHA-27072018-CSF-0259', 'BK-27072018-CSF-0095', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:32:18', '2018-07-27 03:32:18'),
(300, 49, 'M-CHA-27072018-CSF-0259', 'BK-27072018-CSF-0095', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:32:18', '2018-07-27 03:32:18'),
(301, 49, 'M-CHA-27072018-CSF-0261', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A,EF M CN 170/92M', '450,450', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:32:45', '2018-07-27 03:32:45'),
(302, 49, 'M-CHA-27072018-CSF-0261', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:32:45', '2018-07-27 03:32:45'),
(303, 49, 'M-CHA-27072018-CSF-0261', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A', '900', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:32:45', '2018-07-27 03:32:45'),
(304, 49, 'M-CHA-27072018-CSF-0261', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:32:45', '2018-07-27 03:32:45'),
(305, 49, 'M-CHA-27072018-CSF-0261', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '450,900', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:32:45', '2018-07-27 03:32:45'),
(306, 49, 'M-CHA-27072018-CSF-0261', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:32:45', '2018-07-27 03:32:45'),
(307, 49, 'M-CHA-27072018-CSF-0261', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '900', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:32:45', '2018-07-27 03:32:45'),
(308, 49, 'M-CHA-27072018-CSF-0261', 'BK-27072018-CSF-0092, BK-27072018-CSF-0091, BK-27072018-CSF-0090, BK-27072018-CSF-0089', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L KN 175/96', '450,450', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:32:45', '2018-07-27 03:32:45'),
(309, 49, 'M-CHA-27072018-CD-0269', 'BK-27072018-CD-0096', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:34:21', '2018-07-27 03:34:21'),
(310, 49, 'M-CHA-27072018-CD-0269', 'BK-27072018-CD-0096', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '500,500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:34:21', '2018-07-27 03:34:21'),
(311, 49, 'M-CHA-27072018-CD-0271', 'BK-27072018-CD-0096', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:38:18', '2018-07-27 03:38:18'),
(312, 49, 'M-CHA-27072018-CD-0271', 'BK-27072018-CD-0096', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '50,50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-27 03:38:18', '2018-07-27 03:38:18'),
(313, 49, 'M-CHA-29072018-CD-0273', 'BK-27072018-CD-0096', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '-400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-29 00:18:29', '2018-07-29 00:18:29'),
(314, 49, 'M-CHA-29072018-CD-0273', 'BK-27072018-CD-0096', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '-400', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-29 00:18:30', '2018-07-29 00:18:30'),
(315, 49, 'M-CHA-29072018-CD-0275', 'BK-27072018-CD-0096', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-29 00:19:04', '2018-07-29 00:19:04'),
(316, 49, 'M-CHA-29072018-CD-0275', 'BK-27072018-CD-0096', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '50,50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-29 00:19:04', '2018-07-29 00:19:04'),
(317, 49, 'M-CHA-29072018-CSF-0277', 'BK-26072018-CSF-0081, BK-26072018-CSF-0082, BK-26072018-CSF-0083, BK-27072018-CSF-0084', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L CN 175/96A,EG L KN 175/96', '0,0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-29 00:19:49', '2018-07-29 00:19:49'),
(318, 49, 'M-CHA-29072018-CSF-0277', 'BK-26072018-CSF-0081, BK-26072018-CSF-0082, BK-26072018-CSF-0083, BK-27072018-CSF-0084', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EF L CN 175/96A3,EG L KN 175/96', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-29 00:19:49', '2018-07-29 00:19:49'),
(319, 49, 'M-CHA-29072018-CSF-0277', 'BK-26072018-CSF-0081, BK-26072018-CSF-0082, BK-26072018-CSF-0083, BK-27072018-CSF-0084', NULL, '05-OST2LHTCR001X-02', '2L.SLT-TA.001', NULL, NULL, 'EG L CN 175/96A,EG L KN 175/96', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-29 00:19:49', '2018-07-29 00:19:49'),
(320, 49, 'M-CHA-29072018-CSF-0277', 'BK-26072018-CSF-0081, BK-26072018-CSF-0082, BK-26072018-CSF-0083, BK-27072018-CSF-0084', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-29 00:19:49', '2018-07-29 00:19:49'),
(321, 49, 'M-CHA-29072018-CSF-0277', 'BK-26072018-CSF-0081, BK-26072018-CSF-0082, BK-26072018-CSF-0083, BK-27072018-CSF-0084', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-29 00:19:49', '2018-07-29 00:19:49'),
(322, 49, 'M-CHA-29072018-CSF-0277', 'BK-26072018-CSF-0081, BK-26072018-CSF-0082, BK-26072018-CSF-0083, BK-27072018-CSF-0084', NULL, '04-0ST2LMLTA001X-01', '2L.ML-TA.001', NULL, NULL, 'EF L CN 175/96A', '900', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-29 00:19:49', '2018-07-29 00:19:49'),
(323, 49, 'M-CHA-30072018-CSF-0095', 'BK-27072018-CSF-0095', NULL, '21-OST2LHTCR001X-02', '2L.HT-CR.001', NULL, NULL, 'SSS', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-30 04:31:26', '2018-07-30 04:31:26'),
(324, 49, 'M-CHA-30072018-CSF-0095', 'BK-27072018-CSF-0095', NULL, 'X-C0-C-32-E', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', NULL, NULL, 'ANTIQUE BRASS,ANTIQUE BRASS', '0,0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'create', '2018-07-30 04:31:26', '2018-07-30 04:31:26');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_order`
--

CREATE TABLE `mxp_order` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `oss` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `style` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `incrementValue` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_order`
--

INSERT INTO `mxp_order` (`id`, `user_id`, `order_id`, `erp_code`, `item_code`, `oss`, `style`, `item_size`, `quantity`, `incrementValue`, `created_at`, `updated_at`) VALUES
(1, 49, '5b2a4291e1189', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'abc', 'fff', NULL, '22', '001', '2018-06-20 06:03:30', '2018-06-20 06:03:30'),
(2, 49, '5b2a4291e1189', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'abc', 'fff', 'EU XS CN 160/84A', '2000', '001', '2018-06-20 06:03:30', '2018-06-20 06:03:30'),
(3, 49, '5b2a4291e1189', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'abc', NULL, 'EU S CN 165/88A', '2001', '001', '2018-06-20 06:03:30', '2018-06-20 06:03:30'),
(4, 49, '5b2a4291e1189', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'abc', 'tt', 'EU M CN 170/92M', '2002', '001', '2018-06-20 06:03:30', '2018-06-20 06:03:30'),
(5, 49, '5b2a4291e1189', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'abc', 'tt', 'EU L CN 175/96A', '2003', '001', '2018-06-20 06:03:30', '2018-06-20 06:03:30'),
(6, 49, '5b2a4291e1189', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'abc', 'tt', 'EF L CN 175/96A', '1200', '001', '2018-06-20 06:03:30', '2018-06-20 06:03:30'),
(7, 49, '5b2a4291e1189', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'abc', 'tt', 'EF M CN 170/92M', '1201', '001', '2018-06-20 06:03:30', '2018-06-20 06:03:30'),
(8, 49, '5b2a4291e1189', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'abc', NULL, 'EF S CN 165/88A', '1202', '001', '2018-06-20 06:03:30', '2018-06-20 06:03:30'),
(9, 49, '5b2a4291e1189', '05-0ST2LMLTA001X-01', '2L.SLT-TA.001', 'abc', NULL, 'EG L CN 175/96A', '1000', '001', '2018-06-20 06:03:31', '2018-06-20 06:03:31'),
(10, 49, '5b2a4291e1189', '05-0ST2LMLTA001X-01', '2L.SLT-TA.001', 'abc', NULL, 'EG L KN 175/96', '1001', '001', '2018-06-20 06:03:31', '2018-06-20 06:03:31'),
(11, 49, '5b2cc4ba18a40', '21-OST2LHTCR001X-02', '2L.HT-CR.001', 'abc', 'fff', NULL, '22', '002', '2018-06-22 03:43:22', '2018-06-22 03:43:22'),
(12, 49, '5b2cc4ba18a40', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'abc', 'fff', 'EU XS CN 160/84A', '2000', '002', '2018-06-22 03:43:22', '2018-06-22 03:43:22'),
(13, 49, '5b2cc4ba18a40', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'abc', NULL, 'EU S CN 165/88A', '2001', '002', '2018-06-22 03:43:22', '2018-06-22 03:43:22'),
(14, 49, '5b2cc4ba18a40', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'abc', 'tt', 'EU M CN 170/92M', '2002', '002', '2018-06-22 03:43:22', '2018-06-22 03:43:22'),
(15, 49, '5b2cc4ba18a40', '04-OST2LSLTA001X-01', '2L.SL-TA.001', 'abc', 'tt', 'EU L CN 175/96A', '2003', '002', '2018-06-22 03:43:22', '2018-06-22 03:43:22'),
(16, 49, '5b2cc4ba18a40', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'abc', 'tt', 'EF L CN 175/96A', '1200', '002', '2018-06-22 03:43:23', '2018-06-22 03:43:23'),
(17, 49, '5b2cc4ba18a40', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'abc', 'tt', 'EF M CN 170/92M', '1201', '002', '2018-06-22 03:43:23', '2018-06-22 03:43:23'),
(18, 49, '5b2cc4ba18a40', '04-0ST2LMLTA001X-01', '2L.ML-TA.001', 'abc', NULL, 'EF S CN 165/88A', '1202', '002', '2018-06-22 03:43:23', '2018-06-22 03:43:23'),
(19, 49, '5b2cc4ba18a40', '05-0ST2LMLTA001X-01', '2L.SLT-TA.001', 'abc', NULL, 'EG L CN 175/96A', '1000', '002', '2018-06-22 03:43:23', '2018-06-22 03:43:23'),
(20, 49, '5b2cc4ba18a40', '05-0ST2LMLTA001X-01', '2L.SLT-TA.001', 'abc', NULL, 'EG L KN 175/96', '1001', '002', '2018-06-22 03:43:23', '2018-06-22 03:43:23');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_order_input`
--

CREATE TABLE `mxp_order_input` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `oss` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `style` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `incrementValue` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mxp_pageFooter`
--

CREATE TABLE `mxp_pageFooter` (
  `footer_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `action` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mxp_pageheader`
--

CREATE TABLE `mxp_pageheader` (
  `header_id` int(11) NOT NULL,
  `aaaa` text NOT NULL,
  `aaaav` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `mxp_party`
--

CREATE TABLE `mxp_party` (
  `id` int(10) UNSIGNED NOT NULL,
  `party_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_buyer` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_part1_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_part2_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attention_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fax_invoice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_part1_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_part2_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attention_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fax_delivery` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_3` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_party`
--

INSERT INTO `mxp_party` (`id`, `party_id`, `user_id`, `name`, `sort_name`, `name_buyer`, `address_part1_invoice`, `address_part2_invoice`, `attention_invoice`, `mobile_invoice`, `telephone_invoice`, `fax_invoice`, `address_part1_delivery`, `address_part2_delivery`, `attention_delivery`, `mobile_delivery`, `telephone_delivery`, `fax_delivery`, `description_1`, `description_2`, `description_3`, `created_at`, `updated_at`, `status`) VALUES
(2, '00122', '49', 'CSF GARMENTS (PVT.) LTD', 'CSF', 'REGATTA', 'DELUXE HOUSE #3 (3rd-6th floor)', '209/227, KULGAON, BALUCHARA, CHITTAGAON-4214,BANGLADESH', 'Mr. Mohibul', '+8801984464601', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-06-21 00:35:45', '2018-06-21 00:35:45', NULL),
(3, '6545342', '49', 'Capital Design', 'CD', 'CRAGHOPPERS', 'UNI GEARS LTD', 'BADSHAMIAH SCHOOL ROAD KHAILKUR,BOARD BAZAR GAZIPUR-1702,BANGLADESH PHONE: +88 02 9293760', 'MR. SHEHAB', '+88-09610864328', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-06-21 00:38:43', '2018-06-21 00:38:43', NULL),
(4, '3232', '49', 'ALPHA CLOTHING LTD', 'ACL', 'REGATTA', 'Section -1', 'Section- 2', 'aaaa', '01685-696806', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-06-21 06:55:51', '2018-06-21 06:55:51', NULL),
(5, 'xyz', '49', 'maximumregada', 'rga', 'abc', 'mirpur', 'dhaka', 'abced', '123466', '2345678', NULL, 'village: kalikabari danggapara, Union : Boro Chondipur (5), Post :Havra', 'dhakaq', NULL, '1234567', '2345678', NULL, NULL, NULL, NULL, '2018-07-06 23:14:04', '2018-07-09 00:59:43', '1'),
(6, '123456', '49', 'abc', 'abc', 'aaa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-07-09 00:41:38', '2018-07-09 00:57:10', '1');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_piformat_data_info`
--

CREATE TABLE `mxp_piformat_data_info` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `buyer_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_piformat_data_info`
--

INSERT INTO `mxp_piformat_data_info` (`id`, `code`, `buyer_name`, `created_at`, `updated_at`) VALUES
(1, '1001', 'Craghoppers', '2018-06-20 18:00:00', '2018-06-20 18:00:00'),
(2, '1002', 'regatta', '2018-06-21 18:00:00', '2018-06-21 18:00:00'),
(3, '1003', 'DARE2B dare2b', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `mxp_product`
--

CREATE TABLE `mxp_product` (
  `product_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `brand` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_price` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight_qty` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight_amt` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_3` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description_4` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `others_color` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_product`
--

INSERT INTO `mxp_product` (`product_id`, `user_id`, `product_code`, `product_name`, `product_type`, `product_description`, `brand`, `erp_code`, `unit_price`, `weight_qty`, `weight_amt`, `description_1`, `description_2`, `description_3`, `description_4`, `status`, `created_at`, `updated_at`, `action`, `others_color`) VALUES
(1, 49, '2L.HT-CR.001', NULL, NULL, 'sadsads', 'dhamaka', '21-OST2LHTCR001X-02', '1.01', '7400', '097', 'asdasd', 'asdasd', 'asdasd', 'sadasd', '1', '2018-04-17 00:19:18', '2018-07-13 08:46:17', 'create', NULL),
(2, 49, '2L.ML-TA.001', 'others_color', NULL, 'aaa', 'abc', '04-0ST2LMLTA001X-01', '.08', '120', 'aaa', NULL, NULL, NULL, NULL, '1', '2018-04-17 02:11:23', '2018-07-10 02:04:37', 'create', NULL),
(4, 49, '2L.SL-TA.001', NULL, NULL, '2L.ML-TA.001', 'abc', '04-OST2LSLTA001X-01', '0.002', '098', '5', NULL, NULL, NULL, NULL, '1', '2018-04-18 00:59:33', '2018-06-11 00:30:44', 'create', NULL),
(5, 49, '2L.SLT-TA.001', NULL, NULL, 'nai', 'abc', '05-OST2LHTCR001X-02', '.05', NULL, NULL, NULL, NULL, NULL, NULL, '1', '2018-04-27 04:59:09', '2018-06-11 00:30:52', 'create', NULL),
(7, 49, 'CSO04369 - REGETTA GREAT', NULL, NULL, NULL, 'dhamaka', '22322', '0.6', NULL, NULL, NULL, NULL, NULL, NULL, '0', '2018-06-04 02:50:11', '2018-07-10 02:04:45', 'create', NULL),
(8, 49, 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'CORD COLOR', NULL, NULL, 'dhamaka', 'X-C0-C-32-E', '0.3', NULL, NULL, NULL, NULL, NULL, NULL, '1', '2018-06-08 02:02:03', '2018-06-08 02:02:03', 'create', NULL),
(9, 49, '5250', 'Other Colors', NULL, 'hhh', 'abc', 'jhhl', '0.9', NULL, NULL, NULL, NULL, NULL, NULL, '1', '2018-06-13 01:43:22', '2018-06-13 02:09:12', 'create', NULL),
(10, 49, 'productcode', 'productName', NULL, 'this is description', 'branda', 'erpcode', '.8', '100', '.5', NULL, NULL, NULL, NULL, '1', '2018-07-06 23:25:41', '2018-07-06 23:25:41', 'create', NULL),
(11, 49, 'check', 'check', NULL, 'check', 'branda', '12313', '123123', '123123', '1231', NULL, NULL, NULL, NULL, '1', '2018-07-13 08:53:13', '2018-07-13 08:53:13', 'create', NULL),
(12, 49, 'dfgd', 'dfgd', NULL, 'dfgdg', '7', 'dfgd', '12', '12', '12', NULL, NULL, NULL, NULL, '1', '2018-07-13 10:01:02', '2018-07-13 10:01:02', 'create', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `mxp_productSize`
--

CREATE TABLE `mxp_productSize` (
  `proSize_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_size` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_productSize`
--

INSERT INTO `mxp_productSize` (`proSize_id`, `user_id`, `product_code`, `product_size`, `status`, `action`, `created_at`, `updated_at`) VALUES
(1, 49, '2L.SL-TA.001', 'EU L CN 175/96A', '0', 'update', '2018-04-25 11:22:44', '2018-05-22 23:39:44'),
(2, 49, '2L.SL-TA.001', 'EU M CN 170/92M', '1', 'create', '2018-04-25 11:22:53', '2018-04-25 11:22:53'),
(3, 49, '2L.SL-TA.001', 'EU S CN 165/88A', '1', 'create', '2018-04-25 11:22:59', '2018-04-25 11:22:59'),
(4, 49, '2L.SL-TA.001', 'EU XS CN 160/84A', '1', 'update', '2018-04-25 11:23:06', '2018-05-15 01:57:02'),
(6, 49, '2L.ML-TA.001', 'EF L CN 175/96A', '1', 'create', '2018-04-27 00:04:10', '2018-04-27 00:04:10'),
(7, 49, '2L.ML-TA.001', 'EF M CN 170/92M', '1', 'create', '2018-04-27 00:04:36', '2018-04-27 00:04:36'),
(8, 49, '2L.ML-TA.001', 'EF S CN 165/88A', '1', 'create', '2018-04-27 00:05:06', '2018-04-27 00:05:06'),
(9, 49, '2L.SLT-TA.001', 'EG L CN 175/96A', '1', 'create', '2018-04-27 04:59:26', '2018-04-27 04:59:26'),
(10, 49, '2L.SLT-TA.001', 'EG L KN 175/96', '1', 'update', '2018-04-27 05:00:03', '2018-04-27 05:00:21'),
(11, 49, '2L.SLT-TA.001', 'EF L CN 175/96A3', '1', 'create', '2018-05-16 05:18:59', '2018-05-16 05:18:59'),
(12, 49, 'CSO04369 - REGETTA GREAT', 'S', '1', 'create', '2018-06-04 02:50:29', '2018-06-04 02:50:29'),
(13, 49, 'CSO04369 - REGETTA GREAT', 'm', '1', 'update', '2018-06-04 02:50:42', '2018-06-20 05:23:22'),
(14, 49, 'CSO04369 - REGETTA GREAT', 'XL', '1', 'create', '2018-06-04 02:51:00', '2018-06-04 02:51:00'),
(15, 49, 'CSO04369 - REGETTA GREAT', 'XLL', '1', 'create', '2018-06-04 02:51:09', '2018-06-04 02:51:09'),
(16, 49, 'CSO04369 - REGETTA GREAT', '4XL', '1', 'create', '2018-06-04 02:51:44', '2018-06-04 02:51:44'),
(17, 49, 'CSO04369 - REGETTA GREAT', '5XL', '1', 'create', '2018-06-04 02:52:19', '2018-06-04 02:52:19'),
(18, 49, 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'DARK STEEL', '1', 'create', '2018-06-08 02:02:39', '2018-06-08 02:02:39'),
(19, 49, 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'ANTIQUE BRASS', '1', 'create', '2018-06-08 02:03:25', '2018-06-08 02:03:25'),
(20, 49, '5250', '1212', '1', 'create', '2018-06-13 01:50:35', '2018-06-13 01:50:35'),
(22, 49, '', 'SSS', '1', 'create', '2018-07-13 08:45:14', '2018-07-13 08:45:14'),
(26, 49, '', 'WWWW', '1', 'create', '2018-07-13 08:48:07', '2018-07-13 08:48:07'),
(30, 49, '', 'QQQQ', '1', 'create', '2018-07-13 08:50:28', '2018-07-13 08:50:28'),
(31, 49, '', 'ZUUUUUU', '1', 'create', '2018-07-13 08:52:58', '2018-07-13 08:52:58'),
(34, 49, 'check', 'ZUUUUUU', '1', 'create', '2018-07-13 08:53:45', '2018-07-13 08:53:45'),
(35, 49, '', 'kamrul', '1', 'create', '2018-07-13 10:00:44', '2018-07-13 10:00:44'),
(36, 49, 'dfgd', 'SSS', '1', 'create', '2018-07-13 10:01:02', '2018-07-13 10:01:02'),
(37, 49, 'dfgd', 'kamrul', '1', 'create', '2018-07-13 10:01:02', '2018-07-13 10:01:02'),
(38, 49, '2L.HT-CR.001', 'SSS', '1', 'create', '2018-07-27 03:49:55', '2018-07-27 03:49:55'),
(39, 49, '2L.HT-CR.001', 'WWWW', '1', 'create', '2018-07-27 03:49:55', '2018-07-27 03:49:55');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_products_colors`
--

CREATE TABLE `mxp_products_colors` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `color_id` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_products_colors`
--

INSERT INTO `mxp_products_colors` (`id`, `product_id`, `color_id`, `status`, `created_at`, `updated_at`) VALUES
(0, 11, 52, 1, '2018-07-13 08:53:45', '2018-07-13 08:53:45'),
(0, 12, 21, 1, '2018-07-13 10:01:02', '2018-07-13 10:01:02'),
(0, 12, 57, 1, '2018-07-13 10:01:02', '2018-07-13 10:01:02'),
(0, 1, 22, 1, '2018-07-27 03:49:55', '2018-07-27 03:49:55'),
(0, 1, 25, 1, '2018-07-27 03:49:55', '2018-07-27 03:49:55');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_products_sizes`
--

CREATE TABLE `mxp_products_sizes` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `size_id` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_products_sizes`
--

INSERT INTO `mxp_products_sizes` (`id`, `product_id`, `size_id`, `status`, `created_at`, `updated_at`) VALUES
(0, 11, 31, 1, '2018-07-13 08:53:45', '2018-07-13 08:53:45'),
(0, 12, 22, 1, '2018-07-13 10:01:02', '2018-07-13 10:01:02'),
(0, 12, 35, 1, '2018-07-13 10:01:02', '2018-07-13 10:01:02'),
(0, 1, 22, 1, '2018-07-27 03:49:55', '2018-07-27 03:49:55'),
(0, 1, 26, 1, '2018-07-27 03:49:55', '2018-07-27 03:49:55');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_purchase_orders`
--

CREATE TABLE `mxp_purchase_orders` (
  `po_id` int(10) UNSIGNED NOT NULL,
  `po_no` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `booking_order_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipment_date` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `erp_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `item_size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_quantity` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gmts_color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `material` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_price` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_amount` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_purchase_orders`
--

INSERT INTO `mxp_purchase_orders` (`po_id`, `po_no`, `booking_order_id`, `shipment_date`, `item_code`, `erp_code`, `item_size`, `item_quantity`, `gmts_color`, `material`, `unit`, `unit_price`, `total_amount`, `created_at`, `updated_at`) VALUES
(314, ' PO-07082018-0004', 'BK-07082018-CSF-0097', '2018-08-06', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '500', '00XXX', 'null', '', '1.01', '505.00', '2018-08-07 00:35:22', '2018-08-07 00:35:22'),
(313, ' PO-07082018-0003', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '86', 'undefined', 'null', '', '1.05', '90.30', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(312, ' PO-07082018-0003', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '83', 'undefined', 'null', '', '1.05', '87.15', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(311, ' PO-07082018-0003', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '80', 'undefined', 'null', '', '1.05', '84.00', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(310, ' PO-07082018-0003', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '83', 'undefined', 'null', '', '1.05', '87.15', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(309, ' PO-07082018-0003', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '81', 'undefined', 'null', '', '1.05', '85.05', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(308, ' PO-07082018-0003', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '79', 'undefined', 'null', '', '1.05', '82.95', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(307, ' PO-07082018-0003', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '80', 'undefined', 'null', '', '1.05', '84.00', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(306, ' PO-07082018-0003', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '79', 'undefined', 'null', '', '1.05', '82.95', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(305, ' PO-07082018-0003', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '78', 'undefined', 'null', '', '1.05', '81.90', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(304, ' PO-07082018-0003', 'INVO-13072018-CD-0010', '2018-07-26', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF S CN 165/88A', '222', 'undefined', 'null', '', '.08', '17.76', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(303, ' PO-07082018-0003', 'INVO-13072018-CD-0010', '2018-07-26', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF M CN 170/92M', '214', 'undefined', 'null', '', '.08', '17.12', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(302, ' PO-07082018-0003', 'INVO-13072018-CD-0010', '2018-07-26', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF L CN 175/96A', '206', 'undefined', 'null', '', '.08', '16.48', '2018-08-07 00:22:07', '2018-08-07 00:22:07'),
(301, ' PO-07082018-0002', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '86', 'undefined', 'null', '', '1.05', '90.30', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(300, ' PO-07082018-0002', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '83', 'undefined', 'null', '', '1.05', '87.15', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(299, ' PO-07082018-0002', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '80', 'undefined', 'null', '', '1.05', '84.00', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(298, ' PO-07082018-0002', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '83', 'undefined', 'null', '', '1.05', '87.15', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(297, ' PO-07082018-0002', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '81', 'undefined', 'null', '', '1.05', '85.05', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(296, ' PO-07082018-0002', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '79', 'undefined', 'null', '', '1.05', '82.95', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(295, ' PO-07082018-0002', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '80', 'undefined', 'null', '', '1.05', '84.00', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(294, ' PO-07082018-0002', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '79', 'undefined', 'null', '', '1.05', '82.95', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(293, ' PO-07082018-0002', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '78', 'undefined', 'null', '', '1.05', '81.90', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(292, ' PO-07082018-0002', 'INVO-13072018-CD-0010', '2018-07-26', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF S CN 165/88A', '222', 'undefined', 'null', '', '.08', '17.76', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(291, ' PO-07082018-0002', 'INVO-13072018-CD-0010', '2018-07-26', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF M CN 170/92M', '214', 'undefined', 'null', '', '.08', '17.12', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(287, ' PO-30072018-0001', 'INVO-12072018-CSF-0009', '2018-07-25', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '110', 'undefined', 'null', '', '1.05', '115.50', '2018-07-30 08:44:39', '2018-07-30 08:44:39'),
(288, ' PO-30072018-0001', 'INVO-12072018-CSF-0009', '2018-07-25', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '110', 'undefined', 'null', '', '1.05', '115.50', '2018-07-30 08:44:39', '2018-07-30 08:44:39'),
(289, ' PO-30072018-0001', 'INVO-12072018-CSF-0009', '2018-07-25', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '110', 'undefined', 'null', '', '1.05', '115.50', '2018-07-30 08:44:39', '2018-07-30 08:44:39'),
(290, ' PO-07082018-0002', 'INVO-13072018-CD-0010', '2018-07-26', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF L CN 175/96A', '206', 'undefined', 'null', '', '.08', '16.48', '2018-08-07 00:21:53', '2018-08-07 00:21:53'),
(315, ' PO-07082018-0005', 'BK-27072018-CSF-0094', '2018-07-31', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', 'null', '', '0.3', '0.00', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(316, ' PO-07082018-0005', 'BK-27072018-CSF-0094', '2018-07-31', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '0', 'undefined', 'null', '', '.05', '0.00', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(317, ' PO-07082018-0005', 'BK-27072018-CSF-0094', '2018-07-31', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', 'null', '', '1.01', '0.00', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(318, ' PO-07082018-0005', 'BK-27072018-CSF-0093', '2018-07-31', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '0', 'DARK KHAKI', 'null', '', '0.3', '0.00', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(319, ' PO-07082018-0005', 'BK-27072018-CSF-0093', '2018-07-31', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '0', 'undefined', 'null', '', '.05', '0.00', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(320, ' PO-07082018-0005', 'BK-27072018-CSF-0093', '2018-07-31', '2L.HT-CR.001', '21-OST2LHTCR001X-02', 'SSS', '0', '00XXX', 'null', '', '1.01', '0.00', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(321, ' PO-07082018-0005', 'BK-13072018-CSF-0037', '2018-07-25', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '767', 'DARK KHAKI', 'null', '', '0.3', '230.10', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(322, ' PO-07082018-0005', 'BK-13072018-CSF-0037', '2018-07-25', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EG L CN 175/96A', '990', 'undefined', 'null', '', '.05', '49.50', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(323, ' PO-07082018-0005', 'BK-13072018-CSF-0037', '2018-07-25', '2L.SLT-TA.001', '05-OST2LHTCR001X-02', 'EF L CN 175/96A3', '1610', 'undefined', 'null', '', '.05', '80.50', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(324, ' PO-07082018-0005', 'BK-13072018-CSF-0037', '2018-07-20', 'CTO00029 ( ZK011A ) : PLASTIC TOGGOLE BEADS', 'X-C0-C-32-E', 'ANTIQUE BRASS', '899', 'DARK KHAKI', 'null', '', '0.3', '269.70', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(325, ' PO-07082018-0005', 'INVO-13072018-CD-0010', '2018-07-26', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF L CN 175/96A', '206', 'undefined', 'null', '', '.08', '16.48', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(326, ' PO-07082018-0005', 'INVO-13072018-CD-0010', '2018-07-26', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF M CN 170/92M', '214', 'undefined', 'null', '', '.08', '17.12', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(327, ' PO-07082018-0005', 'INVO-13072018-CD-0010', '2018-07-26', '2L.ML-TA.001', '04-0ST2LMLTA001X-01', 'EF S CN 165/88A', '222', 'undefined', 'null', '', '.08', '17.76', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(328, ' PO-07082018-0005', 'INVO-12072018-CSF-0009', '2018-07-25', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '110', 'undefined', 'null', '', '1.05', '115.50', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(329, ' PO-07082018-0005', 'INVO-12072018-CSF-0009', '2018-07-25', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '110', 'undefined', 'null', '', '1.05', '115.50', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(330, ' PO-07082018-0005', 'INVO-12072018-CSF-0009', '2018-07-25', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '110', 'undefined', 'null', '', '1.05', '115.50', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(331, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '78', 'undefined', 'null', '', '1.05', '81.90', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(332, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '79', 'undefined', 'null', '', '1.05', '82.95', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(333, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '80', 'undefined', 'null', '', '1.05', '84.00', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(334, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '79', 'undefined', 'null', '', '1.05', '82.95', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(335, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '81', 'undefined', 'null', '', '1.05', '85.05', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(336, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '83', 'undefined', 'null', '', '1.05', '87.15', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(337, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '80', 'undefined', 'null', '', '1.05', '84.00', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(338, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '83', 'undefined', 'null', '', '1.05', '87.15', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(339, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-26', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '86', 'undefined', 'null', '', '1.05', '90.30', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(340, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-12', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '81', 'undefined', 'null', '', '1.05', '85.05', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(341, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-12', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '85', 'undefined', 'null', '', '1.05', '89.25', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(342, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-12', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '89', 'undefined', 'null', '', '1.05', '93.45', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(343, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '83', 'undefined', 'null', '', '1.05', '87.15', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(344, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '88', 'undefined', 'null', '', '1.05', '92.40', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(345, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '93', 'undefined', 'null', '', '1.05', '97.65', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(346, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '84', 'undefined', 'null', '', '1.05', '88.20', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(347, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '89', 'undefined', 'null', '', '1.05', '93.45', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(348, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '94', 'undefined', 'null', '', '1.05', '98.70', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(349, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '85', 'undefined', 'null', '', '1.05', '89.25', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(350, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '90', 'undefined', 'null', '', '1.05', '94.50', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(351, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '95', 'undefined', 'null', '', '1.05', '99.75', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(352, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '86', 'undefined', 'null', '', '1.05', '90.30', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(353, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '91', 'undefined', 'null', '', '1.05', '95.55', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(354, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '96', 'undefined', 'null', '', '1.05', '100.80', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(355, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '87', 'undefined', 'null', '', '1.05', '91.35', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(356, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '92', 'undefined', 'null', '', '1.05', '96.60', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(357, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '97', 'undefined', 'null', '', '1.05', '101.85', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(358, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '89', 'undefined', 'null', '', '1.05', '93.45', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(359, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '94', 'undefined', 'null', '', '1.05', '98.70', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(360, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '99', 'undefined', 'null', '', '1.05', '103.95', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(361, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '90', 'undefined', 'null', '', '1.05', '94.50', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(362, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '95', 'undefined', 'null', '', '1.05', '99.75', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(363, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '100', 'undefined', 'null', '', '1.05', '105.00', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(364, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '91', 'undefined', 'null', '', '1.05', '95.55', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(365, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '96', 'undefined', 'null', '', '1.05', '100.80', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(366, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '101', 'undefined', 'null', '', '1.05', '106.05', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(367, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '92', 'undefined', 'null', '', '1.05', '96.60', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(368, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '97', 'undefined', 'null', '', '1.05', '101.85', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(369, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '102', 'undefined', 'null', '', '1.05', '107.10', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(370, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '93', 'undefined', 'null', '', '1.05', '97.65', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(371, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '98', 'undefined', 'null', '', '1.05', '102.90', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(372, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '103', 'undefined', 'null', '', '1.05', '108.15', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(373, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '94', 'undefined', 'null', '', '1.05', '98.70', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(374, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '99', 'undefined', 'null', '', '1.05', '103.95', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(375, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-19', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '104', 'undefined', 'null', '', '1.05', '109.20', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(376, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-12', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU L CN 175/96A', '95', 'undefined', 'null', '', '1.05', '99.75', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(377, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-12', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU M CN 170/92M', '100', 'undefined', 'null', '', '1.05', '105.00', '2018-08-07 02:20:38', '2018-08-07 02:20:38'),
(378, ' PO-07082018-0005', 'INVO-12072018-CSF-0006', '2018-07-12', '2L.SL-TA.001', '04-OST2LSLTA001X-01', 'EU S CN 165/88A', '105', 'undefined', 'null', '', '1.05', '110.25', '2018-08-07 02:20:38', '2018-08-07 02:20:38');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_reportFooter`
--

CREATE TABLE `mxp_reportFooter` (
  `re_footer_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `reportName` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description_1` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description_2` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description_3` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description_4` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description_5` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `siginingPerson_1` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `siginingPersonSeal_1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `siginingSignature_1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `siginingPerson_2` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `siginingSignature_2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `siginingPersonSeal_2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `action` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_reportFooter`
--

INSERT INTO `mxp_reportFooter` (`re_footer_id`, `user_id`, `reportName`, `description_1`, `description_2`, `description_3`, `description_4`, `description_5`, `siginingPerson_1`, `siginingPersonSeal_1`, `siginingSignature_1`, `siginingPerson_2`, `siginingSignature_2`, `siginingPersonSeal_2`, `status`, `created_at`, `updated_at`, `action`) VALUES
(2, 49, 'challan report', '', '', '', '', '', '', NULL, NULL, '', NULL, NULL, '1', '2018-04-17 00:14:14', '2018-06-22 23:01:12', 'create');

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
(29, 'test', 10, '', 1, '2018-04-09 01:57:41', '2018-04-09 01:57:41'),
(30, 'role', 17, '34721', 1, '2018-05-03 02:40:21', '2018-05-03 02:40:21'),
(31, 'S Com ROle', 18, '32352', 1, '2018-05-10 00:08:52', '2018-05-10 00:08:52'),
(32, 'subAdmin', 18, '23551', 1, '2018-05-18 00:02:52', '2018-05-18 00:02:52'),
(33, 'admin', 18, '23506', 1, '2018-05-18 00:03:06', '2018-05-18 00:03:06'),
(34, 'asasas', 17, '13547', 1, '2018-05-19 01:18:47', '2018-05-19 01:18:47');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_supplier_prices`
--

CREATE TABLE `mxp_supplier_prices` (
  `supplier_price_id` int(10) UNSIGNED NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `supplier_price` double(8,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_supplier_prices`
--

INSERT INTO `mxp_supplier_prices` (`supplier_price_id`, `supplier_id`, `product_id`, `supplier_price`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 1.05, '2018-07-27 03:49:55', '2018-07-27 03:49:55');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_task`
--

CREATE TABLE `mxp_task` (
  `id_mxp_task` int(10) UNSIGNED NOT NULL,
  `name` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_task`
--

INSERT INTO `mxp_task` (`id_mxp_task`, `name`, `status`, `created_at`, `updated_at`) VALUES
(1, 'booking', 1, NULL, NULL),
(2, 'PI', 1, NULL, NULL),
(3, 'IPO', 1, NULL, NULL),
(4, 'MRF', 1, NULL, NULL),
(5, 'challan', 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `mxp_task_role`
--

CREATE TABLE `mxp_task_role` (
  `id_mxp_task_role` int(10) UNSIGNED NOT NULL,
  `role_id` int(11) NOT NULL,
  `task` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_task_role`
--

INSERT INTO `mxp_task_role` (`id_mxp_task_role`, `role_id`, `task`) VALUES
(1, 1, '1,2,3,4,5'),
(2, 20, ''),
(3, 21, ''),
(4, 22, ''),
(5, 23, ''),
(6, 24, ''),
(7, 25, ''),
(8, 26, ''),
(9, 27, ''),
(10, 29, ''),
(11, 30, ''),
(12, 31, ''),
(13, 32, ''),
(14, 33, ''),
(15, 34, '');

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
(1, 'BD Maxim Online', 1, 'en', 0, 1, '2018-03-05 18:12:49', '2018-07-08 23:58:37'),
(2, 'বিডি ম্যাক্সিম অনলাইন', 1, 'bn', 0, 1, '2018-03-05 18:12:49', '2018-07-08 23:58:37'),
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
(175, 'Item Name', 88, 'en', 0, 1, '2018-03-06 22:01:41', '2018-07-09 01:32:55'),
(176, 'পণ্য  নাম', 88, 'bn', 0, 1, '2018-03-06 22:01:41', '2018-07-09 01:32:55'),
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
(247, 'Packet details', 124, 'en', 0, 1, '2018-03-09 17:56:43', '2018-03-09 17:56:59'),
(248, 'প্যাকেট বিস্তারিত', 124, 'bn', 0, 1, '2018-03-09 17:56:43', '2018-03-09 17:56:59'),
(249, 'Item Code', 125, 'en', 0, 1, '2018-03-09 18:02:50', '2018-07-09 01:32:39'),
(250, 'পণ্য কোড', 125, 'bn', 0, 1, '2018-03-09 18:02:50', '2018-07-09 01:32:39'),
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
(277, 'Company Name', 139, 'en', 0, 1, '2018-03-09 19:09:56', '2018-06-21 00:33:35'),
(278, 'কোমপানির নাম', 139, 'bn', 0, 1, '2018-03-09 19:09:56', '2018-06-21 00:33:35'),
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
(312, NULL, 156, 'bn', 0, 1, '2018-04-02 06:48:57', '2018-04-02 06:49:14'),
(313, 'Management', 157, 'en', 0, 1, '2018-04-10 00:01:48', '2018-04-16 06:00:36'),
(314, 'ম্যানেজমেন্ট', 157, 'bn', 0, 1, '2018-04-10 00:01:48', '2018-04-16 06:00:36'),
(315, 'Item List', 158, 'en', 0, 1, '2018-04-10 00:38:18', '2018-07-09 04:07:11'),
(316, 'পণ্য তালিকা', 158, 'bn', 0, 1, '2018-04-10 00:38:18', '2018-07-09 04:07:11'),
(317, 'Item Description', 159, 'en', 0, 1, '2018-04-10 04:32:01', '2018-07-09 01:33:13'),
(318, 'পণ্যের বর্ণনা', 159, 'bn', 0, 1, '2018-04-10 04:32:01', '2018-07-09 01:33:14'),
(319, 'Brand', 160, 'en', 0, 1, '2018-04-10 04:34:38', '2018-05-13 23:26:45'),
(320, 'তরবার', 160, 'bn', 0, 1, '2018-04-10 04:34:38', '2018-05-13 23:26:45'),
(321, 'ERP Code', 161, 'en', 0, 1, '2018-04-10 04:41:38', '2018-05-13 23:27:40'),
(322, 'ইআরপি কোড', 161, 'bn', 0, 1, '2018-04-10 04:41:38', '2018-05-13 23:27:40'),
(323, 'Unit Price', 162, 'en', 0, 1, '2018-04-10 04:43:37', '2018-05-13 23:28:07'),
(324, 'একক দাম', 162, 'bn', 0, 1, '2018-04-10 04:43:37', '2018-05-13 23:28:07'),
(325, 'Weight Qty', 163, 'en', 0, 1, '2018-04-10 04:46:17', '2018-05-13 23:28:27'),
(326, 'ওজন পরিমাণ', 163, 'bn', 0, 1, '2018-04-10 04:46:18', '2018-05-13 23:28:27'),
(327, 'Weight Amt', 164, 'en', 0, 1, '2018-04-10 04:46:54', '2018-05-13 23:29:01'),
(328, 'ওজন পরিমাণ', 164, 'bn', 0, 1, '2018-04-10 04:46:54', '2018-05-13 23:29:01'),
(329, 'Description 1', 165, 'en', 0, 1, '2018-04-10 04:51:05', '2018-04-10 04:52:20'),
(330, 'বিবরণ 1', 165, 'bn', 0, 1, '2018-04-10 04:51:05', '2018-04-10 04:52:20'),
(331, 'Description 2', 166, 'en', 0, 1, '2018-04-10 04:51:29', '2018-04-10 04:55:18'),
(332, 'বিবরণ 2', 166, 'bn', 0, 1, '2018-04-10 04:51:29', '2018-04-10 04:55:18'),
(333, 'Description 3', 167, 'en', 0, 1, '2018-04-10 04:54:30', '2018-04-10 04:55:30'),
(334, 'বিবরণ 3', 167, 'bn', 0, 1, '2018-04-10 04:54:30', '2018-04-10 04:55:30'),
(335, 'Description 4', 168, 'en', 0, 1, '2018-04-10 04:54:44', '2018-04-10 04:56:56'),
(336, 'বিবরণ 4', 168, 'bn', 0, 1, '2018-04-10 04:54:44', '2018-04-10 04:56:56'),
(337, 'Vendor', 169, 'en', 0, 1, '2018-04-12 00:30:29', '2018-07-09 00:02:01'),
(338, 'বিক্রেতা', 169, 'bn', 0, 1, '2018-04-12 00:30:29', '2018-07-09 00:02:01'),
(339, 'Vendor ID', 170, 'en', 0, 1, '2018-04-12 00:34:45', '2018-07-09 00:31:28'),
(340, 'বিক্রেতা সনাক্তকরন সংখ্যা', 170, 'bn', 0, 1, '2018-04-12 00:34:45', '2018-07-09 00:31:28'),
(341, 'Buyer name', 171, 'en', 0, 1, '2018-04-12 00:35:35', '2018-07-09 00:32:09'),
(342, 'ক্রেতা নাম', 171, 'bn', 0, 1, '2018-04-12 00:35:35', '2018-07-09 00:32:09'),
(343, 'Address -1', 172, 'en', 0, 1, '2018-04-12 00:36:08', '2018-05-11 00:48:16'),
(344, 'ঠিকানা 1', 172, 'bn', 0, 1, '2018-04-12 00:36:08', '2018-05-11 00:48:16'),
(345, 'Address -2', 173, 'en', 0, 1, '2018-04-12 00:37:03', '2018-05-11 00:48:41'),
(346, 'ঠিকানা 2', 173, 'bn', 0, 1, '2018-04-12 00:37:03', '2018-05-11 00:48:41'),
(347, 'Attention', 174, 'en', 0, 1, '2018-04-12 00:38:52', '2018-05-11 00:49:08'),
(348, 'মনোযোগ', 174, 'bn', 0, 1, '2018-04-12 00:38:52', '2018-05-11 00:49:08'),
(349, 'Mobile', 175, 'en', 0, 1, '2018-04-12 00:39:26', '2018-05-11 00:49:33'),
(350, 'মোবাইল', 175, 'bn', 0, 1, '2018-04-12 00:39:26', '2018-05-11 00:49:33'),
(351, 'Telephone', 176, 'en', 0, 1, '2018-04-12 00:40:01', '2018-05-11 00:49:58'),
(352, 'টেলিফোন', 176, 'bn', 0, 1, '2018-04-12 00:40:01', '2018-05-11 00:49:58'),
(353, 'Fax', 177, 'en', 0, 1, '2018-04-12 00:40:51', '2018-05-11 00:50:28'),
(354, 'ফ্যাক্স', 177, 'bn', 0, 1, '2018-04-12 00:40:51', '2018-05-11 00:50:28'),
(355, 'Address -1', 178, 'en', 0, 1, '2018-04-12 00:41:25', '2018-05-11 00:51:57'),
(356, 'ঠিকানা 1', 178, 'bn', 0, 1, '2018-04-12 00:41:25', '2018-05-11 00:51:57'),
(357, 'Address -2', 179, 'en', 0, 1, '2018-04-12 00:41:54', '2018-05-11 00:52:16'),
(358, 'ঠিকানা 2', 179, 'bn', 0, 1, '2018-04-12 00:41:54', '2018-05-11 00:52:17'),
(359, 'Attention', 180, 'en', 0, 1, '2018-04-12 00:42:23', '2018-05-11 00:52:39'),
(360, 'মনোযোগ', 180, 'bn', 0, 1, '2018-04-12 00:42:23', '2018-05-11 00:52:39'),
(361, 'Mobile', 181, 'en', 0, 1, '2018-04-12 00:42:51', '2018-05-11 00:53:11'),
(362, 'মোবাইল', 181, 'bn', 0, 1, '2018-04-12 00:42:51', '2018-05-11 00:53:11'),
(363, 'Telephone', 182, 'en', 0, 1, '2018-04-12 00:43:14', '2018-05-11 00:53:34'),
(364, 'টেলিফোন', 182, 'bn', 0, 1, '2018-04-12 00:43:14', '2018-05-11 00:53:35'),
(365, 'Fax', 183, 'en', 0, 1, '2018-04-12 00:43:40', '2018-05-11 00:54:00'),
(366, 'ফ্যাক্স', 183, 'bn', 0, 1, '2018-04-12 00:43:40', '2018-05-11 00:54:00'),
(367, 'Description -1', 184, 'en', 0, 1, '2018-04-12 00:44:02', '2018-04-12 00:44:17'),
(368, NULL, 184, 'bn', 0, 1, '2018-04-12 00:44:02', '2018-04-12 00:44:17'),
(369, 'Description -2', 185, 'en', 0, 1, '2018-04-12 00:44:29', '2018-04-12 00:44:41'),
(370, NULL, 185, 'bn', 0, 1, '2018-04-12 00:44:29', '2018-04-12 00:44:41'),
(371, 'Description -3', 186, 'en', 0, 1, '2018-04-12 00:44:53', '2018-04-12 00:45:07'),
(372, NULL, 186, 'bn', 0, 1, '2018-04-12 00:44:53', '2018-04-12 00:45:07'),
(373, 'Add vendor', 187, 'en', 0, 1, '2018-04-12 01:09:15', '2018-07-09 00:02:54'),
(374, 'বিক্রেতা যোগ করুন', 187, 'bn', 0, 1, '2018-04-12 01:09:16', '2018-07-09 00:02:55'),
(375, 'Page header', 188, 'en', 0, 1, '2018-04-12 04:03:01', '2018-04-16 05:59:47'),
(376, 'পেজের উপরের অংশ', 188, 'bn', 0, 1, '2018-04-12 04:03:01', '2018-04-16 05:59:47'),
(377, 'Header Title', 189, 'en', 0, 1, '2018-04-12 04:16:18', '2018-05-11 02:33:53'),
(378, 'শিরোলেখ শিরোনাম', 189, 'bn', 0, 1, '2018-04-12 04:16:18', '2018-05-11 02:33:53'),
(379, 'Header font size', 190, 'en', 0, 1, '2018-04-12 04:19:01', '2018-04-12 04:19:22'),
(380, NULL, 190, 'bn', 0, 1, '2018-04-12 04:19:01', '2018-04-12 04:19:22'),
(381, 'Font style', 191, 'en', 0, 1, '2018-04-12 04:21:39', '2018-04-16 06:10:57'),
(382, 'ফন্ট শৈলী', 191, 'bn', 0, 1, '2018-04-12 04:21:39', '2018-04-16 06:10:57'),
(383, 'Header color', 192, 'en', 0, 1, '2018-04-12 04:26:04', '2018-04-12 04:26:12'),
(384, NULL, 192, 'bn', 0, 1, '2018-04-12 04:26:04', '2018-04-12 04:26:12'),
(385, 'Address -1', 193, 'en', 0, 1, '2018-04-12 04:26:24', '2018-04-16 06:15:11'),
(386, 'ঠিকানা 1', 193, 'bn', 0, 1, '2018-04-12 04:26:24', '2018-04-16 06:15:11'),
(387, 'Address -3', 194, 'en', 0, 1, '2018-04-12 04:29:35', '2018-05-10 23:27:52'),
(388, 'ঠিকানা 3', 194, 'bn', 0, 1, '2018-04-12 04:29:35', '2018-05-10 23:27:52'),
(389, 'Header logo aligment', 195, 'en', 0, 1, '2018-04-12 04:30:05', '2018-04-12 04:55:00'),
(390, NULL, 195, 'bn', 0, 1, '2018-04-12 04:30:05', '2018-04-12 04:55:00'),
(391, 'Address -2', 196, 'en', 0, 1, '2018-04-12 04:30:39', '2018-05-10 23:27:38'),
(392, 'ঠিকানা 2', 196, 'bn', 0, 1, '2018-04-12 04:30:39', '2018-05-10 23:27:38'),
(393, 'Logo', 197, 'en', 0, 1, '2018-04-12 04:31:04', '2018-04-16 07:57:34'),
(394, 'লোগো', 197, 'bn', 0, 1, '2018-04-12 04:31:04', '2018-04-16 07:57:34'),
(395, 'Page', 198, 'en', 0, 1, '2018-04-12 05:31:26', '2018-04-16 06:01:07'),
(396, 'পৃষ্ঠা', 198, 'bn', 0, 1, '2018-04-12 05:31:26', '2018-04-16 06:01:07'),
(397, 'Page footer', 199, 'en', 0, 1, '2018-04-12 05:38:56', '2018-05-03 03:59:42'),
(398, 'পৃষ্ঠার পাদলেখ', 199, 'bn', 0, 1, '2018-04-12 05:38:56', '2018-05-03 03:59:43'),
(399, 'Add Page Footer Title', 200, 'en', 0, 1, '2018-04-12 06:07:56', '2018-05-11 02:45:21'),
(400, 'পৃষ্ঠার শিরোনাম শিরোনাম যোগ করুন', 200, 'bn', 0, 1, '2018-04-12 06:07:57', '2018-05-11 02:45:21'),
(401, 'Add a title', 201, 'en', 0, 1, '2018-04-12 06:09:53', '2018-04-12 06:10:06'),
(402, NULL, 201, 'bn', 0, 1, '2018-04-12 06:09:53', '2018-04-12 06:10:06'),
(403, 'Enter footer title', 202, 'en', 0, 0, '2018-04-12 06:10:56', '2018-05-10 23:30:10'),
(404, 'পাদচরণ শিরোনাম লিখুন', 202, 'bn', 0, 0, '2018-04-12 06:10:56', '2018-05-10 23:30:10'),
(405, 'Update footer title', 203, 'en', 0, 1, '2018-04-13 02:05:45', '2018-05-11 02:44:39'),
(406, 'পাদলেখ শিরোনাম আপডেট করুন', 203, 'bn', 0, 1, '2018-04-13 02:05:45', '2018-05-11 02:44:39'),
(407, 'Report footer', 204, 'en', 0, 1, '2018-04-13 02:35:41', '2018-05-03 03:57:07'),
(408, 'পাদটীকা প্রতিবেদন করুন', 204, 'bn', 0, 1, '2018-04-13 02:35:42', '2018-05-03 03:57:07'),
(409, 'Add report', 205, 'en', 0, 1, '2018-04-13 04:43:27', '2018-05-10 23:36:24'),
(410, 'রিপোর্ট যোগ করুন', 205, 'bn', 0, 1, '2018-04-13 04:43:27', '2018-05-10 23:36:24'),
(411, 'Report Name', 206, 'en', 0, 1, '2018-04-13 04:44:39', '2018-04-16 00:13:17'),
(412, 'প্রতিবেদন নাম', 206, 'bn', 0, 1, '2018-04-13 04:44:39', '2018-04-16 00:13:17'),
(413, 'Description -3', 207, 'en', 0, 1, '2018-04-13 04:48:23', '2018-04-13 04:48:33'),
(414, NULL, 207, 'bn', 0, 1, '2018-04-13 04:48:23', '2018-04-13 04:48:33'),
(415, 'Description -1', 208, 'en', 0, 1, '2018-04-13 04:49:10', '2018-04-13 04:49:16'),
(416, NULL, 208, 'bn', 0, 1, '2018-04-13 04:49:10', '2018-04-13 04:49:16'),
(417, 'Description -4', 209, 'en', 0, 1, '2018-04-13 04:50:50', '2018-04-13 04:51:01'),
(418, NULL, 209, 'bn', 0, 1, '2018-04-13 04:50:50', '2018-04-13 04:51:01'),
(419, 'Description -2', 210, 'en', 0, 1, '2018-04-13 04:51:12', '2018-04-13 04:51:19'),
(420, NULL, 210, 'bn', 0, 1, '2018-04-13 04:51:12', '2018-04-13 04:51:19'),
(421, 'Description -5', 211, 'en', 0, 1, '2018-04-13 04:51:28', '2018-04-13 04:51:37'),
(422, NULL, 211, 'bn', 0, 1, '2018-04-13 04:51:29', '2018-04-13 04:51:37'),
(423, 'Sigining Person -1', 212, 'en', 0, 1, '2018-04-13 04:56:18', '2018-04-16 00:15:35'),
(424, 'সাইন ইন ব্যক্তি -1', 212, 'bn', 0, 1, '2018-04-13 04:56:18', '2018-04-16 00:15:35'),
(425, 'Sigining Person -2', 213, 'en', 0, 1, '2018-04-13 04:56:26', '2018-04-16 00:15:43'),
(426, 'সাইন ইন ব্যক্তি -2', 213, 'bn', 0, 1, '2018-04-13 04:56:26', '2018-04-16 00:15:43'),
(427, 'Signature', 214, 'en', 0, 1, '2018-04-13 07:03:30', '2018-04-16 00:14:17'),
(428, 'স্বাক্ষর', 214, 'bn', 0, 1, '2018-04-13 07:03:30', '2018-04-16 00:14:17'),
(429, 'Seal', 215, 'en', 0, 1, '2018-04-13 07:04:58', '2018-04-16 00:13:38'),
(430, 'সীল', 215, 'bn', 0, 1, '2018-04-13 07:04:58', '2018-04-16 00:13:39'),
(431, 'Name', 216, 'en', 0, 1, '2018-04-13 07:26:33', '2018-04-13 07:26:52'),
(432, 'নাম', 216, 'bn', 0, 1, '2018-04-13 07:26:33', '2018-04-13 07:26:52'),
(433, 'Brand List', 217, 'en', 0, 1, '2018-04-16 00:43:54', '2018-04-16 00:44:17'),
(434, 'ব্র্যান্ড তালিকা', 217, 'bn', 0, 1, '2018-04-16 00:43:54', '2018-04-16 00:44:17'),
(435, 'Add Brand', 218, 'en', 0, 1, '2018-04-16 01:36:20', '2018-04-16 01:36:40'),
(436, 'ব্র্যান্ড যোগ করুন', 218, 'bn', 0, 1, '2018-04-16 01:36:20', '2018-04-16 01:36:40'),
(437, 'Brand Name', 219, 'en', 0, 1, '2018-04-16 01:42:14', '2018-04-16 01:42:42'),
(438, 'পরিচিতিমুলক নাম', 219, 'bn', 0, 1, '2018-04-16 01:42:14', '2018-04-16 01:42:42'),
(439, 'Product size list', 220, 'en', 0, 1, '2018-04-16 02:25:24', '2018-06-05 22:35:38'),
(440, 'পণ্য আকার তালিকা', 220, 'bn', 0, 1, '2018-04-16 02:25:24', '2018-06-05 22:35:38'),
(441, 'Add Product Size', 221, 'en', 0, 1, '2018-04-16 04:19:18', '2018-04-16 04:19:42'),
(442, 'পণ্য আকার যোগ করুন', 221, 'bn', 0, 1, '2018-04-16 04:19:18', '2018-04-16 04:19:42'),
(443, 'Size', 222, 'en', 0, 1, '2018-04-16 04:21:37', '2018-04-16 04:21:56'),
(444, 'আয়তন', 222, 'bn', 0, 1, '2018-04-16 04:21:37', '2018-04-16 04:21:56'),
(445, 'Add Size', 223, 'en', 0, 1, '2018-04-16 04:23:26', '2018-04-16 04:23:47'),
(446, 'আকার জুড়ুন', 223, 'bn', 0, 1, '2018-04-16 04:23:26', '2018-04-16 04:23:47'),
(447, 'Font Size', 224, 'en', 0, 1, '2018-04-16 06:09:18', '2018-04-16 06:09:53'),
(448, 'অক্ষরের আকার', 224, 'bn', 0, 1, '2018-04-16 06:09:18', '2018-04-16 06:09:54'),
(449, 'Font Color', 225, 'en', 0, 1, '2018-04-16 06:11:24', '2018-04-16 06:12:18'),
(450, 'ফন্টের রং', 225, 'bn', 0, 1, '2018-04-16 06:11:24', '2018-04-16 06:12:19'),
(451, 'Logo Alignment', 226, 'en', 0, 1, '2018-04-16 06:12:38', '2018-04-17 02:22:44'),
(452, 'লোগো সংলগ্ন', 226, 'bn', 0, 1, '2018-04-16 06:12:38', '2018-04-17 02:22:44'),
(453, 'Print file', 227, 'en', 0, 1, '2018-04-17 05:31:18', '2018-04-17 05:31:50'),
(454, 'মুদ্রণ ফাইল', 227, 'bn', 0, 1, '2018-04-17 05:31:18', '2018-04-17 05:31:50'),
(455, 'Order Entry', 228, 'en', 0, 1, '2018-04-17 05:32:54', '2018-05-09 04:24:57'),
(456, 'অর্ডার এন্ট্রি', 228, 'bn', 0, 1, '2018-04-17 05:32:54', '2018-05-09 04:24:57'),
(457, 'Search bill', 229, 'en', 0, 1, '2018-04-25 22:24:36', '2018-05-03 00:39:41'),
(458, 'অনুসন্ধান বিল', 229, 'bn', 0, 1, '2018-04-25 22:24:36', '2018-05-03 00:39:41'),
(459, 'Search bill', 230, 'en', 0, 1, '2018-05-03 00:37:53', '2018-05-03 00:42:01'),
(460, 'অনুসন্ধান বিল', 230, 'bn', 0, 1, '2018-05-03 00:37:53', '2018-05-03 00:42:01'),
(461, 'Invo No', 231, 'en', 0, 1, '2018-05-03 00:43:16', '2018-05-03 00:45:04'),
(462, 'ইনভো সংখ্যা', 231, 'bn', 0, 1, '2018-05-03 00:43:16', '2018-05-03 00:45:04'),
(463, 'Search', 232, 'en', 0, 1, '2018-05-03 02:54:24', '2018-05-03 02:54:42'),
(464, 'অনুসন্ধান', 232, 'bn', 0, 1, '2018-05-03 02:54:24', '2018-05-03 02:54:42'),
(465, 'Genarate', 233, 'en', 0, 1, '2018-05-03 02:59:29', '2018-05-03 03:00:12'),
(466, 'জেনারেট করুন', 233, 'bn', 0, 1, '2018-05-03 02:59:29', '2018-05-03 03:00:12'),
(467, 'New Challan Create', 234, 'en', 0, 1, '2018-05-03 03:48:13', '2018-05-07 00:29:58'),
(468, 'নতুন চালান তৈরি করুন', 234, 'bn', 0, 1, '2018-05-03 03:48:13', '2018-05-07 00:29:58'),
(469, 'Challan Search', 235, 'en', 0, 1, '2018-05-06 23:53:37', '2018-05-06 23:56:13'),
(470, 'চালান অনুসন্ধান', 235, 'bn', 0, 1, '2018-05-06 23:53:37', '2018-05-06 23:56:13'),
(471, 'Challan No', 236, 'en', 0, 1, '2018-05-06 23:58:00', '2018-05-07 00:01:36'),
(472, 'চালান সংখ্যা', 236, 'bn', 0, 1, '2018-05-06 23:58:00', '2018-05-07 00:01:36'),
(473, 'Order List', 237, 'en', 0, 1, '2018-05-07 00:53:50', '2018-05-07 00:54:20'),
(474, 'অর্ডার তালিকা', 237, 'bn', 0, 1, '2018-05-07 00:53:50', '2018-05-07 00:54:20'),
(475, 'Order List', 238, 'en', 0, 1, '2018-05-07 01:00:57', '2018-05-07 01:01:34'),
(476, 'অর্ডার তালিকা', 238, 'bn', 0, 1, '2018-05-07 01:00:57', '2018-05-07 01:01:34'),
(477, 'Create IPO', 239, 'en', 0, 1, '2018-05-07 01:58:13', '2018-05-07 01:59:32'),
(478, 'আইপিও তৈরি করুন', 239, 'bn', 0, 1, '2018-05-07 01:58:13', '2018-05-07 01:59:32'),
(479, 'Initial Increase', 240, 'en', 0, 1, '2018-05-07 02:01:49', '2018-05-07 02:02:28'),
(480, 'প্রাথমিক বৃদ্ধি', 240, 'bn', 0, 1, '2018-05-07 02:01:49', '2018-05-07 02:02:28'),
(481, 'Update Header', 241, 'en', 0, 1, '2018-05-10 03:00:27', '2018-05-10 03:01:24'),
(482, 'হেডার আপডেট করুন', 241, 'bn', 0, 1, '2018-05-10 03:00:27', '2018-05-10 03:01:25'),
(483, 'Report footer list', 242, 'en', 0, 1, '2018-05-10 23:31:45', '2018-05-10 23:32:22'),
(484, 'পাদলেখ তালিকাটি প্রতিবেদন করুন', 242, 'bn', 0, 1, '2018-05-10 23:31:46', '2018-05-10 23:32:22'),
(485, 'Update report', 243, 'en', 0, 1, '2018-05-10 23:37:20', '2018-05-10 23:37:48'),
(486, 'আপডেট রিপোর্ট', 243, 'bn', 0, 1, '2018-05-10 23:37:20', '2018-05-10 23:37:48'),
(487, 'Update brand', 244, 'en', 0, 1, '2018-05-11 00:34:47', '2018-05-11 00:36:44'),
(488, 'ব্র্যান্ড আপডেট করুন', 244, 'bn', 0, 1, '2018-05-11 00:34:47', '2018-05-11 00:36:45'),
(489, 'Brand List', 245, 'en', 0, 1, '2018-05-11 00:37:57', '2018-05-11 00:38:16'),
(490, 'ব্র্যান্ড তালিকা', 245, 'bn', 0, 1, '2018-05-11 00:37:57', '2018-05-11 00:38:16'),
(491, 'Vendor List', 246, 'en', 0, 1, '2018-05-11 00:41:44', '2018-07-09 00:03:52'),
(492, 'বিক্রেতা তালিকা', 246, 'bn', 0, 1, '2018-05-11 00:41:44', '2018-07-09 00:03:52'),
(493, 'Status', 247, 'en', 0, 1, '2018-05-11 00:45:50', '2018-05-11 00:46:05'),
(494, 'অবস্থা', 247, 'bn', 0, 1, '2018-05-11 00:45:50', '2018-05-11 00:46:05'),
(495, 'Invoice', 248, 'en', 0, 1, '2018-05-11 00:46:18', '2018-05-11 00:46:37'),
(496, 'চালান', 248, 'bn', 0, 1, '2018-05-11 00:46:18', '2018-05-11 00:46:37'),
(497, 'Shipment', 249, 'en', 0, 1, '2018-05-11 00:46:44', '2018-07-09 00:15:26'),
(498, 'Shipment', 249, 'bn', 0, 1, '2018-05-11 00:46:45', '2018-07-09 00:15:27'),
(499, 'Company Sort name', 250, 'en', 0, 1, '2018-05-11 00:55:04', '2018-06-21 00:34:12'),
(500, 'কোম্পানি সাজানোর নাম', 250, 'bn', 0, 1, '2018-05-11 00:55:05', '2018-06-21 00:34:12'),
(501, 'Header list', 251, 'en', 0, 1, '2018-05-11 02:29:51', '2018-05-11 02:30:16'),
(502, 'শিরোনাম তালিকা', 251, 'bn', 0, 1, '2018-05-11 02:29:51', '2018-05-11 02:30:16'),
(503, 'Add header', 252, 'en', 0, 1, '2018-05-11 02:31:28', '2018-05-11 02:31:43'),
(504, 'শিরোলেখ যোগ করুন', 252, 'bn', 0, 1, '2018-05-11 02:31:28', '2018-05-11 02:31:43'),
(505, 'Address', 253, 'en', 0, 1, '2018-05-11 02:40:55', '2018-05-11 02:41:13'),
(506, 'ঠিকানা', 253, 'bn', 0, 1, '2018-05-11 02:40:55', '2018-05-11 02:41:13'),
(507, 'Footer Title', 254, 'en', 0, 1, '2018-05-11 02:43:38', '2018-05-11 02:43:55'),
(508, 'পাদটীকা শিরোনাম', 254, 'bn', 0, 1, '2018-05-11 02:43:38', '2018-05-11 02:43:55'),
(509, 'Update party', 255, 'en', 0, 1, '2018-05-11 02:47:49', '2018-05-11 02:48:07'),
(510, 'পার্টি আপডেট করুন', 255, 'bn', 0, 1, '2018-05-11 02:47:49', '2018-05-11 02:48:07'),
(511, 'Item List', 256, 'en', 0, 1, '2018-05-11 02:49:33', '2018-07-09 01:28:40'),
(512, 'পণ্য তালিকা', 256, 'bn', 0, 1, '2018-05-11 02:49:33', '2018-07-09 01:28:40'),
(513, 'Product size list', 257, 'en', 0, 1, '2018-05-13 23:30:27', '2018-05-13 23:30:45'),
(514, 'পণ্য আকার তালিকা', 257, 'bn', 0, 1, '2018-05-13 23:30:27', '2018-05-13 23:30:45'),
(515, 'Order Input', 258, 'en', 0, 1, '2018-05-16 00:09:31', '2018-05-16 00:10:04'),
(516, 'অর্ডার ইনপুট', 258, 'bn', 0, 1, '2018-05-16 00:09:31', '2018-05-16 00:10:04'),
(517, 'Task', 259, 'en', 0, 1, '2018-06-05 22:36:08', '2018-06-05 22:36:37'),
(518, 'কার্য', 259, 'bn', 0, 1, '2018-06-05 22:36:08', '2018-06-05 22:36:37'),
(519, 'GMTS color', 260, 'en', 0, 1, '2018-06-05 23:27:03', '2018-06-05 23:27:44'),
(520, 'জিএমএসএস রং', 260, 'bn', 0, 1, '2018-06-05 23:27:03', '2018-06-05 23:27:44'),
(521, 'GMTS Color List', 261, 'en', 0, 1, '2018-06-05 23:34:38', '2018-06-05 23:35:46'),
(522, 'জিএমএসএস রঙ তালিকা', 261, 'bn', 0, 1, '2018-06-05 23:34:38', '2018-06-05 23:35:46'),
(523, 'Add Color', 262, 'en', 0, 1, '2018-06-05 23:42:36', '2018-06-05 23:42:54'),
(524, 'রঙ যোগ করুন', 262, 'bn', 0, 1, '2018-06-05 23:42:36', '2018-06-05 23:42:54'),
(525, 'Add GMTS Color', 263, 'en', 0, 1, '2018-06-05 23:54:08', '2018-06-05 23:54:37'),
(526, 'GMTS রঙ যোগ করুন', 263, 'bn', 0, 1, '2018-06-05 23:54:08', '2018-06-05 23:54:37'),
(527, 'Color', 264, 'en', 0, 1, '2018-06-06 01:57:57', '2018-06-06 01:58:08'),
(528, 'Color', 264, 'bn', 0, 1, '2018-06-06 01:57:57', '2018-06-06 01:58:08'),
(529, 'Update GMTS color', 265, 'en', 0, 1, '2018-06-06 02:33:37', '2018-06-06 02:34:02'),
(530, 'আপডেট GMTS রঙ', 265, 'bn', 0, 1, '2018-06-06 02:33:37', '2018-06-06 02:34:02'),
(531, 'Update color', 266, 'en', 0, 1, '2018-06-06 02:34:28', '2018-06-06 02:34:49'),
(532, 'রঙ আপডেট করুন', 266, 'bn', 0, 1, '2018-06-06 02:34:28', '2018-06-06 02:34:49'),
(533, 'Header Type', 267, 'en', 0, 1, '2018-06-08 02:58:26', '2018-06-08 02:58:49'),
(534, 'শিরোলেখ প্রকার', 267, 'bn', 0, 1, '2018-06-08 02:58:26', '2018-06-08 02:58:49'),
(535, 'Cell Number', 268, 'en', 0, 1, '2018-06-08 03:06:08', '2018-06-08 03:06:29'),
(536, 'সেল নম্বর', 268, 'bn', 0, 1, '2018-06-08 03:06:08', '2018-06-08 03:06:29'),
(537, 'Attention', 269, 'en', 0, 1, '2018-06-08 03:06:38', '2018-06-08 03:07:02'),
(538, 'মনোযোগ', 269, 'bn', 0, 1, '2018-06-08 03:06:38', '2018-06-08 03:07:02'),
(539, 'Production', 270, 'en', 0, 1, '2018-06-20 06:29:05', '2018-06-20 06:29:17'),
(540, 'Production', 270, 'bn', 0, 1, '2018-06-20 06:29:05', '2018-06-20 06:29:17'),
(541, 'Booking List', 271, 'en', 0, 1, '2018-06-20 06:29:40', '2018-06-20 06:29:51'),
(542, 'Booking List', 271, 'bn', 0, 1, '2018-06-20 06:29:40', '2018-06-20 06:29:51'),
(543, 'Booking List', 272, 'en', 0, 1, '2018-06-21 04:07:20', '2018-06-21 04:07:35'),
(544, 'Booking List', 272, 'bn', 0, 1, '2018-06-21 04:07:20', '2018-06-21 04:07:35'),
(545, 'Add Item', 273, 'en', 0, 1, '2018-07-09 01:31:09', '2018-07-09 01:31:28'),
(546, 'আইটেম যোগ করুন', 273, 'bn', 0, 1, '2018-07-09 01:31:09', '2018-07-09 01:31:28'),
(547, 'Update Item', 274, 'en', 0, 1, '2018-07-09 01:40:20', '2018-07-09 01:42:12'),
(548, 'আইটেম আপডেট করুন', 274, 'bn', 0, 1, '2018-07-09 01:40:20', '2018-07-09 01:42:12'),
(549, 'Others Color', 275, 'en', 0, 1, '2018-07-10 01:18:23', '2018-07-10 01:18:46'),
(550, 'অন্যান্য রঙ', 275, 'bn', 0, 1, '2018-07-10 01:18:23', '2018-07-10 01:18:46'),
(551, 'New MRF Create', 276, 'en', 0, 1, '2018-07-10 02:31:49', '2018-07-10 02:32:36'),
(552, 'নতুন এমআরএফ তৈরি করুন', 276, 'bn', 0, 1, '2018-07-10 02:31:49', '2018-07-10 02:32:36'),
(553, 'Create', 277, 'en', 0, 1, '2018-07-10 02:46:42', '2018-07-10 02:46:56'),
(554, 'সৃষ্টি', 277, 'bn', 0, 1, '2018-07-10 02:46:42', '2018-07-10 02:46:56'),
(555, 'MRF List', 278, 'en', 0, 1, '2018-07-10 06:40:06', '2018-07-10 06:40:28'),
(556, 'এমআরএফ তালিকা', 278, 'bn', 0, 1, '2018-07-10 06:40:06', '2018-07-10 06:40:28'),
(557, 'Challan List', 279, 'en', 0, 1, '2018-07-13 05:04:03', '2018-07-13 05:04:52'),
(558, 'Challan List', 279, 'bn', 0, 1, '2018-07-13 05:04:03', '2018-07-13 05:04:52'),
(559, 'Generate Purchase Order', 280, 'en', 0, 1, '2018-07-28 01:46:36', '2018-07-28 01:47:12'),
(560, 'ক্রয় অর্ডার তৈরি করুন', 280, 'bn', 0, 1, '2018-07-28 01:46:36', '2018-07-28 01:47:12'),
(561, 'Purchase Order List', 281, 'en', 0, 1, '2018-07-28 03:30:47', '2018-07-28 03:31:20'),
(562, 'অর্ডার তালিকা ক্রয়', 281, 'bn', 0, 1, '2018-07-28 03:30:47', '2018-07-28 03:31:20');

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
(139, 1, '2018-03-09 19:09:55', '2018-03-09 19:09:55', 'party_name_label'),
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
(156, 1, '2018-04-02 06:48:56', '2018-04-02 06:48:56', 'mxp_view_btn'),
(157, 1, '2018-04-10 00:01:48', '2018-04-10 00:01:48', 'mxp_menu_management'),
(158, 1, '2018-04-10 00:38:18', '2018-04-10 00:38:18', 'mxp_menu_product_list'),
(159, 1, '2018-04-10 04:32:01', '2018-04-10 04:32:01', 'product_description_label'),
(160, 1, '2018-04-10 04:34:38', '2018-04-10 04:34:38', 'product_brand_label'),
(161, 1, '2018-04-10 04:41:38', '2018-04-10 04:41:38', 'product_erp_code_label'),
(162, 1, '2018-04-10 04:43:37', '2018-04-10 04:43:37', 'product_unit_price_label'),
(163, 1, '2018-04-10 04:46:17', '2018-04-10 04:46:17', 'product_weight_qty_label'),
(164, 1, '2018-04-10 04:46:54', '2018-04-10 04:46:54', 'product_weight_amt_label'),
(165, 1, '2018-04-10 04:51:05', '2018-04-10 04:51:05', 'product_description1_label'),
(166, 1, '2018-04-10 04:51:29', '2018-04-10 04:51:29', 'product_description2_label'),
(167, 1, '2018-04-10 04:54:29', '2018-04-10 04:54:29', 'product_description3_label'),
(168, 1, '2018-04-10 04:54:44', '2018-04-10 04:54:44', 'product_description4_label'),
(169, 1, '2018-04-12 00:30:29', '2018-04-12 00:30:29', 'mxp_menu_party_list'),
(170, 1, '2018-04-12 00:34:45', '2018-04-12 00:34:45', 'party_id_label'),
(171, 1, '2018-04-12 00:35:35', '2018-04-12 00:35:35', 'name_buyer_label'),
(172, 1, '2018-04-12 00:36:08', '2018-04-12 00:36:08', 'address_part_1_invoice_label'),
(173, 1, '2018-04-12 00:37:02', '2018-04-12 00:37:02', 'address_part_2_invoice_label'),
(174, 1, '2018-04-12 00:38:52', '2018-04-12 00:38:52', 'attention_invoice_label'),
(175, 1, '2018-04-12 00:39:26', '2018-04-12 00:39:26', 'mobile_invoice_label'),
(176, 1, '2018-04-12 00:40:01', '2018-04-12 00:40:01', 'telephone_invoice_label'),
(177, 1, '2018-04-12 00:40:51', '2018-04-12 00:40:51', 'fax_invoice_label'),
(178, 1, '2018-04-12 00:41:25', '2018-04-12 00:41:25', 'address_part1_delivery_label'),
(179, 1, '2018-04-12 00:41:54', '2018-04-12 00:41:54', 'address_part2_delivery_label'),
(180, 1, '2018-04-12 00:42:23', '2018-04-12 00:42:23', 'attention_delivery_label'),
(181, 1, '2018-04-12 00:42:51', '2018-04-12 00:42:51', 'mobile_delivery_label'),
(182, 1, '2018-04-12 00:43:13', '2018-04-12 00:43:13', 'telephone_delivery_label'),
(183, 1, '2018-04-12 00:43:40', '2018-04-12 00:43:40', 'fax_delivery_label'),
(184, 1, '2018-04-12 00:44:02', '2018-04-12 00:44:02', 'description1_label'),
(185, 1, '2018-04-12 00:44:29', '2018-04-12 00:44:29', 'description2_label'),
(186, 1, '2018-04-12 00:44:53', '2018-04-12 00:44:53', 'description3_label'),
(187, 1, '2018-04-12 01:09:15', '2018-04-12 01:09:15', 'add_party_label'),
(188, 1, '2018-04-12 04:03:01', '2018-04-12 04:03:01', 'mxp_menu_page_header'),
(189, 1, '2018-04-12 04:16:18', '2018-04-12 04:16:18', 'header_title_label'),
(190, 1, '2018-04-12 04:19:01', '2018-04-12 04:19:01', 'header_fontsize_label'),
(191, 1, '2018-04-12 04:21:38', '2018-04-12 04:21:38', 'header_font_style_label'),
(192, 1, '2018-04-12 04:26:04', '2018-04-12 04:26:04', 'header_color_label'),
(193, 1, '2018-04-12 04:26:24', '2018-04-12 04:26:24', 'header_address1_label'),
(194, 1, '2018-04-12 04:29:35', '2018-04-12 04:29:35', 'header_address3_label'),
(195, 1, '2018-04-12 04:30:05', '2018-04-12 04:30:05', 'header_logo_aligment_label'),
(196, 1, '2018-04-12 04:30:39', '2018-04-12 04:30:39', 'header_address2_label'),
(197, 1, '2018-04-12 04:31:03', '2018-04-12 04:31:03', 'header_logo_label'),
(198, 1, '2018-04-12 05:31:25', '2018-04-12 05:31:25', 'mxp_menu_page'),
(199, 1, '2018-04-12 05:38:56', '2018-04-12 05:38:56', 'mxp_menu_page_footer'),
(200, 1, '2018-04-12 06:07:56', '2018-04-12 06:07:56', 'add_page_footer_title_label'),
(201, 1, '2018-04-12 06:09:53', '2018-04-12 06:09:53', 'page_footer_title_label'),
(202, 0, '2018-04-12 06:10:56', '2018-04-12 06:10:56', 'enter_title_label'),
(203, 1, '2018-04-13 02:05:45', '2018-04-13 02:05:45', 'update_page_footer_title_label'),
(204, 1, '2018-04-13 02:35:41', '2018-04-13 02:35:41', 'mxp_menu_report_footer'),
(205, 1, '2018-04-13 04:43:27', '2018-04-13 04:43:27', 'add_report_footer_label'),
(206, 1, '2018-04-13 04:44:39', '2018-04-13 04:44:39', 'report_name_label'),
(207, 1, '2018-04-13 04:48:23', '2018-04-13 04:48:23', 're_fo_des3_label'),
(208, 1, '2018-04-13 04:49:10', '2018-04-13 04:49:10', 're_fo_des1_label'),
(209, 1, '2018-04-13 04:50:50', '2018-04-13 04:50:50', 're_fo_des4_label'),
(210, 1, '2018-04-13 04:51:12', '2018-04-13 04:51:12', 're_fo_des2_label'),
(211, 1, '2018-04-13 04:51:28', '2018-04-13 04:51:28', 're_fo_des5_label'),
(212, 1, '2018-04-13 04:56:18', '2018-04-13 04:56:18', 're_fo_siginingPerson_1_label'),
(213, 1, '2018-04-13 04:56:26', '2018-04-13 04:56:26', 're_fo_siginingPerson_2_label'),
(214, 1, '2018-04-13 07:03:29', '2018-04-13 07:03:29', 'person_1_signature'),
(215, 1, '2018-04-13 07:04:58', '2018-04-13 07:04:58', 'persion_seal_label'),
(216, 1, '2018-04-13 07:26:33', '2018-04-13 07:26:33', 'person_name_label'),
(217, 1, '2018-04-16 00:43:54', '2018-04-16 00:43:54', 'mxp_menu_brand'),
(218, 1, '2018-04-16 01:36:20', '2018-04-16 01:36:20', 'add_brand_label'),
(219, 1, '2018-04-16 01:42:14', '2018-04-16 01:42:14', 'brand_name_label'),
(220, 1, '2018-04-16 02:25:24', '2018-04-16 02:25:24', 'mxp_menu_product_size'),
(221, 1, '2018-04-16 04:19:18', '2018-04-16 04:19:18', 'add_product_size_label'),
(222, 1, '2018-04-16 04:21:37', '2018-04-16 04:21:37', 'product_size_label'),
(223, 1, '2018-04-16 04:23:26', '2018-04-16 04:23:26', 'add_size_label'),
(224, 1, '2018-04-16 06:09:18', '2018-04-16 06:09:18', 'header_font_size_label'),
(225, 1, '2018-04-16 06:11:24', '2018-04-16 06:11:24', 'header_colour_label'),
(226, 1, '2018-04-16 06:12:38', '2018-04-16 06:12:38', 'logo_allignment_label'),
(227, 1, '2018-04-17 05:31:18', '2018-04-17 05:31:18', 'mxp_menu_print'),
(228, 1, '2018-04-17 05:32:54', '2018-04-17 05:32:54', 'mxp_menu_bill_copy'),
(229, 1, '2018-04-25 22:24:35', '2018-04-25 22:24:35', 'mxp_menu_all_bill_view'),
(230, 1, '2018-05-03 00:37:53', '2018-05-03 00:37:53', 'add_searchbill_label'),
(231, 1, '2018-05-03 00:43:16', '2018-05-03 00:43:16', 'bill_invo_no_label'),
(232, 1, '2018-05-03 02:54:24', '2018-05-03 02:54:24', 'search_button'),
(233, 1, '2018-05-03 02:59:29', '2018-05-03 02:59:29', 'genarate_bill_button'),
(234, 1, '2018-05-03 03:48:13', '2018-05-03 03:48:13', 'mxp_menu_challan_boxing_list'),
(235, 1, '2018-05-06 23:53:37', '2018-05-06 23:53:37', 'mxp_menu_multiple_challan_search'),
(236, 1, '2018-05-06 23:58:00', '2018-05-06 23:58:00', 'challan_no_label'),
(237, 1, '2018-05-07 00:53:50', '2018-05-07 00:53:50', 'mxp_menu_order_list_view'),
(238, 1, '2018-05-07 01:00:57', '2018-05-07 01:00:57', 'mxp_menu_order_list'),
(239, 1, '2018-05-07 01:58:12', '2018-05-07 01:58:12', 'mxp_menu_ipo_view'),
(240, 1, '2018-05-07 02:01:49', '2018-05-07 02:01:49', 'initial_increase_label'),
(241, 1, '2018-05-10 03:00:27', '2018-05-10 03:00:27', 'update_ueader'),
(242, 1, '2018-05-10 23:31:45', '2018-05-10 23:31:45', 'report_footer_list'),
(243, 1, '2018-05-10 23:37:20', '2018-05-10 23:37:20', 'update_report_footer_label'),
(244, 1, '2018-05-11 00:34:47', '2018-05-11 00:34:47', 'update_brand_label'),
(245, 1, '2018-05-11 00:37:57', '2018-05-11 00:37:57', 'brand_list_label'),
(246, 1, '2018-05-11 00:41:44', '2018-05-11 00:41:44', 'party_list_label'),
(247, 1, '2018-05-11 00:45:50', '2018-05-11 00:45:50', 'header_status_label'),
(248, 1, '2018-05-11 00:46:18', '2018-05-11 00:46:18', 'invoice_label'),
(249, 1, '2018-05-11 00:46:44', '2018-05-11 00:46:44', 'delivery_label'),
(250, 1, '2018-05-11 00:55:04', '2018-05-11 00:55:04', 'sort_name_label'),
(251, 1, '2018-05-11 02:29:51', '2018-05-11 02:29:51', 'header_list_label'),
(252, 1, '2018-05-11 02:31:28', '2018-05-11 02:31:28', 'add_header_label'),
(253, 1, '2018-05-11 02:40:55', '2018-05-11 02:40:55', 'header_address_label'),
(254, 1, '2018-05-11 02:43:38', '2018-05-11 02:43:38', 'footer_title_label'),
(255, 1, '2018-05-11 02:47:49', '2018-05-11 02:47:49', 'update_party_label'),
(256, 1, '2018-05-11 02:49:32', '2018-05-11 02:49:32', 'product_list_label'),
(257, 1, '2018-05-13 23:30:27', '2018-05-13 23:30:27', 'product_size_list'),
(258, 1, '2018-05-16 00:09:31', '2018-05-16 00:09:31', 'mxp_menu_order_input'),
(259, 1, '2018-06-05 22:36:08', '2018-06-05 22:36:08', 'task_label'),
(260, 1, '2018-06-05 23:27:03', '2018-06-05 23:27:03', 'mxp_menu_gmts_color'),
(261, 1, '2018-06-05 23:34:38', '2018-06-05 23:34:38', 'Gmts_color_list_label'),
(262, 1, '2018-06-05 23:42:36', '2018-06-05 23:42:36', 'add_color_label'),
(263, 1, '2018-06-05 23:54:08', '2018-06-05 23:54:08', 'add_gmts_color_label'),
(264, 1, '2018-06-06 01:57:57', '2018-06-06 01:57:57', 'gmts_color_label'),
(265, 1, '2018-06-06 02:33:37', '2018-06-06 02:33:37', 'update_gmts_color_label'),
(266, 1, '2018-06-06 02:34:28', '2018-06-06 02:34:28', 'update_color_label'),
(267, 1, '2018-06-08 02:58:26', '2018-06-08 02:58:26', 'header_type_label'),
(268, 1, '2018-06-08 03:06:08', '2018-06-08 03:06:08', 'header_cell_number_label'),
(269, 1, '2018-06-08 03:06:38', '2018-06-08 03:06:38', 'header_attention_label'),
(270, 1, '2018-06-20 06:29:05', '2018-06-20 06:29:05', 'mxp_menu_production'),
(271, 1, '2018-06-20 06:29:40', '2018-06-20 06:29:40', 'mxp_menu_booking'),
(272, 1, '2018-06-21 04:07:20', '2018-06-21 04:07:20', 'mxp_menu_booking_list'),
(273, 1, '2018-07-09 01:31:09', '2018-07-09 01:31:09', 'add_product_label'),
(274, 1, '2018-07-09 01:40:20', '2018-07-09 01:40:20', 'update_product_label'),
(275, 1, '2018-07-10 01:18:23', '2018-07-10 01:18:23', 'others_color_label'),
(276, 1, '2018-07-10 02:31:49', '2018-07-10 02:31:49', 'new_mrf_create_label'),
(277, 1, '2018-07-10 02:46:42', '2018-07-10 02:46:42', 'create_button_lable'),
(278, 1, '2018-07-10 06:40:06', '2018-07-10 06:40:06', 'mxp_menu_mrf_list'),
(279, 1, '2018-07-13 05:04:03', '2018-07-13 05:04:03', 'mxp_menu_challan_list'),
(280, 1, '2018-07-28 01:46:36', '2018-07-28 01:46:36', 'mxp_menu_purchase_order'),
(281, 1, '2018-07-28 03:30:47', '2018-07-28 03:30:47', 'mxp_menu_purchase_order_list');

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
(1, 'Super Admin', 'middle', 'last', NULL, 'super_admin', 0, 0, 'sajibg7@gmail.com', '$2y$10$BIvmvrQf1a5G3mrmHlrN9ulYV1fKtgUoJaK968BJ2foPBTkVjWn7S', '123456789', 'SDIzAcbIQcU6OPm7xDj2sBk8S88Qms3OcsZAQCYsud13Nbs3AAGcD4Bf2RiL', 1, 1, 0, '0', '2018-01-15 01:37:15', '2018-03-05 13:29:32'),
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
(48, 'test user', NULL, NULL, NULL, 'company_user', 1, 10, 'sajibg7+09@gmail.com', '$2y$10$NItNEFuZfxtXosv7iRoU0utNjKMIijcYPFTj5J/r26AY86hZg2w6W', '123456', NULL, 1, 29, 0, '0', '2018-04-09 01:58:28', '2018-04-09 01:58:28'),
(49, 'shohidur', NULL, 'Rahman', NULL, 'super_admin', 0, 0, 'sohidurr49@gmail.com', '$2y$10$.JwEQcEC.OTXRG4aP/PsU.iomnby.5ndA35BeOVrh2Mb03x1LMlsS', '01792755683', '21RSS0AlFC87FxUxmRJzqBKfRRl0ReJphRcyBLl3Emf7OD2vNm63bhff5wRf', 1, 1, 0, '0', '2018-04-09 04:17:47', '2018-04-09 04:17:47'),
(50, 'Shohid', NULL, NULL, NULL, 'company_user', 49, 18, 'test111@mail.com', '$2y$10$lhlWW/5g71MYtdPWgcGLbOlCEzeVRcVlhmab7KGhHEI7.n2EtmC.O', '1234567890', 'I0QouznQ2v43e8SflagFdAzhvPGLvm3328IZLS76Yt1PZJny12BmolxXhNg9', 1, 31, 0, '0', '2018-05-10 00:10:17', '2018-05-10 00:10:17');

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
(185, 1, 25, 0, 0, '2018-01-26 12:24:42', '2018-01-26 12:24:42'),
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
(868, 29, 20, 10, 1, '2018-04-09 01:57:58', '2018-04-09 01:57:58'),
(869, 1, 73, 0, 1, NULL, NULL),
(870, 1, 74, 0, 1, NULL, NULL),
(871, 1, 75, 0, 1, NULL, NULL),
(872, 1, 76, 0, 1, NULL, NULL),
(885, 1, 85, 0, 1, NULL, NULL),
(886, 1, 86, 0, 1, NULL, NULL),
(887, 1, 87, 0, 1, NULL, NULL),
(1023, 31, 90, 18, 1, '2018-05-10 02:03:27', '2018-05-10 02:03:27'),
(1024, 31, 4, 18, 1, '2018-05-10 02:03:27', '2018-05-10 02:03:27'),
(1025, 31, 38, 18, 1, '2018-05-10 02:03:27', '2018-05-10 02:03:27'),
(1026, 31, 88, 18, 1, '2018-05-10 02:03:27', '2018-05-10 02:03:27'),
(1027, 31, 91, 18, 1, '2018-05-10 02:03:27', '2018-05-10 02:03:27'),
(1028, 31, 87, 18, 1, '2018-05-10 02:03:27', '2018-05-10 02:03:27'),
(1029, 31, 92, 18, 1, '2018-05-10 02:03:27', '2018-05-10 02:03:27'),
(1030, 31, 94, 18, 1, '2018-05-10 02:03:27', '2018-05-10 02:03:27'),
(1031, 31, 75, 18, 1, '2018-05-10 02:03:27', '2018-05-10 02:03:27'),
(1032, 31, 93, 18, 1, '2018-05-10 02:03:28', '2018-05-10 02:03:28'),
(1033, 31, 83, 18, 1, '2018-05-10 02:03:28', '2018-05-10 02:03:28'),
(1034, 31, 85, 18, 1, '2018-05-10 02:03:28', '2018-05-10 02:03:28'),
(1035, 31, 84, 18, 1, '2018-05-10 02:03:28', '2018-05-10 02:03:28'),
(1036, 31, 89, 18, 1, '2018-05-10 02:03:28', '2018-05-10 02:03:28'),
(1037, 31, 86, 18, 1, '2018-05-10 02:03:28', '2018-05-10 02:03:28'),
(1038, 30, 25, 17, 1, '2018-05-16 01:57:34', '2018-05-16 01:57:34'),
(1039, 30, 67, 17, 1, '2018-05-16 01:57:34', '2018-05-16 01:57:34'),
(1040, 30, 90, 17, 1, '2018-05-16 01:57:34', '2018-05-16 01:57:34'),
(1041, 30, 68, 17, 1, '2018-05-16 01:57:34', '2018-05-16 01:57:34'),
(1042, 30, 71, 17, 1, '2018-05-16 01:57:34', '2018-05-16 01:57:34'),
(1043, 30, 70, 17, 1, '2018-05-16 01:57:34', '2018-05-16 01:57:34'),
(1044, 30, 28, 17, 1, '2018-05-16 01:57:34', '2018-05-16 01:57:34'),
(1045, 30, 19, 17, 1, '2018-05-16 01:57:34', '2018-05-16 01:57:34'),
(1046, 30, 72, 17, 1, '2018-05-16 01:57:34', '2018-05-16 01:57:34'),
(1047, 30, 69, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1048, 30, 18, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1049, 30, 4, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1050, 30, 31, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1051, 30, 3, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1052, 30, 24, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1053, 30, 27, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1054, 30, 95, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1055, 30, 30, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1056, 30, 89, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1057, 30, 38, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1058, 30, 76, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1059, 30, 88, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1060, 30, 6, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1061, 30, 8, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1062, 30, 5, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1063, 30, 26, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1064, 30, 29, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1065, 30, 33, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1066, 30, 32, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1067, 30, 20, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1068, 30, 91, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1069, 30, 87, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1070, 30, 92, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1071, 30, 94, 17, 1, '2018-05-16 01:57:35', '2018-05-16 01:57:35'),
(1072, 30, 75, 17, 1, '2018-05-16 01:57:36', '2018-05-16 01:57:36'),
(1073, 30, 93, 17, 1, '2018-05-16 01:57:36', '2018-05-16 01:57:36'),
(1074, 30, 83, 17, 1, '2018-05-16 01:57:36', '2018-05-16 01:57:36'),
(1075, 30, 85, 17, 1, '2018-05-16 01:57:36', '2018-05-16 01:57:36'),
(1076, 30, 84, 17, 1, '2018-05-16 01:57:36', '2018-05-16 01:57:36'),
(1077, 30, 78, 17, 1, '2018-05-16 01:57:36', '2018-05-16 01:57:36'),
(1078, 30, 86, 17, 1, '2018-05-16 01:57:36', '2018-05-16 01:57:36');

-- --------------------------------------------------------

--
-- Table structure for table `mxp_vendor_prices`
--

CREATE TABLE `mxp_vendor_prices` (
  `price_id` int(10) UNSIGNED NOT NULL,
  `party_table_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `vendor_com_price` double(8,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mxp_vendor_prices`
--

INSERT INTO `mxp_vendor_prices` (`price_id`, `party_table_id`, `product_id`, `vendor_com_price`, `created_at`, `updated_at`) VALUES
(1, 3, 1, 1.00, '2018-07-27 03:49:55', '2018-07-27 03:49:55'),
(2, 2, 1, 1.10, '2018-07-27 03:49:55', '2018-07-27 03:49:55'),
(3, 4, 1, 1.20, '2018-07-27 03:49:55', '2018-07-27 03:49:55'),
(4, 6, 1, 1.30, '2018-07-27 03:49:55', '2018-07-27 03:49:55'),
(5, 5, 1, 1.40, '2018-07-27 03:49:55', '2018-07-27 03:49:55');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_delete` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`supplier_id`, `name`, `phone`, `address`, `is_delete`, `status`, `created_at`, `updated_at`) VALUES
(1, 'MyName', 'Contact', 'Address', 0, 1, '2018-07-21 01:58:35', '2018-07-21 01:58:35'),
(2, 'new Supllier', '01743654654', 'Address', 0, 1, '2018-08-07 00:25:31', '2018-08-07 00:25:31');

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
-- Indexes for table `mxp_booking`
--
ALTER TABLE `mxp_booking`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_bookingBuyer_details`
--
ALTER TABLE `mxp_bookingBuyer_details`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_booking_challan`
--
ALTER TABLE `mxp_booking_challan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_booking_multiplechallan`
--
ALTER TABLE `mxp_booking_multiplechallan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_brand`
--
ALTER TABLE `mxp_brand`
  ADD PRIMARY KEY (`brand_id`);

--
-- Indexes for table `mxp_challan`
--
ALTER TABLE `mxp_challan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_companies`
--
ALTER TABLE `mxp_companies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_gmts_color`
--
ALTER TABLE `mxp_gmts_color`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_header`
--
ALTER TABLE `mxp_header`
  ADD PRIMARY KEY (`header_id`);

--
-- Indexes for table `mxp_ipo`
--
ALTER TABLE `mxp_ipo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_items_details_by_booking_challan`
--
ALTER TABLE `mxp_items_details_by_booking_challan`
  ADD PRIMARY KEY (`items_details_id`);

--
-- Indexes for table `mxp_languages`
--
ALTER TABLE `mxp_languages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_maximbill`
--
ALTER TABLE `mxp_maximbill`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_menu`
--
ALTER TABLE `mxp_menu`
  ADD PRIMARY KEY (`menu_id`);

--
-- Indexes for table `mxp_MRF_table`
--
ALTER TABLE `mxp_MRF_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Mxp_multipleChallan`
--
ALTER TABLE `Mxp_multipleChallan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_order`
--
ALTER TABLE `mxp_order`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_order_input`
--
ALTER TABLE `mxp_order_input`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_pageFooter`
--
ALTER TABLE `mxp_pageFooter`
  ADD PRIMARY KEY (`footer_id`);

--
-- Indexes for table `mxp_pageheader`
--
ALTER TABLE `mxp_pageheader`
  ADD PRIMARY KEY (`header_id`);

--
-- Indexes for table `mxp_party`
--
ALTER TABLE `mxp_party`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_piformat_data_info`
--
ALTER TABLE `mxp_piformat_data_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_product`
--
ALTER TABLE `mxp_product`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `mxp_productSize`
--
ALTER TABLE `mxp_productSize`
  ADD PRIMARY KEY (`proSize_id`);

--
-- Indexes for table `mxp_purchase_orders`
--
ALTER TABLE `mxp_purchase_orders`
  ADD PRIMARY KEY (`po_id`);

--
-- Indexes for table `mxp_reportFooter`
--
ALTER TABLE `mxp_reportFooter`
  ADD PRIMARY KEY (`re_footer_id`);

--
-- Indexes for table `mxp_role`
--
ALTER TABLE `mxp_role`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mxp_supplier_prices`
--
ALTER TABLE `mxp_supplier_prices`
  ADD PRIMARY KEY (`supplier_price_id`);

--
-- Indexes for table `mxp_task`
--
ALTER TABLE `mxp_task`
  ADD PRIMARY KEY (`id_mxp_task`);

--
-- Indexes for table `mxp_task_role`
--
ALTER TABLE `mxp_task_role`
  ADD PRIMARY KEY (`id_mxp_task_role`);

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
-- Indexes for table `mxp_vendor_prices`
--
ALTER TABLE `mxp_vendor_prices`
  ADD PRIMARY KEY (`price_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=264;

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
-- AUTO_INCREMENT for table `mxp_booking`
--
ALTER TABLE `mxp_booking`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=318;

--
-- AUTO_INCREMENT for table `mxp_bookingBuyer_details`
--
ALTER TABLE `mxp_bookingBuyer_details`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `mxp_booking_challan`
--
ALTER TABLE `mxp_booking_challan`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=163;

--
-- AUTO_INCREMENT for table `mxp_booking_multiplechallan`
--
ALTER TABLE `mxp_booking_multiplechallan`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `mxp_brand`
--
ALTER TABLE `mxp_brand`
  MODIFY `brand_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `mxp_challan`
--
ALTER TABLE `mxp_challan`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mxp_companies`
--
ALTER TABLE `mxp_companies`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `mxp_gmts_color`
--
ALTER TABLE `mxp_gmts_color`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `mxp_header`
--
ALTER TABLE `mxp_header`
  MODIFY `header_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `mxp_ipo`
--
ALTER TABLE `mxp_ipo`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `mxp_items_details_by_booking_challan`
--
ALTER TABLE `mxp_items_details_by_booking_challan`
  MODIFY `items_details_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=170;

--
-- AUTO_INCREMENT for table `mxp_languages`
--
ALTER TABLE `mxp_languages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `mxp_maximbill`
--
ALTER TABLE `mxp_maximbill`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `mxp_menu`
--
ALTER TABLE `mxp_menu`
  MODIFY `menu_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT for table `mxp_MRF_table`
--
ALTER TABLE `mxp_MRF_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT for table `Mxp_multipleChallan`
--
ALTER TABLE `Mxp_multipleChallan`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=325;

--
-- AUTO_INCREMENT for table `mxp_order`
--
ALTER TABLE `mxp_order`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `mxp_order_input`
--
ALTER TABLE `mxp_order_input`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mxp_pageFooter`
--
ALTER TABLE `mxp_pageFooter`
  MODIFY `footer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mxp_pageheader`
--
ALTER TABLE `mxp_pageheader`
  MODIFY `header_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mxp_party`
--
ALTER TABLE `mxp_party`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `mxp_piformat_data_info`
--
ALTER TABLE `mxp_piformat_data_info`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `mxp_product`
--
ALTER TABLE `mxp_product`
  MODIFY `product_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `mxp_productSize`
--
ALTER TABLE `mxp_productSize`
  MODIFY `proSize_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `mxp_purchase_orders`
--
ALTER TABLE `mxp_purchase_orders`
  MODIFY `po_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=379;

--
-- AUTO_INCREMENT for table `mxp_reportFooter`
--
ALTER TABLE `mxp_reportFooter`
  MODIFY `re_footer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `mxp_role`
--
ALTER TABLE `mxp_role`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `mxp_supplier_prices`
--
ALTER TABLE `mxp_supplier_prices`
  MODIFY `supplier_price_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `mxp_task`
--
ALTER TABLE `mxp_task`
  MODIFY `id_mxp_task` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `mxp_task_role`
--
ALTER TABLE `mxp_task_role`
  MODIFY `id_mxp_task_role` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `mxp_translations`
--
ALTER TABLE `mxp_translations`
  MODIFY `translation_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=563;

--
-- AUTO_INCREMENT for table `mxp_translation_keys`
--
ALTER TABLE `mxp_translation_keys`
  MODIFY `translation_key_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=282;

--
-- AUTO_INCREMENT for table `mxp_users`
--
ALTER TABLE `mxp_users`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `mxp_user_role_menu`
--
ALTER TABLE `mxp_user_role_menu`
  MODIFY `role_menu_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1079;

--
-- AUTO_INCREMENT for table `mxp_vendor_prices`
--
ALTER TABLE `mxp_vendor_prices`
  MODIFY `price_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
