class SessionsController < ApplicationController
  def new
    @datos = params[:datos]
    @cuenta = params[:cuenta]
  end

  def create
#    user = User.authenticate(params[:username], params[:password])
    user = login(params[:username], params[:password])
    rol_corredor = Role.find_by_rol_nombre("Corredor")
    rol_tesorero = Role.find_by_rol_nombre("Tesorero")
    if user#PARA SABER SI EL USUARIO Y CONTRASEÑA SON CORRECTOS
      #SI USUARIO Y CONTRASEÑA SON CORRECTOS, VERIFICAMOS SI LA CUENTA HA SIDO ACTIVADA
      persona = Persona.joins(:users).where(:personas_roles_users=>{:user_id=>user.id, :role_id=>["1","2"]}).first
      if persona and persona.pers_estado == "A"
        if User.joins(:roles).where(:id => user.id, :roles => {:id => rol_tesorero}).exists? == false and user.id != 1
          Amount.estados(user.id)
#          redirect_to ruta_prueba_path(:datos=>"entro por el if"), :notice => "Error!"
        else
          #COMPROBAR PAGO DE TODOS LOS CORREDORES EXCEPTO EL TESORERO
          usuario_tesorero = User.joins(:roles).where(:roles=>{:id=>rol_tesorero}).uniq.first
          @usuarios = User.joins(:roles).where(:roles=>{:id=>rol_corredor})
          @usuarios = @usuarios.where("users.id != ?", usuario_tesorero.id)
          @usuarios.each do |usu|
            Amount.estados(usu.id)
          end
#          cuenta = @usuarios
#          redirect_to ruta_prueba_path(:datos=>"entro por el else", :cuenta=>@usuarios.all), :notice => "Error!"
        end
        user = User.find(user.id)
        if user.usu_estado == "A"
          session[:user_id] = user.id
          redirect_to index_construction_path, :notice => "Conectado!"
        else
          redirect_to deudas_path, :notice => "Error!"
        end
      else
        redirect_to cuenta_inactiva_path
      end
    else
      redirect_to falla_sesion_path, :notice => "Error!"
    end
  end

  def destroy
    logout
#    session[:user_id] = nil
    redirect_to root_url, :notice => "Desconectado!"
  end
end