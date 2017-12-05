//
//  ConnectionViewController.swift
//  POC_iOS
//
//  Created by Hany Arafa on 10/30/17.
//  Copyright © 2017 Hany Arafa. All rights reserved.
//

import UIKit
import Bean_iOS_OSX_SDK
import CoreBluetooth


class ConnectionViewController: UIViewController, PTDBeanManagerDelegate, PTDBeanDelegate
{
    var beanManager: PTDBeanManager?
    var myBean: PTDBean?
    
    @IBOutlet weak var connectionLabel: UILabel!
    
    @IBOutlet weak var beanNameChanged: UILabel!
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        beanManager = PTDBeanManager()
        beanManager!.delegate = self
    }
    
    func textFieldShouldReturn( userID : UITextField) -> Bool {
        userID.resignFirstResponder()
        return true
    }
    
     override func viewDidAppear(_ animated: Bool)
     {
     if(self.myBean != nil)
     {
        beanManager?.disconnectBean(myBean, error: nil)
     self.myBean = nil
     }
     
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
    
    func update() {
        if (self.myBean!.state == .discovered) {
            //self.connectToBean.title = "Connect"
            self.connectionLabel.isEnabled = true
            
        } else if (self.myBean!.state == .connectedAndValidated ) {
            //self.connectToBean.title = "Disconnect"
            self.connectionLabel.isEnabled = true
        }
        
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
    
    @IBAction func connectToBean(_ sender: Any)
    {
        
            //self.myBean!.delegate = self
            //beanManager!.connect(to: myBean, withOptions:nil, error: nil)
            //myBean?.delegate = self
            //self.connectionLabel.isEnabled = false
            
    
      beanManager!.connect(to: myBean, withOptions:nil, error: nil)
        myBean?.delegate = self
        connectionLabel.text = "You are now connected"
    }
    
    func beanManager(_ beanManager: PTDBeanManager!, didDiscover bean: PTDBean!, error: Error!)
    {
        if myBean == nil
        {
            if bean.state == .discovered
            {
                print("bean discovered")
                beanNameChanged.text = bean.name
                //       beanDiscovered = true
                viewDidAppear(true)
                myBean = bean
                beanManager!.connect(to: bean, withOptions:nil, error: nil)
                //    bean.delegate = self
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
    
    func BeanManager(beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: Error!) {
        if (myBean == self.myBean) {
            self.update()
        }
    }
    @IBAction func handlerefresh(_ sender: Any)
    {
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
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
     if segue.identifier == "transferToPatientScreen"
     {
    let controller = segue.destination as! IDViewController
    //controller.dateString = dateAndTimeLabel.text!
    //controller.myBean = myBean
     }
     
    
    
}
}
