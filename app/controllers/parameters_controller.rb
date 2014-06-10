class ParametersController < ApplicationController
  def index
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>rol_administrador.id, :user_id=>current_user})
    if current_user and administrador.exists?
      @parametros = Parameter.find(:all)
      @parametro = Parameter.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end

  def new
    @parametro = Parameter.new
  end

  def create
    @parametro = Parameter.new(params[:parameter])
    respond_to do |format|
      @parametro.param_descrip = @parametro.param_descrip.gsub(/\s+/, " ").strip
      if @parametro.param_descrip == ""
        @bandera = "blank"
        format.js { render "create.js"}
      else
        if Parameter.find_by_param_descrip(@parametro.param_descrip)
          @bandera = "exist"
          format.js { render "create.js"}
        else
          mayuscula = (@parametro.param_descrip).upcase
          todos_parametros = Parameter.all
          todos_parametros.each do |p|
            if (p.param_descrip).upcase == mayuscula
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "create.js"}
          else
            if @parametro.save
              format.html { redirect_to index_parameter_path, :notice => "Registrado"}
            end
          end
        end
      end
    end
  end

  def show
    @parametro = Parameter.find(params[:id])
    @descripcion = Description.joins(:parameters).where(:parameters => {:id => @parametro.id})
  end

  def eliminar
    @parametro = Parameter.find(params[:id])
    respond_to do |format|
      if ConstructionsParameter.find_by_parameter_id(@parametro.id)
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
    @parametro = Parameter.find(params[:id])
    #@parametro.parameters_descriptions.find(params[:id])

    #OBTENEMOS LOS INMUEBLES QUE TIENEN ASOCIADA LA DESCRIPCION A ELEMINAR
    inmuebles = Construction.find(:all, :conditions => "inm_estado != 'I'")
    inm_avaluo_update = Construction.joins(:constructions_parameters).where(:constructions_parameters=>{:construction_id => inmuebles, :parameter_id => @parametro.id}).select("distinct constructions_parameters.construction_id")
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
    detalle_parameter = ConstructionsParameter.where(:parameter_id => @parametro.id)
    detalle_parameter.each do |dp|
      dp.destroy
    end

    #VOLVEMOS A BUSCAR LOS INMUEBLES CON LOS IDS DEL ARREGLO
    inm_avaluo_update = Construction.where(:id => ids_inm)
    inmuebles_count = inm_avaluo_update.count()

    #ACTUALIZAMOS EL AVALUO DE LOS INMUEBLES
    Construction.actualizar_avaluo_inm(inmuebles_count, inm_avaluo_update)
    @parametro.destroy
    redirect_to index_parameter_path
  end

  def edit
    @parametro = Parameter.find(params[:id])
    respond_to do |format|
      format.js { render "edit.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def update
    @parametro = Parameter.new(params[:parameter])
    respond_to do |format|
      @parametro.param_descrip = @parametro.param_descrip.gsub(/\s+/, " ").strip
      if @parametro.param_descrip == ""
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_parametro = Parameter.find(params[:id])
        if Parameter.find_by_param_descrip(@parametro.param_descrip) and (@parametro.param_descrip != aux_parametro.param_descrip)
          @bandera = "exist"
          format.js { render "update.js"}
        else
          mayuscula = (@parametro.param_descrip).upcase
          todos_parametros = Parameter.all
          todos_parametros.each do |p|
            if ((p.param_descrip).upcase == mayuscula) and (p.param_descrip).upcase != (aux_parametro.param_descrip).upcase
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "update.js"}
          else
            @parametro = Parameter.find(params[:id])
            params[:parameter][:description_ids]||=[]
            if @parametro.update_attributes(params[:parameter])
              format.html { redirect_to index_parameter_path, :notice => "Registro Actualizado con Exito"}
            end
          end
        end
      end
    end
  end
end
