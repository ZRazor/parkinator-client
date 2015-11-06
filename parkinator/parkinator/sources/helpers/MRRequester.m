#import "MRRequester.h"
#import <AFHTTPRequestOperationManager.h>

@implementation MRRequester

+ (void)doPostRequest:(NSString *)url params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block
{
    [MRRequester doRequest:url isBaseUrl:YES isPost:YES jsonAns:YES params:params block:block progressBlock:NULL];
}

+ (void)doPostRequest:(NSString *)url params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block progressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock
{
    [MRRequester doRequest:url isBaseUrl:YES isPost:YES jsonAns:YES params:params block:block progressBlock:progressBlock];
}


+ (void)doGetRequest:(NSString *)url params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block
{
    [MRRequester doRequest:url isBaseUrl:YES isPost:NO jsonAns:YES params:params block:block progressBlock:NULL];
}

+ (void)doRequest:(NSString *)url isBaseUrl:(BOOL)isBaseUrl isPost:(BOOL)isPost jsonAns:(BOOL)jsonAns params:(NSDictionary *)params block:(void (^)(id result, NSError *error))block progressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock
{
    NSString *requestUrl = url;
    if (isBaseUrl) {
        requestUrl = [NSString stringWithFormat:@"%@%@", API_BASE_URL, url];
    }

    NSLog(@"Preparing request\n"
                    "Request Url: %@\n"
                    "Is POST: %d\n"
                    "Params: %@\n",
            requestUrl, isPost, params);


    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    if (jsonAns) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", nil];
    } else {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        if (isBaseUrl) {
//            manager.requestSerializer.stringEncoding = NSWindowsCP1251StringEncoding;
//        }
    }
    if (isPost) {
        AFHTTPRequestOperation *requestOperation = [manager POST:requestUrl parameters:params
                                                         success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                         {
                                                             NSLog(@"Success request: %@\n", requestUrl);
                                                             block(responseObject, nil);
                                                         }
                                                         failure:
                                                                 ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                     NSLog(@"Fail request: %@\nError: %@\n", requestUrl, error.userInfo);
                                                                     block(nil, error);
                                                                 }

        ];
        if (progressBlock != NULL) {
            [requestOperation setUploadProgressBlock:progressBlock];
        }
    } else {
        AFHTTPRequestOperation *requestOperation = [manager GET:requestUrl parameters:params
                                                        success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                        {
                                                            NSLog(@"Success request: %@\n", requestUrl);
                                                            block(responseObject, nil);
                                                        }
                                                        failure:
                                                                ^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                    NSLog(@"Fail request: %@\nError: %@\n", requestUrl, error.userInfo);
                                                                    block(nil, error);
                                                                }];
        if (progressBlock != NULL) {
            [requestOperation setUploadProgressBlock:progressBlock];
        }
    }

}

@end
