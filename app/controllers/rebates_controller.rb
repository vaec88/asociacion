class RebatesController < ApplicationController
  def index
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>rol_administrador.id, :user_id=>current_user})
    if current_user and administrador.exists?
      @depreciaciones = Rebate.find(:all)
      @depreciacion = Rebate.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end

  def new
    @depreciacion = Rebate.new
  end

  def create
    @depreciacion = Rebate.new(params[:rebate])
    respond_to do |format|
      @depreciacion.met_nombre = @depreciacion.met_nombre.gsub(/\s+/, " ").strip
      if @depreciacion.met_nombre == ""
        @bandera = "blank"
        format.js { render "create.js"}
      else
        if Rebate.find_by_met_nombre(@depreciacion.met_nombre)
          @bandera = "exist"
          format.js { render "create.js"}
        else
          mayuscula = (@depreciacion.met_nombre).upcase
          todos_depreciaciones = Rebate.all
          todos_depreciaciones.each do |p|
            if (p.met_nombre).upcase == mayuscula
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "create.js"}
          else
            if @depreciacion.save
              format.html { redirect_to index_rebate_path, :notice => "Registrado"}
            end
          end
        end
      end
    end
  end

  def show
    @depreciacion = Rebate.find(params[:id])
  end

  def eliminar
    @depreciacion = Rebate.find(params[:id])
    respond_to do |format|
      if Construction.joins(:states).where(:states=>{:rebate_id=>@depreciacion.id}).exists?
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
    @depreciacion = Rebate.find(params[:id])

    #LOCALIZAR TODOS LOS ESTADOS DEL METODO DE DEPRECIACION A ELIMINAR
    estados = State.joins(:rebate).where(:rebates=>{:id=>@depreciacion.id})
    inmuebles = Construction.find(:all, :conditions => "inm_estado != 'I'")
    inm_avaluo_update = Construction.joins(:constructions_states).where(:constructions_states=>{:construction_id => inmuebles, :state_id => estados}).select("distinct constructions_states.construction_id")
    inm_avaluo_update = Construction.where(:id => inm_avaluo_update)

    #GUARDAMOS EN UN ARREGLO LOS IDS DE LOS INMUEBLES
    ids_inm = []
    cont = 0
    inm_avaluo_update.each do |iau|
      ids_inm[cont] = iau.id
      cont+=1
    end

    #ELIMINAMOS LOS REGISTROS QUE CORRESPONDEN A LA TABLA DETALLE
    detalle_state = ConstructionsState.where(:state_id => estados)
    detalle_state.each do |ds|
      ds.destroy
    end

    #VOLVEMOS A BUSCAR LOS INMUEBLES CON LOS IDS DEL ARREGLO
    inm_avaluo_update = Construction.where(:id => ids_inm)
    inmuebles_count = inm_avaluo_update.count()

    #ACTUALIZAMOS EL AVALUO DE LOS INMUEBLES
    Construction.actualizar_avaluo_inm(inmuebles_count, inm_avaluo_update)
    @depreciacion.destroy
    redirect_to index_rebate_path
  end

  def edit
    @depreciacion = Rebate.find(params[:id])
    respond_to do |format|
      format.js { render "edit.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def update
    @depreciacion = Rebate.new(params[:rebate])
    respond_to do |format|
      @depreciacion.met_nombre = @depreciacion.met_nombre.gsub(/\s+/, " ").strip
      if @depreciacion.met_nombre == ""
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_depreciacion = Rebate.find(params[:id])
        if Rebate.find_by_met_nombre(@depreciacion.met_nombre) and (@depreciacion.met_nombre != aux_depreciacion.met_nombre)
          @bandera = "exist"
          format.js { render "update.js"}
        else
          mayuscula = (@depreciacion.met_nombre).upcase
          todos_depreciaciones = Rebate.all
          todos_depreciaciones.each do |p|
            if ((p.met_nombre).upcase == mayuscula) and (p.met_nombre).upcase != (aux_depreciacion.met_nombre).upcase
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "update.js"}
          else
            @depreciacion = Rebate.find(params[:id])
            if @depreciacion.update_attributes(params[:rebate])
              format.html { redirect_to index_rebate_path, :notice => "Registro Actualizado con Exito"}
            end
          end
        end
      end
    end
  end
end