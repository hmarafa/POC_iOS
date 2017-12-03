//
//  EmailViewController.swift
//  POC_iOS
//
//  Created by Hany Arafa on 10/30/17.
//  Copyright © 2017 Hany Arafa. All rights reserved.
//

import UIKit
import MessageUI
class EmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    var dTL: String = " "
    @IBOutlet weak var moleculesPerMicroL: UILabel!
    var mPML: String = " "
    @IBOutlet weak var userID: UITextField!
    var userIDString: String = " "
    var csvText : String = " "
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        userID.text = userIDString
        moleculesPerMicroL.text = mPML
        dateTimeLabel.text = dTL
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exportCSV(_ sender: Any)
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
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "backToTest"
        {
            let controller = segue.destination as! ViewController
            controller.userID.text = userID.text!
            print(userID.text as Any)
            controller.dateString = dateTimeLabel.text!
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

