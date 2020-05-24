//
//  DrMainPageViewController.swift
//  DrDomain
//
//  Created by TestUser on 10/05/2020.
//  Copyright © 2020 TestUser. All rights reserved.
//

import UIKit

class DrMainPageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    //variables
    let DC = DoctorController()
    let UC = UserControllers()
    let AC = AppController()
    var thisDoctor: Doctor = Doctor()
    var doctorAppointmentList:Array<Appointment> = []
    var doctorRecordList:Array<Appointment> = []
    var doctorInfoDict:NSMutableDictionary = [:]
    var doctorSocialPlatform:Array<String> = []
    var doctorEducation:Array<String> = []
    var doctorTimeInterval: Int = 0
    
    //UI elements
    @IBOutlet weak var imgProfileImg: UIImageView!
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var lblDoctorDomain: UILabel!
    @IBOutlet weak var lblTotalPeopleRated: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var UIViewDoctorAppointments: UIView!
    @IBOutlet weak var UIViewDoctorRecords: UIView!
    @IBOutlet weak var imgPersonalInfo: UIImageView!
    @IBOutlet weak var lblDoctorStatus: UILabel!
    @IBOutlet weak var switchAcceptAppoint: UISwitch!
    @IBOutlet weak var imgSetTimeInterval: UIImageView!
    
    @IBOutlet weak var lblTotalAppointments: UILabel!
    @IBOutlet weak var lblTotalRecords: UILabel!
    
    @IBOutlet weak var imgRecordRedCircle: UIImageView!
    @IBOutlet weak var lblAppointmentNumberInCircle: UILabel!
    @IBOutlet weak var lblRecordNumberInCircle: UILabel!
    @IBOutlet weak var imgAppointmentRedCircle: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DC.getCurrentDoctorInfoSet { (doctor) in
            self.loadDescription(doctor)
            self.thisDoctor = doctor
        
            self.doctorInfoDict = ["uid": doctor.UID!,"name": doctor.name!,"gender": doctor.gender!,"email": doctor.email!,"phone":doctor.phone!, "profileimage": doctor.profileImgURL!]
            self.doctorSocialPlatform = doctor.socialplatform!
            self.doctorEducation = doctor.education!
            self.doctorTimeInterval = doctor.meetingTimeInterval!
            
            if doctor.acceptAppoint!
            {
                self.lblDoctorStatus.text = "Available"
                self.lblDoctorStatus.textColor = UIColor.systemGreen
                self.switchAcceptAppoint.setOn(true, animated: true)
            }
            else
            {
                self.lblDoctorStatus.text = "Busy"
                self.lblDoctorStatus.textColor = UIColor.systemRed
                self.switchAcceptAppoint.setOn(false, animated: true)
            }
            
            //setup linker
            ViewControllersLinkers.doctorMainPageVC = self
            
        }
        
        setupView()
        setupImageGesture()
        
        AC.getDoctorAppointmentsList
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
                  
            self.doctorAppointmentList
                   = filteredAppointment
            self.doctorRecordList = temporaryRecord
            
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
    
    override func viewWillAppear(_ animated: Bool) {
           
           //reload patientAppointmentArray
        
        AC.getDoctorAppointmentsList
        {
            (appointmentList) in
            
            self.doctorAppointmentList = []
            self.doctorRecordList = []
                        
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
                        
            self.doctorAppointmentList
                         = filteredAppointment
            self.doctorRecordList = temporaryRecord
            
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
        imgProfileImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (handleSelectProfileImage)))
               
        imgProfileImg.isUserInteractionEnabled = true
        
        //add tappedGesture for book icon
        imgPersonalInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMoveToPersonalInfoViewController)))
        
        imgPersonalInfo.isUserInteractionEnabled = true
        
        
        let UIViewDoctorAppointmentsTappedGesture = UITapGestureRecognizer(target: self, action: #selector(handleMoveToDoctorAppointmentsPage))
        
        UIViewDoctorAppointments.addGestureRecognizer(UIViewDoctorAppointmentsTappedGesture)
        
        UIViewDoctorAppointments.isUserInteractionEnabled = true
        
        let UIViewDoctorRecordsTappedGesture = UITapGestureRecognizer(target: self, action: #selector(handleMoveToDoctorRecordsPage))
        
        UIViewDoctorRecords.addGestureRecognizer(UIViewDoctorRecordsTappedGesture)
        
        UIViewDoctorRecords.isUserInteractionEnabled = true
        
        let imgSetTimeIntervalTappedGesture = UITapGestureRecognizer(target: self, action: #selector(handleMoveToSetTimeIntervalPage))
        
        imgSetTimeInterval.addGestureRecognizer(imgSetTimeIntervalTappedGesture)
        
        imgSetTimeInterval.isUserInteractionEnabled = true
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DoctorAppointmentsPage"
        {
            if let destinationViewController = segue.destination as? DrAppointmentsViewController
            {
                destinationViewController.appointmentList = self.doctorAppointmentList
            }
        }
        
        else if segue.identifier == "DoctorRecordsPage"
        {
            if let destinationViewController = segue.destination as? DrRecordsViewController
            {
                destinationViewController.recordList = self.doctorRecordList
            }
        }
        
        else if segue.identifier == "DoctorInfoPage"
        {
            if let destinationViewController = segue.destination as? DrPersonalInfoViewController
            {
                destinationViewController.doctorInfoDict = self.doctorInfoDict
                destinationViewController.doctorSocialPlatform = self.doctorSocialPlatform
                destinationViewController.doctorEducation = self.doctorEducation
            }
            
        }
        
        else if segue.identifier == "SetTimeIntervalPage"
        {
            if let destinationViewController = segue.destination as? SetTimeIntervalPopUpViewController
            {
                destinationViewController.minutesInterval = self.doctorTimeInterval
            }
        }
        
    }
    
    @objc func handleMoveToSetTimeIntervalPage()
    {
        self.performSegue(withIdentifier: "SetTimeIntervalPage", sender: self)
    }
    
    @objc func handleMoveToDoctorAppointmentsPage()
    {
        self.performSegue(withIdentifier: "DoctorAppointmentsPage", sender: self)
    }
    
    @objc func handleMoveToDoctorRecordsPage()
    {
        self.performSegue(withIdentifier: "DoctorRecordsPage", sender: self)
    }
    
    @objc func handleMoveToPersonalInfoViewController()
    {
        self.performSegue(withIdentifier: "DoctorInfoPage", sender: self)
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
           
           UC.uploadProfileImage(selectedImage!,"doctor") {
               (data) in
               
               DispatchQueue.main.async {
                   self.imgProfileImg.image = UIImage(data: data)
               }
           }
           
           dismiss(animated: true, completion: nil)
           
    }
       
    
    func loadDescription(_ doctor: Doctor)
    {
        lblDoctorName.text = doctor.name
        lblDoctorDomain.text = doctor.domain
        lblTotalPeopleRated.text = "(\(doctor.totalPeopleRated!) reviewers)"
        
        let rating = doctor.totalRating!/Double(doctor.totalPeopleRated!)
        
        lblRating.text = String(rating)
        
        
        let doctorProfileImgURLstr = doctor.profileImgURL
        
        let doctorProfileImgURL = URL(string: doctorProfileImgURLstr!)
            
        URLSession.shared.dataTask(with: doctorProfileImgURL!, completionHandler: {
                
        (data, response, error) in
                
        if error != nil
        {
            print(error!)
            return
        }
        
        DispatchQueue.main.async
        {
            self.imgProfileImg.image = UIImage(data: data!)
        }
                
        }).resume()
    }
    
    
    @IBAction func switchAcceptAppoint(_ sender: UISwitch)
    {
        if (sender.isOn)
        {
            lblDoctorStatus.text = "Available"
            lblDoctorStatus.textColor = UIColor.systemGreen
            DC.updateAcceptAppointStatus(true)
        }
        else
        {
            lblDoctorStatus.text = "Busy"
            lblDoctorStatus.textColor = UIColor.systemRed
            DC.updateAcceptAppointStatus(false)
        }
    }
    
    
    
    func setupView()
    {
        
        imgProfileImg.layer.cornerRadius =
            imgProfileImg.frame.height/2
        imgProfileImg.layer.borderWidth = 2
        imgProfileImg.layer.borderColor = UIColor.black.cgColor
        imgProfileImg.clipsToBounds = true
    }
    
    
    
    @IBAction func btnLogout(_ sender: UIButton)
    {
        UC.logout()
        
        dismiss(animated: true, completion: nil)
    }
    

}
