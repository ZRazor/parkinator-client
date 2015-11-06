#import <Foundation/Foundation.h>

//#define API_BASE_URL @"http://worldwidepolza.com/api"
#define API_BASE_URL @"http://mayakdev.ru/api"
#define API_GET_AUTH_CODE @"/authorize/getAuthCode"
#define API_GET_ACCESS_TOKEN @"/authorize/getAccessToken"
#define API_REGISTER @"/register"
#define API_REMIND_PASSWORD @"/remind"
#define API_SET_USER_DATA @"/user?accessToken=%@"
#define API_CHANGE_USER_PASS @"/user/password?accessToken=%@"
#define API_GET_USER_DATA @"/user"
#define API_GET_ITEM_LIST @"/parking/list"

@interface MRRequester : NSObject

+ (void)doPostRequest:(NSString *)url params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block;

+ (void)doPostRequest:(NSString *)url params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block progressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;

+ (void)doGetRequest:(NSString *)url params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block;

+ (void)doRequest:(NSString *)url isBaseUrl:(BOOL)isBaseUrl isPost:(BOOL)isPost jsonAns:(BOOL)jsonAns params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block progressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;

@end
