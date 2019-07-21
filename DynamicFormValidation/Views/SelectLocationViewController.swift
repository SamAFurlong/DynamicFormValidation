//
//  MapViewController.swift
//  Inclusive
//
//  Created by Sam Furlong on 12/13/17.
//  Copyright © 2017 Sam Furlong. All rights reserved.
//

import UIKit
import MapKit
class SelectLocationViewController: UIViewController, UISearchBarDelegate, AlertPresenter {
    
    
    private var searchController: UISearchController!
    private var annotation:MKAnnotation!
    private var localSearchRequest:MKLocalSearch.Request!
    private var localSearch:MKLocalSearch!
    private var localSearchResponse:MKLocalSearch.Response!
    private var error:NSError!
    private var pointAnnotation:MKPointAnnotation!
    private var pinAnnotationView:MKPinAnnotationView!
    var viewModel:LocationViewModel!
    
    
    @IBAction func doneAction(_ sender: Any) {
        viewModel.location.swap(pointAnnotation.title ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func searchAction(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                self.presentAlert(with: "The location you searched for could not be found")
                return
            }
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    

}
