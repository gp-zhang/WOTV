//
//  mURLConnection.m
//  WTV
//
//  Created by Gf_zgp on 14-4-9.
//  Copyright (c) 2014年 Gf_zgp. All rights reserved.
//

#import "mURLConnection.h"
@implementation mURLConnection
@synthesize HttpConnection,HttpMethod,HttpRequest,HttpUrl,ContentType,HttpStatusCode,HttpBody;


- (void)SoapActionWithUrl:(NSURL *)url HttpMethod:(NSString *)method Action:(NSString *)soapaction Parameters:(NSDictionary*)parameters NameSpace:(NSString *)upnpnamespace Complete:(mResponseBlock)complete onError:(merrorBlock)error
{
    
    NSMutableString *body = [[NSMutableString alloc] init];
	[body appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
	[body appendString:@"<s:Envelope s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
	[body appendString:@"<s:Body>"];
	[body appendFormat:@"<u:%@ xmlns:u=\"%@\">", soapaction, upnpnamespace];
	for (id key in parameters) {
		[body appendFormat:@"<%@>%@</%@>", key, [parameters objectForKey:key], key];
	}
	[body appendFormat:@"</u:%@>", soapaction];
	[body appendFormat:@"</s:Body></s:Envelope>"];
    int	len = [body length];
    
    if (self.HttpRequest == nil) {
        
        self.HttpRequest = [[NSMutableURLRequest alloc]init];
        [HttpRequest setValue:@"txt/xml charset=utf-8" forHTTPHeaderField:@"content-type"];
        [HttpRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        [HttpRequest setValue:[NSString stringWithFormat:@"\"%@#%@\"", upnpnamespace, soapaction] forHTTPHeaderField:@"SOAPACTION"];
        [HttpRequest setValue:[NSString stringWithFormat:@"%d", len] forHTTPHeaderField:@"CONTENT-LENGTH"];
        [HttpRequest setValue:@"text/xml; charset=\"utf-8\"" forHTTPHeaderField:@"CONTENT-TYPE"];
        self.HttpUrl = url;
        self.HttpMethod = method;
    }
    
    [self.HttpRequest setURL:url];
    
    self.responseBlock = complete;
    self.errorBlock = error;
    [self.HttpRequest setHTTPMethod:HttpMethod];
    if (self.ContentType.length > 0) {
        [self.HttpRequest setValue:ContentType forHTTPHeaderField:@"content-type"];
    }
    if (self.HttpBody.length >0) {
        [self.HttpRequest setHTTPBody:HttpBody];
    }
    self.HttpConnection = [[NSURLConnection alloc]initWithRequest:HttpRequest delegate:self];
    [self.HttpConnection start];
}

- (void)CreateHttpRequestWithUrl:(NSURL *)url HttpMethod:(NSString *)method Complete:(mResponseBlock)complete onError:(merrorBlock)error;
{
    self.HttpUrl = url;
    self.HttpMethod = method;
    
    if (self.HttpRequest == nil) {
        self.HttpRequest = [[NSMutableURLRequest alloc]init];
    }
    [self.HttpRequest setURL:url];
    
    self.responseBlock = complete;
    self.errorBlock = error;
    [self.HttpRequest setHTTPMethod:HttpMethod];
    if (self.ContentType.length > 0) {
        [self.HttpRequest setValue:ContentType forHTTPHeaderField:@"content-type"];
    }
    if (self.HttpBody.length >0) {
        [self.HttpRequest setHTTPBody:HttpBody];
    }
    self.HttpConnection = [[NSURLConnection alloc]initWithRequest:HttpRequest delegate:self];
    [self.HttpConnection start];
}

- (void)CreateHttpRequestWithUrl:(NSURL *)url HttpMethod:(NSString *)method HttpBody:(NSData *)body Complete:(mResponseBlock)complete onError:(merrorBlock)error
{
    self.HttpRequest = [[NSMutableURLRequest alloc]init];
    [self.HttpRequest setURL:url];
    self.responseBlock = complete;
    self.errorBlock = error;
    [self.HttpRequest setHTTPMethod:method];
    if (self.ContentType.length > 0) {
        [self.HttpRequest setValue:ContentType forHTTPHeaderField:@"content-type"];
    }
    [HttpRequest setHTTPBody:body];
    self.HttpBody = body;
    
    self.HttpConnection = [[NSURLConnection alloc]initWithRequest:HttpRequest delegate:self];
    [self.HttpConnection start];
}

- (void)Refresh
{
    [self.HttpConnection start];
}

- (void)Cancle
{
    [self.HttpConnection cancel];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.HttpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (responseData == nil) {
        responseData = [[NSMutableData alloc]initWithCapacity:0];
    }
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *str = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"murlResponse \n-->%@",str);
    self.responseBlock(str);
    return;
    if (HttpStatusCode == 200) {
        self.responseBlock(str);
    }
    else
    {
        self.responseBlock(str);

        self.errorBlock([NSNumber numberWithInteger:self.HttpStatusCode],str);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];
    NSLog(@"murlstatuCode \n-->%d Error\n-->%@",self.HttpStatusCode,error);

    self.errorBlock([NSNumber numberWithInteger:self.HttpStatusCode],error);
}



@end
