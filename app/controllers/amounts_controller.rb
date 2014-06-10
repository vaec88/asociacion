class AmountsController < ApplicationController
  def index
#    rol_administrador = Role.find_by_rol_nombre("Administrador")
    rol_corredor = Role.find_by_rol_nombre("Corredor")
    rol_tesorero = Role.find_by_rol_nombre("Tesorero")
    rol_actual = Role.joins(:users).where(:personas_roles_users=>{:role_id=>rol_tesorero.id, :user_id=>current_user})
    persona =  Persona.joins(:users).where(:personas_roles_users=>{:persona_id=>params[:persona_id], :role_id=>rol_corredor.id, :user_id=>params[:usuario_id]}).uniq
    if current_user and rol_actual.exists? and persona.exists?
      @cuotas = Amount.where(:user_id => params[:usuario_id]).order("amo_anio DESC","amo_mes DESC")
      @usuario = User.find(params[:usuario_id])
      @persona = Persona.find(params[:persona_id])
      @cuota = Amount.new
      @mes = ""
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end
  
  def new
    @cuota = Amount.new
    @usuario = User.find(params[:usuario_id])
  end

  def create
    @bandera = ""
    @amo_cantidad = ""
    @amo_fecha = ""
    @cuota = Amount.new(params[:amount])
    id = params[:usuario_id]
    @cuota.user_id = id
    respond_to do |format|
      if (@cuota.amo_cantidad == nil) or (@cuota.amo_fecha == nil)
        if @cuota.amo_cantidad == nil
          @amo_cantidad = "blank"
        end
        if @cuota.amo_fecha == nil
          @amo_fecha = "blank"
        end
        @bandera = "blank"
        format.js { render "create.js"}
        #redirect_to novedades_path
      else
        if Amount.find_by_amo_mes_and_amo_anio_and_user_id(@cuota.amo_mes, @cuota.amo_anio, @cuota.user_id)
          @bandera = "exist"
          @mes = Amount.meses_string(@cuota.amo_mes)
          format.js { render "create.js"}
        else
          if @cuota.save
            ultima_cuota = Amount.where(:user_id => id).order("amo_anio","amo_mes").last
            if ultima_cuota.amo_anio < Time.zone.now.year
              @mes_anterior = 13
              if ultima_cuota.amo_mes == 12 and Time.zone.now.month == 1 and (Time.zone.now.year - ultima_cuota.amo_anio) == 1
                @mes_anterior = 12
              end
            else
              @mes_anterior = Time.zone.now.month - 1
            end

            if ultima_cuota.amo_mes < @mes_anterior
              User.find(id).update_attributes(usu_estado: 'I')
            else
              User.find(id).update_attributes(usu_estado: 'A')
            end

            format.html {redirect_to index_amount_path(:usuario_id => id, :persona_id=>params[:persona_id]), :notice => "Registro de cuota guardado con exito"}
#          else
#            redirect_to new_amount_path, :notice => "Verificar datos"
          end
        end
#        redirect_to index_person_path
      end
    end
  end

  def eliminar
    @cuota = Amount.find(params[:id])
    @persona = Persona.find(params[:persona_id])
    respond_to do |format|
      @mes = Amount.meses_string(@cuota.amo_mes)
      format.js { render "eliminar.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def destroy
    @cuota = Amount.find(params[:id])
    @cuota.destroy
    redirect_to index_amount_path(:usuario_id => @cuota.user_id, :persona_id=>params[:persona_id])
  end

  def edit
    @cuota = Amount.find(params[:id])
    @usuario = User.find(params[:usuario_id])
    @persona = Persona.find(params[:persona_id])
    respond_to do |format|
       format.js { render "edit.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def update
    @bandera = ""
    @amo_cantidad = ""
    @amo_fecha = ""
    @cuota = Amount.new(params[:amount])
    @cuota.user_id = params[:usuario_id]
    respond_to do |format|
      
      if (@cuota.amo_cantidad == nil) or (@cuota.amo_fecha == nil)
        if @cuota.amo_cantidad == nil
          @amo_cantidad = "blank"
        end
        if @cuota.amo_fecha == nil
          @amo_fecha = "blank"
        end
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_amount = Amount.find(params[:id])
        if Amount.find_by_amo_mes_and_amo_anio_and_user_id(@cuota.amo_mes, @cuota.amo_anio, @cuota.user_id) and (@cuota.amo_mes != aux_amount.amo_mes or @cuota.amo_anio != aux_amount.amo_anio)
          #format.js { render "errores.js"}
          @bandera = "exist"
          @mes = Amount.meses_string(@cuota.amo_mes)
          format.js { render "update.js"}
        else
          @cuota = Amount.find(params[:id])
          if @cuota.update_attributes(params[:amount])
            ultima_cuota = Amount.where(:user_id => params[:usuario_id]).order("amo_anio","amo_mes").last
            if ultima_cuota.amo_anio < Time.zone.now.year
              @mes_anterior = 13
              if ultima_cuota.amo_mes == 12 and Time.zone.now.month == 1 and (Time.zone.now.year - ultima_cuota.amo_anio) == 1
                @mes_anterior = 12
              end
            else
              @mes_anterior = Time.zone.now.month - 1
            end

            if ultima_cuota.amo_mes < @mes_anterior
              User.find(params[:usuario_id]).update_attributes(usu_estado: 'I')
            else
              User.find(params[:usuario_id]).update_attributes(usu_estado: 'A')
            end

            format.html {redirect_to index_amount_path(:usuario_id => params[:usuario_id], :persona_id=>params[:persona_id]), :notice => "Registro de cuota guardado con exito"}
#          else
#            redirect_to new_amount_path, :notice => "Verificar datos"
          end
        end
      end
      
    end
#    redirect_to index_amount_path(:usuario_id => @cuota.usuario_id)
  end
end