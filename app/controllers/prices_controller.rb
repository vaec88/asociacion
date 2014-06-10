class PricesController < ApplicationController
  def index
    rol_administrador = Role.find_by_rol_nombre("Administrador")
    administrador = User.joins(:roles).where(:personas_roles_users=>{:role_id=>rol_administrador.id, :user_id=>current_user})
    if current_user and administrador.exists?
      @tablas_avaluos = Price.find(:all)
      @tabla_avaluo = Price.new
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to denegado_path
    end
  end
  
  def new
    @tabla_avaluo = Price.new
  end

  def create
    @tabla_avaluo = Price.new(params[:price])
    respond_to do |format|
      @tabla_avaluo.aval_descrip = @tabla_avaluo.aval_descrip.gsub(/\s+/, " ").strip
      if @tabla_avaluo.aval_descrip == ""
        @bandera = "blank"
        format.js { render "create.js"}
      else
        if Price.find_by_aval_descrip(@tabla_avaluo.aval_descrip)
          @bandera = "exist"
          format.js { render "create.js"}
        else
          mayuscula = (@tabla_avaluo.aval_descrip).upcase
          todos_tabla_avaluos = Price.all
          todos_tabla_avaluos.each do |p|
            if (p.aval_descrip).upcase == mayuscula
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "create.js"}
          else
            if @tabla_avaluo.save
              format.html { redirect_to index_price_path, :notice => "Registrado"}
            end
          end
        end
      end
    end
  end

  def show
    @tabla_avaluo = Price.find(params[:id])
  end

  def eliminar
    @tabla_avaluo = Price.find(params[:id])
    respond_to do |format|
      if ConstructionsPrice.find_by_price_id(@tabla_avaluo.id)
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
    @tabla_avaluo = Price.find(params[:id])

    #OBTENEMOS LOS INMUEBLES QUE TIENEN ASOCIADA LA DESCRIPCION A ELEMINAR
    inmuebles = Construction.find(:all, :conditions => "inm_estado != 'I'")
    inm_avaluo_update = Construction.joins(:constructions_prices).where(:constructions_prices=>{:construction_id => inmuebles, :price_id => @tabla_avaluo.id}).select("distinct constructions_prices.construction_id")
    inm_avaluo_update = Construction.where(:id => inm_avaluo_update)

    #GUARDAMOS EN UN ARREGLO LOS IDS DE LOS INMUEBLES
    ids_inm = []
    cont = 0
    inm_avaluo_update.each do |iau|
      ids_inm[cont] = iau.id
      cont+=1
    end

    #ELIMINAMOS LOS REGISTROS QUE CORRESPONDEN A LA TABLA DETALLE
    detalle_price = ConstructionsPrice.where(:price_id => @tabla_avaluo.id)
    detalle_price.each do |dp|
      dp.destroy
    end

    #VOLVEMOS A BUSCAR LOS INMUEBLES CON LOS IDS DEL ARREGLO
    inm_avaluo_update = Construction.where(:id => ids_inm)
    inmuebles_count = inm_avaluo_update.count()

    #ACTUALIZAMOS EL AVALUO DE LOS INMUEBLES
    for i in 0..(inmuebles_count-1)
      suma0 = 0
      suma1 = 0
      suma2 = 0

      tabla_prices = ConstructionsPrice.where(:construction_id=>inm_avaluo_update[i].id)
      tabla_prices.each do |tp|
        suma0+=tp.det_val_tot
      end

      parametros = ConstructionsParameter.where(:construction_id=>inm_avaluo_update[i].id)
      parametros.each do |p|
        suma1+=p.description.param_val_unit
      end

      estados = ConstructionsState.where(:construction_id=>inm_avaluo_update[i].id)
      estados.each do |e|
        suma2+=e.state.met_val_unit
      end
      inm = Construction.find(inm_avaluo_update[i].id)
      nuevo_avaluo = suma0 + suma1 + suma2
      inm.update_attributes(inm_val_real: suma0, inm_val_merc: nuevo_avaluo)
    end

    @tabla_avaluo.destroy
    redirect_to index_price_path
  end

  def edit
    @tabla_avaluo = Price.find(params[:id])
    respond_to do |format|
      format.js { render "edit.js"}
    end
    rescue ActiveRecord::RecordNotFound
      redirect_to denegado_path
    return
  end

  def update
    @tabla_avaluo = Price.new(params[:price])
    respond_to do |format|
      @tabla_avaluo.aval_descrip = @tabla_avaluo.aval_descrip.gsub(/\s+/, " ").strip
      if @tabla_avaluo.aval_descrip == ""
        @bandera = "blank"
        format.js { render "update.js"}
      else
        aux_tabla_avaluo = Price.find(params[:id])
        if Price.find_by_aval_descrip(@tabla_avaluo.aval_descrip) and (@tabla_avaluo.aval_descrip != aux_tabla_avaluo.aval_descrip)
          @bandera = "exist"
          format.js { render "update.js"}
        else
          mayuscula = (@tabla_avaluo.aval_descrip).upcase
          todos_tabla_avaluos = Price.all
          todos_tabla_avaluos.each do |p|
            if ((p.aval_descrip).upcase == mayuscula) and (p.aval_descrip).upcase != (aux_tabla_avaluo.aval_descrip).upcase
              @bandera = "exist"
            end
          end
          if @bandera == "exist"
            format.js { render "update.js"}
          else
            @tabla_avaluo = Price.find(params[:id])
            if @tabla_avaluo.update_attributes(params[:price])
              format.html { redirect_to index_price_path, :notice => "Registro Actualizado con Exito"}
            end
          end
        end
      end
    end
  end
end
