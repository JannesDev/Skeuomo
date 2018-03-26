//
//  ArtistsGalleriaFliterScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 15/02/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ArtistsGalleriaFliterScreen: UIViewController, UITableViewDelegate ,UITableViewDataSource, RangeSeekSliderDelegate , UITextFieldDelegate
{
    
    @IBOutlet weak var tblFilterData: UITableView!
    
    @IBOutlet var tool: UIToolbar!
    
    var arrGenres =    NSArray()
    var arrSubject =   NSArray()
    var arrMedium =    NSArray()
    var arrMood =      NSArray()
    
    
    var strGenres = ""
    var strSubject = ""
    var strMedium = ""
    var strMood = ""
    
    
    var MinPrice = 1
    var MaxPrice = 50000
    
    var selectedMinPrice = 1
    var selectedMaxPrice = 50000
    
    
    var arrFilterOptions = NSMutableArray()
    
    var arrFilterOptionSelected = NSMutableArray()
    
    
    var isClick: Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        isClick = -1
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        arrFilterOptions = ["PRICE", "GENRES", "SUBJECT", "MEDIUM", "MOOD"]
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ButtonsMethods
    
    @IBAction func btnDoneToolbar(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
    }
    func btnSelectDropDown(sender:UIButton)
    {
        if arrFilterOptionSelected.contains(sender.tag)
        {
            arrFilterOptionSelected.remove(sender.tag)
        }
            
        else
        {
            arrFilterOptionSelected.add(sender.tag)
        }
        
        tblFilterData.reloadData()
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnApply(_ sender: Any)
    {
        let dicFilter = NSMutableDictionary()
        
        dicFilter.setValue(strGenres, forKey: "genre")
        dicFilter.setValue(strSubject, forKey: "subject")
        dicFilter.setValue(strMedium, forKey: "medium")
        dicFilter.setValue(strMood, forKey: "mood")

        
        dicFilter.setValue(NSNumber.init(value: MinPrice), forKey: "minprice")
        dicFilter.setValue(NSNumber.init(value: MaxPrice), forKey: "maxprice")
        
        dicFilter.setValue(NSNumber.init(value: selectedMinPrice), forKey: "selectedminprice")
        dicFilter.setValue(NSNumber.init(value: selectedMaxPrice), forKey: "selectedmaxprice")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ApplyFilterArtwork"), object: dicFilter)
        
        _ =  self.navigationController?.popViewController(animated: true)
        
        
    }
    @IBAction func btnReset(_ sender: Any)
    {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RemoveFilterArtwork"), object: nil)
        
        _ =  self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrFilterOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrFilterOptionSelected.contains(section)
        {
            if section == 0
            {
                return 2
            }
            else if section == 1
            {
                return arrGenres.count + 1
            }
            else if section == 2
            {
                return arrSubject.count + 1
            }
            else if section == 3
            {
                return arrMedium.count + 1
            }
            else if section == 4
            {
                return arrMood.count + 1
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                return 50
            }
            else
            {
                return 90
            }
        }
        else
        {
            return 50
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cellIdentifier:String = "FilterOptionTblCell"
            
            var cell:FilterOptionTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? FilterOptionTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("FilterOptionTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? FilterOptionTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.btnDropDown.tag = indexPath.section
            cell?.btnDropDown.addTarget(self,action: #selector(btnSelectDropDown),for: UIControlEvents.touchUpInside)
            
            if arrFilterOptionSelected.contains(indexPath.section)
            {
                cell?.btnDropDown.isSelected = true
            }
            else
            {
                cell?.btnDropDown.isSelected = false
            }
            
            cell?.lblFilterNames.text = arrFilterOptions.object(at: indexPath.section) as? String
            
            return cell!
        }
        else
        {
            if indexPath.section == 0
            {
                let cellIdentifier:String = "FilterPriceTblCell"
                var cell:FilterPriceTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? FilterPriceTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("FilterPriceTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? FilterPriceTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                cell?.txtMinPrice.delegate  = self
                cell?.txtMaxPrice.delegate  = self
                
                
                cell?.txtMinPrice.tag = 111
                cell?.txtMaxPrice.tag = 222
                
                
                cell?.txtMinPrice.inputAccessoryView = tool
                cell?.txtMaxPrice.inputAccessoryView = tool
                
                cell?.rangeSlider.delegate = self
                
                
                cell?.rangeSlider.minValue = 1.0
                
                if MaxPrice > 50000 {
                    
                    cell?.rangeSlider.maxValue = CGFloat(MaxPrice)
                    
                }
                else
                {
                    cell?.rangeSlider.maxValue = 50000
                }
                
                cell?.rangeSlider.selectedMinValue = CGFloat(selectedMinPrice)
                cell?.rangeSlider.selectedMaxValue = CGFloat(selectedMaxPrice)
                
                
                cell?.txtMinPrice.text = String(format: "%d", selectedMinPrice)
                cell?.txtMaxPrice.text = String(format: "%d", selectedMaxPrice)
                
                return cell!
                
            }
            else
            {
                let cellIdentifier:String = "FilterGenreTblCell"
                
                var cell:FilterGenreTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? FilterGenreTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("FilterGenreTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? FilterGenreTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                
                cell?.imgSelected.isHidden =  true
                
                if indexPath.section == 1
                {
                    cell?.lblOption.text = (arrGenres.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name")
                    
                    if strGenres == (arrGenres.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name") {
                        
                        cell?.imgSelected.isHidden =  false
                        
                    }
                    
                }
                else if indexPath.section == 2
                {
                    cell?.lblOption.text = (arrSubject.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name")
                    
                    if strSubject == (arrSubject.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name") {
                        
                        cell?.imgSelected.isHidden =  false
                        
                    }
                    
                }
                else if indexPath.section == 3
                {
                    cell?.lblOption.text = (arrMedium.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name")

                    
                    if strMedium == (arrMedium.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name") {
                        
                        cell?.imgSelected.isHidden =  false
                        
                    }
                    
                }
                else
                {
                    
                    
                    cell?.lblOption.text = (arrMood.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name")

                    
                    if strMood == (arrMood.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name") {
                        
                        cell?.imgSelected.isHidden =  false
                        
                    }
                    
                }
                
                return cell!
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            if arrFilterOptionSelected.contains(indexPath.section)
            {
                arrFilterOptionSelected.remove(indexPath.section)
            }
            else
            {
                arrFilterOptionSelected.add(indexPath.section)
            }
            
            tblFilterData.reloadData()
        }
        else
        {
            if indexPath.section == 1
            {
                strGenres = (arrGenres.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name")
            }
            else if indexPath.section == 2
            {
                strSubject =  (arrSubject.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name")
            }
            else if indexPath.section == 3
            {
                strMedium =  (arrMedium.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name")

            }
            else if indexPath.section == 4
            {
                strMood =  (arrMood.object(at: indexPath.row - 1) as! NSDictionary).valueForNullableKey(key: "name")
                
            }
            
            tblFilterData.reloadData()
        }
        
        
    }
    
    //MARK: - Range Slider
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat)
    {
        selectedMinPrice = Int(minValue)
        selectedMaxPrice = Int(maxValue)
        
        let buttonPosition : CGPoint = slider.convert(CGPoint.zero, to: tblFilterData)
        
        let indexPath = self.tblFilterData.indexPathForRow(at: buttonPosition)
        
        let Cell = self.tblFilterData.cellForRow(at: indexPath!) as! FilterPriceTblCell
        
        Cell.txtMaxPrice.text = String(format: "%d", selectedMaxPrice)
        Cell.txtMinPrice.text = String(format: "%d", selectedMinPrice)
        
    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " "
        {
            return false
        }
        else if string == "0" && textField.text!.characters.count == 0 {
            
            return false
        }
        
        let inverseSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        
        let components = string.components(separatedBy: inverseSet)
        
        let filtered = components.joined(separator: "")
        
        
        
        if string != filtered
        {
            return false
        }
        
        
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        
        return newLength > 10 ? false : true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 111
        {
            
            if textField.text!.characters.count > 0
            {
                selectedMinPrice = Int(textField.text!)!
                
            }
            else
            {
                selectedMinPrice = 1
            }
            
        }
        else
        {
            
            if textField.text!.characters.count > 0
            {
                selectedMaxPrice = Int(textField.text!)!
                if selectedMaxPrice > MaxPrice {
                    MaxPrice = selectedMaxPrice
                }
            }
            else
            {
                selectedMaxPrice = 50000
                
                if selectedMaxPrice > MaxPrice
                {
                    MaxPrice = selectedMaxPrice
                }
            }
            
        }
        
        tblFilterData.reloadData()
    }
    
    
}
