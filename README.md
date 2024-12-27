# Lab1 Paradigmas
Fue desarrollado por:
### Los Hackermans

* Federico Virgolini <fvirgolini@gmail.com>
* Gonzalo Garcia Zurlo <gonzalogarciazurlo@gmail.com>
* Santiago Monserrat Campanello <smonserratcampanello@gmail.com>

## Preguntas
1.
    - ¿Por qué están separadas las funcionalidades en los módulos indicados? Explicar detalladamente la responsabilidad de cada módulo.
    - El código original no está del todo prolijo. ¿Harían alguna modificación a la partición en módulos dada? ¿Qué otros cambios creen necesarios? Justificar e implementar los cambios.

Los módulos se encuentran separados debido a su diferente funcionalidad. Modularizar el código es de gran utilidad para diferenciar correctamente cada una de las partes que componen una solución al problema que se desea resolver. A su vez, esto nos permite encontrar errores con mayor facilidad.

El módulo `Dibujo.hs` implementa la sintaxis de nuestro programa, definiendo en primer lugar definiendo los constructores del tipo Dibujo. Allí también se definen las funciones que utilizaremos con este tipo.

Por otro lado, `Interp.hs` implementa la semántica del lenguaje que estamos creando. Es decir, implementa los comportamientos que tendrán nuestras funciones. Esto lo hace utilizando vectores.

En tercer lugar, `Main.hs` es el módulo encargado de coordinar todos los demás. Es aquí también donde se realizan las configuraciones de parámetros para la correcta ejecución del programa. Este módulo es el que finalmente muestra los dibujos utilizando la librería Gloss.

Finalmente, en los archivos situados en `Basica/` se define un tipo para instanciar Dibujo, y se define la interpretación de las figuras básicas.

Creemos que la partición de módulos dada es correcta. No vemos la necesidad de realizar cambios a la disposición propuesta.

2. ¿Por qué las funciones básicas no están incluidas en la definición del lenguaje, y en vez es un parámetro del tipo?

Esto se debe a que la interpretación puede ser diferente dependiendo el caso. Esto significa que la persona que utilice el tipo Dibujo será quien determine la definición según su forma de verlo o conveniencia. De esta forma, el tipo se podrá adaptar a cada situación según la necesidad.

3. Explique cómo hace Interp.grid para construir la grilla, explicando cada pedazo de código que interviene. ¡Ojo! Si mal no recuerdo hay un error sutil…

`hlines` crea una lista infinita de lineas horizontales desde el vector (x,y), con un ancho mag y separación entre ellas de sep.

`grid` toma n+1 (para que la grilla sea de n x n) elementos de la lista infinita de lineas y crea un picture de dos elementos, una con las lineas horizontales y las mismas lineas rotadas 90°


## Experiencias/Comentarios

Para empezar, como grupo ya tuvimos la oportunidad de trabajar juntos en otros proyectos, pero en este caso, al ser la primera vez en trabajar sobre el paradigma funcional, pudimos experimentar otra forma completamente distinta de encarar los problemas. A la hora de buscar una solución, de por ejemplo implementar una función x, tuvimos que dejar el teclado y ocupar la mayor parte del tiempo en pensar como razonaríamos esto desde una perspectiva declarativa, es decir, en otras ocasiones nos hubiéramos puesto a escribir código e ir viendo en el camino como solucionaríamos los errores que íbamos cometiendo, pero en este laboratorio una vez resuelto el problema abstractamente, simplemente traducíamos ese pensamiento en pocas lineas de código.

Lo que más costoso nos resulto fue el inicio, el estar acostumbrado a trabajar en otros paradigmas nos jugo en contra. En específico estuvimos un buen tiempo intentando comprender el funcionamiento de la función sem y lo que implicaba en la implementación de las siguientes funciones que la utilizarían.     

Una vez que ya implementamos los módulos Dibujo.hs y Inter.hs, lo demás nos resulto más fácil (o intuitivo al menos), el hecho de poder ver gráficamente lo que estábamos construyendo nos ayudo mucho.   

Podemos incluir también que a medida que íbamos trabajando, a cada uno se nos ocurrían distintas formas de escribir en el código lo que estábamos pensando como solución abstracta al problema. Finalmente terminamos eligiendo la versión que considerábamos más elegante o prolija.

Nos hubiera gustado hacer mas puntos estrella (sobre todo el de dibujar otras cosas), pero por complicaciones con tiempo no nos fue posible, sin embargo pudimos agregar una figura mas (esto esta en otro branch) la cual es el triangulo de Sierpinski.
   
En conclucion nos parecio un proyecto muy particular, en los sentidos explicados anteriormente, y una experiencia muy buena en la que nos gusto trabajar y creemos que nos ayudara para proximos trabajos.