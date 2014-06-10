class SolicitudesController < ApplicationController
  def solicitud_construction
    fecha = Time.zone.now.strftime("%Y-%m-%d")
    @solicitud = Solicitude.new(sol_nombre: params[:contacto_nombres], sol_apellido: params[:contacto_apellidos], sol_email: params[:contacto_email], sol_msg: params[:contacto_mensaje], sol_fecha: fecha, construction_id: params[:contacto_construction_id])
    @error_nombre = ""
    @error_apellido = ""
    @error_email = ""
    @error_msg = ""
    
    form_valido = true
    respond_to do |format|
      if @solicitud.valid? == false
        if @solicitud.errors[:sol_nombre].empty? == false
          @error_nombre = @solicitud.errors[:sol_nombre].to_s
        end
        if @solicitud.errors[:sol_apellido].empty? == false
          @error_apellido = @solicitud.errors[:sol_apellido].to_s
        end
        if @solicitud.errors[:sol_email].empty? == false
          @error_email = @solicitud.errors[:sol_email].to_s
        end
        if @solicitud.errors[:sol_msg].empty? == false
          @error_msg = @solicitud.errors[:sol_msg].to_s
        end
        form_valido = false
      end
      if form_valido == false
        format.js { render "errores.js"}
      else
        if @solicitud.save
          format.js { render "correcto.js"}
        end
      end
    end
  end

  def index
    if current_user
      rol_corredor = Role.find_by_rol_nombre("Corredor")
#      @rol_propietario = Role.find_by_rol_nombre("Propietario")
#      @rol_demandante = Role.find_by_rol_nombre("Demandante")
      persona = Persona.joins(:users).where(:personas_roles_users => {:user_id => current_user, :role_id => rol_corredor.id}).first
      if current_user.id == 1
        @inmueble = Construction.find(:all)
        @inmueble = Construction.where(:id => @inmueble)#.paginate(:page => params[:page], :per_page => 12)
      else
        @inmueble = Construction.joins(:personas).where(:personas_constructions_roles => {:persona_id => persona.id, :role_id => rol_corredor.id})#.paginate(:page => params[:page], :per_page => 12)
      end
      @solicitudes = Solicitude.where(:construction_id=>@inmueble)
    else
      redirect_to denegado_path
    end
  end

  def eliminar
    @solicitud = Solicitude.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
    respond_to do |format|
      format.js { render "eliminar.js"}
    end
  end

  def destroy
    @solicitud = Solicitude.find(params[:id])
    @solicitud.destroy
    redirect_to index_solicitude_path
  end

  def reporte_solicitude_formulario
    respond_to do |format|
      format.js {render "reporte_solicitude_formulario.js"}
    end
  end

  def reporte_solicitude
    @fecha_desde = params[:solicitude_fecha_desde]
    @fecha_hasta = params[:solicitude_fecha_hasta]
    corredor = Role.find_by_rol_nombre("Corredor")
#    @inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>corredor.id,:user_id=>current_user}).uniq
#    @solicitudes = Solicitude.where("solicitudes.sol_fecha >= '#{@fecha_desde}' and solicitudes.sol_fecha <= '#{@fecha_hasta}'", :construction_id=>@inmuebles_current)
    @solicitudes = Solicitude.joins(:construction=>{:personas=>:users}).where("solicitudes.sol_fecha >= '#{@fecha_desde}' and solicitudes.sol_fecha <= '#{@fecha_hasta}' and personas_roles_users.role_id == '#{corredor.id}' and personas_roles_users.user_id == '#{current_user.id}'").uniq
    render :layout => false
  end
end
