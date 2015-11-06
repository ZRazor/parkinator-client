#import <Foundation/Foundation.h>

//#define API_BASE_URL @"http://worldwidepolza.com/api"
#define API_BASE_URL @"http://mayakdev.ru/api"


@interface MRRequester : NSObject

+ (void)doPostRequest:(NSString *)url params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block;

+ (void)doPostRequest:(NSString *)url params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block progressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;

+ (void)doGetRequest:(NSString *)url params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block;

+ (void)doRequest:(NSString *)url isBaseUrl:(BOOL)isBaseUrl isPost:(BOOL)isPost jsonAns:(BOOL)jsonAns params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block progressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;

@end
