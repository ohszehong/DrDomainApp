//
//  FindHospitallViewController.swift
//  DrDomain
//
//  Created by TestUser on 19/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FindHospitallViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate {


    //variables
    let hospitalList = HospitalSet.hospitalSet
    let locationManager = CLLocationManager()
    
    //UI elements
    @IBOutlet weak var pickerHospital: UIPickerView!
    @IBOutlet weak var txtSearchHospital: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblEstimatedTime: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        pickerHospital.delegate = self
        pickerHospital.dataSource = self
        
        txtSearchHospital.delegate = self
        
        //setup location Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        map.delegate = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        //remove the "All" selection from hospitalSet
        return hospitalList.count - 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return hospitalList[row+1]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        txtSearchHospital.text = hospitalList[row+1]
        pickerView.isHidden = true
    }
    
    func  textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtSearchHospital
        {
            pickerHospital.isHidden = false
            txtSearchHospital.endEditing(true)
        }
    }
    
    func getAddress()
    {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(txtSearchHospital.text!) { (placemark, error) in
            
            guard let placemark = placemark, let location = placemark.first?.location
            else
            {
                print("Unable to locate the hospital")
                return
            }
            
            self.drawMap(destCoordinate: location.coordinate)
            
        }
    }
    
    
    func drawMap(destCoordinate: CLLocationCoordinate2D)
    {
        
        let userLocation = locationManager.location?.coordinate
        
        let userPlacemark = MKPlacemark(coordinate: userLocation!)
        let destPlacemark = MKPlacemark(coordinate: destCoordinate)
        
        let userItem = MKMapItem(placemark: userPlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let destRequest = MKDirections.Request()
        destRequest.source = userItem
        destRequest.destination = destItem
        
        destRequest.transportType = .automobile
        destRequest.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: destRequest)
        
        direction.calculate { (response, error) in
            
            if error != nil
            {
                print(error!)
            }
        
            let route = response?.routes[0]
            self.map.addOverlay(route!.polyline as MKOverlay)
            self.map.setVisibleMapRect((route!.polyline.boundingMapRect), animated: true)
            
            let routeExpectedTravelTime = Int(route!.expectedTravelTime)
            
            let routeExpectedHour = routeExpectedTravelTime/60
            let routeExpectedMinute = routeExpectedTravelTime - (routeExpectedHour*60)
            
            if (routeExpectedHour > 1)
            {
                self.lblEstimatedTime.text = "\(routeExpectedHour) hours \(routeExpectedMinute) minutes"
            }
            else
            {
                  self.lblEstimatedTime.text = "\(routeExpectedHour) hour \(routeExpectedMinute) minutes"
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .systemTeal
        return render
    }
    
    @IBAction func btnSearch(_ sender: UIButton) {
        
        getAddress()
        
    }
    
    

}
