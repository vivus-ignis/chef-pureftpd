actions :create, :delete

def initialize(*args)
  super
  @action = :create
end

attribute :name,               :kind_of => String, :name_attribute => true
attribute :chroot_to,          :kind_of => String
attribute :password,           :kind_of => String
#attribute :locked,             :kind_of => [ TrueClass, FalseClass ]
