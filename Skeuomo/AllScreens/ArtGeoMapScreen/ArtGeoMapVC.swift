//
//  ArtGeoMapVC.swift
//  Skeuomo
//
//  Created by by Jannes on 21/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import MapKit

class ArtGeoMapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate  {

    
    @IBOutlet var mapShow: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapShow.delegate = self
        
        print(appDelegate.currentLocation.coordinate.latitude)
        if appDelegate.currentLocation.coordinate.latitude > 0.0
        {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude:(appDelegate.locationManager.location?.coordinate.latitude)! , longitude: (appDelegate.locationManager.location?.coordinate.longitude)!)
            // annotation.coordinate = annotation.coordinate
            mapShow.addAnnotation(annotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - buttonsMethod
   
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.appDelegate.sideMenuController.openMenu()
    }
    @IBAction func btnSearching(_ sender: UIButton)
    {
    }
    @IBAction func btnNotifications(_ sender: UIButton)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
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

}
