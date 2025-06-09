# Repositório de Scripts SQL - CGA/PMMG

Bem-vindo ao repositório de scripts SQL do **Centro de Gerenciamento e Análise de Dados (CGA)** da Polícia Militar de Minas Gerais (PMMG). Este espaço foi criado para compartilhar e 
fomentar o uso de boas práticas em consultas SQL, promovendo o desenvolvimento de soluções eficientes e de alta qualidade para consulta e análise de dados.

Neste repositório, você encontrará scripts prontos e comentados, além de orientações detalhadas sobre comandos básicos e avançados, aplicáveis a diversos cenários e análises. O objetivo é oferecer suporte tanto a analistas experientes quanto a iniciantes, promovendo a criação de consultas otimizadas e bem estruturadas, alinhadas às demandas operacionais e estratégicas da instituição.

> 💡 **Dica de configuração no DBeaver:**  
> Para evitar problemas com a execução de múltiplas instruções SQL separadas por linhas em branco, configure o DBeaver da seguinte forma:  
> - No topo da janela principal, clique em **“Janela”** e depois em **“Preferências”**.  
> - No menu lateral esquerdo, vá em **Editores > Editor SQL > Processamento de SQL**.  
> - No painel da direita, na seção **Delimitadores**, altere a opção **“Linha em branco como delimitador de instruções”** para **“Never”** e aplique a mudança.  
> Isso garante que linhas em branco não sejam interpretadas como separadores de instruções SQL.

---

## 📚 Conteúdo
- [GDO 2025](https://github.com/CGA-PMMG/CGA_SCRIPTS/tree/main/GDO%202025)
- [Indicadores de Interação Comunitária](https://github.com/CGA-PMMG/CGA_SCRIPTS/tree/main/INDICADORES%20DE%20INTERA%C3%87%C3%83O%20COMUNIT%C3%81RIA%20-%20DOP)
- [Indicadores de Prevenção à Violência Doméstica](https://github.com/CGA-PMMG/CGA_SCRIPTS/tree/main/INDICADORES%20PVD)
- [GDO 2024](https://github.com/CGA-PMMG/CGA_SCRIPTS/tree/main/GDO%202024)
- [SIGOP](https://github.com/CGA-PMMG/CGA_SCRIPTS/tree/main/SIGOP)
- [Produtividade](https://github.com/CGA-PMMG/CGA_SCRIPTS/tree/main/PRODUTIVIDADE)
- [PPVD](https://github.com/CGA-PMMG/CGA_SCRIPTS/tree/main/PPVD)
- [Demandas e OS](https://github.com/CGA-PMMG/CGA_SCRIPTS/tree/main/Demandas%20e%20OS)
- [Contribuições](https://github.com/CGA-PMMG/CGA_SCRIPTS/tree/main/CONTRIBUI%C3%87%C3%95ES)


Além destes tópicos, o repositório também inclui outros conteúdos relevantes, continuamente atualizados. Explore o repositório para descobrir mais materiais úteis!

---
## 📌 Recomendações Importantes

### 1. Evite o uso de `SELECT *`
- **Desempenho:** Carregar todas as colunas aumenta o tempo de processamento.
- **Manutenção:** Mudanças nas tabelas podem impactar consultas genéricas.
- **Legibilidade:** Listar colunas torna o código mais claro e compreensível.

### 2. Utilize `LIMIT` ao testar consultas
- **Testar resultados:** Permite validar a consulta com uma amostra reduzida.
- **Economizar recursos:** Reduz o impacto no sistema durante os testes.

### 3. Prefira `EXISTS` ou `IN` conforme o contexto
- Use `EXISTS` para grandes volumes de dados ou junções complexas.
- Use `IN` para conjuntos pequenos ou listas específicas.

### 4. Tipos de dados booleanos
- **Eficiência:** Menor espaço de armazenamento e processamento mais rápido.
- **Clareza:** Representa estados binários de forma intuitiva e autoexplicativa.

### 5. JOINS vs Subconsultas
- Prefira **JOINS** para maior eficiência em tabelas grandes.
- Use subconsultas para condições específicas e lógicas mais complexas.

### 6. Otimização da cláusula `LIKE`
- Evite padrões que começam com `%` para garantir o uso de índices.

### 7. Priorize comparações diretas com `=`
- Melhor desempenho e consistência no código.

### 8. Ordene condições na cláusula `WHERE`
- Dê prioridade às condições mais seletivas, como:
  - Índices.
  - Igualdade (`=`).
  - Faixas (`BETWEEN`, `>=`, `<=`).
  - Subconsultas e funções complexas devem ser evitadas no início.

---

## 🌟 Por que seguir estas práticas?
Adotar boas práticas em SQL garante consultas mais rápidas, eficientes e fáceis de manter, otimizando recursos e melhorando a performace da busca.

---
## 🤝 Contribuições

Contribuições, correções e sugestões são sempre bem-vindas! Caso identifique melhorias ou tenha novas ideias, sinta-se à vontade para abrir uma *issue* ou enviar um *pull request*. Este repositório é um espaço colaborativo, e sua participação é fundamental para torná-lo ainda mais útil e eficiente para todos. 

Junte-se a nós na construção de um recurso cada vez melhor!


