/*INGRESAR SOLO NUMEROS*/
      function isNumberKey(evt)
      {
		 var charCode = (evt.which) ? evt.which : event.keyCode
		 var numCurrent = this.value + String.fromCharCode(charCode);
		 //alert(numCurrent);
		 /*PARA CONTROLAR EL RANGO DE NUMERO*/
		if(numCurrent>20 || numCurrent<0) {
			return false;
		}
		
		 /*PARA INGRESAR SOLO NUMEROS*/
         if (charCode > 31 && (charCode < 48 || charCode > 57) && charCode!=46)
            return false;
		
		/*PARA CONTROLAR SOLO DECIMALES*/
		var regex = /^\d+(?:\.\d{0,2})$/;
		var numBack = this.value;
		for(i=0;i<numBack.length;i++){
			if (numBack[i]=="." && charCode!=8){
				var numStr = this.value + String.fromCharCode(charCode);
				if (regex.test(numStr))
					{}
				else
					{return false;}
			}
		}
		
		//var regex = /^\d+(?:\.\d{0,2})$/; var numStr = "123.20"; if (regex.test(numStr)) alert("Numero incorrecto: " + numStr);
		
         return true;
      }