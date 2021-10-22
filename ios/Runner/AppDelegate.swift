// AppDelegate.swift

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate{
//  var navigationController: UINavigationController?;
    var deepLinkMethodChannel:FlutterMethodChannel?;

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    // Add this line before GeneratedPluginRegistrant
      let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController;
      
      deepLinkMethodChannel = FlutterMethodChannel(name: "deep_link_ios", binaryMessenger: flutterViewController.binaryMessenger)
      
      
    // This line is added by the Flutter App Generator
    GeneratedPluginRegistrant.register(with: self)

    // Add these lines after GeneratedPluginRegistrant
//    self.navigationController = UINavigationController(rootViewController: flutterViewController);
//    self.navigationController?.setNavigationBarHidden(true, animated: false);
//
//    self.window = UIWindow(frame: UIScreen.main.bounds);
//    self.window.rootViewController = self.navigationController;
//    self.window.makeKeyAndVisible();
    // End of edit

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  override  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      deepLinkMethodChannel?.invokeMethod("url_received", arguments: [
        "url":url.absoluteString
      
        ]);
        print(url);
        return true;
    }
}

