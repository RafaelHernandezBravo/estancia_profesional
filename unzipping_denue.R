# Define la ruta base donde se guardarán los archivos descargados
ruta_base <- "denue_11_2024/"

lista_paths = list.files(path = ruta_base, pattern = ".zip$", full.names = T)

for(i in 1:length(lista_paths)) {
  print(i)
  unzip(lista_paths[i],exdir = gsub(lista_paths[i], pattern = "zip", replacement = ""))
}

