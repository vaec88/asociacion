class Amount < ActiveRecord::Base
  attr_accessible :amo_cantidad, :amo_mes, :amo_anio, :amo_fecha, :user_id
  belongs_to :user

  def self.estados(user_id)
    if Amount.where(:user_id => user_id).last
      ultima_cuota = Amount.where(:user_id => user_id).order("amo_anio","amo_mes").last
      if ultima_cuota.amo_anio < Time.zone.now.year
        @mes_anterior = 13
        if ultima_cuota.amo_mes == 12 and Time.zone.now.month == 1 and (Time.zone.now.year - ultima_cuota.amo_anio) == 1
          @mes_anterior = 12
        end
      else
        @mes_anterior = Time.zone.now.month - 1
      end

      if ultima_cuota.amo_mes < @mes_anterior
        User.find(user_id).update_attributes(usu_estado: 'I')
      else
        User.find(user_id).update_attributes(usu_estado: 'A')
      end
    end
  end

  def self.meses_string(mes)
    if mes == 1
      @mes = "Enero"
    end
    if mes == 2
      @mes = "Febrero"
    end
    if mes == 3
      @mes = "Marzo"
    end
    if mes == 4
      @mes = "Abril"
    end
    if mes == 5
      @mes = "Mayo"
    end
    if mes == 6
      @mes = "Junio"
    end
    if mes == 7
      @mes = "Julio"
    end
    if mes == 8
      @mes = "Agosto"
    end
    if mes == 9
      @mes = "Septiembre"
    end
    if mes == 10
      @mes = "Octubre"
    end
    if mes == 11
      @mes = "Noviembre"
    end
    if mes == 12
      @mes = "Diciembre"
    end
    return @mes
  end
end
