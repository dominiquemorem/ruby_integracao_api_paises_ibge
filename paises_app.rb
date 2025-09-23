require_relative 'database_ibge'
require_relative 'api_client'

class PaisesApp
  def self.popular_dados
    paises = ApiClient.buscar_paises

    paises.each do |pais|
      dados_processados = ApiClient.processar_dados_pais(pais)
      DatabaseIBGE.inserir_pais(dados_processados)
    end

    puts "Dados inseridos com sucesso!"
  end

  def self.listar_todos
    puts "\n=== TODOS OS PAÍSES ==="
    result = DatabaseIBGE.listar_todos

    result.each do |pais|
     puts "\n--- #{pais['nome']} ---"
      puts "Código ISO2: #{pais['codigo_iso2']}"
      puts "Código ISO3: #{pais['codigo_iso3']}"
      puts "Capital: #{pais['capital'] || 'N/A'}"
      puts "Região: #{pais['regiao'] || 'N/A'}"
      puts "Sub-região: #{pais['sub_regiao'] || 'N/A'}"
      puts "Região Intermediária: #{pais['regiao_intermediaria'] || 'N/A'}"
      puts "Área: #{pais['area'] || 'N/A'}"
      puts "Línguas: #{pais['linguas'] || 'N/A'}"
      puts "Unidades Monetárias: #{pais['unidades_monetarias'] || 'N/A'}"
      if pais['historico'] && !pais['historico'].empty?
        puts "Histórico: #{pais['historico'][0..200]}..."
      end
    end

    puts "\nTotal: #{result.ntuples} países"
  end

  def self.buscar_por_nome(nome)
    puts "\n=== BUSCA POR NOME: #{nome} ==="
    result = DatabaseIBGE.buscar_por_nome(nome)

    if result.ntuples > 0
      result.each do |pais|
        puts "\n--- #{pais['nome']} ---"
        puts "Código ISO2: #{pais['codigo_iso2']}"
        puts "Código ISO3: #{pais['codigo_iso3']}"
        puts "Capital: #{pais['capital'] || 'N/A'}"
        puts "Região: #{pais['regiao'] || 'N/A'}"
        puts "Sub-região: #{pais['sub_regiao'] || 'N/A'}"
        puts "Região Intermediária: #{pais['regiao_intermediaria'] || 'N/A'}"
        puts "Área: #{pais['area'] || 'N/A'}"
        puts "Línguas: #{pais['linguas'] || 'N/A'}"
        puts "Unidades Monetárias: #{pais['unidades_monetarias'] || 'N/A'}"
        if pais['historico'] && !pais['historico'].empty?
          puts "Histórico: #{pais['historico'][0..200]}..."
        end
      end
      puts "\nEncontrados #{result.ntuples} país(es)"
    else
      puts "Nenhum país encontrado com o nome '#{nome}'!"
    end
  end
end