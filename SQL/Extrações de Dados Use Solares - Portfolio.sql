/*
====================================================================
PROJETO: USE SOLARES
ARQUIVO: Extrações de Dados - Portfolio
TECNOLOGIAS: SQL Server / SSMS

Objetivo:
Consultas utilizadas para extrair indicadores e análises comerciais
do banco UseSolaresDB para posterior utilização no Power BI.

====================================================================
*/

USE UseSolaresDB;
GO

/* ================================================================
   1. VENDAS POR MÊS
   ================================================================ */

SELECT MONTH(o.order_date) AS [Meses],
COUNT(DISTINCT o.order_id) AS [Total Pedidos],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total]
FROM Orders AS o
INNER JOIN Order_Items AS oi
ON o.order_id = oi.order_id
GROUP BY MONTH(o.order_date)
ORDER BY MONTH(o.order_date) ASC;
GO

/* ================================================================
   2. FATURAMENTO POR CATEGORIA
   ================================================================ */

SELECT c.category_name AS [Categoria],
SUM(oi.quantity) AS [Quant. Vendida],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total]
FROM Products AS p
INNER JOIN Categories AS c
ON p.category_id = c.category_id
INNER JOIN Order_Items AS oi
ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY [Faturamento Total] DESC;
GO

/* ================================================================
   3. FATURAMENTO POR PRODUTO
   ================================================================ */

SELECT p.product_name AS [Produto],
c.category_name AS [Categoria],
SUM(oi.quantity) AS [Quant. Vendida],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total]
FROM Products AS p
INNER JOIN Categories AS c
ON p.category_id = c.category_id
INNER JOIN Order_Items AS oi
ON p.product_id = oi.product_id
GROUP BY p.product_name,
c.category_name
ORDER BY [Faturamento Total] DESC;
GO

/* ================================================================
   4. FATURAMENTO POR LOJA
   ================================================================ */

SELECT s.store_name AS [Loja],
SUM(oi.quantity) AS [Quant. Vendida],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total]
FROM Orders AS o
INNER JOIN Order_Items AS oi
ON o.order_id = oi.order_id
INNER JOIN Stores AS s
ON o.store_id = s.store_id
GROUP BY s.store_name
ORDER BY [Faturamento Total] DESC;
GO

/* ================================================================
   5. FATURAMENTO POR FUNCIONÁRIO
   ================================================================ */

SELECT e.employee_name AS [Funcionário],
SUM(oi.quantity) AS [Quant. Vendida],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.employee_id = e.employee_id
INNER JOIN Order_Items AS oi
ON o.order_id = oi.order_id
GROUP BY e.employee_name
ORDER BY [Faturamento Total] DESC;
GO

/* ================================================================
   6. FATURAMENTO POR ESTADO
   ================================================================ */

SELECT c.state AS [Estado],
SUM(oi.quantity) AS [Quant. Vendida],
SUM(oi.quantity * oi.unit_price) AS [Faturamento]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.customer_id = c.customer_id
INNER JOIN Order_Items AS oi
ON o.order_id = oi.order_id
GROUP BY c.state
ORDER BY [Faturamento] DESC;
GO

/* ================================================================
   7. DESEMPENHO DOS CLIENTES
   ================================================================ */

SELECT c.name AS [Cliente],
COUNT(DISTINCT o.order_id) AS [Total de Pedidos],
SUM(oi.quantity) AS [Quant. Vendida],
SUM(oi.quantity * oi.unit_price) AS [Faturamento]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.customer_id = c.customer_id
INNER JOIN Order_Items AS oi
ON o.order_id = oi.order_id
GROUP BY c.name
ORDER BY [Faturamento] DESC;
GO

/* ================================================================
   8. TICKET MÉDIO POR LOJA
   ================================================================ */

SELECT s.store_name AS [Loja],
COUNT(DISTINCT o.order_id) AS [Total de Pedidos],
SUM(oi.quantity * oi.unit_price) AS [Faturamento],
CAST( SUM(oi.quantity * oi.unit_price) /
COUNT(DISTINCT o.order_id) AS DECIMAL(10,2)) AS [Ticket Médio]
FROM Orders AS o
INNER JOIN Stores AS s
ON o.store_id = s.store_id
INNER JOIN Order_Items AS oi
ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY [Ticket Médio] DESC;
GO

/* ================================================================
   9. DESEMPENHO DE VENDAS POR CATEGORIA
   ================================================================ */

SELECT c.category_name AS [Categoria],
COUNT(DISTINCT o.order_id) AS [Total Pedidos],
SUM(oi.quantity) AS [Quant. Vendida],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total]
FROM Categories AS c
INNER JOIN Products AS p
ON c.category_id = p.category_id
INNER JOIN Order_Items AS oi
ON p.product_id = oi.product_id
INNER JOIN Orders AS o
ON oi.order_id = o.order_id
GROUP BY c.category_name
ORDER BY [Faturamento Total] DESC;
GO

/* ================================================================
   10. FATURAMENTO POR FORMA DE PAGAMENTO
   ================================================================ */

SELECT pa.payment_method AS [Forma de Pagamento],
COUNT(DISTINCT pa.order_id) AS [Total de Pedidos],
SUM(oi.quantity) AS [Quant. Vendida],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total]
FROM Payments AS pa
INNER JOIN Order_Items AS oi
ON pa.order_id = oi.order_id
GROUP BY pa.payment_method
ORDER BY [Faturamento Total] DESC;
GO

/* ================================================================
   11. FATURAMENTO POR CIDADE
   ================================================================ */

SELECT c.city AS [Cidade],
c.state AS [Estado],
COUNT(DISTINCT o.order_id) AS [Total de Pedidos],
SUM(oi.quantity) AS [Quant. Vendida],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.customer_id = c.customer_id
INNER JOIN Order_Items AS oi
ON o.order_id = oi.order_id
GROUP BY c.city,
c.state
ORDER BY [Faturamento Total] DESC;
GO

/* ================================================================
   12. CANCELAMENTO POR LOJA
   ================================================================ */

SELECT s.store_name AS [Loja],
COUNT(DISTINCT o.order_id) AS [Total Pedidos],
SUM(CASE WHEN o.order_status = 'Cancelled' THEN 1 ELSE 0
END) AS [Ped. Cancelados],
CAST(SUM(CASE WHEN o.order_status = 'Cancelled' THEN 1
ELSE 0 END) * 100.0 / COUNT(DISTINCT o.order_id)
AS DECIMAL(10,2)) AS [% Cancelamento]
FROM Stores AS s
INNER JOIN Orders AS o
ON s.store_id = o.store_id
GROUP BY s.store_name;
GO

/* ================================================================
   13. TICKET MÉDIO POR ESTADO
   ================================================================ */

SELECT c.state AS [Estado],
COUNT(DISTINCT oi.order_id) AS [Total Pedidos],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total],
CAST(SUM(oi.quantity * oi.unit_price) /
COUNT(DISTINCT oi.order_id) AS DECIMAL(10,2)) AS [Ticket Médio]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.customer_id = c.customer_id
INNER JOIN Order_Items AS oi
ON o.order_id = oi.order_id
GROUP BY c.state
ORDER BY [Ticket Médio] DESC;
GO

/* ================================================================
   14. TICKET MÉDIO POR FUNCIONÁRIO
   ================================================================ */

SELECT e.employee_name AS [Funcionário],
COUNT(DISTINCT o.order_id) AS [Total Pedidos],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total],
CAST(SUM(oi.quantity * oi.unit_price) / 
COUNT(DISTINCT o.order_id) AS DECIMAL(10,2)) AS [Ticket Médio]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.employee_id = e.employee_id
INNER JOIN Order_Items AS oi
ON o.order_id = oi.order_id
GROUP BY e.employee_name
ORDER BY [Ticket Médio] DESC;
GO

/* ================================================================
   15. DESEMPENHO MENSAL COMPLETO
   ================================================================ */

SELECT MONTH(o.order_date) AS [Mês],
COUNT(DISTINCT o.order_id) AS [Total Pedidos],
SUM(oi.quantity) AS [Quant. Vendida],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total],
CAST(SUM(oi.quantity * oi.unit_price) /
COUNT(DISTINCT o.order_id) AS DECIMAL(10,2)) AS [Ticket Médio]
FROM Orders AS o
INNER JOIN Order_Items AS oi
ON o.order_id = oi.order_id
GROUP BY MONTH(o.order_date)
ORDER BY MONTH(o.order_date) ASC;
GO

/* ================================================================
   16. DESEMPENHO MENSAL POR STATUS
   ================================================================ */

SELECT MONTH(o.order_date) AS [Mês],
o.order_status AS [Status do Pedido],
COUNT(DISTINCT o.order_id) AS [Total Pedidos]
FROM Orders AS o
GROUP BY MONTH(o.order_date),
o.order_status
ORDER BY MONTH(o.order_date) ASC;
GO

/* ================================================================
   17. QUANTIDADE DE CLIENTES POR ESTADO
   ================================================================ */

SELECT c.state AS [Estado],
COUNT(DISTINCT c.customer_id) AS [Quant. Clientes]
FROM Customers AS c
GROUP BY c.state
ORDER BY [Quant. Clientes] DESC;
GO

/* ================================================================
   18. INDICADORES GERAIS DE VENDAS
   ================================================================ */

SELECT COUNT(DISTINCT o.order_id) AS [Total Pedidos],
SUM(oi.quantity) AS [Quant. Vendida],
SUM(oi.quantity * oi.unit_price) AS [Faturamento Total],
CAST(SUM(oi.quantity * oi.unit_price) /
COUNT(DISTINCT o.order_id) AS DECIMAL(10,2)) AS [Ticket Médio]
FROM Orders AS o
INNER JOIN Order_Items AS oi
ON o.order_id = oi.order_id;
GO
