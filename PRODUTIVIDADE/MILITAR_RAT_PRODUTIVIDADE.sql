/*------------------------------------------------------------------------------------------------------------------
 * Este script SQL tem como finalidade fornecer uma visão detalhada dos membros das equipes que atuaram em 
 * ocorrências relacionadas ao RAT Produtividade, destacando suas respectivas funções, unidades de lotação, 
 * a descrição do indicador do Rat e sua quantidade. A consulta integra informações das tabelas de 
 * integrante da guarnição, ocorrências e RAT produtividade, permitindo uma análise focada no desempenho de equipes. 
--------------------------------------------------------------------------------------------------------------------*/
SELECT 
    IG.numero_matricula, -- Matrícula do integrante
    IG.nome_cargo, -- Cargo do integrante
    IG.nome, -- Nome do integrante
    IG.unidade_servico_nome, -- Nome da unidade de serviço
    OCO.unidade_responsavel_registro_nome, -- Nome da unidade responsável pelo registro
    IG.data_hora_fato, -- Data/hora do fato
    IG.numero_ocorrencia, -- Número da ocorrência
    RAT.indicador_descricao, -- Descrição o indicador da produtividade
    RAT.quantidade  -- Quantidade produtividade
FROM 
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia as IG-- Tabela de integrantes de guarnição
 INNER JOIN  
    db_bisp_reds_reporting.tb_ocorrencia as OCO-- Junção com a tabela de ocorrências para retornar dados da ocorrência 
    ON OCO.numero_ocorrencia = IG.numero_ocorrencia 
 INNER JOIN  
    db_bisp_reds_reporting.tb_rat_produtividade_ocorrencia as RAT-- Junção com a tabela Rat Produtividade para retornar dados da produtividade do rat
    ON RAT.numero_ocorrencia = IG.numero_ocorrencia 
WHERE 
    YEAR(OCO.data_hora_fato) = 2025 -- Filtra ano da data/hora fato
    AND MONTH (OCO.data_hora_fato) = 6 -- Filtra o mês da data/hora fato
    AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de MG
    AND OCO.digitador_id_orgao = 0 -- Garante que retorne ocorrências atendidas apenas por policiais militares
	--  AND OCO.unidade_responsavel_registro_nome LIKE '%xx BPM/xx RPM%' -- Filtra pelo nome da unidade responsável pelo registro
	--  AND OCO.codigo_municipio IN (123456,456789,987654,......) -- PARA RESGATAR APENAS OS DADOS DOS MUNICÍPIOS SOB SUA RESPONSABILIDADE, REMOVA O COMENTÁRIO E ADICIONE O CÓDIGO DE MUNICIPIO DA SUA RESPONSABILIDADE. NO INÍCIO DO SCRIPT, É POSSÍVEL VERIFICAR ESSES CÓDIGOS, POR RPM E UEOP.
    --  AND IG.numero_matricula = 'xxxx' -- Filtre pela matrícula do militar 
ORDER BY IG.numero_matricula, IG.data_hora_fato, IG.numero_ocorrencia -- Ordena por número da matricula do militar, data/hora do fato e pelo número da ocorrência
