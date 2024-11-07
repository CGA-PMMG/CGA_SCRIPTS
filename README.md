# Banco de Dados <img src="https://github.com/CGA-PMMG/CGA_SCRIPTS/blob/main/Configura%C3%A7%C3%A3o%20GitHub/image_readme_sql.png" width="10%" height="10%" align="right" valign="center"/>
![SQL](https://img.shields.io/badge/SQL-blue?style=plastic)
![Dbeaver](https://img.shields.io/badge/DBEAVER-blue?style=plastic)
![Scripts](https://img.shields.io/badge/SCRIPT-blue?style=plastic)
![Recomendacoes](https://img.shields.io/badge/Recomenda%C3%A7%C3%B5es-red?style=plastic)


Coleção de scripts SQL desenvolvidos pelo Centro de Gerenciamento e Análise de Dados para otimizar a análise de dados e relatórios dentro da Polícia Militar de Minas Gerais. Esta sessão contém instruções/ dicas para utilização do Dbeaver e dos scripts.
- [GDO 2024](GDO 2024)
- [Produtividade](PRODUTIVIDADE)
- [SIGOP](SIGOP)
- [CAD](CAD)
### DBEAVER                                             


Manipular o DBeaver envolve várias tarefas, desde conectar-se a um banco de dados até executar consultas 
SQL e visualizar resultados. Vamos detalhar algumas das funcionalidades principais e como você pode usá-las eficientemente:

-- Criar Conexão: No menu principal, selecione Database e depois Nova Conexão. Escolha o tipo de banco de dados e 
preencha os detalhes necessários como host, porta, nome do usuário e senha.

-- Editor SQL: Abra um novo editor SQL clicando no ícone de SQL ou pressionando `'CTRL' + ']'`

-- Escrever Consultas: Use o editor para digitar suas consultas SQL. O DBeaver oferece recursos como autocompletar e destaque de sintaxe para ajudar.

-- Executar Consultas: Execute suas consultas usando o botão Execute (ou pressionando `'CTRL' + 'Enter'`). 
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


#### Erros Dbeaver:

 
 1- Erro de conexão:

 
 Erro ocorrido durante a execução de consulta SQL.
 
		PT: [Erro SQL [500051] [HY000]: ... Erro XXXXXX ao processar a consulta/declarativa. Código de Erro: 0, Estado SQL: TStatus(statusCode:ERROR_STATUS, sqlState:HY000, errorMessage:AuthorizationException: O usuário 'XXXX' não possui privilégios para executar 'SELECT' em: default.tb_XXX.]
  		EN: [Erro SQL [500051] [HY000]: ... ERROR processing query/statement. Error Code: 0, SQL state: TStatus(statusCode:ERROR_STATUS, sqlState:HY000, errorMessage:AuthorizationException: User 'xxx' does not have privileges to execute 'SELECT' on: default.xxx]
    
Este erro ocorre devido a uma falha na conexão do Sistema de Gerenciamento de Banco de Dados (SGBD) ao banco de dados. Ocasionalmente apenas uma aba do DBeaver se desconecta do banco de dados. Para resolver, vá ao canto superior direito da tela, ao lado de 'Cloudera Impala'. No botão atualmente selecionado 'default', selecione o banco de dados desejado para a execução da consulta.


 ### Comandos SQL - Linguagem de Consulta de Dados                                                
![Alerta](https://img.shields.io/badge/IMPORTANTE-red?style=plastic)
![DQL](https://img.shields.io/badge/DQL-green?style=plastic)												     

#### SELECT

Seleciona campos específicos da tabela para serem exibidos na consulta.

Exemplo: `SELECT nome_completo_envolvido, nome_mae, data_nascimento`

---
#### FROM

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
#### JOIN

1. `INNER JOIN`: Combina dados de duas tabelas com base em uma condição específica.

2. `LEFT JOIN`: Retorna todos os registros da tabela à esquerda e os registros correspondentes da tabela à direita, se houver.

3. `RIGHT JOIN`: Retorna todos os registros da tabela à direita e os registros correspondentes da tabela à esquerda, se houver.

Exemplo: `INNER JOIN tb_envolvido_ocorrencia ENV ON ENV.numero_ocorrencia = OCO.numero_ocorrencia`

---								
#### WHERE

Filtra os dados da consulta com base em condições específicas.

Exemplo: `WHERE OCO.natureza_codigo IN (...) AND YEAR(OCO.data_hora_fato) BETWEEN 2023 AND 2024`
Os operadores `WHERE` em SQL são usados para filtrar registros com base em condições específicas. 
Aqui estão alguns operadores comuns usados com a cláusula `WHERE`:

1. **Operador de Igualdade (=)**:
   - Usado para comparar se dois valores são iguais.
     
    Exemplo: `SELECT coluna FROM tabela WHERE coluna = 'valor';`
 
2. **Operador de Diferença (!=)**:
   - Usado para comparar se dois valores são diferentes.
     
    Exemplo: `SELECT coluna FROM tabela WHERE coluna <> 'valor';`

3. **Operadores de Comparação (<, >, <=, >=)**:
   - Usados para comparar valores numericamente.
     
    Exemplo: `SELECT coluna FROM tabela WHERE coluna > 10;`

4. **Operador IN**:
   - Usado para verificar se um valor está em uma lista de valores.
     
    Exemplo: `SELECT coluna FROM tabela WHERE coluna IN ('valor1', 'valor2', 'valor3');`


5. **Operador LIKE**:
   - Usado para fazer correspondência parcial em strings usando curingas (% para zero ou mais caracteres).
     
    Exemplo: `SELECT coluna FROM tabela WHERE coluna LIKE 'valor%';`
  

6. **Operador BETWEEN**:
   - Usado para verificar se um valor está dentro de um intervalo.
     
    Exemplo: `SELECT coluna FROM tabela WHERE coluna BETWEEN 10 AND 20;`


7. **Operador NOT**:
   - Usado para negar uma condição.
     
    Exemplo: `SELECT coluna FROM tabela WHERE NOT coluna = 'valor';`

Estes são alguns dos operadores mais comuns utilizados com a cláusula `WHERE` em SQL. Eles permitem realizar 
filtragens mais precisas e específicas nos dados de uma tabela.

---
 ##### CASE WHEN
 
 Estrutura condicional que permite verificar uma série de condições e retornar valores específicos 
 com base nessas condições, dentro de uma consulta. Funciona de maneira similar a uma 
 declaração "if-else" (se-senão).

1. `CASE`: Inicia a expressão.
2. `WHEN`: Seguido por uma condição que você quer testar.
3. `THEN`: Define o que deve ser retornado se a condição WHEN for verdadeira.
4. `ELSE`: Opcional, define o que deve ser retornado se nenhuma das condições WHEN for atendida.
5. `END`: Finaliza a expressão.
   
A expressão `CASE WHEN` é frequentemente usada para criar novas categorias ou transformar dados de acordo com regras específicas, diretamente na consulta SQL, antes dos dados serem exibidos.

---
##### SUBSTRING 

Extrai uma parte específica de uma string.

Exemplo: `SUBSTRING(OCO.unidade_responsavel_registro_nome, 1, 3)`

---
##### UPPER / LOWER

Converte o texto para maísculo (`UPPER`) ou minúsculo (`LOWER`).

Exemplo: `UPPER(ENV.nome_completo_envolvido)`

---
##### COUNT

Conta o número de registros que atendem a uma condição específica.

Exemplo: `COUNT(DISTINCT OCO.numero_ocorrencia) as REINCIDENCIA`

---
##### SPLIT_PART

Divide uma string em substrings com base em um delimitador especificado e retorna a substring na posição indicada.
split_part(string, delimiter, part)

Exemplo: `SPLIT_PART(OCO.unidade_responsavel_registro_nome, '/', -1) AS RPM`

---
##### NOW

Retorna data atual do sistema.

Exemplo:`Now() as data_atual`

---
##### TO_DATE 

No caso para retornar apenas a data NÃO CONTENDO a hora.

Exemplo: `TO_DATE(OCO.data_hora_fato) as Data`

---
##### GROUP_CONCAT

Concatena valores de uma coluna para cada grupo de linhas.

Exemplo: `GROUP_CONCAT(DISTINCT OCO.natureza_codigo) as Naturezas_codigo`

---
##### GROUP BY

Agrupa os resultados da consulta com base em uma ou mais colunas.

Exemplo: `GROUP BY ENV.nome_completo_envolvido, ENV.nome_mae, ENV.data_nascimento`

---
##### HAVING

Filtra grupos de linhas após a agregação de dados.
 
Exemplo: `HAVING COUNT(DISTINCT OCO.numero_ocorrencia) > 1`

---

# Recomendações Importantes para o Uso de Funções SQL
![Alerta](https://img.shields.io/badge/IMPORTANTE-red?style=plastic)
#### 1. Evitar `SELECT *`
O uso da cláusula `SELECT *` nas consultas SQL **não é recomendado** em ambientes de produção, especialmente em bancos de dados de grande porte. A prática de selecionar todas as colunas de uma tabela pode levar a vários problemas como:

- **Desempenho**: Ao usar `SELECT *`, o banco de dados precisa carregar todas as colunas de uma tabela, mesmo aquelas que não são necessárias para a análise desejada. Isso aumenta o tempo de processamento e o uso de memória, afetando negativamente o desempenho das consultas e do sistema como um todo.
- **Manutenção**: Com o tempo, as tabelas tendem a evoluir, com a adição ou remoção de colunas. O uso de `SELECT *` torna o código mais difícil de ser mantido, pois qualquer mudança na estrutura da tabela pode ter efeitos inesperados nas consultas.
- **Legibilidade do Código**: Especificar explicitamente as colunas que serão selecionadas torna o código mais claro e fácil de entender, facilitando a manutenção e a colaboração entre desenvolvedores, além de minimizar a chance de erros.

**Recomenda-se sempre listar explicitamente as colunas necessárias para a consulta.**

#### 2. Uso do `LIMIT`
O uso da cláusula `LIMIT` é **altamente recomendado** ao testar uma consulta. Benefícios do uso do `LIMIT`:

- **Testar Resultados**: O `LIMIT` nos permite visualizar uma amostra dos resultados da consulta sem processar todo o conjunto de dados. Isso é útil para verificar se a lógica da consulta está correta e se os dados retornados são os esperados. Visualizar uma amostra dos resultados facilita a identificação de problemas na consulta, como filtros incorretos ou junções erradas, permitindo correções antes de executar a consulta final, economizando tempo e recursos.
- **Economizar Recursos**: Executar uma consulta completa pode consumir muitos recursos do sistema, especialmente se a consulta envolve junções complexas, agregações ou filtros em grandes tabelas. O uso do `LIMIT` reduz a carga de processamento, permitindo ajustes na consulta de maneira mais eficiente.

#### 3. `EXISTS` vs `IN`
A cláusula `EXISTS` é utilizada para verificar se um ou mais valores estão presentes no resultado de uma subconsulta. Por outro lado, a cláusula `IN` é empregada para comparar um valor com um conjunto de valores retornados por uma subconsulta ou com um conjunto declarado de valores. Ambas as cláusulas são usadas no comando `WHERE`.

A decisão entre `EXISTS` e `IN` pode impactar o desempenho da consulta, dependendo do contexto e da estrutura dos dados.

- **`EXISTS`**: É eficiente em grandes volumes de dados, pois o SQL pode interromper a busca assim que encontra o primeiro registro que satisfaz a condição. É útil em consultas que envolvem junções complexas e onde a mera existência de registros é suficiente para atender à condição.
- **`IN`**: Apresenta maior desempenho quando se trata de um conjunto de dados menor. Em situações onde a subconsulta retorna poucos registros ou quando a comparação é feita com uma lista declarada de valores, a cláusula `IN` é mais rápida e intuitiva.

**Recomenda-se:**
- `EXISTS`: Quando a subconsulta retorna muitos registros ou quando é necessário verificar a existência de registros em junções complexas.
- `IN`: Quando se compara valores específicos em conjuntos pequenos ou quando a subconsulta retorna poucos registros.

#### 4. Tipo de Dado Booleano
A utilização de dados booleanos em SQL traz diversas vantagens, como um menor espaço de armazenamento de dados, já que as colunas booleanas ocupam menos espaço em comparação com inteiros ou strings. As variáveis booleanas simplificam a lógica condicional, pois seus valores são limitados e claros, restringindo-se apenas a TRUE (verdadeiro) ou FALSE (falso). Isso torna o código mais intuitivo e fácil de entender. Colunas como `usuario_ativo` e `permissao_acesso` são autoexplicáveis. Outro benefício significativo é o desempenho, pois a comparação de valores booleanos é mais rápida e eficiente em comparação com outros tipos de dados.

**Recomenda-se sempre o uso de booleanos para representar estados binários**, melhorando tanto a clareza quanto a eficiência do código SQL.

#### 5. JOINS vs Subconsulta
Quando trabalhamos com bancos de dados SQL, a escolha entre utilizar joins ou subconsultas pode impactar o desempenho das suas consultas.

- **Joins**: Normalmente são utilizados para combinar dados de duas ou mais tabelas com base em uma condição. Existem diferentes tipos de joins, cada um servindo a propósitos específicos. Em termos de performance, os joins geralmente são mais eficientes do que subconsultas, especialmente quando se trata de grandes conjuntos de dados. Isso ocorre porque os joins permitem que o banco de dados otimize a consulta e execute as operações de combinação de maneira mais direta e eficaz.
- **Subconsultas**: São consultas aninhadas dentro de outra consulta. Embora sejam úteis em alguns casos, são menos eficientes do que os joins, particularmente quando retornam grandes conjuntos de dados ou quando a lógica da consulta envolve múltiplas camadas de subconsultas.

**Recomenda-se:**
- **Usar Joins**: Quando precisar combinar dados de duas ou mais tabelas com base em uma condição de relacionamento clara. Prefira joins para consultas que envolvem grandes volumes de dados.
- **Usar Subconsultas**: Quando precisar filtrar resultados com base em condições complexas que não são facilmente resolvidas com joins. As subconsultas são úteis para casos onde uma consulta interna deve ser executada primeiro para fornecer dados à consulta externa.

#### 6. Otimizando a Cláusula `LIKE`
A cláusula `LIKE` é frequentemente utilizada em consultas para buscar padrões dentro de colunas do tipo texto. No entanto, a forma como o padrão é especificado influencia na performance da consulta.

Índices são estruturas de dados que o banco de dados usa para melhorar a velocidade das operações de consulta, permitindo que o banco de dados encontre dados mais rapidamente sem ter que varrer todas as linhas de uma tabela. Quando usamos o `LIKE` para buscar padrões em uma coluna, o comportamento do índice depende de como o padrão é especificado.

- **Padrão que Não Começa com `%`**: Se o padrão especificado não começa com um caractere curinga `%`, o banco de dados pode usar o índice para acelerar a busca. Por exemplo: `LIKE 'Ana%'` pode usar um índice, pois o banco de dados sabe que está procurando por textos que começam com "Ana".
- **Padrão que Começa com `%`**: Quando o padrão começa com `%`, o índice não pode ser utilizado de maneira eficiente. `%` no início significa que qualquer sequência de caracteres pode estar antes do padrão, exigindo que o banco de dados examine linha a linha. Exemplo: `LIKE '%na'` não pode usar o índice, pois o banco de dados teria que verificar todas as entradas para encontrar aquelas que terminam em "na".

**Recomenda-se evitar padrões que começam com `%`** para garantir que suas buscas sejam rápidas e eficientes.

#### 7. Atribuição Direta `=`
A utilização de atribuição direta `=` é muito vantajosa e recomendada quando comparamos um valor único. Por ser uma operação de comparação, tem um custo de processamento menor, portanto, melhor desempenho que outras operações ou cláusulas. Além de ser uma excelente prática, pois torna o código consistente, também facilita o entendimento da consulta para outros desenvolvedores.

#### 8. Ordem das Condições no `WHERE`
Quando falamos das condições e cláusulas dentro do `WHERE`, a ordem dos fatores não altera o resultado, mas influencia na performance e desempenho do banco de dados. Então, ao construir um código, devemos nos atentar à ordem em que inserimos as condições e cláusulas. A ordem de priorização é:

1. **Condições com Índices**: Condições que utilizam índices devem ser priorizadas porque o banco de dados consegue rapidamente localizar os registros sem a necessidade de ler toda a tabela.
2. **Condições de Igualdade**: As condições de igualdade `=` geralmente são mais eficientes porque reduzem o conjunto de dados antes de outras condições.
3. **Condições de Faixa**: Condições que restringem o intervalo de valores (`BETWEEN, >=, <=`).
4. **Condições de Junção**: As condições de junção (`JOIN`) podem ser otimizadas se colocadas cedo, especialmente se forem usadas em colunas indexadas.
5. **Condições de Subconsulta**: Devem ser priorizadas depois das condições mais seletivas para reduzir o número de registros que a subconsulta precisa processar.
6. **Condições de IN/NOT IN**: `IN` com uma lista pequena pode ser eficiente, mas com listas grandes ou em tabelas grandes, são menos eficientes do que junções ou outras condições.
7. **Condições de LIKE com `%` ao Final**: Condições `LIKE` onde o wildcard `%` está no final são índices, tornando-as mais rápidas que wildcards no início.
8. **Condições de LIKE com `%` ao Início**: Condições `LIKE` com wildcards no início (`%prefixo`) não são eficientes, nem recomendadas, pois não podem usar índices e exigem uma varredura completa da tabela linha a linha.
9. **Condições Complexas e Funções**: Condições que envolvem funções, cálculos ou operações complexas são deixadas por último, pois requerem mais processamento.

**Adotar estas práticas no seu fluxo de trabalho pode melhorar significativamente a eficiência e a precisão das consultas no banco de dados.**



