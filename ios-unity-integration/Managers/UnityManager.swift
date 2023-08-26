//
//  UnityManager.swift
//  ios-unity-integration
//
//  Created by Betül Çalık on 26.08.2023.
//

import Foundation
import UnityFramework

final class UnityManager: UIResponder, UIApplicationDelegate {
    
    // MARK: - Variables
    static let shared = UnityManager()
    
    private let dataBundleId = "com.unity3d.framework"
    private let frameworkPath = "/Frameworks/UnityFramework.framework"
    
    private var unityFramework: UnityFramework?
    private var hostMainWindow: UIWindow?
    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    private var isInitialized: Bool {
        return unityFramework != nil && unityFramework?.appController() != nil
    }
    
    // MARK: - Public Functions
    func show() {
        if isInitialized {
            showUnityWindow()
            return
        }
        
        initUnityWindow()
    }
    
    func setHostMainWindow(_ hostMainWindow: UIWindow?) {
        self.hostMainWindow = hostMainWindow
    }
    
    // MARK: - Private Functions
    private func initUnityWindow() {
        guard let unityFramework = loadUnityFramework() else {
            debugPrint("ERROR: Was not able to load Unity")
            return unloadUnityWindow()
        }
        
        self.unityFramework = unityFramework
        self.unityFramework?.setDataBundleId(dataBundleId)
        self.unityFramework?.register(self)
        self.unityFramework?.runEmbedded(withArgc: CommandLine.argc,
                                         argv: CommandLine.unsafeArgv,
                                         appLaunchOpts: launchOptions)
    }
    
    private func showUnityWindow() {
        if isInitialized {
            unityFramework?.showUnityWindow()
        }
    }
    
    private func unloadUnityWindow() {
        if isInitialized {
            unityFramework?.unloadApplication()
        }
    }
    
    private func loadUnityFramework() -> UnityFramework? {
        let bundlePath: String = Bundle.main.bundlePath + frameworkPath
        let bundle = Bundle(path: bundlePath)
        
        if bundle?.isLoaded == false {
            bundle?.load()
        }
        
        let unityFramework = bundle?.principalClass?.getInstance()
        if unityFramework?.appController() == nil {
            let machineHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
            machineHeader.pointee = _mh_execute_header
            
            unityFramework?.setExecuteHeader(machineHeader)
        }
        
        return unityFramework
    }
    
}

// MARK: - Unity Framework Listener
extension UnityManager: UnityFrameworkListener {
    
    func unityDidUnload(_ notification: Notification!) {
        unityFramework?.appController().rootViewController.dismiss(animated: true)
        unityFramework?.unregisterFrameworkListener(self)
        unityFramework = nil
        hostMainWindow?.makeKeyAndVisible()
    }
    
}
