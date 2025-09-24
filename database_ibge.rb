require 'pg'

class DatabaseIBGE
  
  DB_CONFIG = {
    host: "localhost",
    user: "postgres",
    password: "admin",
    dbname: "database_ibge"
  }

  def self.setup
    begin
      PG.connect(host: "localhost", user: "postgres", password: "admin", dbname: "database_ibge").exec("CREATE DATABASE database_ibge")
      puts "Banco 'database_ibge' criado!"
    rescue PG::Error
      puts "Banco 'database_ibge' já existe"
    end

    PG.connect(DB_CONFIG).exec(<<~SQL)
      CREATE TABLE IF NOT EXISTS paises (
        id SERIAL PRIMARY KEY,
        codigo_iso2 VARCHAR(3),
        codigo_iso3 VARCHAR(4),
        nome VARCHAR(255),
        capital VARCHAR(255),
        regiao VARCHAR(255),
        sub_regiao VARCHAR(255),
        regiao_intermediaria VARCHAR(255),
        area VARCHAR(100),
        linguas TEXT,
        unidades_monetarias TEXT,
        historico TEXT
      );
    SQL

    puts "Tabela 'paises' criada!"
  end

  def self.connect
    PG.connect(DB_CONFIG)
  end

  def self.inserir_pais(dados_pais)
    exists = connect.exec_params(
      "SELECT id FROM paises WHERE codigo_iso2 = $1",
      [dados_pais[:codigo_iso2]]
    ).ntuples > 0

    unless exists
      connect.exec_params(
        "INSERT INTO paises (codigo_iso2, codigo_iso3, nome, capital, regiao, sub_regiao, regiao_intermediaria, area, linguas, unidades_monetarias, historico) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
        [
          dados_pais[:codigo_iso2],
          dados_pais[:codigo_iso3],
          dados_pais[:nome],
          dados_pais[:capital],
          dados_pais[:regiao],
          dados_pais[:sub_regiao],
          dados_pais[:regiao_intermediaria],
          dados_pais[:area],
          dados_pais[:linguas],
          dados_pais[:unidades_monetarias],
          dados_pais[:historico]
        ]
      )
    end
  end

  def self.listar_todos
    connect.exec("SELECT * FROM paises ORDER BY nome")
  end

  def self.buscar_por_nome(nome)
    connect.exec_params(
      "SELECT * FROM paises WHERE UPPER(nome) LIKE UPPER($1)",
      ["%#{nome}%"]
    )
  end
end


DatabaseIBGE.setup