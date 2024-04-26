# CGA SCPRITS
Coleção de scripts SQL desenvolvidos pelo Centro de Gerenciamento e Análise de dados para otimizar a análise de dados e relatórios dentro da Polícia Militar de Minas Gerais. Esta sessão contém instruções/ dicas para utilização do Dbeaver e dos scripts.

-----------------------------------------------------------------------------------------------------
                                                  DBEAVER                                             
                                                                                                     


Manipular o DBeaver envolve várias tarefas, desde conectar-se a um banco de dados até executar consultas 
SQL e visualizar resultados. Vamos detalhar algumas das funcionalidades principais e como você pode usá-las eficientemente:

-- Criar Conexão: No menu principal, selecione Database e depois Nova Conexão. Escolha o tipo de banco de dados e 
preencha os detalhes necessários como host, porta, nome do usuário e senha.

-- Editor SQL: Abra um novo editor SQL clicando no ícone de SQL ou pressionando 'CTRL' + ']'.

-- Escrever Consultas: Use o editor para digitar suas consultas SQL. O DBeaver oferece recursos como autocompletar e destaque de sintaxe para ajudar.

-- Executar Consultas: Execute suas consultas usando o botão Execute (ou pressionando 'CTRL' + 'Enter'). 
Você pode executar todo o script ou apenas uma parte selecionada.

-- Configurações: Personalize o comportamento e a aparência do DBeaver em Janela> Preferências, onde você pode ajustar temas,
 configurações de SQL, etc.

		Configurações IMPORTANTES:
	1 - Codificação de caracteres do alfabeto para extração dos dados - ISO 8859-1.
	2 - O Dbeaver entende que a linha em branco como delimitador de instruções, recomenda-se configurar para as linhas 
	em branco não serem interpretadas no script: 
		PT: Janela - Preferências - Editores - Editor SQL - Processamento SQL - Delimitadores - demarcar a caixa 'Linha em branco como demilitador de instuções'.
		EN: Window - Preferences - Editors - SQL Editor – SQL Processing -  Delimiters - desmarcar a caixa 'Blank Line is statement delimiter'.
		
		Dicas:	
	1 – Comentar linha: -- 
	2 – Descomentar linha:'Crtl' + '/'
	3 – Executar script: 'Crtl' + 'Enter'


------------------------------------------------------------------------------------------------------
                                               SQL                                                 
                                                                                                     

SELECT

Seleciona campos específicos da tabela para serem exibidos na consulta.

Exemplo: SELECT nome_completo_envolvido, nome_mae, data_nascimento

---------------------------------------------------------------------------------------------------------
FROM

Indica a tabela da qual os dados estão sendo selecionados.

Exemplo: FROM tb_ocorrencia OCO

---------------------------------------------------------------------------------------------------------
COUNT

Conta o número de registros que atendem a uma condição específica.

Exemplo: COUNT(DISTINCT OCO.numero_ocorrencia) as REINCIDENCIA

---------------------------------------------------------------------------------------------------------
GROUP_CONCAT

GROUP_CONCAT: Concatena valores de uma coluna para cada grupo de linhas.

Exemplo: GROUP_CONCAT(DISTINCT OCO.natureza_codigo) as Naturezas_codigo

---------------------------------------------------------------------------------------------------------
JOIN

INNER JOIN: Combina dados de duas tabelas com base em uma condição específica.
LEFT JOIN: Retorna todos os registros da tabela à esquerda e os registros correspondentes da tabela à direita, se houver.
RIGHT JOIN: Retorna todos os registros da tabela à direita e os registros correspondentes da tabela à esquerda, se houve

Exemplo: INNER JOIN tb_envolvido_ocorrencia ENV ON (ENV.numero_ocorrencia = OCO.numero_ocorrencia)

---------------------------------------------------------------------------------------------------------									
WHERE

WHERE: Filtra os dados da consulta com base em condições específicas.
Exemplo: WHERE OCO.natureza_codigo IN (...) AND YEAR(OCO.data_hora_fato) BETWEEN 2023 AND 2024
Os operadores `WHERE` em SQL são usados para filtrar registros com base em condições específicas. 
Aqui estão alguns operadores comuns usados com a cláusula `WHERE`:

1. **Operador de Igualdade (=)**:
   - Usado para comparar se dois valores são iguais.
     
   - Exemplo: SELECT * FROM tabela WHERE coluna = 'valor';
 
2. **Operador de Diferença (<>, !=)**:
   - Usado para comparar se dois valores são diferentes.
     
   - Exemplo: SELECT * FROM tabela WHERE coluna <> 'valor';

3. **Operadores de Comparação (<, >, <=, >=)**:
   - Usados para comparar valores numericamente.
     
   - Exemplo: SELECT * FROM tabela WHERE coluna > 10;

4. **Operador IN**:
   - Usado para verificar se um valor está em uma lista de valores.
     
   - Exemplo: SELECT * FROM tabela WHERE coluna IN ('valor1', 'valor2', 'valor3');


5. **Operador LIKE**:
   - Usado para fazer correspondência parcial em strings usando curingas (% para zero ou mais caracteres, _ para um caractere).
   - 
   - Exemplo: SELECT * FROM tabela WHERE coluna LIKE 'valor%';
  

6. **Operador BETWEEN**:
   - Usado para verificar se um valor está dentro de um intervalo.
     
   - Exemplo: SELECT * FROM tabela WHERE coluna BETWEEN 10 AND 20;


7. **Operador NOT**:
   - Usado para negar uma condição.
     
   - Exemplo: SELECT * FROM tabela WHERE NOT coluna = 'valor';

Estes são alguns dos operadores mais comuns utilizados com a cláusula `WHERE` em SQL. Eles permitem realizar 
filtragens mais precisas e específicas nos dados de uma tabela.

---------------------------------------------------------------------------------------------------------
GROUP BY

GROUP BY: Agrupa os resultados da consulta com base em uma ou mais colunas.

Exemplo: GROUP BY ENV.nome_completo_envolvido, ENV.nome_mae, ENV.data_nascimento

---------------------------------------------------------------------------------------------------------
HAVING

Filtra grupos de linhas após a agregação de dados.
Exemplo: HAVING COUNT(DISTINCT OCO.numero_ocorrencia) > 1


---------------------------------------------------------------------------------------------------------
SPLIT_PART

Divide uma string em substrings com base em um delimitador especificado e retorna a substring na posição indicada.
split_part(string, delimiter, part)

Exemplo: SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM

---------------------------------------------------------------------------------------------------------
TO_DATE 

No caso para retornar apenas a data NÂO CONTENDO a hora.

Exemplo: TO_DATE(OCO.data_hora_fato) as Data

---------------------------------------------------------------------------------------------------------

