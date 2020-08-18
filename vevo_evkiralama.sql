-- --------------------------------------------------------
-- Sunucu:                       185.126.177.45
-- Sunucu sürümü:                10.4.13-MariaDB - mariadb.org binary distribution
-- Sunucu İşletim Sistemi:       Win64
-- HeidiSQL Sürüm:               11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- essentialmode için veritabanı yapısı dökülüyor
CREATE DATABASE IF NOT EXISTS `essentialmode` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `essentialmode`;

-- tablo yapısı dökülüyor essentialmode.vevo_evkiralama
CREATE TABLE IF NOT EXISTS `vevo_evkiralama` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `daily_price` int(11) DEFAULT NULL,
  `weekly_price` int(11) DEFAULT NULL,
  `login_coords` varchar(255) DEFAULT NULL,
  `logout_coords` varchar(255) DEFAULT NULL,
  `dolap_coords` varchar(255) DEFAULT NULL,
  `blip_rengi` int(11) DEFAULT NULL,
  `kalan_gun` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- essentialmode.vevo_evkiralama: ~3 rows (yaklaşık) tablosu için veriler indiriliyor
/*!40000 ALTER TABLE `vevo_evkiralama` DISABLE KEYS */;
INSERT INTO `vevo_evkiralama` (`id`, `owner`, `name`, `daily_price`, `weekly_price`, `login_coords`, `logout_coords`, `dolap_coords`, `blip_rengi`, `kalan_gun`) VALUES
	(1, 'kiralik', 'Kiralık Ev', 15000, 50000, '{"x": -2588.24, "y": 1911.34, "z": 166.49, "heading": 9.74}', '{"x": -786.69, "y": 315.74, "z": 216.63, "heading": 271.8}', '{"x": -796.64, "y": 326.73, "z": 219.43}', 1, 1),
	(2, 'kiralik', 'Kiralık Ev', 15000, 50000, '{"x": -113.205, "y": 985.809, "z": 234.75, "heading": 110.93}', '{"x": -786.95, "y": 315.62, "z": 186.91, "heading": 275.27}', '{"x": -796.71, "y": 326.83, "z": 189.71}', 1, 1),
	(3, 'kiralik', 'Kiralık Ev', 20000, 75000, '{"x": -1846.62, "y": 299.26, "z": 88.32, "heading": 189.41}', '{"x": -774.34, "y": 341.99, "z": 195.68, "heading": 91.75}', '{"x": -764.41, "y": 330.35, "z": 198.48}', 1, 1);
/*!40000 ALTER TABLE `vevo_evkiralama` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
