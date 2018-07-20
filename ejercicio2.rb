File.open('peliculas.txt', 'r') { |file| puts file.read.split("\n").length }
