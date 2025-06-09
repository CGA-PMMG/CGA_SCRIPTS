/*----------------------------------------------------------------------------------------------------------------
 * Este código SQL está projetado para extrair informações detalhadas de chamadas de atendimento registradas no 
 * banco de dados CAD. O objetivo é identificar eventos específicos com base em critérios de localização, 
 * unidade de serviço, intervalo de tempo e palavras-chave presentes no histórico das chamadas. 
 ---------------------------------------------------------------------------------------------------------------*/
SELECT 
CHAMADA.id_chamada, -- Seleciona o identificador único da chamada.
CHAMADA.numero_chamada, -- Seleciona o número associado à chamada.
CHAMADA.codigo_tipo_servico, -- Seleciona o código que identifica o tipo de serviço da chamada.
ATEND.chamada_data_hora_solicitacao, -- Seleciona a data e hora de solicitação da chamada.
ATEND.chamada_data_hora_inclusao, -- Seleciona a data e hora da inclusão da chamada.
ATEND.local_municipio_id, -- Seleciona o identificador do município onde ocorreu a chamada.
ATEND.local_municipio_nome, -- Seleciona o nome do município onde ocorreu a chamada.
ATEND.local_bairro_nome, -- Seleciona o nome do bairro onde ocorreu a chamada.
ATEND.local_logradouro_nome, -- Seleciona o nome do logradouro onde ocorreu a chamada.
ATEND.local_latitude, -- Seleciona a latitude associada à localização da chamada.
ATEND.local_longitude, -- Seleciona a longitude associada à localização da chamada.
ATEND.natureza_codigo, -- Seleciona o código de natureza da chamada.
ATEND.natureza_descricao, -- Seleciona a descrição da natureza da chamada.
ATEND.recursos_empenhados_total, -- Seleciona o total de recursos empenhados no atendimento da chamada.
HIST.texto_historico, -- Seleciona o texto histórico associado à chamada.
ATEND.orgao_sigla -- Seleciona a sigla do órgão responsável pela ada.
FROM db_bisp_cad_reporting.tb_chamada CHAMADA -- Especifica a tabela principal "tb_chamada", renomeada como CHAMADA, no banco "db_bisp_cad_reporting".
INNER JOIN db_bisp_cad_reporting.tb_chamada_historico HIST ON CHAMADA.id_chamada = HIST.id_chamada -- Realiza um JOIN com a tabela "tb_chamada_historico", vinculando o histórico pelo identificador da chamada.
INNER JOIN db_bisp_cad_reporting.tb_chamada_atendimento ATEND ON ATEND.chamada_id = CHAMADA.id_chamada -- Realiza um JOIN com a tabela "tb_chamada_atendimento", vinculando os dados do atendimento pelo identificador da chamada.
WHERE 1=1 -- Condição inicial neutra, usada como base para adicionar filtros adicionais.
AND ATEND.orgao_sigla ='PM'-- Filtra órgao responsável pela chamada.
AND HIST.texto_historico LIKE '%xx%' -- Filtra chamadas cujo histórico contenha o termo "xx".
AND CHAMADA.data_hora_inclusao BETWEEN '2025-01-01 00:00:00.000' AND '2025-01-01 00:00:00.000' -- Filtra as chamadas inseridas no sistema dentro do intervalo de tempo especificado.
AND ATEND.local_municipio_id = 000000 -- Filtra os registros pelo codigo de município (substituir '000000' pelo ID desejado).
AND ATEND.unidade_servico_nome LIKE '%X BPM%' -- Filtra as chamadas associadas à unidade de serviço.
ORDER BY 1 -- Ordena os resultados pelo primeiro campo selecionado (CHAMADA.id_chamada).
