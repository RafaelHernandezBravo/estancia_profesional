df = read.csv("diccionario_denue_11_2024.csv", encoding = "latin1")
# Obtener la lista de archivos .csv
lista_archivos = list.files(path = "denue_11_2024", pattern = "",full.names = T, recursive = T)
# NOTA: se están descargando solamente 24 de 25 archivos, por lo que es necesario
# revisar el contenido de las carpetas descomprimidas, el siguiente código lo permite.
#lista_directorios = lista_archivos[!grepl(lista_archivos, pattern = ".zip")]
#lapply(lista_directorios, function(x)list.files(x,recursive = T))
#lista_directorios[[21]]

A = grep(lista_archivos, pattern = "denue_inegi.+\\.csv$", value = T)
fx = function(x) {
  D = read.csv(A[x], colClasses = "character")
  id = paste(D$cve_ent, D$cve_mun, sep="_")
  as.data.frame.matrix(table(id, D$codigo_act))}

Z = lapply(1:length(A), fx)
nombres = gsub(gsub(A, pattern = ".+/", replacement = ""), pattern = "(_|).csv", replacement = "")
ueconomicas = gsub(gsub(A, pattern = "\\./conjunto.+", replacement = ""), pattern = ".+/", replacement = "")
names(Z) = nombres
saveRDS(Z, "NOMBRE.rds")