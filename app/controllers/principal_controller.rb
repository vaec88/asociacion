class PrincipalController < ApplicationController
  def index
    @operacion = Operation.find(:all)
    @propiedad = Property.find(:all)
    @provincia = Province.find(:all)
    @partes = Piece.find(:all)
    @canton = []
    @parroquia = []
    #@inmueble = Construction.paginate(:page => params[:page], :per_page => 3)
    @inmueble = Construction.where(:inm_estado => ["A","P"]).paginate(:page => params[:page], :per_page => 12)
    @json = @inmueble.to_gmaps4rails
#    User.find(5).update_attributes(usu_estado: "I")
    respond_to do |format|
      format.js
      format.html
    end
  end

  def directivos
    respond_to do |format|
      @bandera = "directivos"
      format.js { render "contenidos.js"}
      format.html
    end
  end

  def mision
    respond_to do |format|
      @bandera = "mision"
      format.js { render "contenidos.js"}
      format.html
    end
  end

  def vision
  end

  def propiedades
  end

  def novedades
  end

  def falla_sesion
  end

  def ingresaste
  end

  def deudas
  end

  def cuenta_inactiva
  end
  
  def resena
    respond_to do |format|
      @bandera = "resena"
      format.js { render "contenidos.js"}
      format.html
    end
  end

  def etica
    respond_to do |format|
      @bandera = "etica"
      format.js { render "contenidos.js"}
      format.html
    end
  end

  def ley
    respond_to do |format|
      @bandera = "ley"
      format.js { render "contenidos.js"}
      format.html
    end
  end

  def reglamento
    respond_to do |format|
      @bandera = "reglamento"
      format.js { render "contenidos.js"}
      format.html
    end
  end

  def contacto
  end

  def denegado
  end
end