/*INGRESAR SOLO NUMEROS*/
      function isNumberKey(evt)
      {
		 var obj_age_hora = document.getElementById("diaries_index_age_hora");
		 var obj_age_hora_edit = document.getElementById("diaries_edit_age_hora");
		 obj_age_hora_edit.maxLength = 8;
		 obj_age_hora.maxLength = 8;
		 var charCode = (evt.which) ? evt.which : event.keyCode
		 var numCurrent = this.value + String.fromCharCode(charCode);
		 var longitud = numCurrent.length;
		 //alert(numCurrent);
		 /*PARA CONTROLAR EL RANGO DE NUMERO*/
		/*if(numCurrent<0) {
			return false;
		}*/
		
		if((charCode>47 && charCode<59) || charCode==08){
			return true;
		}
		
		
		
		
		 /*PARA INGRESAR SOLO NUMEROS, BACKSPACE, DOS PUNTOS*/
        /* if (charCode > 31 && (charCode < 48 || charCode > 57) && charCode!=58 && charCode!=08){
			alert("condicion 1");
			return false;
		 }
		 if (numCurrent>23){
			return false;
			alert("condicion 2");
		 }
		 if (numCurrent.length>2){
			alert("condicion 3");
			return false;
		 }
		 if (numCurrent.length!=3 && charCode==58){
			alert("condicion 4");
			return false;
		 }*/
		/*if(numCurrent>23 || (numCurrent.length>2 && charCode!=08 && numCurrent.length==3 && charCode!=58)){
			alert("condicion 2");
			return false;
		 }*/
		
		/*PARA CONTROLAR FORMATO DE HORA EN HH:MM:SS*/
		//var numBack = this.value;
		//if (numCurrent.length>2 && (charCode!=08 ))
			//return false;
		//alert(numCurrent.length);
		
		/*var regex = /^\d+(?:\.\d{0,2})$/;
		var numBack = this.value;
		for(i=0;i<numBack.length;i++){
			if (numBack[i]=="." && charCode!=8){
				var numStr = this.value + String.fromCharCode(charCode);
				if (regex.test(numStr))
					{}
				else
					{return false;}
			}
		}*/
        //return true;
		return false;
      }