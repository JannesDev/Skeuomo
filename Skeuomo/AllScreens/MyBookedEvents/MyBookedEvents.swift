//
//  MyBookedEvents.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 01/12/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking
import FSCalendar

class MyBookedEvents: UIViewController, FSCalendarDelegate, FSCalendarDataSource , UITableViewDelegate , UITableViewDataSource
{

    @IBOutlet weak var imgThemeBG: UIImageView!

    @IBOutlet weak var tblBookedEvent: UITableView!

    
    var arrAllEvents = NSArray()
    var arrCommonDate = NSMutableArray()
    var arrEventTableList = NSMutableArray()

    
    var dateFormateServer             :DateFormatter!
    var dateFormate                   :DateFormatter!
    var dateFormateCalendar            :DateFormatter!
    
    var dateFormateMonthType            :DateFormatter!

    
    var CalendarEvent: FSCalendar!

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblBookedEvent.tableFooterView = UIView()
        
        dateFormateServer  = DateFormatter()
        dateFormateServer.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        dateFormate  = DateFormatter()
        dateFormate.dateFormat = "YYYY-MM-dd"
        
        
        dateFormateMonthType  = DateFormatter()
        dateFormateMonthType.dateFormat = "dd MMM YYYY"
        
        dateFormateCalendar  = DateFormatter()
        dateFormateCalendar.dateFormat = "YYYY-MM-dd HH:mm:ss ZZZ"
        
                CalendarEvent = FSCalendar.init()
                CalendarEvent.delegate = self
                CalendarEvent.dataSource = self
        
        
        CalendarEvent.backgroundColor = UIColor.white
        
        
        
//        CalendarEvent.backgroundColor = UIColor(red: 11.0/255.0, green: 11.0/255.0, blue: 11.0/255.0, alpha: 1.0)
//        
        CalendarEvent.appearance.weekdayTextColor = UIColor(red: 11.0/255.0, green: 11.0/255.0, blue: 11.0/255.0, alpha: 1.0)
        CalendarEvent.appearance.headerTitleColor = UIColor(red: 11.0/255.0, green: 11.0/255.0, blue: 11.0/255.0, alpha: 1.0)
        
        
        
        
                DispatchQueue.main.async {
        
        
                    self.CalendarEvent.frame = CGRect(x: 15, y: 79, width: UIScreen.main.bounds.size.width - 30, height: 210)
        
                    self.view.addSubview(self.CalendarEvent)
        
                    self.tblBookedEvent.frame = CGRect(x: 15, y: 79 + self.CalendarEvent.frame.size.height , width: UIScreen.main.bounds.size.width - 30, height: UIScreen.main.bounds.size.height - 79 - self.CalendarEvent.frame.size.height - 15)
                    
                    
                    
        }
        
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetBooking), with: nil)
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
        
        if UserDefaults.standard.object(forKey: "Theme") != nil {
            
            let dicTheme = UserDefaults.standard.object(forKey: "Theme") as! NSDictionary
            
            if dicTheme.allKeys.count > 0
            {
                let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicTheme.object(forKey: "themePic") as? String)!)
                
                let urlImage = URL.init(string: urlStr as String)
                imgThemeBG.setImageWith(urlImage!, placeholderImage: UIImage.init(named:""))
            }
            else
            {
                imgThemeBG.image = UIImage.init(named: "")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - UIButton Events
    
    @IBAction func btnBack(_ sender: AnyObject)
    {
      _ =  self.navigationController?.popViewController(animated: true)
    }

    //MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrEventTableList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "MyBookedEventCell"
        var cell:MyBookedEventCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MyBookedEventCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("MyBookedEventCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? MyBookedEventCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            
        }
        
        //ForIncraseSeparatorSize
        
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        
        
        cell?.viewBG.layer.masksToBounds = true
        cell?.viewBG.layer.cornerRadius = 5.0
        cell?.viewBG.layer.borderWidth = 1.0
        cell?.viewBG.layer.borderColor = UIColor.init(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0).cgColor
        
        let dicEvent = arrEventTableList.object(at: indexPath.row) as! NSDictionary
        
        cell?.lblEventTitle.text = (dicEvent.object(forKey: "booked_event") as! NSDictionary).object(forKey: "name") as! String?
        
        cell?.lblEventAddress.text = (dicEvent.object(forKey: "booked_event") as! NSDictionary).object(forKey: "address") as! String?

        
        let strStartDate = (dicEvent.object(forKey: "booked_event") as! NSDictionary).object(forKey: "event_start_date") as! String?
        
        let strEndDate = (dicEvent.object(forKey: "booked_event") as! NSDictionary).object(forKey: "event_end_date") as! String?
        
        let DateStart = dateFormateServer.date(from: strStartDate!)
        
        let DateEnd = dateFormateServer.date(from: strEndDate!)
        
        
        if DateStart != nil && DateEnd != nil
        {
            let strStartDate = dateFormateMonthType.string(from: DateStart!)
            
            let strEndDate = dateFormateMonthType.string(from: DateEnd!)
            
            cell?.lblEventDate.text = String(format: "%@ - %@", strStartDate,strEndDate)
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dicEvent = arrEventTableList.object(at: indexPath.row) as! NSDictionary
        print(dicEvent)
        let Event = EventDetailsVC(nibName:"EventDetailsVC",bundle:nil)
        Event.strEventID = (dicEvent.object(forKey: "booked_event") as! NSDictionary).valueForNullableKey(key: "id")
        Event.strPageFrom = "calendar"
        self.navigationController?.pushViewController(Event, animated: true)
    }
    
    //MARK: - FSCalendar Delegate
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        
        let strDate = dateFormate.string(from: date)
        
        if arrCommonDate.contains(strDate) {
            
            return 1
        }
        
        
        return 0
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        let strDate = dateFormate.string(from: date)
        
        let dateSelected = dateFormate.date(from: strDate)
        
        self.getEventList(date: dateSelected!)
        
        
        
    }
    
    
    
    func getAllEventDates()
    {
        arrCommonDate.removeAllObjects()
        
        for obj in arrAllEvents {
            
            
            let DicObj = (obj as! NSDictionary).object(forKey: "booked_event") as! NSDictionary
            
            let dateStart = dateFormateServer.date(from: DicObj.object(forKey: "event_start_date") as! String)
            
            let dateEnd = dateFormateServer.date(from: DicObj.object(forKey: "event_end_date") as! String)
            
            let datesBetweenArray = Date().generateDatesArrayBetweenTwoDates(startDate: dateStart! , endDate: dateEnd!)

            
            print(datesBetweenArray)
            
            for date in datesBetweenArray {
                
                let Date = dateFormate.string(from: date)
                
                if !arrCommonDate.contains(Date) {
                    
                    arrCommonDate.add(Date)
                }
                
                
            }
            
            
            
        }
        
        
        print("Common Dates:",arrCommonDate)
        
        CalendarEvent.reloadData()
        
        let strDate = dateFormate.string(from: CalendarEvent.today!)
        
        let dateSelected = dateFormate.date(from: strDate)
        
        self.getEventList(date: dateSelected!)
        
    }
    
    func getEventList(date : Date)
    {
        arrEventTableList.removeAllObjects()
        
        for obj in arrAllEvents
        {
            let DicObj = (obj as! NSDictionary).object(forKey: "booked_event") as! NSDictionary
            
            let dateStart = dateFormateServer.date(from: DicObj.object(forKey: "event_start_date") as! String)
            
            let dateEnd = dateFormateServer.date(from: DicObj.object(forKey: "event_end_date") as! String)
            
            let datesBetweenArray = Date().generateDatesArrayBetweenTwoDates(startDate: dateStart! , endDate: dateEnd!)
            
            print(datesBetweenArray)
            
            let strSelectedDate = dateFormate.string(from: date)
            
            
            
            for dateObj in datesBetweenArray
            {
                let strDate = dateFormate.string(from: dateObj)
                
                if strSelectedDate == strDate {
                    
                    if !arrEventTableList.contains(obj)
                    {
                        arrEventTableList.add(obj)
                    }
                }
                
                
            }
            
            
        }
        
        print(arrEventTableList)
        
        tblBookedEvent.reloadData()
        
    }
    
    
    //MARK: - Webservice Methods
    
    
    
    
    func GetBooking()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@event/booked?userid=%@", kSkeuomoMainURL,strUserid)
        
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            if DicResponseData.object(forKey: "event") != nil
                            {
                                if (DicResponseData.object(forKey: "event") as! NSDictionary).object(forKey: "data") != nil
                                {
                                    self.arrAllEvents = (DicResponseData.object(forKey: "event") as! NSDictionary).object(forKey: "data") as! NSArray
                                    
                                    self.getAllEventDates()
                                    
                                    //                                    let tempTotalPage = (DicResponseData.object(forKey: "booking") as! NSDictionary).object(forKey:"last_page") as! Int
                                    //
                                    //                                    let tempTotalRecord = (DicResponseData.object(forKey: "booking") as! NSDictionary).object(forKey:"total") as! Int
                                    //
                                    //                                    if self.arrAllEvents.count > 0 && self.currentPage == 1
                                    //                                    {
                                    //                                        self.arrAllEvents.removeAllObjects()
                                    //                                    }
                                    //
                                    //                                    self.arrBookedTickets.addObjects(from: tempArr as! [NSDictionary])
                                    //
                                    //                                    self.totalPage = tempTotalPage
                                    //                                    self.totalPageRecord = tempTotalRecord
                                    
                                    // self.tblBookedEvent.reloadData()
                                }
                            }
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
    

}

extension Date{
    
    func generateDatesArrayBetweenTwoDates(startDate: Date , endDate:Date) ->[Date]
    {
        var datesArray: [Date] =  [Date]()
        var startDate = startDate
        let calendar = Calendar.current
        
        while startDate <= endDate
        {
            datesArray.append(startDate)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            
        }
        return datesArray
    }
}


