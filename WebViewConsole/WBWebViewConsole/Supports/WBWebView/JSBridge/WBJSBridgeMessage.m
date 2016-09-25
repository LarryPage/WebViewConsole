//
//  WBJSBridgeMessage.m
//  WBWebViewConsole
//
//  Created by LiXiangCheng on 2/13/15.
//
//  Copyright (c) 2014-present, Weibo, Corp.
//  All rights reserved.
//
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "WBJSBridgeMessage.h"
#import "NSDictionary+Accessors.h"

@interface WBJSBridgeMessage ()

@property (nonatomic, copy) NSString * action;
@property (nonatomic, copy) NSDictionary * parameters;

@property (nonatomic, copy) NSString * callbackID;

@end

@implementation WBJSBridgeMessage

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [self init]) {
        self.action = [dict stringForKey:@"action"];
        self.parameters = [dict dictionaryForKey:@"params"];
        self.callbackID = [dict stringForKey:@"callback_id"];
    }
    return self;
}

@end
