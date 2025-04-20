##ERROREES

df = read.csv("diccionario_denue_11_2024.csv", encoding = "latin1")
### Objetivo: Tener en una misma carpeta "conjunto_de_datos" TODOS los archivos .csv ###
# Define la ruta base donde se guardarán los archivos descargados
ruta_base <- "denue_11_2024/conjunto_de_datos_11_2024/"

for (i in 1:nrow(df)) {
  print(i)
  download_url <- df$descarga_csv[i]
  file <- df$Act...Economica[i]
  
# Limpia el nombre del archivo para evitar problemas con caracteres especiales
  file_clean <- gsub("[^[:alnum:]_.-]", "_", file)
  
  tryCatch({
    # Construye la ruta completa para guardar el archivo .csv
    ruta_completa <- paste0(ruta_base, file_clean, ".csv")
    
    # Descarga el archivo y lo guarda en la carpeta conjunto_de_datos
    download.file(download_url, destfile = ruta_completa, mode = "wb")
    
    print(paste("Descarga exitosa:", file_clean, ".csv"))
  }, error = function(e) {
    print(paste("Error al descargar", file_clean, ".csv:", e$message))
  })
}
