class UsersController < ApplicationController
  def index
    rol_admin = Role.find_by_rol_nombre("Administrador")
    rol_teso = Role.find_by_rol_nombre("Tesorero")
#    administrador = PersonasRolesUsuario.where(:role_id=>rol_admin.id, :usuario_id=>current_user.id)
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>[rol_admin.id, rol_teso.id], :user_id=>current_user}).uniq
    if current_user and administrador.exists?
      @personas = Persona.joins(:users).where(:personas_roles_users => {:role_id => '2'})
      @personas = @personas.order("pers_apellido")
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end
  
  def new
    @user = User.new
    @person = Persona.new
  end

  def create
    @user = User.new(params[:user])
    @user.usu_estado = "I"
    @person = Persona.new(params[:persona])
    @person.pers_estado = "I"
    #@person = @user.personas.build(params[:persona])
    @error_username = ""
    @error_password = ""
    @error_password_confirm = ""
    @error_matricula = ""

    @error_cedula = ""
    @error_apellido = ""
    @error_nombre = ""
    @error_direccion = ""
    @error_telefono2 = ""
    @error_email = ""

    form_valido = true
    #@error_password_confirmation = ""
    if @user.valid? == false
      if @user.errors[:username].empty? == false
        @error_username = @user.errors[:username].to_s
      end
      if @user.errors[:password].empty? == false
        @error_password = @user.errors[:password].to_s
      end
      if @user.errors[:usu_matr_prof].empty? == false
        @error_matricula = @user.errors[:usu_matr_prof].to_s
      end
      form_valido = false
    end

    if params[:user][:password_confirmation] == ""
      @error_password_confirm = "Debe confirmar la contrasenia"
      form_valido = false
    end
    if (params[:user][:password_confirmation] != "") and (@user.password != params[:user][:password_confirmation])
      @error_password_confirm = "Las contrasenias no coinciden!"
      form_valido = false
    end

    if @person.valid? == false
      if @person.errors[:pers_cedula].empty? == false
        @error_cedula = @person.errors[:pers_cedula].to_s
      end
      if @person.errors[:pers_apellido].empty? == false
        @error_apellido = @person.errors[:pers_apellido].to_s
      end
      if @person.errors[:pers_nombre].empty? == false
        @error_nombre = @person.errors[:pers_nombre].to_s
      end
      if @person.errors[:pers_direccion].empty? == false
        @error_direccion = @person.errors[:pers_direccion].to_s
      end
      if @person.errors[:pers_telefono2].empty? == false
        @error_telefono2 = @person.errors[:pers_telefono2].to_s
      end
      if @person.errors[:pers_email].empty? == false
        @error_email = @person.errors[:pers_email].to_s
      end
      form_valido = false
    end

    if form_valido == false
      render "create.js"
    else
      @user.email = @person.pers_email
      if @user.save and @person.save
        p_id = @person.id
        u_id = @user.id
        @per_rol_usu = PersonasRolesUser.new(:persona_id => p_id, :role_id => '2', :user_id => u_id)
        @per_rol_usu.save
        #redirect_to index_usuarios_path, :notice => "Registrado"
        redirect_to index_path
      else
        #render "new"
      end
    end
  end

  def edit
    rol_corredor = Role.find_by_rol_nombre("Corredor")
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    #usuario_current = Usuario.find(current_user)
    persona_current = Persona.joins(:users).where(:personas_roles_users=>{:role_id=>[rol_corredor.id, rol_administrador.id],:user_id=>current_user}).uniq.first
    if current_user and current_user.id == params[:usuario_id].to_i and persona_current.id == params[:persona_id].to_i
      @user = User.find(params[:usuario_id])
      @person = Persona.find(params[:persona_id])
    else
      redirect_to denegado_path
    end
  end

  def update
    @user = User.new(params[:user])
    @person = Persona.new(params[:persona])
    
    @error_username = ""
    @error_password = ""
    @error_matricula = ""

    @error_cedula = ""
    @error_apellido = ""
    @error_nombre = ""
    @error_direccion = ""
    @error_telefono2 = ""
    @error_email = ""

    respond_to do |format|
      form_valido = true
      if @user.valid? == false
        aux_usu = User.find(params[:usuario_id])
        if (@user.errors[:username].empty? == false) and (@user.username!=aux_usu.username)
          @error_username = @user.errors[:username].to_s
          form_valido = false
        else
          @error_username = ""
        end
  #      if @user.errors[:usu_password].empty? == false
  #        @error_password = @user.errors[:usu_password].to_s
  #      end
        if (@user.errors[:usu_matr_prof].empty? == false) and (@user.usu_matr_prof!=aux_usu.usu_matr_prof)
          @error_matricula = @user.errors[:usu_matr_prof].to_s
          form_valido = false
        else
          @error_matricula = ""
        end
      end

      if @person.valid? == false
        aux_pers = Persona.find(params[:persona_id])
        if (@person.errors[:pers_cedula].empty? == false) and (@person.pers_cedula!=aux_pers.pers_cedula)
          @error_cedula = @person.errors[:pers_cedula].to_s
          form_valido = false
        else
          @error_cedula = ""
        end
        if @person.errors[:pers_apellido].empty? == false
          @error_apellido = @person.errors[:pers_apellido].to_s
          form_valido = false
        end
        if @person.errors[:pers_nombre].empty? == false
          @error_nombre = @person.errors[:pers_nombre].to_s
          form_valido = false
        end
        if @person.errors[:pers_direccion].empty? == false
          @error_direccion = @person.errors[:pers_direccion].to_s
          form_valido = false
        end
        if @person.errors[:pers_telefono2].empty? == false
          @error_telefono2 = @person.errors[:pers_telefono2].to_s
          form_valido = false
        end
        if (@person.errors[:pers_email].empty? == false) and (@person.pers_email!=aux_pers.pers_email)
          @error_email = @person.errors[:pers_email].to_s
          form_valido = false
        else
          @error_email = ""
        end
      end
      #@bandera_validacion = form_valido
      if form_valido == false
         format.js {render "update.js"}
      else
        user_email = @person.pers_email
        @usuario = User.find(params[:usuario_id])
        @person = Persona.find(params[:persona_id])
        if @usuario.update_attributes(params[:user]) and @person.update_attributes(params[:persona])
          @usuario.update_attributes(email: user_email)
          rol = Role.find(current_rol.first)
          if rol.rol_nombre == "Administrador"
             format.html {redirect_to index_usuarios_path}
          else
            format.html {redirect_to index_construction_path}
          end
        else
#          @mensaje = "hola mensaje"
#          @pars = params[:usuario]
          format.js {render "msg.js"}
          #render "edit"
        end
      end
    end
  end

  def usu_username_check
    @check = ""
    @accion = params[:accion].to_s
    if @accion == "new"
      if User.find_by_username(params[:usu_username])
        @usuario = User.find_by_username(params[:usu_username])
        @check = "existe"
      else
        @usuario = params[:usu_username]
        @check = "no_existe"
      end
    end
    
    if @accion == "edit"
      aux_user = User.find(params[:usuario_id])
#      @id_user = aux_user.usu_username
      if (User.find_by_username(params[:usu_username])) and (params[:usu_username] != aux_user.username)
        @usuario = User.find_by_username(params[:usu_username])
        @check = "existe"
      else
        @usuario = params[:usu_username]
        @check = "no_existe"
      end
    end
  end

  def usu_matr_prof_check
    @check = ""
    @accion = params[:accion].to_s
    if @accion == "new"
      if User.find_by_usu_matr_prof(params[:usu_matr_prof])
        @usuario = User.find_by_usu_matr_prof(params[:usu_matr_prof])
        @check = "existe"
      else
        @usuario = params[:usu_matr_prof]
        @check = "no_existe"
      end
    end

    if @accion == "edit"
      aux_user = User.find(params[:usuario_id])
      if (User.find_by_usu_matr_prof(params[:usu_matr_prof])) and (params[:usu_matr_prof] != aux_user.usu_matr_prof)
        @usuario = User.find_by_usu_matr_prof(params[:usu_matr_prof])
        @check = "existe"
      else
        @usuario = params[:usu_matr_prof]
        @check = "no_existe"
      end
    end  
  end

  def pers_cedula_check
    @check = ""
    @accion = params[:accion].to_s
    if @accion == "new"
      if Persona.find_by_pers_cedula(params[:pers_cedula])
        @persona = Persona.find_by_pers_cedula(params[:pers_cedula])
        @check = "existe"
      else
        @check = "no_existe"
      end
    end
    if @accion == "edit"
      aux_person = Persona.find(params[:persona_id])
      if (Persona.find_by_pers_cedula(params[:pers_cedula])) and (params[:pers_cedula] != aux_person.pers_cedula)
        @persona = Persona.find_by_pers_cedula(params[:pers_cedula])
        @check = "existe"
      else
        @check = "no_existe"
      end
    end
  end

  def pers_email_check
    @check = ""
    @accion = params[:accion].to_s
    if @accion == "new"
      if Persona.find_by_pers_email(params[:pers_email])
        @persona = Persona.find_by_pers_email(params[:pers_email])
        @check = "existe"
      else
        @check = "no_existe"
      end
    end
    if @accion == "edit"
      aux_person = Persona.find(params[:persona_id])
      if (Persona.find_by_pers_email(params[:pers_email])) and (params[:pers_email] != aux_person.pers_email)
        @persona = Persona.find_by_pers_email(params[:pers_email])
        @check = "existe"
      else
        @check = "no_existe"
      end
    end
  end

  def edit_password
    @error_password = ""
    form_valido = true

    @aux_user = User.find(params[:usuario_id])
    @usu_password_old = params[:usuario_password_old]
    @user = User.new
    @user.password = params[:usuario_password]
    respond_to do |format|

      if (@usu_password_old == @aux_user.password)
        if @user.valid? == false
          if @user.errors[:password].empty? == false
            @error_password = @user.errors[:password].to_s
            form_valido = false
          end
        end

        if params[:usuario_password_confirm] == ""
          @error_password_confirm = "Debe confirmar la contrasenia"
          form_valido = false
        end
        if (params[:usuario_password_confirm] != "") and (@user.password != params[:usuario_password_confirm])
          @error_password_confirm = "Las contrasenias no coinciden!"
          form_valido = false
        end
      else
        @error_password = "Verifique su Contrasenia Actual"
        form_valido = false
      end

      if form_valido == false
        format.js {render "edit_password.js"}
      else
        @aux_user.update_attributes(password: @user.password, password_confirm: params[:usuario_password_confirm])
        rol = Role.find(current_rol.first)
        if rol.rol_nombre == "Administrador"
          format.html {redirect_to index_usuarios_path}
        else
          format.html {redirect_to index_construction_path}
        end
      end

    end
  end

  def eliminar
    @persona = Persona.find(params[:id])
    @usuario = User.find(params[:usuario_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
    respond_to do |format|
      if current_user.id == params[:usuario_id].to_i
        format.js { render "no_eliminar.js"}
      else
        format.js { render "eliminar.js"}
      end
    end
  end
  
  def destroy
    @usuario = User.find(params[:usuario_id])
    #BUSCAR LAS PERSONAS RELACIONADAS CON ESE USUARIO
    @personas = Persona.joins(:users).where(:personas_roles_users=>{:user_id=>@usuario.id}).uniq!
    if @personas == nil
      @personas = Persona.joins(:users).where(:personas_roles_users=>{:user_id=>@usuario.id}).uniq
    end
    #ELIMINAR AL USUARIO DE LA TABLA DETALLE "PERSONAS_ROLES_USUARIOS"
    @usuarios_detalle = PersonasRolesUser.where(:user_id=>@usuario.id)
    @usuarios_detalle.each do |ud|
      ud.destroy
    end
    #BUSCAR LOS INMUEBLES RELACIONADOS CON ESAS PERSONAS
    @inmuebles = Construction.joins(:personas).where(:personas_constructions_roles=>{:persona_id=>@personas}).uniq!
    if @inmuebles == nil
      @inmuebles = Construction.joins(:personas).where(:personas_constructions_roles=>{:persona_id=>@personas}).uniq
    end
    #ELIMINAR A LAS PERSONAS DE LA TABLA DETALLE "PERSONAS_CONSTRUCTIONS_ROLES"
    @personas_detalle = PersonasConstructionsRole.where(:persona_id=>@personas)
    @personas_detalle.each do |pd|
      pd.destroy
    end
    #BUSCAR LOS INMUEBLES EN LAS TABLAS DETALLE "constructions_parameters", "constructions_states", "constructions_prices", "constructions_pieces", "constructions_channels"
    @inm_const_param = ConstructionsParameter.where(:construction_id=>@inmuebles)
    @inm_const_state = ConstructionsState.where(:construction_id=>@inmuebles)
    @inm_const_price = ConstructionsPrice.where(:construction_id=>@inmuebles)
    @inm_const_piece = ConstructionsPiece.where(:construction_id=>@inmuebles)
    @inm_const_channel = ConstructionsChannel.where(:construction_id=>@inmuebles)
    #ELIMINAR LOS REGISTROS DE ESAS TABLAS DETALLE
    @inm_const_param.each do |icp|
      icp.destroy
    end
    @inm_const_state.each do |icp|
      icp.destroy
    end
    @inm_const_price.each do |icp|
      icp.destroy
    end
    @inm_const_piece.each do |icp|
      icp.destroy
    end
    @inm_const_channel.each do |icp|
      icp.destroy
    end
    #ELIMINAR LOS REGISTROS DE "CONSTRUCTIONS", "PERSONAS", "USUARIOS
    @inmuebles.each do |inm|
      inm.destroy
    end
    @personas.each do |per|
      per.destroy
    end
    
    @usuario.destroy

#    @cuota = Amount.find(params[:id])
#    @cuota.destroy
    redirect_to index_usuarios_path
  end

  def activar_cuentas
    @personas = Persona.joins(:users).where(:personas_roles_users => {:role_id => '2'}).uniq
    @cuentas = params[:cuentas_activas]
    @personas_cuentas = @personas.where(:id=>@cuentas)
#    @activar = []
#    @no_activar = []
#    contador1 = 0
#    contador2 = 0
    @personas.each do |pers|
      if @personas_cuentas.find_by_id(pers.id)
#        @activar[contador1] = @personas.find_by_id(pers.id)
#        contador1+=1
        Persona.find(pers).update_attributes(pers_estado: "A")
      else
#        @no_activar[contador2] = pers
#        contador2+=1
        Persona.find(pers).update_attributes(pers_estado: "I")
      end
    end
    redirect_to index_usuarios_path
  end

  def reporte_amount_formulario
    @estados_pago = [["Pagos al Dia","C"], ["Pagos Pendientes","I"]].to_a
    @meses = [["Enero","1"],["Febrero","2"],["Marzo","3"],["Abril","4"],["Mayo","5"],["Junio","6"],["Julio","7"],["Agosto","8"],["Septiembre","9"],["Octubre","10"],["Noviembre","11"],["Diciembre","12"]]
    @anios = ["2013","2014"]
    respond_to do |format|
      format.js {render "reporte_amount_formulario.js"}
    end
  end

  def reporte_amount
    @estado_pago = params[:estado_pago].first
    @estado_mes = params[:estado_mes].first
    @estado_anio = params[:estado_anio].first
    rol_corredor = Role.find_by_rol_nombre("Corredor")
    if @estado_pago == "C"
      @personas = Persona.joins(:users=>:amounts).where(:personas_roles_users=>{:role_id=>rol_corredor.id}, :amounts=>{:amo_mes=>@estado_mes, :amo_anio=>@estado_anio}).uniq
      @estado_pago = "Pagos al Dia"
    else
      @usuarios = User.joins(:amounts).where(:amounts=>{:amo_mes=>@estado_mes, :amo_anio=>@estado_anio}).uniq
      usuarios_pendientes = []
      contador = 0
      @todos_usuarios = User.all
      @todos_usuarios.each do |usu|
        if @usuarios.find_by_id(usu.id)

        else
          usuarios_pendientes[contador] = usu
          contador+=1
        end
      end
      @personas = Persona.joins(:users).where(:personas_roles_users=>{:role_id=>rol_corredor.id},:users=>{:id=>usuarios_pendientes}).uniq
      @estado_pago = "Pagos Pendientes"
    end
    @estado_mes = Amount.meses_string(@estado_mes.to_i)
    render :layout => false
  end
end