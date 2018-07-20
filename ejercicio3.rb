def contar_palabras(string)
  string.scan(/\w+/).length
end

def contar_coincidencias(string, palabra)
  string.scan(/#{palabra}/i).length
end

documento = File.open('peliculas.txt', 'r').read

puts contar_palabras(documento)
puts contar_coincidencias(documento, 'de')
