//
//  EventDetailsVC.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking
import MapKit
class EventDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource , MKMapViewDelegate
{

    @IBOutlet weak var tblEventsDetails: UITableView!
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var btnBuyTicket: UIButton!

    var dicEventDetails = NSDictionary()
    
    var strEventID = ""
    
    var strPageFrom = ""
    
    
    var dateFormateServer             :DateFormatter!
    var dateFormate                   :DateFormatter!
    var timeFormate                   :DateFormatter!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetEventDetail), with: nil)
        
        dateFormateServer  = DateFormatter()
        dateFormateServer.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        dateFormate  = DateFormatter()
        dateFormate.dateFormat = "MMMM dd, YYYY"
        
        timeFormate  = DateFormatter()
        timeFormate.dateFormat = "HH:mm a"
        
        
        if strPageFrom == "calendar"
        {
            btnBuyTicket.isHidden =  true
            
            tblEventsDetails.frame = CGRect(x: 18, y: 78, width: UIScreen.main.bounds.size.width - 36, height: UIScreen.main.bounds.size.height - 78 - 10)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDetail(notification:)), name: NSNotification.Name(rawValue: "UpdateEventDetail"), object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func updateDetail(notification : NSNotification)
    {
        self.performSelector(inBackground: #selector(GetEventDetail), with: nil)

    }
    
    
    // MARK: - UIButton Methods
    
    @IBAction func btnViewCommentClicked(sender:UIButton)
    {
        let reviewVC  = ReviewAndCommentListScreen(nibName : "ReviewAndCommentListScreen", bundle: nil)
        
        reviewVC.strModule = "shopart"
        reviewVC.strID = strEventID
        
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    
    @IBAction func btnSubmitClicked(sender:UIButton)
    {
        let reviewVC  = SubmitReviewRatingScreen(nibName : "SubmitReviewRatingScreen", bundle: nil)
        
        reviewVC.strModule = "shopart"
        reviewVC.strID = strEventID
        
        self.present(reviewVC, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNotification(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    @IBAction func btnSearching(_ sender: Any)
    {
        
    }
    @IBAction func btnBuyTickets(_ sender: Any)
    {
        
        if dicEventDetails.allKeys.count > 0
        {
            
            let BookingView  = BuyTicketScreen(nibName : "BuyTicketScreen", bundle: nil)
            BookingView.dicEventDetails = self.dicEventDetails
            BookingView.modalPresentationStyle = .overCurrentContext
            self.present(BookingView, animated: true)
        }
        
    
        
        
        
    }

    // MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.dicEventDetails.allKeys.count > 0
        {
          return 9
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 242
        }
        else  if indexPath.row == 1
        {
            return 120
        }
        else  if indexPath.row == 2
        {
            return 110
        }
        else if indexPath.row == 3
        {
            return 66
        }
        else if indexPath.row == 4
        {
            let strDes =  dicEventDetails.object(forKey: "description") as? String
            
            let font = UIFont.init(name: "Gibson-Regular", size: 12)
            
            let height = self.Method_HeightCalculation(text: strDes!, font: font!, width: tableView.frame.size.width - 29)
            
            if height > 46
            {
                return 46 + height + 30
            }
            
            return 46
        }
        else if indexPath.row == 6
        {
            return 44
        }
        else if indexPath.row == 7
        {
            return 200
        }
        else if indexPath.row == 8
        {
            return 60
        }
        else
        {
            let strDes =  dicEventDetails.object(forKey: "addtional_information") as? String
            
            let font = UIFont.init(name: "Gibson-Regular", size: 12)
            
            let height = self.Method_HeightCalculation(text: strDes!, font: font!, width: tableView.frame.size.width - 29)
            
            if height > 46
            {
                return 46 + height + 30
            }
            
            return 46
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cellIdentifier:String = "ColorImgTblCell"
            var cell:ColorImgTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ColorImgTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ColorImgTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ColorImgTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //For Incrase Separator Size
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            // cell?.btnDropDown.tag = indexPath.section
            
            //cell?.btnDropDown.addTarget(self,action: #selector(btnSelectDropDown),for: UIControlEvents.touchUpInside)
            
            
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicEventDetails.object(forKey: "picture") as? String)!)
            
            let urlImage = URL.init(string: urlStr as String)
            
            cell?.imgCollCell.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
            
            return cell!
            
        }
        else  if indexPath.row == 1
        {
            let cellIdentifier:String = "WallnutPaintsTblCell"
            var cell:WallnutPaintsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WallnutPaintsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("WallnutPaintsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? WallnutPaintsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.imgTblCell.layer.masksToBounds = true
            cell?.imgTblCell.layer.cornerRadius = (cell?.imgTblCell.frame.size.width)! / 2
            
            
            
            cell?.lblPaintsType.text = dicEventDetails.object(forKey: "name") as? String
            
            let strUserImage = (dicEventDetails.object(forKey: "user") as! NSDictionary).object(forKey: "profile_picture") as! String
            
            let urlStrUser = NSString(format: "%@%@",kSkeuomoImageURL,strUserImage)
            
            let urlImageUser = URL.init(string: urlStrUser as String)
            
            
            cell?.imgTblCell.setImageWith(urlImageUser!, placeholderImage: UIImage.init(named:"user_place"))
            
            
            
            
            let strUsername = String(format: "%@ %@", (dicEventDetails.object(forKey: "user") as! NSDictionary).object(forKey: "firstName") as! String,(dicEventDetails.object(forKey: "user") as! NSDictionary).object(forKey: "lastName") as! String)
            
            cell?.lblUserName.text = String(format: "By %@", strUsername)
            
            cell?.lblAddress.text = (dicEventDetails.object(forKey: "user") as! NSDictionary).object(forKey: "city") as? String
            
            if dicEventDetails.object(forKey: "event_type") as! String == "free"
            {
                cell?.lblPrice.text = "Free"
            }
            else
            {
                let TempPrice = dicEventDetails.object(forKey: "price") as! Double
                cell?.lblPrice.text = String(format: "$%.2f", TempPrice)
            }
            
            return cell!
            
        }
        else  if indexPath.row == 2
        {
            let cellIdentifier:String = "VenueDetailsTblCell"
            var cell:VenueDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? VenueDetailsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("VenueDetailsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? VenueDetailsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.lblEventAddress.text = dicEventDetails.object(forKey: "address")! as? String
            
            
            
            let strStartDate = dicEventDetails.object(forKey: "event_start_date") as? String
            
            let strEndDate = dicEventDetails.object(forKey: "event_end_date") as? String
            
            let DateStart = dateFormateServer.date(from: strStartDate!)
            
            let DateEnd = dateFormateServer.date(from: strEndDate!)
            
            
            if DateStart != nil && DateEnd != nil
            {
                let strStartDate = dateFormate.string(from: DateStart!)
                let strStartTime = timeFormate.string(from: DateStart!)
                
                
                let strEndDate = dateFormate.string(from: DateEnd!)
                let strEndTime = timeFormate.string(from: DateEnd!)
                
            cell?.lblEventStart.text = String(format: "%@ at %@", strStartDate,strStartTime)
            cell?.lblEventEnd.text = String(format: "%@ at %@", strEndDate,strEndTime)
                
            }

            
            return cell!
        }

        else if indexPath.row == 3
        {
            let cellIdentifier:String = "SharingOptionTblCell"
            var cell:SharingOptionTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SharingOptionTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("SharingOptionTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? SharingOptionTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            return cell!
        }
        else if indexPath.row == 4
        {
            let cellIdentifier:String = "DecriptionTblCell"
            var cell:DecriptionTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DecriptionTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("DecriptionTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? DecriptionTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            cell?.lblTitle.text = "DESCRIPTION"
             cell?.lblDescription.text = dicEventDetails.object(forKey: "description") as? String
            return cell!
        }
            
        else if indexPath.row == 6
        {
            let cellIdentifier:String = "CategoryCell"
            
            var cell:CategoryCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CategoryCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CategoryCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CategoryCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            
            cell?.lblCategory.text = dicEventDetails.object(forKey: "event_type") as? String
            
            return cell!
            
        }
            
        else if indexPath.row == 7
        {
            let cellIdentifier:String = "MapEventCell"
            
            var cell:MapEventCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MapEventCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("MapEventCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? MapEventCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero

            
            cell?.mapEvent.delegate = self
            
            if (cell?.mapEvent.annotations.count)! > 0
            {
                cell?.mapEvent.removeAnnotations((cell?.mapEvent.annotations)!)
            }
            
            let annotation = MDAnnotation()
            
            annotation.title = dicEventDetails.object(forKey: "name") as? String
            
            let strLat = dicEventDetails.object(forKey: "latitude") as? String
            let strLng = dicEventDetails.object(forKey: "longitude") as? String
            
            if strLat != "" && strLng != ""
            {
                annotation.coordinate =  CLLocationCoordinate2D(latitude:Double(strLat!)! , longitude: Double(strLng!)!)
                
                cell?.mapEvent.addAnnotation(annotation)
            }
            
            self.zoomToFitMapAnnotations(aMapView: (cell?.mapEvent)!)
            
            return cell!
            
        }
       else if indexPath.row == 8
        {
            let cellIdentifier:String = "CreateCommentAndRatingCell"
            var cell:CreateCommentAndRatingCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CreateCommentAndRatingCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CreateCommentAndRatingCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CreateCommentAndRatingCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            
            cell?.btnSubmitReview.addTarget(self, action: #selector(btnSubmitClicked(sender:)), for: .touchUpInside)
            
            cell?.btnViewComments.addTarget(self, action: #selector(btnViewCommentClicked(sender:)), for: .touchUpInside)
            
            
            
            return cell!
        }
        else
        {
            let cellIdentifier:String = "DecriptionTblCell"
            var cell:DecriptionTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DecriptionTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("DecriptionTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? DecriptionTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            cell?.lblTitle.text = "ADDITIONAL INFORMATON"
            cell?.lblDescription.text = dicEventDetails.object(forKey: "addtional_information") as? String
            return cell!
        }
        
        
        
    }
 
    // MARK: - UICollection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.size.width), height: 256)
    }
    // make a cell for each cell index path
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgShowCollectionCell", for: indexPath as IndexPath) as! ImgShowCollectionCell
        return cell
    }
    
    // MARK: - MKMapView Delegate Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let annotationIdentifier = "AnnotationIdentifier"
        let annotationView: MKAnnotationView?
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        annotationView!.canShowCallout = false
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "egypto")
        }
        
        return annotationView
    }

    
    
    //MARK: - Web Service Method
    
    func GetEventDetail()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setValue(strUserid, forKey: "userid")
        
        parameters.setValue(strEventID, forKey: "id")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted
            { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending
        }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        let token = appDelegate.MD5(strforMD5 as String)
        
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        let  url  = String(format: "%@event/frontdetail?id=%@&userid=%@", kSkeuomoMainURL,strEventID,strUserid)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                                
                            self.dicEventDetails = DicResponseData.object(forKey: "event") as! NSDictionary
                            
                            self.lblPageTitle.text = self.dicEventDetails.object(forKey: "name") as? String
                            
                            let userIdEvent = (self.dicEventDetails.object(forKey: "user") as! NSDictionary).valueForNullableKey(key: "id")
                            
                            let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
                            
                            if userIdEvent == strUserid as String
                            {
                                self.btnBuyTicket.isHidden =  true
                                
                                self.tblEventsDetails.frame = CGRect(x: 18, y: 78, width: UIScreen.main.bounds.size.width - 36, height: UIScreen.main.bounds.size.height - 78 - 10)
                            }
                            
                            self.tblEventsDetails.reloadData()
                            
                            
                            
                        }
                        else
                        {
                            print("failed")
                            
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
        for annotation: MKAnnotation in aMapView.annotations {
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
        aMapView.setRegion(region, animated: true)
    }


}
