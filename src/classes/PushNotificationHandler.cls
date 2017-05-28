public  class PushNotificationHandler {

    @future ( callout = true )
    public static void sendPushNotification(String title, String message, String url){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.pushbots.com/push/all');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('x-pushbots-appid', '<Configure Pushbot APP Id>');
        request.setHeader('x-pushbots-secret', '<Configure Pushbot Secret Key>');

        // Set the body as a JSON object
        request.setBody('{"platform" : 2 , "msg" : "'+message+'" , "payload" : {"nTitle" : "'+title+'", "url":"'+url+'" }  }');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }

    }
    
}