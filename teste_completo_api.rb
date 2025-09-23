
require 'httparty'
require 'json'

puts "=== TESTE COMPLETO API IBGE ==="

paises_teste = %w[AD AE AF AG AI AL AM AO AR AS AT AU AW AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW]

puts "Testando alguns países individuais..."
paises_encontrados = []


paises_teste.first(10).each do |codigo|
  print "Testando #{codigo}... "
  response = HTTParty.get("https://servicodados.ibge.gov.br/api/v1/paises/#{codigo}")

  if response.success? && response.body != "[]"
    data = JSON.parse(response.body)
    if data.is_a?(Array) && data.length > 0
      nome = data.first.dig('nome', 'abreviado')
      puts "OK - #{nome}"
      paises_encontrados << codigo
    else
      puts "Vazio"
    end
  else
    puts "Erro - #{response.code}"
  end

  sleep(0.1)
end

puts "\nPaíses encontrados: #{paises_encontrados.join(', ')}"


if paises_encontrados.length > 1
  puts "\nTestando consulta em lote..."
  codigos_lote = paises_encontrados.first(5).join(';')
  puts "Códigos: #{codigos_lote}"

  response_lote = HTTParty.get("https://servicodados.ibge.gov.br/api/v1/paises/#{codigos_lote}")
  puts "Status lote: #{response_lote.code}"

  if response_lote.success?
    data_lote = JSON.parse(response_lote.body)
    puts "Países no lote: #{data_lote.length}"
    data_lote.each do |pais|
      puts "- #{pais.dig('nome', 'abreviado')}"
    end
  end
end


puts "\n=== ESTRATÉGIA PARA BUSCAR TODOS ==="
puts "A API não retorna todos os países de uma vez."
puts "Precisamos consultar por lotes usando códigos ISO."
puts "Vou criar uma lista com todos os códigos de países válidos..."


todos_paises = %w[
  AF ZA AL DE AD AO AG SA DZ AR AM AU AT AZ BS BD BB BH BY BE BZ BJ BO BA BW BR BN BG BF BI BT
  CV CM KH CA QA KZ TD CL CN CY CO KM CG CI CR HR CU DK DJ DM EG SV AE EC ER SK SI ES US EE SZ ET
  FJ PH FI FR GA GM GH GE GD GR GT GY GN GQ GW HT NL HN HU YE MH SB IN ID IR IQ IE IS IL IT JM JP
  JO KI KW LA LS LV LB LR LY LI LT LU MK MG MY MW MV ML MT MA MU MR MX MM FM MZ MD MC MN ME NA NR
  NP NI NE NG NO NZ OM PW PA PG PK PY PE PL PT KE KG GB CF KR CD DO KP CZ RO RW RU WS SM LC KN ST
  VC SC SN SL RS SG SY SO LK SD SS SE CH SR TJ TH TZ TL TG TO TT TN TM TR TV UA UG UY UZ VU VE VN
  ZM ZW
]

puts "Total de códigos para testar: #{todos_paises.length}"
puts "Primeiros 10: #{todos_paises.first(10).join(', ')}"