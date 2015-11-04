require "redistat"

class ModelHelper1
  include Redistat::Model


end

class ModelHelper2
  include Redistat::Model

  depth :day
  store_event true
  hashed_label true

end

class ModelHelper3
  include Redistat::Model

  connect_to port: REDIS_PORT, db: REDIS_DB - 1

end

class ModelHelper4
  include Redistat::Model

  scope 'FancyHelper'
  expire hour: 24*3600

end
