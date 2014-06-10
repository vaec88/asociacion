class ChannelsController < ApplicationController
  def index
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>rol_administrador.id, :user_id=>current_user})
    if current_user and administrador.exists?
      @captaciones = Channel.find(:all)
      @captacion = Channel.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end
  
  def new
    @captacion = Channel.new
  end

  def create
    @captacion = Channel.new(params[:channel])
    respond_to do |format|
      @captacion.capt_nombre = @captacion.capt_nombre.gsub(/\s+/, " ").strip
      if @captacion.capt_nombre == ""
        @bandera = "blank"
        format.js { render "create.js"}
      else
        if Channel.find_by_capt_nombre(@captacion.capt_nombre)
          @bandera = "exist"
          format.js { render "create.js"}
        else
          mayuscula = (@captacion.capt_nombre).upcase
          todos_captaciones = Channel.all
          todos_captaciones.each do |p|
            if (p.capt_nombre).upcase == mayuscula
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "create.js"}
          else
            if @captacion.save
              format.html { redirect_to index_channel_path, :notice => "Registrado"}
            end
          end
        end
      end
    end
  end

  def show
    @captacion = Channel.find(params[:id])
  end

  def eliminar
    @captacion = Channel.find(params[:id])
    respond_to do |format|
      if ConstructionsChannel.find_by_channel_id(@captacion.id)
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
    @captacion = Channel.find(params[:id])
    @captacion.destroy
    redirect_to index_channel_path
  end

  def edit
   @captacion = Channel.find(params[:id])
   respond_to do |format|
     format.js { render "edit.js"}
   end
   rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def update
    @captacion = Channel.new(params[:channel])
    respond_to do |format|
      @captacion.capt_nombre = @captacion.capt_nombre.gsub(/\s+/, " ").strip
      if @captacion.capt_nombre == ""
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_captacion = Channel.find(params[:id])
        if Channel.find_by_capt_nombre(@captacion.capt_nombre) and (@captacion.capt_nombre != aux_captacion.capt_nombre)
          @bandera = "exist"
          format.js { render "update.js"}
        else
          mayuscula = (@captacion.capt_nombre).upcase
          todos_captaciones = Channel.all
          todos_captaciones.each do |p|
            if ((p.capt_nombre).upcase == mayuscula) and (p.capt_nombre).upcase != (aux_captacion.capt_nombre).upcase
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "update.js"}
          else
            @captacion = Channel.find(params[:id])
            if @captacion.update_attributes(params[:channel])
              format.html { redirect_to index_channel_path, :notice => "Registrado"}
            end
          end
        end
      end
    end
  end
end
