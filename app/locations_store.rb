class LocationsStore
  def self.shared
    @shared ||= LocationsStore.new
  end

  def initialize
    model = NSManagedObjectModel.new
    model.entities = [Location.entity]
    
    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents',
                                                'Locations.sqlite'))
    error_ptr = Pointer.new(:object)
    unless store.addPersistentStoreWithType(NSSQLiteStoreType,
                                            configuration: nil,
                                            URL: store_url,
                                            options: nil,
                                            error: error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end

    context = NSManagedObjectContext.new
    context.persistentStoreCoordinator = store
    @context = context
  end

  def locations
    @locations ||=
      begin
        request = NSFetchRequest.new
        request.entity = NSEntityDescription.
          entityForName('Location',
                        inManagedObjectContext: @context)
        request.sortDescriptors = [NSSortDescriptor.alloc.initWithKey('creation_date',
                                                                      ascending: false)]
        error_ptr = Pointer.new(:object)
        data = @context.executeFetchRequest(request, error: error_ptr)
        raise "Error when fetching data: #{error_ptr[0].description}" if data.nil?
        data
      end
  end

  def add_location
    yield NSEntityDescription.insertNewObjectForEntityForName(
      'Location',
      inManagedObjectContext: @context
    )
    save
  end

  def remove_location(location)
    @context.deleteObject(location)
    save
  end

  def save
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
    @locations = nil
  end
end
