class AvaluosController < ApplicationController
  def index

  end

  def new
    inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>"2",:user_id=>current_user}, :personas_constructions_roles=>{:construction_id => params[:construction_id]}).uniq
#    if current_user and inmuebles_current.exists? and inmuebles_current.find(params[:construction_id])
    if (current_user and current_user.id == 1) or (current_user and inmuebles_current.exists? and inmuebles_current.find(params[:construction_id]))
      @tabla_avaluo = Price.find(:all)
      #@imueble_tabla_avaluo = ConstructionsPrice.new

      @parametro = Parameter.find(:all)
      @inmueble_parametro = ConstructionsParameter.new
      #@id = params[:construction_id]

      @met_depr = Rebate.find(:all)
      @inmueble_met_depr = ConstructionsState.new

      @inmueble = Construction.find(params[:construction_id])

      #VALORES INICIALES DEL ARREGLO
      @taa_areas = []
      @taa_unitarios = []
      @taa_totales = []
      @taa_val_real = 0
      @taa_val_merc = 0

      @description_actual = []
      @description_actual_valor = []
      @sumatoria1 = 0

      @state_actual = []
      @state_actual_valor = []
      @sumatoria2 = 0

      #CUANDO SE VA A EDITAR EL AVALUO DE UN INMUEBLE
      @tabla_avaluo_actual = ConstructionsPrice.where(:construction_id => params[:construction_id])
      @parametro_actual = ConstructionsParameter.where(:construction_id => params[:construction_id])
      @met_depr_actual = ConstructionsState.where(:construction_id => params[:construction_id])



      price_count = Price.find(:all).count()
      parameter_count = Parameter.find(:all).count()
      rebate_count = Rebate.find(:all).count()
      #SI EXISTE UN INMUEBLE CON AVALUO SE PROCEDE A EDITAR
      if @tabla_avaluo_actual.exists?
        #PARA CARGAR LOS VALORES DE TABLA AVALUO
        for i in 0..(price_count-1)
          #CUANDO SE AGREGA UN NUEVO REGISTRO PARA LA TABLA DE AVALUO
          if @tabla_avaluo_actual[i]!=nil
            @taa_areas[i] = @tabla_avaluo_actual[i].det_area
            @taa_unitarios[i] = @tabla_avaluo_actual[i].det_val_unit
            @taa_totales[i] = @tabla_avaluo_actual[i].det_val_tot
          else
            @taa_areas[i] = 0
            @taa_unitarios[i] = 0
            @taa_totales[i] = 0
          end
        end
        #@taa_val_real = @inmueble.inm_val_real
        #@taa_val_merc = @inmueble.inm_val_merc

        #PARA CARGAR LAS DESCRIPCIONES Y VALOR UNITARIO DE LOS PARAMETROS DE AVALUO
        for i in 0..(parameter_count-1)
          #@description_actual[i] = Description.where(:id => @parametro_actual[i].description_id).pluck(:id)
          #CUANDO SE AGREGA UN NUEVO PARAMETRO DE AVALUO
          if @parametro_actual[i]!=nil
            id_descrip_actual = Description.find(@parametro_actual[i].description_id)
            @description_actual[i] = id_descrip_actual.id
            val_descrip_actual = Description.find(@parametro_actual[i].description_id)
            @description_actual_valor[i] = val_descrip_actual.param_val_unit
            @sumatoria1 += val_descrip_actual.param_val_unit
          else
            @description_actual_valor[i] = 0
          end
        end

        #PARA CARGAR LOS ESTADOS DE LOS METODOS DE DEPRECIACION CON SU VALOR UNITARIO
        for i in 0..(rebate_count-1)
          #@description_actual[i] = Description.where(:id => @parametro_actual[i].description_id).pluck(:id)
          #CUANDO SE AGREGA UN NUEVO METODO DE DEPRECIACION
          if @met_depr_actual[i]!=nil
            id_state_actual = State.find(@met_depr_actual[i].state_id)
            @state_actual[i] = id_state_actual.id
            val_state_actual = State.find(@met_depr_actual[i].state_id)
            @state_actual_valor[i] = val_state_actual.met_val_unit
            @sumatoria2 += val_state_actual.met_val_unit
          else
            @state_actual_valor[i] = 0
          end
        end

        @taa_val_real = @inmueble.inm_val_real
        @taa_val_merc = @taa_val_real + @sumatoria1 + @sumatoria2
      else
        #CASO CONTRARIO: SE VA A CALCULAR POR PRIMERA VEZ EL AVALUO DE UN INMUEBLE
        for i in 0..(price_count-1)
          @taa_areas[i] = 0
          @taa_unitarios[i] = 0
          @taa_totales[i] = 0
        end

        for i in 0..(parameter_count-1)
          @description_actual_valor[i] = 0
        end

        for i in 0..(rebate_count-1)
          @state_actual_valor[i] = 0
        end
      end

      @cont1 = 0
      @cont2 = 0
      @cont3 = 0
    else
      redirect_to denegado_path
    end
  end

  def update_description_val
    @descrip = Description.find(params[:description_id])
    @descrip = @descrip.param_val_unit
    @parameter_id = Parameter.find_by_param_descrip(params[:parameter_id])
    @parameter_id = @parameter_id.id
  end

  def update_state_val
    @state = State.find(params[:state_id])
    @state = @state.met_val_unit
    @rebate_id = Rebate.find_by_met_nombre(params[:rebate_id])
    @rebate_id = @rebate_id.id
  end

  def create
    price_count = Price.find(:all).count()
    parameter_count = Parameter.find(:all).count()
    rebate_count = Rebate.find(:all).count()

    #ANTES DE GUARDAR UN AVALUO SE REALIZA UNA CONSULTA PARA SABER SI SE TRATA DE UN NUEVO AVALUO O
    #SE ESTA EDITANDO LOS VALORES DE UN AVALUO YA EXISTENTE
    @tabla_avaluo_actual = ConstructionsPrice.where(:construction_id => params[:construction_id])
    @parametro_actual = ConstructionsParameter.where(:construction_id => params[:construction_id])
    @met_depr_actual = ConstructionsState.where(:construction_id => params[:construction_id])

    
    #SI EXISTE UN INMUEBLE CON AVALUO SE PROCEDE A LA ACTUALIZACION DE LOS VALORES DEL AVALUO
    if @tabla_avaluo_actual.exists?
      #@inmueble = Construction.find(1)
      #@actualizar = ConstructionsPrice.where(:construction_id => 1, :price_id =>1).first
      #@actualizar.update_attributes(det_area: 8, det_val_unit: 8, det_val_tot: 64)
#      @inmueble.constructions_prices.each do |area|
#        area.update_attributes(det_area: 5, det_val_unit: 5, det_val_tot: 25)
#      end
      #@tabla_avaluo_actual[0].update_attributes(det_area: params[:det_areas].at(4), det_val_unit: params[:det_vals_unit].at(4), det_val_tot: params[:det_vals_tot].at(4))
      #@actualizar = ConstructionsPrice.find_by_construction_id_and_price_id(params[:construction_id], @tabla_avaluo_actual[0].price_id)
      #redirect_to update_avaluo_path(:construction_id => params[:construction_id], :price_id => @tabla_avaluo_actual[0].price_id)
      for i in 0..(price_count-1)
        #construction_id: params[:construction_id], price_id: params[:price_ids].at(i),
        if @tabla_avaluo_actual[i]!=nil
          @actualizar = ConstructionsPrice.find_by_construction_id_and_price_id(params[:construction_id], @tabla_avaluo_actual[i].price_id)
          @actualizar.update_attributes(det_area: params[:det_areas].at(i), det_val_unit: params[:det_vals_unit].at(i), det_val_tot: params[:det_vals_tot].at(i))
        else
          ConstructionsPrice.create(construction_id: params[:construction_id], price_id: params[:price_ids].at(i), det_area: params[:det_areas].at(i), det_val_unit: params[:det_vals_unit].at(i), det_val_tot: params[:det_vals_tot].at(i))
        end
      end
      for i in 0..(parameter_count-1)
        if @parametro_actual[i]!=nil
          @actualizar = ConstructionsParameter.find_by_construction_id_and_parameter_id(params[:construction_id], @parametro_actual[i].parameter_id)
          @actualizar.update_attributes(description_id: params[:description_ids].at(i))
        else
          ConstructionsParameter.create(construction_id: params[:construction_id], parameter_id: params[:parameter_ids].at(i), description_id: params[:description_ids].at(i))
        end
        
#        @parametro_actual[i].update_attributes(construction_id: params[:construction_id], parameter_id: params[:parameter_ids].at(i), description_id: params[:description_ids].at(i))
      end
      for i in 0..(rebate_count-1)
        if @met_depr_actual[i]!=nil
          @actualizar = ConstructionsState.find_by_construction_id_and_state_id(params[:construction_id], @met_depr_actual[i].state_id)
          @actualizar.update_attributes(state_id: params[:state_ids].at(i))
        else
          ConstructionsState.create(construction_id: params[:construction_id], state_id: params[:state_ids].at(i))
        end
#        @met_depr_actual[i].update_attributes(construction_id: params[:construction_id], state_id: params[:state_ids].at(i))
      end

      #actualizar = Construction.joins(:states).where(:id => 1, :states => {:id => 3}).first
      #actualizar.constructions_states.first.update_attribute(:state_id, 5)
      #actualizar.save
    else
      #ConstructionsState.find(1)
      #CASO CONTRARIO: SE VA A CREAR UN NUEVO REGISTRO PARA LOS VALORES DEL AVALUO DEL INMUEBLE
      for i in 0..(price_count-1)
        ConstructionsPrice.create(construction_id: params[:construction_id], price_id: params[:price_ids].at(i), det_area: params[:det_areas].at(i), det_val_unit: params[:det_vals_unit].at(i), det_val_tot: params[:det_vals_tot].at(i))
      end
      for i in 0..(parameter_count-1)
        ConstructionsParameter.create(construction_id: params[:construction_id], parameter_id: params[:parameter_ids].at(i), description_id: params[:description_ids].at(i))
      end
      for i in 0..(rebate_count-1)
        ConstructionsState.create(construction_id: params[:construction_id], state_id: params[:state_ids].at(i))
      end
    end
    
    @inmueble = Construction.find(params[:construction_id])
    @inmueble.update_attributes(inm_val_real: params[:inm_val_real], inm_val_merc: params[:val_merc])
    
    redirect_to index_construction_path, :notice => "Avaluo Registrado"
  end

  #eliminar esto, solo era un prueba
  #inicio
  def update_avaluo
    actualizar = ConstructionsPrice.find_by_construction_id_and_price_id(params[:construction_id], params[:price_id])
    actualizar.update_attributes(det_area: 8, det_val_unit: 8, det_val_tot: 64)
    redirect_to index_construction_path, :notice => "Avaluo Registrado"
  end
  #fin  

#  def update_tabla_total
#    @avaluo_id = Price.find_by_aval_descrip(params[:avaluo_nombre])
#    @avaluo_id = @avaluo_id.id
#    @val1 = (params[:area_valor]).to_d
#    @val2 = (params[:unitario_valor]).to_d
#    @total = @val1*@val2#*params[:area_valor]
#    @unit_id = params[:unitario_act_id]
#    @area_id = params[:area_act_id]
#
#    @rec_area = params[:arreglo_rec_area]
#    @rec_unitario = params[:arreglo_rec_unitario]
#    @total = 5*4
#  end
end
