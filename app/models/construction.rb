class Construction < ActiveRecord::Base
  attr_accessible :name, :address, :inm_ciudadela, :inm_calle, :latitude, :longitude, :inm_conjunto, :inm_vivienda, :inm_unid_med, :inm_estado, :inm_val_real, :inm_val_merc, :inm_forma_pago, :inm_val_honor,:operation_id, :property_id, :parish_id, :channel_ids
  #geocoded_by :inm_calle
  #after_validation :geocode, :if => :inm_calle_changed?
  acts_as_gmappable :process_geocoding => false
      def gmaps4rails_address
          self.inm_calle
      end
       def gmaps4rails_infowindow
         fotos = Image.where(:construction_id=>self.id)
         if fotos.exists?
           "<h4>#{self.inm_ciudadela}</h4>" << "<h4>#{self.inm_calle}</h4>" << "#{fotos.first.id}" << "#{ActionController::Base.helpers.image_tag self.images.first.img_path.url(:thumb)}"
         else
           "<h4>#{self.inm_ciudadela}</h4>" << "<h4>#{self.inm_calle}</h4>"
         end
         #cons = Construction.where(:id=>id_cons)
         
         #"#{id_cons}"<<"<h4>#{self.inm_ciudadela}</h4>" << "<h4>#{self.inm_calle}</h4>" << "#{puta.count()}" << "#{ActionController::Base.helpers.image_tag Image.first.img_path.url(:thumb)}" #<< "#{Image.first.img_path.url(:original)}" << "<img src='/images/back4.gif'>"
         #self.images.each.first.img_path.url(:thumb)
         #asset_path img.img_path.url(:thumb)
         #"<img src='#{Image.first.img_path.url(:original)}'>"
         #"<h4>#{self.inm_ciudadela}</h4>" << "<h4>#{self.inm_calle}</h4>" << "<h4>#{image_tag Image.first.img_path.url(:thumb)}</h4>"
     end

  has_many :personas_constructions_roles#, :dependent => :delete_all
  has_many :personas, :through => :personas_constructions_roles

  has_many :personas_constructions_roles#, :dependent => :delete_all
  has_many :roles, :through => :personas_constructions_roles

  has_many :constructions_pieces, :dependent => :delete_all
  has_many :pieces, :through => :constructions_pieces

  has_many :constructions_prices#, :dependent => :delete_all
  has_many :prices, :through => :constructions_prices

  has_many :constructions_states#, :dependent => :delete_all
  has_many :states, :through => :constructions_states

  has_many :constructions_parameters#, :dependent => :delete_all
  has_many :parameters, :through => :constructions_parameters

  #has_many :areas, :class_name=>"Area"#, :foreign_key => "construction_id"#, :dependent => :delete_all
  #has_many :prices, :through => :areas

  #has_and_belongs_to_many :states, :join_table => :constructions_states

  has_many :constructions_channels#, :dependent => :delete_all
  has_many :channels, :through => :constructions_channels

  has_many :solicitudes, :dependent => :destroy
  has_many :meetings, :dependent => :destroy
  has_many :honoraries, :dependent => :destroy
  has_many :images, :dependent => :destroy
  belongs_to :operation
  belongs_to :property
  #belongs_to :channel
  belongs_to :parish

  validates :latitude,
            :presence => {:message => "Debe seleccionar un Ubicacion en el Mapa"}

  validates :operation_id,
            :presence => {:message => "Debe seleccionar un Tipo de Operacion"}

  validates :property_id,
            :presence => {:message => "Debe seleccionar un Tipo de Propiedad"}

  validates :inm_forma_pago,
            :presence => {:message => "Debe seleccionar una Forma de Pago"}

  validates :parish_id,
            :presence => {:message => "Debe seleccionar una Parroquia"}
          
  validate :blanco
  def blanco
    self.inm_ciudadela = self.inm_ciudadela.gsub(/\s+/, " ").strip
    self.inm_calle = self.inm_calle.gsub(/\s+/, " ").strip
    self.inm_conjunto = self.inm_conjunto.gsub(/\s+/, " ").strip
  end

  def self.actualizar_avaluo_inm(inmuebles_count, inm_avaluo_update)
    for i in 0..(inmuebles_count-1)
      suma1 = 0
      suma2 = 0
      parametros = ConstructionsParameter.where(:construction_id=>inm_avaluo_update[i].id)
      parametros.each do |p|
        suma1+=p.description.param_val_unit
      end
      estados = ConstructionsState.where(:construction_id=>inm_avaluo_update[i].id)
      estados.each do |e|
        suma2+=e.state.met_val_unit
      end
      inm = Construction.find(inm_avaluo_update[i].id)
      nuevo_avaluo = inm.inm_val_real + suma1 + suma2
      inm.update_attributes(inm_val_merc: nuevo_avaluo)
    end
  end
end