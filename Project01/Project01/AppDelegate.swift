//
//  AppDelegate.swift
//  Project01
//
//  Created by 박종현 on 13/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import IceCream
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var syncEngine: SyncEngine? // 아이클라우드 연동을 위한 싱크엔진 객체
    
    let deviceWidth = UIScreen.main.bounds.size.width
    let deviceHeight = UIScreen.main.bounds.size.height
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
        application.registerForRemoteNotifications()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.pushiCloudData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.pulliCloudData()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let dict = userInfo as! [String: NSObject]
        let notification = CKNotification(fromRemoteNotificationDictionary: dict)
        
        if (notification.subscriptionID == IceCreamConstant.cloudKitSubscriptionID) {
            NotificationCenter.default.post(name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil, userInfo: userInfo)
        }
        completionHandler(.newData)
        
    }


	// MARK: - Shared Instance
	/**
	* 공유 UIApplication 객체 access (싱클톤 패턴)
	* @return UIApplication class
	*/
	class func sharedAppDelegate() -> AppDelegate? {
		return UIApplication.shared.delegate as? AppDelegate
	}
	
	class func sharedNamedStroyBoard(_ storyBoardName: String?) -> Any? {
		//스토리 보드 id 로딩
		return UIStoryboard(name: storyBoardName ?? "", bundle: Bundle.main)
	}
    
    // MARK: - iCloud 연동
    func accessiCloudData() {
        print("accessiCloudData")
        // Realm과 아이클라우드와 연동
        self.syncEngine = SyncEngine(objects: [SyncObject<ModelDBDiary>(),
                                               SyncObject<ModelDBProfile>(),
                                               SyncObject<ModelDBTodo>(),
                                               SyncObject<ModelDBPlan>(),
                                               SyncObject<ModelDBProfileImage>(),
                                               SyncObject<ModelDBTest>(),
                                               ],
                                     callback: {
                                        print("클라우드 로드 완료")
                                        
                                        // Notification 통지 쓰기 (통지를 보내고 싶은 곳에 쓴다. 예를 들어 어떤 버튼을 눌렀을 때의 처리 중등)
                                        NotificationCenter.default.post(name: Notification.Name("CloudLoadComplete"), object: nil)
        })
    }
    
    // MARK: - iCloud Push
    func pushiCloudData() {
        print("pushiCloudData")
        if self.syncEngine != nil {
            self.syncEngine?.pushAll()
        }else {
            
        }
    }
    
    // MARK: - iCloud Pull
    func pulliCloudData() {
        print("pulliCloudData")
        if self.syncEngine != nil {
            self.syncEngine?.pull()
        }else {
            
        }
    }
    
}

