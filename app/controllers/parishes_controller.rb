class ParishesController < ApplicationController
  def index
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>rol_administrador.id, :user_id=>current_user})
    if current_user and administrador.exists?
      @id = params[:canton_id]
      @canton = Canton.find(@id)
      @province = Province.find(@canton.province_id)
      @parroquias = Parish.joins(:canton).where(:canton_id=>@id)
      @parroquia = Parish.new
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
    @parroquia = Parish.new
    @id = params[:canton_id]
  end

  def create
    @parroquia = Parish.new(params[:parish])
    respond_to do |format|
      @parroquia.parr_nombre = @parroquia.parr_nombre.gsub(/\s+/, " ").strip
      if @parroquia.parr_nombre == ""
        @bandera = "blank"
        format.js { render "create.js"}
      else
        @parroquias = Parish.where(:canton_id=>@parroquia.canton_id)
        if @parroquias.find_by_parr_nombre(@parroquia.parr_nombre)
          @bandera = "exist"
          format.js { render "create.js"}
        else
          mayuscula = (@parroquia.parr_nombre).upcase
          @parroquias.each do |p|
            if (p.parr_nombre).upcase == mayuscula
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "create.js"}
          else
            if @parroquia.save
              format.html { redirect_to index_parish_path(:canton_id => @parroquia.canton_id), :notice => "Registrado"}
            end
          end
        end
      end
    end
  end

  def show
    @parroquia = Parish.find(params[:id])
  end

  def eliminar
    @parroquia = Parish.find(params[:id])
    respond_to do |format|
      if Construction.find_by_parish_id(@parroquia.id)
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
    @parroquia = Parish.find(params[:id])
    @parroquia.destroy
    redirect_to index_parish_path(:canton_id => @parroquia.canton_id)
  end

  def edit
   @parroquia = Parish.find(params[:id])
   respond_to do |format|
     format.js { render "edit.js"}
   end
   rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def update
    @parroquia = Parish.new(params[:parish])
    respond_to do |format|
      @parroquia.parr_nombre = @parroquia.parr_nombre.gsub(/\s+/, " ").strip
      if @parroquia.parr_nombre == ""
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_parroquia = Parish.find(params[:id])
        @parroquias = Parish.where(:canton_id=>params[:canton_id])
        if @parroquias.find_by_parr_nombre(@parroquia.parr_nombre) and (@parroquia.parr_nombre != aux_parroquia.parr_nombre)
          @bandera = "exist"
          format.js { render "update.js"}
        else
          mayuscula = (@parroquia.parr_nombre).upcase
          @parroquias.each do |p|
            if ((p.parr_nombre).upcase == mayuscula) and (p.parr_nombre).upcase != (aux_parroquia.parr_nombre).upcase
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "update.js"}
          else
            @parroquia = Parish.find(params[:id])
            if @parroquia.update_attributes(params[:parish])
              format.html { redirect_to index_parish_path(:canton_id => @parroquia.canton_id), :notice => "Registrado"}
            end
          end
        end
      end
    end
  end
end
