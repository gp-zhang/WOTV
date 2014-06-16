//
//  NetEngine.m
//  csc
//
//  Created by hetao on 12-11-13.
//
//

#import "NetEngine.h"
#import "JSON.h"
#import "SDDataCache.h"
#import <MobileCoreServices/UTType.h>
@implementation NetEngine
static NetEngine *_instance=nil;
static NetEngine *_extrainstance=nil;
static NetEngine *_testinstance=nil;
+(id)Share
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        _instance = [[NetEngine alloc] initWithHostName:baseDomain apiPath:basePath customHeaderFields:nil];
        _instance.portNumber=[basePort integerValue];
        [_instance useCache];
    });
	return _instance;
}

+(id)ShareWithextra
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        _extrainstance = [[NetEngine alloc] initWithHostName:extraDomain apiPath:extraPath customHeaderFields:nil];
        _extrainstance.portNumber=[extraPort integerValue];
        [_extrainstance useCache];
    });
	return _extrainstance;
}

+(id)ShareWithTest
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        _testinstance = [[NetEngine alloc] initWithHostName:testDomain portNumber:[testPort integerValue]apiPath:testPath customHeaderFields:nil];
        [_testinstance useCache];
    });
	return _testinstance;
}

+(void)cancel
{
    [SVProgressHUD dismiss];
    [[NetEngine Share] cancelAllOperations];
}

#pragma mark - fileAction
+(MKNetworkOperation*) createUploadImageAction:(NSString*)url
                                      ImageKey:(NSString*)key
                                         Image:(UIImage*)image
                                  onCompletion:(CurrencyResponseBlock)completionBlock
                                       onError:(MKNKErrorBlock)errorBlock
                                      withMask:(SVProgressHUDMaskType)mask
{
    return [[NetEngine Share] createUploadImageAction:url ImageKey:key Image:image onCompletion:completionBlock onError:errorBlock withMask:mask];
}

+(MKNetworkOperation*) createUploadMutableImageAction:(NSString*)url
                                             ImageKey:(NSString*)key
                                           ImageArray:(NSMutableArray*)imageArray
                                         onCompletion:(CurrencyResponseBlock)completionBlock
                                              onError:(MKNKErrorBlock)errorBlock
                                             withMask:(SVProgressHUDMaskType)mask
{
    return [[NetEngine Share] createUploadMutableImageAction:url ImageKey:key ImageArray:imageArray onCompletion:completionBlock onError:errorBlock withMask:mask];
}

-(MKNetworkOperation*) createUploadImageAction:(NSString*)url
                                      ImageKey:(NSString*)key
                                         Image:(UIImage*)image
                                  onCompletion:(CurrencyResponseBlock)completionBlock
                                       onError:(MKNKErrorBlock)errorBlock
                                      withMask:(SVProgressHUDMaskType)mask
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    MKNetworkOperation *op = [self operationWithPath:url params:nil httpMethod:@"POST"];
    if (image) {
        UIImage *img=[self imageWithImage:image scaledToSize:CGSizeMake(320, 320)];
        
        NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
        [op addData:imageData forKey:key mimeType:@"image/jpeg" fileName:@"imagename.jpg"];
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSString *responseStr = completedOperation.responseString;
        NSLog(@" createUploadImageAction responseStr:%@",responseStr);
        if (!responseStr) {
            [SVProgressHUD dismissWithError:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
            if ([[responseStr JSONValue] isEqual:[NSNull null]]) {
                completionBlock(responseStr, NO);
            }else{
                completionBlock([responseStr JSONValue],NO);
            }

        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@",url);
        errorBlock?errorBlock(nil):nil;
    }];
    [self enqueueOperation:op forceReload:YES];
    return op;
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+(MKNetworkOperation*) createUploadImageAction:(NSString*)url
                                      ImageKey:(NSString*)key
                                         Array:(NSArray*)array
                                  onCompletion:(CurrencyResponseBlock)completionBlock
                                       onError:(MKNKErrorBlock)errorBlock
                                      withMask:(SVProgressHUDMaskType)mask
{
    return [[NetEngine Share] createUploadImageAction:url ImageKey:key Array:array onCompletion:completionBlock onError:errorBlock withMask:mask];
}

-(MKNetworkOperation*) createUploadImageAction:(NSString*)url
                                      ImageKey:(NSString*)key
                                         Array:(NSArray*)array
                                  onCompletion:(CurrencyResponseBlock)completionBlock
                                       onError:(MKNKErrorBlock)errorBlock
                                      withMask:(SVProgressHUDMaskType)mask
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MKNetworkOperation *op = [self operationWithPath:url params:nil httpMethod:@"POST"];
    int i=0;
    if (array) {
//        UIImage *IMAGE=[array objectAtIndex:i-1];
//
//        NSData *imageData = UIImageJPEGRepresentation(IMAGE, 0.8);
//        [op addData:imageData forKey:key mimeType:@"image/jpeg" fileName:imagename];
        i++;
    }

    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSData *responseData = completedOperation.responseData;
        if (!responseData) {
            [SVProgressHUD dismissWithError:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
            completionBlock(responseData,NO);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@",url);
        errorBlock?errorBlock(nil):nil;
    }];
    [self enqueueOperation:op forceReload:YES];
    return op;
}

-(MKNetworkOperation*) createUploadMutableImageAction:(NSString*)url
                                      ImageKey:(NSString*)key
                                         ImageArray:(NSMutableArray*)imageArray
                                  onCompletion:(CurrencyResponseBlock)completionBlock
                                       onError:(MKNKErrorBlock)errorBlock
                                      withMask:(SVProgressHUDMaskType)mask
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"uploadImage %@", url);
    MKNetworkOperation *op = [self operationWithPath:url params:nil httpMethod:@"POST"];
    if ([imageArray count] > 0) {
        for (UIImage *image in imageArray) {
        
            [op addData: UIImageJPEGRepresentation(image, 0.5)  forKey:key mimeType:@"image/jpeg" fileName:@"imgname.png"];
        }
    }
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        NSData *responseData = completedOperation.responseData;
//        if (!responseData) {
//            [SVProgressHUD dismissWithError:@"数据有误"];
//            errorBlock?errorBlock(nil):nil;
//        }else{
//            [SVProgressHUD dismiss];
//            completionBlock(responseData,NO);
//        }
        NSString *responseString = completedOperation.responseString;
        if([completedOperation isCachedResponse]) {
            [SVProgressHUD dismiss];
            DLog(@"Data from cache");
        }
        else {
            [SVProgressHUD dismiss];
            DLog(@"Data from server:%@",responseString);
        }
        if (!responseString) {
            [SVProgressHUD dismissWithError:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
            if ([[responseString JSONValue] isEqual:[NSNull null]]) {
                completionBlock(responseString, NO);
            }else{
                completionBlock([responseString JSONValue],NO);
            }

        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@",url);
        errorBlock?errorBlock(nil):nil;
    }];
    [self enqueueOperation:op forceReload:YES];
    return op;
}




+(MKNetworkOperation*) createFileAction:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                               withMask:(SVProgressHUDMaskType)mask
{
    return [[NetEngine Share] createFileAction:url onCompletion:completionBlock onError:errorBlock withMask:mask];
}


+(MKNetworkOperation*) createUploadFileWithUrl:(NSString*) url
                                      filePath:(NSString *)path
                                  onCompletion:(CurrencyResponseBlock) completionBlock
                                       onError:(MKNKErrorBlock) errorBlock
                                      withMask:(SVProgressHUDMaskType)mask
{
    
    NSURL *tempurl = [NSURL URLWithString:url];
    NetEngine  *engine = [[NetEngine alloc] initWithHostName:tempurl.host apiPath:tempurl.path customHeaderFields:nil];
    engine.portNumber = tempurl.port.intValue;
    [engine useCache];
    
    return [engine createUploadFileWithUrl:url filePath:path onCompletion:completionBlock onError:errorBlock withMask:mask];
}


-(MKNetworkOperation*) createFileAction:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                               withMask:(SVProgressHUDMaskType)mask
{
    DLog(@"%@",url);
    if ([[Utility Share] offline]) {
            [SVProgressHUD dismiss];
            errorBlock?errorBlock(nil):nil;
            return nil;
    }
    if(mask!=SVProgressHUDMaskTypeNil)
        [SVProgressHUD showWithMaskType:mask];
    
    MKNetworkOperation *op = [self operationWithPath:@"" params:nil httpMethod:@"GET"];
//    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {return msg;}forType:@"text/xml"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData *responseData = completedOperation.responseData;
        if (!responseData) {
            [SVProgressHUD dismissWithError:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
            completionBlock(responseData,NO);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@",url);
        errorBlock?errorBlock(nil):nil;
    }];
    
    [self enqueueOperation:op forceReload:YES];
    return op;
}


-(MKNetworkOperation*) createUploadFileWithUrl:(NSString*) url
                                      filePath:(NSString *)path
                                  onCompletion:(CurrencyResponseBlock) completionBlock
                                       onError:(MKNKErrorBlock) errorBlock
                                      withMask:(SVProgressHUDMaskType)mask
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"uploadImage %@", url);
    MKNetworkOperation *op = [self operationWithPath:url params:nil httpMethod:@"POST"];
//            [op addData: UIImageJPEGRepresentation(image, 0.5)  forKey:key mimeType:@"image/jpeg" fileName:@"imgname.png"];
    [op addFile:path forKey:@"filekey"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        //        NSData *responseData = completedOperation.responseData;
        //        if (!responseData) {
        //            [SVProgressHUD dismissWithError:@"数据有误"];
        //            errorBlock?errorBlock(nil):nil;
        //        }else{
        //            [SVProgressHUD dismiss];
        //            completionBlock(responseData,NO);
        //        }
        NSString *responseString = completedOperation.responseString;
        if([completedOperation isCachedResponse]) {
            [SVProgressHUD dismiss];
            DLog(@"Data from cache");
        }
        else {
            [SVProgressHUD dismiss];
            DLog(@"Data from server:%@",responseString);
        }
        if (!responseString) {
            [SVProgressHUD dismissWithError:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
            if ([[responseString JSONValue] isEqual:[NSNull null]]) {
                completionBlock(responseString, NO);
            }else{
                completionBlock([responseString JSONValue],NO);
            }
            
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@",url);
        errorBlock?errorBlock(nil):nil;
    }];
    [self enqueueOperation:op forceReload:YES];
    return op;
}

#pragma mark - httpAction

+(MKNetworkOperation*) createHttpAction:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock{
    return [[NetEngine Share] createHttpAction:url onCompletion:completionBlock onError:errorBlock useCache:YES withMask:SVProgressHUDMaskTypeClear];
}

+(MKNetworkOperation*) createHttpAction:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                               useCache:(BOOL)usecache
                               withMask:(SVProgressHUDMaskType)mask{
    return [[NetEngine Share] createHttpAction:url onCompletion:completionBlock onError:errorBlock useCache:usecache withMask:mask];
}

+(MKNetworkOperation*) createHttpAction:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                               useCache:(BOOL)usecache
                               withMask:(SVProgressHUDMaskType)mask
                             httpMethod:(NSString*)method
{
    return [[NetEngine Share] createHttpAction:url onCompletion:completionBlock onError:errorBlock useCache:usecache withMask:mask httpMethod:method];

}

+(MKNetworkOperation*) createHttpActionWithextra:(NSString*) url
                                    onCompletion:(CurrencyResponseBlock) completionBlock
                                         onError:(MKNKErrorBlock) errorBlock
                                        useCache:(BOOL)usecache
                                        withMask:(SVProgressHUDMaskType)mask
{
    return [[NetEngine ShareWithextra] createHttpActionextra:url onCompletion:completionBlock onError:errorBlock useCache:usecache withMask:mask];
}

+(MKNetworkOperation*)  createHttpActionWithTest:(NSString*) url
                                          params:(NSDictionary*) body
                                   onCompletion:(CurrencyResponseBlock) completionBlock
                                        onError:(MKNKErrorBlock) errorBlock
                                       useCache:(BOOL)usecache
                                       withMask:(SVProgressHUDMaskType)mask
                                     httpMethod:(NSString*)method
{
    return [[NetEngine ShareWithTest] createHttpActionTest:url onCompletion:completionBlock onError:errorBlock params:body useCache:usecache withMask:mask httpMethod:method ];
}


+(MKNetworkOperation*)  createHttpActionWithHostName:(NSString*) domain
                                                Path:(NSString*) path
                                          PortNumber:(NSString*) portNumber
                                              params:(NSDictionary*) body
                                        onCompletion:(CustomResponseBlock) completionBlock
                                             onError:(MKNKErrorBlock) errorBlock
                                            useCache:(BOOL)usecache
                                            withMask:(SVProgressHUDMaskType)mask
                                          httpMethod:(NSString*)method
{
   NetEngine  *engine = [[NetEngine alloc] initWithHostName:domain apiPath:nil customHeaderFields:nil];
    if(portNumber.length >0)
    {
     engine.portNumber=[portNumber integerValue];
    }
    [engine useCache];
    
   return  [engine createHttpActionCustom:path onCompletion:completionBlock onError:errorBlock params:body useCache:usecache withMask:mask httpMethod:method];
}

+(MKNetworkOperation*)  createHttpActionWithUrlString:(NSString*) urlstring
                                               params:(NSDictionary*) body
                                         onCompletion:(CustomResponseBlock) completionBlock
                                              onError:(MKNKErrorBlock) errorBlock
                                             useCache:(BOOL)usecache
                                             withMask:(SVProgressHUDMaskType)mask
                                           httpMethod:(NSString*)method
{
    NetEngine  *engine = [[NetEngine alloc] init];
    [engine useCache];
    return  [engine createHttpActionUrlString:urlstring onCompletion:completionBlock onError:errorBlock params:body useCache:usecache withMask:mask httpMethod:method];
    
    

}

-(MKNetworkOperation*) createHttpActionUrlString:(NSString*) url
                                 onCompletion:(CustomResponseBlock) completionBlock
                                      onError:(MKNKErrorBlock) errorBlock
                                       params:(NSDictionary*) body
                                     useCache:(BOOL)usecache
                                     withMask:(SVProgressHUDMaskType)mask
                                   httpMethod:(NSString*)method;

{
    //网络状况判断
    Reachability *reachability = [Reachability reachabilityWithHostname:baseDomain];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"无网络连接" duration:1];
        return 0;
    }
    
    
    NSString *storeKey=[url md5];
    
    //    如果启用缓存 或者 离线的话 从缓存读数据
    if (usecache||[[Utility Share] offline]) {
        if (storeKey) {
            id storedata=[[SDDataCache sharedDataCache] dataFromKey:storeKey fromDisk:YES];
            if (storedata) {
                NSMutableString *datastring=[[NSMutableString alloc] initWithData:storedata encoding:NSUTF8StringEncoding];
                
                if ([[datastring JSONValue] isEqual:[NSNull null]]) {
                    [SVProgressHUD dismiss];
                    completionBlock(datastring,YES,nil);
                }else{
                    [SVProgressHUD dismiss];
                    completionBlock([datastring JSONValue],YES,nil);
                }
            }
        }
        if ([[Utility Share] offline]) {
            [SVProgressHUD dismiss];
            errorBlock?errorBlock(nil):nil;
            return nil;
        }
    }
    if(mask!=SVProgressHUDMaskTypeNil)
        [SVProgressHUD showWithMaskType:mask];
    //    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MKNetworkOperation *op = [self operationWithURLString:url params:body httpMethod:method];
    DLog(@"url %@",op.url);
    //[op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {return msg;}forType:@"text/xml"];
    //    [op onDownloadProgressChanged:^(double progress) {
    //        DLog(@"%.2f",progress);
    //    }];
    
    //http://119.57.82.122:1000/index.php?s=/Beelte/login/email/335758423@sina.com/password/111111
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *responseString = completedOperation.responseString;
        DLog(@"url %@",[completedOperation readonlyResponse].URL);
        if([completedOperation isCachedResponse]) {
            [SVProgressHUD dismiss];
            DLog(@"Data from cache");
        }
        else {
            [SVProgressHUD dismiss];
            DLog(@"Data from server:%@",responseString);
        }
        if (!responseString) {
            [SVProgressHUD dismissWithError:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
            if ([[responseString JSONValue] isEqual:[NSNull null]]) {
                completionBlock(responseString, NO,completedOperation.readonlyResponse.URL);
            }else{
                completionBlock([responseString JSONValue],NO,completedOperation.readonlyResponse.URL);
            }
            if (usecache && storeKey) {
                if (!responseString){
                    [[SDDataCache sharedDataCache] removeDataForKey:storeKey];
                }else{
                    [[SDDataCache sharedDataCache] storeData:[responseString dataUsingEncoding:NSUTF8StringEncoding] forKey:storeKey toDisk:YES];
                }
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@\n",url);
        errorBlock?errorBlock(error):nil;
    }];
    [self enqueueOperation:op forceReload:YES];
    return op;
}


-(MKNetworkOperation*) createHttpActionCustom:(NSString*) url
                               onCompletion:(CustomResponseBlock) completionBlock
                                    onError:(MKNKErrorBlock) errorBlock
                                     params:(NSDictionary*) body
                                   useCache:(BOOL)usecache
                                   withMask:(SVProgressHUDMaskType)mask
                                 httpMethod:(NSString*)method;

{
    //网络状况判断
    Reachability *reachability = [Reachability reachabilityWithHostname:baseDomain];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"无网络连接" duration:1];
        return 0;
    }
    
    
    NSString *storeKey=[url md5];
    
    //    如果启用缓存 或者 离线的话 从缓存读数据
    if (usecache||[[Utility Share] offline]) {
        if (storeKey) {
            id storedata=[[SDDataCache sharedDataCache] dataFromKey:storeKey fromDisk:YES];
            if (storedata) {
                NSMutableString *datastring=[[NSMutableString alloc] initWithData:storedata encoding:NSUTF8StringEncoding];
                
                if ([[datastring JSONValue] isEqual:[NSNull null]]) {
                    [SVProgressHUD dismiss];
                    completionBlock(datastring,YES,nil);
                }else{
                    [SVProgressHUD dismiss];
                    completionBlock([datastring JSONValue],YES,nil);
                }
            }
        }
        if ([[Utility Share] offline]) {
            [SVProgressHUD dismiss];
            errorBlock?errorBlock(nil):nil;
            return nil;
        }
    }
    if(mask!=SVProgressHUDMaskTypeNil)
        [SVProgressHUD showWithMaskType:mask];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    MKNetworkOperation *op = [self operationWithPath:url params:body httpMethod:method];
    DLog(@"url %@",op.url);
    //[op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {return msg;}forType:@"text/xml"];
    //    [op onDownloadProgressChanged:^(double progress) {
    //        DLog(@"%.2f",progress);
    //    }];
    
    //http://119.57.82.122:1000/index.php?s=/Beelte/login/email/335758423@sina.com/password/111111
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *responseString = completedOperation.responseString;
        DLog(@"url %@",[completedOperation readonlyResponse].URL);
        if([completedOperation isCachedResponse]) {
            [SVProgressHUD dismiss];
            DLog(@"Data from cache");
        }
        else {
            [SVProgressHUD dismiss];
            DLog(@"Data from server:%@",responseString);
        }
        if (!responseString) {
            [SVProgressHUD dismissWithError:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
            if ([[responseString JSONValue] isEqual:[NSNull null]]) {
                completionBlock(responseString, NO,completedOperation.readonlyResponse.URL);
            }else{
                completionBlock([responseString JSONValue],NO,completedOperation.readonlyResponse.URL);
            }
            if (usecache && storeKey) {
                if (!responseString){
                    [[SDDataCache sharedDataCache] removeDataForKey:storeKey];
                }else{
                    [[SDDataCache sharedDataCache] storeData:[responseString dataUsingEncoding:NSUTF8StringEncoding] forKey:storeKey toDisk:YES];
                }
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@\n",url);
        errorBlock?errorBlock(error):nil;
    }];
    [self enqueueOperation:op forceReload:YES];
    return op;
}


-(MKNetworkOperation*) createHttpActionextra:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                               useCache:(BOOL)usecache
                               withMask:(SVProgressHUDMaskType)mask
{
    //网络状况判断
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"无网络连接" duration:1];
        return 0;
    }
    
    
    NSString *storeKey=[url md5];
    
    //    如果启用缓存 或者 离线的话 从缓存读数据
    if (usecache||[[Utility Share] offline]) {
        if (storeKey) {
            id storedata=[[SDDataCache sharedDataCache] dataFromKey:storeKey fromDisk:YES];
            if (storedata) {
                NSMutableString *datastring=[[NSMutableString alloc] initWithData:storedata encoding:NSUTF8StringEncoding];
                
                if ([[datastring JSONValue] isEqual:[NSNull null]]) {
                    [SVProgressHUD dismiss];
                    completionBlock(datastring,YES);
                }else{
                    [SVProgressHUD dismiss];
                    completionBlock([datastring JSONValue],YES);
                }
            }
        }
        if ([[Utility Share] offline]) {
            [SVProgressHUD dismiss];
            errorBlock?errorBlock(nil):nil;
            return nil;
        }
    }
    if(mask!=SVProgressHUDMaskTypeNil)
        [SVProgressHUD showWithMaskType:mask];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"url:%@",url);
    MKNetworkOperation *op = [self operationWithPath:url params:nil httpMethod:@"POST"];
    
    //[op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {return msg;}forType:@"text/xml"];
    //    [op onDownloadProgressChanged:^(double progress) {
    //        DLog(@"%.2f",progress);
    //    }];
    
    //http://119.57.82.122:1000/index.php?s=/Beelte/login/email/335758423@sina.com/password/111111
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        DLog(@"%@",completedOperation.readonlyRequest.URL);
        NSString *responseString = completedOperation.responseString;
        if([completedOperation isCachedResponse]) {
            [SVProgressHUD dismiss];
            DLog(@"Data from cache");
        }
        else {
            [SVProgressHUD dismiss];
            DLog(@"Data from server:%@",responseString);
        }
        if (!responseString) {
            [SVProgressHUD dismissWithError:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
            if ([[responseString JSONValue] isEqual:[NSNull null]]) {
                completionBlock(responseString, NO);
            }else{
                completionBlock([responseString JSONValue],NO);
            }
            if (usecache && storeKey) {
                if (!responseString){
                    [[SDDataCache sharedDataCache] removeDataForKey:storeKey];
                }else{
                    [[SDDataCache sharedDataCache] storeData:[responseString dataUsingEncoding:NSUTF8StringEncoding] forKey:storeKey toDisk:YES];
                }
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@\n",url);
        errorBlock?errorBlock(error):nil;
    }];
    [self enqueueOperation:op forceReload:YES];
    return op;
}

-(MKNetworkOperation*) createHttpAction:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                               useCache:(BOOL)usecache
                               withMask:(SVProgressHUDMaskType)mask
{
    //网络状况判断
    Reachability *reachability = [Reachability reachabilityWithHostname:baseDomain];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"无网络连接" duration:1];
        return 0;
    }
    
    
    NSString *storeKey=[url md5];
    
    //    如果启用缓存 或者 离线的话 从缓存读数据
    if (usecache||[[Utility Share] offline]) {
        if (storeKey) {
            id storedata=[[SDDataCache sharedDataCache] dataFromKey:storeKey fromDisk:YES];
            if (storedata) {
                NSMutableString *datastring=[[NSMutableString alloc] initWithData:storedata encoding:NSUTF8StringEncoding];
                
                if ([[datastring JSONValue] isEqual:[NSNull null]]) {
                    [SVProgressHUD dismiss];
                    completionBlock(datastring,YES);
                }else{
                    [SVProgressHUD dismiss];
                    completionBlock([datastring JSONValue],YES);
                }
            }
        }
        if ([[Utility Share] offline]) {
            [SVProgressHUD dismiss];
            errorBlock?errorBlock(nil):nil;
            return nil;
        }
    }
    if(mask!=SVProgressHUDMaskTypeNil)
        [SVProgressHUD showWithMaskType:mask];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"url:%@",url);
    MKNetworkOperation *op = [self operationWithPath:url params:nil httpMethod:@"POST"];
    
    //[op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {return msg;}forType:@"text/xml"];
    //    [op onDownloadProgressChanged:^(double progress) {
    //        DLog(@"%.2f",progress);
    //    }];
    
    //http://119.57.82.122:1000/index.php?s=/Beelte/login/email/335758423@sina.com/password/111111
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        DLog(@"%@",completedOperation.readonlyRequest.URL);
        NSString *responseString = completedOperation.responseString;
        if([completedOperation isCachedResponse]) {
            [SVProgressHUD dismiss];
            DLog(@"Data from cache");
        }
        else {
            [SVProgressHUD dismiss];
            DLog(@"Data from server:%@",responseString);
        }
        if (!responseString) {
            [SVProgressHUD dismissWithError:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
            if ([[responseString JSONValue] isEqual:[NSNull null]]) {
                completionBlock(responseString, NO);
            }else{
                completionBlock([responseString JSONValue],NO);
            }
            if (usecache && storeKey) {
                if (!responseString){
                    [[SDDataCache sharedDataCache] removeDataForKey:storeKey];
                }else{
                    [[SDDataCache sharedDataCache] storeData:[responseString dataUsingEncoding:NSUTF8StringEncoding] forKey:storeKey toDisk:YES];
                }
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@\n",url);
        errorBlock?errorBlock(error):nil;
    }];
    [self enqueueOperation:op forceReload:YES];
    return op;
}


-(MKNetworkOperation*) createHttpAction:(NSString*) url
                       onCompletion:(CurrencyResponseBlock) completionBlock
                            onError:(MKNKErrorBlock) errorBlock
                           useCache:(BOOL)usecache
                           withMask:(SVProgressHUDMaskType)mask
                         httpMethod:(NSString*)method

{
    //网络状况判断
    Reachability *reachability = [Reachability reachabilityWithHostname:baseDomain];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"无网络连接" duration:1];
        return 0;
    }
    

    NSString *storeKey=[url md5];
    
//    如果启用缓存 或者 离线的话 从缓存读数据
    if (usecache||[[Utility Share] offline]) {
        if (storeKey) {
            id storedata=[[SDDataCache sharedDataCache] dataFromKey:storeKey fromDisk:YES];
            if (storedata) {
                NSMutableString *datastring=[[NSMutableString alloc] initWithData:storedata encoding:NSUTF8StringEncoding];

                if ([[datastring JSONValue] isEqual:[NSNull null]]) {
                    [SVProgressHUD dismiss];
                    completionBlock(datastring,YES);
                }else{
                    [SVProgressHUD dismiss];
                    completionBlock([datastring JSONValue],YES);
                }
            }
        }
        if ([[Utility Share] offline]) {
            [SVProgressHUD dismiss];
            errorBlock?errorBlock(nil):nil;
            return nil;
        }
    }
    if(mask!=SVProgressHUDMaskTypeNil)
        [SVProgressHUD showWithMaskType:mask];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MKNetworkOperation *op = [self operationWithPath:url params:nil httpMethod:method];
    DLog(@"url %@",op.url);
    //[op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {return msg;}forType:@"text/xml"];
//    [op onDownloadProgressChanged:^(double progress) {
//        DLog(@"%.2f",progress);
//    }];
    
    //http://119.57.82.122:1000/index.php?s=/Beelte/login/email/335758423@sina.com/password/111111
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        DLog(@"url %@",completedOperation.readonlyRequest.URL);
        NSString *responseString = completedOperation.responseString;
        if([completedOperation isCachedResponse]) {
            [SVProgressHUD dismiss];
            DLog(@"Data from cache");
        }
        else {
            [SVProgressHUD dismiss];
            DLog(@"Data from server:%@",responseString);
        }
        if (!responseString) {
            [SVProgressHUD dismissWithError:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
             if ([[responseString JSONValue] isEqual:[NSNull null]]) {
                completionBlock(responseString, NO);
            }else{
                completionBlock([responseString JSONValue],NO);
            }
            if (usecache && storeKey) {
                if (!responseString){
                    [[SDDataCache sharedDataCache] removeDataForKey:storeKey];
                }else{
                    [[SDDataCache sharedDataCache] storeData:[responseString dataUsingEncoding:NSUTF8StringEncoding] forKey:storeKey toDisk:YES];
                }
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@\n",url);
        errorBlock?errorBlock(error):nil;
    }];
    [self enqueueOperation:op forceReload:YES];
    return op;
}


-(MKNetworkOperation*) createHttpActionTest:(NSString*) url
                           onCompletion:(CurrencyResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock
                                     params:(NSDictionary*) body
                               useCache:(BOOL)usecache
                               withMask:(SVProgressHUDMaskType)mask
                                 httpMethod:(NSString*)method;

{
    //网络状况判断
    Reachability *reachability = [Reachability reachabilityWithHostname:baseDomain];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"无网络连接" duration:1];
        return 0;
    }
    
    
    NSString *storeKey=[url md5];
    
    //    如果启用缓存 或者 离线的话 从缓存读数据
    if (usecache||[[Utility Share] offline]) {
        if (storeKey) {
            id storedata=[[SDDataCache sharedDataCache] dataFromKey:storeKey fromDisk:YES];
            if (storedata) {
                NSMutableString *datastring=[[NSMutableString alloc] initWithData:storedata encoding:NSUTF8StringEncoding];
                
                if ([[datastring JSONValue] isEqual:[NSNull null]]) {
                    [SVProgressHUD dismiss];
                    completionBlock(datastring,YES);
                }else{
                    [SVProgressHUD dismiss];
                    completionBlock([datastring JSONValue],YES);
                }
            }
        }
        if ([[Utility Share] offline]) {
            [SVProgressHUD dismiss];
            errorBlock?errorBlock(nil):nil;
            return nil;
        }
    }
    if(mask!=SVProgressHUDMaskTypeNil)
        [SVProgressHUD showWithMaskType:mask];
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MKNetworkOperation *op = [self operationWithPath:url params:body httpMethod:method];
    DLog(@"url %@",op.url);
    //[op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {return msg;}forType:@"text/xml"];
    //    [op onDownloadProgressChanged:^(double progress) {
    //        DLog(@"%.2f",progress);
    //    }];
    
    //http://119.57.82.122:1000/index.php?s=/Beelte/login/email/335758423@sina.com/password/111111
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        DLog(@"url %@",completedOperation.readonlyRequest.URL);
        NSString *responseString = completedOperation.responseString;
        if([completedOperation isCachedResponse]) {
            [SVProgressHUD dismiss];
            DLog(@"Data from cache");
        }
        else {
            [SVProgressHUD dismiss];
            DLog(@"Data from server:%@",responseString);
        }
        if (!responseString) {
            [SVProgressHUD dismissWithError:@"数据有误"];
            errorBlock?errorBlock(nil):nil;
        }else{
            [SVProgressHUD dismiss];
            if ([[responseString JSONValue] isEqual:[NSNull null]]) {
                completionBlock(responseString, NO);
            }else{
                completionBlock([responseString JSONValue],NO);
            }
            if (usecache && storeKey) {
                if (!responseString){
                    [[SDDataCache sharedDataCache] removeDataForKey:storeKey];
                }else{
                    [[SDDataCache sharedDataCache] storeData:[responseString dataUsingEncoding:NSUTF8StringEncoding] forKey:storeKey toDisk:YES];
                }
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"errorHandler网络超时:%@\n",url);
        errorBlock?errorBlock(error):nil;
    }];
    [self enqueueOperation:op forceReload:YES];
    return op;
}

#pragma mark - soapAction

+ (MKNetworkOperation*)imageAtURL:(NSString *)url size:(CGSize) size onCompletion:(MKNKImageBlock) imageFetchedBlock
{
    if (url) {
        //[NSURL URLWithString:@"http://www.baidu.com/img/baidu_sylogo1.gif"]
        //[NSString stringWithFormat:@"http://%@/%@",basePicPath,url]
        //NSString *picPath = [NSString stringWithFormat:@"http://%@%@",basePicPath,url];
        return [[NetEngine Share] imageAtURL:[NSURL URLWithString:url] size:size onCompletion:imageFetchedBlock];
    }
    return nil;
}

+ (MKNetworkOperation*)imageAtURL:(NSString *)url onCompletion:(MKNKImageBlock) imageFetchedBlock
{
    if (url) {
        //[NSURL URLWithString:@"http://www.baidu.com/img/baidu_sylogo1.gif"]
        //[NSString stringWithFormat:@"http://%@/%@",basePicPath,url]
        //NSString *picPath = [NSString stringWithFormat:@"http://%@%@",basePicPath,url];
        url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [[NetEngine Share] imageAtURL:[NSURL URLWithString:url] onCompletion:imageFetchedBlock];
    }
    return nil;
}

+ (MKNetworkOperation*)fileAtURL:(NSString *)url onCompletion:(MKNKImageBlock) imageFetchedBlock
{
    if (url) {
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [[NetEngine Share] fileAtURL:[NSURL URLWithString:url] onCompletion:imageFetchedBlock ];
    }
    return nil;
}

- (MKNetworkOperation*)fileAtURL:(NSURL *)url completionHandler:(MKNKImageBlock) imageFetchedBlock errorHandler:(MKNKResponseErrorBlock) errorBlock {
    
#ifdef DEBUG
    // I could enable caching here, but that hits performance and inturn affects table view scrolling
    // if imageAtURL is called for loading thumbnails.
#endif
        
        if (url == nil) {
            return nil;
        }
    
    MKNetworkOperation *op = [self operationWithURLString:[url absoluteString]];
    op.shouldCacheResponseEvenIfProtocolIsHTTPS = YES;
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        if (imageFetchedBlock)
            imageFetchedBlock([completedOperation responseImage],
                              url,
                              [completedOperation isCachedResponse]);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (errorBlock)
            errorBlock(completedOperation, error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

//-(NSString*) cacheDirectoryName {
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = paths[0];
//    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"cscImages"];
//    return cacheDirectoryName;
//}
@end
