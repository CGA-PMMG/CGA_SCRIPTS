/* ----------------------------------------------------------------------------------------------------------------------------------------------------
 *  ================================================================================================================================================
 *  ========================================= AVALIAÇÃO OBJETIVA DO RISCO DE REINCIDÊNCIA – SCORE FONAR ============================================
 *  ================================================================================================================================================
 *
 * Objetivo do script:
 * Avaliação objetiva do risco de reincidência das vítimas de violência doméstica. Utilizando critérios da natureza
 * do registro e do “Score FONAR”, o sistema possibilita a priorização dos casos com maior gravidade, contribuindo
 * para o melhor direcionamento dos recursos disponíveis.
 *
 * Visão geral:
 * - Calcula o SCORE FONAR a partir das respostas do formulário de avaliação de risco.
 * - Identifica vítimas em situação de alto risco, considerando natureza do fato e gravidade.
 * - Consolida histórico de registros policiais e atendimentos de PVD nos últimos 12 meses.
 * - Verifica situação da vítima (viva ou morta) com base em registros de condição física.
 * ---------------------------------------------------------------------------------------------------------------------------------------------------*/
 /*  =================================================
                 CTE FONAR !!!NÃO ALTERAR A CTE!!!
 *  =================================================*/
WITH PONTUACAO_FORM AS (                      -- CTE que calcula o SCORE FONAR por avaliação 
SELECT
ROUND(                                        -- Arredonda o valor final do score para 3 casas decimais
SUM(                                          -- Soma ponderada das respostas do formulário       
CASE WHEN id_pergunta_resposta=1 THEN 0.132100396301189 -- Cada id_pergunta_resposta recebe um peso específico, definido metodologicamente
WHEN id_pergunta_resposta=3 THEN 0.0264200792602378
WHEN id_pergunta_resposta=2 THEN 0.0792602377807134
WHEN id_pergunta_resposta=4 THEN 0
WHEN id_pergunta_resposta=216 THEN 0.0330250990752972
WHEN id_pergunta_resposta=5 THEN 0.132100396301189
WHEN id_pergunta_resposta=9 THEN 0.132100396301189
WHEN id_pergunta_resposta=6 THEN 0.132100396301189
WHEN id_pergunta_resposta=10 THEN 0.132100396301189
WHEN id_pergunta_resposta=7 THEN 0.132100396301189
WHEN id_pergunta_resposta=11 THEN 0.0990752972258917
WHEN id_pergunta_resposta=8 THEN 0.165125495376486
WHEN id_pergunta_resposta=12 THEN 0
WHEN id_pergunta_resposta=18 THEN 0
WHEN id_pergunta_resposta=13 THEN 0.0660501981505945
WHEN id_pergunta_resposta=16 THEN 0.0330250990752972
WHEN id_pergunta_resposta=14 THEN 0.0660501981505945
WHEN id_pergunta_resposta=17 THEN 0.0330250990752972
WHEN id_pergunta_resposta=15 THEN 0.0330250990752972
WHEN id_pergunta_resposta=20 THEN 0
WHEN id_pergunta_resposta=19 THEN 0.165125495376486
WHEN id_pergunta_resposta=21 THEN 0.0990752972258917
WHEN id_pergunta_resposta=22 THEN 0.0792602377807134
WHEN id_pergunta_resposta=23 THEN 0.059445178335535
WHEN id_pergunta_resposta=24 THEN 0.059445178335535
WHEN id_pergunta_resposta=25 THEN 0.0396301188903567
WHEN id_pergunta_resposta=26 THEN 0.059445178335535
WHEN id_pergunta_resposta=27 THEN 0.0396301188903567
WHEN id_pergunta_resposta=28 THEN 0
WHEN id_pergunta_resposta=241 THEN 0.0792602377807134
WHEN id_pergunta_resposta=30 THEN 0.059445178335535
WHEN id_pergunta_resposta=29 THEN 0
WHEN id_pergunta_resposta=32 THEN 0.165125495376486
WHEN id_pergunta_resposta=31 THEN 0
WHEN id_pergunta_resposta=35 THEN 0
WHEN id_pergunta_resposta=33 THEN 0.059445178335535
WHEN id_pergunta_resposta=34 THEN 0.0792602377807134
WHEN id_pergunta_resposta=36 THEN 0.0198150594451783
WHEN id_pergunta_resposta=39 THEN 0
WHEN id_pergunta_resposta=40 THEN 0.0198150594451783
WHEN id_pergunta_resposta=37 THEN 0.0396301188903567
WHEN id_pergunta_resposta=38 THEN 0.0792602377807134
WHEN id_pergunta_resposta=42 THEN 0
WHEN id_pergunta_resposta=245 THEN 0
WHEN id_pergunta_resposta=41 THEN 0.165125495376486
WHEN id_pergunta_resposta=244 THEN 0.165125495376486
WHEN id_pergunta_resposta=246 THEN 0.0330250990752972
WHEN id_pergunta_resposta=44 THEN 0
WHEN id_pergunta_resposta=43 THEN 0.105680317040951
WHEN id_pergunta_resposta=255 THEN 0.0264200792602378
WHEN id_pergunta_resposta=46 THEN 0
WHEN id_pergunta_resposta=45 THEN 0.0264200792602378
WHEN id_pergunta_resposta=47 THEN 0.0132100396301189
WHEN id_pergunta_resposta=49 THEN 0
WHEN id_pergunta_resposta=48 THEN 0.132100396301189
WHEN id_pergunta_resposta=50 THEN 0.0330250990752972
WHEN id_pergunta_resposta=52 THEN 0
WHEN id_pergunta_resposta=53 THEN 0.0198150594451783
WHEN id_pergunta_resposta=54 THEN 0.0792602377807134
WHEN id_pergunta_resposta=55 THEN 0.059445178335535
WHEN id_pergunta_resposta=56 THEN 0.0396301188903567
WHEN id_pergunta_resposta=57 THEN 0.0396301188903567
WHEN id_pergunta_resposta=58 THEN 0.0396301188903567
WHEN id_pergunta_resposta=51 THEN 0.0396301188903567
WHEN id_pergunta_resposta=60 THEN 0
WHEN id_pergunta_resposta=59 THEN 0.105680317040951
WHEN id_pergunta_resposta=63 THEN 0
WHEN id_pergunta_resposta=61 THEN 0.0264200792602378
WHEN id_pergunta_resposta=62 THEN 0.0132100396301189
WHEN id_pergunta_resposta=274 THEN 0.0264200792602378
WHEN id_pergunta_resposta=64 THEN 0.0264200792602378
WHEN id_pergunta_resposta=65 THEN 0.0132100396301189
WHEN id_pergunta_resposta=66 THEN 0
WHEN id_pergunta_resposta=68 THEN 0
WHEN id_pergunta_resposta=67 THEN 0.059445178335535
WHEN id_pergunta_resposta=70 THEN 0
WHEN id_pergunta_resposta=69 THEN 0.059445178335535
WHEN id_pergunta_resposta=71 THEN 0
WHEN id_pergunta_resposta=73 THEN 0
WHEN id_pergunta_resposta=72 THEN 0.105680317040951
WHEN id_pergunta_resposta=75 THEN 0
WHEN id_pergunta_resposta=74 THEN 0.105680317040951
WHEN id_pergunta_resposta=76 THEN 0
WHEN id_pergunta_resposta=78 THEN 0
WHEN id_pergunta_resposta=77 THEN 0.105680317040951
WHEN id_pergunta_resposta=79 THEN 0
WHEN id_pergunta_resposta=81 THEN 0
WHEN id_pergunta_resposta=80 THEN 0.059445178335535
WHEN id_pergunta_resposta=82 THEN 0
WHEN id_pergunta_resposta=83 THEN 0.00660501981505945
WHEN id_pergunta_resposta=84 THEN 0.00660501981505945
WHEN id_pergunta_resposta=85 THEN 0
WHEN id_pergunta_resposta=86 THEN 0.00660501981505945
WHEN id_pergunta_resposta=88 THEN 0
WHEN id_pergunta_resposta=87 THEN 0.0264200792602378
WHEN id_pergunta_resposta=89 THEN 0.0132100396301189
WHEN id_pergunta_resposta=91 THEN 0
WHEN id_pergunta_resposta=90 THEN 0.059445178335535
WHEN id_pergunta_resposta=93 THEN 0
WHEN id_pergunta_resposta=92 THEN 0.059445178335535
WHEN id_pergunta_resposta=151 THEN 0
WHEN id_pergunta_resposta=150 THEN 0.165125495376486
WHEN id_pergunta_resposta=165 THEN 0
WHEN id_pergunta_resposta=164 THEN 0.059445178335535
WHEN id_pergunta_resposta=167 THEN 0.0198150594451783
WHEN id_pergunta_resposta=166 THEN 0.0792602377807134
WHEN id_pergunta_resposta=183 THEN 0
WHEN id_pergunta_resposta=184 THEN 0.0198150594451783
WHEN id_pergunta_resposta=182 THEN 0.0495376486129459
WHEN id_pergunta_resposta=279 THEN 0
WHEN id_pergunta_resposta=278 THEN 0.059445178335535
WHEN id_pergunta_resposta=199 THEN 0
WHEN id_pergunta_resposta=198 THEN 0.105680317040951
WHEN id_pergunta_resposta=205 THEN 0
WHEN id_pergunta_resposta=204 THEN 0.059445178335535
WHEN id_pergunta_resposta=217 THEN 0.132100396301189
WHEN id_pergunta_resposta=222 THEN 0.132100396301189
WHEN id_pergunta_resposta=218 THEN 0.132100396301189
WHEN id_pergunta_resposta=223 THEN 0.132100396301189
WHEN id_pergunta_resposta=219 THEN 0.132100396301189
WHEN id_pergunta_resposta=224 THEN 0.0990752972258917
WHEN id_pergunta_resposta=221 THEN 0.165125495376486
WHEN id_pergunta_resposta=220 THEN 0.132100396301189
WHEN id_pergunta_resposta=225 THEN 0.0660501981505945
WHEN id_pergunta_resposta=226 THEN 0.0660501981505945
WHEN id_pergunta_resposta=227 THEN 0.0330250990752972
WHEN id_pergunta_resposta=228 THEN 0.0330250990752972
WHEN id_pergunta_resposta=229 THEN 0.0330250990752972
WHEN id_pergunta_resposta=230 THEN 0.0330250990752972
WHEN id_pergunta_resposta=231 THEN 0
WHEN id_pergunta_resposta=234 THEN 0
WHEN id_pergunta_resposta=232 THEN 0.105680317040951
WHEN id_pergunta_resposta=233 THEN 0.132100396301189
WHEN id_pergunta_resposta=236 THEN 0
WHEN id_pergunta_resposta=235 THEN 0.165125495376486
WHEN id_pergunta_resposta=237 THEN 0.0330250990752972
WHEN id_pergunta_resposta=239 THEN 0
WHEN id_pergunta_resposta=238 THEN 0.059445178335535
WHEN id_pergunta_resposta=240 THEN 0.0198150594451783
WHEN id_pergunta_resposta=243 THEN 0
WHEN id_pergunta_resposta=242 THEN 0.059445178335535
WHEN id_pergunta_resposta=248 THEN 0
WHEN id_pergunta_resposta=247 THEN 0.165125495376486
WHEN id_pergunta_resposta=249 THEN 0.0330250990752972
WHEN id_pergunta_resposta=253 THEN 0
WHEN id_pergunta_resposta=250 THEN 0.059445178335535
WHEN id_pergunta_resposta=251 THEN 0.0792602377807134
WHEN id_pergunta_resposta=254 THEN 0.0198150594451783
WHEN id_pergunta_resposta=252 THEN 0.0396301188903567
WHEN id_pergunta_resposta=257 THEN 0
WHEN id_pergunta_resposta=256 THEN 0.0264200792602378
WHEN id_pergunta_resposta=258 THEN 0.0132100396301189
WHEN id_pergunta_resposta=262 THEN 0
WHEN id_pergunta_resposta=263 THEN 0.0330250990752972
WHEN id_pergunta_resposta=259 THEN 0.165125495376486
WHEN id_pergunta_resposta=260 THEN 0.132100396301189
WHEN id_pergunta_resposta=261 THEN 0.132100396301189
WHEN id_pergunta_resposta=270 THEN 0
WHEN id_pergunta_resposta=271 THEN 0.0198150594451783
WHEN id_pergunta_resposta=264 THEN 0.0792602377807134
WHEN id_pergunta_resposta=265 THEN 0.059445178335535
WHEN id_pergunta_resposta=266 THEN 0.0396301188903567
WHEN id_pergunta_resposta=267 THEN 0.0396301188903567
WHEN id_pergunta_resposta=268 THEN 0.0396301188903567
WHEN id_pergunta_resposta=269 THEN 0.0396301188903567
WHEN id_pergunta_resposta=273 THEN 0
WHEN id_pergunta_resposta=272 THEN 0.105680317040951
WHEN id_pergunta_resposta=275 THEN 0.0264200792602378
WHEN id_pergunta_resposta=276 THEN 0.0132100396301189
WHEN id_pergunta_resposta=277 THEN 0
WHEN id_pergunta_resposta=281 THEN 0
WHEN id_pergunta_resposta=280 THEN 0.059445178335535
WHEN id_pergunta_resposta=282 THEN 0.0198150594451783
WHEN id_pergunta_resposta=284 THEN 0
WHEN id_pergunta_resposta=283 THEN 0.059445178335535
WHEN id_pergunta_resposta=286 THEN 0
WHEN id_pergunta_resposta=285 THEN 0.105680317040951
WHEN id_pergunta_resposta=288 THEN 0
WHEN id_pergunta_resposta=287 THEN 0.059445178335535
WHEN id_pergunta_resposta=289 THEN 0
WHEN id_pergunta_resposta=290 THEN 0.0132100396301189
WHEN id_pergunta_resposta=291 THEN 0.0264200792602378
WHEN id_pergunta_resposta=152 THEN 0.0990752972258917
WHEN id_pergunta_resposta=153 THEN 0.0792602377807134
WHEN id_pergunta_resposta=154 THEN 0.059445178335535
WHEN id_pergunta_resposta=155 THEN 0.059445178335535
WHEN id_pergunta_resposta=156 THEN 0.0396301188903567
WHEN id_pergunta_resposta=157 THEN 0.059445178335535
WHEN id_pergunta_resposta=158 THEN 0.0396301188903567
WHEN id_pergunta_resposta=159 THEN 0
WHEN id_pergunta_resposta=161 THEN 0
WHEN id_pergunta_resposta=160 THEN 0.059445178335535
WHEN id_pergunta_resposta=163 THEN 0
WHEN id_pergunta_resposta=162 THEN 0.165125495376486
WHEN id_pergunta_resposta=169 THEN 0
WHEN id_pergunta_resposta=171 THEN 0.0198150594451783
WHEN id_pergunta_resposta=168 THEN 0.059445178335535
WHEN id_pergunta_resposta=170 THEN 0.0792602377807134
WHEN id_pergunta_resposta=173 THEN 0
WHEN id_pergunta_resposta=172 THEN 0.165125495376486
WHEN id_pergunta_resposta=175 THEN 0
WHEN id_pergunta_resposta=174 THEN 0.105680317040951
WHEN id_pergunta_resposta=177 THEN 0
WHEN id_pergunta_resposta=176 THEN 0.0264200792602378
WHEN id_pergunta_resposta=178 THEN 0.0132100396301189
WHEN id_pergunta_resposta=180 THEN 0
WHEN id_pergunta_resposta=179 THEN 0.132100396301189
WHEN id_pergunta_resposta=181 THEN 0.0330250990752972
WHEN id_pergunta_resposta=186 THEN 0
WHEN id_pergunta_resposta=185 THEN 0.105680317040951
WHEN id_pergunta_resposta=189 THEN 0
WHEN id_pergunta_resposta=187 THEN 0.0264200792602378
WHEN id_pergunta_resposta=188 THEN 0.0132100396301189
WHEN id_pergunta_resposta=190 THEN 0.0264200792602378
WHEN id_pergunta_resposta=191 THEN 0.0132100396301189
WHEN id_pergunta_resposta=192 THEN 0
WHEN id_pergunta_resposta=196 THEN 0
WHEN id_pergunta_resposta=195 THEN 0.059445178335535
WHEN id_pergunta_resposta=197 THEN 0
WHEN id_pergunta_resposta=201 THEN 0
WHEN id_pergunta_resposta=200 THEN 0.105680317040951
WHEN id_pergunta_resposta=203 THEN 0
WHEN id_pergunta_resposta=202 THEN 0.105680317040951
WHEN id_pergunta_resposta=206 THEN 0
WHEN id_pergunta_resposta=207 THEN 0.00660501981505945
WHEN id_pergunta_resposta=208 THEN 0.00660501981505945
WHEN id_pergunta_resposta=209 THEN 0
WHEN id_pergunta_resposta=210 THEN 0.00660501981505945
WHEN id_pergunta_resposta=212 THEN 0
WHEN id_pergunta_resposta=211 THEN 0.0264200792602378
WHEN id_pergunta_resposta=213 THEN 0.0132100396301189
WHEN id_pergunta_resposta=215 THEN 0
WHEN id_pergunta_resposta=214 THEN 0.059445178335535
WHEN id_pergunta_resposta=194 THEN 0
WHEN id_pergunta_resposta=193 THEN 0.059445178335535
WHEN id_pergunta_resposta=132 THEN 0.132100396301189
WHEN id_pergunta_resposta=134 THEN 0.105680317040951
WHEN id_pergunta_resposta=135 THEN 0
WHEN id_pergunta_resposta=133 THEN 0.0792602377807134
WHEN id_pergunta_resposta=136 THEN 0.132100396301189
WHEN id_pergunta_resposta=137 THEN 0.132100396301189
WHEN id_pergunta_resposta=138 THEN 0.132100396301189
WHEN id_pergunta_resposta=139 THEN 0.132100396301189
WHEN id_pergunta_resposta=140 THEN 0.132100396301189
WHEN id_pergunta_resposta=141 THEN 0.0990752972258917
WHEN id_pergunta_resposta=142 THEN 0.165125495376486
WHEN id_pergunta_resposta=143 THEN 0
WHEN id_pergunta_resposta=149 THEN 0
WHEN id_pergunta_resposta=144 THEN 0.0660501981505945
WHEN id_pergunta_resposta=145 THEN 0.0330250990752972
WHEN id_pergunta_resposta=146 THEN 0.0660501981505945
WHEN id_pergunta_resposta=147 THEN 0.0330250990752972
WHEN id_pergunta_resposta=148 THEN 0.0330250990752972
END),3) AS SCORE,                  -- Score FONAR calculado para a avaliação
id_avaliacao_risco_vd ,                 -- Identificador da avaliação de risco de violência doméstica
numero_ocorrencia,                     -- Número da ocorrência
numero_envolvido_vitima,               -- Número de identificação da vítima na ocorrência
numero_envolvido_agressor,             -- Número de identificação do agressor na ocorrência
id_relacao_vitima_agressor,            -- Código da relação vítima/agressor
relacao_vitima_agressor_descricao      -- Descrição da relação vítima/agressor
FROM db_bisp_reds_reporting.tb_avaliacao_risco_vd 
WHERE 
YEAR(data_hora_inclusao) in (2024,2025) -- Considera avaliações incluídas em 2024 e 2025
AND id_pergunta_resposta IS NOT NULL    -- Garante que haja resposta vinculada
GROUP BY 2,3,4,5,6,7),                  -- Agrupa por identificação da avaliação e envolvidos, mantendo SCORE agregado

MAIOR_PONTUACAO_FORM AS(                -- CTE que retém, por vítima/ocorrência, a avaliação com maior SCORE
SELECT *
FROM(
    SELECT *, ROW_NUMBER() OVER (PARTITION BY numero_ocorrencia,numero_envolvido_vitima ORDER BY SCORE DESC)AS mp
    FROM PONTUACAO_FORM 
)FILTRADO
WHERE mp = 1
),

VITIMAS_FATAL AS(                       -- CTE que identifica vítimas com condição física fatal ('0100')
SELECT nome_completo_envolvido_padrao,
       data_nascimento,
       condicao_fisica_codigo,
       data_hora_fato,
       ROW_NUMBER () OVER(PARTITION BY nome_completo_envolvido_padrao, data_nascimento ORDER BY data_hora_inclusao DESC)AS ORD_F  -- Mantém apenas o registro mais recente de óbito por pessoa
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia 
WHERE condicao_fisica_codigo ='0100'    -- Condição física FATAL
AND nome_completo_envolvido_padrao IS NOT NULL
AND data_nascimento IS NOT NULL
),

TESTE_VITIMA_FATAL AS(                  -- CTE que traz demais ocorrências da mesma vítima, para comparar com registros fatais
SELECT nome_completo_envolvido_padrao, 
       data_nascimento , 
       numero_ocorrencia,
       data_hora_fato,
       ROW_NUMBER() OVER (PARTITION BY nome_completo_envolvido_padrao, data_nascimento ORDER BY data_hora_inclusao desc) AS ORDEM_TVF -- Ordem das ocorrências por vítima
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia
WHERE 1=1
AND nome_completo_envolvido_padrao IS NOT NULL
AND data_nascimento IS NOT NULL
AND (condicao_fisica_codigo <>'0100' OR condicao_fisica_codigo IS NULL) -- Exclui registros com condição física fatal ou nula
),

VITIMAS_ALTO_RISCO AS(                  -- CTE que identifica vítimas em alto risco pela natureza do fato
SELECT
ENV.numero_ocorrencia,                 -- Ocorrência em que a vítima aparece
ENV.nome_completo_envolvido_padrao ,   -- Nome padronizado da vítima
ENV.data_nascimento,                   -- Data de nascimento da vítima
ENV.natureza_ocorrencia_codigo,        -- Natureza principal da ocorrência
CASE WHEN ENV.id_relacao_vitima_autor IN (3,4,9,15,16,18,22) 
		THEN 'SIM' ELSE'NAO' END AS conjugalidade, -- Indica se relação vítima/autor é conjugal/familiar específica
ENV.relacao_vitima_autor_descricao,    -- Descrição da relação vítima/autor
COALESCE(PONTUACAO_FORM.SCORE, 0) score_nat_grave, -- Score FONAR associado, quando existir
CASE WHEN natureza_ocorrencia_codigo = 'D01217' THEN 1   
	WHEN natureza_ocorrencia_codigo = 'B01504' THEN 2
	WHEN natureza_ocorrencia_codigo = 'D01213' THEN 3
	WHEN natureza_ocorrencia_codigo = 'B01125' THEN 4
	WHEN natureza_ocorrencia_codigo = 'B02001' THEN 5
	WHEN natureza_ocorrencia_codigo = 'B01129' THEN 6
	WHEN natureza_ocorrencia_codigo = 'B01121' THEN 7
	WHEN natureza_ocorrencia_codigo = 'B01148' THEN 8
	WHEN natureza_ocorrencia_codigo = 'B01122' THEN 9
	END AS nivel_natureza                 
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV 
INNER JOIN db_bisp_reds_reporting.tb_ocorrencia OCO
ON ENV.numero_ocorrencia = OCO.numero_ocorrencia           -- Junta envolvido à ocorrência
LEFT JOIN PONTUACAO_FORM 
ON ENV.numero_ocorrencia= PONTUACAO_FORM.numero_ocorrencia 
	AND ENV.numero_envolvido= PONTUACAO_FORM.numero_envolvido_vitima
WHERE (natureza_codigo = 'U33004'                          -- Ocorrências marcadas como violência doméstica (natureza principal ou secundárias)
	OR natureza_secundaria1_codigo = 'U33004'
	OR natureza_secundaria2_codigo = 'U33004'
	OR natureza_secundaria3_codigo = 'U33004')
AND (ENV.natureza_ocorrencia_codigo IN ('B01121','B01504') AND ENV.ind_consumado = 'N' -- Tentativas de homicídio/feminicídio
	OR ENV.natureza_ocorrencia_codigo IN('B01122','B02001','D01213','D01217','B01148','B01125') -- Outras naturezas graves
	OR ENV.natureza_ocorrencia_codigo ='B01129' AND ENV.condicao_fisica_codigo ='0300') -- Homicídio consumado com condição específica
AND ENV.nome_completo_envolvido_padrao IS NOT NULL 
AND ENV.data_nascimento IS NOT NULL
AND ENV.data_hora_inclusao >= ADD_MONTHS(NOW(),-12)        -- Considera apenas o último ano
AND ENV.id_envolvimento IN (25,32,1097,26,27,28,872)       -- Tipos de envolvimento relacionados à vítima
),
VITIMAS_ALTO_RISCO_FILTRO AS(           -- CTE que mantém, por vítima, apenas a ocorrência mais grave
SELECT *
FROM(
    SELECT *, ROW_NUMBER() OVER (PARTITION BY nome_completo_envolvido_padrao ,data_nascimento ORDER BY nivel_natureza ASC)AS ra
    FROM VITIMAS_ALTO_RISCO
)FILTRADO
WHERE ra = 1
),
VIT_FORM AS(                            -- CTE que junta vítimas com maior SCORE FONAR, excluindo as já classificadas como alto risco por natureza
SELECT 
ENV.nome_completo_envolvido_padrao , 
ENV.data_nascimento,
ENV.numero_ocorrencia, 
ENV.data_hora_inclusao,
ENV.natureza_ocorrencia_codigo,
MAIOR_PONTUACAO_FORM.SCORE,                     -- Maior score FONAR daquela vítima
MAIOR_PONTUACAO_FORM.id_avaliacao_risco_vd,     -- Id da avaliação
MAIOR_PONTUACAO_FORM.numero_envolvido_vitima,   -- Número do envolvido vítima
MAIOR_PONTUACAO_FORM.relacao_vitima_agressor_descricao, -- Relação vítima/agressor
ROW_NUMBER() OVER (PARTITION BY ENV.nome_completo_envolvido_padrao , ENV.data_nascimento ORDER BY ENV.data_hora_inclusao DESC )AS ordem_form,  -- Ordem das avaliações por vítima
CASE WHEN MAIOR_PONTUACAO_FORM.id_relacao_vitima_agressor IN (3,4,9,15,16,18,22) 
		THEN 'SIM' ELSE'NAO' END AS conjugalidade           -- Indica relação conjugal/familiar específica
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV
INNER JOIN MAIOR_PONTUACAO_FORM
ON ENV.numero_ocorrencia= MAIOR_PONTUACAO_FORM.numero_ocorrencia 
	AND ENV.numero_envolvido= MAIOR_PONTUACAO_FORM.numero_envolvido_vitima
LEFT JOIN VITIMAS_ALTO_RISCO_FILTRO
ON ENV.nome_completo_envolvido_padrao = VITIMAS_ALTO_RISCO_FILTRO.nome_completo_envolvido_padrao 
	AND ENV.data_nascimento = VITIMAS_ALTO_RISCO_FILTRO.data_nascimento	
WHERE ENV.nome_completo_envolvido_padrao IS NOT NULL 
AND VITIMAS_ALTO_RISCO_FILTRO.nome_completo_envolvido_padrao IS NULL -- Exclui quem já está no grupo “alto risco” por natureza
AND ENV.data_nascimento IS NOT NULL
AND ENV.data_hora_inclusao >= ADD_MONTHS(NOW(),-12)        -- Avaliações do último ano
),
VIT_FORM_E_RISCO_ALTO AS(               -- CTE que unifica vítimas com alto risco (por natureza ou por formulário)
SELECT 
COALESCE(VIT_FORM.nome_completo_envolvido_padrao , VITIMAS_ALTO_RISCO_FILTRO.nome_completo_envolvido_padrao) AS nome_completo_envolvido_padrao,
COALESCE(VIT_FORM.data_nascimento,VITIMAS_ALTO_RISCO_FILTRO.data_nascimento) AS data_nascimento,
COALESCE(VIT_FORM.numero_ocorrencia, VITIMAS_ALTO_RISCO_FILTRO.numero_ocorrencia)AS numero_ocorrencia,
CASE WHEN VITIMAS_ALTO_RISCO_FILTRO.nivel_natureza IS NOT NULL AND VITIMAS_ALTO_RISCO_FILTRO.score_nat_grave =0 THEN NULL
	WHEN VITIMAS_ALTO_RISCO_FILTRO.nivel_natureza IS NOT NULL AND VITIMAS_ALTO_RISCO_FILTRO.score_nat_grave >0 THEN VITIMAS_ALTO_RISCO_FILTRO.score_nat_grave ELSE VIT_FORM.SCORE END SCORE_FORM,
    -- SCORE_FORM: score derivado do formulário ou da natureza grave, quando existir
CASE WHEN VITIMAS_ALTO_RISCO_FILTRO.nivel_natureza IS NOT NULL THEN VITIMAS_ALTO_RISCO_FILTRO.score_nat_grave+6 ELSE VIT_FORM.SCORE END SCORE_FINAL,
    -- SCORE_FINAL: inclui incremento para casos com natureza muito grave
COALESCE(VITIMAS_ALTO_RISCO_FILTRO.natureza_ocorrencia_codigo,VIT_FORM.natureza_ocorrencia_codigo)as natureza_ocorrencia_codigo,
COALESCE(VIT_FORM.relacao_vitima_agressor_descricao,VITIMAS_ALTO_RISCO_FILTRO.relacao_vitima_autor_descricao) AS relacao_vitima_agressor_descricao,
CASE WHEN TESTE_VITIMA_FATAL.data_hora_fato <= VITIMAS_FATAL.data_hora_fato AND VITIMAS_FATAL.condicao_fisica_codigo ='0100'THEN 'MORTO' 
	WHEN TESTE_VITIMA_FATAL.data_hora_fato IS NULL AND VITIMAS_FATAL.condicao_fisica_codigo ='0100' THEN 'MORTO' 
	ELSE 'VIVO'END AS ANALISE,                -- Indica se, na análise, a vítima está viva ou morta
COALESCE(VIT_FORM.ordem_form,0)ordem_form,   -- Ordem da avaliação na série histórica (0 quando veio do alto risco)
COALESCE(VIT_FORM.conjugalidade,VITIMAS_ALTO_RISCO_FILTRO.conjugalidade)AS conjugalidade, -- Mantém informação de conjugalidade
VITIMAS_FATAL.condicao_fisica_codigo         -- Código de condição física associado ao registro fatal
FROM VIT_FORM
FULL JOIN VITIMAS_ALTO_RISCO_FILTRO
ON VIT_FORM.nome_completo_envolvido_padrao = VITIMAS_ALTO_RISCO_FILTRO.nome_completo_envolvido_padrao
AND VIT_FORM.data_nascimento = VITIMAS_ALTO_RISCO_FILTRO.data_nascimento
LEFT JOIN VITIMAS_FATAL 
ON COALESCE(VIT_FORM.nome_completo_envolvido_padrao,VITIMAS_ALTO_RISCO_FILTRO.nome_completo_envolvido_padrao) = VITIMAS_FATAL.nome_completo_envolvido_padrao 
	AND COALESCE(VIT_FORM.data_nascimento,VITIMAS_ALTO_RISCO_FILTRO.data_nascimento) = VITIMAS_FATAL.data_nascimento
	AND VITIMAS_FATAL.ORD_F = 1             -- Considera apenas o registro mais recente de óbito
LEFT JOIN TESTE_VITIMA_FATAL 
ON COALESCE(VIT_FORM.nome_completo_envolvido_padrao,VITIMAS_ALTO_RISCO_FILTRO.nome_completo_envolvido_padrao) = TESTE_VITIMA_FATAL.nome_completo_envolvido_padrao 
	AND COALESCE(VIT_FORM.data_nascimento,VITIMAS_ALTO_RISCO_FILTRO.data_nascimento) = TESTE_VITIMA_FATAL.data_nascimento
	AND TESTE_VITIMA_FATAL.ORDEM_TVF = 1    -- Considera a ocorrência mais recente não fatal
WHERE 
VIT_FORM.ordem_form = 1                     -- Mantém a avaliação mais recente
OR VIT_FORM.ordem_form is null              -- Permite entrada de casos que vieram só de alto risco (sem formulário)
),
VIT_GERAL AS (                           -- CTE com indicadores gerais de histórico policial da vítima no último ano
SELECT nome_completo_envolvido_padrao , 
data_nascimento , 
SUM(CASE WHEN env.envolvimento_descricao LIKE '%VITIMA%'  
          AND env.natureza_ocorrencia_codigo NOT IN ('A20002','A20003','A20004','A20005','A20006','A20007','A20008','A20009','A20010','A20011','A20012','A20013','A20014','A20015','A20016','A20017','A20018','A20019','A20020','A20021','A20022','A20023','A20024','A20025','A20026','A20027','Q04009','Q04010','Y07012','Y10011', 'U33025') 
     THEN 1 ELSE 0 END)AS qtde_oco,      -- Quantidade de ocorrências em que entrou como vítima (exceto códigos de PVD)
SUM(CASE WHEN env.natureza_ocorrencia_codigo IN ('A20002','A20003','A20004','A20005','A20006','A20007','A20008','A20009','A20010','A20011','A20012','A20013','A20014','A20015','A20016','A20017','A20018','A20019','A20020','A20021','A20022','A20023','A20024','A20025','A20026','A20027','Q04009','Q04010','Y07012','Y10011', 'U33025') 
     THEN 1 ELSE 0 END)AS atd_pvd,       -- Quantidade de atendimentos/protocolos PVD
SUM(CASE WHEN (natureza_codigo = 'U33004'
	OR natureza_secundaria1_codigo = 'U33004'
	OR natureza_secundaria2_codigo = 'U33004'
	OR natureza_secundaria3_codigo = 'U33004') THEN 1 ELSE 0 END)as qtde_o_vdom -- Quantidade de registros de violência doméstica
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia env 
INNER JOIN db_bisp_reds_reporting.tb_ocorrencia oco 
ON env.numero_ocorrencia = oco.numero_ocorrencia 
WHERE 1=1
AND nome_completo_envolvido_padrao IS NOT NULL
AND data_nascimento IS NOT NULL
AND env.data_hora_inclusao>= ADD_MONTHS(NOW(),-12)  -- Histórico do último ano
AND env.digitador_id_orgao in (0,1)                 -- Órgãos específicos (PM/PC)
GROUP BY 1,2
),
VIT_GERAL_2 AS(                          -- CTE que traz a última ocorrência de violência doméstica da vítima
SELECT nome_completo_envolvido_padrao , 
data_nascimento , 
env.numero_ocorrencia,
env.data_hora_inclusao,
natureza_ocorrencia_descricao, 
ROW_NUMBER() OVER (PARTITION BY nome_completo_envolvido_padrao, data_nascimento ORDER BY env.data_hora_inclusao desc) AS ORDEM_OCORRENCIA -- Ordem das ocorrências por vítima
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia env
INNER JOIN db_bisp_reds_reporting.tb_ocorrencia oco 
ON env.numero_ocorrencia = oco.numero_ocorrencia 
WHERE 1=1
AND nome_completo_envolvido_padrao IS NOT NULL
AND data_nascimento IS NOT NULL
AND envolvimento_descricao LIKE '%VITIMA%'
AND env.digitador_id_orgao in (0,1)
AND env.natureza_ocorrencia_codigo NOT IN ('A20002','A20003','A20004','A20005','A20006','A20007','A20008','A20009','A20010','A20011','A20012','A20013','A20014','A20015','A20016','A20017','A20018','A20019','A20020','A20021','A20022','A20023','A20024','A20025','A20026','A20027','Q04009','Q04010','Y07012','Y10011', 'U33025') -- Exclui PVD
AND (natureza_codigo = 'U33004'
	OR natureza_secundaria1_codigo = 'U33004'
	OR natureza_secundaria2_codigo = 'U33004'
	OR natureza_secundaria3_codigo = 'U33004')
),
VIT_GERAL_3 AS(                          -- CTE que traz a última ocorrência de atendimento PVD da vítima
SELECT nome_completo_envolvido_padrao , 
data_nascimento , 
env.numero_ocorrencia,
env.data_hora_inclusao,
natureza_ocorrencia_descricao, 
ROW_NUMBER() OVER (PARTITION BY nome_completo_envolvido_padrao, data_nascimento ORDER BY env.data_hora_inclusao desc) AS ORDEM_OCORRENCIA
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia env
INNER JOIN db_bisp_reds_reporting.tb_ocorrencia oco 
ON env.numero_ocorrencia = oco.numero_ocorrencia 
WHERE 1=1
AND nome_completo_envolvido_padrao IS NOT NULL
AND data_nascimento IS NOT NULL
AND env.digitador_id_orgao in (0,1)
AND env.natureza_ocorrencia_codigo IN ('A20002','A20003','A20004','A20005','A20006','A20007','A20008','A20009','A20010','A20011','A20012','A20013','A20014','A20015','A20016','A20017','A20018','A20019','A20020','A20021','A20022','A20023','A20024','A20025','A20026','A20027','Q04009','Q04010','Y07012','Y10011', 'U33025') -- Naturezas PVD
),
INICIO_PROTOCOLO AS(                     -- CTE que identifica o início do protocolo PVD por vítima
SELECT nome_completo_envolvido_padrao , 
data_nascimento , 
natureza_ocorrencia_codigo,
data_hora_inclusao,
ROW_NUMBER() OVER (PARTITION BY nome_completo_envolvido_padrao, data_nascimento ORDER BY data_hora_inclusao desc) AS ORDEM_OCORRENCIA
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia
WHERE 1=1
AND nome_completo_envolvido_padrao IS NOT NULL
AND data_nascimento IS NOT NULL
AND natureza_ocorrencia_codigo ='A20003'   -- Código de início de protocolo
AND digitador_id_orgao in (0,1)
),
ENCERRAMENTO_PROTOCOLO AS (              -- CTE que identifica o encerramento do protocolo PVD
SELECT nome_completo_envolvido_padrao , 
data_nascimento , 
natureza_ocorrencia_codigo,
data_hora_inclusao,
ROW_NUMBER() OVER (PARTITION BY nome_completo_envolvido_padrao, data_nascimento ORDER BY data_hora_inclusao desc) AS ORDEM_OCORRENCIA_ENC
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia
WHERE 1=1
AND nome_completo_envolvido_padrao IS NOT NULL
AND data_nascimento IS NOT NULL
AND digitador_id_orgao in (0,1)
AND natureza_ocorrencia_codigo IN ('A20014','A20016','A20017','A20018','A20020','A20024') -- Códigos de encerramento
),
RECUSA_PROTOCOLO AS(                     -- CTE que contabiliza recusas ao protocolo PVD
SELECT nome_completo_envolvido_padrao , 
data_nascimento , 
natureza_ocorrencia_codigo,
COUNT(numero_ocorrencia)qtde_recusa      -- Quantidade de recusas
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia
WHERE 1=1
AND nome_completo_envolvido_padrao IS NOT NULL
AND data_nascimento IS NOT NULL
AND natureza_ocorrencia_codigo ='A20005'  -- Código de recusa
AND digitador_id_orgao in (0,1)
GROUP BY 1,2,3
),
RECUSA_PROTOCOLO_2 AS(                   -- CTE que identifica a última recusa ao protocolo
SELECT nome_completo_envolvido_padrao , 
       data_nascimento , 
       natureza_ocorrencia_codigo,
       data_hora_inclusao ,
       numero_ocorrencia,
       ROW_NUMBER() OVER (PARTITION BY nome_completo_envolvido_padrao, data_nascimento ORDER BY data_hora_inclusao desc) AS ORDEM_OCORRENCIA
FROM db_bisp_reds_reporting.tb_envolvido_ocorrencia
WHERE 1=1
AND nome_completo_envolvido_padrao IS NOT NULL
AND data_nascimento IS NOT NULL
AND natureza_ocorrencia_codigo ='A20005'
AND digitador_id_orgao in (0,1)
)
-- Consulta final: consolida informações de risco, histórico e situação de atendimento das vítimas priorizadas
SELECT
VIT_FORM_E_RISCO_ALTO.numero_ocorrencia,                                             -- Número da ocorrência que gerou o alerta
VIT_FORM_E_RISCO_ALTO.nome_completo_envolvido_padrao as nome_vitima,               -- Nome da vítima
CAST(VIT_FORM_E_RISCO_ALTO.data_nascimento AS DATE)as data_nascimento,             -- Data de nascimento da vítima
conjugalidade,                                                                      -- Indica se há relação conjugal/familiar específica com o agressor
VIT_FORM_E_RISCO_ALTO.relacao_vitima_agressor_descricao,                           -- Descrição da relação vítima/agressor
VIT_FORM_E_RISCO_ALTO.natureza_ocorrencia_codigo,    -- Natureza principal da ocorrência
CASE 	
 		WHEN OCO.codigo_municipio IN (310620) THEN '01 RPM'
   		WHEN OCO.codigo_municipio IN (310670 , 310810 , 310900 , 311860 , 312060 , 312410 , 312600 , 312980 , 313010 , 313220 , 313665 , 314015 , 314070 , 315040 , 315460 , 315530 , 316292 , 316553) THEN '02 RPM'	
		WHEN OCO.codigo_municipio IN (311000 , 311787 , 312170 , 313190 , 313460 , 313660 , 313760 , 314000 , 314480 , 314610 , 315390 , 315480 , 315670 , 315780 , 315900 , 316295 , 316830 , 317120) THEN '03 RPM'
    	WHEN OCO.codigo_municipio IN (310150 , 310310 , 310370 , 310440 , 310460 , 310550 , 310610 , 310690 , 310870 , 311020 , 311170 , 311330 , 311530 , 311590 , 311620 , 311670 , 311960 , 312130 , 312190 , 312200 , 312290 , 312330 , 312400 , 312460 , 312490 , 312530 , 312595 , 312738 , 312840 , 312850 , 312880 , 312900 , 313260 , 313670 , 313800 , 313840 , 313860 , 313980 , 314020 , 314080 , 314160 , 314210 , 314220 , 314390 , 314540 , 314587 , 314670 , 314820 , 314830 , 314880 , 314900 , 314940 , 314950 , 315010 , 315110 , 315130 , 315410 , 315540 , 315580 , 315590 , 315620 , 315630 , 315645 , 315727 , 315840 , 315860 , 315930 , 316000 , 316140 , 316150 , 316290 , 316380 , 316443 , 316560 , 316570 , 316730 , 316750 , 316790 , 316850 , 316900 , 316920 , 316990 , 317130 , 317140 , 317200 , 317210) THEN '04 RPM'	
    	WHEN OCO.codigo_municipio IN (310070 , 310400 , 311110 , 311140 , 311150 , 311455 , 311690 , 311730 , 311820 , 312125 , 312700 , 312710 , 312950 , 313340 , 313440 , 313862 , 314500 , 314920 , 314980 , 315070 , 315160 , 315300 , 315690 , 315770  , 315970 , 316130 , 316810 , 317010 , 317043 , 317110) THEN '05 RPM'
    	WHEN OCO.codigo_municipio IN (310080 , 310710 , 310800 , 311070 , 311090 , 311120 , 311190 , 311200 , 311390 , 311400 , 311450 , 311460 , 311770 , 311870 , 312020 , 312360 , 312810 , 313000 , 313040 , 313050 , 313080 , 313430 , 313450 , 313590 , 313780 , 313820 , 313870 , 314260 , 314460 , 314550 , 314560 , 314770 , 314990 , 315060 , 315470 , 315830 , 315880 , 315990 , 316080 , 316120 , 316520 , 316930 , 316940 , 317070) THEN '06 RPM'
    	WHEN OCO.codigo_municipio IN (310020 , 310390 , 310420 , 310510 , 310700 , 310740 , 311040 , 311420 , 311560 , 311660 , 311760 , 311980 , 311995 , 312230 , 312320 , 312470 , 312610 , 313020 , 313030 , 313350 , 313370 , 313380 , 313530 , 313720 , 313830 , 313880 , 313970 , 314050 , 314130 , 314240 , 314350 , 314520 , 314580 , 314640 , 314650 , 314690 , 314710 , 314890 , 314960 , 314970 , 315050 , 315140 , 315200 , 315370 , 316040 , 316180 , 316310 , 316460 , 316660 , 316820) THEN '07 RPM'
    	WHEN OCO.codigo_municipio IN (310110 , 310180 , 310220 , 311205 , 311265 , 311570 , 311680 , 311840 , 311920 , 312083 , 312210 , 312220 , 312310 , 312370 , 312580 , 312690 , 312695 , 312730 , 312737 , 312750 , 312770 , 312800 , 313180 , 313320 , 313410 , 313655 , 313960 , 314010 , 314060 , 314150 , 314420 , 314467 , 314840 , 314860 , 314995 , 315430 , 315600 , 315680 , 315750 , 315820 , 315950 , 316105 , 316160 , 316165 , 316257 , 316280 , 316300 , 316350 , 316410 , 316450 , 316550 , 316610 , 316770 , 316840 , 316950 , 317150 , 317180 , 317190) THEN '08 RPM'	
    	WHEN OCO.codigo_municipio IN (310350 , 310375 , 310980 , 311180 , 311260 , 311500 , 311580 , 312480 , 312790 , 312910 , 313070 , 313140 , 313420 , 314280 , 315280 , 315980 , 316960 , 317020) THEN '09 RPM'
    	WHEN OCO.codigo_municipio IN (310010 , 310380 , 311430 , 311930 , 312070 , 312350 , 312890 , 313160 , 313710 , 313750 , 313753 , 314120 , 314310 , 314800 , 314810 , 315340 , 315550 , 315640 , 316170 , 316210 , 316680 , 316890 , 317075) THEN '10 RPM'
    	WHEN OCO.codigo_municipio IN (310665 , 310730 , 310825 , 310850 , 310860 , 311115 , 311270 , 311547 , 311650 , 311783 , 311880 , 312030 , 312087 , 312380 , 312430 , 312660 , 312670 , 312707 , 312733 , 312735 , 312780 , 312825 , 312960 , 312965 , 313005 , 313065 , 313200 , 313210 , 313505 , 313510 , 313520 , 313535 , 313657 , 313680 , 313695 , 313730 , 313865 , 313868 , 313925 , 313930 , 314085 , 314100 , 314200 , 314225 , 314270 , 314290 , 314330 , 314345 , 314465 , 314505 , 314537 , 314545 , 314625 , 314655 , 314795 , 314915 , 315057 , 315213 , 315220 , 315450 , 315560 , 315650 , 315700 , 315737 , 316045 , 316110 , 316225 , 316240 , 316245 , 316265 , 316270 , 316695 , 316800 , 317000 , 317065 , 317090 , 317103) THEN '11 RPM'
    	WHEN OCO.codigo_municipio IN (310030 , 310040 , 310050 , 310205 , 310230 , 310250 , 310300 , 310540 , 310570 , 310600 , 310630 , 310770 , 310780 , 310880 , 310925 , 311010 , 311210 , 311290 , 311340 , 311380 , 311535 , 311600 , 311740 , 311940 , 312000 , 312180 , 312250 , 312270 , 312352 , 312385 , 312420 , 312590 , 312820 , 312930 , 313055 , 313090 , 313115 , 313120 , 313130 , 313170 , 313280 , 313500 , 313550 , 313610 , 313620 , 313770 , 313867 , 313940 , 313950 , 314030 , 314053 , 314090 , 314170 , 314400 , 314435 , 314470 , 314585 , 314750 , 314875 , 315015 , 315020 , 315053 , 315190 , 315210 , 315350 , 315400 , 315415 , 315490 , 315500 , 315570 , 315720 , 315725 , 315740 , 315790 , 315800 , 315890 , 315895 , 315935 , 316010 , 316095 , 316100 , 316190 , 316255 , 316260 , 316340 , 316360 , 316400 , 316447 , 316556 , 316630 , 316760 , 316805 , 316870 , 317005 , 317050 , 317057 , 317115) THEN '12 RPM'	
    	WHEN OCO.codigo_municipio IN (310163 , 310210 , 310280 , 310290 , 310330 , 310360 , 310560 , 310590 , 310640 , 310680 , 310750 , 311220 , 311310 , 311320 , 311490 , 311520 , 311540 , 311630 , 311800 , 311830 , 311970 , 312040 , 312140 , 312150 , 312300 , 312390 , 312500 , 312940 , 313390 , 313540 , 313740 , 313790 , 313910 , 314230 , 314450 , 314570 , 314590 , 314660 , 315030 , 315080 , 315230 , 315270 , 315310 , 315380 , 315420 , 315440 , 315520 , 315610 , 315730 , 315733 , 315870 , 315910 , 315940 , 316070 , 316090 , 316250 , 316500 , 316530 , 316600 , 316620 , 316880) THEN'13 RPM'	
    	WHEN OCO.codigo_municipio IN (310060 , 310240 , 310285 , 310445 , 310480 , 310650 , 310920 , 310940 , 311230 , 311350 , 311610 , 311750 , 311810 , 311910 , 312010 , 312090 , 312100 , 312160 , 312260 , 312540 , 312550 , 312570 , 312650 , 312760 , 313110 , 313250 , 313545 , 313560 , 313640 , 313652 , 313810 , 313835 , 314180 , 314250 , 314360 , 314370 , 315120 , 315320 , 315330 , 315760 , 316020 , 316050 , 316060 , 316420 , 316480 , 316590 , 316650 , 316710 , 316935 , 316970 , 317080 , 317107) THEN '14 RPM'
    	WHEN OCO.codigo_municipio IN (310090 , 310100 , 310170 , 310270 , 310340 , 310470 , 310520 , 310660 , 311080 , 311300 , 311370 , 311545 , 311700 , 311950 , 312015 , 312235 , 312245 , 312560 , 312675 , 312680 , 312705 , 313230 , 313270 , 313330 , 313400 , 313470 , 313507 , 313580 , 313600 , 313650 , 313700 , 313890 , 313920 , 314055 , 314140 , 314315 , 314430 , 314490 , 314530 , 314535 , 314620 , 314630 , 314675 , 314850 , 314870 , 315000 , 315217 , 315240 , 315510 , 315660 , 315710 , 315765 , 315810 , 316030 , 316330 , 316555 , 316670 , 316860 , 317030 , 317160) THEN '15 RPM'	
	    WHEN OCO.codigo_municipio IN (310450 , 310820 , 310855 , 310930 , 310945 , 311615 , 312247 , 312620 , 312860 , 313630 , 314437 , 314700 , 315445 , 317040 , 317047 , 317052 , 317100) THEN '16 RPM'	
	    WHEN OCO.codigo_municipio IN (310120 , 310130 , 310140 , 310490 , 310720 , 310790 , 310830 , 310890 , 310910 , 310970 , 311050 , 311060 , 311360 , 311410 , 311480 , 311550 , 311720 , 311780 , 311790 , 311850 , 311900 , 311990 , 312050 , 312080 , 312110 , 312280 , 312440 , 312450 , 312510 , 312740 , 312920 , 313060 , 313240 , 313300 , 313310 , 313360 , 313490 , 313850 , 313990 , 314040 , 314190 , 314340 , 314380 , 314440 , 314600 , 314730 , 314760 , 314780 , 314910 , 315090 , 315100 , 315250 , 315260 , 315960 , 316200 , 316230 , 316320 , 316370 , 316440 , 316490 , 316540 , 316557 , 316580 , 316640 , 316700 , 316740 , 316780 , 316905 , 316910 , 316980 , 317170 , 317220) THEN'17 RPM'	
	    WHEN OCO.codigo_municipio IN (310160 , 310190 , 310200 , 310260 , 310410 , 310430 , 310530 , 310760 , 310840 , 310950 , 311030 , 311100 , 311130 , 311160 , 311240 , 311280 , 311440 , 311470 , 311510 , 311640 , 311710 , 312120 , 312240 , 312340 , 312520 , 312630 , 312830 , 312870 , 312970 , 312990 , 313150 , 313290 , 313375 , 313480 , 313690 , 313900 , 314300 , 314320 , 314410 , 314510 , 314720 , 314790 , 315150 , 315170 , 315180 , 315290 , 315920 , 316220 , 316294 , 316390 , 316430 , 316470 , 316510 , 316690 , 317060) THEN '18 RPM'	
	    WHEN OCO.codigo_municipio IN (316720 , 314930 , 314110 , 314740 , 315360 , 310990 , 310500 , 311250 , 313570 , 313100 , 310320 , 312720 , 311890 , 312640 , 310960 , 315850) THEN '19 RPM'	
   	END AS RPM,
	   	--ELSE SPLIT_PART(OCO.unidade_area_militar_nome,'/',-1) END as RPM,
--SPLIT_PART(OCO.unidade_area_militar_nome,'/',-2)as UEOP,
CASE WHEN OCO.codigo_municipio IN (310690,311590,311960,312130,312738,312850,314020,314950,315010,315540,315620,316290) THEN '02 BPM'
		WHEN OCO.codigo_municipio IN (310240,311750,311810,312010,312100,312160,312260,312540,312550,312760,314250,314370,315330,316020,316050,316480,316590,316650,316710) THEN '03 BPM'
		WHEN OCO.codigo_municipio IN (312125) THEN '04 BPM'
		WHEN OCO.codigo_municipio IN (312770,310180,311265,312370,312580,313320,314995,316770,316840,310220,312690,314010,317150,316160,316300) THEN '06 BPM'
		WHEN OCO.codigo_municipio IN (310020,310700,310740,311560,311980,312320,312470,313530,313720,313880,314050,314240,314350,314640,314890,315200,315370,316040,316660) THEN '07 BPM'
		WHEN OCO.codigo_municipio IN (310080,310800,311120,311190,311200,311400,311450,311460,312020,313000,313040,313080,313430,313450,313820,313870,314460,314560,314770,314990,315060,315470,315880,315990,316120) THEN '08 BPM'
		WHEN OCO.codigo_municipio IN (310163,310210,310290,310330,310560,310680,311630,312150,312500,312940,314570,314660,315030,315440,315730,315870,315940,316070) THEN '09 BPM'
		WHEN OCO.codigo_municipio IN (314480,315390,315480) THEN '1 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310730,311650,311880,312380,312660,312735,312825,312960,313200,313680,313730,314545,316225,316265) THEN '10 BPM'
		WHEN OCO.codigo_municipio IN (310370,311020,311170,311670,312400,314830,314880,316380,316850,317130) THEN '10 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310030,310205,311010,311210,311290,311600,312352,312420,313770,313867,313940,313950,314053,314090,314400,314875,315350,315415,315790,315890,316255,316630,316760,316360) THEN '11 BPM'
		WHEN OCO.codigo_municipio IN (311250,314110,314930,315360) THEN '11 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310190,311240,311280,311510,311640,312120,312340,312970,313375,314790,315150,315290,316220,316294,316430,317060) THEN '12 BPM'
		WHEN OCO.codigo_municipio IN (310860,311115,312965,313005,313535,313865,313868,315057,315213,316110,316240,317000,317090) THEN '13 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310050,310630,310880,313115,313130,313610,314170,314435,315895) THEN '14 BPM'
		WHEN OCO.codigo_municipio IN (310340,311950,313400,314630,317160,311700,313330,314140,315217) THEN '70 BPM'
		WHEN OCO.codigo_municipio IN (310380,311430,313710,313750,313753,314120,314800,315340,315550,316170,316210,316890,317075) THEN '15 BPM'
		WHEN OCO.codigo_municipio IN (310110,311840,312083,312737,313410,315430,315950,316950) THEN '15 CIA PM IND'
		WHEN OCO.codigo_municipio IN (311070,311090,311770,313590,313780,314550,316080,316520,316930,314260) THEN '16 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310230,310600,312180,312270,313620,314470,315570,316100,316340,316556) THEN '17 CIA PM IND'
		WHEN OCO.codigo_municipio IN (311570,312210,312730,313180,313960,314150,314467,316105,316165,316257) THEN '18 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310470,311080,311300,311545,312675,312680,313230,313270,313507,313700,313920,314490,314530,314535,314620,314850,315000,315240,316330,316555,316860) THEN '19 BPM'
		WHEN OCO.codigo_municipio IN (313020,313970,314580,314690,314710,314960,316310) THEN '19 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310665,312087,312707,313065,314345,314465,314537,314625,315560,315650,315700,315737,316045,316270,316800,317065) THEN '2 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310140,310830,310970,311360,311720,311780,311790,311900,312440,312450,312920,313060,313490,314340,314440,314600,315250,315960,316200,316230,316440,316580,316740,316905,316980) THEN '20 BPM'
		WHEN OCO.codigo_municipio IN (310870,312190,312330,312840,312880,312900,314160,315130,315580,315630,316150,316570,316730,316790,316900,316990,317200) THEN '21 BPM'
		WHEN OCO.codigo_municipio IN (310040,310250,310570,312820,313550,314585,315020,315210,315490,315500,315740,316010,316400,317050) THEN '21 CIA PM IND'
		WHEN OCO.codigo_municipio IN (311420,311660,312230,316180) THEN '23 BPM'
		WHEN OCO.codigo_municipio IN (310060,310285,310445,310650,311230,311350,311610,312650,313250,313545,313652,313835,314180,316970,317107) THEN '23 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310710,311390,311870,312360,312810,313050,315830,316940,317070) THEN '24 BPM'
		WHEN OCO.codigo_municipio IN (310090,310660,311370,312015,312705,313890,314430,315765,316670,317030) THEN '24 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310320,310500,310960,310990,311890,312640,312720,313100,313570,314740,315850,316720) THEN '25 BPM'
		WHEN OCO.codigo_municipio IN (311205,311680,311920,312220,312310,312695,312750,312800,313655,314060,314420,314840,314860,315600,315680,315750,315820,316280,316350,316410,316450,316550,316610,317180,317190) THEN '65 BPM'
		WHEN OCO.codigo_municipio IN (310540,310770,311380,311535,312590,313170,313280,314750,315720,315800,316190) THEN '26 BPM'
		WHEN OCO.codigo_municipio IN (310610,311620,313860,313980,314080,314540,314940,315590,315727,315860,315930,316560,316750) THEN '27 BPM'
		WHEN OCO.codigo_municipio IN (310450,310820,310930,310945,311615,312247,312620,314437,315445,317040,317047,317052) THEN '28 BPM'
		WHEN OCO.codigo_municipio IN (310260,310530,310840,310950,311030,311100,312240,312990,313150,315180,315920) THEN '29 BPM'
		WHEN OCO.codigo_municipio IN (311110,311455,313440,313862,317043) THEN '3 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310825,311783,313210,313520,313695,313930,314225,314270,314915,316245) THEN '30 BPM'
		WHEN OCO.codigo_municipio IN (310640,311220,311310,311320,311490,311540,311800,311830,312040,312140,312390,313390,313540,313790,314230,314590,315080,315230,315310,315380,315520,315910,316090,316600) THEN '31 BPM'
		WHEN OCO.codigo_municipio IN (315780) THEN '35 BPM'
		WHEN OCO.codigo_municipio IN (316295,317120) THEN '36 BPM'
		WHEN OCO.codigo_municipio IN (313760,311787,315900,313460) THEN '8 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310400,311150,311820,312950,314500,314920,314980,315300,315690,315770,315970,316810) THEN '37 BPM'
		WHEN OCO.codigo_municipio IN (310280,310360,310590,310750,311520,311970,312300,313740,313910,314450,315270,315420,315610,315733,316250,316500,316530,316880) THEN '38 BPM'
		WHEN OCO.codigo_municipio IN (311690,312700,312710,313340,315160,316130,311140,311730,315070) THEN '69 BPM'
		WHEN OCO.codigo_municipio IN (315460) THEN '40 BPM'
		WHEN OCO.codigo_municipio IN (310480,310920,311910,312090,312570,313110,313640,314360,315320,316060,316935) THEN '42 BPM'
		WHEN OCO.codigo_municipio IN (310410,310760,312830,312870,313290,313690,314300,314320,314410,314510,316390,316470,316510,312630,313480) THEN '43 BPM'
		WHEN OCO.codigo_municipio IN (310170,310520,312245,312560,313470,313580,313600,313650,314055,314315,314675,315510,315660,315710,315810,316030,310100,310270,312235,314870) THEN '44 BPM'
		WHEN OCO.codigo_municipio IN (310855,312860,313630,314700,317100) THEN '45 BPM'
		WHEN OCO.codigo_municipio IN (310010,311930,312070,312350,312890,313160,314310,314810,315640,316680) THEN '46 BPM'
		WHEN OCO.codigo_municipio IN (310310,310550,311330,312200,312490,312530,312595,313800,314210,314390,314587,314670,314820,314900,315645,316140,316920,317140) THEN '47 BPM'
		WHEN OCO.codigo_municipio IN (310900,312980,314015,316553) THEN '48 BPM'
		WHEN OCO.codigo_municipio IN (310850,311270,312030,312670,312780,313657,314200,314795 ) THEN '50 BPM'
		WHEN OCO.codigo_municipio IN (311547,312430,312733,313505,313510,313925,314100,314290,314505,314655,315220,315450,316695,317103,314085) THEN '51 BPM'
		WHEN OCO.codigo_municipio IN (312170,313190,314000,314610) THEN '52 BPM'
		WHEN OCO.codigo_municipio IN (310350,310375,311500,312480,312790,313070,316960) THEN '53 BPM'
		WHEN OCO.codigo_municipio IN (310980,311180,311260,311580,312910,313140,313420,314280,315280,315980) THEN '54 BPM'
		WHEN OCO.codigo_municipio IN (310940,313560,313810,315120,315760,316420,317080) THEN '55 BPM'
		WHEN OCO.codigo_municipio IN (310890,311850,312050,312110,312740,313240,313990,314040,314730,314910,315090,315100,316320,316540,317220) THEN '56 BPM'
		WHEN OCO.codigo_municipio IN (310120,310130,310490,310720,311410,311480,311550,312080,312280,313300,313310,313850,314190,314760,314780,315260,316370,316490,316640,316700,316780,317170) THEN '57 BPM'
		WHEN OCO.codigo_municipio IN (310300,311940,313500,314030,316870) THEN '58 BPM'
		WHEN OCO.codigo_municipio IN (310790,311050,311060,311990,312510,313360,316557,316910,310910,314380) THEN '59 BPM'
		WHEN OCO.codigo_municipio IN (310390,311760,313830,314520,314970,315140) THEN '60 BPM'
		WHEN OCO.codigo_municipio IN (311000,313660,315670,316830) THEN '61 BPM'
		WHEN OCO.codigo_municipio IN (310780,311340,311740,312000,312250,312385,313055,313090,313120,315015,315053,315190,315400,315725,315935,316095,316260,316447,316805,317005,317057,317115,310925,312930) THEN '62 BPM'
		WHEN OCO.codigo_municipio IN (310420,310510,311040,311995,312610,313030,313350,314130,314650,315050,316460,316820) THEN '63 BPM'
		WHEN OCO.codigo_municipio IN (310160,310200,310430,311130,311160,311440,311470,311710,312520,313900,314720,315170,316690) THEN '64 BPM'
		WHEN OCO.codigo_municipio IN (312410) THEN '6 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310070,317110) THEN '67 BPM'
		WHEN OCO.codigo_municipio IN (310810,312060,312600,313010,313220,313665,314070,315040,315530,316292) THEN '7 CIA PM IND'
		WHEN OCO.codigo_municipio IN (310440,310460,311530,312290,313260,313840,314220,315410,315840,316443,315110,317210,310150,316000,312460) THEN '68 BPM'
		WHEN OCO.codigo_municipio IN (313370,313380) THEN '9 CIA PM IND'
		/* MUNIC PIOS COM MAIS DE 01 UEOP - 7 Munic pios*/
		WHEN OCO.codigo_municipio =317020 AND (OCO.unidade_area_militar_nome LIKE '32 BPM%' or OCO.unidade_area_militar_nome LIKE '%/32 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '32 BPM'
		WHEN OCO.codigo_municipio =317020 AND (OCO.unidade_area_militar_nome LIKE '17 BPM%' or OCO.unidade_area_militar_nome LIKE '%/17 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '17 BPM'
		WHEN OCO.codigo_municipio =317010 AND (OCO.unidade_area_militar_nome LIKE '4 BPM%' or OCO.unidade_area_militar_nome LIKE '%/4 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '04 BPM'
		WHEN OCO.codigo_municipio =317010 AND (OCO.unidade_area_militar_nome LIKE '67 BPM%' or OCO.unidade_area_militar_nome LIKE '%/67 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '67 BPM'
		WHEN OCO.codigo_municipio =314330 AND (OCO.unidade_area_militar_nome LIKE '50 BPM%' or OCO.unidade_area_militar_nome LIKE '%/50 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '50 BPM'
		WHEN OCO.codigo_municipio =314330 AND (OCO.unidade_area_militar_nome LIKE '10 BPM%' or OCO.unidade_area_militar_nome LIKE '%/10 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '10 BPM'
		WHEN OCO.codigo_municipio =313670 AND (OCO.unidade_area_militar_nome LIKE '27 BPM%' or OCO.unidade_area_militar_nome LIKE '%/27 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '27 BPM'
		WHEN OCO.codigo_municipio =313670 AND (OCO.unidade_area_militar_nome LIKE '2 BPM%' or OCO.unidade_area_militar_nome LIKE '%/2 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '02 BPM'
		WHEN OCO.codigo_municipio =311860 AND (OCO.unidade_area_militar_nome LIKE '39 BPM%' or OCO.unidade_area_militar_nome LIKE '%/39 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '39 BPM'
		WHEN OCO.codigo_municipio =311860 AND (OCO.unidade_area_militar_nome LIKE '18 BPM%' or OCO.unidade_area_militar_nome LIKE '%/18 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '18 BPM'
		WHEN OCO.codigo_municipio =310670 AND (OCO.unidade_area_militar_nome LIKE '66 BPM%' or OCO.unidade_area_militar_nome LIKE '%/66 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '66 BPM'
		WHEN OCO.codigo_municipio =310670 AND (OCO.unidade_area_militar_nome LIKE '33 BPM%' or OCO.unidade_area_militar_nome LIKE '%/33 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '33 BPM'
		WHEN OCO.codigo_municipio =310620 AND (OCO.unidade_area_militar_nome LIKE '1 BPM%' or OCO.unidade_area_militar_nome LIKE '%/1 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '01 BPM'
		WHEN OCO.codigo_municipio =310620 AND (OCO.unidade_area_militar_nome LIKE '5 BPM%' or OCO.unidade_area_militar_nome LIKE '%/5 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%') THEN '05 BPM'
		WHEN OCO.codigo_municipio =310620 AND (OCO.unidade_area_militar_nome LIKE '13 BPM%' or OCO.unidade_area_militar_nome LIKE '%/13 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%') THEN '13 BPM'
		WHEN OCO.codigo_municipio =310620 AND (OCO.unidade_area_militar_nome LIKE '16 BPM%' or OCO.unidade_area_militar_nome LIKE '%/16 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%') THEN '16 BPM'
		WHEN OCO.codigo_municipio =310620 AND (OCO.unidade_area_militar_nome LIKE '22 BPM%' or OCO.unidade_area_militar_nome LIKE '%/22 BPM%' ) AND (OCO.unidade_area_militar_nome not LIKE '%TM%') THEN '22 BPM'
		WHEN OCO.codigo_municipio =310620 AND (OCO.unidade_area_militar_nome LIKE '41 BPM%' or OCO.unidade_area_militar_nome LIKE '%/41 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '41 BPM'
		WHEN OCO.codigo_municipio =310620 AND (OCO.unidade_area_militar_nome LIKE '49 BPM%' or OCO.unidade_area_militar_nome LIKE '%/49 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '49 BPM'
		WHEN OCO.codigo_municipio =310620 AND (OCO.unidade_area_militar_nome LIKE '34 BPM%' or OCO.unidade_area_militar_nome LIKE '%/34 BPM%') AND (OCO.unidade_area_militar_nome not LIKE '%TM%')THEN '34 BPM'
		WHEN OCO.codigo_municipio =316620 AND (OCO.unidade_area_militar_nome like '31 BPM%' or OCO.unidade_area_militar_nome like '%/31 BPM%') THEN '31 BPM'
		WHEN OCO.codigo_municipio =316620 AND (OCO.unidade_area_militar_nome like '9 BPM%' or OCO.unidade_area_militar_nome like '%/9 BPM%') THEN '9 BPM'
		ELSE 'OUTROS' END as UEOP,
CASE WHEN SPLIT_PART(OCO.unidade_area_militar_nome,'/',-2) LIKE '%CIA PM IND%' 
		THEN '' ELSE SPLIT_PART(OCO.unidade_area_militar_nome,'/',-3) END as Cia_PM, -- Cia PM da unidade de área militar
OCO.unidade_area_militar_nome ,                                                     -- Unidade da área militar completa
OCO.nome_municipio ,                                                                -- Município da ocorrência
OCO.nome_bairro ,                                                                   -- Bairro da ocorrência
VIT_GERAL.qtde_oco as qtde_registros_policiais_ultimo_ano ,                        -- Quantidade de registros policiais em que foi vítima no último ano
VIT_GERAL.qtde_o_vdom as qtde_registros_vdom_ultimo_ano,                           -- Quantidade de registros de violência doméstica no último ano
VIT_GERAL.atd_pvd as qtde_atendimentos_PVD,                                        -- Quantidade de atendimentos/protocolos PVD
CAST(VIT_GERAL_3.data_hora_inclusao AS DATE) as data_ultimo_atendimento_pvd,       -- Data do último atendimento PVD
CAST(VIT_GERAL_2.data_hora_inclusao AS DATE) as data_ultimo_registro,              -- Data do último registro de violência doméstica
CAST(ENCERRAMENTO_PROTOCOLO.data_hora_inclusao AS DATE) as data_encerramento_protocolo, -- Data de encerramento do protocolo, se houver
CAST(INICIO_PROTOCOLO.data_hora_inclusao AS DATE) as data_inicio_protocolo,        -- Data de início do protocolo PVD
CASE WHEN ENCERRAMENTO_PROTOCOLO.data_hora_inclusao IS NULL 
         AND INICIO_PROTOCOLO.data_hora_inclusao IS NOT NULL THEN 'Em atendimento'
	 WHEN INICIO_PROTOCOLO.data_hora_inclusao IS NULL THEN 'Sem atendimento'	
	 WHEN INICIO_PROTOCOLO.data_hora_inclusao IS NOT NULL 
          AND ENCERRAMENTO_PROTOCOLO.data_hora_inclusao IS NOT NULL 
          AND ENCERRAMENTO_PROTOCOLO.data_hora_inclusao <INICIO_PROTOCOLO.data_hora_inclusao THEN 'Em atendimento'
	 WHEN INICIO_PROTOCOLO.data_hora_inclusao IS NOT NULL 
          AND ENCERRAMENTO_PROTOCOLO.data_hora_inclusao IS NOT NULL 
          AND ENCERRAMENTO_PROTOCOLO.data_hora_inclusao >VIT_GERAL_2.data_hora_inclusao THEN 'Encerrado'
	 WHEN INICIO_PROTOCOLO.data_hora_inclusao IS NOT NULL 
          AND ENCERRAMENTO_PROTOCOLO.data_hora_inclusao IS NOT NULL 
          AND ENCERRAMENTO_PROTOCOLO.data_hora_inclusao >INICIO_PROTOCOLO.data_hora_inclusao THEN 'Sem atendimento'
END AS situacao_atendimento,                                                        -- Situação atual do atendimento PVD
CASE WHEN ENCERRAMENTO_PROTOCOLO.data_hora_inclusao IS NOT NULL
		AND ENCERRAMENTO_PROTOCOLO.data_hora_inclusao >VIT_GERAL_2.data_hora_inclusao THEN 'excluir'
	 ELSE 'manter' END AS situacao_vitima_lista,                                   -- Indica se a vítima deve ser mantida ou excluída da lista de acompanhamento
	 COALESCE(RECUSA_PROTOCOLO.qtde_recusa,0)as qtdes_recusa,                      -- Quantidade de recusas ao protocolo
CAST(RECUSA_PROTOCOLO_2.data_hora_inclusao AS DATE) as data_ultima_recusa,         -- Data da última recusa, se existente
OCO.data_hora_inclusao,                                                            -- Data/hora de inclusão da ocorrência
SCORE_FINAL,                                                                       -- Score final de risco (considerando natureza e formulário)
SCORE_FORM                                                                         -- Score FONAR calculado a partir do formulário
FROM VIT_FORM_E_RISCO_ALTO
INNER JOIN db_bisp_reds_reporting.tb_ocorrencia OCO 
ON VIT_FORM_E_RISCO_ALTO.numero_ocorrencia = OCO.numero_ocorrencia AND VIT_FORM_E_RISCO_ALTO.ordem_form IN (0,1) AND VIT_FORM_E_RISCO_ALTO.ANALISE = 'VIVO'
LEFT JOIN VIT_GERAL
ON VIT_FORM_E_RISCO_ALTO.nome_completo_envolvido_padrao = VIT_GERAL.nome_completo_envolvido_padrao 
   AND VIT_FORM_E_RISCO_ALTO.data_nascimento = VIT_GERAL.data_nascimento
LEFT JOIN VIT_GERAL_2
ON VIT_FORM_E_RISCO_ALTO.nome_completo_envolvido_padrao = VIT_GERAL_2.nome_completo_envolvido_padrao 
   AND VIT_FORM_E_RISCO_ALTO.data_nascimento = VIT_GERAL_2.data_nascimento 
   AND VIT_GERAL_2.ORDEM_OCORRENCIA =1
LEFT JOIN VIT_GERAL_3
ON VIT_FORM_E_RISCO_ALTO.nome_completo_envolvido_padrao = VIT_GERAL_3.nome_completo_envolvido_padrao 
   AND VIT_FORM_E_RISCO_ALTO.data_nascimento = VIT_GERAL_3.data_nascimento 
   AND VIT_GERAL_3.ORDEM_OCORRENCIA =1
LEFT JOIN INICIO_PROTOCOLO
ON VIT_FORM_E_RISCO_ALTO.nome_completo_envolvido_padrao = INICIO_PROTOCOLO.nome_completo_envolvido_padrao 
   AND VIT_FORM_E_RISCO_ALTO.data_nascimento = INICIO_PROTOCOLO.data_nascimento 
   AND INICIO_PROTOCOLO.ORDEM_OCORRENCIA = 1
LEFT JOIN ENCERRAMENTO_PROTOCOLO 
ON VIT_FORM_E_RISCO_ALTO.nome_completo_envolvido_padrao = ENCERRAMENTO_PROTOCOLO.nome_completo_envolvido_padrao 
   AND VIT_FORM_E_RISCO_ALTO.data_nascimento = ENCERRAMENTO_PROTOCOLO.data_nascimento 
   AND ENCERRAMENTO_PROTOCOLO.ORDEM_OCORRENCIA_ENC = 1
LEFT JOIN RECUSA_PROTOCOLO
ON VIT_FORM_E_RISCO_ALTO.nome_completo_envolvido_padrao = RECUSA_PROTOCOLO.nome_completo_envolvido_padrao 
   AND VIT_FORM_E_RISCO_ALTO.data_nascimento = RECUSA_PROTOCOLO.data_nascimento
LEFT JOIN RECUSA_PROTOCOLO_2
ON VIT_FORM_E_RISCO_ALTO.nome_completo_envolvido_padrao = RECUSA_PROTOCOLO_2.nome_completo_envolvido_padrao 
   AND VIT_FORM_E_RISCO_ALTO.data_nascimento = RECUSA_PROTOCOLO_2.data_nascimento 
   AND RECUSA_PROTOCOLO_2.ORDEM_OCORRENCIA = 1
WHERE 1=1
AND OCO.ocorrencia_uf = 'MG'            -- Restringe às ocorrências registradas em Minas Gerais
