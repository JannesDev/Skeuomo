//
//  SearchLocationScreen.swift
//  BookMyCargo
//
//  Created by Madhusudan-iOS on 04/11/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchLocationScreen: UIViewController  , UITextFieldDelegate , GMSAutocompleteResultsViewControllerDelegate , UISearchBarDelegate,UISearchControllerDelegate
{
    
    @IBOutlet var toolDone: UIToolbar!

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
   
    @IBOutlet weak var txt_Location: UITextField!

    @IBOutlet weak var  viewHeader : UIView!

    var  subView  = UIView ()
    
    var arryCountryList : NSArray = [];
    
    var arrFavList: NSMutableArray = [];

    var lastSelectedIndex = 0
		
    var isEditFrom : Bool = false
    
    
    var dicLocation = NSMutableDictionary()
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    var fetcher: GMSAutocompleteFetcher?

    
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var btnDone: UIButton!

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        resultsViewController?.view.frame = CGRect(x: 0, y: 20.0, width: UIScreen.main.bounds.size.width, height: 45.0)
        resultsViewController?.navigationController?.isNavigationBarHidden = true
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.navigationController?.isNavigationBarHidden = true
        searchController?.searchBar.delegate = self

        
        if appdelegate.currentLocation != nil
        {
            let northEast =  CLLocationCoordinate2D(latitude: appdelegate.currentLocation.coordinate.latitude+0.0001, longitude: appdelegate.currentLocation.coordinate.longitude+0.0001)
            
            let southWest =  CLLocationCoordinate2D(latitude: appdelegate.currentLocation.coordinate.latitude+0.0001, longitude: appdelegate.currentLocation.coordinate.longitude+0.0001)
            
            resultsViewController?.autocompleteBounds = GMSCoordinateBounds.init(coordinate: northEast, coordinate: southWest)

        }

        lblPageTitle.text = "Search Location"
        
        btnDone.setTitle("Done", for: UIControlState.normal)
        
        searchController?.delegate = self
        
        subView = UIView(frame: CGRect(x: 0, y: 65.0, width: UIScreen.main.bounds.size.width, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = false
        

        //  Text Field did change Notification
        
        NotificationCenter.default.addObserver(self, selector:#selector(textDidChanged(_:)) , name: NSNotification.Name.UITextFieldTextDidChange, object: txt_Location)
        
        
        
        
        
       
        
        
    }
    func willPresentSearchController(_ searchController: UISearchController)
    {
        //let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: UIScreen.main.bounds.size.width, height: 45.0))
      
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1, animations: {
                    self.subView.frame = CGRect(x: 0, y: 20.0, width: UIScreen.main.bounds.size.width, height: 45.0)
                    
                })
                
        }
        
   //     view.bringSubview(toFront: viewHeader)

    }
    
    func willDismissSearchController(_ searchController: UISearchController)
    {
        DispatchQueue.main.async {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.subView.frame = CGRect(x: 0, y: 65.0, width: UIScreen.main.bounds.size.width, height: 45.0)
            })

        }
      

        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
   {

    return true
    
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        let arrviewdd = ((searchController?.view)! as UIView).subviews as NSArray

       let arrviewdd1 = ((((arrviewdd.object(at: 0)) as! UIView).subviews) as NSArray).object(at: 0) as! UIView
        arrviewdd1.backgroundColor = viewHeader.backgroundColor

        for view in (searchController?.searchResultsController?.view.subviews)!
        {
            if view is UITableView
            {
                var frame = view.frame
                
                frame.origin.y=20
                frame.size.height=UIScreen.main.bounds.size.height-20
                view.frame = frame
            }
        }

    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        view.bringSubview(toFront: viewHeader)
    }
    // Handle the user's selection.
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace)
    {
        searchController?.isActive = false
        
        searchController?.searchBar.text = String(format: "%@, %@", place.name,place.formattedAddress!)
        
        var latFrom:Double!
        var lonFrom:Double!
        
        latFrom = place.coordinate.latitude
        
        lonFrom = place.coordinate.longitude
        
        print("latFrom",latFrom)
        print("lonFrom",lonFrom)
        
        dicLocation.setObject(NSString.init(string: (searchController?.searchBar.text!)!), forKey: "location" as NSCopying)
        
        dicLocation.setObject(String(latFrom), forKey: "latitude" as NSCopying)
        dicLocation.setObject(String(lonFrom), forKey: "longitude" as NSCopying)
        
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        var strLine1 = ""
        var strLine2 = ""
        var strCity = ""
        var strZipCode = ""
        var strState = ""
        var strCountry = ""
        
        for  addressComponent in place.addressComponents!
        {
            
            print(addressComponent.type)
            print(addressComponent.name)
            
            if addressComponent.type == "street_number" {
                
               strLine1 = addressComponent.name
            }
            else if addressComponent.type == "route" {
                
                if strLine1 == ""
                {
                    strLine1 = addressComponent.name

                }
                else
                {
                
                strLine1 = strLine1.appending(String(format: ", %@", addressComponent.name))
                }
            }
            else if addressComponent.type == "sublocality_level_3" {
                
                if strLine1 == ""
                {
                    strLine1 = addressComponent.name
                    
                }
                else
                {
                    
                    strLine1 = strLine1.appending(String(format: ", %@", addressComponent.name))
                }
            }
            else if addressComponent.type == "sublocality_level_1" {
                
                strLine2 = addressComponent.name

            }
            else if addressComponent.type == "administrative_area_level_2" {
                
                strCity = addressComponent.name
                
            }
            else if addressComponent.type == "postal_code" {
                
                strZipCode = addressComponent.name
                
            }
            else if addressComponent.type == "administrative_area_level_1"
            {
                strState = addressComponent.name
            }
            else if addressComponent.type == "country"
            {
                strCountry = addressComponent.name
            }
            
        }
        
        
        dicLocation.setObject(String(strLine1), forKey: "line1" as NSCopying)

        dicLocation.setObject(String(strLine2), forKey: "line2" as NSCopying)
        
        dicLocation.setObject(String(strCity), forKey: "city" as NSCopying)
        dicLocation.setObject(String(strZipCode), forKey: "zipcode" as NSCopying)
        
        dicLocation.setObject(String(strState), forKey: "state" as NSCopying)

        dicLocation.setObject(String(strCountry), forKey: "country" as NSCopying)
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error)
    {
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnBack(sender: AnyObject)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDone(sender: AnyObject)
    {
        self.view.endEditing(true)
        
        if searchController?.searchBar.text == ""
        {
           _ = appdelegate.ShowAlert(message: "Please search location")
            
            return
        }
        
        print(dicLocation);
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSkeuomoUpdateEventAddress), object: dicLocation)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    

   
    
    //MARK:-SearchLocationAPI
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField.text == "" && string == " ")
        {
            return false
        }
        guard let text = textField.text else { return true }
        return true
        
    }
    
    func textDidChanged(_ noti:Notification)
    {
        let txtfield = noti.object as! UITextField
        
        if txtfield.tag == 111
        {

        }
        
        
    }
    
    //MARK: - Google Auto suggesstion


    func getLocationFromAddressString(_ addressStr:NSString) -> CLLocationCoordinate2D
    {
        var latitude:Double = 0
        var longitude:Double = 0
        
        var esc_addr:NSString!
        esc_addr = addressStr.addingPercentEscapes(using: String.Encoding.utf8.rawValue) as NSString!
        let req = NSString(format: "http://maps.google.com/maps/api/geocode/json?sensor=true&components=locality&address=%@", esc_addr)
        
        //var result = NSString(contentsOfURL: NSURL(string: req as String)!, encoding: NSUTF8StringEncoding, error: nil)
        var result:NSString!
        do {
            result = try String (contentsOf: URL(string: req as String)!, encoding: String.Encoding.utf8) as NSString!
        }
        catch {
            print(error)
        }
        if (result != nil)
        {
            var scanner:Scanner!
            scanner = Scanner(string: result as String)
            if scanner .scanUpTo("\"lat\":", into: nil) && scanner .scanUpTo("\"lat\":", into: nil)
            {
                scanner .scanDouble(&latitude)
                
            }
            
            if scanner .scanUpTo("\"lng\":", into: nil) && scanner .scanUpTo("\"lng\":", into: nil)
            {
                scanner .scanDouble(&longitude)
                
            }
        }
        
        var error:NSError!
        var jsonData:Data!
        jsonData = result .data(using: String.Encoding.utf8.rawValue)
        var jsonResults:NSDictionary!
        do {
            
            jsonResults = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! NSDictionary
            print("jsonResults",jsonResults)
            //if (![[resultDic objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"])
            if jsonResults.object(forKey: "status") as! String == "OK"
            {
                var arrRes = NSArray()
                
                arrRes = jsonResults.object(forKey: "results") as! NSArray
                
                let dicData = arrRes[0] as! NSDictionary
                
                let dicGeo = dicData.object(forKey: "geometry") as! NSDictionary
                
                let dicLocation = dicGeo.object(forKey: "location") as! NSDictionary

                latitude = (dicLocation.object(forKey: "lat")! as AnyObject).doubleValue
                longitude = (dicLocation.object(forKey: "lng")! as AnyObject).doubleValue
                
                print("longitude",longitude)
                print("latitude",latitude)
                
                
            }
            // success ...
        }
        catch
        {
            // failure
            print("Fetch failed: \((error as NSError).localizedDescription)")
        }
        var center = CLLocationCoordinate2DMake(latitude,longitude)
        center.latitude = latitude
        center.longitude = longitude
        return center
        
        
    }
    

 
    

    @IBAction func btnDoneToolBar(_ sender: AnyObject)
    {
        self.view.endEditing(true)
    }


}
