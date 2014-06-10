$(function(){  
/* Con esto se esta diciendo "una vez que se cargue el sitio", 
cuando eso se cumpla se sigue con lo demas */  
  
$('#busqueda_avanzada').toggle(function(){  
/* Usamos la funcion toggle, que sirve para hacer cierta acción con el primer click 
y otra con el segundo. Los clicks se deben hacer sobre #login que es el 
identificador de "login" en nuestro menu */  
  
$('#busqueda_form').slideDown();  
/* Con el primer click, hacemos que el formulario se despliegue hacia abajo */  
  
},function(){   
  
//y con el segundo click...  
  
$('#busqueda_form').slideUp();  
// hacemos que el formuario se "guarde" hacia arriba  
  
}); //cerramos la funcion que realiza toggle  
  
}); //cerramos las funciones 