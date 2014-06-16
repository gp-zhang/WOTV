//
//  Utility.h
//  CloudTravel
//
//  Created by hetao on 10-12-5.
//  Copyright 2010 oulin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define showProgressIndicator_width 250

@interface Utility : NSObject

//badgeViewS
@property (nonatomic,retain) NSMutableDictionary *badgeViewDict;

//启用缓存
@property (nonatomic,assign) BOOL offline;

+(id)Share;
-(NSString *)getAddressBy:(NSString *)description;
@end
