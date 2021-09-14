#Estructura de datos en R

#1. vectores
#2. Listas
#3. Dataframe


# Vectores ----------------------------------------------------------------

#Estructura fundamental de datos en R
#Son unidimensionales
#Son homogeneos (todos su elementos son de un mismo tipo)

## Tipos de vectores ----

#numérico (numeric)
xn <- c(1, 2, 3, 4, 5) #función c sirve para combinar valores en un vector
class(xn) #numeric

#texto (character)
xt <- c("uno","A")
class(xt) #character

xnt <- c(1, "UNO")
class(xnt) #character (pese a combinar un número y texto, los devuelve a el tipo común)
xnt

#lógico (logical)
xl <- c(T, F, F, T)
class(xl)

#factores (factors): 
#es un tipo de vector de texto, pero la diferencia es que sus valores se almacenan como número (levels)
#R almacena y trabaja estos levels como si fueran números y asocia una etiqueta (label) a cada valor
#son útiles para almacenar datos categóricos. 
#Se crean con la función factor() a la cual le suministro un vector de cualquier tipo, por ejemplo:

xf <- factor(c("hombre", "mujer", "mujer"),
             levels = c("hombre", "mujer"), #importa el orden
             labels = c("Hombre","Mujer"))

plot(xf)

## Generar vectores ----

# Funcion rep() 
#OJO, el primer argumento puede ser cualquier tipo de vector
v1 <- c(1,2,3)

rep(v1, times = 3) #repite el primer argumento la cantidad de veces indicada en times
#> 1 2 3 1 2 3 1 2 3
rep(v1, each = 3) #repite el primer argumento 
#> 1 1 1 2 2 2 3 3 3

## Función sep()
#Genera una secuencia de números 
seq(from = 1, to = 10) 
#es lo mismo que:
1:10

seq(from = 10, to = 20, by = 2) #ir de 10 a 20 saltando de 2 en 2
#es lo mismo que:
seq(10, 20, 2)

## Acceder a subconjuntos de vectores ----

#se puede acceder a elementos de un vector especificando un vector índice, es decir, 
#un vector de números dentro de [] (lo que va dentro del corchete se le llama índice). Ejemplo:

(xsub <- seq(0, 50, 5)) #creamos un vector numérico de 0 a 50 saltando de 5 en 5
#> 0  5 10 15 20 25 30 35 40 45 50
x[2] #me entrega el segundo elemento o la posición n° dos
#> 5
x[c(1, 10)] #me entrega el primer y penúltimo elemento de vector
#> 0 45
x[4:7] #me entrega del 4to a 7mo elemento del vector 
#> 15 20 25 30

#otra alternativa es a través de vectores lógicos 
#OJO, vector lógico debe tener la misma longitud que el vector original
(xlo <- seq(0, 20, 5)) 
#0  5 10 15 20
xlo[c(T,T,F,F,F)] #me entrega solo los TRUE, es decir, los primeros dos elementos
#> 0 5

#lo anterior sirve para establecer condiciones lógicas, por ejemplo:
(cond1 <- xlo > 10)
#> FALSE FALSE FALSE  TRUE  TRUE #entrega como TRUE todo los valores mayores a 10
#luego, puedo pedir que devuelva los valores que complen la condición:
xlo[cond1] # es lo mismo que x[x > 10]
#> 15 20


# Funciones vectorizadas --------------------------------------------------

#R está orientado a operaciones vectorizadas, es decir, la mayoría de las f(x) se aplican
#sobre un vector y devuelven como resultado otro vector (esto evita que usemos loop). Ejemplo
(xvect <- seq(10, 100, 20))
log(xvect) #me entrega cada logaritmo del vector
#PERO, esto no siempre es así, existen funciones que devuelven un sólo resultado
mean(xvect)

## Operadores lógicos ----

#es un tipo de función vectorizada
#me devuelven como resultado si es que una f(x) se cumple o no. Ejemplo:

(xopl <- 1:10)
#>  1  2  3  4  5  6  7  8  9 10
xopl > 5 #operador lógico que evalúa la condición (>) en cada elemento del vector 
#> FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  

xopl %in% c(3, 7) #evalúa si los elementos 3 y 7 se encuentran dentro del vector 
#> FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE

#otro ejemplo bueno:
(xopl2 <- rep(c("hombre","mujer","otros"), times = 3))
#> "hombre" "mujer"  "otros"  "hombre" "mujer"  "otros"  "hombre" "mujer"  "otros" 
xopl2[xopl2 %in% c("hombre","mujer")] #devuelve sólo categorías hombre y mujer, es decir, sólo los TRUE (ver abajo)
xopl2 %in% c("hombre", "mujer")
#> TRUE  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE