class ProvincesController < ApplicationController
  def index
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>rol_administrador.id, :user_id=>current_user})
    if current_user and administrador.exists?
      @provincias = Province.find(:all)
      @provincia = Province.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end

  def new
    @provincia = Province.new
  end

  def create
    @provincia = Province.new(params[:province])
    respond_to do |format|
      @provincia.prov_nombre = @provincia.prov_nombre.gsub(/\s+/, " ").strip
      if @provincia.prov_nombre == ""
        @bandera = "blank"
        format.js { render "create.js"}
      else
        if Province.find_by_prov_nombre(@provincia.prov_nombre)
          @bandera = "exist"
          format.js { render "create.js"}
        else
          mayuscula = (@provincia.prov_nombre).upcase
          todos_provincias = Province.all
          todos_provincias.each do |p|
            if (p.prov_nombre).upcase == mayuscula
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "create.js"}
          else
            if @provincia.save
              format.html { redirect_to index_province_path, :notice => "Registrado"}
            end
          end
        end
      end
    end
  end

  def show
    @provincia = Province.find(params[:id])
  end

  def eliminar
    @provincia = Province.find(params[:id])
    respond_to do |format|
      if Construction.joins(:parish=>:canton).where(:cantons=>{:province_id=>@provincia.id}).exists?
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
    @provincia = Province.find(params[:id])
    @provincia.destroy
    redirect_to index_province_path
  end

  def edit
    @provincia = Province.find(params[:id])
    respond_to do |format|
      format.js { render "edit.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def update
    @provincia = Province.new(params[:province])
    respond_to do |format|
      @provincia.prov_nombre = @provincia.prov_nombre.gsub(/\s+/, " ").strip
      if @provincia.prov_nombre == ""
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_provincia = Province.find(params[:id])
        if Province.find_by_prov_nombre(@provincia.prov_nombre) and (@provincia.prov_nombre != aux_provincia.prov_nombre)
          @bandera = "exist"
          format.js { render "update.js"}
        else
          mayuscula = (@provincia.prov_nombre).upcase
          todos_provincias = Province.all
          todos_provincias.each do |p|
            if ((p.prov_nombre).upcase == mayuscula) and (p.prov_nombre).upcase != (aux_provincia.prov_nombre).upcase
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "update.js"}
          else
            @provincia = Province.find(params[:id])
            if @provincia.update_attributes(params[:province])
              format.html { redirect_to index_province_path, :notice => "Registrado"}
            end
          end
        end
      end
    end
  end
end