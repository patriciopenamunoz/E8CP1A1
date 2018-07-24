require 'io/console'

def main
  limpiar_pantalla
  loop do
    case abrir_menu_principal
    when 1 then consultar_productos
    when 2 then buscar_stock_producto
    when 3 then mostrar_productos_no_registrados
    when 4 then consultar_stock_mayor_que
    when 5 then agregar_producto
    when 6 then exit
    end
  end
end

def agregar_producto
  limpiar_pantalla
  imprimir_titulo('Registrar nuevo producto')
  print 'Escriba el nombre del producto: '
  nombre = gets.chomp
  stock = []
  3.times do |n|
    print "Ingrese el valor para la BODEGA #{n + 1} (NR para no registrado): "
    stock[n] = gets.chomp
    stock[n] = stock[n].downcase == 'nr' ? 'NR' : stock[n].to_i
  end
  file = File.open('stock.txt', 'a')
  file.puts "#{nombre}, #{stock[0]}, #{stock[1]}, #{stock[2]}"
  file.close
  puts '-----------------------------------'
  puts 'PRODUCTO REGISTRADO'
  puts '-----------------------------------'
  esperar
end

def consultar_stock_mayor_que
  limpiar_pantalla
  imprimir_titulo('Ver productos con cantidad mayor a la ingresada')
  puts 'Ingrese el numero de stock:'
  num_min = gets.chomp.to_i
  productos = obtener_stock
  aptos = productos.select { |v| v[:stock].sum >= num_min }
  limpiar_pantalla
  imprimir_titulo("Productos mayores a #{num_min}")
  if aptos.length.zero?
    puts "Ningún producto posee stock mayor o igual a #{num_min}."
  else
    aptos.each { |v| puts "#{v[:nombre]}: #{v[:stock].sum}" }
  end
  esperar
end

def consultar_productos
  case abrir_submenu
  when 1 then mostrar_existencia_por_producto
  when 2 then mostrar_existencia_por_bodega
  when 3 then mostrar_existencia_bodegas
  end
end

def mostrar_productos_no_registrados
  limpiar_pantalla
  imprimir_titulo('Productos no registados')
  bodega = [[], [], []]
  obtener_stock.each do |v|
    bodega.each_with_index do |_, i|
      bodega[i].push(v[:nombre]) if v[:stock_raw][i] == 'NR'
    end
  end
  bodega.each_with_index do |e, i|
    puts "Bodega #{i + 1}:"
    e.each { |v| puts "  #{v}" }
  end
  esperar
end

def buscar_stock_producto
  limpiar_pantalla
  puts 'Ingrese el nombre del producto:'
  producto = obtener_producto(gets.chomp)
  if producto.nil?
    puts 'Producto no encontrado'
  else
    puts "Stock del producto '#{producto[:nombre]}': #{producto[:stock].sum}"
  end
  esperar
end

def obtener_producto(nombre)
  producto = obtener_stock.select { |e| e[:nombre] == nombre }
  if producto.length.zero?
    return nil
  else
    return producto[0]
  end
end

def mostrar_existencia_por_producto
  limpiar_pantalla
  imprimir_titulo('Mostrar la existencia por productos')
  obtener_stock.each { |v| puts "#{v[:nombre]}: #{v[:stock].sum}" }
  esperar
end

def mostrar_existencia_por_bodega
  limpiar_pantalla
  imprimir_titulo('Mostrar la existencia total por bodega')
  stock = [0, 0, 0]
  obtener_stock.each do |v|
    stock.each_with_index { |e, i| stock[i] = e + v[:stock][i] }
  end
  stock.each_with_index { |e, i| puts "Tienda #{i + 1}: #{e}" }
  esperar
end

def mostrar_existencia_bodegas
  limpiar_pantalla
  imprimir_titulo('Mostrar la existencia total de todas las bodegas')
  stock = obtener_stock.map { |v| v[:stock].sum }.sum
  puts "Stock total: #{stock}"
  esperar
end

def abrir_menu_principal
  preguntar_listado(['Consultar cantidad de productos',
                     'Mostrar stock de un producto',
                     'Ver productos no registrados',
                     'Ver productos con cantidad mayor a la ingresada',
                     'Registrar nuevo producto', 'SALIR'], 'MENU PRINCIPAL')
end

def abrir_submenu
  preguntar_listado(['Mostrar la existencia por productos.',
                     'Mostrar la existencia total por bodega.',
                     'Mostrar la existencia total en todas las bodegas.',
                     'Volver al menú principal.'], 'CONSULTAR PRODUCTOS')
end

def imprimir_listado(opciones, show_error = false)
  puts 'Seleccione una de las siguientes opciones:'
  opciones.each_with_index { |v, i| puts "#{i + 1} - #{v}" }
  puts '----------------------------------------------------'
  puts '-----------------------' if show_error
  puts 'ERROR: opción invalida.' if show_error
  puts '-----------------------' if show_error
  print 'Ingrese opción: '
end

def imprimir_titulo(titulo)
  puts "#{titulo}\n-----------------\n" unless titulo.nil?
end

def preguntar_listado(opciones, titulo = nil)
  errado = false
  loop do
    limpiar_pantalla
    imprimir_titulo(titulo) unless titulo.nil?
    imprimir_listado(opciones, errado)
    opcion = gets.chomp.to_i
    return opcion if opcion.between?(1, opciones.length)
    errado = true
  end
end

def obtener_stock
  stock = []
  File.readlines('stock.txt').each do |line|
    producto = {}
    line = line.chomp.split(', ')
    producto[:nombre] = line[0]
    producto[:stock_raw] = line[1..line.length]
    producto[:stock] = producto[:stock_raw].map(&:to_i)
    stock.push(producto)
  end
  stock
end

def esperar
  puts "\nPresione cualquier tecla antes de continuar."
  STDIN.getch
end

def limpiar_pantalla
  system 'clear'
end

main
