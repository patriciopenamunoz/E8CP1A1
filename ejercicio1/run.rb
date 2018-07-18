# - Crear un método que reciba dos strings, este método creará un archivo
# index.html y pondrá como párrafo cada uno de los strings recibidos.

# - Crear un método similar al anterior, que además pueda recibir un arreglo.
# Si el arreglo no está vacío, agregar debajo de los párrafos una lista
# ordenada con cada uno de los elementos.

# - Crear un tercer método que además pueda recibir un color.
# Agregar color de fondo a los párrafos.

# - El retorno de los métodos debe devolver nil.
def generar_2_parrafos(string1, string2)
  crearHTML('index.html', "<p>#{string1}</p>\n<p>#{string2}</p>")
  nil
end

def generar_lista_parrafos(listado)
  parrafos = ''
  listado.each { |v| parrafos += "<p>#{v}</p>\n" }
  crearHTML('listado_parrafos.html', parrafos)
end

def generar_lista_parrafos_coloridos(listado, color)
  parrafos = ''
  listado.each { |v| parrafos += "<p style='color:#{color};'>#{v}</p>\n" }
  crearHTML('listado_parrafos_coloridos.html', parrafos)
end

def crearHTML(nombre_archivo, contenido)
  file = File.open(nombre_archivo, 'w')
  file.puts <<-HTML_CONT
  <!DOCTYPE html>
  <html lang="en" dir="ltr">
    <head>
      <meta charset="utf-8">
      <title></title>
    </head>
    <body>
      #{contenido}
    </body>
  </html>
  HTML_CONT
  file.close
end

generar_2_parrafos('hola', 'mundo')
generar_lista_parrafos(%w[hola mundo aquí estoy])
generar_lista_parrafos_coloridos(%w[hola mundo aquí estoy], 'red')
