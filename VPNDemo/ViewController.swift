//
//  ViewController.swift
//  NEPacketTunnelVPNDemo
//
//  Created by lxd on 12/8/16.
//  Copyright © 2016 lxd. All rights reserved.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {
    var vpnManager: NETunnelProviderManager = NETunnelProviderManager()
    @IBOutlet var connectButton: UIButton!
    @IBOutlet weak var ipTextField: UITextField!
    
    // Hard code VPN configurations
    let tunnelBundleId = "org.kaige.vpndemo.tunnel"
//    let serverAddress = "192.168.1.104"
//    var serverAddress = "128.199.111.96"
//    let serverAddress = "13.76.171.234"
//    let serverAddress = "192.168.1.102"
    let serverAddress = "52.191.134.183"
    let serverPort = "20188" //ykgchanged
    let mtu = "600" //ykgchanged
    let ip = "10.9.0.2" //ykgchanged
    let subnet = "255.255.255.0"
    let dns = "8.8.8.8,8.4.4.4"
//    var newIP = ""


    private func initVPNTunnelProviderManager() {
        NETunnelProviderManager.loadAllFromPreferences { (savedManagers: [NETunnelProviderManager]?, error: Error?) in
            if let error = error {
                print(">>>>>>11111>>>>")
                print(error)
            }
            if let savedManagers = savedManagers {
                if savedManagers.count > 0 {
                    self.vpnManager = savedManagers[0]
                }
            }

            self.vpnManager.loadFromPreferences(completionHandler: { (error:Error?) in
                if let error = error {
                    print(">>>>>>2222>>>>")
                    print(error)
                }

                print(">>>>>>3333>>>>")
                let providerProtocol = NETunnelProviderProtocol()
                providerProtocol.providerBundleIdentifier = self.tunnelBundleId

                providerProtocol.providerConfiguration = ["port": self.serverPort,
                                                          "server": self.serverAddress,
                                                          "ip": self.ip,
                                                          "subnet": self.subnet,
                                                          "mtu": self.mtu,
                                                          "dns": self.dns
                ]
                providerProtocol.serverAddress = self.serverAddress
                self.vpnManager.protocolConfiguration = providerProtocol
                self.vpnManager.localizedDescription = "NEPacketTunnelVPNDemoConfig"
                self.vpnManager.isEnabled = true

                print(">>>>>>4444>>>>" + self.serverAddress)
                self.vpnManager.saveToPreferences(completionHandler: { (error:Error?) in
                    if let error = error {
                        print(error)
                    } else {
                        print("Save successfully")
                    }
                })
                self.VPNStatusDidChange(nil)

            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        print(">>>>>>0000>>>>")
        initVPNTunnelProviderManager()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.VPNStatusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func VPNStatusDidChange(_ notification: Notification?) {
        print("VPN Status changed:")
        let status = self.vpnManager.connection.status
        switch status {
        case .connecting:
            print("连接中...")
            connectButton.setTitle("断开连接", for: .normal)
            break
        case .connected:
            print("已连接...")
            connectButton.setTitle("断开连接", for: .normal)
            break
        case .disconnecting:
            print("断开中...")
            break
        case .disconnected:
            print("已断开...")
            connectButton.setTitle("连接", for: .normal)
            break
        case .invalid:
            print("Invliad")
            break
        case .reasserting:
            print("Reasserting...")
            break
        }
    }

    @IBAction func go(_ sender: UIButton, forEvent event: UIEvent) {
        print("Go!")
        
        
        
//        let s = "ykg"
//        let buf = [UInt8](s.utf8)
//        var data : Data
//        data = Data.init(bytes: buf)
//        
//        print(data.hexEncodedString())
//        
//        var data2 : Data
//        data2 = Data.init()
//        data.forEach { (b) in
//            data2.append(b & 1)
//        }
//        print(data2.hexEncodedString())
//        
//        print(data.xor().hexEncodedString())
        
        

//        serverAddress = ipTextField.text!
//        if serverAddress == "us1" {
//            serverAddress = "52.191.134.183"
//        }
//        serverAddress = "52.191.134.183"
//        print("go: " + serverAddress)
//        initVPNTunnelProviderManager()
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.VPNStatusDidChange(_:)), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
//
        
        self.vpnManager.loadFromPreferences { (error:Error?) in
            if let error = error {
                print(error)
            }
            if (sender.title(for: .normal) == "连接") {
                do {
                    try self.vpnManager.connection.startVPNTunnel()
                } catch {
                    print(error)
                }
            } else {
                self.vpnManager.connection.stopVPNTunnel()
            }
        }
    }


}

