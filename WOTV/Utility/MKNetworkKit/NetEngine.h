//
//  NetEngine.h
//  csc
//
//  Created by hetao on 12-11-13.
//
//

#import "Foundation.h"
#import "SVProgressHUD.h"
#import "Utility.h"
#import "MKNetworkEngine.h"
#import "UIImageView+WebCache.h"
@interface NetEngine : MKNetworkEngine
typedef void (^CurrencyResponseBlock)(id responseData, BOOL isCache);
typedef void (^CustomResponseBlock)(id responseData, BOOL isCache  ,id redirectURL);

+(id)Share;
+(id)ShareWithextra;
+(void)cancel;


+(MKNetworkOperation*) createFileAction:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                               withMask:(SVProgressHUDMaskType)mask;

+(MKNetworkOperation*) createUploadFileWithUrl:(NSString*) url
                                      filePath:(NSString *)path
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                               withMask:(SVProgressHUDMaskType)mask;

+(MKNetworkOperation*) createHttpAction:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                               useCache:(BOOL)usecache
                               withMask:(SVProgressHUDMaskType)mask;

+(MKNetworkOperation*) createHttpAction:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                               useCache:(BOOL)usecache
                               withMask:(SVProgressHUDMaskType)mask
                             httpMethod:(NSString*)method;

+(MKNetworkOperation*) createHttpActionWithextra:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                               useCache:(BOOL)usecache
                               withMask:(SVProgressHUDMaskType)mask;

+(MKNetworkOperation*)  createHttpActionWithTest:(NSString*) url
                                          params:(NSDictionary*) body
                                    onCompletion:(CurrencyResponseBlock) completionBlock
                                         onError:(MKNKErrorBlock) errorBlock
                                        useCache:(BOOL)usecache
                                        withMask:(SVProgressHUDMaskType)mask
                                      httpMethod:(NSString*)method;

+(MKNetworkOperation*)  createHttpActionWithHostName:(NSString*) domain
                                                Path:(NSString*) path
                                          PortNumber:(NSString*) portNumber
                                          params:(NSDictionary*) body
                                    onCompletion:(CustomResponseBlock) completionBlock
                                         onError:(MKNKErrorBlock) errorBlock
                                        useCache:(BOOL)usecache
                                        withMask:(SVProgressHUDMaskType)mask
                                      httpMethod:(NSString*)method;

+(MKNetworkOperation*)  createHttpActionWithUrlString:(NSString*) urlstring
                                              params:(NSDictionary*) body
                                        onCompletion:(CustomResponseBlock) completionBlock
                                             onError:(MKNKErrorBlock) errorBlock
                                            useCache:(BOOL)usecache
                                            withMask:(SVProgressHUDMaskType)mask
                                          httpMethod:(NSString*)method;


/*        _extrainstance = [[NetEngine alloc] initWithHostName:extraDomain apiPath:extraPath customHeaderFields:nil];
 _extrainstance.portNumber=[extraPort integerValue];
 [_extrainstance useCache];*/

+(MKNetworkOperation*) createHttpAction:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock;

+(MKNetworkOperation*) createUploadImageAction:(NSString*)url
                                      ImageKey:(NSString*)key
                                         Image:(UIImage*)image
                                  onCompletion:(CurrencyResponseBlock)completionBlock
                                       onError:(MKNKErrorBlock)errorBlock
                                      withMask:(SVProgressHUDMaskType)mask;
+(MKNetworkOperation*) createUploadMutableImageAction:(NSString*)url
                                             ImageKey:(NSString*)key
                                           ImageArray:(NSMutableArray*)imageArray
                                         onCompletion:(CurrencyResponseBlock)completionBlock
                                              onError:(MKNKErrorBlock)errorBlock
                                             withMask:(SVProgressHUDMaskType)mask;
+ (MKNetworkOperation*)imageAtURL:(NSString *)url size:(CGSize) size onCompletion:(MKNKImageBlock) imageFetchedBlock;
+ (MKNetworkOperation*)imageAtURL:(NSString *)url onCompletion:(MKNKImageBlock) imageFetchedBlock;
+ (MKNetworkOperation*)fileAtURL:(NSString *)url onCompletion:(MKNKImageBlock) imageFetchedBlock;


@end
