-- Entretanto, alguns que podem gerar alguma confusão seriam: 
-- fullfilment -> indica que o produto é de inteira responsabilidade do ecommerce em termos de coleta, 
--	transporte e envio (quando igual a true), caso contrário, é de responsabilidade do vendedor.
-- ship-service-level que é expedido ou padrão; 
-- E courier-status que seria o status do envio (enviado ou não)



-- 01. Qual foi o valor total em vendas mensalmente?
SELECT tbv."Periodo",
	   sum(tbv."Quantidade" * tbv."Preco") AS "Total_Vendas"	
FROM tabela_normalizada_view tbv
GROUP BY tbv."Periodo";

-- 02. Qual foi o valor total em vendas foi exepedido mensalmente?
SELECT tbv."Periodo",
	   sum(tbv."Quantidade" * tbv."Preco") AS "Total_Expedido"	
FROM tabela_normalizada_view tbv
WHERE tbv."Despachado" = 'Shipped'
GROUP BY tbv."Periodo"

-- 03. Qual o percentual de vendas não foi expedido?
SELECT vte."Periodo",
		vtv."Total_Vendas",
		vte."Total_Expedido",
		round((vtv."Total_Vendas" - vte."Total_Expedido") / vte."Total_Expedido" * 100, 2) AS "Percentual"
FROM valor_total_expedido_view vte
	Right Join valor_total_vendas_view vtv ON vte."Periodo" = vtv."Periodo"

-- 04. Qual o percentual de vendas com divergência na informação de despacho de expedição?
SELECT tbv."Periodo",
       vtv."Total_Vendas",
       SUM(tbv."Quantidade" * tbv."Preco") AS "Total_Sem_Rastreio",
       ROUND((SUM(tbv."Quantidade" * tbv."Preco") / vtv."Total_Vendas") * 100, 2) AS "Percentual"
FROM tabela_normalizada_view tbv
LEFT JOIN valor_total_vendas_view vtv ON tbv."Periodo" = vtv."Periodo"
WHERE tbv."Despachado" IS NULL 
GROUP BY tbv."Periodo", vtv."Total_Vendas"
ORDER BY tbv."Periodo";

-- 05. Dentre as expedições canceladas, quais foram os 3 produto que tiveram os maiores valores em expedições canceladas?
SELECT 
	tbv."Codigo",
	tbv."Produto",
	Sum(tbv."Quantidade") AS "Cancelamentos",
	SUM(tbv."Quantidade" * tbv."Preco") AS "Valor_Total"
FROM tabela_normalizada_view tbv
WHERE tbv."Despachado" IS NULL
GROUP BY tbv."Codigo", tbv."Produto"
ORDER BY SUM(tbv."Quantidade" * tbv."Preco") DESC
LIMIT 3

-- 06. Quais os países que apresentaram os maiore valores em produtos com expedição cancelada?
SELECT 
	tbv."Pais",
	Sum(tbv."Quantidade") AS "Cancelamentos",
	SUM(tbv."Quantidade" * tbv."Preco") AS "Valor_Total"
FROM 
	tabela_normalizada_view tbv
WHERE 
	tbv."Despachado" IS NULL
GROUP BY 
	tbv."Pais"
ORDER BY 
	SUM(tbv."Quantidade" * tbv."Preco") DESC
	
-- 07. Dentre os itens com expedição realizada, qual foi o percentual para cada Incoterm?
SELECT 
    mpp."Pais",
    mpp."Modalidade",
    mpp."Valor_Total_Por_Modalidade",
    ROUND((mpp."Valor_Total_Por_Modalidade" / veg."Total_Geral") * 100, 2) AS "Percentual_MOdalidade_Pais"
FROM 
    modalidade_por_pais_view mpp
CROSS JOIN 
    valor_expedicao_geral veg;
    
-- 08. Qual o produto mais expedido em cada país em termos de quantidade?
  SELECT
    agr."Pais",
    agr."Codigo",
    agr."Produto",
    agr."Total_Vendido"
FROM
    (
        SELECT
            tbv."Pais",
            tbv."Codigo",
            tbv."Produto",
            SUM(tbv."Quantidade") AS "Total_Vendido",
            RANK() OVER (PARTITION BY tbv."Pais" ORDER BY SUM(tbv."Quantidade") DESC) AS "Ranking"
        FROM
            tabela_normalizada_view tbv
        WHERE 
            tbv."Despachado" = 'Shipped'
        GROUP BY
            tbv."Pais", tbv."Codigo", tbv."Produto"
    ) agr
WHERE
    agr."Ranking" = 1;
   
 -- 09. Qual o produto menos expedido em cada país em termos de quantidade?
SELECT
    agr."Pais",
    agr."Codigo",
    agr."Produto",
    agr."Total_Vendido"
FROM
    (
        SELECT
            tbv."Pais",
            tbv."Codigo",
            tbv."Produto",
            SUM(tbv."Quantidade") AS "Total_Vendido",
            RANK() OVER (PARTITION BY tbv."Pais" ORDER BY SUM(tbv."Quantidade") ASC) AS "Ranking"
        FROM
            tabela_normalizada_view tbv
        WHERE 
            tbv."Despachado" = 'Shipped'
        GROUP BY
            tbv."Pais", tbv."Codigo", tbv."Produto"
    ) agr
WHERE
    agr."Ranking" = 1;
   
-- 10. Qual o produto menos expedido em cada pa´si em termos de quantidade?
SELECT
    agr."Pais",
    agr."Codigo",
    agr."Produto",
    agr."Total_Vendido"
FROM
    (
        SELECT
            tbv."Pais",
            tbv."Codigo",
            tbv."Produto",
            SUM(tbv."Quantidade") AS "Total_Vendido",
            RANK() OVER (PARTITION BY tbv."Pais" ORDER BY SUM(tbv."Quantidade") ASC) AS "Ranking"
        FROM
            tabela_normalizada_view tbv
        WHERE 
            tbv."Despachado" = 'Shipped'
        GROUP BY
            tbv."Pais", tbv."Codigo", tbv."Produto"
    ) agr
WHERE
    agr."Ranking" = 1;

--11. Qual o produto mais expedido para cada país em termos de valores?
SELECT
    agr."Pais",
    agr."Codigo",
    agr."Produto",
    agr."Total_Vendido"
FROM
    (
        SELECT
            tbv."Pais",
            tbv."Codigo",
            tbv."Produto",
            SUM(tbv."Quantidade" * tbv."Preco") AS "Total_Vendido",
            RANK() OVER (PARTITION BY tbv."Pais" ORDER BY SUM(tbv."Quantidade" * tbv."Preco") DESC) AS "Ranking"
        FROM
            tabela_normalizada_view tbv
        WHERE 
            tbv."Despachado" = 'Shipped'
        GROUP BY
            tbv."Pais", tbv."Codigo", tbv."Produto"
    ) agr
WHERE
    agr."Ranking" = 1;

-- 12. Qual o produto menos expedido para cada pais em termos de valores?
SELECT
    agr."Pais",
    agr."Codigo",
    agr."Produto",
    agr."Total_Vendido"
FROM
    (
        SELECT
            tbv."Pais",
            tbv."Codigo",
            tbv."Produto",
            SUM(tbv."Quantidade" * tbv."Preco") AS "Total_Vendido",
            RANK() OVER (PARTITION BY tbv."Pais" ORDER BY SUM(tbv."Quantidade" * tbv."Preco") ASC) AS "Ranking"
        FROM
            tabela_normalizada_view tbv
        WHERE 
            tbv."Despachado" = 'Shipped'
        GROUP BY
            tbv."Pais", tbv."Codigo", tbv."Produto"
    ) agr
WHERE
    agr."Ranking" = 1;
   
   
-- 13. Qual foi a Order mais cara e o valor dela para cada um dos países?
   
SELECT DISTINCT ON ("Pais")
    "Pais",
    "Order_ID",
    "Valor_Total"
FROM (
    SELECT
        "Order_ID",
        "Pais",
        SUM("Preco" * "Quantidade") AS "Valor_Total"
    FROM
        tabela_normalizada_view tbv
    GROUP BY
        "Order_ID",
        "Pais"
) AS "Pedido_Pais"
ORDER BY
    "Pais", "Valor_Total" DESC;
   
-- 15. Qual valor medio de Order para cada país?
SELECT 
    "Pais",
    AVG("Valor_Total") AS "Valor_Medio"
FROM (
    SELECT
        "Pais",
        "Order_ID",
        SUM("Preco" * "Quantidade") AS "Valor_Total"
    FROM
        tabela_normalizada_view tbv
    GROUP BY
        "Order_ID",
        "Pais"
) AS "Pedidos_Por_Pais"
GROUP BY
    "Pais";
   