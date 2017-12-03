//
//  IDViewController.swift
//  POC_iOS
//
//  Created by Hany Arafa on 10/30/17.
//  Copyright © 2017 Hany Arafa. All rights reserved.
//
import UIKit
import Bean_iOS_OSX_SDK
import CoreBluetooth

class IDViewController: UIViewController, PTDBeanManagerDelegate, PTDBeanDelegate  {
    
    @IBOutlet weak var userID: UITextField!

    //  var beanManager: PTDBeanManager!
    // var myBean: PTDBean!
    
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // let date = NSDate()
        //  let calendar = NSCalendar.current
        //  let components = calender.components([.Hour, .Minute], fromDate: date)
        
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        // get the date time String from the date object
        let result = formatter.string(from: currentDateTime) // October 8, 2017 at 10:48:53 PM
        
        dateAndTimeLabel.text = result
        
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderWidth = width
        userID.layer.addSublayer(border)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    func textFieldShouldReturn(userID: UITextField) -> Bool {
        userID.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "idSegue"
        {
            let controller = segue.destination as! ViewController
            //controller.userID = userID.text!
            
            controller.dateString = dateAndTimeLabel.text!
            //controller.myBean = myBean
            print(dateAndTimeLabel.text as Any)
        }
    }
    
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
