class StatesController < ApplicationController
  def index
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>rol_administrador.id, :user_id=>current_user})
    if current_user and administrador.exists?
      @id = params[:rebate_id]
      @rebate = Rebate.find(@id)
      @estados = State.joins(:rebate).where(:rebate_id=>@id)
      @estado = State.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def new
    @estado = State.new
    @id = params[:rebate_id]
  end

  def create
    @estado = State.new(params[:state])
    @bandera = ""
    @met_val_descrip = ""
    @met_val_unit = ""
    respond_to do |format|
      @estado.met_val_descrip = @estado.met_val_descrip.gsub(/\s+/, " ").strip
      if (@estado.met_val_descrip == "") or (@estado.met_val_unit == nil)
        if @estado.met_val_descrip == ""
          @met_val_descrip = "blank"
        end
        if @estado.met_val_unit == nil
          @met_val_unit = "blank"
        end
        @bandera = "blank"
        format.js { render "create.js"}
      else
        @estados = State.where(:rebate_id=>@estado.rebate_id)
        if @estados.find_by_met_val_descrip(@estado.met_val_descrip)
          @bandera = "exist"
          format.js { render "create.js"}
        else
          mayuscula = (@estado.met_val_descrip).upcase
          @estados.each do |p|
            if (p.met_val_descrip).upcase == mayuscula
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "create.js"}
          else
            if @estado.save
              format.html { redirect_to index_state_path(:rebate_id => @estado.rebate_id), :notice => "Registrado"}
            end
          end
        end
      end
    end
  end

  def show
    @estado = State.find(params[:id])
  end

  def eliminar
    @estado = State.find(params[:id])
    respond_to do |format|
      if ConstructionsState.find_by_state_id(@estado.id)
        format.js { render "no_eliminar.js"}
      else
        format.js { render "eliminar.js"}
      end
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def destroy
    @estado = State.find(params[:id])

    #OBTENEMOS LOS INMUEBLES QUE TIENEN ASOCIADA EL ESTADO A ELEMINAR
    inmuebles = Construction.find(:all, :conditions => "inm_estado != 'I'")
    inm_avaluo_update = Construction.joins(:constructions_states).where(:constructions_states=>{:construction_id => inmuebles, :state_id => @estado.id}).select("distinct constructions_states.construction_id")
    inm_avaluo_update = Construction.where(:id => inm_avaluo_update)
    inmuebles_count = inm_avaluo_update.count()

     #GUARDAMOS EN UN ARREGLO LOS IDS DE LOS INMUEBLES
    ids_inm = []
    cont = 0
    inm_avaluo_update.each do |iau|
      ids_inm[cont] = iau.id
      cont+=1
    end

    #ELIMINAMOS LOS REGISTROS QUE CORRESPONDEN A LA TABLA DETALLE
    detalle_state = ConstructionsState.where(:state_id => @estado.id)
    detalle_state.each do |ds|
      ds.destroy
    end

    #VOLVEMOS A BUSCAR LOS INMUEBLES CON LOS IDS DEL ARREGLO
    inm_avaluo_update = Construction.where(:id => ids_inm)
    inmuebles_count = inm_avaluo_update.count()

    #ACTUALIZAMOS EL AVALUO DE LOS INMUEBLES
    Construction.actualizar_avaluo_inm(inmuebles_count, inm_avaluo_update)
    @estado.destroy
    redirect_to index_state_path(:rebate_id => @estado.rebate_id)
  end

  def edit
    @estado = State.find(params[:id])
    respond_to do |format|
      format.js { render "edit.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def update
    @estado = State.new(params[:state])
    @bandera = ""
    @met_val_descrip = ""
    @met_val_unit = ""
    respond_to do |format|
      @estado.met_val_descrip = @estado.met_val_descrip.gsub(/\s+/, " ").strip
      if (@estado.met_val_descrip == "") or (@estado.met_val_unit == nil)
        if @estado.met_val_descrip == ""
          @met_val_descrip = "blank"
        end
        if @estado.met_val_unit == nil
          @met_val_unit = "blank"
        end
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_state = State.find(params[:id])
        @estados = State.where(:rebate_id=>params[:rebate_id])
        #if Description.find_by_param_val_descrip(@param_val.param_val_descrip) and (@param_val.param_val_descrip != aux_description.param_val_descrip)
        if @estados.find_by_met_val_descrip(@estado.met_val_descrip) and (@estado.met_val_descrip != aux_state.met_val_descrip)
          @bandera = "exist"
          format.js { render "update.js"}
        else
          mayuscula = (@estado.met_val_descrip).upcase
          @estados.each do |p|
            if ((p.met_val_descrip).upcase == mayuscula) and (p.met_val_descrip).upcase != (aux_state.met_val_descrip).upcase
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "update.js"}
          else
            @estado = State.find(params[:id])
            if @estado.update_attributes(params[:state])
              #LUEGO DE EDITAR EL VALOR DE LA DESCRIPCION, SE DEBE VOLVER A CALCULAR EL AVALUO DE LOS INMUEBLES
              inmuebles = Construction.find(:all, :conditions => "inm_estado != 'I'")
              #inm_avaluo_update = ConstructionsState.where(:construction_id => inmuebles, :state_id => @estado.id).select("distinct construction_id")
              inm_avaluo_update = Construction.joins(:constructions_states).where(:constructions_states=>{:construction_id => inmuebles, :state_id => @estado.id}).select("distinct constructions_states.construction_id")
              inm_avaluo_update = Construction.where(:id => inm_avaluo_update)
              inmuebles_count = inm_avaluo_update.count()
              Construction.actualizar_avaluo_inm(inmuebles_count, inm_avaluo_update)
              format.html { redirect_to index_state_path(:rebate_id => @estado.rebate_id), :notice => "Registrado"}
            end
          end
        end
      end
    end
  end
end