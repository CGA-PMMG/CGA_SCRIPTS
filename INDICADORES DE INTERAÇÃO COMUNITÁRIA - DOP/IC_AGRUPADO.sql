/* ----------------------------------------------------------------------------------------------------------------------------------------------------=
 *  ====================================================================================================================================================
 *  ============================================================== INDICADORES IC  =====================================================================
 *  ====================================================================================================================================================
 * 
 * Este script agrupa os Indicadores de Manutenção de Rede de Proteção Preventiva (MRPP), Reuniões Comunitárias(RC), Reuniões Comunitárias Rurais (RCR),
 * Visitas Comunitárias Preventivas (VCP), Visitas Tranquilizadoras (VT) e Visitas Tranquilizadoras a Vítimas de Crimes Violentos (VTCV) para 
 * padronizar análises e dashboards.
 *-----------------------------------------------------------------------------------------------------------------------------------------------------*/
WITH
BASE AS (  -- Define a CTE para extrair informações de ocorrências com número do BO no histórico
  SELECT 
    oco.numero_ocorrencia,                  -- Seleciona o número da ocorrência
    oco.natureza_codigo,                    -- Seleciona o código da natureza da ocorrência
    oco.historico_ocorrencia,               -- Seleciona o texto completo do histórico da ocorrência
    CASE                                    -- Inicia lógica condicional para extrair código do BO no histórico
      WHEN oco.natureza_codigo IN ('A20000','A20001','A20028') THEN  -- Aplica somente para naturezas correspondentes ao VT e VT CV
        REGEXP_EXTRACT(oco.historico_ocorrencia, '([0-9]{4}-[0-9]{9}-[0-9]{3})', 0)  -- Extrai padrão numérico de BO (formato YYYY-NNNNNNNNN-NNN) do histórico
    END AS BO_HISTORICO                      -- Renomeia a coluna resultante como BO_HISTORICO
  FROM db_bisp_reds_reporting.tb_ocorrencia oco                    -- Define a tabela fonte como tb_ocorrencia com alias 'oco'
  WHERE 
    digitador_sigla_orgao = 'PM'            -- Filtra apenas ocorrências digitadas pela Polícia Militar 
    AND ocorrencia_uf = 'MG'                -- Filtra apenas ocorrências no estado de Minas Gerais ('MG')
    AND ind_estado IN ('F','R')             -- Filtra ocorrências com status Fechado ('F') ou Pendente de Recibo ('R')
    AND data_hora_fato >= '2024-01-01 00:00:00'  -- Filtra ocorrências a partir de 1º de janeiro de 2024
    AND historico_ocorrencia LIKE '%20__-%-00%'  -- Filtra históricos que contenham padrão indicando BO (ex: "20xx-xxxxxxx-00")
),
NATUREZAS AS (  -- Define CTE para validar naturezas específicas de ocorrência
  SELECT 
    numero_ocorrencia,                              -- Seleciona o número da ocorrência
    natureza_codigo,                                -- Seleciona o código da natureza da ocorrência
    complemento_natureza_descricao,                 -- Seleciona a descrição do complemento da natureza 
    complemento_natureza_codigo,                    -- Seleciona o código do complemento da natureza
    local_imediato_descricao,                       -- Seleciona a descrição do local imediato do fato
    local_imediato_codigo,                          -- Seleciona o código do local imediato
 CASE                                            -- Inicia lógica condicional para validar furtos em residência/comércio
      WHEN natureza_codigo = 'C01155'               -- Aplica apenas para natureza 'C01155' (furto de residência/comércio)
      AND (
        SUBSTRING(OCO.local_imediato_codigo, 1, 2) = '07'  -- Início de condição composta para filtrar local imediato, extraindo os dois primeiros caracteres do código, 07
			OR SUBSTRING(OCO.local_imediato_codigo, 1, 2) = '10'  -- Outra faixa  extraindo os dois primeiros caracteres do código,'10'  
			OR SUBSTRING(OCO.local_imediato_codigo, 1, 2) = '14'  -- Outra faixa  extraindo os dois primeiros caracteres do código,'14' 
			OR OCO.local_imediato_codigo IN ('1501','1502','1503','1599')  -- Verifica outros códigos específicos de locais imediatos 
			OR OCO.complemento_natureza_codigo IN ('2002','2003','2004','2005','2015')  -- Verifica códigos complementares para furto em residência/comércio
        ) THEN 'VALIDO' ELSE 'INVALIDO'             -- Atribui 'VALIDO' se as condições forem atendidas, caso contrário 'INVALIDO'
 END AS VALIDO_FURTO_RESIDCOM,                  -- Renomeia resultado como VALIDO_FURTO_RESIDCOM	
CASE                                           -- Inicia lógica condicional para validar crimes violentos (CV)
      WHEN natureza_codigo IN ('B01121','B01148','B02001','C01157','C01158','C01159','B01504')  -- Aplica para códigos específicos de crimes violentos
      THEN 'VALIDO' ELSE 'INVALIDO'                -- Atribui 'VALIDO' se a natureza for crime violento, caso contrário 'INVALIDO'
END AS VALIDO_CV                               -- Renomeia resultado como VALIDO_CV  
FROM db_bisp_reds_reporting.tb_ocorrencia OCO                          -- Define a tabela fonte como tb_ocorrencia com alias 'OCO'
WHERE 
    natureza_codigo IN ('C01155','B01121','B01148','B02001','C01157','C01158','C01159','B01504')  -- Filtra apenas naturezas de Furto e CV  
    AND digitador_sigla_orgao IN ('PM','PC')       -- Filtra registros digitados pela Polícia Militar ('PM') ou Polícia Civil ('PC')
    AND ocorrencia_uf = 'MG'                       -- Filtra ocorrências no estado de Minas Gerais
    AND ind_estado = 'F'                           -- Filtra apenas ocorrências fechadas
    AND data_hora_fato >= '2023-06-01'             -- Filtra ocorrências a partir de 1º de junho de 2023
),
FILTRO AS (  -- Define CTE para contar quantidade de envolvidos identificados por ocorrência
  SELECT 
    OCO.numero_ocorrencia,  -- Seleciona o número da ocorrência
    COUNT(
      CASE 
        WHEN ENV.numero_cpf_cnpj IS NOT NULL  -- Conta quando o CPF/CNPJ do envolvido não nulo
          OR (ENV.tipo_documento_codigo = '0801' AND ENV.numero_documento_id IS NOT NULL)  -- Ou quando o tipo de documento for RG não nulo
        THEN 1 
        ELSE NULL 
      END
    ) AS qtd_envolvidos_identificados  -- Soma a quantidade de envolvidos identificados por registro
  FROM db_bisp_reds_reporting.tb_ocorrencia OCO  -- Define a tabela de ocorrências com alias 'OCO'
  LEFT JOIN db_bisp_reds_reporting.tb_envolvido_ocorrencia ENV ON OCO.numero_ocorrencia = ENV.numero_ocorrencia  -- Faz join esquerdo com tabela de envolvidos para agregar informações
  WHERE 1=1  -- Condição sempre verdadeira para facilitar inclusão de múltiplos filtros
    AND OCO.data_hora_fato >= '2024-01-01 00:00:00.000'  -- Filtra ocorrências a partir de 1º de janeiro de 2024
    AND OCO.natureza_codigo IN ('A21000','A19000', 'A19001','A19004','A19099','A19006', 'A19007','A19008','A19009', 'A19010', 'A19011','A20000','A20001','A20028','A21007') -- Filtra por conjunto de naturezas específicas do IC : MRPP-> 'A19006', 'A19007','A19008','A19009', 'A19010', 'A19011'; RC -> 'A19000', 'A19001','A19004','A19099'; VCP -> 'A21000'; VT -> 'A20000'; VT CV -> 'A20001'.
    AND OCO.ocorrencia_uf = 'MG'  -- Filtra ocorrências no estado de Minas Gerais
    AND OCO.digitador_sigla_orgao = 'PM'  -- Filtra ocorrências digitadas pela Polícia Militar
    AND OCO.nome_tipo_relatorio IN ('BOS', 'BOS AMPLO')  -- Filtra apenas relatórios BOS e BOS AMPLO
    AND OCO.unidade_responsavel_registro_nome NOT LIKE '%IND PE%'  -- Exclui unidades com 'IND PE' no nome
    AND OCO.unidade_responsavel_registro_nome NOT LIKE '%PVD%'  -- Exclui unidades com 'PVD' no nome
    AND (
      OCO.unidade_responsavel_registro_nome NOT REGEXP '/[A-Za-z]'  -- Inclui apenas nomes de unidade que não contenham letras após '/'
      OR OCO.unidade_responsavel_registro_nome LIKE '%/PEL TM%'  -- Ou que contenham '/PEL TM' explicitamente
    )
    AND (
      OCO.unidade_responsavel_registro_nome REGEXP '^(SG|PEL|GP)'  -- Inclui somente unidades cujo nome começa com 'SG', 'PEL' ou 'GP'
      OR OCO.unidade_responsavel_registro_nome REGEXP '^[^A-Za-z]'  -- Ou que começam com caractere não alfabético
    )
    AND OCO.ind_estado IN ('F','R')  -- Filtra apenas ocorrências Fechadas ('F') ou Pendente de Recibo ('R')
  GROUP BY 1  -- Agrupa por número da ocorrência
)
SELECT
  F.numero_ocorrencia,                            -- Número da ocorrência vindo da CTE FILTRO
  F.qtd_envolvidos_identificados,                  -- Quantidade de envolvidos identificados, agregada na CTE FILTRO
  OCO.natureza_codigo,                             -- Código da natureza da ocorrência, da tabela principal
  OCO.natureza_descricao,                          -- Descrição da natureza da ocorrência, da tabela principal
  L.codigo_unidade_area,                           -- Código da unidade militar da área 
  L.unidade_area_militar_nome,                     -- Nome da unidade militar da área 
  OCO.unidade_responsavel_registro_codigo,         -- Código da unidade da unidade responsável pelo registro 
  OCO.unidade_responsavel_registro_nome,           -- Nome da unidade responsável pelo registro 
  SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM_REGISTRO,   -- Extrai parte após '/' como sigla RPM no registro
  SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -2) AS UEOP_REGISTRO,  -- Extrai parte antes de '/' como sigla UEOP no registro
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
    END AS RPM_2025_AREA,
CASE WHEN OCO.codigo_municipio in (310690,311590,311960,312130,312738,312850,314020,314950,315010,315540,315620,316290) THEN '02 BPM'
        WHEN OCO.codigo_municipio in (310240,311750,311810,312010,312100,312160,312260,312540,312550,312760,314250,314370,315330,316020,316050,316480,316590,316650,316710) THEN '03 BPM'
        WHEN OCO.codigo_municipio in (312125) THEN '04 BPM'
        WHEN OCO.codigo_municipio in (312770,310180,311265,312370,312580,313320,314995,316770,316840,310220,312690,314010,317150,316160,316300) THEN '06 BPM'
        WHEN OCO.codigo_municipio in (310020,310700,310740,311560,311980,312320,312470,313530,313720,313880,314050,314240,314350,314640,314890,315200,315370,316040,316660) THEN '07 BPM'
        WHEN OCO.codigo_municipio in (310080,310800,311120,311190,311200,311400,311450,311460,312020,313000,313040,313080,313430,313450,313820,313870,314460,314560,314770,314990,315060,315470,315880,315990,316120) THEN '08 BPM'
        WHEN OCO.codigo_municipio in (310163,310210,310290,310330,310560,310680,311630,312150,312500,312940,314570,314660,315030,315440,315730,315870,315940,316070) THEN '09 BPM'
        WHEN OCO.codigo_municipio in (314480,315390,315480) THEN '1 CIA PM IND'
        WHEN OCO.codigo_municipio in (310730,311650,311880,312380,312660,312735,312825,312960,313200,313680,313730,314545,316225,316265) THEN '10 BPM'
        WHEN OCO.codigo_municipio in (310370,311020,311170,311670,312400,314830,314880,316380,316850,317130) THEN '10 CIA PM IND'
        WHEN OCO.codigo_municipio in (310030,310205,311010,311210,311290,311600,312352,312420,313770,313867,313940,313950,314053,314090,314400,314875,315350,315415,315790,315890,316255,316630,316760,316360) THEN '11 BPM'
        WHEN OCO.codigo_municipio in (311250,314110,314930,315360) THEN '11 CIA PM IND'
        WHEN OCO.codigo_municipio in (310190,311240,311280,311510,311640,312120,312340,312970,313375,314790,315150,315290,316220,316294,316430,317060) THEN '12 BPM'
        WHEN OCO.codigo_municipio in (310860,311115,312965,313005,313535,313865,313868,315057,315213,316110,316240,317000,317090) THEN '13 CIA PM IND'
        WHEN OCO.codigo_municipio in (310050,310630,310880,313115,313130,313610,314170,314435,315895) THEN '14 BPM'
        WHEN OCO.codigo_municipio in (310340,311950,313400,314630,317160,311700,313330,314140,315217) THEN '70 BPM'
        WHEN OCO.codigo_municipio in (310380,311430,313710,313750,313753,314120,314800,315340,315550,316170,316210,316890,317075) THEN '15 BPM'
        WHEN OCO.codigo_municipio in (310110,311840,312083,312737,313410,315430,315950,316950) THEN '15 CIA PM IND'
        WHEN OCO.codigo_municipio in (311070,311090,311770,313590,313780,314550,316080,316520,316930,314260) THEN '16 CIA PM IND'
        WHEN OCO.codigo_municipio in (310230,310600,312180,312270,313620,314470,315570,316100,316340,316556) THEN '17 CIA PM IND'
        WHEN OCO.codigo_municipio in (311570,312210,312730,313180,313960,314150,314467,316105,316165,316257) THEN '18 CIA PM IND'
        WHEN OCO.codigo_municipio in (310470,311080,311300,311545,312675,312680,313230,313270,313507,313700,313920,314490,314530,314535,314620,314850,315000,315240,316330,316555,316860) THEN '19 BPM'
        WHEN OCO.codigo_municipio in (313020,313970,314580,314690,314710,314960,316310) THEN '19 CIA PM IND'
        WHEN OCO.codigo_municipio in (310665,312087,312707,313065,314345,314465,314537,314625,315560,315650,315700,315737,316045,316270,316800,317065) THEN '2 CIA PM IND'
        WHEN OCO.codigo_municipio in (310140,310830,310970,311360,311720,311780,311790,311900,312440,312450,312920,313060,313490,314340,314440,314600,315250,315960,316200,316230,316440,316580,316740,316905,316980) THEN '20 BPM'
        WHEN OCO.codigo_municipio in (310870,312190,312330,312840,312880,312900,314160,315130,315580,315630,316150,316570,316730,316790,316900,316990,317200) THEN '21 BPM'
        WHEN OCO.codigo_municipio in (310040,310250,310570,312820,313550,314585,315020,315210,315490,315500,315740,316010,316400,317050) THEN '21 CIA PM IND'
        WHEN OCO.codigo_municipio in (311420,311660,312230,316180) THEN '23 BPM'
        WHEN OCO.codigo_municipio in (310060,310285,310445,310650,311230,311350,311610,312650,313250,313545,313652,313835,314180,316970,317107) THEN '23 CIA PM IND'
        WHEN OCO.codigo_municipio in (310710,311390,311870,312360,312810,313050,315830,316940,317070) THEN '24 BPM'
        WHEN OCO.codigo_municipio in (310090,310660,311370,312015,312705,313890,314430,315765,316670,317030) THEN '24 CIA PM IND'
        WHEN OCO.codigo_municipio in (310320,310500,310960,310990,311890,312640,312720,313100,313570,314740,315850,316720) THEN '25 BPM'
        WHEN OCO.codigo_municipio in (311205,311680,311920,312220,312310,312695,312750,312800,313655,314060,314420,314840,314860,315600,315680,315750,315820,316280,316350,316410,316450,316550,316610,317180,317190) THEN '65 BPM'
        WHEN OCO.codigo_municipio in (310540,310770,311380,311535,312590,313170,313280,314750,315720,315800,316190) THEN '26 BPM'
        WHEN OCO.codigo_municipio in (310610,311620,313860,313980,314080,314540,314940,315590,315727,315860,315930,316560,316750) THEN '27 BPM'
        WHEN OCO.codigo_municipio in (310450,310820,310930,310945,311615,312247,312620,314437,315445,317040,317047,317052) THEN '28 BPM'
        WHEN OCO.codigo_municipio in (310260,310530,310840,310950,311030,311100,312240,312990,313150,315180,315920) THEN '29 BPM'
        WHEN OCO.codigo_municipio in (311110,311455,313440,313862,317043) THEN '3 CIA PM IND'
        WHEN OCO.codigo_municipio in (310825,311783,313210,313520,313695,313930,314225,314270,314915,316245) THEN '30 BPM'
        WHEN OCO.codigo_municipio in (310640,311220,311310,311320,311490,311540,311800,311830,312040,312140,312390,313390,313540,313790,314230,314590,315080,315230,315310,315380,315520,315910,316090,316600) THEN '31 BPM'
        WHEN OCO.codigo_municipio in (315780) THEN '35 BPM'
        WHEN OCO.codigo_municipio in (316295,317120) THEN '36 BPM'
        WHEN OCO.codigo_municipio in (313760,311787,315900,313460) THEN '8 CIA PM IND'
        WHEN OCO.codigo_municipio in (310400,311150,311820,312950,314500,314920,314980,315300,315690,315770,315970,316810) THEN '37 BPM'
        WHEN OCO.codigo_municipio in (310280,310360,310590,310750,311520,311970,312300,313740,313910,314450,315270,315420,315610,315733,316250,316500,316530,316880) THEN '38 BPM'
        WHEN OCO.codigo_municipio in (311690,312700,312710,313340,315160,316130,311140,311730,315070) THEN '69 BPM'
        WHEN OCO.codigo_municipio in (315460) THEN '40 BPM'
        WHEN OCO.codigo_municipio in (310480,310920,311910,312090,312570,313110,313640,314360,315320,316060,316935) THEN '42 BPM'
        WHEN OCO.codigo_municipio in (310410,310760,312830,312870,313290,313690,314300,314320,314410,314510,316390,316470,316510,312630,313480) THEN '43 BPM'
        WHEN OCO.codigo_municipio in (310170,310520,312245,312560,313470,313580,313600,313650,314055,314315,314675,315510,315660,315710,315810,316030,310100,310270,312235,314870) THEN '44 BPM'
        WHEN OCO.codigo_municipio in (310855,312860,313630,314700,317100) THEN '45 BPM'
        WHEN OCO.codigo_municipio in (310010,311930,312070,312350,312890,313160,314310,314810,315640,316680) THEN '46 BPM'
        WHEN OCO.codigo_municipio in (310310,310550,311330,312200,312490,312530,312595,313800,314210,314390,314587,314670,314820,314900,315645,316140,316920,317140) THEN '47 BPM'
        WHEN OCO.codigo_municipio in (310900,312980,314015,316553) THEN '48 BPM'
        WHEN OCO.codigo_municipio in (310850,311270,312030,312670,312780,313657,314200,314795 ) THEN '50 BPM'
        WHEN OCO.codigo_municipio in (311547,312430,312733,313505,313510,313925,314100,314290,314505,314655,315220,315450,316695,317103,314085) THEN '51 BPM'
        WHEN OCO.codigo_municipio in (312170,313190,314000,314610) THEN '52 BPM'
        WHEN OCO.codigo_municipio in (310350,310375,311500,312480,312790,313070,316960) THEN '53 BPM'
        WHEN OCO.codigo_municipio in (310980,311180,311260,311580,312910,313140,313420,314280,315280,315980) THEN '54 BPM'
        WHEN OCO.codigo_municipio in (310940,313560,313810,315120,315760,316420,317080) THEN '55 BPM'
        WHEN OCO.codigo_municipio in (310890,311850,312050,312110,312740,313240,313990,314040,314730,314910,315090,315100,316320,316540,317220) THEN '56 BPM'
        WHEN OCO.codigo_municipio in (310120,310130,310490,310720,311410,311480,311550,312080,312280,313300,313310,313850,314190,314760,314780,315260,316370,316490,316640,316700,316780,317170) THEN '57 BPM'
        WHEN OCO.codigo_municipio in (310300,311940,313500,314030,316870) THEN '58 BPM'
        WHEN OCO.codigo_municipio in (310790,311050,311060,311990,312510,313360,316557,316910,310910,314380) THEN '59 BPM'
        WHEN OCO.codigo_municipio in (310390,311760,313830,314520,314970,315140) THEN '60 BPM'
        WHEN OCO.codigo_municipio in (311000,313660,315670,316830) THEN '61 BPM'
        WHEN OCO.codigo_municipio in (310780,311340,311740,312000,312250,312385,313055,313090,313120,315015,315053,315190,315400,315725,315935,316095,316260,316447,316805,317005,317057,317115,310925,312930) THEN '62 BPM'
        WHEN OCO.codigo_municipio in (310420,310510,311040,311995,312610,313030,313350,314130,314650,315050,316460,316820) THEN '63 BPM'
        WHEN OCO.codigo_municipio in (310160,310200,310430,311130,311160,311440,311470,311710,312520,313900,314720,315170,316690) THEN '64 BPM'
        WHEN OCO.codigo_municipio in (312410) THEN '6 CIA PM IND'
        WHEN OCO.codigo_municipio in (310070,317110) THEN '67 BPM'
        WHEN OCO.codigo_municipio in (310810,312060,312600,313010,313220,313665,314070,315040,315530,316292) THEN '7 CIA PM IND'
        WHEN OCO.codigo_municipio in (310440,310460,311530,312290,313260,313840,314220,315410,315840,316443,315110,317210,310150,316000,312460) THEN '68 BPM'
        WHEN OCO.codigo_municipio in (313370,313380) THEN '9 CIA PM IND'
        WHEN OCO.codigo_municipio =317020 AND (L.unidade_area_militar_nome like '32 BPM%' or L.unidade_area_militar_nome like '%/32 BPM%') THEN '32 BPM'
        WHEN OCO.codigo_municipio =317020 AND (L.unidade_area_militar_nome like '17 BPM%' or L.unidade_area_militar_nome like '%/17 BPM%') THEN '17 BPM'
        WHEN OCO.codigo_municipio =317010 AND (L.unidade_area_militar_nome like '4 BPM%' or L.unidade_area_militar_nome like '%/4 BPM%') THEN '04 BPM'
        WHEN OCO.codigo_municipio =317010 AND (L.unidade_area_militar_nome like '67 BPM%' or L.unidade_area_militar_nome like '%/67 BPM%') THEN '67 BPM'
        WHEN OCO.codigo_municipio =314330 AND (L.unidade_area_militar_nome like '50 BPM%' or L.unidade_area_militar_nome like '%/50 BPM%') THEN '50 BPM'
        WHEN OCO.codigo_municipio =314330 AND (L.unidade_area_militar_nome like '10 BPM%' or L.unidade_area_militar_nome like '%/10 BPM%') THEN '10 BPM'
        WHEN OCO.codigo_municipio =313670 AND (L.unidade_area_militar_nome like '27 BPM%' or L.unidade_area_militar_nome like '%/27 BPM%') THEN '27 BPM'
        WHEN OCO.codigo_municipio =313670 AND (L.unidade_area_militar_nome like '2 BPM%' or L.unidade_area_militar_nome like '%/2 BPM%') THEN '02 BPM'
        WHEN OCO.codigo_municipio =311860 AND (L.unidade_area_militar_nome like '39 BPM%' or L.unidade_area_militar_nome like '%/39 BPM%') THEN '39 BPM'
        WHEN OCO.codigo_municipio =311860 AND (L.unidade_area_militar_nome like '18 BPM%' or L.unidade_area_militar_nome like '%/18 BPM%') THEN '18 BPM'
        WHEN OCO.codigo_municipio =310670 AND (L.unidade_area_militar_nome like '66 BPM%' or L.unidade_area_militar_nome like '%/66 BPM%') THEN '66 BPM'
        WHEN OCO.codigo_municipio =310670 AND (L.unidade_area_militar_nome like '33 BPM%' or L.unidade_area_militar_nome like '%/33 BPM%') THEN '33 BPM'
        WHEN OCO.codigo_municipio =310620 AND (L.unidade_area_militar_nome like '1 BPM%' or L.unidade_area_militar_nome like '%/1 BPM%') THEN '01 BPM'
        WHEN OCO.codigo_municipio =310620 AND (L.unidade_area_militar_nome like '5 BPM%' or L.unidade_area_militar_nome like '%/5 BPM%')  THEN '05 BPM'
        WHEN OCO.codigo_municipio =310620 AND (L.unidade_area_militar_nome like '13 BPM%' or L.unidade_area_militar_nome like '%/13 BPM%')  THEN '13 BPM'
        WHEN OCO.codigo_municipio =310620 AND (L.unidade_area_militar_nome like '16 BPM%' or L.unidade_area_militar_nome like '%/16 BPM%')  THEN '16 BPM'
        WHEN OCO.codigo_municipio =310620 AND (L.unidade_area_militar_nome like '22 BPM%' or L.unidade_area_militar_nome like '%/22 BPM%' )  THEN '22 BPM'
        WHEN OCO.codigo_municipio =310620 AND (L.unidade_area_militar_nome like '41 BPM%' or L.unidade_area_militar_nome like '%/41 BPM%') THEN '41 BPM'
        WHEN OCO.codigo_municipio =310620 AND (L.unidade_area_militar_nome like '49 BPM%' or L.unidade_area_militar_nome like '%/49 BPM%') THEN '49 BPM'
        WHEN OCO.codigo_municipio =310620 AND (L.unidade_area_militar_nome like '34 BPM%' or L.unidade_area_militar_nome like '%/34 BPM%') THEN '34 BPM'
        WHEN OCO.codigo_municipio =316620 AND (L.unidade_area_militar_nome like '31 BPM%' or L.unidade_area_militar_nome like '%/31 BPM%') THEN '31 BPM'
        WHEN OCO.codigo_municipio =316620 AND (L.unidade_area_militar_nome like '9 BPM%' or L.unidade_area_militar_nome like '%/9 BPM%') THEN '09 BPM'
        ELSE 'OUTROS'
    END AS UEOP_2025_AREA,
  CAST(OCO.codigo_municipio AS INTEGER),           -- Converte o código do município para tipo inteiro
  OCO.nome_municipio,                              -- Nome do município do fato
  OCO.tipo_logradouro_descricao,                   -- Descrição do tipo de logradouro 
  OCO.logradouro_nome,                             -- Nome do logradouro onde ocorreu o fato
  OCO.numero_endereco,                             -- Número do endereço
  OCO.nome_bairro,                                 -- Nome do bairro
  OCO.ocorrencia_uf,                               -- Unidade federativa (UF) da ocorrência
  OCO.numero_latitude,                             -- Latitude do local da ocorrência 
  OCO.numero_longitude,                            -- Longitude do local da ocorrência 
  REPLACE(CAST(OCO.numero_latitude AS STRING), '.', ',') AS local_latitude_formatado,  -- Formata latitude para representação com vírgula decimal
  REPLACE(CAST(OCO.numero_longitude AS STRING), '.', ',') AS local_longitude_formatado, -- Formata longitude para representação com vírgula decimal
  CONCAT(
    CAST(OCO.numero_latitude AS STRING),
    CAST(OCO.numero_longitude AS STRING)
  ) AS CHAVE_LATLONG,                              -- Concatena latitude e longitude em uma chave única
  geo.latitude_sirgas2000,                         -- Latitude SIRGAS2000 (tabela geo)
  geo.longitude_sirgas2000,                        -- Longitude SIRGAS2000 (tabela geo)
  CASE                                            -- Inicia lógica condicional para atribuir código do setor censitário
    WHEN OCO.ocorrencia_uf <> 'MG' THEN 'Outra_UF'  -- Se UF não for MG, atribui 'Outra_UF'
    ELSE geo.setor_codigo                           -- Caso contrário, utiliza o código de setor do IBGE a partir da tabela geo
  END AS setor_codigo,                              -- Renomeia resultado como setor_codigo
  CASE                                            -- Inicia lógica condicional para determinar se o ponto é urbano ou rural
    WHEN OCO.pais_codigo <> 1 AND OCO.ocorrencia_uf IS NULL THEN 'Outro_Pais'  -- Se país diferente de Brasil ou UF nulo, atribui 'Outro_Pais'
    WHEN OCO.ocorrencia_uf <> 'MG' THEN 'Outra_UF'  -- Se UF não for MG, atribui 'Outra_UF'
    WHEN OCO.numero_latitude IS NULL THEN 'Invalido'  -- Se não houver latitude, atribui 'Invalido'
    WHEN geo.situacao_codigo = 9 THEN 'Agua'         -- Se código de situação for 9, atribui 'Agua'
    WHEN geo.situacao_zona IS NULL THEN 'Erro_Processamento'  -- Se situação de zona nulo, atribui 'Erro_Processamento'
    ELSE geo.situacao_zona                           -- Caso contrário, utiliza a situação da zona (Urbano ou Rural)
  END AS situacao_zona,                             -- Renomeia resultado como situacao_zona
  ibge.tipo_descricao,                              -- Informações adicionais do IBGE 
  OCO.unidade_area_militar_nome,                    -- Nome da unidade da área militar 
  MUB.udi,                                          
  MUB.ueop,                                         
  MUB.cia,                                          
  MUB.codigo_espacial_pm AS setor_PM,              
  OCO.data_hora_fato,                               -- Data e hora do fato 
  YEAR(OCO.data_hora_fato) AS ano,                  -- Extrai o ano da data do fato
  MONTH(OCO.data_hora_fato) AS mes,                 -- Extrai o mês da data do fato
  OCO.nome_tipo_relatorio,                          -- Tipo do relatório 
  OCO.digitador_sigla_orgao,                        -- Sigla do órgão que digitou a ocorrência 
  BASE.BO_HISTORICO,                                -- BO extraído do histórico na CTE BASE
  N.natureza_codigo,                                -- Código da natureza da CTE NATUREZAS
  N.complemento_natureza_descricao,                 -- Descrição do complemento da natureza (CTE NATUREZAS)
  N.complemento_natureza_codigo,                    -- Código do complemento da natureza (CTE NATUREZAS)
  N.local_imediato_descricao,                       -- Descrição do local imediato (CTE NATUREZAS)
  N.local_imediato_codigo,                          -- Código do local imediato (CTE NATUREZAS)
  N.VALIDO_FURTO_RESIDCOM,                          -- Indicador de validade para furto de residência/comércio (CTE NATUREZAS)
CASE 
	WHEN OCO.natureza_codigo = 'A21000' AND OCO.data_hora_fato BETWEEN '2025-01-01' AND '2025-07-31' AND qtd_envolvidos_identificados >= 1 THEN 1
	WHEN OCO.natureza_codigo = 'A21007' AND qtd_envolvidos_identificados >= 1 THEN 1 ELSE 0
END AS VCP_TOTAL,    -- Atribui 1 se condição atendida, caso contrário 0
CASE                                            -- Inicia cálculo de indicador RC_TOTAL 
    WHEN OCO.natureza_codigo IN ('A19000', 'A19001','A19004','A19099')  -- Naturezas correspondentes a RC
      AND qtd_envolvidos_identificados >= 3  -- Exige pelo menos três envolvidos identificados
    THEN 1 
    ELSE 0 
END AS RC_TOTAL,   -- Atribui 1 se condição atendida, caso contrário 0
CASE                                      -- Inicia cálculo de indicador RCR_TOTAL 
    WHEN OCO.natureza_codigo IN ('A19000', 'A19001','A19004','A19099')  -- Naturezas correspondentes a RCR
      AND qtd_envolvidos_identificados >= 3  -- Exige pelo menos três envolvidos identificados
      AND UPPER(geo.situacao_zona) = 'RURAL' -- A situação da zona deve ser igual a RURAL
    THEN 1 
    ELSE 0 
END AS RCR_TOTAL,   -- Atribui 1 se condição atendida, caso contrário 0
CASE                                            -- Inicia cálculo de indicador MRPP_TOTAL (Menores em Roubos e Outras Condutas)
    WHEN OCO.natureza_codigo IN ('A19006', 'A19007','A19008','A19009', 'A19010', 'A19011')  -- Naturezas específicas a MRPP
      AND qtd_envolvidos_identificados >= 3  -- Exige pelo menos três envolvidos identificados
    THEN 1 
    ELSE 0 
END AS MRPP_TOTAL,      -- Atribui 1 se condição atendida, caso contrário 0
 CASE 
		WHEN OCO.natureza_codigo = 'A20000' 
			AND OCO.data_hora_fato BETWEEN '2025-01-01' AND '2025-07-31' 
			AND qtd_envolvidos_identificados >= 1  
			AND VALIDO_FURTO_RESIDCOM = 'VALIDO' THEN 1
		WHEN OCO.natureza_codigo = 'A20028' 
			AND qtd_envolvidos_identificados >= 1  
			AND VALIDO_FURTO_RESIDCOM = 'VALIDO' THEN 1 ELSE 0
 END AS VT_TOTAL,      -- Atribui 1 se condição atendida, caso contrário 0
  CASE    -- Inicia cálculo de indicador VTCV_TOTAL 
    WHEN OCO.natureza_codigo = 'A20001'  -- Natureza correspondente a VT CV 
      AND qtd_envolvidos_identificados >= 1  -- Exige pelo menos um envolvido identificado
      AND VALIDO_CV = 'VALIDO'  -- Exige que o crime violento seja validado pela CTE NATUREZAS
    THEN 1 
    ELSE 0 
  END AS VTCV_TOTAL   -- Atribui 1 se condição atendida, caso contrário 0
FROM FILTRO F     -- Faz join com a CTE FILTRO para obter ocorrências qualificadas
INNER JOIN db_bisp_reds_reporting.tb_ocorrencia OCO ON F.numero_ocorrencia = OCO.numero_ocorrencia  -- Relaciona ocorrências filtradas com tabela principal
LEFT JOIN db_bisp_reds_master.tb_local_unidade_area_pmmg L ON OCO.id_local = L.id_local  -- Join esquerdo com tabela de unidades PMMG 
LEFT JOIN BASE ON BASE.numero_ocorrencia = F.numero_ocorrencia  -- Join esquerdo com CTE BASE para obter BO_HISTORICO
LEFT JOIN NATUREZAS N ON N.numero_ocorrencia = BASE.BO_HISTORICO  -- Join esquerdo com CTE NATUREZAS usando BO_HISTORICO correspondente
LEFT JOIN
    db_bisp_reds_master.tb_ocorrencia_setores_geodata AS geo  -- Join esquerdo com tabela de setores georreferenciados (IBGE)
    ON OCO.numero_ocorrencia = geo.numero_ocorrencia
    AND OCO.ocorrencia_uf = 'MG'  -- Garante que apenas registros de MG sejam considerados nesta junção
LEFT JOIN
    db_bisp_shared.tb_ibge_setores_geodata AS ibge  -- Join esquerdo com tabela de dados IBGE enriquecidos 
    ON geo.setor_codigo = ibge.setor_codigo
LEFT JOIN
    db_bisp_shared.tb_pmmg_setores_geodata AS MUB  -- Join esquerdo com tabela MUB 
    ON geo.setor_codigo = MUB.setor_codigo
--WHERE 1 = 1
--AND OCO.unidade_responsavel_registro_nome LIKE '%x BPM/x RPM%'   -- FILTRE PELO NOME DA UNIDADE RESPONSÁVEL PELO REGISTRO 
;
