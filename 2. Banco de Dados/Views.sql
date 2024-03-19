CREATE VIEW tabela_normalizada_view AS 
SELECT 
	v."Order ID" AS "Order_ID",
	TO_CHAR(TO_DATE(v."Date", 'MM/DD/YYYY'), 'MM/YYYY') AS "Periodo",
	v."ship-service-level" AS "Modalidade",
	v."Codigo",
	p."Produto",
	v."Qty" AS "Quantidade",
	CAST(REPLACE(p."Preco", '$', '') AS NUMERIC) AS "Preco",
	v."Courier Status" AS "Despachado", 
	v."ship-country" AS "Pais",
	v."Fulfillment" AS "Incoterms"
FROM vendas v
	LEFT JOIN produtos p ON v."Codigo" = p."Codigo"

----------------------------

CREATE VIEW valor_total_expedido_view AS 
SELECT tbv."Periodo",
	   sum(tbv."Quantidade" * tbv."Preco") AS "Total_Expedido"	
FROM tabela_normalizada_view tbv
WHERE tbv."Despachado" = 'Shipped'
GROUP BY tbv."Periodo";

----------------------------
CREATE VIEW valor_total_vendas_view AS 
SELECT tbv."Periodo",
	   sum(tbv."Quantidade" * tbv."Preco") AS "Total_Vendas"	
FROM tabela_normalizada_view tbv
GROUP BY tbv."Periodo";

---------------------------------------------
CREATE VIEW valor_expedicao_geral AS
SELECT 
    SUM("Quantidade" * "Preco") AS "Total_Geral"
FROM 
    tabela_normalizada_view
WHERE 
    "Despachado" = 'Shipped';
    
---------------------------------------------
CREATE VIEW modalidade_por_pais_view AS
SELECT 
    tbv."Pais",
    tbv."Modalidade",
    SUM(tbv."Quantidade" * tbv."Preco") AS "Valor_Total_Por_Modalidade"
FROM 
    tabela_normalizada_view tbv
WHERE 
    tbv."Despachado" = 'Shipped'
GROUP BY 
    tbv."Pais", tbv."Modalidade";

--------------------------------------------