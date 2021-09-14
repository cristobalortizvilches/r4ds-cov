library(tidyverse)
library(datos)
setwd("C:/Users/Cristobal/Google Drive/Estudio Autónomo/Data Science con RStudio/r4ds-cov")

# Filtrar datos (filter) -----------------------------------------------------------------


vuelos
View(vuelos)

ene1 <- filter(vuelos, mes == 1, dia == 1)
ene1
sqrt(2)^2 == 2
1/49*49 == 1

filter(vuelos, mes == 11 | mes == 12)
filter(vuelos,mes==(11|12)) # devolverá un TRUE cuando mes == 11 & mes ==12, por lo que ese TRUE pasa a ser 1
#mejor usar:
nov_dic <- filter(vuelos,mes %in% c(11,12))

y <- NA
is.na(y)
y


df <- tibble(x = c(1, NA, 3))
filter(df, x > 1) # filter solo deja los TRUE, excluye FALSE y NA
filter(df, is.na(x) | x > 1) #para incluir NA hay que expresarlo explicitamente como argumento

#ejercicio
vuelos
filter(vuelos,atraso_salida >= 2)
IAH <- filter(vuelos,destino == "IAH")
?vuelos
sjmisc::frq(vuelos$aerolinea)

E3 <- filter(vuelos, aerolinea == "AA" | aerolinea == "DL" | aerolinea == "UA")
E3.1 <- filter(vuelos, aerolinea %in% c("AA","DL","UA"))

#llegaron mÃ¡s de dos horas tarde, pero no salieron tarde
#atraso_llegada & atraso_salida
E5 <- filter(vuelos,atraso_llegada > 2 & atraso_salida == 0)

#Partieron entre la medianoche y las 6 a.m. (incluyente)
E6 <- filter(horario_salida)


# Ordenar (arrange) -------------------------------------------------------


head(vuelos)
arrange(vuelos,atraso_salida) #reordena en orden creciente o ascendente según variable indicada
arrange(vuelos,desc(atraso_salida)) #reordena en orden decreciente o descendente según variable (col) indicada

#Notar que los NA siempre se ordenan al final
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
#A menos que apliquemos is.na en un desc (descending order)
arrange(df,desc(is.na(x)))


select(vuelos, anio, mes, dia) #selecciona 3 var
select(vuelos, anio:dia) #selecciona todo lo que hay entre anio y dia
select(vuelos, -(anio:dia)) #selecciona todo, exceptuando lo que hay entre anio y dia


#Hay una serie de funciones auxiliares que puedes usar dentro de select():
#starts_with("abc"): coincide con los nombres que comienzan con “abc”.
#ends_with("xyz"): coincide con los nombres que terminan con “xyz”.
#contains("ijk"): coincide con los nombres que contienen “ijk”.
#matches("(.)\\1"): selecciona variables que coinciden con una expresión regular. 
#Esta en particular coincide con cualquier variable que contenga caracteres repetidos. 
#num_range("x", 1:3): coincide con x1,x2 y x3.

#OJO: con select también se puede cambiar el nombre de la variable a la vez que se selecciona,
#pero esto no es recomendable ya que excluye todo aquello que no ha sido seleccionado. Por ej:

select(vuelos,year=anio)
rename(vuelos,year=anio)

#Otra opción es usar select() junto con el auxiliar everything().
#Esto es útil si tienes un grupo de variables que te gustaría mover al comienzo del data frame.

select(vuelos,distancia,everything())

vuelos_sml <- select(vuelos,anio:dia,starts_with("atraso"),distancia,tiempo_vuelo)

# Mutar/Crear (mutate) ----------------------------------------------------

#mutate crea nuevas variables a partir de la transformación de las ya existentes, sin embargo las mantiene.
mutate(vuelos_sml,ganancia = atraso_salida - atraso_llegada,velocidad = distancia / tiempo_vuelo * 60)

#para quedarse sólo con las variables nuevas usar
transmute(vuelos_sml,ganancia = atraso_salida - atraso_llegada,velocidad = distancia / tiempo_vuelo * 60)

#existen muchas funciones de creación utiles para usar en conjunto a mutate, el único requisito para usarlas
#es que la función deba ser "vectorizada", esto es, tomar un vector de n filas como input 
#y devolver n filas como output. Algunas de ellas:

#Rezagos: lead() y lag() te permiten referirte a un valor adelante o un valor atrás (con rezago).
#resulta útil por ejemplo para restar el sucesor de una var x (x-lead(x))

#plus: cómo dividir enteros en partes (con Aritmética modular: %/% (división entera) y %% (resto)):
transmute(vuelos,
          horario_salida,
          hora = horario_salida %/% 100,
          minuto = horario_salida %% 100)


# Resumir/Colapsar (summarise + group_by) --------------------------------------------

#colapsa bbdd en una sola fila
summarise(vuelos, atraso = mean(atraso_salida, na.rm = TRUE))

#summarise se utiliza usualmente con group_by(), que cambia la unidad de análisis desde la bbdd completa
#a cierto grupo de interés group_by(x), donde x es la variable asociada a dicho grupo

por_dia <- group_by(vuelos, anio, mes, dia)
summarise(por_dia, atraso = mean(atraso_salida, na.rm = TRUE))

#group_by() y summarise() son de las herramientas más usadas de dplyr: resúmenes agrupado


# Encadenar funciones (%>%) -----------------------------------------------

#Cltrl + Shift + M

#Pensemos por ejemplo que queremos preparar datos para graficar relación entre distancia y atraso
#Para ello procedemos de la siguiente manera:
por_destino <- group_by(vuelos, destino) #Agrupar los vuelos por destino.

atraso <- summarise(por_destino, #Resumir para calcular algunos estadísticos para (...) en cada grupo.
                    conteo = n(), #(...) distancia
                    distancia = mean(distancia, na.rm = TRUE), #(...) demora promedio
                    atraso = mean(atraso_llegada, na.rm = TRUE)) #(...) número de vuelos

atraso <- filter(atraso, conteo > 20, destino != "HNL") #Filtrar para eliminar puntos ruidosos y el aeropuerto de Honolulu, que está casi dos veces más lejos que el próximo aeropuerto más cercano.

ggplot(data = atraso, mapping = aes(x = distancia, y = atraso)) +
  geom_point(aes(size = conteo), alpha = 1/3) +
  geom_smooth(se = FALSE)

#Sin embargo, podemos simplificar la preparación de datos con %>%

atraso <- vuelos %>% #agrupa
  group_by(destino) %>% #luego resume
  summarise(conteo = n(),
            distancia = mean(distancia, na.rm = TRUE),
            atraso = mean(atraso_llegada, na.rm = TRUE)) %>% #luego filtra
  filter(conteo > 20, destino !="HNL")


# Valores faltantes (na.rm) -----------------------------------------------

#na.rm: omitir valores NA en funciones de agregación

#caso1: no removemos NA por lo que todo el vector mean se vuelve NA (basta con que atraso_salida tenga un sólo NA)
vuelos %>% 
  group_by(anio, mes, dia) %>% 
  summarise(mean = mean(atraso_salida))
#caso 2: aplico el argumento na.rm = TRUE para indicar que excluya a los NA del calculo de mean
vuelos %>% 
  group_by(anio, mes, dia) %>% 
  summarise(mean = mean(atraso_salida, na.rm = TRUE))

#caso3: alternativamente podemos excluir los NA con un filter
no_cancelados <- vuelos %>% #luego filtra dejando todo lo que no sea NA en atrado_salida y atraso_llegada
  filter(!is.na(atraso_salida), !is.na(atraso_llegada))

no_cancelados %>% 
  group_by(anio, mes, dia) %>% 
  summarise(mean = mean(atraso_salida))

# Conteos (n()) -----------------------------------------------------------------

#En toda agregación (summarise+group_by) es util incluir un conteo con n() o sum(!is.na(x))

#aviones (identificados por su número de cola) que tienen las demoras promedio más altas:
atrasos <- no_cancelados %>% #uso bbdd sin NA
  group_by(codigo_cola) %>% #agrupo por aviones
  summarise(atraso = mean(atraso_llegada)) #creo nueva var "atraso" que resume la media de atraso_llegada según codigo_cola

ggplot(data = atrasos, mapping = aes(x = atraso)) + 
  geom_freqpoly(binwidth = 10)

#al código anterior agregamos un conteo de modo que este se pueda graficar de manera explícita
atrasos <- no_cancelados %>% 
  group_by(codigo_cola) %>% 
  summarise(
    atraso = mean(atraso_llegada),
    n = n())
#ahora si graficamos incluyento el conteo como argumento de aes
ggplot(data = atrasos, mapping = aes(x = atraso, y = n)) + 
  geom_point(alpha = 1/10)

#también podemos filtrar casos con n bajo y unir encadenamiento dplyr con estructura ggplot2
atrasos %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = atraso, y = n)) + 
  geom_point(alpha = 1/10)

#de manera alternativa a n() que es un argumento de summarise(x), 
#podemos usar count(x) que es una función por sí sola:
no_cancelados %>% 
  count(codigo_cola)
#también podemos añadir un argumento que es una variable de ponderación:
no_cancelados %>%
  count(codigo_cola, wt = distancia) #es este n serpa los km de distancia asociados a codigo_cola

# Funciones de resumen útiles ---------------------------------------------

#Sirven para se utilizadas dentro de summarise:

#mean(x) media
#median(x) mediana
#sd(x) desviación estándar
#IQR() rango intercuartil 
#mad(x) desviación media absoluta
#sum(x) sumatoria
#min(x) valor mínimo
#max(x) valor máximo
#quantile(x, X%) valor del percentil X% (?)
#n() cantidad de casos
#sum(!is.na(X)) cantidad de casos no faltantes
#n_distinct(x) cantidad de valores distintos o únicos

#Conteos y proporciones de valores lógicos: sum(x > 10), mean(y == 0). NO ENTIENDO BIEN
#Cuando se usan con funciones numéricas, TRUE se convierte en 1 y FALSE en 0. 
#Esto hace que sum() y mean() sean muy útiles: sum(x) te da la cantidad de TRUE en x, y mean(x) te da la proporción.
# ¿Cuántos vuelos salieron antes de las 5 am? 
# (estos generalmente son vuelos demorados del día anterior)
no_cancelados %>% 
  group_by(anio, mes, dia) %>% 
  summarise(n_temprano = sum(horario_salida < 500))

# ¿Qué proporción de vuelos se retrasan más de una hora?
no_cancelados %>% 
  group_by(anio, mes, dia) %>% 
  summarise(hora_prop = mean(atraso_llegada > 60))


# Agrupación por múltiples variables --------------------------------------

#Cuando agrupas por múltiples variables, cada resumen se desprende de un nivel de la agrupación
#por ejemplo, queremos agrupar por año, mes y día, y de ello resumir un conteo de cada combinación posible entre dichas var
diario <- vuelos %>% 
  group_by(anio,mes,dia) %>% 
  summarise(n())

#alternativamente, puedo escribir la misma operación en dos comandos:
diario <- group_by(vuelos, anio, mes, dia)
(por_dia   <- summarise(diario, vuelos = n()))
#de esta manera, puedo ir utilizando los nuevos objetos creados de forma acumulativa
(por_mes <- summarise(por_dia, vuelos = sum(vuelos)))
#ahora por año
(por_anio  <- summarise(por_mes, vuelos = sum(vuelos)))


# Desagrupar --------------------------------------------------------------

#Si necesitas eliminar la agrupación y regresar a las operaciones en datos desagrupados, usa ungroup()

diario %>% 
  ungroup() %>% # ya no está agrupado por fech
  summarise(vuelos = n()) # todos los vuelos


# Transformaciones (y filtros) agrupadas ----------------------------------

#La agrupación resulta mejor con summarise, sin embargo, también se puede usar junto a mutate() y filter()
#Un filtro agrupado es una transformación agrupada seguida de un filtro desagrupado

#ejemplo 1: peores miembros de cada grupo 
vuelos_sml %>% 
  group_by(anio, mes, dia) %>%
  filter(rank(desc(atraso_llegada)) < 10)

#ejemplo 2:  todos los grupos más grandes que un determinado umbral
destinos_populares <- vuelos %>% 
  group_by(destino) %>% 
  filter(n() > 365)
destinos_populares


# R Project ---------------------------------------------------------------

library(tidyverse)
library(datos)

ggplot(diamantes, aes(quilate, precio)) + 
  geom_hex()
ggsave("diamantes.pdf")

write_csv(diamantes, "diamantes.csv")
