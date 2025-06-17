/*------------------------------------------------------------------------------------------------------------------
 * Este código SQL tem o objetivo de fornecer uma visão clara sobre os membros da equipe que atendem a 
 * ocorrências, identificando suas respectivas funções e unidades durante as ocorrências.
------------------------------------------------------------------------------------------------------------------*/
-- Seleção das colunas de interesse na tabela de integrantes de guarnição
SELECT 
    IG.numero_ocorrencia, -- Número da ocorrência
    IG.numero_sequencial_viatura, -- Número sequencial da viatura
    IG.nome_cargo, -- Cargo do integrante
    IG.numero_matricula, -- Matrícula do integrante
    IG.nome, -- Nome do integrante
    IG.unidade_servico_codigo, -- Código da unidade de serviço
    IG.unidade_servico_nome, -- Nome da unidade de serviço
    IG.unidade_responsavel_registro_nome, -- Nome da unidade responsável pelo registro
    IG.data_hora_fato -- Data e hora do fato
FROM 
    db_bisp_reds_reporting.tb_integrante_guarnicao_ocorrencia  AS IG-- Tabela de integrantes de guarnição
 LEFT JOIN 
    db_bisp_reds_reporting.tb_ocorrencia AS OCO ON OCO.numero_ocorrencia = IG.numero_ocorrencia -- Junção com a tabela de ocorrências
WHERE 1 = 1 
AND OCO.digitador_id_orgao = 0 -- Filtra pelo ID do órgão digitador - PM 
AND OCO.ocorrencia_uf ='MG'                  -- Filtra apenas ocorrências de Minas Gerais
AND OCO.data_hora_fato BETWEEN '2025-01-01 00:00:00.000' AND '2025-02-01 00:00:00.000'  -- Filtra ocorrências entre o periodo especificado
 -- AND IG.unidade_servico_nome LIKE '%x BPM/x RPM%' -- Filtra pelo nome da unidade área militar
	-- AND IG.unidade_responsavel_registro_nome LIKE '%xx RPM%' -- Filtra pelo nome da unidade responsável pelo registro
	-- AND OCO.codigo_municipio IN (123456,456789,987654,......) -- PARA RESGATAR APENAS OS DADOS DOS MUNICÍPIOS SOB SUA RESPONSABILIDADE, REMOVA O COMENTÁRIO E ADICIONE O CÓDIGO DE MUNICIPIO DA SUA RESPONSABILIDADE. NO INÍCIO DO SCRIPT, É POSSÍVEL VERIFICAR ESSES CÓDIGOS, POR RPM E UEOP.CÓDIGOS, POR RPM E UEOP.
