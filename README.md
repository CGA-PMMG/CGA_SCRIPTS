# CGA SCPRITS
Coleção de scripts SQL desenvolvidos pelo Centro de Gerenciamento e Análise de dados para otimizar a análise de dados e relatórios dentro da Polícia Militar de Minas Gerais. Esta sessão contém instruções/ dicas para utilização do Dbeaver e dos scripts.

---
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


---
                                               SQL                                                 
                                                                                                     

SELECT

Seleciona campos específicos da tabela para serem exibidos na consulta.

Exemplo: SELECT nome_completo_envolvido, nome_mae, data_nascimento

---
FROM

Indica a tabela da qual os dados estão sendo selecionados.

Exemplo: FROM tb_ocorrencia OCO

       > O que é um Alias?
	Um alias é basicamente um apelido que você dá para uma tabela ou uma coluna em uma consulta SQL. 
	Isso pode ajudar a encurtar o seu código e torná-lo mais fácil de entender, especialmente quando você 
	está trabalhando com nomes de tabelas ou colunas muito longos ou complexos. 

 Geralmente é utlizado 'OCO' para referenciar a tabela de ocorrências e 'ENV' para tabela de envolvidos.

 	> Por que usar Alias é importante?
  
		1. Clareza: Alias tornam as consultas mais claras, especialmente em junções de múltiplas 
  		tabelas onde nomes podem se repetir ou ser confusos.
    
		2. Eficiência: Digitar menos código, especialmente em consultas complexas, economiza tempo e reduz a chance de erros.
  
		3. Flexibilidade: Você pode nomear os resultados de suas consultas da maneira que melhor se adeque ao contexto do seu 
  		trabalho ou do relatório que está preparando.
 
---
JOIN

1. INNER JOIN: Combina dados de duas tabelas com base em uma condição específica.

2. LEFT JOIN: Retorna todos os registros da tabela à esquerda e os registros correspondentes da tabela à direita, se houver.

3. RIGHT JOIN: Retorna todos os registros da tabela à direita e os registros correspondentes da tabela à esquerda, se houve

Exemplo: INNER JOIN tb_envolvido_ocorrencia ENV ON (ENV.numero_ocorrencia = OCO.numero_ocorrencia)

---								
WHERE

Filtra os dados da consulta com base em condições específicas.

Exemplo: WHERE OCO.natureza_codigo IN (...) AND YEAR(OCO.data_hora_fato) BETWEEN 2023 AND 2024
Os operadores `WHERE` em SQL são usados para filtrar registros com base em condições específicas. 
Aqui estão alguns operadores comuns usados com a cláusula `WHERE`:

1. **Operador de Igualdade (=)**:
   - Usado para comparar se dois valores são iguais.
     
    Exemplo: SELECT * FROM tabela WHERE coluna = 'valor';
 
2. **Operador de Diferença (!=)**:
   - Usado para comparar se dois valores são diferentes.
     
    Exemplo: SELECT * FROM tabela WHERE coluna <> 'valor';

3. **Operadores de Comparação (<, >, <=, >=)**:
   - Usados para comparar valores numericamente.
     
    Exemplo: SELECT * FROM tabela WHERE coluna > 10;

4. **Operador IN**:
   - Usado para verificar se um valor está em uma lista de valores.
     
    Exemplo: SELECT * FROM tabela WHERE coluna IN ('valor1', 'valor2', 'valor3');


5. **Operador LIKE**:
   - Usado para fazer correspondência parcial em strings usando curingas (% para zero ou mais caracteres).
     
    Exemplo: SELECT * FROM tabela WHERE coluna LIKE 'valor%';
  

6. **Operador BETWEEN**:
   - Usado para verificar se um valor está dentro de um intervalo.
     
    Exemplo: SELECT * FROM tabela WHERE coluna BETWEEN 10 AND 20;


7. **Operador NOT**:
   - Usado para negar uma condição.
     
    Exemplo: SELECT * FROM tabela WHERE NOT coluna = 'valor';

Estes são alguns dos operadores mais comuns utilizados com a cláusula `WHERE` em SQL. Eles permitem realizar 
filtragens mais precisas e específicas nos dados de uma tabela.

---
 CASE WHEN
 
 Estrutura condicional que permite verificar uma série de condições e retornar valores específicos 
 com base nessas condições, dentro de uma consulta. Funciona de maneira similar a uma 
 declaração "if-else" (se-senão).

1. CASE: Inicia a expressão.
2. WHEN: Seguido por uma condição que você quer testar.
3. THEN: Define o que deve ser retornado se a condição WHEN for verdadeira.
4. ELSE: Opcional, define o que deve ser retornado se nenhuma das condições WHEN for atendida.
5. END: Finaliza a expressão.
   
A expressão CASE WHEN é frequentemente usada para criar novas categorias ou transformar dados de acordo com regras específicas, diretamente na consulta SQL, antes dos dados serem exibidos.

---
SUBSTRING 

Extrai uma parte específica de uma string.

Exemplo: SUBSTRING(OCO.unidade_responsavel_registro_nome, 1, 3)

---
UPPER / LOWER

Converte o texto para maísculo (UPPER) ou minúsculo (LOWER).

Exemplo: UPPER(ENV.nome_completo_envolvido)

---
COUNT

Conta o número de registros que atendem a uma condição específica.

Exemplo: COUNT(DISTINCT OCO.numero_ocorrencia) as REINCIDENCIA

---
SPLIT_PART

Divide uma string em substrings com base em um delimitador especificado e retorna a substring na posição indicada.
split_part(string, delimiter, part)

Exemplo: SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM

---
NOW

Retorna data atual do sistema.

Exemplo: Now() as data_atual

---
TO_DATE 

No caso para retornar apenas a data NÂO CONTENDO a hora.

Exemplo: TO_DATE(OCO.data_hora_fato) as Data

---
GROUP_CONCAT

Concatena valores de uma coluna para cada grupo de linhas.

Exemplo: GROUP_CONCAT(DISTINCT OCO.natureza_codigo) as Naturezas_codigo

---
GROUP BY

Agrupa os resultados da consulta com base em uma ou mais colunas.

Exemplo: GROUP BY ENV.nome_completo_envolvido, ENV.nome_mae, ENV.data_nascimento

---
HAVING

Filtra grupos de linhas após a agregação de dados.
 
Exemplo: HAVING COUNT(DISTINCT OCO.numero_ocorrencia) > 1

---

