class CantonsController < ApplicationController
  def index
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>rol_administrador.id, :user_id=>current_user})
    if current_user and administrador.exists?
      @id = params[:province_id]
      @province = Province.find(@id)
      @cantones = Canton.joins(:province).where(:province_id=>@id)
      @canton = Canton.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def new
    @canton = Canton.new
    @id = params[:province_id]
  end

  def create
    @canton = Canton.new(params[:canton])
    respond_to do |format|
      @canton.cant_nombre = @canton.cant_nombre.gsub(/\s+/, " ").strip
      if @canton.cant_nombre == ""
        @bandera = "blank"
        format.js { render "create.js"}
      else
        if Canton.find_by_cant_nombre(@canton.cant_nombre)
          @bandera = "exist"
          format.js { render "create.js"}
        else
          mayuscula = (@canton.cant_nombre).upcase
          todos_cantones = Canton.all
          todos_cantones.each do |p|
            if (p.cant_nombre).upcase == mayuscula
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "create.js"}
          else
            if @canton.save
              format.html { redirect_to index_canton_path(:province_id => @canton.province_id), :notice => "Registrado"}
            end
          end
        end
      end
    end
  end

  def show
    @canton = Canton.find(params[:id])
  end

  def eliminar
    @canton = Canton.find(params[:id])
#    parroquias = Parish.where(:canton_id=>@canton.id)
    respond_to do |format|
      if Construction.joins(:parish=>:canton).where(:cantons=>{:id=>@canton.id}).exists?
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
    @canton = Canton.find(params[:id])
    @canton.destroy
    redirect_to index_canton_path(:province_id => @canton.province_id)
  end

  def edit
   @canton = Canton.find(params[:id])
   respond_to do |format|
     format.js { render "edit.js"}
   end
   rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def update
    @canton = Canton.new(params[:canton])
    respond_to do |format|
      @canton.cant_nombre = @canton.cant_nombre.gsub(/\s+/, " ").strip
      if @canton.cant_nombre == ""
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_canton = Canton.find(params[:id])
        if Canton.find_by_cant_nombre(@canton.cant_nombre) and (@canton.cant_nombre != aux_canton.cant_nombre)
          @bandera = "exist"
          format.js { render "update.js"}
        else
          mayuscula = (@canton.cant_nombre).upcase
          todos_cantones = Canton.all
          todos_cantones.each do |p|
            if ((p.cant_nombre).upcase == mayuscula) and (p.cant_nombre).upcase != (aux_canton.cant_nombre).upcase
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "update.js"}
          else
            @canton = Canton.find(params[:id])
            if @canton.update_attributes(params[:canton])
              format.html { redirect_to index_canton_path(:province_id => @canton.province_id), :notice => "Registrado"}
            end
          end
        end
      end
    end
  end
end
