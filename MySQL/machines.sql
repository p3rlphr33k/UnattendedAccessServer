SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE TABLE IF NOT EXISTS `machines` (
  `id` int(9) NOT NULL AUTO_INCREMENT,
  `account` varchar(100) NOT NULL,
  `hostname` varchar(200) NOT NULL,
  `IP` varchar(15) DEFAULT NULL,
  `command` varchar(1000) DEFAULT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `sessionid` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `updated` (`updated`),
  KEY `hostname` (`hostname`,`account`),
  KEY `account` (`account`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=43 ;
