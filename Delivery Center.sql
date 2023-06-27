CREATE database db_deliverycenter;
USE db_deliverycenter;

SELECT * FROM `channels`;
SELECT * FROM `hubs`;
SELECT * FROM `stores`;
SELECT * FROM `drivers`;
SELECT * FROM `deliveries`;
SELECT * FROM `payments`;
SELECT * FROM `orders`;

CREATE TABLE `db_deliverycenter`.`channels` (
  `channel_id` int DEFAULT NULL,
  `channel_name` text,
  `channel_type` text);

CREATE TABLE `db_deliverycenter`.`hubs` (
  `hub_id` int DEFAULT NULL,
  `hub_name` text,
  `hub_city` text,
  `hub_state` text,
  `hub_latitude` double DEFAULT NULL,
  `hub_longitude` double DEFAULT NULL);

CREATE TABLE `db_deliverycenter`.`stores` (
  `store_id` int DEFAULT NULL,
  `hub_id` int DEFAULT NULL,
  `store_name` text,
  `store_segment` text,
  `store_plan_price` int DEFAULT NULL,
  `store_latitude` text,
  `store_longitude` text);


CREATE TABLE `db_deliverycenter`.`drivers` (
  `driver_id` int DEFAULT NULL,
  `driver_modal` text,
  `driver_type` text);


CREATE TABLE `db_deliverycenter`.`deliveries` (
  `delivery_id` int DEFAULT NULL,
  `delivery_order_id` int DEFAULT NULL,
  `driver_id` int DEFAULT NULL,
  `delivery_distance_meters` int DEFAULT NULL,
  `delivery_status` text);


CREATE TABLE `db_deliverycenter`.`payments` (
  `payment_id` int DEFAULT NULL,
  `payment_order_id` int DEFAULT NULL,
  `payment_amount` double DEFAULT NULL,
  `payment_fee` double DEFAULT NULL,
  `payment_method` text,
  `payment_status` text);


CREATE TABLE `db_deliverycenter`.`orders` (
  `order_id` int DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `channel_id` int DEFAULT NULL,
  `payment_order_id` int DEFAULT NULL,
  `delivery_order_id` int DEFAULT NULL,
  `order_status` text,
  `order_amount` double DEFAULT NULL,
  `order_delivery_fee` int DEFAULT NULL,
  `order_delivery_cost` text,
  `order_created_hour` int DEFAULT NULL,
  `order_created_minute` int DEFAULT NULL,
  `order_created_day` int DEFAULT NULL,
  `order_created_month` int DEFAULT NULL,
  `order_created_year` int DEFAULT NULL,
  `order_moment_created` text,
  `order_moment_accepted` text,
  `order_moment_ready` text,
  `order_moment_collected` text,
  `order_moment_in_expedition` text,
  `order_moment_delivering` text,
  `order_moment_delivered` text,
  `order_moment_finished` text,
  `order_metric_collected_time` text,
  `order_metric_paused_time` text,
  `order_metric_production_time` text,
  `order_metric_walking_time` text,
  `order_metric_expediton_speed_time` text,
  `order_metric_transit_time` text,
  `order_metric_cycle_time` text);

/*1- Qual o número de hubs por cidade?*/ 
SELECT COUNT(hub_id) AS NumberOfHubs FROM `hubs`;

/*2- Qual o número de pedidos (orders) por status?*/
SELECT COUNT(order_status) AS NumberOfOrders FROM `orders` WHERE order_status = 'FINISHED';

/*3- Qual o número de lojas (stores) por cidade dos hubs?*/
SELECT h.hub_city, COUNT(s.store_id) AS NumberOfStores FROM hubs h INNER JOIN stores s ON h.hub_id = s.hub_id
GROUP BY h.hub_city;

/*4- Qual o maior e o menor valor de pagamento (payment_amount) registrado?*/
SELECT MAX(payment_amount) AS max_payment, MIN(payment_amount) AS min_payment FROM payments;

/*5- Qual tipo de driver (driver_type) fez o maior número de entregas?*/
SELECT driver_type, COUNT(*) AS NumberOfDeliveries FROM drivers d INNER JOIN deliveries dv ON d.driver_id = dv.driver_id
GROUP BY driver_type;

/*6- Qual a distância média das entregas por tipo de driver (driver_modal)?*/
SELECT driver_modal, AVG(delivery_distance_meters) AS AverageDistance FROM drivers d INNER JOIN deliveries dv ON d.driver_id = dv.driver_id
GROUP BY driver_modal;

/*7- Qual a média de valor de pedido (order_amount) por loja, em ordem decrescente?*/
SELECT store_id, AVG(order_amount) AS AverageOrderAmount FROM orders GROUP BY store_id
ORDER BY AverageOrderAmount DESC;

/*8- Existem pedidos que não estão associados a lojas? Se caso positivo, quantos?*/
SELECT COUNT(*) AS NumOrdersWithoutStore FROM orders o LEFT JOIN stores s ON o.store_id = s.store_id
WHERE s.store_id IS NULL;

/*9 - Qual o valor total de pedido (order_amount) no channel 'FOOD PLACE'?*/
SELECT SUM(order_amount) AS total_order_amount FROM orders INNER JOIN channels ON 
orders.channel_id = channels.channel_id WHERE channel_name = 'FOOD PLACE';

/*10 - Quantos pagamentos foram cancelados (chargeback)?*/
SELECT COUNT(*) AS cancelled_payments FROM payments WHERE payment_status = 'chargeback';

/*11 - Qual foi o valor médio dos pagamentos cancelados (chargeback)?*/
SELECT AVG(payment_amount) AS average_cancelled_payment FROM payments WHERE payment_status = 'chargeback';

/*12 - Qual a média do valor de pagamento por método de pagamento(payment_method) em ordem decrescente?*/
SELECT payment_method, AVG(payment_amount) AS average_payment FROM payments GROUP BY payment_method
ORDER BY average_payment DESC;

/*13 - Quais métodos de pagamento tiveram valor médio superior a 100?*/
SELECT AVG(payment_amount) AS average_payment, payment_method FROM payments GROUP BY payment_method
HAVING average_payment > '100';

/*14- Qual a média de valor de pedido (order_amount) por estado do hub (hub_state), 
segmento da loja (store_segment) e tipo de canal (channel_type)?*/
SELECT hub_state, store_segment, channel_type, AVG(order_amount) AS average_order_amount
FROM orders o INNER JOIN stores s ON o.store_id = s.store_id INNER JOIN hubs h ON s.hub_id = h.hub_id
INNER JOIN channels c ON o.channel_id = c.channel_id GROUP BY hub_state, store_segment, channel_type;

/*15- Qual estado do hub (hub_state), segmento da loja (store_segment) e tipo
de canal (channel_type) teve média de valor de pedido (order_amount) maior que
450?*/
SELECT hub_state, store_segment, channel_type, AVG(order_amount) AS average_order_amount
FROM orders o INNER JOIN stores s ON o.store_id = s.store_id INNER JOIN hubs h ON s.hub_id = h.hub_id
INNER JOIN channels c ON o.channel_id = c.channel_id GROUP BY hub_state, store_segment, channel_type
HAVING average_order_amount > 450;

SELECT * FROM `channels`;
SELECT * FROM `hubs`;
SELECT * FROM `stores`;
SELECT * FROM `drivers`;
SELECT * FROM `deliveries`;
SELECT * FROM `payments`;
SELECT * FROM `orders`;