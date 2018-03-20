//
//  MainVC.swift
//  PokeSearch
//
//  Created by Shruti Sharma on 2/21/18.
//  Copyright © 2018 Shruti Sharma. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var geofire: GeoFire!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pokemonBallTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "PokemonListVC", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? PokemonListVC else {return}
        slideInTransitioningDelegate.direction = .right
        slideInTransitioningDelegate.disableCompactHeight = false
        destinationVC.transitioningDelegate = slideInTransitioningDelegate
        destinationVC.modalPresentationStyle = .custom
    }

}

