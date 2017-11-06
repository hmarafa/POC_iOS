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

class ViewController: UIViewController, PTDBeanManagerDelegate, PTDBeanDelegate {
    
    @IBOutlet weak var percentUpdate: UILabel!
    @IBOutlet weak var valueFromBean: UILabel!
    var beanManager: PTDBeanManager!
    var userID: String = ""
    var maxValue: String = " "
    var dateString: String = " "
    @IBOutlet weak var timeTaken: UILabel!
    @IBOutlet weak var testProgressLabel: UILabel!
    var myBean: PTDBean!
    var lightState: Bool = false
    var startReading: Bool = true
    var stopReading: Bool = false
    var displayTime: Bool = false
    var lastValue: Bool = false
    var newLine: String = ""
    var csvText = ""
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beanManager = PTDBeanManager()
        beanManager!.delegate = self
        lightState = false
        //make the csv up here
    }
    
    
    func beanManagerDidUpdateState(_ beanManager: PTDBeanManager!)
    {
        let scanError: NSError?
        if beanManager!.state == BeanManagerState.poweredOn
        {
            print("made it here")
            startScanning()
            print("made it here part 2")
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
        
        var stringData : String = NSString(data: data, encoding : String.Encoding.ascii.rawValue) as! String
        if(stringData == "The time is")
        {
            displayTime = true
            //  var stringData : String = NSString(data: data, encoding : String.Encoding.ascii.rawValue) as! String
            //  timeTaken.text? = stringData
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
                let newValue = (Double(stringData)! / 1000.0) * 100
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
            else if(displayTime == true)
            {
                testProgressLabel.text = "Test is completed."
                timeTaken.text? = stringData
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
    
    @IBAction func saveData(_ sender: Any)
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
    }
    
    @IBAction func pressButtonToChangeValue(_ sender: Any)
    {
        testProgressLabel.text = "Test is in Progress. Please Wait."
        print(testProgressLabel.text)
        newLine = ""
        print ("hi")
        lightState = true
        //while (stopReading == false)
        //   {
        let data = NSData(bytes: &lightState, length: MemoryLayout<Bool>.size)
        sendSerialData(beanState: data)
        //   updateLedStatusText(lightState: lightState)
        // }
        
    }
    
    @IBAction func stopReadingBean(_ sender: Any)
    {
        lightState = false
        print("debugging")
        let data = NSData(bytes: &lightState, length: MemoryLayout<Bool>.size)
        sendSerialData(beanState: data)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "transferToEmail"
        {
            let emailViewController = segue.destination as? EmailViewController
            emailViewController?.csvText = csvText
            print(userID)
            emailViewController?.userIDString = userID
            emailViewController?.mPML = maxValue
            emailViewController?.dTL = dateString
            print(emailViewController?.userIDString)
        }
    }
    
}



