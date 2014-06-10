class RolesController < ApplicationController
  def new
    @role = Role.new
  end

  def create
    @role = Role.new(params[:role])
    respond_to do |format|
      @role.rol_nombre = @role.rol_nombre.gsub(/\s+/, " ").strip
      if @role.rol_nombre == ""
        @bandera = "blank"
        format.js { render "create.js"}
      else
        if Role.find_by_rol_nombre(@role.rol_nombre)
          @bandera = "exist"
          format.js { render "create.js"}
        else
          mayuscula = (@role.rol_nombre).upcase
          todos_roles = Role.all
          todos_roles.each do |p|
            if (p.rol_nombre).upcase == mayuscula
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "create.js"}
          else
            if @role.save
              format.html { redirect_to index_role_path, :notice => "Registrado"}
            end
          end
        end
      end
    end
  end

  def index
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>rol_administrador.id, :user_id=>current_user})
    if current_user and administrador.exists?
      @roles = Role.find(:all)
      @role = Role.new
      respond_to do |format|
        format.js
        format.html
      end 
    else
      redirect_to denegado_path
    end
  end
  
  def show
    @roles = Role.find(params[:id])
  end

  def eliminar
    @role = Role.find(params[:id])
    respond_to do |format|
      if PersonasRolesUser.find_by_role_id(@role.id) or PersonasConstructionsRole.find_by_role_id(@role.id)
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
    @role= Role.find(params[:id])
    @role.destroy
    redirect_to index_role_path
  end

  def edit
    @roles= Role.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
    respond_to do |format|
      format.js { render "edit.js"}

      #PARA CAMBIAR DE ADMINISTRADOR
      rol_corredor = Role.find_by_rol_nombre("Corredor")
      rol_administrador = Role.find_by_rol_nombre("Administrador")
      @usuarios_corr = User.find(:all, :conditions => "id != '#{current_user.id}'")
      @corredores = Persona.joins(:users).where(:personas_roles_users=>{:role_id=>rol_corredor}, :users=>{:usu_estado=>"A",:id=>@usuarios_corr})
      @admin_corr = Persona.joins(:users).where(:personas_roles_users=>{:role_id=>rol_administrador}, :users=>{:usu_estado=>"A",:id=>@usuarios_corr}).first

      #PARA CAMBIAR DE TESORERO
      rol_tesorero = Role.find_by_rol_nombre("Tesorero")
      @teso_corr = Persona.joins(:users).where(:personas_roles_users=>{:role_id=>rol_tesorero}, :users=>{:usu_estado=>"A",:id=>@usuarios_corr}).first
    end
  end

  def update
    @role = Role.new(params[:role])
    respond_to do |format|
      @role.rol_nombre = @role.rol_nombre.gsub(/\s+/, " ").strip
      if @role.rol_nombre == ""
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_role = Role.find(params[:id])
        if Role.find_by_rol_nombre(@role.rol_nombre) and (@role.rol_nombre != aux_role.rol_nombre)
          @bandera = "exist"
          format.js { render "update.js"}
        else
          mayuscula = (@role.rol_nombre).upcase
          todos_roles = Role.all
          todos_roles.each do |p|
            if ((p.rol_nombre).upcase == mayuscula) and (p.rol_nombre).upcase != (aux_role.rol_nombre).upcase
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "update.js"}
          else
            @role= Role.find (params[:id])
            if @role.update_attributes(params[:role])
              if params[:persona_id]!=nil
                usuario_admin = User.joins(:personas).where(:personas_roles_users=>{:persona_id=>params[:persona_id]}).first
                #SI EL USUARIO ES EL PROGRAMADOR SE ASIGNA AL NUEVO ADMINISTRADOR SIN ELIMINAR AL PROGRAMADOR
                if (current_person!=1 and current_rol!=1 and current_user.id!=1)
                  PersonasRolesUser.create(persona_id: params[:persona_id], role_id: @role.id, user_id: usuario_admin.id)
                  PersonasRolesUser.find_by_persona_id_and_role_id_and_user_id(current_person,@role.id,current_user.id).destroy
                  format.html {redirect_to log_out_path}
                else
                  if params[:persona_id_old]==nil
                    PersonasRolesUser.create(persona_id: params[:persona_id], role_id: @role.id, user_id: usuario_admin.id)
                  end
                  #TENGO QUE ELIMINAR OLD_ADMIN
                  if params[:persona_id_old]!=nil and params[:persona_id]!=params[:persona_id_old]
                    usuario_admin_old = User.joins(:personas).where(:personas_roles_users=>{:persona_id=>params[:persona_id_old]}).first
                    PersonasRolesUser.create(persona_id: params[:persona_id], role_id: @role.id, user_id: usuario_admin.id)
                    PersonasRolesUser.find_by_persona_id_and_role_id_and_user_id(params[:persona_id_old],@role.id,usuario_admin_old.id).destroy
                  end
                  format.html {redirect_to index_role_path}
                end
                #HASTA AQUI
              else
                #EL CAMBIO DE TESORERO SOLO LO PUEDE HACER EL ADMINISTRADOR
                if params[:persona_teso_id]!=nil
                  usuario_teso = User.joins(:personas).where(:personas_roles_users=>{:persona_id=>params[:persona_teso_id]}).first
                  if params[:persona_teso_id_old]==nil
                    PersonasRolesUser.create(persona_id: params[:persona_teso_id], role_id: @role.id, user_id: usuario_teso.id)
                  end

                  if params[:persona_teso_id_old]!=nil and params[:persona_teso_id]!=params[:persona_teso_id_old]
                    usuario_teso_old = User.joins(:personas).where(:personas_roles_users=>{:persona_id=>params[:persona_teso_id_old]}).first
                    PersonasRolesUser.create(persona_id: params[:persona_teso_id], role_id: @role.id, user_id: usuario_teso.id)
                    PersonasRolesUser.find_by_persona_id_and_role_id_and_user_id(params[:persona_teso_id_old],@role.id,usuario_teso_old.id).destroy
                  end
                end
                format.html {redirect_to index_role_path}
              end
            end
          end
        end
      end
    end
  end
end