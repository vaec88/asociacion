class PersonasController < ApplicationController
  #ESTE CONTROLADOR SE UTILIZA SOLO PARA LISTAR, CREAR, EDITAR, ELIMINAR DEMANDANTES
  def index
    if current_user
      corredor = Role.find_by_rol_nombre("Corredor")
      inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>corredor.id,:user_id=>current_user}).uniq
      demandante = Role.find_by_rol_nombre("Demandante")
#      @demandantes = Persona.joins(:usuarios).where(:personas_roles_usuarios => {:role_id => demandante.id, :usuario_id => current_user.id})
#      @demandantes = Persona.joins(:users, :constructions).where(:personas_roles_users => {:user_id => current_user.id}, :personas_constructions_roles=>{:role_id=>demandante.id}).uniq
      @demandantes = Persona.joins(:constructions).where(:personas_constructions_roles=>{:role_id=>demandante.id,:construction_id=>inmuebles_current}).uniq
    else
      redirect_to denegado_path
    end
  end
  
  def new
    demandante = Role.find_by_rol_nombre("Demandante")
    inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>"2",:user_id=>current_user}, :personas_constructions_roles=>{:construction_id => params[:construction_id]}).uniq
    demandante_current = PersonasConstructionsRole.where(:construction_id=>params[:construction_id], :role_id=>demandante.id)
    if (current_user and current_user.id == 1) or (current_user and inmuebles_current.exists? and inmuebles_current.find(params[:construction_id]) and demandante_current.exists? == false)
      @demandante = Persona.new
      @inmueble = Construction.find(params[:construction_id])
      @captaciones = Channel.find(:all)

      @rol_propietario = Role.find_by_rol_nombre("Propietario")
      @propietario = Persona.joins(:personas_constructions_roles).where(:personas_constructions_roles => {:construction_id => @inmueble.id, :role_id => @rol_propietario.id}).first
    else
      redirect_to denegado_path
    end
  end

  def edit
    
  end

  def create
    @inmueble = Construction.find(params[:construction_id])
    
    @role = Role.find_by_rol_nombre("Demandante")
    exito = "no"
    @person = Persona.new(params[:persona])

    @error_cedula = ""
    @error_apellido = ""
    @error_nombre = ""
    @error_direccion = ""
    @error_telefono2 = ""
    @error_email = ""
    respond_to do |format|
      form_valido = true
      filtro = "no"
      persona_email = Persona.find_by_pers_cedula(@person.pers_cedula)

      if (params[:demand_existe] == "yes" and @person.pers_email == "") or (params[:demand_existe] == "yes" and @person.pers_email == persona_email.pers_email) or @person.pers_email == ""
        @error_email = ""
        form_valido = true
        filtro = "yes"
      end
      
      if @person.valid? == false
        if @person.errors[:pers_cedula].empty? == false
          @error_cedula = @person.errors[:pers_cedula].to_s
          form_valido = false
          if @error_cedula == '["El Numero de Cedula ya existe, por favor ingrese uno diferente"]'
#            @tipo = "Cedula"
            @error_cedula = ""
            form_valido = true
          end
        end

        if @person.errors[:pers_email].empty? == false and filtro == "no"
          @error_email = @person.errors[:pers_email].to_s
          form_valido = false
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
      end

      if form_valido == false
        format.js { render "create.js"}
      else
#        format.js { render "mensaje.js"}
        if params[:demand_existe] == "yes"
          demandante = Persona.find_by_pers_cedula(@person.pers_cedula)
          #if demandante.update_attributes(pers_apellido: params[:pers_apellido], pers_nombre: params[:pers_nombre], pers_direccion: params[:pers_direccion], pers_telefono1: params[:pers_telefono1], pers_telefono2: params[:pers_telefono2], pers_email: params[:pers_email])
          if demandante.update_attributes(params[:persona])
            PersonasConstructionsRole.create(persona_id: demandante.id, construction_id: @inmueble.id, role_id: @role.id) #ASIGNAR UN DEMANDANTE A UN INMUEBLE
            exito = "yes"
          else
#            redirect_to new_person_path(:construction_id => @inmueble.id), :notice => "Verificar datos"
          end
        else
          if @person.save
            PersonasConstructionsRole.create(persona_id: @person.id, construction_id: @inmueble.id, role_id: @role.id) #ASIGNAR UN DEMANDANTE A UN INMUEBLE
            PersonasRolesUser.create(persona_id: @person.id, role_id: @role.id, user_id: current_user.id) #ASIGNAR UN DEMANDANTE A UN CORREDOR
            exito = "yes"
          else
#            redirect_to new_person_path(:construction_id => @inmueble.id), :notice => "Verificar datos"
          end
        end

        if exito == "yes"
          @inmueble.update_attributes(inm_estado: 'P')
          if params[:channel_ids].blank? == false
            params[:channel_ids].each do |ci|
              ConstructionsChannel.create(construction_id: @inmueble.id, channel_id: ci)
            end
          end
          format.html {redirect_to index_construction_path, :notice => "Registrado"}
        end
      end
    end

    #CODIGO ORIGINAL DESDE AQUI
#    if @person.save
#      @inmueble.update_attributes(inm_estado: 'P')
#      PersonasConstructionsRole.create(persona_id: @person.id, construction_id: @inmueble.id, role_id: @role.id) ASIGNAR UN DEMANDANTE A UN INMUEBLE
#      PersonasRolesUsuario.create(persona_id: @person.id, role_id: @role.id, usuario_id: current_user.id) ASIGNAR UN DEMANDANTE A UN CORREDOR
#      params[:channel_ids].each do |ci|
#        ConstructionsChannel.create(construction_id: @inmueble.id, channel_id: ci)
#      end
#      redirect_to index_construction_path, :notice => "Registrado"
#    else
#      redirect_to new_person_path(:construction_id => @inmueble.id), :notice => "Verificar datos"
#    end
    #HASTA AQUI
  end

  def update_demandante
    @propietario = Persona.find(params[:propietario])
    @misma_persona = "no"
    if Persona.where(:pers_cedula => params[:numero_cedula]).exists?
      @demandante = Persona.find_by_pers_cedula(params[:numero_cedula])
      if @propietario.pers_cedula == @demandante.pers_cedula
        @misma_persona = "yes"
      end
      @existe = "yes"
    else
      @demandante = nil
      @existe = "no"
    end
  end
  
  def lista
    #desde aqui
    #@det_pers_id = PersonasRolesUsuario.where(:usuario_id => current_user).pluck(:persona_id)
    #@rol = Role.where(:id => current_rol)
    #@lista_personas = Persona.where(:id => @det_pers_id)
    #hasta aqui es el cogigo original sin relacionar
    
    #@lista_personas = PersonasRolesUsuario.where(:usuario_id => current_user).joins(:persona)
    #@personas = Persona.find(params[:id])
    #@lista_personas = Persona.joins(:usuarios => :roles).where(:usuarios => {:id => current_user}, :roles => {:id => current_user.roles})
    @lista_personas = Persona.joins(:users).where(:personas_roles_users => {:user_id => current_user, :role_id => ['1','2']}).first
    @role = Role.joins(:users).where(:personas_roles_users => {:user_id => current_user, :role_id => ['1','2']}).first
    #@lista_personas = Usuario.joins(:personas).where(:id=>current_user)
    #@lista_personas = Persona.joins(:usuarios).where(:id=>)
    #@rol = Role.joins(:usuarios).where(:usuario_id=>current_user)
  end

  def reporte_demandante_formulario
    @estados_negociacion = [["En Proceso","P"],["Finalizado","I"],["Todos","T"]].to_a
    respond_to do |format|
      format.js {render "reporte_demandante_formulario.js"}
    end
  end

  def reporte_demandante
    @estados_negociacion = params[:estado_negociacion].first
    corredor = Role.find_by_rol_nombre("Corredor")
    inmuebles_current = Construction.joins(:personas=>:users).where(:constructions=>{:inm_estado=>@estados_negociacion},:personas_roles_users=>{:role_id=>corredor.id,:user_id=>current_user}).uniq
    demandante = Role.find_by_rol_nombre("Demandante")
    if @estados_negociacion == "P"  
      @estados_negociacion = "En Proceso"
    end
    if @estados_negociacion == "I"
      @estados_negociacion = "Finalizado"
    end
    if @estados_negociacion == "T"
      inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>corredor.id,:user_id=>current_user}).uniq
      @estados_negociacion = "Todos"
    end
    @demandantes = Persona.joins(:constructions).where(:personas_constructions_roles=>{:role_id=>demandante.id,:construction_id=>inmuebles_current}).uniq
#    @estado_mes = params[:estado_mes].first
#    @estado_anio = params[:estado_anio].first
#    rol_corredor = Role.find_by_rol_nombre("Corredor")
#    if @estado_pago == "C"
#      @personas = Persona.joins(:users=>:amounts).where(:personas_roles_users=>{:role_id=>rol_corredor.id}, :amounts=>{:amo_mes=>@estado_mes, :amo_anio=>@estado_anio}).uniq
#      @estado_pago = "Pagos al Dia"
#    else
#      @usuarios = User.joins(:amounts).where(:amounts=>{:amo_mes=>@estado_mes, :amo_anio=>@estado_anio}).uniq
#      usuarios_pendientes = []
#      contador = 0
#      @todos_usuarios = User.all
#      @todos_usuarios.each do |usu|
#        if @usuarios.find_by_id(usu.id)
#
#        else
#          usuarios_pendientes[contador] = usu
#          contador+=1
#        end
#      end
#      @personas = Persona.joins(:users).where(:personas_roles_users=>{:role_id=>rol_corredor.id},:users=>{:id=>usuarios_pendientes}).uniq
#      @estado_pago = "Pagos Pendientes"
#    end
#    @estado_mes = Amount.meses_string(@estado_mes.to_i)
    render :layout => false
  end
end
