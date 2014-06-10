class PiecesController < ApplicationController
  def index
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>rol_administrador.id, :user_id=>current_user})
    if current_user and administrador.exists?
      @partes = Piece.find(:all)
      @parte = Piece.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end

  def new
    @parte = Piece.new
  end

  def create
    @parte = Piece.new(params[:piece])
    respond_to do |format|
      @parte.part_nombre = @parte.part_nombre.gsub(/\s+/, " ").strip
      if @parte.part_nombre == ""
        @bandera = "blank"
        format.js { render "create.js"}
      else
        if Piece.find_by_part_nombre(@parte.part_nombre)
          @bandera = "exist"
          format.js { render "create.js"}
        else
          mayuscula = (@parte.part_nombre).upcase
          todos_partes = Piece.all
          todos_partes.each do |p|
            if (p.part_nombre).upcase == mayuscula
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "create.js"}
          else
            if @parte.save
              format.html { redirect_to index_piece_path, :notice => "Registrado"}
            end
          end
        end
      end
    end
  end

  def show
    @parte = Piece.find(params[:id])
  end

  def eliminar
    @parte = Piece.find(params[:id])
    respond_to do |format|
      if ConstructionsPiece.find_by_piece_id(@parte.id)
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
    @parte = Piece.find(params[:id])
    @parte.destroy
    redirect_to index_piece_path
  end

  def edit
    @parte = Piece.find(params[:id])
    respond_to do |format|
      format.js { render "edit.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def update
    @parte = Piece.new(params[:piece])
    respond_to do |format|
      @parte.part_nombre = @parte.part_nombre.gsub(/\s+/, " ").strip
      if @parte.part_nombre == ""
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_parte = Piece.find(params[:id])
        if Piece.find_by_part_nombre(@parte.part_nombre) and (@parte.part_nombre != aux_parte.part_nombre)
          @bandera = "exist"
          format.js { render "update.js"}
        else
          mayuscula = (@parte.part_nombre).upcase
          todos_partes = Piece.all
          todos_partes.each do |p|
            if ((p.part_nombre).upcase == mayuscula) and (p.part_nombre).upcase != (aux_parte.part_nombre).upcase
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "update.js"}
          else
            @parte = Piece.find(params[:id])
            if @parte.update_attributes(params[:piece])
              format.html { redirect_to index_piece_path, :notice => "Registro Actualizado con Exito"}
            end
          end
        end
      end
    end
  end
end
