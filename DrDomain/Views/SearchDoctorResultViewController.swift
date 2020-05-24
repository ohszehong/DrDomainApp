//
//  SearchDoctorResultViewController.swift
//  DrDomain
//
//  Created by TestUser on 16/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class SearchDoctorResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //UI elements
    @IBOutlet weak var cvDoctorResult: UICollectionView!
    @IBOutlet weak var imgNoResult: UIImageView!
    
    
    //variables
    var filteredDoctorList: Array<Doctor> = []
    var selectedDoctor: Doctor = Doctor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvDoctorResult.delegate = self
        cvDoctorResult.dataSource = self
        
        
        //if array is empty
        if filteredDoctorList.isEmpty
        {
            imgNoResult.image = UIImage(named: "noresultfound")
        }
        else
        {
            imgNoResult.isHidden = true
        }
        
        //set linker
        ViewControllersLinkers.searchDoctorResultVC = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        imgNoResult.isHidden = true
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDoctorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: FindDoctorCollectionViewCell
      
            cell = cvDoctorResult.dequeueReusableCell(withReuseIdentifier: "DoctorResult", for: indexPath) as! FindDoctorCollectionViewCell
        
            cell.setupDoctor(filteredDoctorList[indexPath.row])
        
            cell.setupBorder()
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        if let destinationViewController = segue.destination as? LookIntoDoctorViewController
        {
            destinationViewController.thisDoctor = self.selectedDoctor
        }
                           
    }
    
    

}
