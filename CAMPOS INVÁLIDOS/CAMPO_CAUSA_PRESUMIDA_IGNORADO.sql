/*----------------------------------------------------------------------------------------------------------------------------------------------
 * Este script SQL foi desenvolvido para fornecer uma visão detalhada sobre a integridade dos dados relacionados aos motivos presumidos 
 * das ocorrências fechadas registradas pela Polícia Militar de Minas Gerais  no período especificado. O objetivo está em identificar 
 * quantas dessas ocorrências não têm um motivo presumido registrado ou estão categorizadas com códigos '9800'(IGNORADO MOTIVACAO), 
 * '0133'(CAUSA IGNORADA).
 ----------------------------------------------------------------------------------------------------------------------------------------------*/
SELECT
    OCO.digitador_matricula AS MATRICULA_DIGITADOR, -- Extrai a matrícula do digitador responsável pelo registro
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM, -- Extrai o último segmento da unidade responsável pelo registro para identificar a RPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS BPM, -- Extrai o penúltimo segmento da unidade responsável pelo registro para identificar o BPM
    SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -3) AS CIA, -- Extrai o antepenúltimo da unidade responsável pelo registro segmento para identificar a CIA
    COUNT(OCO.numero_ocorrencia) AS Total_Registros, -- Conta o total de ocorrências únicas
    SUM(CASE 
        WHEN OCO.motivo_presumido_codigo IS NULL 
             OR OCO.motivo_presumido_codigo IN ('9800', '0133') -- Verifica a ausência ou códigos específicos de motivo presumido(Nulo,IGNORADO MOTIVACAO OU CAUSA IGNORADA)
        THEN 1 ELSE 0 
        END) AS Qtd_Null_9800_0133 -- Verifica a ausência ou códigos específicos de motivo presumido(Nulo, IGNORADO MOTIVACAO OU CAUSA IGNORADA). Se ausente, atribui valor 1, caso contrario 0, então soma os valores
FROM db_bisp_reds_reporting.tb_ocorrencia OCO
WHERE 1 = 1 
  AND OCO.digitador_sigla_orgao = 'PM' -- Apenas ocorrências digitadas pela Polícia Militar
  AND OCO.ocorrencia_uf = 'MG' -- Filtra ocorrências no estado de Minas Gerais
  AND OCO.descricao_estado = 'FECHADO' -- Filtra ocorrências que estão fechadas
  AND OCO.nome_tipo_relatorio NOT IN ('RAT', 'BOS', 'BOS AMPLO') -- Exclui certos tipos de relatórios
  AND OCO.data_hora_fato BETWEEN '2025-01-01 00:00:00' AND '2025-05-01 00:00:00'  -- Filtra os dados para ocorrências dentro do intervalo especificado
 -- AND OCO.unidade_responsavel_registro_nome LIKE '%/X BPM%' -- filtra ocorrências relacionadas à unidade de registro
GROUP BY OCO.digitador_matricula, RPM, BPM, CIA
-- ordenação dos resultados pela hierarquia da unidade
ORDER BY RPM, BPM, CIA;
