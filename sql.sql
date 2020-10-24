CREATE TABLE `pixel_badge` (
  `id` int(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `callsign` varchar(255) NOT NULL,
  `badge` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `pixel_badge`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pixel_badge`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;