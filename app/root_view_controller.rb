class RootViewController < UITableViewController
  def viewDidLoad
    super
    self.title = 'Locations'
    self.navigationItem.leftBarButtonItem = self.editButtonItem
    @addButton = UIBarButtonItem.alloc.
      initWithBarButtonSystemItem(UIBarButtonSystemItemAdd,
                                  target: self,
                                  action: 'addEvent')
    @addButton.enabled = false
    self.navigationItem.rightBarButtonItem = @addButton

    # start location manager
    locationManager.startUpdatingLocation
  end

  def locationManager
    @locationManager ||= begin
      manager = CLLocationManager.alloc.init
      manager.desiredAccuracy = KCLLocationAccuracyNearestTenMeters
      manager.delegate = self
      manager
    end
  end

  def addEvent
    puts 'ADDED!!'
  end

  # CoreLocation Delegates
  def locationManager(manager,
                      didUpdateToLocation: newLocation,
                      fromLocation: oldLocation)
    @addButton.enabled = true
  end

  def locationManager(manager,
                      didFailWithError: error)
    @addButton.enabled = false
  end
                      
end
