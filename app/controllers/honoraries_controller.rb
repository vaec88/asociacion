class HonorariesController < ApplicationController
  def index
    inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>"2",:user_id=>current_user}, :personas_constructions_roles=>{:construction_id => params[:construction_id]}).uniq
    if (current_user and current_user.id == 1) or (current_user and inmuebles_current.exists? and inmuebles_current.find(params[:construction_id]))
      @honorarios = Honorary.where(:construction_id => params[:construction_id])
      @inmueble = Construction.find(params[:construction_id])
      @honorario = Honorary.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end

  def new
    @honorario = Honorary.new
    @inmueble = Construction.find(params[:construction_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def create
    @honorario = Honorary.new(params[:honorary])
    @bandera = ""
    @hon_cantidad = ""
    @hon_fecha = ""

    respond_to do |format|
      if (@honorario.hon_cantidad == nil) or (@honorario.hon_fecha == nil)
        if @honorario.hon_cantidad == nil
          @hon_cantidad = "blank"
        end
        if @honorario.hon_fecha == nil
          @hon_fecha = "blank"
        end
        @bandera = "blank"
        format.js { render "create.js"}
      else
        id = params[:construction_id]
        @honorario.construction_id = id
        if @honorario.save
          Honorary.total_honorarios(id)
          format.html {redirect_to index_honorary_path(:construction_id => id), :notice => "Registro de abono guardado con exito"}
        end
      end
    end
  end

#  def show
#    @honorario = Honorary.find(params[:id])
#  end

  def eliminar
    @honorario = Honorary.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
    respond_to do |format|
      format.js { render "eliminar.js"}
    end
  end

  def destroy
    @honorario = Honorary.find(params[:id])
    @honorario.destroy
    Honorary.total_honorarios(@honorario.construction_id)
    redirect_to index_honorary_path(:construction_id => @honorario.construction_id)
  end

  def edit
   @honorario = Honorary.find(params[:id])
   rescue ActiveRecord::RecordNotFound
     redirect_to denegado_path
   return
   respond_to do |format|
     format.js { render "edit.js"}
   end
  end

  def update
    @honorario = Honorary.new(params[:honorary])
    @bandera = ""
    @hon_cantidad = ""
    @hon_fecha = ""

    respond_to do |format|
      if (@honorario.hon_cantidad == nil) or (@honorario.hon_fecha == nil)
        if @honorario.hon_cantidad == nil
          @hon_cantidad = "blank"
        end
        if @honorario.hon_fecha == nil
          @hon_fecha = "blank"
        end
        @bandera = "blank"
        format.js { render "update.js"}
      else
        @honorario = Honorary.find(params[:id])
        if @honorario.update_attributes(params[:honorary])
          Honorary.total_honorarios(@honorario.construction_id)
          format.html {redirect_to index_honorary_path(:construction_id => @honorario.construction_id), :notice => "Registro de abono guardado con exito"}
        end
      end
    end
  end

  def todos    
    if current_user
      corredor = Role.find_by_rol_nombre("Corredor")
      @propietario = Role.find_by_rol_nombre("Propietario")
      @inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>corredor.id,:user_id=>current_user}).uniq
    else
      redirect_to denegado_path
    end
  end

  def reporte_honorary_formulario
    respond_to do |format|
      format.js {render "reporte_honorary_formulario.js"}
    end
  end

  def reporte_honorary
    @fecha_desde = params[:honorary_fecha_desde]
    @fecha_hasta = params[:honorary_fecha_hasta]
    corredor = Role.find_by_rol_nombre("Corredor")
    @propietario = Role.find_by_rol_nombre("Propietario")
#    @inmuebles_current = Construction.joins(:honoraries, :personas=>:users).where("honoraries.hon_fecha >= '2014-06-01' and honoraries.hon_fecha <= '2014-06-05'", :personas_roles_users=>{:role_id=>corredor.id,:user_id=>current_user}).uniq
#    @inmuebles_current = Construction.joins(:honoraries, :personas=>:users).where("honoraries.hon_fecha >= '#{@fecha_desde}' and honoraries.hon_fecha <= '#{@fecha_hasta}'", :personas_roles_users=>{:role_id=>corredor.id,:user_id=>current_user}).uniq
    @inmuebles_current = Construction.joins(:honoraries, :personas=>:users).where("honoraries.hon_fecha >= '#{@fecha_desde}' and honoraries.hon_fecha <= '#{@fecha_hasta}' and personas_roles_users.role_id == '#{corredor.id}' and personas_roles_users.user_id == '#{current_user.id}'").uniq
    array_inmuebles = []
    contador = 0
    @inmuebles_current.each do |inm|
      if inm.honoraries.last.hon_fecha.to_s >= @fecha_desde and inm.honoraries.last.hon_fecha.to_s <= @fecha_hasta
        array_inmuebles[contador] = inm
        contador+=1
      end
    end
    @inmuebles_current = Construction.where(:id=>array_inmuebles)
    render :layout => false
  end
end















