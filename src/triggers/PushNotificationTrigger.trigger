trigger PushNotificationTrigger on Push_Notification__c (after insert) {

    PushNotificationHandler.sendPushNotification(Trigger.new[0].Title__c,Trigger.new[0].Message__c, Trigger.new[0].URL__c);  
}