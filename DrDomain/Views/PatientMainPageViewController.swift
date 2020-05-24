//
//  PatientMainPageViewController.swift
//  DrDomain
//
//  Created by TestUser on 10/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit
import FirebaseAuth

class PatientMainPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //variables
    let PC = PatientControllers()
    let UC = UserControllers()
    let AC = AppController()
    var userInfoDict: NSMutableDictionary = [:]
    var userSocialPlatform: Array<String> = []
    var patientAppointmentList:Array<Appointment> = []
    var patientRecordList:Array<Appointment> = []
    
    //UI elemments
    @IBOutlet weak var imgProfileImage: UIImageView!
    
    @IBOutlet weak var lblPatientName: UILabel!
    
    @IBOutlet weak var UIViewFindDoctor: UIView!
    
    @IBOutlet weak var UIViewFindHospital: UIView!
    
    @IBOutlet weak var UIViewAppointments: UIView!
    
    @IBOutlet weak var UIViewRecords: UIView!
    
    @IBOutlet weak var lblTotalDoctors: UILabel!
    
    @IBOutlet weak var lblTotalAppointments: UILabel!
    
    @IBOutlet weak var lblTotalRecords: UILabel!
    
    @IBOutlet weak var imgPersonalInfo: UIImageView!
    
    @IBOutlet weak var UIViewContainer: UIView!
    
    @IBOutlet weak var imgRecordRedCircle: UIImageView!
    
    @IBOutlet weak var lblRecordNumberInCircle: UILabel!
    
    @IBOutlet weak var imgAppointmentRedCircle: UIImageView!
    
    @IBOutlet weak var lblTotalHospital: UILabel!
    
    @IBOutlet weak var lblAppointmentNumberInCircle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        PC.getCurrentUserInfoSet { (User) in
            
            self.loadDescription(User)
            self.userInfoDict = ["uid": User.UID!,"name": User.name!,"gender": User.gender!,"email": User.email!,"phone":User.phone!, "profileimage": User.profileImageURL!]
            self.userSocialPlatform = User.socialplatform!
            
            UserLinker.thisUser = User
        }
        
        AC.getPatientAppointmentsList
        {
            (appointmentList) in
            
            var filteredAppointment:Array<Appointment> = []
            var temporaryRecord:Array<Appointment> = []
            
            for appointment in appointmentList
            {
                if appointment.appointmentActive!
                {
                    filteredAppointment.append(appointment)
                }
                else
                {
                    temporaryRecord.append(appointment)
                }
            }
            
            self.patientAppointmentList
             = filteredAppointment
            self.patientRecordList = temporaryRecord
            
            //load total Appointments and total records
            if filteredAppointment.isEmpty
            {
                self.imgAppointmentRedCircle.isHidden = true
                self.lblAppointmentNumberInCircle.isHidden = true
            }
            else
            {
                let totalAppointments = filteredAppointment.count
                self.lblTotalAppointments.text = "\(totalAppointments) appointments"
                self.lblAppointmentNumberInCircle.isHidden = false
                self.imgAppointmentRedCircle.isHidden = false
                self.lblAppointmentNumberInCircle.text = String(totalAppointments)
            }
            
            if temporaryRecord.isEmpty
            {
                self.imgRecordRedCircle.isHidden = true
                self.lblRecordNumberInCircle.isHidden = true
            }
            else
            {
                let totalRecords = temporaryRecord.count
                self.lblTotalRecords.text = "\(totalRecords) records"
                self.lblRecordNumberInCircle.isHidden = false
                self.imgRecordRedCircle.isHidden = false
                self.lblRecordNumberInCircle.text = String(totalRecords)
            }
            
        }
        
        setupImageGesture()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //reload name
       self.lblPatientName.text = self.userInfoDict["name"] as? String
        
        //reload patientAppointmentArray
        
        AC.getPatientAppointmentsList { (appointmentList) in
            
            self.patientAppointmentList = []
            self.patientRecordList = []
            
            var filteredAppointment:Array<Appointment> = []
            var temporaryRecord:Array<Appointment> = []
            
            for appointment in appointmentList
            {
                if appointment.appointmentActive!
                {
                    filteredAppointment.append(appointment)
                }
                else
                {
                    temporaryRecord.append(appointment)
                }
            }

            self.patientAppointmentList
            = filteredAppointment
            self.patientRecordList = temporaryRecord
            
            //load total Appointments and total records
            if filteredAppointment.isEmpty
            {
                self.imgAppointmentRedCircle.isHidden = true
                self.lblAppointmentNumberInCircle.isHidden = true
            }
            else
            {
                let totalAppointments = filteredAppointment.count
                self.lblTotalAppointments.text = "\(totalAppointments) appointments"
                self.imgAppointmentRedCircle.isHidden = false
                self.lblAppointmentNumberInCircle.isHidden = false
                self.lblAppointmentNumberInCircle.text = String(totalAppointments)
            }
                      
            if temporaryRecord.isEmpty
            {
                self.imgRecordRedCircle.isHidden = true
                self.lblRecordNumberInCircle.isHidden = true
            }
            else
            {
                let totalRecords = temporaryRecord.count
                self.lblTotalRecords.text = "\(totalRecords) records"
                self.imgRecordRedCircle.isHidden = false
                self.lblRecordNumberInCircle.isHidden = false
                self.lblRecordNumberInCircle.text = String(totalRecords)
            }
        }
    }
    
    func setupImageGesture()
    {
        //add tappedGesture for profile image view
        imgProfileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (handleSelectProfileImage)))
               
        imgProfileImage.isUserInteractionEnabled = true
        
        //add tappedGesture for book icon
        imgPersonalInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMoveToPersonalInfoViewController)))
        
        imgPersonalInfo.isUserInteractionEnabled = true
        
        
        //add tapped Gesture for 4 grid block view
        let UIViewFindDoctorTappedGesture = UITapGestureRecognizer(target: self, action: #selector (handleMoveToFindDoctorViewController))
        
        UIViewFindDoctor.addGestureRecognizer(UIViewFindDoctorTappedGesture)
        
        UIViewFindDoctor.isUserInteractionEnabled = true
        
        let UIViewFindHospitalTappedGesture = UITapGestureRecognizer(target: self, action: #selector(handleMoveToFindHospitalViewController))
        
        UIViewFindHospital.addGestureRecognizer(UIViewFindHospitalTappedGesture)
        
        UIViewFindHospital.isUserInteractionEnabled = true
        
        let UIViewAppointmentTappedGesture = UITapGestureRecognizer(target: self, action: #selector(handleMoveToAppointmentsViewController))
        
        UIViewAppointments.addGestureRecognizer(UIViewAppointmentTappedGesture)
        
        UIViewAppointments.isUserInteractionEnabled = true
        
        let UIViewRecordsTappedGesture = UITapGestureRecognizer(target: self, action: #selector(handleMoveToRecordsViewController))
        
        UIViewRecords.addGestureRecognizer(UIViewRecordsTappedGesture)
        
        UIViewRecords.isUserInteractionEnabled = true
        
    }
    
    @objc func handleMoveToRecordsViewController()
    {
        self.performSegue(withIdentifier: "PatientRecordsPage", sender: self)
    }
    
    @objc func handleMoveToAppointmentsViewController()
    {
        self.performSegue(withIdentifier: "AppointmentsPage", sender: self)
    }
    
    @objc func handleMoveToFindDoctorViewController()
    {
        self.performSegue(withIdentifier: "FindDoctorPage", sender: self)
    }

    @objc func handleMoveToPersonalInfoViewController()
    {
        self.performSegue(withIdentifier: "UserInfoPage", sender: self)
    }
    
    @objc func handleMoveToFindHospitalViewController()
    {
        self.performSegue(withIdentifier: "FindHospitalPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //passing user info dict to PatientPersonalInfoViewController
        if segue.identifier == "UserInfoPage"
        {
            if let destinationViewController = segue.destination as? PatientPersonalInfoViewController
            {
                destinationViewController.userInfoDict = self.userInfoDict
                destinationViewController.userSocialPlatform = self.userSocialPlatform
            }
        }
        
        if segue.identifier == "AppointmentsPage"
        {
            if let destinationViewController = segue.destination as? PatientAppointmentsViewController
            {
                destinationViewController.AppointmentList = self.patientAppointmentList
            }
        }
        
        if segue.identifier == "PatientRecordsPage"
        {
            if let  destinationViewController = segue.destination as? PatientRecordsViewController
            {
                destinationViewController.RecordList = self.patientRecordList
            }
        }
        
    }
        
    @objc func handleSelectProfileImage()
    {
        //create picker controller and present it
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    //if image is selected from UIpicker controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        var selectedImage: UIImage?
        
        //retrieve image from picker
        if let editedImage = info[.editedImage] as? UIImage
        {
            selectedImage = editedImage
        }
        else if let originalImage = info[.originalImage] as? UIImage
        {
            selectedImage = originalImage
        }
        
        UC.uploadProfileImage(selectedImage!,"patient") {
            (data) in
            
            DispatchQueue.main.async {
                self.imgProfileImage.image = UIImage(data: data)
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func setupView()
    {
        
        navigationController?.navigationBar.prefersLargeTitles = true

        imgProfileImage.layer.cornerRadius = imgProfileImage.frame.height/2
        imgProfileImage.layer.borderWidth = 2
        imgProfileImage.layer.borderColor = UIColor.black.cgColor
        imgProfileImage.clipsToBounds = true
        
        UIViewContainer.layer.shadowColor = UIColor.black.cgColor
        UIViewContainer.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        UIViewContainer.layer.shadowRadius = 3
        UIViewContainer.layer.shadowOpacity = 0.3
        UIViewContainer.clipsToBounds = true
        UIViewContainer.layer.masksToBounds = false
        UIViewContainer.layer.borderWidth = 1
        UIViewContainer.layer.borderColor = UIColor.black.cgColor
    }
    
    
    func loadDescription(_ thisUser: CurrentUser)
    {
        let AC = AppController()
        
        lblPatientName.text = thisUser.name
     
        let userProfileImgURLstr = thisUser.profileImageURL
        
        let userProfileImgURL = URL(string: userProfileImgURLstr!)
            
        URLSession.shared.dataTask(with: userProfileImgURL!, completionHandler: {
                
        (data, response, error) in
                
        if error != nil
        {
            print(error!)
            return
        }
        
        DispatchQueue.main.async
        {
        self.imgProfileImage.image = UIImage(data: data!)
        }
                
        }).resume()
        
        
        //load total hospitals
        let totalHospital = HospitalSet.hospitalSet.count - 1
        lblTotalHospital.text = "\(totalHospital) hospitals"
        
        //load total doctors
        AC.getTotalDoctor {
            (TotalDoctor) in
            self.lblTotalDoctors.text = String(TotalDoctor) + " doctors"
        }
        
    }
    
    
    @IBAction func btnLogout(_ sender: UIButton)
    {
        UC.logout()
            
        dismiss(animated: true, completion: nil)
            
    }
    
}
