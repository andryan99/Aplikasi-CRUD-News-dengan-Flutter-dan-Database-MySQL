-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 03, 2020 at 01:15 AM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `app_news`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_news`
--

CREATE TABLE `tbl_news` (
  `id_news` int(11) NOT NULL,
  `image` text NOT NULL,
  `title` text NOT NULL,
  `content` text NOT NULL,
  `description` text NOT NULL,
  `date_news` datetime NOT NULL,
  `id_users` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_news`
--

INSERT INTO `tbl_news` (`id_news`, `image`, `title`, `content`, `description`, `date_news`, `id_users`) VALUES
(2, '02102020104200scaled_image_picker4277199387363063979.jpg', 'oke', 'oke', 'oke', '2020-10-02 15:40:41', 2),
(3, '02102020153805scaled_image_picker4146849357542558613.jpg', 'oke2', 'oke', 'oke', '2020-10-02 15:42:00', 2);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `id_users` int(11) NOT NULL,
  `username` text NOT NULL,
  `email` text NOT NULL,
  `password` text NOT NULL,
  `level` int(11) NOT NULL,
  `register_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`id_users`, `username`, `email`, `password`, `level`, `register_date`) VALUES
(1, 'admin', 'admin@gmail.com', '0192023a7bbd73250516f069df18b500', 1, '2020-08-28 09:32:25'),
(2, 'oke', 'oke', '0079fcb602361af76c4fd616d60f9414', 1, '2020-10-02 06:23:07');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_news`
--
ALTER TABLE `tbl_news`
  ADD PRIMARY KEY (`id_news`),
  ADD KEY `id_users` (`id_users`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`id_users`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_news`
--
ALTER TABLE `tbl_news`
  MODIFY `id_news` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `id_users` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_news`
--
ALTER TABLE `tbl_news`
  ADD CONSTRAINT `tbl_news_ibfk_1` FOREIGN KEY (`id_users`) REFERENCES `tbl_users` (`id_users`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
