class RootViewController < UITableViewController
  CellID = 'CellIdentifier'

  def viewDidLoad
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    navigationItem.title = 'Locations'
    navigationItem.leftBarButtonItem = editButtonItem
    @addButton = UIBarButtonItem.alloc.
      initWithBarButtonSystemItem(UIBarButtonSystemItemAdd,
                                  target: self,
                                  action: 'addLocation')
    @addButton.enabled = false
    self.navigationItem.rightBarButtonItem = @addButton

    # start location manager
    locationManager.startUpdatingLocation
  end

  def locationManager
    @locationManager ||= CLLocationManager.new.tap do |lm|
      lm.desiredAccuracy = KCLLocationAccuracyNearestTenMeters
      lm.delegate = self
    end
  end

  def addLocation
    LocationsStore.shared.add_location do |location|
      coordinate = locationManager.location.coordinate
      location.creation_date = NSDate.date
      location.latitude = coordinate.latitude
      location.longitude = coordinate.longitude
    end
    view.reloadData
  end

  # TableView Delegates
  def tableView(tableView, numberOfRowsInSection:section)
    LocationsStore.shared.locations.size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle,
                                          reuseIdentifier: CellID)
    location = LocationsStore.shared.locations[indexPath.row]
    
    @date_formatter ||= NSDateFormatter.new.tap do |df|
      df.timeStyle = NSDateFormatterMediumStyle
      df.dateStyle = NSDateFormatterMediumStyle
    end
    cell.textLabel.text = @date_formatter.stringFromDate(location.creation_date)
    cell.detailTextLabel.text = "%0.3f, %0.3f" % [location.latitude, location.longitude]
    cell
  end

  def tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView,
                commitEditingStyle: editingStyle,
                forRowAtIndexPath: indexPath)
    location = LocationsStore.shared.locations[indexPath.row]
    LocationsStore.shared.remove_location(location)
    tableView.deleteRowsAtIndexPaths([indexPath],
                                     withRowAnimation: UITableViewRowAnimationFade)
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
