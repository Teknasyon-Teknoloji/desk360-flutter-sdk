import Flutter
import UIKit
import Desk360
import Foundation

public class SwiftDesk360flutterPlugin: NSObject, FlutterPlugin {

  static var viewController = UIViewController();
  static var channel : FlutterMethodChannel? = nil;
    
  override init(){
  }
  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "desk360flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftDesk360flutterPlugin()
    viewController = (UIApplication.shared.delegate?.window??.rootViewController)!;
    registrar.addMethodCallDelegate(instance, channel: channel!)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "start") {
      guard let args = call.arguments else {
        return result("Could not recognize flutter arguments in method: (start)")
      }
      if let myArgs = args as? [String: Any]{
          if let properties = myArgs["properties"] as? Dictionary<String,Any> {
            var desk360Environment : Desk360Environment;
            if (properties["environment"] as? Int == 0){
                desk360Environment = .sandbox
            }
            else{
                desk360Environment = .production
            }
            
            let props = Desk360Properties(
              appID: properties["appID"] as? String ?? "",
              deviceID: properties["deviceID"] as? String ?? "",
              environment: desk360Environment,
              language: properties["languageCode"] as? String ?? "",
              country: properties["countryCode"]as? String ?? "",
              bypassCreateTicketIntro: properties["bypassCreateTicketIntro"] as? Bool ?? false,
              jsonInfo: properties["jsonInfo"] as? Dictionary<String,Any>
            )

            Desk360.start(using: props)
          }
          else{
              result(FlutterError(code: "-1", message: "iOS could not extract " +
              "flutter arguments in method: (start)", details: nil))
          }
          
      } else {
          result(FlutterError(code: "-1", message: "iOS could not extract " +
              "flutter arguments in method: (start)", details: nil))
      }
    }
    else if(call.method == "show") {
      if let myArgs = call.arguments as? [String: Any]{
        Desk360.show(on: SwiftDesk360flutterPlugin.viewController, animated: myArgs["animated"] as? Bool ?? false);
      } else {
        Desk360.show(on: SwiftDesk360flutterPlugin.viewController);
      }
    }
    else if(call.method == "showWithPushDeeplink") {
        Desk360.showWithPushDeeplink(on: SwiftDesk360flutterPlugin.viewController);
    }
    else if(call.method == "getUnreadTickets") {
        Desk360.getUnreadTickets{ results in
            switch results {
            case .failure(let error):
                result(FlutterError(code: "-2", message: error.localizedDescription, details: nil))
            case .success(let tickets):
                var items = [[String:Any]]();
                for model in tickets {
                    do{
                        let data = try JSONEncoder().encode(model)
                        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        items.append(dictionary);
                    }catch {
                        result(FlutterError(code: "-2", message: error.localizedDescription, details: nil))
                    }
                }
                result(items);
            }
        }
    }
    else if(call.method == "ticketDetailsViewController") {
        guard let args = call.arguments else {
          return result("Could not recognize flutter arguments in method: (ticketDetailsViewController)")
        }
        do {
            let myArgs = args as? [String: Any]
            let data = try JSONSerialization.data(withJSONObject: myArgs?["ticket"] as! [String:Any], options: [])
            let ticketData = try JSONDecoder().decode(Ticket.self, from: data)
            let detailsViewController = Desk360.ticketDetailsViewController(ofTicket: ticketData);
            SwiftDesk360flutterPlugin.viewController.present(detailsViewController, animated: myArgs?["animated"] as? Bool ?? false, completion: nil)
        } catch {
          result(FlutterError(code: "-1", message: "iOS could not extract " +
                  "flutter arguments in method: (ticketDetailsViewController)", details: nil))
        }
    }
    else if(call.method == "showDetails") {
        guard let args = call.arguments else {
          return result("Could not recognize flutter arguments in method: (showDetails)")
        }
        do {
            let myArgs = args as? [String: Any]
            let data = try JSONSerialization.data(withJSONObject: myArgs?["ticket"] as! [String:Any], options: [])
            let ticketData = try JSONDecoder().decode(Ticket.self, from: data)
            Desk360.showDetails(ofTicket: ticketData, on: SwiftDesk360flutterPlugin.viewController, animated: myArgs?["animated"] as? Bool ?? false);
        } catch {
          result(FlutterError(code: "-1", message: "iOS could not extract " +
                  "flutter arguments in method: (showDetails)", details: nil))
        }
    }
    else if(call.method == "setPushToken") {
      guard let args = call.arguments else {
        return result("Could not recognize flutter arguments in method: (setPushToken)")
      }
      if let myArgs = args as? [String: Any]{
        Desk360.setPushToken(deviceToken: (myArgs["deviceToken"] as? String)?.data(using: .utf8));
      } else {
        result(FlutterError(code: "-1", message: "iOS could not extract " +
                "flutter arguments in method: (setPushToken)", details: nil))
      }
    }
    else if(call.method == "applicationUserInfoChecker") {
      guard let args = call.arguments else {
        return result("Could not recognize flutter arguments in method: (applicationUserInfoChecker)")
      }
      if let myArgs = args as? [String: Any]{
        Desk360.applicationUserInfoChecker(myArgs["launchOptions"] as? [AnyHashable : Any]);
      } else {
        result(FlutterError(code: "-1", message: "iOS could not extract " +
                  "flutter arguments in method: (applicationUserInfoChecker)", details: nil))
      }
    }
    else if(call.method == "willNotificationPresent") {
      guard let args = call.arguments else {
        return result("Could not recognize flutter arguments in method: (willNotificationPresent)")
      }
      if let myArgs = args as? [String: Any]{
        Desk360.willNotificationPresent(myArgs["userInfo"] as? [AnyHashable : Any]);
      } else {
        result(FlutterError(code: "-1", message: "iOS could not extract " +
                  "flutter arguments in method: (willNotificationPresent)", details: nil))
      }
    }
    else if(call.method == "applicationLaunchChecker") {
      guard let args = call.arguments else {
        return result("Could not recognize flutter arguments in method: (applicationLaunchChecker)")
      }
      if let myArgs = args as? [String: Any]{
        Desk360.applicationLaunchChecker(myArgs["launchOptions"] as? [UIApplication.LaunchOptionsKey : Any])
      } else {
        result(FlutterError(code: "-1", message: "iOS could not extract " +
                  "flutter arguments in method: (applicationLaunchChecker)", details: nil))
      }
    }
  }

  public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data -> String in
        return String(format: "%02.2hhx", data)
    }
    let token = tokenParts.joined()
    SwiftDesk360flutterPlugin.channel?.invokeMethod("onDeviceToken", arguments: token)
  }
    
  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
    SwiftDesk360flutterPlugin.channel?.invokeMethod("didFinishLaunchingWithOptions", arguments: launchOptions)
    return true;
  }
    
  public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      
    SwiftDesk360flutterPlugin.channel?.invokeMethod("didReceiveRemoteNotification", arguments: userInfo)
  }
  
  public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          completionHandler([.alert])
    SwiftDesk360flutterPlugin.channel?.invokeMethod("willPresent", arguments: notification.request.content.userInfo)
  }
  
  @available(iOS 10.0, *)
  public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    SwiftDesk360flutterPlugin.channel?.invokeMethod("didReceive", arguments: response.notification.request.content.userInfo)
  }
}
