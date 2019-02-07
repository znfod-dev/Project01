//
//  NotificationHelper.swift
//  Test2
//
//  Created by 김삼현 on 07/02/2019.
//  Copyright © 2019 김삼현. All rights reserved.
//
/** Ex)
// 현재 시간에 5초후 푸쉬 알람보내기
let alarmDate = Date(timeIntervalSinceNow: 5)
NotificationHelper.sharedInstance.alarmReservation(alarmDate: alarmDate, title: "제목", subtitle: "", body: "내용")
 */
import UIKit
import UserNotifications

class NotificationHelper: NSObject {
	static let sharedInstance = NotificationHelper()
	
	override init() {
		super.init()
		print("NotificationHelper init")
		
		//Configuration
		let center = UNUserNotificationCenter.current()
		center.delegate = self
		center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
			//granted = yes, if app is authorized for all of the requested interaction types
			//granted = no, if one or more interaction type is disallowed
		}
	}
	
	// 알람 예약
	// alarmDate : 예약 날짜/시간
	// title : 제목
	// subtitle : 서브 제목
	// body : 내용
	func alarmReservation(alarmDate: Date?, title: String, subtitle: String, body: String) {
		
		guard let alarmDate = alarmDate else {
			return
		}
		
		let calendar = Calendar.current
		let triggerDate = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: alarmDate)
		let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

		let formatter = DateFormatter()
		formatter.locale = Locale(identifier:"ko_KR")
		formatter.dateFormat = "yyyyMMdd_HHmmss"
		
		// 이 알림 요청의 고유 식별자입니다. 보류중인 알림 요청 또는 배달 된 알림을 바꾸거나 제거하는 데 사용할 수 있습니다.
		let identifierDate = formatter.string(from: alarmDate)
		print("identifierDate=\(identifierDate)")
		
		//Notification Content
		let content = UNMutableNotificationContent()
		content.title = title
		content.subtitle = subtitle
		content.body = body
//		content.categoryIdentifier = "INVITATION"
		content.sound = UNNotificationSound.default
		
		//Notification Request
		let request = UNNotificationRequest(identifier: identifierDate, content: content, trigger: trigger)
		
		//Scheduling the Notification
		let center = UNUserNotificationCenter.current()
		center.add(request) { (error) in
			if let error = error
			{
				print(error.localizedDescription)
			}
		}
	}
}

extension NotificationHelper: UNUserNotificationCenterDelegate
{
	//Here you get the callback for notification, if the app is in FOREGROUND.
	//Here you decide whether to silently handle the notification or still alert the user.
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
	{
		completionHandler([.alert, .sound]) //execute the provided completion handler block with the delivery option (if any) that you want the system to use. If you do not specify any options, the system silences the notification.
	}
	
/*
	//Here you get the callback when the user selects a custom action.
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
	{
		switch response.notification.request.content.categoryIdentifier
		{
		case "GENERAL":
			break
			
		case "INVITATION":
			switch response.actionIdentifier
			{
			case "remindLater":
				print("remindLater")
				
			case "accept":
				print("accept")
				
			case "decline":
				print("decline")
				
			case "comment":
				print("comment")
				
			default:
				break
			}
			
		default:
			break
		}
		
		completionHandler()
	}
*/
	//Here you get the payload of a remote notification whenever it arrives.
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
	{
		print("Original Remote Notification:\n\(userInfo)")
		completionHandler(.newData)
	}
}
