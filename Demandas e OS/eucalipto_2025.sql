SELECT oco.NUMERO_OCORRENCIA,
oco.natureza_codigo,
oco.natureza_descricao,
oco.complemento_natureza_codigo,
oco.complemento_natureza_descricao_longa,
oco.historico_ocorrencia
from db_bisp_reds_reporting.tb_ocorrencia oco
where 1=1
and YEAR(data_hora_fato)>2023 
and oco.natureza_codigo = 'N32301';
SELECT 
    oco.NUMERO_OCORRENCIA,
    oco.natureza_codigo,
    oco.natureza_descricao,
    oco.complemento_natureza_codigo,
    oco.complemento_natureza_descricao_longa,
    mat.informacao_complementar,
    oco.historico_ocorrencia
FROM db_bisp_reds_reporting.tb_ocorrencia oco
LEFT JOIN db_bisp_reds_reporting.tb_material_apreendido_ocorrencia mat 
    ON oco.numero_ocorrencia = mat.numero_ocorrencia
WHERE 1=1
    AND YEAR(oco.data_hora_fato) > 2023 
    AND oco.natureza_codigo IN ('C01155','C01157')
    and UPPER(mat.informacao_complementar) LIKE '%EUCALIPTO%' 
    AND oco.complemento_natureza_descricao LIKE '%ESTAB%'
;
