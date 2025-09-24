
## 📌 Sobre o Projeto API IBGE + Ruby puro

Este projeto foi desenvolvido em **Ruby puro** (sem Rails ou frameworks), como parte da disciplina **Programação Avançada**.  

A atividade proposta pedia que cada aluno criasse uma aplicação para:  
✅ Praticar o consumo de **APIs REST** usando Ruby puro.  
✅ Persistir dados em um banco **PostgreSQL**.  
✅ Permitir consultas dos dados armazenados.  
✅ Trabalhar com **orientação a objetos**.  

---

## 💎 Gems Utilizadas

1. **[pg](https://github.com/ged/ruby-pg)**  
   - Faz a conexão com o banco **PostgreSQL**.  
   - Permite criar tabelas, inserir e consultar dados.  

2. **[httparty](https://github.com/jnunemaker/httparty)**  
   - Facilita o consumo de **APIs REST**.  
   - Permite fazer requisições HTTP e processar respostas JSON.  

---

## 🌐 API Utilizada

O projeto consome a **API de Países do IBGE**:  
🔗 [Documentação oficial](https://servicodados.ibge.gov.br/api/docs/paises)  

**Endpoint utilizado:**  

[https://servicodados.ibge.gov.br/api/v1/paises/{paises}](https://servicodados.ibge.gov.br/api/v1/paises/{paises})


- Recurso: **Países**  
- Retorna a **listagem de países e seus perfis** (códigos ISO, capital, região, línguas, moedas, área e histórico).

---

## ⚙️ Como Funciona

### 🔗 Conexão com o PostgreSQL
- O projeto cria automaticamente a tabela `paises` dentro do banco configurado.  
- Cada país é inserido apenas se não existir (verificação pelo código ISO2).  

### 🌍 Consumo da API do IBGE
- A API não retorna todos os países de uma vez.  
- Por isso, o sistema consulta em **lotes de códigos ISO**.  
- Cada país retornado é processado e formatado antes de ir para o banco.  

### 📊 Consulta e Manipulação de Dados
- É possível **listar todos os países**.  
- Também é possível **buscar por nome** e visualizar informações detalhadas como:  
  - Nome oficial  
  - Códigos ISO  
  - Capital  
  - Região e sub-região  
  - Área  
  - Línguas oficiais  
  - Unidades monetárias  
  - Histórico  

---

## 🚀 Modo de Usar

### Como consultar os dados guardados

1. Clone o repositório:

```bash
git clone https://github.com/dominiquemorem/ruby_integracao_api_paises_ibge
````

2. Entre no diretório do projeto:

```bash
cd ruby_integracao_api_paises_ibge
```

3. (Opcional) Abra no VS Code:

```bash
code .
```

4. Rode a aplicação:

```bash
ruby main.rb
```

5. No menu, escolha a opção **1** para popular os dados da API no banco.

6. Se der algum problema, rode o script de teste:

```bash
ruby teste_api.rb
```

7. Agora você pode:

   * Listar todos os países (**opção 2**).
   * Buscar informações de um país pelo nome (**opção 3**).

---

## 📂 Estrutura do Projeto

* `database_ibge.rb` → Conexão e manipulação do banco PostgreSQL.
* `api_client.rb` → Consumo da API do IBGE e processamento dos dados.
* `paises_app.rb` → Lógica para popular, listar e buscar países.
* `main.rb` → Menu principal da aplicação.
* `teste_api.rb` → Script auxiliar para popular dados diretamente da API.

---

## 📝 Observações

* Projeto feito em **Ruby puro**, sem Rails.
* Segue boas práticas de **orientação a objetos**.
* Ideal para estudo de **APIs REST + PostgreSQL**.

---

