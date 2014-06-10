class DiariesController < ApplicationController
  def index
    if (current_user) and (current_user.id == params[:usuario_id].to_i)
      @usuario = User.find(params[:usuario_id])
      @actividades = Diary.where(:user_id => @usuario.id)
      @date = params[:month] ? Date.parse(params[:month]) : Date.today

      if @date.strftime("%B") == "January"
        @month = "Enero"
      end
      if @date.strftime("%B") == "February"
        @month = "Febrero"
      end
      if @date.strftime("%B") == "March"
        @month = "Marzo"
      end
      if @date.strftime("%B") == "April"
        @month = "Abril"
      end
      if @date.strftime("%B") == "May"
        @month = "Mayo"
      end
      if @date.strftime("%B") == "June"
        @month = "Junio"
      end
      if @date.strftime("%B") == "July"
        @month = "Julio"
      end
      if @date.strftime("%B") == "August"
        @month = "Agosto"
      end
      if @date.strftime("%B") == "September"
        @month = "Septiembre"
      end
      if @date.strftime("%B") == "October"
        @month = "Octubre"
      end
      if @date.strftime("%B") == "November"
        @month = "Noviembre"
      end
      if @date.strftime("%B") == "December"
        @month = "Diciembre"
      end
      #render :layout => false
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end

  def new
    if (current_user) and (current_user.id == params[:usuario_id].to_i)
      @actividad = Diary.new
      @usuario = User.find(params[:usuario_id])
      @fecha = params[:fecha_actual]
      @actividades = Diary.where(:user_id => @usuario.id, :age_fecha=>@fecha)
    else
      redirect_to denegado_path
    end
  end

  def create
    @fecha_actual = Time.zone.now.strftime('%Y-%m-%d')

    @actividad = Diary.new(params[:diary])
    @bandera = ""
    @age_actividad = ""
    @age_fecha = ""
    @age_hora = ""
    @age_direccion = ""

    respond_to do |format|
      @actividad.age_actividad = @actividad.age_actividad.gsub(/\s+/, " ").strip
      @actividad.age_direccion = @actividad.age_direccion.gsub(/\s+/, " ").strip
      if (@actividad.age_actividad == "") or (@actividad.age_fecha == nil) or (@actividad.age_hora == nil) or (@actividad.age_direccion == "")
        if @actividad.age_actividad == ""
          @age_actividad = "blank"
        end
        if @actividad.age_fecha == nil
          @age_fecha = "blank"
        end
        if @actividad.age_hora == nil
          @age_hora = "blank"
        end
        if @actividad.age_direccion == ""
          @age_direccion = "blank"
        end
        @bandera = "blank"
        format.js { render "create.js"}
      else
        @actividad.user_id = params[:usuario_id]
        @actividad.age_hora = @actividad.age_hora.strftime("%H:%M:%S")
        if @actividad.save
          format.html {redirect_to index_diary_path(:usuario_id => @actividad.user_id), :notice => "Registro guardado con Exito"}
        end
      end
    end
  end

  def edit
    @actividad = Diary.find(params[:id])
    respond_to do |format|
      format.js { render "edit.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def update
    @actividad = Diary.new(params[:diary])
    @bandera = ""
    @age_actividad = ""
    @age_fecha = ""
    @age_hora = ""
    @age_direccion = ""

    respond_to do |format|
      @actividad.age_actividad = @actividad.age_actividad.gsub(/\s+/, " ").strip
      @actividad.age_direccion = @actividad.age_direccion.gsub(/\s+/, " ").strip
      if (@actividad.age_actividad == "") or (@actividad.age_fecha == nil) or (@actividad.age_hora == nil) or (@actividad.age_direccion == "")
        if @actividad.age_actividad == ""
          @age_actividad = "blank"
        end
        if @actividad.age_fecha == nil
          @age_fecha = "blank"
        end
        if @actividad.age_hora == nil
          @age_hora = "blank"
        end
        if @actividad.age_direccion == ""
          @age_direccion = "blank"
        end
        @bandera = "blank"
        format.js { render "update.js"}
      else
        @actividad = Diary.find(params[:id])
        if @actividad.update_attributes(params[:diary])
          format.html {redirect_to index_diary_path(:usuario_id => @actividad.user_id), :notice => "Registro guardado con Exito"}
        end
      end
    end
  end

  def eliminar
    @actividad = Diary.find(params[:id])
    respond_to do |format|
      format.js { render "eliminar.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def destroy
    @actividad = Diary.find(params[:id])
    @actividad.destroy
    redirect_to index_diary_path(:usuario_id => @actividad.user_id)
  end
end