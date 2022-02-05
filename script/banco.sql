-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           8.0.21 - MySQL Community Server - GPL
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Copiando estrutura do banco de dados para vendaswk
DROP DATABASE IF EXISTS `vendaswk`;
CREATE DATABASE IF NOT EXISTS `vendaswk` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `vendaswk`;

-- Copiando estrutura para tabela vendaswk.clientes
DROP TABLE IF EXISTS `clientes`;
CREATE TABLE IF NOT EXISTS `clientes` (
  `codcliente` int NOT NULL,
  `nome` varchar(60) NOT NULL,
  `cidade` varchar(60) NOT NULL,
  `uf` char(2) NOT NULL,
  PRIMARY KEY (`codcliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copiando dados para a tabela vendaswk.clientes: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
REPLACE INTO `clientes` (`codcliente`, `nome`, `cidade`, `uf`) VALUES
	(1, 'Márcio', 'Balneário Camboriú', 'SC'),
	(2, 'José Ubaldo', 'Balneário Camboriú', 'SC'),
	(3, 'Nelci', 'Balneário Camboriú', 'SC'),
	(4, 'Daiane', 'Balneário Camboriú', 'SC'),
	(5, 'Nicolye', 'Balneário Camboriú', 'SC'),
	(6, 'Sophia', 'Balneário Camboriú', 'SC'),
	(7, 'Vitória', 'Itajaí', 'SC'),
	(8, 'Meire', 'Itajaí', 'SC'),
	(9, 'Jhonatan', 'Itajaí', 'SC'),
	(10, 'Diana', 'Caldas Novas', 'GO'),
	(11, 'Rafael', 'Caldas Novas', 'GO'),
	(12, 'Celso', 'Brasília', 'DF'),
	(13, 'Sandra', 'Brasília', 'DF'),
	(14, 'Inês', 'Brasília', 'DF'),
	(15, 'Izabela', 'Itajaí', 'SC'),
	(16, 'Israel', 'Caldas Novas', 'GO'),
	(17, 'Fernanda', 'Caldas Novas', 'GO'),
	(18, 'Edmar', 'Goiânia', 'GO'),
	(19, 'Carlos', 'Goiânia', 'GO'),
	(20, 'Daniel', 'Goiânia', 'GO');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;

-- Copiando estrutura para tabela vendaswk.pedidos
DROP TABLE IF EXISTS `pedidos`;
CREATE TABLE IF NOT EXISTS `pedidos` (
  `nropedido` int NOT NULL,
  `dtemissao` datetime NOT NULL,
  `codcliente` int NOT NULL,
  `vlrtotal` decimal(9,2) NOT NULL,
  PRIMARY KEY (`nropedido`),
  KEY `fk_ped_clientes_idx` (`codcliente`),
  CONSTRAINT `fk_ped_clientes` FOREIGN KEY (`codcliente`) REFERENCES `clientes` (`codcliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copiando dados para a tabela vendaswk.pedidos: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;

-- Copiando estrutura para tabela vendaswk.pedidos_itens
DROP TABLE IF EXISTS `pedidos_itens`;
CREATE TABLE IF NOT EXISTS `pedidos_itens` (
  `id_pedido` int NOT NULL AUTO_INCREMENT,
  `nropedido` int NOT NULL,
  `codproduto` int NOT NULL,
  `qde` decimal(9,3) NOT NULL,
  `vlrunitario` decimal(9,2) NOT NULL,
  `vlrtotal` decimal(9,2) NOT NULL,
  PRIMARY KEY (`id_pedido`),
  KEY `fk_pedidos_itens_pedido_idx` (`nropedido`),
  KEY `fk_pedidos_itens_produto_idx` (`codproduto`),
  CONSTRAINT `fk_pedidos_itens_pedido` FOREIGN KEY (`nropedido`) REFERENCES `pedidos` (`nropedido`),
  CONSTRAINT `fk_pedidos_itens_produto` FOREIGN KEY (`codproduto`) REFERENCES `produtos` (`codproduto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copiando dados para a tabela vendaswk.pedidos_itens: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `pedidos_itens` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos_itens` ENABLE KEYS */;

-- Copiando estrutura para tabela vendaswk.produtos
DROP TABLE IF EXISTS `produtos`;
CREATE TABLE IF NOT EXISTS `produtos` (
  `codproduto` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) NOT NULL,
  `prvenda` decimal(9,2) NOT NULL,
  PRIMARY KEY (`codproduto`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copiando dados para a tabela vendaswk.produtos: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
REPLACE INTO `produtos` (`codproduto`, `descricao`, `prvenda`) VALUES
	(1, 'Pen drive 8GB', 39.99),
	(2, 'Mouse Optico Microsoft', 45.00),
	(3, 'Monitor Dell 21 Pol', 930.00),
	(4, 'Regua 5 Tomadas Clone', 39.00),
	(5, 'Caixa Som USB 9V', 39.00),
	(6, 'Notebook Dell Inspiron', 2900.00),
	(7, 'Impressora Epson L4150', 950.00),
	(8, 'Notebook Dell Vostro', 2900.00),
	(9, 'Teclado USB Dell', 99.00),
	(10, 'Teclado USB Microsoft', 149.00),
	(11, 'Gabinete PCGamer Azul Viper', 499.00),
	(12, 'Fonte Atx 450W', 289.00),
	(13, 'Monitor Samsung 19 Pol', 790.00),
	(14, 'Pen Drive 16GB', 99.00),
	(15, 'HD SSD 128GB', 699.00),
	(16, 'Memória RAM DDR4 16GB', 399.00),
	(17, 'Drive CD ROM', 50.00),
	(18, 'Estabilizador SMS 600vA', 490.00),
	(19, 'Roteador TP-Link 8 Portas 1Gbt', 299.00),
	(20, 'Camera USB Logitec', 89.00);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
