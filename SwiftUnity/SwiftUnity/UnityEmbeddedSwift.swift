//
//  UnityEmbeddedSwift.swift
//  iOSApp
//
//  Created by Sandeep M on 24/12/19.
//  Copyright © 2019 Kiksar. All rights reserved.
//

import Foundation
import UnityFramework
class UnityEmbeddedSwift: UIResponder, UIApplicationDelegate, UnityFrameworkListener {
    var msgData = ""
    func changeBG(_ bgcolor: String!) {
        print("\nchnages color from is unity")
               print(bgcolor)
        

    }
    
    func mytest(_ color: String!) {
        print("\nthis is unity")
        print(color)
        msgData = color
//        UserDefaults.standard.set(color, forKey: "PasMSG")
        UserDefaults.standard.set(color, forKey: "PasMSG") //setObject
       
NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        
    }

    

    static func getUnityV()->UIView! {
        return instance.ufw.appController()?.rootViewController.view
    }
    static func getUnityRootC()->UIViewController! {
        return instance.ufw.appController()?.rootViewController
    }
    private struct UnityMessage {
        let objectName : String?
        let methodName : String?
        let messageBody : String?
    }
    var nav = UINavigationController()
    private static var instance : UnityEmbeddedSwift!
    private var ufw : UnityFramework!
    private static var hostMainWindow : UIWindow! //Window to return to when exitting Unity window
    private static var launchOpts : [UIApplication.LaunchOptionsKey: Any]?
 
    private static var cachedMessages = [UnityMessage]()
 
    //Static functions that can be called from other scripts
    static func setHostMainWindow(_ hostMainWindow : UIWindow?) {
        UnityEmbeddedSwift.hostMainWindow = hostMainWindow
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
   
    }
 
    static func setLaunchinOptions(_ launchingOptions :  [UIApplication.LaunchOptionsKey: Any]?) {
        UnityEmbeddedSwift.launchOpts = launchingOptions
    }
 
    static func showUnity() {
        if(UnityEmbeddedSwift.instance == nil || UnityEmbeddedSwift.instance.unityIsInitialized() == false) {
            UnityEmbeddedSwift().initUnityWindow()
            print("initalized unity")
        }
        else {
            print("already init")

            UnityEmbeddedSwift.instance.showUnityWindow()
        }
    }
 
    static func hideUnity() {
        UnityEmbeddedSwift.instance?.hideUnityWindow()
    }
 
    static func unloadUnity() {
        UnityEmbeddedSwift.instance?.unloadUnityWindow()
    }
 
    static func sendUnityMessage(_ objectName : String, methodName : String, message : String) {
        let msg : UnityMessage = UnityMessage(objectName: objectName, methodName: methodName, messageBody: message)
   
   
        //Send the message right away if Unity is initialized, else cache it
        if(UnityEmbeddedSwift.instance != nil && UnityEmbeddedSwift.instance.unityIsInitialized()) {
            UnityEmbeddedSwift.instance.ufw.sendMessageToGO(withName: msg.objectName, functionName: msg.methodName, message: msg.messageBody)
        }
        else {
            UnityEmbeddedSwift.cachedMessages.append(msg)
        }
    }
 
    //Callback from UnityFrameworkListener
    func unityDidUnload(_ notification: Notification!) {
        ufw.unregisterFrameworkListener(self)
        ufw = nil
        UnityEmbeddedSwift.hostMainWindow?.makeKeyAndVisible()
    }
 
    //Private functions called within the class
    private func unityIsInitialized() -> Bool {
        return ufw != nil && (ufw.appController() != nil)
    }
 
    private func initUnityWindow() {
        if unityIsInitialized() {
            showUnityWindow()
            return
        }
   
        ufw = UnityFrameworkLoad()!
        ufw.setDataBundleId("com.unity3d.framework")
        ufw.register(self)
//        NSClassFromString("FrameworkLibAPI")?.registerAPIforNativeCalls(self)
   
        ufw.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: UnityEmbeddedSwift.launchOpts)
   
        sendUnityMessageToGameObject()
   
        UnityEmbeddedSwift.instance = self
    }
 
    private func showUnityWindow() {
        if unityIsInitialized() {
            ufw.showUnityWindow()
            sendUnityMessageToGameObject()
        }
    }
 
    private func hideUnityWindow() {
        if(UnityEmbeddedSwift.hostMainWindow == nil) {
            print("WARNING: hostMainWindow is nil! Cannot switch from Unity window to previous window")
        }
        else {
            UnityEmbeddedSwift.hostMainWindow?.makeKeyAndVisible()
        }
    }
 
    private func unloadUnityWindow() {
        if unityIsInitialized() {
            UnityEmbeddedSwift.cachedMessages.removeAll()
          
        }
    }
 
    private func sendUnityMessageToGameObject() {
        if(UnityEmbeddedSwift.cachedMessages.count >= 0 && unityIsInitialized())
        {
            for msg in UnityEmbeddedSwift.cachedMessages {
                ufw.sendMessageToGO(withName: msg.objectName, functionName: msg.methodName, message: msg.messageBody)
            }
       
            UnityEmbeddedSwift.cachedMessages.removeAll()
        }
    }
 
    private func UnityFrameworkLoad() -> UnityFramework? {
        let bundlePath: String = Bundle.main.bundlePath + "/Frameworks/UnityFramework.framework"
   
        let bundle = Bundle(path: bundlePath )
        if bundle?.isLoaded == false {
            bundle?.load()
        }
   
        let ufw = bundle?.principalClass?.getInstance()
        if ufw?.appController() == nil {
            // unity is not initialized
            //            ufw?.executeHeader = &mh_execute_header
       
            let machineHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
            machineHeader.pointee = _mh_execute_header
       
            ufw!.setExecuteHeader(machineHeader)
        }
        return ufw
    }
}
