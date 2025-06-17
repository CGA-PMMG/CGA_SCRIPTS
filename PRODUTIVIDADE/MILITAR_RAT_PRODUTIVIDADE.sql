/*------------------------------------------------------------------------------------------------------------------
 * Este script SQL tem como finalidade fornecer uma visão detalhada dos membros das equipes que atuaram em 
 * ocorrências relacionadas ao RAT Produtividade, destacando suas respectivas funções, unidades de lotação, 
 * a descrição do indicador do Rat e sua quantidade. A consulta integra informações das tabelas de 
 * integrante da guarnição e RAT produtividade, permitindo uma análise focada no desempenho de equipes. 
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
WHERE 1 = 1 
AND OCO.digitador_id_orgao = 0 -- Filtra pelo ID do órgão digitador - PM 
AND OCO.ocorrencia_uf ='MG'                  -- Filtra apenas ocorrências de Minas Gerais
AND OCO.nome_tipo_relatorio = 'RAT'
AND OCO.data_hora_fato BETWEEN '2025-01-01 00:00:00.000' AND '2025-02-01 00:00:00.000'  -- Filtra ocorrências entre o periodo especificado
 -- AND OCO.unidade_area_militar_nome LIKE '%x BPM/x RPM%' -- Filtra pelo nome da unidade área militar
	-- AND OCO.unidade_responsavel_registro_nome LIKE '%xx RPM%' -- Filtra pelo nome da unidade responsável pelo registro
	-- AND OCO.codigo_municipio IN (123456,456789,987654,......) -- PARA RESGATAR APENAS OS DADOS DOS MUNICÍPIOS SOB SUA RESPONSABILIDADE, REMOVA O COMENTÁRIO E ADICIONE O CÓDIGO DE MUNICIPIO DA SUA RESPONSABILIDADE. NO INÍCIO DO SCRIPT, É POSSÍVEL VERIFICAR ESSES CÓDIGOS, POR RPM E UEOP.
