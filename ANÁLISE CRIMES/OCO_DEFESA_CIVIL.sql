/*--------------------------------------------------------------------------------------------------------------------
 * O objetivo do código é realizar uma consulta em uma tabela de ocorrências, extraindo informações sobre ocorrências,
 * com naturezas típicas de Defesa Social, começando com 'R', dentro de um intervalo de datas especificado, 
 * e limitadas a municípios específicos, identificados por seus códigos.
 *
 * Contribuição: Gabriel A S e Brito, Sd PM
 ---------------------------------------------------------------------------------------------------------------------*/
SELECT
oco.numero_ocorrencia,  -- Seleciona o número de ocorrência .
year(oco.data_hora_fato) as Ano,  -- Extrai o ano da data/hora do fato e o renomeia como "Ano".
MONTH(oco.data_hora_fato) as Mes,  -- Extrai o mês da data/hora do fato e o renomeia como "Mes".
DAY(oco.data_hora_fato) as Dia,  -- Extrai o dia da data/hora do fato e o renomeia como "Dia".
CONCAT(
        LPAD(CAST(EXTRACT(HOUR FROM oco.data_hora_fato) AS STRING), 2, '0'), ':',
        LPAD(CAST(EXTRACT(MINUTE FROM oco.data_hora_fato) AS STRING), 2, '0'), ':',
        LPAD(CAST(EXTRACT(SECOND FROM oco.data_hora_fato) AS STRING), 2, '0')
    ) AS hora_fato,  -- Extrai a hora, minuto e segundo dda data/hora do fato e formata como string "HH:MM:SS", renomeando o campo como "hora_fato".
oco.natureza_codigo,  -- Seleciona o código da natureza da ocorrência.
oco.natureza_descricao,  -- Seleciona a descrição da natureza da ocorrência.
oco.unidade_area_militar_nome,  -- Seleciona o nome da área militar responsável.
oco.unidade_responsavel_registro_nome,  -- Seleciona o nome da unidade responsável pelo registro da ocorrência.
oco.nome_municipio  -- Seleciona o nome do município do fato.
from db_bisp_reds_reporting.tb_ocorrencia oco  -- Especifica a tabela "tb_ocorrencia" do banco de dados "db_bisp_reds_reporting" com o alias "oco".
where 1=1  -- Condição sempre verdadeira, usada como base para outras condições subsequentes.
and SUBSTRING(natureza_codigo,1,1) = 'R'  -- Filtra as ocorrências típicas de Defesa Civil, naturezas que iniciam com R.
and oco.data_hora_fato BETWEEN '2018-01-01 00:00:00' and '2024-12-31 23:59:59'  -- Filtra as ocorrências que tenham ocorrido entre 1º de janeiro de 2023 e 31 de dezembro de 2024.
--and oco.codigo_municipio in (0,0,0,0,0,...)  -- Caso deseje, retire o comentario e filtre as ocorrências que pertencem a um dos municípios listados pelos respectivos códigos.
--and unidade_responsavel_registro_nome like '%10BBM%' -- Caso deseje, retire o comentario e filtre as ocorrências pela unidade responsável pelo registro