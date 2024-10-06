public with sharing class PapagoController {
    @AuraEnabled
    public static String translateInfo(String question){
        String result;

        try {
            String apiURL = 'https://openapi.naver.com/v1/papago/n2mt';

            // Named Credentials를 사용하여 연결 설정
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiURL);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');

            String clientId = 'Ck75yuyd0mwKGLrkDsnb'; // 애플리케이션 클라이언트 아이디값
            String clientSecret = 'XrW6lVlPU1'; // 애플리케이션 클라이언트 시크릿값

            // API 요청 바디 설정
            String requestBody = 'source=ko&target=en&text=' + EncodingUtil.urlEncode(question, 'UTF-8');
            request.setHeader('X-Naver-Client-Id', clientId);
            request.setHeader('X-Naver-Client-Secret', clientSecret);
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
            request.setHeader('Accept', '*/*');
            request.setBody(requestBody);

            // API 호출 및 응답 처리
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                Map<String, Object> jsonMessage = (Map<String, Object>) jsonResponse.get('message');
                Map<String, Object> jsonResult = (Map<String, Object>) jsonMessage.get('result');
                result = (String) jsonResult.get('translatedText');

                return result;
            } else {
                // 오류 처리
                System.debug('API 오류: ' + response.getBody());
                throw new AuraHandledException('API 호출 중 오류 발생');
            }

        } catch (Exception e) {
            System.debug('Error : '       + e.getMessage());
            System.debug('Line Number : ' + e.getLineNumber());

            throw new AuraHandledException(e.getMessage());
        }
    }
}