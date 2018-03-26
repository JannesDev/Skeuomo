//
//  EventsShowVC.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import MapKit
import AFNetworking


class MDAnnotation : NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    var tag : Int?
    
    override init()
    {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.image = nil

    }
}

class EventsShowVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate ,UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate
{
    @IBOutlet var lblFilter: UILabel!

    @IBOutlet var collectionEvents: UICollectionView!
    @IBOutlet var btnArtMap: UIButton!
    @IBOutlet var btnGridView: UIButton!
    @IBOutlet  var vieSegMentBtn: UIView!
    @IBOutlet var mapShow: MKMapView!
    
    var selectedIndexPicker = 0
    var strSelectedPickerType = ""

    @IBOutlet weak var pickerDataSet: UIPickerView!
    @IBOutlet var viewPickerview: UIView!

    var arrFilter : NSArray!
    var strFilterType = "Free"
    
    var arrEvent = NSArray()
    
    var dateFormateServer             :DateFormatter!
    var dateFormate                   :DateFormatter!
    var timeFormate                   :DateFormatter!
    
    
    @IBOutlet var viewAnno: UIView!
    
    @IBOutlet weak var ImgAnnoEvent: UIImageView!
    @IBOutlet weak var lblAnnoEventTitle: UILabel!
    @IBOutlet weak var lblAnnoEventAddress: UILabel!

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrFilter = ["Free","Paid","Fundraiser"]
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let nib = UINib(nibName: "EventCollectionCell", bundle: nil)
        collectionEvents.register(nib,forCellWithReuseIdentifier: "EventCollectionCell")
        
        self.vieSegMentBtn.layer.cornerRadius = 16.0
        self.vieSegMentBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.vieSegMentBtn.layer.borderWidth = 1.0
        
        self.btnArtMap.setImage(UIImage.init(named: "artmap_active.png"), for: .normal)
        
        mapShow.delegate = self
        mapShow.showsUserLocation =  true
        
        
        dateFormateServer  = DateFormatter()
        dateFormateServer.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        dateFormate  = DateFormatter()
        dateFormate.dateFormat = "MMMM dd, YYYY"
        
        timeFormate  = DateFormatter()
        timeFormate.dateFormat = "HH:mm a"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        
        
        tap.delegate = self
        
        viewAnno.addGestureRecognizer(tap)
        
        viewAnno.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(CheckLocationWhenAppComeInForground(notification:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined, .restricted, .denied:
                
                print("No access")
                
                let alertController = UIAlertController(
                    title: "Location Access Disabled",
                    message: "In order to be see event near you, please open this app's settings and set location access to 'Always'.",
                    preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                    if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(url as URL)
                    }
                }
                alertController.addAction(openAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                HelpingMethods.sharedInstance.ShowHUD()
                self.performSelector(inBackground: #selector(GetNearbyEvents), with: nil)
            }
        } else
        {
            print("Location services are not enabled")
            
            let alertController = UIAlertController(
                title: "Location services Disabled",
                message: "In order to be see event near you, please open settings and set location services enabled.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                    // If general location settings are disabled then open general location settings
                    UIApplication.shared.openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        
        

    }
    
    func CheckLocationWhenAppComeInForground(notification : Notification)
    {
        
        if arrEvent.count == 0 {
            if CLLocationManager.locationServicesEnabled()
            {
                switch CLLocationManager.authorizationStatus()
                {
                case .notDetermined, .restricted, .denied:
                    
                    print("No access")
                    
                    let alertController = UIAlertController(
                        title: "Location Access Disabled",
                        message: "In order to be see event near you, please open this app's settings and set location access to 'Always'.",
                        preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                        if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(url as URL)
                        }
                    }
                    alertController.addAction(openAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    
                    HelpingMethods.sharedInstance.ShowHUD()
                    self.performSelector(inBackground: #selector(GetNearbyEvents), with: nil)
                }
            } else
            {
                print("Location services are not enabled")
                
                let alertController = UIAlertController(
                    title: "Location services Disabled",
                    message: "In order to be see event near you, please open settings and set location services enabled.",
                    preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                    
                    if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                        // If general location settings are disabled then open general location settings
                        UIApplication.shared.openURL(url)
                    }
                }
                alertController.addAction(openAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil)
    {
        // handling code
        
        
        
        let dicEvent = arrEvent.object(at: (sender?.view?.tag)!) as! NSDictionary
        print(dicEvent)
        let Event = EventDetailsVC(nibName:"EventDetailsVC",bundle:nil)
        Event.strEventID = "\(dicEvent.object(forKey: "id")!)"
        self.navigationController?.pushViewController(Event, animated: true)
        
    }
    //MARK: - Add Annotation
    
    func addAnnotation() {
        
        if mapShow.annotations.count > 0
        {
            mapShow.removeAnnotations(mapShow.annotations)
        }
    
        for obj in arrEvent
        {
            
            let dicObj = obj as! NSDictionary
            
            let annotation = MDAnnotation()
            
            annotation.tag = arrEvent.index(of: obj)
            annotation.title = " "
            
            
            let strLat = dicObj.object(forKey: "latitude") as? String
            let strLng = dicObj.object(forKey: "longitude") as? String
            
            if strLat != "" && strLng != ""
            {
                annotation.coordinate =  CLLocationCoordinate2D(latitude:Double(strLat!)! , longitude: Double(strLng!)!)
                
                mapShow.addAnnotation(annotation)
            }
            
            
        }
        self.zoomToFitMapAnnotations(aMapView: mapShow)
    }
    
    func zoomToFitMapAnnotations(aMapView: MKMapView)
    {
        guard aMapView.annotations.count > 0 else {
            return
        }
        var topLeftCoord: CLLocationCoordinate2D = CLLocationCoordinate2D()
        topLeftCoord.latitude = -90
        topLeftCoord.longitude = 180
        var bottomRightCoord: CLLocationCoordinate2D = CLLocationCoordinate2D()
        bottomRightCoord.latitude = 90
        bottomRightCoord.longitude = -180
        for annotation: MKAnnotation in mapShow.annotations {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }
        
        var region: MKCoordinateRegion = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.4
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.4
        region = aMapView.regionThatFits(region)
        mapShow.setRegion(region, animated: true)
    }
    
    // MARK: - ButtonsMethods
    
    @IBAction func btnSelectFilter(_ sender: AnyObject)
    {
        strSelectedPickerType = "Filter"
        
        reloadPicker()
        self.view.addSubview(viewPickerview)
        viewPickerview.frame = self.view.frame
    }
    @IBAction func btnSelectSort(_ sender: AnyObject)
    {
        
    }
    
    @IBAction func btnCancelPickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
    }
    
    @IBAction func btnDonePickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
        
        if strSelectedPickerType == "Filter"
        {
            strFilterType =  arrFilter.object(at: selectedIndexPicker) as! String
            
            lblFilter.text = strFilterType
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(GetNearbyEvents), with: nil)
            
        }
        else if strSelectedPickerType == "Sort"
        {
            strFilterType = arrFilter.object(at: selectedIndexPicker) as! String
        }
        
        
    }

    
    @IBAction func btnArtAndGrid(_ sender: UIButton)
    {
        if sender.tag == 100
        {
            self.btnGridView.setImage(UIImage.init(named: "grid-view.png"), for: .normal)
            self.btnArtMap.setImage(UIImage.init(named: "artmap_active.png"), for: .normal)
            self.mapShow.isHidden = false
        }
        else
        {
            self.btnArtMap.setImage(UIImage.init(named: "artmap.png"), for: .normal)
            self.btnGridView.setImage(UIImage.init(named: "grid-view_active.png"), for: .normal)
            self.mapShow.isHidden = true
            collectionEvents.reloadData()
        }
    }
    @IBAction func btnSideMenu(_ sender: Any)
    {
        self.appDelegate.sideMenuController.openMenu()
    }
    
    @IBAction func btnNotification(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    @IBAction func btnSearching(_ sender: Any) {
    }
    
    // MARK: - UICollection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrEvent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.size.width/2), height: 248)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionCell", for: indexPath as IndexPath) as! EventCollectionCell
        
        let dicEvent = arrEvent.object(at: indexPath.row) as! NSDictionary
        
        cell.imgEvent.layer.masksToBounds = true
        
        if dicEvent.object(forKey: "event_type") as! String == "Free"
        {
            cell.lblPrice.text = "Free"
        }
        else
        {
            let TempPrice = dicEvent.object(forKey: "price") as! Double
            cell.lblPrice.text = String(format: "$%.2f", TempPrice)
        }
        
        cell.lblEventName.text = dicEvent.object(forKey: "name") as? String
        
        let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicEvent.object(forKey: "picture") as? String)!)
        let urlImage = URL.init(string: urlStr as String)
        
        
        cell.imgEvent.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
        
        cell.lblAddress.text = dicEvent.object(forKey: "address") as? String
        
        let strStartDate = dicEvent.object(forKey: "event_start_date") as? String
        
        let strEndDate = dicEvent.object(forKey: "event_end_date") as? String
        
        let DateStart = dateFormateServer.date(from: strStartDate!)
        
        let DateEnd = dateFormateServer.date(from: strEndDate!)

        if DateStart != nil && DateEnd != nil
        {
            let strStartDate = dateFormate.string(from: DateStart!)
            let strStartTime = timeFormate.string(from: DateStart!)
            
            let strEndDate = dateFormate.string(from: DateEnd!)
            let strEndTime = timeFormate.string(from: DateEnd!)
            
            cell.lblEventStart.text = String(format: "%@ at %@", strStartDate,strStartTime)
            cell.lblEventEnd.text = String(format: "%@ at %@", strEndDate,strEndTime)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
         let dicEvent = arrEvent.object(at: indexPath.row) as! NSDictionary
        print(dicEvent)
        let Event = EventDetailsVC(nibName:"EventDetailsVC",bundle:nil)
        Event.strEventID = "\(dicEvent.object(forKey: "id")!)"
        self.navigationController?.pushViewController(Event, animated: true)
    }
    
    // MARK: - MKMapView Delegate Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        let annotationView: MKAnnotationView?
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        
        if annotation is MKUserLocation {
            
            annotationView?.image = UIImage(named: "home_location_blue")
            
            return annotationView
        }
        
        annotationView!.canShowCallout = false
        
        if let annotationView = annotationView
        {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "egypto")
        }
        
        let widthConstraint = NSLayoutConstraint(item: viewAnno, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewAnno.frame.size.width)
        
        viewAnno.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: viewAnno, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewAnno.frame.size.height)
        
        viewAnno.addConstraint(heightConstraint)
        
        annotationView?.detailCalloutAccessoryView = viewAnno
        
        annotationView?.tag = (annotation as! MDAnnotation).tag!
        
        viewAnno.tag =  (annotation as! MDAnnotation).tag!
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if view.annotation is MKUserLocation
        {
            return 
        }
        
        
        let dicEvent = arrEvent.object(at: view.tag) as! NSDictionary
        
        viewAnno.tag =  view.tag

        
        lblAnnoEventTitle.text = dicEvent.object(forKey: "name") as? String
        let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicEvent.object(forKey: "picture") as? String)!)
        let urlImage = URL.init(string: urlStr as String)
        
        
        ImgAnnoEvent.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
        
        lblAnnoEventAddress.text = dicEvent.object(forKey: "address") as? String
    }
    
    
    //MARK: - PikcerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if strSelectedPickerType == "Filter"
        {
            return arrFilter.count
        }
        else if strSelectedPickerType == "Sort"
        {
            return arrFilter.count
        }
        else
        {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if strSelectedPickerType == "Filter"
        {
            return arrFilter.object(at: row) as? String
        }
        else
        {
            return arrFilter.object(at: row) as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedIndexPicker = row
    }

    func reloadPicker()
    {
        selectedIndexPicker = 0
        pickerDataSet.reloadAllComponents()
        pickerDataSet.selectRow(selectedIndexPicker, inComponent: 0, animated: true)
    }
    
    //MARK: - Webservice Methods
    
    func GetNearbyEvents()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        // http://demo2server.in/sites/laravelapp/skeuomo/api/event/detailbytype?userid=97
        
        let parameters = NSMutableDictionary()
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        parameters.setObject(strFilterType.lowercased(), forKey: "type" as NSCopying)
        
        var latitude = ""
        var longitude = ""
        
        if appDelegate.currentLocation != nil
        {
            latitude = String(format: "%f", appDelegate.currentLocation.coordinate.latitude)
            longitude = String(format: "%f", appDelegate.currentLocation.coordinate.longitude)
        }
        
        
        parameters.setObject(latitude, forKey: "latitude" as NSCopying)
        parameters.setObject(longitude, forKey: "longitude" as NSCopying)

        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        

        
        let  url  = String(format: "%@event/detailbytype?userid=%@&type=%@&latitude=%@&longitude=%@", kSkeuomoMainURL,strUserid,strFilterType.lowercased(),latitude,longitude)
        
        print("URL: ",url)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            if DicResponseData.object(forKey: "events") != nil && (DicResponseData.object(forKey: "events") as! NSDictionary).allKeys.count > 0
                            {
                                if (DicResponseData.object(forKey: "events") as! NSDictionary).object(forKey: "data") != nil
                                {
                                    self.arrEvent = (DicResponseData.object(forKey: "events") as! NSDictionary).object(forKey: "data") as! NSArray
                                    
                                    self.addAnnotation()
                                    self.collectionEvents.reloadData()
                                }
                                else
                                {
                                    self.arrEvent = NSArray()
                                    self.addAnnotation()
                                    self.collectionEvents.reloadData()
                                }
                            }
                            else
                            {
                                self.arrEvent = NSArray()
                                self.addAnnotation()
                                self.collectionEvents.reloadData()
                            }
                        }
                        else
                        {
                            print("failed")
                            
                            self.arrEvent = NSArray()
                            self.addAnnotation()
                            self.collectionEvents.reloadData()
                            
                            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                        }
                }
                
            },
                    failure:{(operation, error) in
                        print("Error: " + (error.localizedDescription))
                        DispatchQueue.main.async
                            {
                                HelpingMethods.sharedInstance.hideHUD()
                                
                                
                                
                        }
        })
        
    }
    
}
