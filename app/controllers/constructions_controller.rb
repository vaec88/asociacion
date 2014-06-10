class ConstructionsController < ApplicationController
  def index
    if current_user
      #rol = Role.joins(:usuarios).where(:personas_roles_usuarios => {:usuario_id => current_user, :role_id => ['1']}).first
      persona = Persona.joins(:users).where(:personas_roles_users => {:user_id => current_user, :role_id => ['2']}).first
      if current_user.id == 1
        @inmueble = Construction.find(:all)
        @inmueble = Construction.where(:id => @inmueble).paginate(:page => params[:page], :per_page => 12)
        @json = @inmueble.all.to_gmaps4rails
      else
        @inmueble = Construction.joins(:personas).where(:personas_constructions_roles => {:persona_id => persona.id, :role_id => ['2']}).paginate(:page => params[:page], :per_page => 12)
        @json = @inmueble.all.to_gmaps4rails
      end

      @rol_demandante = Role.find_by_rol_nombre("Demandante")
      #PARA REALIZAR LA BUSQUEDA DE LOS INMUEBLES
      @operacion = Operation.find(:all)
      @propiedad = Property.find(:all)
      @provincia = Province.find(:all)
      @partes = Piece.find(:all)
      @canton = []
      @parroquia = []

#      @datos = params[:datos]
    else
      redirect_to denegado_path
    end
  end

  def search
    @operacion = Operation.find(:all)
    @propiedad = Property.find(:all)
    @provincia = Province.find(:all)
    @partes = Piece.find(:all)
    @canton = []
    @parroquia = []


    #partes = Piece.find(:all)
    persona = Persona.joins(:users).where(:personas_roles_users => {:user_id => current_user, :role_id => ['2']}).first
    if persona.nil?
      const_ids = Construction.find(:all)
      #const_ids = Construction.where(:inm_estado => "A")
      @search = Construction.where(:id => const_ids, :inm_estado => ["A","P"])
    else
      @search = Construction.joins(:personas).where(:personas_constructions_roles => {:persona_id => persona.id, :role_id => ['2']})
    end


    @search = @search.where('operation_id LIKE ?', params[:operation_id_search]) unless params[:operation_id_search].blank?
    @search = @search.where('property_id LIKE ?', params[:property_id_search]) unless params[:property_id_search].blank?
    #@search = @search.joins(:parish => {:canton => :province}).where('provinces.id LIKE ?', params[:province_id_search]) unless params[:province_id_search].blank?
    @search = @search.joins(:parish => {:canton => :province}).where(:provinces =>{:id => params[:province_id_search]}) unless params[:province_id_search].blank?
    #@search = @search.joins(:parish => :canton).where('cantons.id LIKE ?', params[:canton_id_search]) unless params[:canton_id_search].blank?
    @search = @search.joins(:parish => :canton).where(:cantons => {:id => params[:canton_id_search]}) unless params[:canton_id_search].blank?
    @search = @search.where('inm_val_merc >= ?', params[:precio_inmueble_1]) unless params[:precio_inmueble_1].blank?
    @search = @search.where('inm_val_merc <= ?', params[:precio_inmueble_2]) unless params[:precio_inmueble_2].blank?
#    partes.each do |p|
#      @search = @search.joins(:pieces).where('constructions_pieces.det_numero LIKE ?', params["piece_id_search_" + "#{p.id}"]) unless params["piece_id_search_" + "#{p.id}"].blank?
#    end

    #PARA CAPTURAR LOS IDS DE LAS PARTES QUE SE UTILIZA COMO PARAMETROS DE BUSQUEDA
    @piece_ids_current = []
    count = 0
    params[:piece_ids].each do |pi|
      if params["piece_id_search_" + "#{pi}"].blank?
        ""
      else
        @piece_ids_current[count] = pi
        count+=1
      end
    end

    #@search = @search.joins(:pieces).where("pieces.id in (?)",['2'||'3'])
    #@search = @search.joins(:pieces).where("pieces.id in (?)",@piece_ids_current.to_sentence(words_connector: '||'))

    @search = @search.joins(:pieces).uniq unless @search.joins(:pieces)
    const_piece_found =[]
    contador_inm = 0
    @search.each do |sear|
      contador_partes = 0
      @piece_ids_current.each do |pic|
        if ConstructionsPiece.find_by_construction_id_and_piece_id_and_det_numero(sear.id, pic, params["piece_id_search_" + "#{pic}"]).nil?

        else
          contador_partes+=1
        end
      end
      if contador_partes == @piece_ids_current.count()
        const_piece_found[contador_inm] = sear.id
        contador_inm+=1
      end
    end
    @search = @search.where(:id => const_piece_found).uniq

    @search = @search.paginate(:page => params[:page], :per_page => 12)
    @json = @search.all.to_gmaps4rails

    @rol_demandante = Role.find_by_rol_nombre("Demandante")
  end

  def new
    if current_user
      @inmueble = Construction.new
      @persona = Persona.new
      @operacion = Operation.find(:all)
      @propiedad = Property.find(:all)
      @provincia = Province.find(:all)
      @canton = []
      @parroquia = []

      @partes = Piece.find(:all)
      @medidas = ["Metros","Hectareas"]
      @pagos = ["Contado", "Credito"]
    else
      redirect_to denegado_path
    end
  end

  def update_cantons
#    @codigo = params[:index_number].to_i
    if (params[:index_number].to_i)!=0
      provincia = Province.find(params[:province_id])
      @canton = provincia.cantons.map{|c| [c.cant_nombre, c.id]}.insert(0, "Seleccione un Canton")
    else
      @canton =[].insert(0,"Seleccione un Canton")
    end
    @parroquia =[].insert(0,"Seleccione una Parroquia")
  end

  def update_parishes
    if (params[:index_number].to_i)!=0
      canton = Canton.find(params[:canton_id])
      @parroquia = canton.parishes.map{|p| [p.parr_nombre, p.id]}.insert(0, "Seleccione una Parroquia")
    else
      @parroquia =[].insert(0,"Seleccione una Parroquia")
    end
  end

  def update_propietario
    if Persona.where(:pers_cedula => params[:numero_cedula]).exists?
      @propietario = Persona.find_by_pers_cedula(params[:numero_cedula])
      @existe = "yes"
    else
      @propietario = nil
      @existe = "no"
    end
  end

  def create
    @inmueble = Construction.new(params[:construction])
    @inmueble.inm_estado = "A"
    @person = Persona.new(params[:persona])
    @role = Role.find_by_rol_nombre("Propietario")

    @error_operacion = ""
    @error_propiedad = ""
    @error_pago = ""

    @error_provincia = ""
    @error_canton = ""
    @error_parroquia = ""
    @error_latitud = ""

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
      if (params[:propiet_existe] == "yes" and @person.pers_email == "") or (params[:propiet_existe] == "yes" and @person.pers_email == persona_email.pers_email) or @person.pers_email == ""
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

      if @inmueble.valid? == false
        if @inmueble.errors[:operation_id].empty? == false
          @error_operacion = @inmueble.errors[:operation_id].to_s
        end
        if @inmueble.errors[:property_id].empty? == false
          @error_propiedad = @inmueble.errors[:property_id].to_s
        end
        if @inmueble.errors[:inm_forma_pago].empty? == false
          @error_pago = @inmueble.errors[:inm_forma_pago].to_s
        end
        if @inmueble.errors[:parish_id].empty? == false
          @error_parroquia = @inmueble.errors[:parish_id].to_s
        end
        if @inmueble.errors[:latitude].empty? == false
          @error_latitud = @inmueble.errors[:latitude].to_s
        end
        form_valido = false
      end

      if @inmueble.parish_id == 0
        @error_parroquia = '["Debe seleccionar una Parroquia"]'
        form_valido = false
      end



      if params[:piece_ids].blank?
        form_valido = false
      else
        params[:piece_ids].each do |pib|
          #@numero_detalle =
          if (params["det_numero_"+"#{pib}"]=="") or (params["det_descrip_"+"#{pib}"].to_s.gsub(/\s+/, " ").strip=="")
            form_valido = false
          end
        end
      end

      if form_valido == false
        format.js { render "create.js"}
      else
#        format.js { render "mensaje.js"}
        rol = Role.joins(:users).where(:personas_roles_users => {:user_id => current_user, :role_id => ['2']}).first #ROL DEL USUARIO ACTUAL
        persona = Persona.joins(:users).where(:personas_roles_users => {:user_id => current_user, :role_id => ['2']}).first #DATOS DEL USUARIO ACTUAL

        if params[:propiet_existe] == "yes"
          propietario = Persona.find_by_pers_cedula(@person.pers_cedula)
          if propietario.update_attributes(params[:persona]) and @inmueble.save
            PersonasConstructionsRole.create(persona_id: persona.id, construction_id: @inmueble.id, role_id: rol.id) #ASIGNAR UN CORREDOR A UN INMUEBLE
            PersonasConstructionsRole.create(persona_id: propietario.id, construction_id: @inmueble.id, role_id: @role.id) #ASIGNAR UN PROPIETARIO A UN INMUEBLE
            exito = "yes"
          else
#            redirect_to new_construction_path, :notice => "Verificar datos"
          end
        else

          if @person.save and @inmueble.save
            PersonasConstructionsRole.create(persona_id: persona.id, construction_id: @inmueble.id, role_id: rol.id) #ASIGNAR UN CORREDOR A UN INMUEBLE
            PersonasConstructionsRole.create(persona_id: @person.id, construction_id: @inmueble.id, role_id: @role.id) #ASIGNAR UN PROPIETARIO A UN INMUEBLE
            PersonasRolesUser.create(persona_id: @person.id, role_id: @role.id, user_id: current_user.id) #ASIGNAR UN PROPIETARIO A UN CORREDOR
            exito = "yes"
          else
#            redirect_to new_construction_path, :notice => "Verificar datos"
          end
        end

        if exito == "yes"
          params[:piece_ids].each do |pi|
            ConstructionsPiece.create(construction_id: @inmueble.id, piece_id: pi.to_i, det_numero: params["det_numero_"+"#{pi}"], det_descrip: params["det_descrip_"+"#{pi}"])
          end
          format.html {redirect_to index_construction_path, :notice => "Registrado"}
        end
      end
    end
  end

  def show
    inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>"2",:user_id=>current_user}, :personas_constructions_roles=>{:construction_id => params[:id]}).uniq
    if (current_user.nil? == true) or (current_user and current_user.id == 1) or (current_user and inmuebles_current.exists? and inmuebles_current.find(params[:id]))
      @inmueble = Construction.find(params[:id])

      @rol_corredor = Role.find_by_rol_nombre("Corredor")
      @corredor = Persona.joins(:constructions).where(:personas_constructions_roles => {:construction_id => @inmueble.id, :role_id => @rol_corredor.id}).first

      @rol_propietario = Role.find_by_rol_nombre("Propietario")
      @propietario = Persona.joins(:constructions).where(:personas_constructions_roles => {:construction_id => @inmueble.id, :role_id => @rol_propietario.id}).first

      @rol_demandante = Role.find_by_rol_nombre("Demandante")
      @demandante = Persona.joins(:constructions).where(:personas_constructions_roles => {:construction_id => @inmueble.id, :role_id => @rol_demandante.id}).first
    else
      redirect_to denegado_path
    end
  end

  def eliminar
    @inmueble = Construction.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
    respond_to do |format|
      format.js { render "eliminar.js"}
    end
  end

  def destroy
    @inmueble = Construction.find(params[:id])
    @inm_pers_const_rol = PersonasConstructionsRole.where(:construction_id=>@inmueble)
    @inm_const_param = ConstructionsParameter.where(:construction_id=>@inmueble)
    @inm_const_state = ConstructionsState.where(:construction_id=>@inmueble)
    @inm_const_price = ConstructionsPrice.where(:construction_id=>@inmueble)
    @inm_const_piece = ConstructionsPiece.where(:construction_id=>@inmueble)
    @inm_const_channel = ConstructionsChannel.where(:construction_id=>@inmueble)
    #ELIMINAR LOS REGISTROS DE ESAS TABLAS DETALLE
    @inm_pers_const_rol.each do |ipcr|
      ipcr.destroy
    end
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
    @inmueble.destroy
    redirect_to index_construction_path
  end

  def edit
    inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>"2",:user_id=>current_user}, :personas_constructions_roles=>{:construction_id => params[:id]}).uniq
    if (current_user and current_user.id == 1) or (current_user and inmuebles_current.exists? and inmuebles_current.find(params[:id]))
      @inmueble = Construction.find(params[:id])
      @operacion = Operation.find(:all)
      @propiedad = Property.find(:all)
      @captaciones = Channel.find(:all)
      @medidas = ["Metros","Hectareas"]
      @pagos = ["Contado", "Credito"]

      @provincia = Province.find(:all)
      @cod_prov = Province.joins(:cantons => :parishes).where(:parishes => {:id => @inmueble.parish_id})
      @canton = Canton.joins(:province).where(:province_id => @cod_prov)
      @cod_cant = Canton.joins(:parishes).where(:parishes => {:id => @inmueble.parish_id})
      @parroquia = Parish.joins(:canton).where(:canton_id => @cod_cant)

      @operacion_actual = Operation.find(@inmueble.operation_id)
      @propiedad_actual = Property.find(@inmueble.property_id)
      @parroquia_actual = Parish.find(@inmueble.parish_id)
      @canton_actual = Canton.find(@parroquia_actual.canton_id)
      @provincia_actual = Province.find(@canton_actual.province_id)

      @rol_propietario = Role.find_by_rol_nombre("Propietario")
      @propietario = Persona.joins(:personas_constructions_roles).where(:personas_constructions_roles => {:construction_id => @inmueble.id, :role_id => @rol_propietario.id}).first
  #    @persona_propiet = Persona.new

      @rol_demandante = Role.find_by_rol_nombre("Demandante")
      @demandante = Persona.joins(:personas_constructions_roles).where(:personas_constructions_roles => {:construction_id => @inmueble.id, :role_id => @rol_demandante.id}).first

      @partes = Piece.find(:all)
      @partes_const_actual = ConstructionsPiece.where(:construction_id => @inmueble.id)
    else
      redirect_to denegado_path
    end
  end

  def update
    @inmueble = Construction.new(params[:construction])
    @person = Persona.new(pers_cedula: params[:pers_cedula], pers_apellido: params[:pers_apellido], pers_nombre: params[:pers_nombre], pers_direccion: params[:pers_direccion], pers_telefono1: params[:pers_telefono1], pers_telefono2: params[:pers_telefono2], pers_email: params[:pers_email])
    
    @error_operacion = ""
    @error_propiedad = ""
    @error_pago = ""

    @error_provincia = ""
    @error_canton = ""
    @error_parroquia = ""
    @error_latitud = ""

    @error_cedula = ""
    @error_apellido = ""
    @error_nombre = ""
    @error_direccion = ""
    @error_telefono2 = ""
    @error_email = ""

    @error_cedula_demand = ""
    @error_apellido_demand = ""
    @error_nombre_demand = ""
    @error_direccion_demand = ""
    @error_telefono2_demand = ""
    @error_email_demand = ""

    @misma_persona = "no"
    @demandante_existe = "no"
    
    respond_to do |format|
      form_valido = true
      filtro = "no"
      persona_email = Persona.find_by_pers_cedula(@person.pers_cedula)

#       PARA VALIDAR EMAIL DEL PROPIETARIO
#      if (@person.pers_email == "") or (@person.pers_email == persona_email.pers_email)
      if (params[:propiet_existe] == "yes" and @person.pers_email == "") or (params[:propiet_existe] == "yes" and @person.pers_email == persona_email.pers_email) or @person.pers_email == ""
        form_valido = true
        @error_email = ""
        filtro = "yes"
      end

# SOLO SI EXISTE DEMANDANTE SE ACTUALIZA SUS DATOS
      if params[:demand_id].present?
        @demand = Persona.new(pers_cedula: params[:demand_cedula], pers_apellido: params[:demand_apellido], pers_nombre: params[:demand_nombre], pers_direccion: params[:demand_direccion], pers_telefono1: params[:demand_telefono1], pers_telefono2: params[:demand_telefono2], pers_email: params[:demand_email])
        filtro_demand = "no"
        demand_email = Persona.find_by_pers_cedula(@demand.pers_cedula)
#        PARA VALIDAR EMAIL DEL DEMANDANTE
        if (params[:demand_existe] == "yes" and @demand.pers_email == "") or (params[:demand_existe] == "yes" and @demand.pers_email == demand_email.pers_email) or @demand.pers_email == ""
          form_valido = true
          @error_email_demand = ""
          filtro_demand = "yes"
        end
        if (@demand.errors[:pers_cedula].empty? == false) #and (@person.pers_cedula != aux_propiet.pers_cedula)
          @error_cedula_demand = @demand.errors[:pers_cedula].to_s
          form_valido = false
          if @error_cedula_demand == '["El Numero de Cedula ya existe, por favor ingrese uno diferente"]'
            @error_cedula_demand = ""
            form_valido = true
          end
        end
      end
      
      if @person.valid? == false
#        aux_propiet = Persona.find(params[:pers_id])     1: activar esta linea
        if (@person.errors[:pers_cedula].empty? == false) #and (@person.pers_cedula != aux_propiet.pers_cedula)
          @error_cedula = @person.errors[:pers_cedula].to_s
          form_valido = false
          if @error_cedula == '["El Numero de Cedula ya existe, por favor ingrese uno diferente"]'
            @error_cedula = ""
            form_valido = true
          end
        end

        #1: para que funcione esta, reemplazar persona_email por aux_propiet
        if (@person.errors[:pers_email].empty? == false) and filtro == "no" #and (@person.pers_email != persona_email.pers_email)
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
#      PARA DEMANDANTE
      if params[:demand_id].present?
        @demandante_existe = "yes"
        if @demand.valid? == false
          if (@demand.errors[:pers_email].empty? == false) and filtro_demand == "no"
            @error_email_demand = @demand.errors[:pers_email].to_s
            form_valido = false
          end
          if @demand.errors[:pers_apellido].empty? == false
            @error_apellido_demand = @demand.errors[:pers_apellido].to_s
            form_valido = false
          end
          if @demand.errors[:pers_nombre].empty? == false
            @error_nombre_demand = @demand.errors[:pers_nombre].to_s
            form_valido = false
          end
          if @demand.errors[:pers_direccion].empty? == false
            @error_direccion_demand = @demand.errors[:pers_direccion].to_s
            form_valido = false
          end
          if @demand.errors[:pers_telefono2].empty? == false
            @error_telefono2_demand = @demand.errors[:pers_telefono2].to_s
            form_valido = false
          end
        end
        if (@person.pers_cedula == @demand.pers_cedula) or (@person.pers_email == @demand.pers_email)
          @misma_persona = "yes"
          form_valido = false
        end
      end

#      PARA VALIDAR INMUEBLE

      if @inmueble.valid? == false
        if @inmueble.errors[:operation_id].empty? == false
          @error_operacion = @inmueble.errors[:operation_id].to_s
        end
        if @inmueble.errors[:property_id].empty? == false
          @error_propiedad = @inmueble.errors[:property_id].to_s
        end
        if @inmueble.errors[:inm_forma_pago].empty? == false
          @error_pago = @inmueble.errors[:inm_forma_pago].to_s
        end
        if @inmueble.errors[:parish_id].empty? == false
          @error_parroquia = @inmueble.errors[:parish_id].to_s
        end
        if @inmueble.errors[:latitude].empty? == false
          @error_latitud = @inmueble.errors[:latitude].to_s
        end
        form_valido = false
      end

      if @inmueble.parish_id == 0
        @error_parroquia = '["Debe seleccionar una Parroquia"]'
        form_valido = false
      end

      if params[:piece_ids].blank?
        form_valido = false
      else
        params[:piece_ids].each do |pib|
          if (params["det_numero_"+"#{pib}"])=="" or (params["det_descrip_"+"#{pib}"].gsub(/\s+/, " ").strip)==""
            form_valido = false
          end
        end
      end

      if form_valido == false
        format.js {render "update.js"}
      else
        #format.js {render "mensaje.js"}
        #actualizar
        if params[:pers_id].present?
          @propietario = Persona.find(params[:pers_id])
          @propietario.update_attributes(pers_cedula: params[:pers_cedula], pers_apellido: params[:pers_apellido], pers_nombre: params[:pers_nombre], pers_direccion: params[:pers_direccion], pers_telefono1: params[:pers_telefono1], pers_telefono2: params[:pers_telefono2], pers_email: params[:pers_email])
        end

        if params[:demand_id].present?
          @demandante = Persona.find(params[:demand_id])
          @demandante.update_attributes(pers_cedula: params[:demand_cedula], pers_apellido: params[:demand_apellido], pers_nombre: params[:demand_nombre], pers_direccion: params[:demand_direccion], pers_telefono1: params[:demand_telefono1], pers_telefono2: params[:demand_telefono2], pers_email: params[:demand_email])
          params[:construction][:channel_ids]||=[]
        end

        @inmueble = Construction.find(params[:id])
        @inmueble.update_attributes(params[:construction])

        if params[:inm_estado] == "1"
          @inmueble.update_attributes(inm_estado: "A")
          role = Role.find_by_rol_nombre("Demandante")
          demand = Persona.find(params[:demand_id])
          PersonasConstructionsRole.find_by_persona_id_and_construction_id_and_role_id(demand.id, @inmueble.id, role.id).destroy
          const_chann = ConstructionsChannel.where(:construction_id=>@inmueble.id)
          const_chann.each do |cc|
            cc.destroy
          end
        end
        #@propietario.update_attributes(params[:persona])
        const_piece = ConstructionsPiece.where(:construction_id => @inmueble.id)

        params[:piece_actuals].each do |pa|
          existe = "no"
          params[:piece_ids].each do |pis|
            if pa == pis
              existe = "si"
            end
          end
          if existe == "no"
            const_piece.find_by_piece_id(pa).destroy
          end
        end

        params[:piece_ids].each do |pi|
          if const_piece.find_by_piece_id(pi)
            const_piece.find_by_piece_id(pi).update_attributes(det_numero: params["det_numero_"+"#{pi}"], det_descrip: params["det_descrip_"+"#{pi}"])
          else
            ConstructionsPiece.create(construction_id: @inmueble.id, piece_id: pi.to_i, det_numero: params["det_numero_"+"#{pi}"], det_descrip: params["det_descrip_"+"#{pi}"])
          end
        end
        format.html {redirect_to index_construction_path, :notice => "Registrado"}
      end
    end
  end

  def coordenadas
    respond_to do |format|
      format.js { render "coordenadas.js"}
    end
  end

  #FUNCION PARA CERRAR LA NEGOCIACION DEL INMUEBLE, SE LO HACE DESDE LA VISTA SHOW
  def close
    Construction.find(params[:construction_id]).update_attributes(inm_estado: "I")
    redirect_to index_construction_path
  end

  def pers_email_check
    @check = ""
    @accion = params[:accion].to_s
#    @email = params[:propiet_cedula]
    @person = Persona.find_by_pers_cedula(params[:propiet_cedula])
    if @accion == "new"
      if (Persona.find_by_pers_email(params[:pers_email]) and params[:propiet_existe]=="no") or (Persona.find_by_pers_email(params[:pers_email]) and params[:propiet_existe]=="yes" and params[:pers_email]!= @person.pers_email)
        @persona = Persona.find_by_pers_email(params[:pers_email])
        @check = "existe"
      else
        @check = "no_existe"
      end
    end
#    if @accion == "edit"
#      aux_person = Persona.find_by_pers_cedula(params[:propiet_cedula])
#      if (Persona.find_by_pers_email(params[:pers_email])) and (params[:pers_email] != aux_person.pers_email)
#        @persona = Persona.find_by_pers_email(params[:pers_email])
#        @check = "existe"
#      else
#        @check = "no_existe"
#      end
#    end
    if @accion == "edit"
      if (Persona.find_by_pers_email(params[:pers_email]) and params[:propiet_existe]=="no") or (Persona.find_by_pers_email(params[:pers_email]) and params[:propiet_existe]=="yes" and params[:pers_email]!= @person.pers_email)
        @persona = Persona.find_by_pers_email(params[:pers_email])
        @check = "existe"
        @email = params[:pers_email].to_s
      else
        @check = "no_existe"
        @email = params[:pers_email].to_s
      end
    end
  end

  def demand_email_check
    @check = ""
    @accion = params[:accion].to_s
    @person = Persona.find_by_pers_cedula(params[:demand_cedula])
    if @accion == "new" or @accion == "edit"
      if (Persona.find_by_pers_email(params[:demand_email]) and params[:demand_existe]=="no") or (Persona.find_by_pers_email(params[:demand_email]) and params[:demand_existe]=="yes" and params[:demand_email]!= @person.pers_email)
        @persona = Persona.find_by_pers_email(params[:demand_email])
        @check = "existe"
      else
        @check = "no_existe"
      end
    end
  end

  def todos
    if current_user
      rol_corredor = Role.find_by_rol_nombre("Corredor")
      @rol_propietario = Role.find_by_rol_nombre("Propietario")
      @rol_demandante = Role.find_by_rol_nombre("Demandante")
      persona = Persona.joins(:users).where(:personas_roles_users => {:user_id => current_user, :role_id => rol_corredor.id}).first
      if current_user.id == 1
        @inmueble = Construction.find(:all)
        @inmueble = Construction.where(:id => @inmueble).paginate(:page => params[:page], :per_page => 12)
      else
        @inmueble = Construction.joins(:personas).where(:personas_constructions_roles => {:persona_id => persona.id, :role_id => rol_corredor.id}).paginate(:page => params[:page], :per_page => 12)
      end
    else
      redirect_to denegado_path
    end
  end

  def reporte_constructions
    if current_user
      rol_corredor = Role.find_by_rol_nombre("Corredor")
      @rol_propietario = Role.find_by_rol_nombre("Propietario")
      @rol_demandante = Role.find_by_rol_nombre("Demandante")
      persona = Persona.joins(:users).where(:personas_roles_users => {:user_id => current_user, :role_id => rol_corredor.id}).first
      if current_user.id == 1
        @inmueble = Construction.find(:all)
        @inmueble = Construction.where(:id => @inmueble).paginate(:page => params[:page], :per_page => 12)
      else
        @inmueble = Construction.joins(:personas).where(:personas_constructions_roles => {:persona_id => persona.id, :role_id => rol_corredor.id}).paginate(:page => params[:page], :per_page => 12)
      end
      render :layout => false
    else
      redirect_to denegado_path
    end
  end
end