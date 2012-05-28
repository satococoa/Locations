class Location < NSManagedObject
  def self.entity
    @entity ||=
      begin
        entity = NSEntityDescription.new
        entity.name = 'Location'
        entity.managedObjectClassName = 'Location'
        entity.properties = 
          ['creation_date', NSDateAttributeType,
           'latitude', NSDoubleAttributeType,
           'longitude', NSDoubleAttributeType].each_slice(2).map do |name, type|
             property = NSAttributeDescription.new
             property.name = name
             property.attributeType = type
             property.optional = false
             property
           end
           entity
      end
  end
end
