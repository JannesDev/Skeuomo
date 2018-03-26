//
//  PinterestHandler.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 19/02/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit
import PinterestSDK
//import PDFKit

class PinterestHandler: NSObject
{
    static let PinterestAppID = "4950983494265223480"

    static let shared: PinterestHandler = {
        let instance = PinterestHandler()
        
        // setup code
        
        PDKClient.configureSharedInstance(withAppId: PinterestHandler.PinterestAppID)
        
        return instance
    }()
    
    func isPinterestAutherized() -> Bool
    {
        return true
    }
    
    
    
    
    
    
}
