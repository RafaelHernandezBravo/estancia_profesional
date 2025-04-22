# RUTA AL DIRECTORIO DE TRABAJO

# ESTABLECER DIRECTORIO DE TRABAJO
# ver contenido del directorio 
df = read.csv("diccionario_denue_11_2024.csv", encoding = "latin1")
# Creando directorio denue
dir_path = "denue_11_2024"
if (dir.exists(dir_path)) {
  unlink(dir_path, recursive = TRUE)
}
dir.create(dir_path)

# LOOP MEJORADO
options(timeout = 600)

for (i in 1:nrow(df)) {
  print(i)
  download_url <- df$descarga_csv[i] # Asumiendo que df$descarga_csv contiene las URLs
  file <- df$Act...Economica[i] # Asumiendo que quieres usar esto para nombres de archivos
  print(file)
  
  # Limpia el nombre del archivo para evitar problemas con caracteres especiales
  file_clean <- gsub("[^[:alnum:]_.-]", "_", file) # Reemplaza caracteres no alfanuméricos con guiones bajos
  
  tryCatch({
    download.file(download_url, destfile = paste0("denue_11_2024/", file_clean, ".zip"), mode = "wb")
    print(paste("Descarga exitosa:", file_clean, ".zip"))
  }, error = function(e) {
    print(paste("Error al descargar", file_clean, ".zip:", e$message))
  })
}


