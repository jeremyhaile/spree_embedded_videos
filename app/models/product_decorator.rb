Product.class_eval do
  has_many :videos, :as => :viewable, :order => :position, :dependent => :destroy
end