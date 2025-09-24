require 'httparty'
require 'json'

class ApiClient

  def self.buscar_paises

    puts "Buscando dados da API do IBGE..."

    todos_codigos = %w[
          AF ZA AL DE AD AO AG SA DZ AR AM AU AT AZ BS BD BB BH BY BE BZ BJ BO BA BW BR BN BG BF BI BT
      CV CM KH CA QA KZ TD CL CN CY CO KM CG CI CR HR CU DK DJ DM EG SV AE EC ER SK SI ES US EE SZ ET
      FJ PH FI FR GA GM GH GE GD GR GT GY GN GQ GW HT NL HN HU YE MH SB IN ID IR IQ IE IS IL IT JM JP
      JO KI KW LA LS LV LB LR LY LI LT LU MK MG MY MW MV ML MT MA MU MR MX MM FM MZ MD MC MN ME NA NR
      NP NI NE NG NO NZ OM PW PA PG PK PY PE PL PT KE KG GB CF KR CD DO KP CZ RO RW RU WS SM LC KN ST
      VC SC SN SL RS SG SY SO LK SD SS SE CH SR TJ TH TZ TL TG TO TT TN TM TR TV UA UG UY UZ VU VE VN
      ZM ZW
    ]

    puts "Consultando #{todos_codigos.length} países em lotes..."
    todos_paises = []

    todos_codigos.each_slice(20).each_with_index do |lote, index|
      print "\rProcessando lote #{index + 1}/#{(todos_codigos.length / 20.0).ceil}..."

      begin
        codigos_lote = lote.join(';')
        response = HTTParty.get("https://servicodados.ibge.gov.br/api/v1/paises/#{codigos_lote}")

        if response.success? && response.body != "[]"
          paises_lote = response.parsed_response
          todos_paises.concat(paises_lote) if paises_lote.is_a?(Array)
          todos_paises.uniq! { |p| p.dig('id','ISO-3166-1-ALPHA-2') }
        end

        sleep(0.2)
      rescue => e
        puts "\nErro no lote #{lote.join(', ')}: #{e.message}"
      end
    end

    puts "\nEncontrados #{todos_paises.length} países"
    todos_paises
  end

  def self.processar_dados_pais(pais)
    linguas = nil
    if pais['linguas'].is_a?(Array)
      linguas_array = pais['linguas'].map { |l| l['nome'] }.compact
      linguas = linguas_array.join(', ') unless linguas_array.empty?
    end

    unidades_monetarias = nil
    if pais['unidades-monetarias'].is_a?(Array)
      moedas_array = pais['unidades-monetarias'].map { |m| m['nome'] }.compact
      unidades_monetarias = moedas_array.join(', ') unless moedas_array.empty?
    end

    {
      codigo_iso2: pais.dig('id', 'ISO-3166-1-ALPHA-2'),
      codigo_iso3: pais.dig('id', 'ISO-3166-1-ALPHA-3'),
      nome: pais.dig('nome', 'abreviado'),
      capital: pais.dig('governo', 'capital', 'nome'),
      regiao: pais.dig('localizacao', 'regiao', 'nome'),
      sub_regiao: pais.dig('localizacao', 'sub-regiao', 'nome'),
      regiao_intermediaria: pais.dig('localizacao', 'regiao-intermediaria', 'nome'),
      area: pais.dig('area', 'total'),
      historico: pais['historico'],
      linguas: linguas,
      unidades_monetarias: unidades_monetarias
    }
  end
end