require_relative 'database_ibge'
require_relative 'api_client'
require_relative 'paises_app'

puts "\n=== CONSULTA DE PAÍSES - IBGE API ==="
puts "1. Popular dados da API"
puts "2. Listar todos os países"
puts "3. Buscar país por nome"

print "Escolha uma opção: "
opcao = gets.chomp

case opcao
when '1'
  PaisesApp.popular_dados
when '2'
  PaisesApp.listar_todos
when '3'
  print "Digite o nome do país (ou parte dele): "
  nome = gets.chomp
  PaisesApp.buscar_por_nome(nome)
else
  puts "Opção inválida!"
end