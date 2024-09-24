/*------------------------------------------------------------------------------------------------------------------
 * Este script SQL tem como finalidade fornecer uma visão detalhada dos membros das equipes que atuaram em 
 * ocorrências relacionadas ao RAT Produtividade, destacando suas respectivas funções, unidades de lotação, 
 * a descrição do indicador do Rat e sua quantidade. A consulta integra informações das tabelas de 
 * integrante da guarnição, ocorrências e RAT produtividade, permitindo uma análise focada no desempenho de equipes. 
--------------------------------------------------------------------------------------------------------------------*/
SELECT 
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.numero_matricula, -- Matrícula do integrante
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.nome_cargo, -- Cargo do integrante
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.nome, -- Nome do integrante
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.unidade_servico_nome, -- Nome da unidade de serviço
    db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome, -- Nome da unidade responsável pelo registro
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.data_hora_fato, -- Data/hora do fato
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.numero_ocorrencia, -- Número da ocorrência
    db_bisp_reds_reporting.tb_rat_produtividade_ocorrencia.indicador_descricao, -- Descrição o indicador da produtividade
    db_bisp_reds_reporting.tb_rat_produtividade_ocorrencia.quantidade  -- Quantidade produtividade
FROM 
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia -- Tabela de integrantes de guarnição
INNER JOIN  
    db_bisp_reds_reporting.tb_ocorrencia -- Junção com a tabela de ocorrências para retornar dados da ocorrência 
    ON db_bisp_reds_reporting.tb_ocorrencia.numero_ocorrencia = db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.numero_ocorrencia 
INNER JOIN  
    db_bisp_reds_reporting.tb_rat_produtividade_ocorrencia -- Junção com a tabela Rat Produtividade para retornar dados da produtividade do rat
    ON db_bisp_reds_reporting.tb_rat_produtividade_ocorrencia.numero_ocorrencia = db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.numero_ocorrencia 
WHERE 
    YEAR(db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) = 2018 -- Filtra ano da data/hora fato
    AND MONTH (db_bisp_reds_reporting.tb_ocorrencia.data_hora_fato) = 1 -- Filtra o mês da data/hora fato
    AND db_bisp_reds_reporting.tb_ocorrencia.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de MG
    AND db_bisp_reds_reporting.tb_ocorrencia.unidade_responsavel_registro_nome LIKE '%X BPM%'  -- Filtra ocorrências da unidade responsável pelo registro
    AND UPPER(db_bisp_reds_reporting.tb_ocorrencia.nome_municipio)  LIKE UPPER('%XXXX%')-- Filtra município da ocorrência, em letras maiúsculas
    AND db_bisp_reds_reporting.tb_ocorrencia.digitador_id_orgao = 0 -- Garante que retorne ocorrências atendidas apenas por policiais militares
   -- AND db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia.numero_matricula = 'xxxx' -- Filtre pela matrícula do militar 
ORDER BY numero_matricula, data_hora_fato, numero_ocorrencia -- Ordena por número da matricula do militar, data/hora do fato e pelo número da ocorrência
