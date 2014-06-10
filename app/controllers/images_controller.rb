class ImagesController < ApplicationController
  def index
    inmuebles_current = Construction.joins(:personas=>:users).where(:personas_roles_users=>{:role_id=>"2",:user_id=>current_user}, :personas_constructions_roles=>{:construction_id => params[:construction_id]}).uniq
    if (current_user and current_user.id == 1) or (current_user and inmuebles_current.exists? and inmuebles_current.find(params[:construction_id]))
      @inmueble = Construction.find(params[:construction_id])
      @image = Image.new
    else
      redirect_to denegado_path
    end
  end

  def create
    @image = Image.new(params[:image])
    @error = ""
    respond_to do |format|
      if @image.valid? == false
        if @image.errors[:img_path].empty? == false
          @error = "No ha seleccionado ninguna imagen"
          format.js { render "error.js"}
        end
        format.html {
        redirect_to index_images_path(:construction_id => params[:construction_id]), :notice => 'Falla'}
      else
#        @image.construction_id = params[:construction_id]
#        @image.save
        format.html {
          redirect_to index_images_path(:construction_id => params[:construction_id]), :notice => 'Exito'
        }
      end
    end
  end

  def eliminar
    @imagen = Image.find(params[:id])
    respond_to do |format|
      format.js { render "eliminar.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end
  def destroy
    @imagen = Image.find(params[:id])
    construction = Construction.find(@imagen.construction_id)
    @imagen.destroy
    redirect_to index_images_path(:construction_id => construction)
  end
end
