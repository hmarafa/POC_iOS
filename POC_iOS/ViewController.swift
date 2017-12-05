//
//  ViewController.swift
//  POC_iOS
//
//  Created by Hany Arafa on 10/30/17.
//  Copyright © 2017 Hany Arafa. All rights reserved.
//

import UIKit
import Bean_iOS_OSX_SDK
import CoreBluetooth
import UICircularProgressRing

class ViewController: UIViewController, UITextFieldDelegate, PTDBeanManagerDelegate, PTDBeanDelegate {

    
    
    @IBOutlet weak var percentUpdate: UILabel!
    @IBOutlet weak var valueFromBean: UILabel!
    var beanManager: PTDBeanManager!
    var userID: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    var maxValue: String = " "
    var dateString: String = " "
    //@IBOutlet weak var timeTaken: UILabel!
    @IBOutlet weak var labelMinute: UILabel!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var labelMillisecond: UILabel!
    @IBOutlet weak var testProgressLabel: UILabel!
    var myBean: PTDBean!
    var lightState: Bool = false
    var startReading: Bool = true
    var stopReading: Bool = false
    var displayTime: Bool = false
    var lastValue: Bool = false
    var newLine: String = ""
    var csvText = ""
    
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var status: Bool = false
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        beanManager = PTDBeanManager()
        beanManager?.delegate = self
        lightState = false
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
       
        //make the csv up here
    }
    
    //optional func textFieldDidEndEditing(_ textField: UITextField)
    
    func textFieldShouldReturn( userID : UITextField) -> Bool {
        userID.resignFirstResponder()
        return true
    }
    
    func beanManagerDidUpdateState(_ beanManager: PTDBeanManager!)
    {
        if(self.beanManager!.state == BeanManagerState.poweredOn){
            self.beanManager?.startScanning(forBeans_error: nil)
            
        } else if (self.beanManager!.state == BeanManagerState.poweredOff) {
            let alert = UIAlertController(title: "Error", message: "Turn on bluetooth to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func startScanning()
    {
        var error: NSError?
        beanManager!.startScanning(forBeans_error: &error)
        if let e = error
        {
            print(e)
        }
        else
        {
            print("Connection is made")
        }
    }
    
    func beanManager(_ beanManager: PTDBeanManager!, didDiscover bean: PTDBean!, error: Error!) {
        if myBean == nil {
            if bean.state == .discovered {
                print("bean discovered")
                //       beanDiscovered = true
                viewDidAppear(true)
                myBean = bean
                beanManager!.connect(to: bean, withOptions:nil, error: nil)
                bean.delegate = self
            }
        }
        
        #if DEBUG
           print("DISCOVERED BEAN \nName: \(bean.name), UUID: \(bean.identifier) RSSI: \(bean.rssi)")
        #endif
    }
    func beanManager(_ beanManager: PTDBeanManager!, didConnect bean: PTDBean!, error: Error!) {
        if ((error) != nil) {
            let alert = UIAlertController(title: "Error", message: "This is an alert.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")}))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        var theError: NSError? = nil
        
            self.beanManager?.stopScanning(forBeans_error: &theError)
        
        if ((theError) != nil) {
            let alert = UIAlertController(title: "Error", message: "This is an alert.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")}))
           self.present(alert, animated: true, completion: nil)
            return;
        }
            }
    
    func BeanManager(beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: NSError!) {
        
    }
    
    
    @IBAction func handlerefresh(_ sender: Any) {
        if(self.beanManager!.state == BeanManagerState.poweredOn){
            var theError: NSError? = nil
            
            self.beanManager?.startScanning(forBeans_error: &theError)
            
            if ((theError) != nil) {
                let alert = UIAlertController(title: "Error", message: "This is an alert.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                //let alert: UIAlertController = UIAlertAction(title: "Error", message: theError!.localizedDescription, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok")
                //self.present(alert, animated: true, completion: nil)
            }
        }
        
        (sender as! UIRefreshControl).endRefreshing()
    }
    
/*    func connectionChanged(_ notification: Notification) {
        // Connection status changed. Indicate on GUI.
        let userInfo = (notification as NSNotification).userInfo as! [String: Bool]
        
        DispatchQueue.main.async(execute: {
            // Set image based on connection status
            if let isConnected: Bool = userInfo["isConnected"] {
                if isConnected {
                    let alertController = UIAlertController(title: "iOScreator", message:
                        "Hello, world!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                }
                else {
                    let alertController = UIAlertController(title: "iOScreator", message:
                        "Bluetooth is disconnecected. Please check your connection.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                
                }
            }
        });
    }

    */
    
    
    /* func bean(_ bean: PTDBean!, serialDataReceived data: Data!)
     {
     if(data != nil)
     {
     var receivedMessage = NSString(data:data, encoding: String.Encoding.utf8.rawValue)
     print("From serial: (receivedMessage)")
     ledTextLabel.text = receivedMessage! as string
     }
     }*/
    
    /* func connectToBean(bean: PTDBean)
     {
     var error: NSError?
     print ("hi")
     beanManager!.connect(to: bean, withOptions:nil, error: &error)
     print("Bean connected")
     bean.delegate = self
     
     
     }*/
    
    
    func sendSerialData(beanState: NSData)
    {
        print(myBean)
        print("bye")
        //while(lightState == true)
        //{
        myBean?.sendSerialData(beanState as Data!)
        //}
        //myBean?.sendSerialData(beanState as Data!)
        print("sent over serial data")
    }
    
    
    func bean(_ bean: PTDBean!, serialDataReceived data: Data!)
    {
        if(data != nil)
        {
            print ("Received Data")
        }
        
        let stringData : String = NSString(data: data, encoding : String.Encoding.ascii.rawValue)! as String
        if(stringData == "The time is")
        {
            displayTime = true
            var stringData : String = NSString(data: data, encoding : String.Encoding.ascii.rawValue)! as String
            //timeTaken.text? = stringData
        }
        else if(stringData == "Done")
        {
            //put a new line into the csv
        }
        else if(stringData == "Finished Calculating Value")
        {
            lastValue = true
        }
        else
        {
            /* var onlyDigits: CharacterSet = CharacterSet.decimalDigits.inverted
             if stringData.rangeOfCharacter(from: onlyDigits) != nil
             {
             let newValue = (Int(stringData)! / 1000) * 100
             percentUpdate.text = String(newValue)
             }*/
            
            let numbers = NSCharacterSet(charactersIn: "0123456789.").inverted
            
            if stringData.rangeOfCharacter(from: numbers) == nil
            {
                let newValue = (Double(stringData)! / 100.0) * 100
                print("HIIII")
                print(newValue)
                percentUpdate.text = String(newValue)
            }
            
            newLine += stringData + ","
            if(lastValue == true)
            {
                maxValue = stringData
                lastValue = false
            }
            else if(lastValue == true)
            {
                testProgressLabel.text = "Test is completed."
                //timeTaken.text? = stringData
                newLine += "\n"
                csvText.append(newLine)
                //WHEN THEY CLICK SAVE WRITE THE FILE TO THE PATH WE CREATED then send data over to next view controller to export
                displayTime = false
            }
            else
            {
                valueFromBean.text? = stringData
            }
            
            
        }
        
        //var fullString : String = valueFromBean.text!
        
        // valueFromBean.scrollRangeToVisible(NSMakeRange(count(valueFromBean.string!),0))
        //put this in a loop (while serialDataReceived < 1000 (so led has been turned on) or stop has been pressed)
        /* if(data != nil)
         {
         var stringReceived: String = ""
         
         let nLength: Int = data.count / MemoryLayout<UInt8>.size
         var arrData: [UInt8] = [UInt8](repeating: 0, count: nLength)
         data.copyBytes(to: &arrData, count: nLength)
         
         var n: Int = 0
         while(n < nLength)
         {
         let str = String(UnicodeScalar(arrData[n]))
         stringReceived += str
         n += 1
         }
         print(stringReceived)
         //   var receivedMessage = NSString(data:data, encoding: String.Encoding.utf8.rawValue)
         valueFromBean.text = stringReceived as String
         }*/
        
        //    NSString *uuidSubstring = [bean.identifier.UUIDString substringFromIndex:bean.identifier.UUIDString.length-4];
        //    serialOutput = [NSString stringWithFormat:@"%@-%@:%@", bean.name, uuidSubstring, serialOutput];
        
        /* if(serialOutput)
         {
         serialOutput = [self.consoleOutputTextView.string stringByAppendingString:serialOutput];
         self.consoleOutputTextView.string = serialOutput;
         }
         
         [self.consoleOutputTextView scrollRangeToVisible: NSMakeRange(self.consoleOutputTextView.string.length, 0)];*/
    }
    
       /* func saveData(_ sender: Any)
    {
        let fileName = "TimeData.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        do
        {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            print(csvText)
        }
        catch
        {
            print("File creating failed")
            print("\(error)")
        }
    }*/
    func start() {
        
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        // Set Start/Stop button to true
        status = true
        
    }
    
    func stop() {
        
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
        
        // Set Start/Stop button to false
        status = false
    }
    
    @objc func updateCounter() {
        
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        let milliseconds = UInt8(time * 100)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        // Add time vars to relevant labels
        labelMinute.text = strMinutes
        labelSecond.text = strSeconds
        labelMillisecond.text = strMilliseconds
        
    }
    @IBAction func pressButtonToChangeValue(_ sender: UIButton!)
    {
        if (status) {
            stop()
            
            //resetBtn.isEnabled = true
            
            // If button status is false use start function, relabel button and disable reset button
        } else {
            start()
            
            //resetBtn.isEnabled = false
            testProgressLabel.text = "Test in Progress"
            print(testProgressLabel.text)
        }
       
        //newLine = ""
        //print ("hi")
        //lightState = true
        //while (stopReading == false){
        //let data = NSData(bytes: &lightState, length: MemoryLayout<Bool>.size)
        //sendSerialData(beanState: data)
        //   updateLedStatusText(lightState: lightState)
      //  }
        
    }
    
    /*func stopReadingBean(_ sender: Any)
    {
        lightState = false
        print("debugging")
        let data = NSData(bytes: &lightState, length: MemoryLayout<Bool>.size)
        sendSerialData(beanState: data)
        performSegue(withIdentifier: "transfertoEmail", sender: self)

    }*/
 
    @IBAction func viewresult(_ sender: Any) {
        //lightState = false
        print("debugging")
        //let data = NSData(bytes: &lightState, length: MemoryLayout<Bool>.size)
       // sendSerialData(beanState: data)
        //performSegue(withIdentifier: "transfertoEmail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "transferToEmail"
        {
            //let controller = segue.destination as!EmailViewController
            //controller.csvText = csvText
            //print(userID)
            //controller.userID.text = userID.text
            //controller.mPML = maxValue
            //controller.dateString = dateAndTimeLabel.text!
            //print(emailViewController?.userID.text as Any)
        }
    }
}
    



