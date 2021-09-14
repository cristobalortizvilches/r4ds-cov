# 1. Como crear una función ---------------------------------------------------------------

#Funciones son código reutilizable que permite automatizar tareas (mismo código a diferentes inputs)
#se usan cuando has copiado y pegado un bloque de código más de dos veces 
#Por ejemplo queremos reescalar entre 0 y 1:

df <- tibble::tibble(a = rnorm(10), b = rnorm(10), c = rnorm(10), d = rnorm(10)) #creamos un df

#Queremos reescalas los valores de df entre 0 y 1
df$a <- (df$a - min(df$a, na.rm = TRUE)) /
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) /
  (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE)) #aquí hay error de arrastre ($a en vez de $b)
df$c <- (df$c - min(df$c, na.rm = TRUE)) /
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) /
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))
#No obstante, esto es ineficiente, repetitivo y podemos incurrir en errores de copy/paste al no reemplazar bien.
#Ante esto, es factible y deseable crear una función.

#Para escribir una función lo primero es fijarnos en el número de inputs
(df$a - min(df$a, na.rm = TRUE)) /
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
#En este caso, sólo hay un input (df$a) ya que na.rm = TRUE no cuenta como input (es un valor del entorno?).
#Para asegurarse del número de inputs, es buena idea reescribir el código con nombres de variables genéricos
x <- df$a
(x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
#notamos que estamos computando el rango 3 veces, por lo cual se puede simplificar usando "range":
 rng <- range(x, na.rm = TRUE)
(x - rng[1]) / (rng[2] - rng[1])

#Una vez que simplificamos el código, podemos convertirlo a función:
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
#la probamos
rescale01(c(0,5,10)) #notamos que efectivamente reescala entre 0 y 1

#Hay tres pasos claves para crear una función nueva:
#1. elegir un nombre indicativo para la función.
#2. listar inputs, o argumentos, de la función dentro de function.
#3. situar el código que has creado en el cuerpo de una función, un bloque de { que sigue inmediatamente a function(...).

#finalmente, escribimos nuevamente el código usando la función creada

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

#de manera adicional, podemos cambiar los requerimientos de la función ante posibles fallas, por ejemplo:

x <- c(1:10, Inf)
rescale01(x)

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(x)


# 2. Ejecución condicional ---------------------------------------------------

#Una sentencia if (si) te permite ejecutar un código condicional. Por ejemplo:

if (condition) {
  # el código que se ejecuta cuando la condición es verdadera (TRUE)
} else {
  # el código que se ejecuta cuando la condición es falsa (FALSE)
}

if (c(TRUE, FALSE)) {}


# 3. Condiciones múltiples ---------------------------------------------------


if (this) {
  # haz aquello
} else if (that) {
  # haz otra cosa
} else {
  #
}

# 4. Estilo de código --------------------------------------------------------

#La llave de apertura nunca debe ir en su propia línea y siempre debe ir seguida de una línea nueva. 
#Una llave de cierre siempre debe ir en su propia línea, a menos que sea seguida por else

# Bien
if (y < 0 && debug) {
  message("Y es negativo")
}

if (y == 0) {
  log(x)
} else {
  y ^ x
}

# Mal
if (y < 0 && debug)
  message("Y is negative")

if (y == 0) {
  log(x)
}
else {
  y ^ x
}

# 5. Argumentos de funciones -------------------------------------------------

#Los argumentos de las funciones normalmente están dentro de dos conjuntos amplios: 
#1. datos a computar 
#2. argumentos que controlan los detalles de la computación. 
# Por ejemplo: En mean(), los datos son x 
#y los detalles son la cantidad de datos para recortar de los extremos (trim) y cómo lidiar con los valores faltantes (na.rm).

# Computar intervalo de confianza alrededor de la media usando la aproximación normal 
mean_ci <- function(x, conf = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - conf
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

x <- runif(100)
mean_ci(x)
#> [1] 0.4976111 0.6099594
mean_ci(x, conf = 0.99)
#> [1] 0.4799599 0.6276105

# 6. Nombres de argumentos convencionales ------------------------------------

#x, y, z: vectores.
#w: un vector de pesos.
#df: un data frame.
#i, j: índices numéricos (usualmente filas y columnas).
#n: longitud, o número de filas.
#p: número de columnas.

#En caso contrario, hacerlos coincidir con nombres de argumentos de funciones de R que ya existen. 
#Por ejemplo, usa na.rm para determinar si los valores faltantes deberían ser eliminados.

# 7. Chequear valores --------------------------------------------------------

#Se usa cuando queremos verificar si los argumentos que indicamos a f(x) son adecuados
#para la lógica de la misma o, lo que sería lo mismo, verificar si los inputs de la f(x) son válidos.
#Para evitar aquello, es útil incorporar restricciones explícitas dentro de la f(x).

#Partamos de un ejemplo, supongamos que queremos calcular estadísticos ponderados
wt_mean <- function(x, w) {
  sum(x * w) / sum(w)
}
wt_var <- function(x, w) {
  mu <- wt_mean(x, w)
  sum(w * (x - mu) ^ 2) / sum(w)
}
wt_sd <- function(x, w) {
  sqrt(wt_var(x, w))
}

#una vez creada, la ponemos en práctica:
wt_mean(1:6, 1:3)
#pero notamos que x y w (argumentos de la función), no tienen la misma longitud, siendo que debería se así.
#ante esto, podemos agregar una advertencia que indique que x y w deben ser de la misma longitud
#esto lo hacemos con stop() antes del argumento principal de la f(x)

wt_mean <- function(x, w) {
  if (length(x) != length(w)) {
    stop("`x` y `w` deben tener la misma extensión", call. = FALSE)
  }
  sum(w * x) / sum(w)
}
#luego corremos el mismo código
wt_mean(1:6, 1:3) #no devuelve la advertencia con el error indicado en la función
#en cambio, si corregimos:
wt_mean(1:6,7:12) #ahora si devuelve un valor adecuado

#ahora bien, no es una buena práctica agregar muchas restricciones, por ejemplo así:

wt_mean <- function(x, w, na.rm = FALSE) {
  if (!is.logical(na.rm)) {
    stop("`na.rm` debe ser lógico")
  }
  if (length(na.rm) != 1) {
    stop("`na.rm` debe tener extensión 1")
  }
  if (length(x) != length(w)) {
    stop("`x` y `w` deben tener la misma extensión", call. = FALSE)
  }
  
  if (na.rm) {
    miss <- is.na(x) | is.na(w)
    x <- x[!miss]
    w <- w[!miss]
  }
  sum(w * x) / sum(w)
}

#esto supone mucho trabajo, lo mejor sería incorporar:
stopifnot() #comprueba que cada argumento sea TRUE, en caso contrario devuelve error

wt_mean <- function(x, w, na.rm = FALSE) {
  stopifnot(is.logical(na.rm), length(na.rm) == 1)
  stopifnot(length(x) == length(w))
  
  if (na.rm) {
    miss <- is.na(x) | is.na(w)
    x <- x[!miss]
    w <- w[!miss]
  }
  sum(w * x) / sum(w)
}
wt_mean(1:6, 6:1, na.rm = "foo")
#> Error in wt_mean(1:6, 6:1, na.rm = "foo"): is.logical(na.rm) is not TRUE

#Ten en cuenta que al usar stopifnot() afirmas lo que debería ser cierto 
#en vez de verificar lo que podría estar mal.

# 8. Punto-punto-punto (...) -------------------------------------------------

#PENDIENTE, NO ENTENDI NADA

# 9. Valores de retorno ------------------------------------------------------

#al crear funciones se vuelve fundamental saber que es lo que debería devolver la función
#el valor devuelto por una función suele ser la última sentencia que esta evalúa
#pese a ello, podemos devolver un valor anticipadamente utilizando return()

#PENDIENTE, NO ENTENDI MUCHO


# 10. Hallar valores en el entorno --------------------------------------------

#R permite incorporar en el cuerpo de la función argumentos/valores que NO están definidos al interior de la misma. 
#Esto ocurre ya que, al ser un lenguaje de objetos, R permite la función interactúe con objetos que están
#precargados en el entorno de trabajo. 



# X. Estructura de una función --------------------------------------------

function_name <- function(inputs) {
  output_value <- do_something(inputs)
  return(output_value)
}

#lo que está dentro de {} es código que se ejecuta en conjunto, por ejemplo:
{
  a = 2
  b = 5
  a + b
}

#ejemplo para calcular volumen:
calc_vol <- function(largo,ancho,alto) {
  area <- largo * ancho
  volumen <- area * alto
  return(volumen)
}
cacl_vol(0.8, 1.6, 2.0) 


# Y. Función con condicional ----------------------------------------------

##. Y.1. Con un argumento ----
signo <- function(x) {
  if(x > 0) {
    print("Numero positivo")
  }
  else if(x < 0) {
    print("Numero negativo")
  }
  else {
    print("Cero") #si quisiera hacer una condición para 0 sería if(x == 0)
  }
}
signo(1)
#> "Numero positivo"
signo(-1)
#> "Numero negativo"
signo(0)
#> "Cero"
