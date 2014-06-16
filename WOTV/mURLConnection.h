//
//  mURLConnection.h
//  WTV
//
//  Created by Gf_zgp on 14-4-9.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^mResponseBlock)(id responseData);
typedef void (^merrorBlock)(id responseCode,id error);


@interface mURLConnection : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSMutableData *responseData;
}
@property (nonatomic,strong)NSURL *HttpUrl;
@property (nonatomic,strong)NSString *HttpMethod;
@property (nonatomic,strong)NSMutableURLRequest *HttpRequest;
@property (nonatomic,strong)NSURLConnection *HttpConnection;
@property (nonatomic,strong)NSData *HttpBody;
@property (nonatomic,strong)NSString *ContentType;
@property (nonatomic,assign)NSInteger HttpStatusCode;
@property (nonatomic,strong)mResponseBlock responseBlock;
@property (nonatomic,strong)merrorBlock errorBlock;


/*    NSDictionary *parameters = nil;
 NSString *soapAction = @"GetDeviceCapability";
 NSString *upnpNameSpace = @"urn:schemas-upnp-org:service:ContentDirectory:1";*/

- (void)SoapActionWithUrl:(NSURL *)url HttpMethod:(NSString *)method Action:(NSString *)soapaction Parameters:(NSDictionary*)parameters NameSpace:(NSString *)upnpnamespace Complete:(mResponseBlock)complete onError:(merrorBlock)error;


- (void)CreateHttpRequestWithUrl:(NSURL *)url HttpMethod:(NSString *)method  Complete:(mResponseBlock)complete onError:(merrorBlock)error;

- (void)CreateHttpRequestWithUrl:(NSURL *)url HttpMethod:(NSString *)method HttpBody:(NSData *)body Complete:(mResponseBlock)complete onError:(merrorBlock)error;

- (void)Refresh;
- (void)Cancle;
@end
