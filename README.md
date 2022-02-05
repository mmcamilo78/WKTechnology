### Teste Técnico Dev Delphi = WK Technology
---

#### Informação do Participante 
```
Candidato > Márcio Moreira Camilo
   E-mail > mmcamilo@gmail.com
 Telefone > (47)98867-7130
     Data > 05/02/2022
```
#### Recursos
    Ferramenta de Desenvolvimento------> RadStudio Delphi Versão 10.3 
    Sistema Gerenciador Banco de Dados-> MySQL 8.0
    Nome do Banco de Dados-------------> VENDASWK 
    
### Estrutura de Pastas
```
\release      <- Pasta que contém versão compilada do aplicativo
\script       <- Pasta que contém o script para criação do banco de dados 
\Source       <- Pasta com os Códigos Fonte do programa
```

### Configurações
- Instalar o SGBD caso ainda não exista no computador destino, instalação padrão sem seleções específicas.
- Em seguida copiar, colar e rodar o script através da ferramente de apoio ao SGBD da sua escolha. 
- O arquivo `conexao.ini` será criado na pasta `\release` onde será feito o redirecionamento do ip/server. Se necessário, editar o arquivo, informando o local onde o Banco de Dados se encontra. 

### Programa
Com base no escopo proposto, uma tela principal única com os campos solitados para atendimento dos testes.

- Geração de Pedidos com cadastros de Clientes, Produtos, Pedidos e Itens do Pedido.
- Funções de Seleção, Inclusão, Alteração e Exclusão
- Persistência dos dados

 
### Banco de Dados

Para este desafio utilizei o banco de dados Firebird por considerar Portátil, Free e Confiável para o escopo proposto.

~~~SQL
/*VENDASWK*/
-- Copiando estrutura do banco de dados para vendaswk
DROP DATABASE IF EXISTS `vendaswk`;
CREATE DATABASE IF NOT EXISTS `vendaswk` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `vendaswk`;


### Tabelas
> CLIENTES | PRODUTOS | PEDIDOS | PEDIDOS_ITENS

### Script

~~~SQL
/*CLIENTES*/
-- Copiando estrutura para tabela vendaswk.clientes
DROP TABLE IF EXISTS `clientes`;
CREATE TABLE IF NOT EXISTS `clientes` (
  `codcliente` int NOT NULL,
  `nome` varchar(60) NOT NULL,
  `cidade` varchar(60) NOT NULL,
  `uf` char(2) NOT NULL,
  PRIMARY KEY (`codcliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;~~~

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


~~~

~~~SQL
/*PRODUTOS*/
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
~~~

~~~SQL
/*PEDIDOS*/ 
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
~~~

~~~SQL
/*PEDIDOS_ITENS*/
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
~~~
