class DescriptionsController < ApplicationController
  def index
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>rol_administrador.id, :user_id=>current_user})
    if current_user and administrador.exists?
      @params_vals = Description.find(:all)
      @param_val = Description.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end

  def new
    @param_val = Description.new
  end

  def create
    @param_val = Description.new(params[:description])
    @bandera = ""
    @param_val_descrip = ""
    @param_val_unit = ""
    respond_to do |format|
      @param_val.param_val_descrip = @param_val.param_val_descrip.gsub(/\s+/, " ").strip
      #@param_val.param_val_unit = @param_val.param_val_unit.gsub(/\s+/, " ").strip

      if (@param_val.param_val_descrip == "") or (@param_val.param_val_unit == nil)
        if @param_val.param_val_descrip == ""
          @param_val_descrip = "blank"
        end
        if @param_val.param_val_unit == nil
          @param_val_unit = "blank"
        end
        @bandera = "blank"
        format.js { render "create.js"}
      else
        if Description.find_by_param_val_descrip(@param_val.param_val_descrip)
          @bandera = "exist"
          format.js { render "create.js"}
        else
          mayuscula = (@param_val.param_val_descrip).upcase
          todos_params_val = Description.all
          todos_params_val.each do |p|
            if (p.param_val_descrip).upcase == mayuscula
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "create.js"}
          else
            if @param_val.save
              format.html { redirect_to index_description_path, :notice => "Registrado"}
            end
          end
        end
      end
    end
  end

  def show
    @param_val = Description.find(params[:id])
  end

  def eliminar
    @param_val = Description.find(params[:id])
    respond_to do |format|
      if ConstructionsParameter.find_by_description_id(@param_val.id)
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
    @param_val = Description.find(params[:id])
#    @det = ParametersDescription.where(:description_id => @param_val.id)
#    @det.each do |d|
#      d.destroy
#    end
    #@param_val=@param_val.parameters_descriptions.find(params[:id])
    #@param_val = Description.includes(:parameters_descriptions).find(params[:id])
    
    #OBTENEMOS LOS INMUEBLES QUE TIENEN ASOCIADA LA DESCRIPCION A ELEMINAR
    inmuebles = Construction.find(:all, :conditions => "inm_estado != 'I'")
    inm_avaluo_update = Construction.joins(:constructions_parameters).where(:constructions_parameters=>{:construction_id => inmuebles, :description_id => @param_val.id}).select("distinct constructions_parameters.construction_id")
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
    detalle_description = ConstructionsParameter.where(:description_id => @param_val.id)
    detalle_description.each do |dd|
      dd.destroy
    end

    #VOLVEMOS A BUSCAR LOS INMUEBLES CON LOS IDS DEL ARREGLO
    inm_avaluo_update = Construction.where(:id => ids_inm)
    inmuebles_count = inm_avaluo_update.count()

    #ACTUALIZAMOS EL AVALUO DE LOS INMUEBLES
    Construction.actualizar_avaluo_inm(inmuebles_count, inm_avaluo_update)
    @param_val.destroy
    
    redirect_to index_description_path
  end

  def edit
    @param_val = Description.find(params[:id])
    respond_to do |format|
      format.js { render "edit.js"}
#      format.js { render "msg.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
#    inmuebles = Construction.find(:all, :conditions => "inm_estado != 'I'")
#    inm_avaluo_update = Construction.joins(:constructions_parameters).where(:constructions_parameters=>{:construction_id => inmuebles, :description_id => @param_val.id}).select("distinct constructions_parameters.construction_id")
#    @inm_avaluo_update = Construction.where(:id => inm_avaluo_update)
#    @inmuebles_count = @inm_avaluo_update.count()
  end

  def update
    @param_val = Description.new(params[:description])
    @bandera = ""
    @param_val_descrip = ""
    @param_val_unit = ""
    respond_to do |format|
      @param_val.param_val_descrip = @param_val.param_val_descrip.gsub(/\s+/, " ").strip
      if (@param_val.param_val_descrip == "") or (@param_val.param_val_unit == nil)
        if @param_val.param_val_descrip == ""
          @param_val_descrip = "blank"
        end
        if @param_val.param_val_unit == nil
          @param_val_unit = "blank"
        end
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_description = Description.find(params[:id])
        if Description.find_by_param_val_descrip(@param_val.param_val_descrip) and (@param_val.param_val_descrip != aux_description.param_val_descrip)
          @bandera = "exist"
          format.js { render "update.js"}
        else
          mayuscula = (@param_val.param_val_descrip).upcase
          todos_params_val = Description.all
          todos_params_val.each do |p|
            if ((p.param_val_descrip).upcase == mayuscula) and (p.param_val_descrip).upcase != (aux_description.param_val_descrip).upcase
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "update.js"}
          else
            @param_val = Description.find(params[:id])
            if @param_val.update_attributes(params[:description])
              #LUEGO DE EDITAR EL VALOR DE LA DESCRIPCION, SE DEBE VOLVER A CALCULAR EL AVALUO DE LOS INMUEBLES
              inmuebles = Construction.find(:all, :conditions => "inm_estado != 'I'")
              #inm_avaluo_update = ConstructionsParameter.where(:construction_id => inmuebles, :description_id => @param_val.id).select("distinct construction_id")
              inm_avaluo_update = Construction.joins(:constructions_parameters).where(:constructions_parameters=>{:construction_id => inmuebles, :description_id => @param_val.id}).select("distinct constructions_parameters.construction_id")
              inm_avaluo_update = Construction.where(:id => inm_avaluo_update)
              inmuebles_count = inm_avaluo_update.count()
              Construction.actualizar_avaluo_inm(inmuebles_count, inm_avaluo_update)
              format.html { redirect_to index_description_path, :notice => "Registro Actualizado con Exito"}
            end
          end
        end
      end
    end
  end
end
