//
//  EmailViewController.swift
//  POC_iOS
//
//  Created by Hany Arafa on 10/30/17.
//  Copyright © 2017 Hany Arafa. All rights reserved.
//

import UIKit
import MessageUI

class EmailVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    //@IBOutlet weak var dateLabel : UILabel!
    //@IBOutlet weak var moleculesPerMicroL: UILabel!
    var mPML: String = " "
    //@IBOutlet weak var userID: UITextField!
    var userIDString: String = " "
    var csvText : String = " "
    var result : String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        // get the date time String from the date object
        let result = formatter.string(from: currentDateTime) // October 8, 2017 at 10:48:53 PM
        
        dateLabel.text = result
        //labelSecond.text = strSeconds
        //userID.text = userIDString
        //moleculesPerMicroL.text = mPML
        //dateTimeLabel.text = dTL
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func testing(_ sender: Any) {
        print("touchdown")
    }
    
    /*@IBAction func exportCSV(_ sender: UIButton!)
     {
     let fileName = "TimeData.csv"
     let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
     do
     {
     try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
     }
     catch
     {
     print("Failed to export file")
     }
     let emailViewController = configuredMailComposeViewController()
     if MFMailComposeViewController.canSendMail()
     {
     self.present(emailViewController, animated: true, completion: nil)
     }
     }*/
    
    @IBAction func sendEmailButtonTapped(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    /* func configuredMailComposeViewController() -> MFMailComposeViewController
     {
     let emailController = MFMailComposeViewController()
     emailController.mailComposeDelegate = self
     emailController.setSubject("CSV File")
     emailController.setMessageBody("Here is the data", isHTML: false)
     
     let data = csvText.data(using: String.Encoding.utf8, allowLossyConversion: false)!
     
     emailController.addAttachmentData(data, mimeType: "text/csv", fileName: "TimeData.csv")
     return emailController
     }
     
     func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
     controller.dismiss(animated: true, completion: nil)
     //pop up with notification saying "your message has been sent!"
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "backToTest"
        {
            //let controller = segue.destination as! ViewController
            // controller.userID.text = userID.text!
            // print(userID.text as Any)
            //controller.dateString = dateAndTimeLabel.text!
            //controller.dateString = dateTimeLabel.text!
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


