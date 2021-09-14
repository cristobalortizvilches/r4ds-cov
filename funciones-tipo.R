
# Agregar nuevo vetor a df ------------------------------------------------

add.vect.df <- fuction(df, vect) { #indico los argumentos (inputs)
  new.df <- cbind((df, vect))      #procesamiento de los inputs que me entrega un resultado
  return(new.df)                   #indico a la función que devuelva el resultado (output)
}
