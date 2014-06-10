class MeetingsController < ApplicationController
  def index
    inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>"2",:user_id=>current_user}, :personas_constructions_roles=>{:construction_id => params[:construction_id]}).uniq
    if (current_user and current_user.id == 1) or (current_user and inmuebles_current.exists? and inmuebles_current.find(params[:construction_id]))
      @inmueble = Construction.find(params[:construction_id])
      @reuniones = Meeting.where(:construction_id => @inmueble.id)
      @reunion = Meeting.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end

  def new
    @reunion = Meeting.new
    @inmueble = Construction.find(params[:construction_id])
  end

  def create
    @reunion = Meeting.new(params[:meeting])
    @bandera = ""
    @reu_actores = ""
    @reu_detalle = ""
    
    respond_to do |format|
      @reunion.reu_actores = @reunion.reu_actores.gsub(/\s+/, " ").strip
      @reunion.reu_detalle = @reunion.reu_detalle.gsub(/\s+/, " ").strip
      if (@reunion.reu_actores == "") or (@reunion.reu_detalle == "")
        if @reunion.reu_actores == ""
          @reu_actores = "blank"
        end
        if @reunion.reu_detalle == ""
          @reu_detalle = "blank"
        end
        @bandera = "blank"
        format.js { render "create.js"}
      else
        @reunion.reu_fecha_hora = Time.zone.now
        @reunion.construction_id = params[:construction_id]
        if @reunion.save
          format.html {redirect_to index_meeting_path(:construction_id => @reunion.construction_id), :notice => "Registro guardado con Exito"}
        else
#          redirect_to new_meeting_path, :notice => "Verificar datos"
        end
      end
    end
  end

  def edit
    @reunion = Meeting.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
    respond_to do |format|
      format.js { render "edit.js"}
    end
  end

  def update
    @reunion = Meeting.new(params[:meeting])
    @bandera = ""
    @reu_actores = ""
    @reu_detalle = ""

    respond_to do |format|
      @reunion.reu_actores = @reunion.reu_actores.gsub(/\s+/, " ").strip
      @reunion.reu_detalle = @reunion.reu_detalle.gsub(/\s+/, " ").strip
      if (@reunion.reu_actores == "") or (@reunion.reu_detalle == "")
        if @reunion.reu_actores == ""
          @reu_actores = "blank"
        end
        if @reunion.reu_detalle == ""
          @reu_detalle = "blank"
        end
        @bandera = "blank"
        format.js { render "update.js"}
      else
        @reunion = Meeting.find(params[:id])
        if @reunion.update_attributes(params[:meeting])
          format.html {redirect_to index_meeting_path(:construction_id => @reunion.construction_id), :notice => "Registro guardado con Exito"}
        else
#          redirect_to new_meeting_path, :notice => "Verificar datos"
        end
      end
    end
  end

  def eliminar
    @reunion = Meeting.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
    respond_to do |format|
      format.js { render "eliminar.js"}
    end
  end

  def destroy
    @reunion = Meeting.find(params[:id])
    @reunion.destroy
    redirect_to index_meeting_path(:construction_id => @reunion.construction_id)
  end

  def reporte_meeting_formulario
    respond_to do |format|
      format.js {render "reporte_meeting_formulario.js"}
    end
  end

  def reporte_meeting
    inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>"2",:user_id=>current_user}, :personas_constructions_roles=>{:construction_id => params[:id]}).uniq
    if (current_user and current_user.id == 1) or (current_user and inmuebles_current.exists? and inmuebles_current.find(params[:id]))
      @inmueble = Construction.find(params[:id])
      @reuniones = Meeting.where(:construction_id => @inmueble.id)
      render :layout => false
    else
      redirect_to denegado_path
    end
  end
end
