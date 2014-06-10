class PersonasRolesUsuariosController < ApplicationController
  def nombres
    @list_nombre = PersonasRolesUser.find(:all)
  end
end
