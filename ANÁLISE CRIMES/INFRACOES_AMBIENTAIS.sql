/*------------------------------------------------------------------------------------------------------------------------------------
 * Este código SQL tem como objetivo extrair e consolidar informações sobre ocorrências ambientais registradas 
 * nos período espeficicado, com foco em infrações classificadas por categorias como fauna, flora, pesca, recursos hídricos e poluição.
 * 
 * Contribuição: Thiago Jardim de Castro, 3º Sgt PM
 ------------------------------------------------------------------------------------------------------------------------------------*/
SELECT 
    oco.numero_ocorrencia, -- Seleciona o número da ocorrência
    YEAR(oco.data_hora_fato) AS Ano, -- Extrai o ano da data/hora do fato e atribui o alias 'Ano'
    MONTH(oco.data_hora_fato) AS Mes, -- Extrai o mês da data/hora do fato e atribui o alias 'Mês'
    oco.data_hora_fato, -- Seleciona a data/hora do fato completo
    CAST(oco.data_hora_fato AS DATE) AS data_ocorrencia, -- Converte a data/hora para apenas a data, com alias 'data_ocorrência'
    oco.codigo_municipio, -- Seleciona o código do município
    oco.nome_municipio, -- Seleciona o nome do município
    oco.unidade_responsavel_registro_nome, -- Seleciona o nome da unidade responsável pelo registro
    oco.natureza_codigo, -- Seleciona o código da natureza da ocorrência
    oco.natureza_descricao, -- Seleciona a descrição da natureza da ocorrência
    CASE -- Início da lógica condicional para classificar a natureza das infrações
        WHEN oco.natureza_codigo IN ( -- Se o código de natureza estiver entre os listados, classifica como 'FAUNA'
           'M31599', 'M31538', 'M31537', 'M31536', 'M31535', 'M31534', 'M31533', 'M31532', 'M31531', 'M31530',
            'M31529', 'M31528', 'M31527', 'M31526', 'M31525', 'M31524', 'M31523', 'M31522', 'M31521', 'M31520',
            'M31519', 'M31518', 'M31517', 'M31516', 'M31515', 'M31514', 'M31513', 'M31512', 'M31511', 'M31510',
            'M31509', 'M31508', 'M31507', 'M31506', 'M31505', 'M31504', 'M31503', 'M31502', 'M31501', 'M30999'
        ) THEN 'FAUNA' -- Atribui 'FAUNA' como categoria
        WHEN oco.natureza_codigo IN ( -- Se o código de natureza estiver entre os listados, classifica como 'FLORA'
			'N32301', 'N32302', 'N32303', 'N32304', 'N32305', 'N32306', 'N32307', 'N32308', 'N32309', 'N32310',
            'N32311', 'N32312', 'N32313', 'N32314', 'N32315', 'N32316', 'N32317', 'N32318', 'N32319', 'N32320',
            'N32321', 'N32322', 'N32323', 'N32324', 'N32325', 'N32326', 'N32327', 'N32328', 'N32329', 'N32330',
            'N32331', 'N32332', 'N32333', 'N32334', 'N32335', 'N32336', 'N32337', 'N32338', 'N32339', 'N32340',
            'N32341', 'N32342', 'N32343', 'N32344', 'N32345', 'N32346', 'N32347', 'N32348', 'N32349', 'N32350',
            'N32351', 'N32352', 'N32353', 'N32354', 'N32355', 'N31399', 'N31351', 'N31352', 'N31353', 'N31354',
            'N31355', 'N31350', 'N31349', 'N31348', 'N31347', 'N31346', 'N31345', 'N31344', 'N31343', 'N31342',
            'N31355', 'N31350', 'N31349', 'N31348', 'N31347', 'N31346', 'N31345', 'N31344', 'N31343', 'N31342',
            'N31340', 'N31339', 'N31338', 'N31337', 'N31336', 'N31335', 'N31334', 'N31333', 'N31332', 'N31331',
            'N31330', 'N31329', 'N31328', 'N31327', 'N31326', 'N31325', 'N31324', 'N31323', 'N31322', 'N31321',
            'N31320', 'N31319', 'N31318', 'N31317', 'N31316', 'N31315', 'N31314', 'N31313', 'N31312', 'N31311',
            'N31310', 'N31309', 'N31308', 'N31307', 'N31306', 'N31305', 'N31304', 'N31303', 'N31301'
        ) THEN 'FLORA' -- Atribui 'FLORA' como categoria
        WHEN oco.natureza_codigo IN ( -- Se o código de natureza estiver entre os listados, classifica como 'PESCA'
			'M32499', 'M32445', 'M32444', 'M32443', 'M32442', 'M32441', 'M32440', 'M32438', 'M32437', 'M32436',
            'M32435', 'M32434', 'M32432', 'M32431', 'M32430', 'M32429', 'M32428', 'M32427', 'M32426', 'M32425',
            'M32424', 'M32423', 'M32422', 'M32421', 'M32420', 'M32419', 'M32417', 'M32416', 'M32415', 'M32414',
            'M32413', 'M32412', 'M32411', 'M32410', 'M32409', 'M32408', 'M32407', 'M32406', 'M32405', 'M32404',
            'M32403', 'M32402', 'M32401', 'M31499', 'M31445', 'M31444', 'M31443', 'M31442', 'M31441', 'M31440',
            'M31439', 'M31438', 'M31437', 'M31436', 'M31435', 'M31434', 'M31433', 'M31432', 'M31431', 'M31430',
            'M31429', 'M31428', 'M31427', 'M31426', 'M31425', 'M31424', 'M31423', 'M31422', 'M31421', 'M31420',
            'M31419', 'M31418', 'M31417', 'M31416', 'M31415', 'M31414', 'M31413', 'M31412', 'M31411', 'M31410',
            'M31409', 'M31408', 'M31407', 'M31406', 'M31405', 'M31404', 'M31403', 'M31402', 'M31401'            
        ) THEN 'PESCA' -- Atribui 'PESCA' como categoria
        WHEN oco.natureza_codigo IN ( -- Se o código de natureza estiver entre os listados, classifica como 'RECURSOS HIDRICOS'
			'L32299', 'L32236', 'L32235', 'L32234', 'L32233', 'L32232', 'L32231', 'L32230', 'L32229', 'L32228',
            'L32227', 'L32226', 'L32225', 'L32224', 'L32223', 'L32222', 'L32221', 'L32220', 'L32219', 'L32218',
            'L32217', 'L32216', 'L32215', 'L32214', 'L32213', 'L32212', 'L32211', 'L32210', 'L32209', 'L32208',
            'L32207', 'L32206', 'L32205', 'L32204', 'L32203', 'L32202', 'L32201', 'L31299', 'L31236', 'L31235',
            'L31234', 'L31233', 'L31232', 'L31231', 'L31230', 'L31229', 'L31228', 'L31227', 'L31226', 'L31225',
            'L31224', 'L31223', 'L31222', 'L31221', 'L31220', 'L31219', 'L31218', 'L31217', 'L31216', 'L31215',
            'L31214', 'L31213', 'L31212', 'L31211', 'L31210', 'L31209', 'L31208', 'L31207', 'L31206', 'L31205',
            'L31204', 'L31203', 'L31202', 'L31201'
        ) THEN 'RECURSOS HIDRICOS' -- Atribui 'RECURSOS HIDRICOS' como categoria
        WHEN oco.natureza_codigo IN ( -- Se o código de natureza estiver entre os listados, classifica como 'POLUICAO'
           'L31199', 'L32199', 'L32135', 'L32134', 'L32133', 'L32132', 'L32131', 'L32130', 'L32129', 'L32128',
            'L32127', 'L32126', 'L32125', 'L32124', 'L32123', 'L32122', 'L32121', 'L32120', 'L32119', 'L32118',
            'L32117', 'L32116', 'L32115', 'L32114', 'L32113', 'L32112', 'L32111', 'L32110', 'L32109', 'L32108',
            'L32107', 'L32106', 'L32105', 'L32104', 'L32103', 'L32102', 'L31135', 'L31134', 'L31133', 'L32101',
            'L31132', 'L31131', 'L31130', 'L31129', 'L31128', 'L31114', 'L31113', 'L31127', 'L31126', 'L31125',
            'L31123', 'L31124', 'L31122', 'L31121', 'L31120', 'L31119', 'L31118', 'L31117', 'L31116', 'L31115',
            'L31112', 'L31111', 'L31110', 'L31109', 'L31108', 'L31107', 'L31106', 'L31105', 'L31104', 'L31103', 'L31102', 'L31101'        
            ) THEN 'POLUICAO' -- Atribui 'POLUICAO' como categoria
        ELSE 'OUTROS' -- Se não se enquadrar em nenhuma das condições anteriores, classifica como 'OUTROS'
    END AS 'INFRACOES_AMBIENTAIS' -- Define a coluna resultante com o nome 'INFRACOES_AMBIENTAIS'
FROM 
    db_bisp_reds_reporting.tb_ocorrencia oco -- Seleciona os dados da tabela 'tb_ocorrencia' do banco 'db_bisp_reds_reporting'
WHERE
    YEAR(oco.data_hora_fato) IN (2023, 2024) -- Filtra ano da data/hora
       AND oco.natureza_codigo IN (
       'L31199', 'L32199', 'L32135', 'L32134', 'L32133', 'L32132', 'L32131', 'L32130', 'L32129', 'L32128', --INFRAÇÕES RELATIVO A POLUIÇÃO
        'L32127', 'L32126', 'L32125', 'L32124', 'L32123', 'L32122', 'L32121', 'L32120', 'L32119', 'L32118', --INFRAÇÕES RELATIVO A POLUIÇÃO
        'L32117', 'L32116', 'L32115', 'L32114', 'L32113', 'L32112', 'L32111', 'L32110', 'L32109', 'L32108', --INFRAÇÕES RELATIVO A POLUIÇÃO
        'L32107', 'L32106', 'L32105', 'L32104', 'L32103', 'L32102', 'L31135', 'L31134', 'L31133', 'L32101', --INFRAÇÕES RELATIVO A POLUIÇÃO
        'L31132', 'L31131', 'L31130', 'L31129', 'L31128', 'L31114', 'L31113', 'L31127', 'L31126', 'L31125', --INFRAÇÕES RELATIVO A POLUIÇÃO
        'L31123', 'L31124', 'L31122', 'L31121', 'L31120', 'L31119', 'L31118', 'L31117', 'L31116', 'L31115', --INFRAÇÕES RELATIVO A POLUIÇÃO
        'L31112', 'L31111', 'L31110', 'L31109', 'L31108', 'L31107', 'L31106', 'L31105', 'L31104', 'L31103', --INFRAÇÕES RELATIVO A POLUIÇÃO
        'L31102', 'L31101', --INFRAÇÕES RELATIVO A POLUIÇÃO
        'L32299', 'L32236', 'L32235', 'L32234', 'L32233', 'L32232', 'L32231', 'L32230', 'L32229', 'L32228', --INFRAÇÕES RELATIVO A RECURSOS HIDRICOS
        'L32227', 'L32226', 'L32225', 'L32224', 'L32223', 'L32222', 'L32221', 'L32220', 'L32219', 'L32218', --INFRAÇÕES RELATIVO A RECURSOS HIDRICOS
        'L32217', 'L32216', 'L32215', 'L32214', 'L32213', 'L32212', 'L32211', 'L32210', 'L32209', 'L32208', --INFRAÇÕES RELATIVO A RECURSOS HIDRICOS        
        'L32207', 'L32206', 'L32205', 'L32204', 'L32203', 'L32202', 'L32201', 'L31299', 'L31236', 'L31235', --INFRAÇÕES RELATIVO A RECURSOS HIDRICOS        
        'L31234', 'L31233', 'L31232', 'L31231', 'L31230', 'L31229', 'L31228', 'L31227', 'L31226', 'L31225', --INFRAÇÕES RELATIVO A RECURSOS HIDRICOS        
        'L31224', 'L31223', 'L31222', 'L31221', 'L31220', 'L31219', 'L31218', 'L31217', 'L31216', 'L31215', --INFRAÇÕES RELATIVO A RECURSOS HIDRICOS       
        'L31214', 'L31213', 'L31212', 'L31211', 'L31210', 'L31209', 'L31208', 'L31207', 'L31206', 'L31205', --INFRAÇÕES RELATIVO A RECURSOS HIDRICOS        
        'L31204', 'L31203', 'L31202', 'L31201', --INFRAÇÕES RELATIVO A RECURSOS HIDRICOS             
        'M32499', 'M32445', 'M32444', 'M32443', 'M32442', 'M32441', 'M32440', 'M32438', 'M32437', 'M32436', --INFRAÇÕES AMBIENTAIS RELATIVOS A PESCA 
        'M32435', 'M32434', 'M32432', 'M32431', 'M32430', 'M32429', 'M32428', 'M32427', 'M32426', 'M32425', --INFRAÇÕES AMBIENTAIS RELATIVOS A PESCA 
        'M32424', 'M32423', 'M32422', 'M32421', 'M32420', 'M32419', 'M32417', 'M32416', 'M32415', 'M32414', --INFRAÇÕES AMBIENTAIS RELATIVOS A PESCA 
        'M32413', 'M32412', 'M32411', 'M32410', 'M32409', 'M32408', 'M32407', 'M32406', 'M32405', 'M32404', --INFRAÇÕES AMBIENTAIS RELATIVOS A PESCA 
        'M32403', 'M32402', 'M32401', 'M31499', 'M31445', 'M31444', 'M31443', 'M31442', 'M31441', 'M31440', --INFRAÇÕES AMBIENTAIS RELATIVOS A PESCA 
        'M31439', 'M31438', 'M31437', 'M31436', 'M31435', 'M31434', 'M31433', 'M31432', 'M31431', 'M31430', --INFRAÇÕES AMBIENTAIS RELATIVOS A PESCA 
        'M31429', 'M31428', 'M31427', 'M31426', 'M31425', 'M31424', 'M31423', 'M31422', 'M31421', 'M31420', --INFRAÇÕES AMBIENTAIS RELATIVOS A PESCA 
        'M31419', 'M31418', 'M31417', 'M31416', 'M31415', 'M31414', 'M31413', 'M31412', 'M31411', 'M31410', --INFRAÇÕES AMBIENTAIS RELATIVOS A PESCA 
        'M31409', 'M31408', 'M31407', 'M31406', 'M31405', 'M31404', 'M31403', 'M31402', 'M31401', --INFRAÇÕES AMBIENTAIS RELATIVOS A PESCA         
        'M31599', 'M31538', 'M31537', 'M31536', 'M31535', 'M31534', 'M31533', 'M31532', 'M31531', 'M31530', --INFRAÇÕES AMBIENTAIS RELATIVOS A FAUNA
        'M31529', 'M31528', 'M31527', 'M31526', 'M31525', 'M31524', 'M31523', 'M31522', 'M31521', 'M31520', --INFRAÇÕES AMBIENTAIS RELATIVOS A FAUNA
        'M31519', 'M31518', 'M31517', 'M31516', 'M31515', 'M31514', 'M31513', 'M31512', 'M31511', 'M31510', --INFRAÇÕES AMBIENTAIS RELATIVOS A FAUNA
        'M31509', 'M31508', 'M31507', 'M31506', 'M31505', 'M31504', 'M31503', 'M31502', 'M31501', 'M30999', --INFRAÇÕES AMBIENTAIS RELATIVOS A FAUNA                
        'N32301', 'N32302', 'N32303', 'N32304', 'N32305', 'N32306', 'N32307', 'N32308', 'N32309', 'N32310', --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA 
        'N32311', 'N32312', 'N32313', 'N32314', 'N32315', 'N32316', 'N32317', 'N32318', 'N32319', 'N32320', --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA
        'N32321', 'N32322', 'N32323', 'N32324', 'N32325', 'N32326', 'N32327', 'N32328', 'N32329', 'N32330', --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA
        'N32331', 'N32332', 'N32333', 'N32334', 'N32335', 'N32336', 'N32337', 'N32338', 'N32339', 'N32340', --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA
        'N32341', 'N32342', 'N32343', 'N32344', 'N32345', 'N32346', 'N32347', 'N32348', 'N32349', 'N32350', --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA
        'N32351', 'N32352', 'N32353', 'N32354', 'N32355', 'N31399', 'N31351', 'N31352', 'N31353', 'N31354', --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA
        'N31355', 'N31350', 'N31349', 'N31348', 'N31347', 'N31346', 'N31345', 'N31344', 'N31343', 'N31342', --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA
        'N31355', 'N31350', 'N31349', 'N31348', 'N31347', 'N31346', 'N31345', 'N31344', 'N31343', 'N31342', --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA
        'N31340', 'N31339', 'N31338', 'N31337', 'N31336', 'N31335', 'N31334', 'N31333', 'N31332', 'N31331', --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA
        'N31330', 'N31329', 'N31328', 'N31327', 'N31326', 'N31325', 'N31324', 'N31323', 'N31322', 'N31321', --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA
        'N31320', 'N31319', 'N31318', 'N31317', 'N31316', 'N31315', 'N31314', 'N31313', 'N31312', 'N31311', --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA
        'N31310', 'N31309', 'N31308', 'N31307', 'N31306', 'N31305', 'N31304', 'N31303', 'N31301'  --INFRAÇÕES AMBIENTAIS RELATIVOS A FLORA
        )