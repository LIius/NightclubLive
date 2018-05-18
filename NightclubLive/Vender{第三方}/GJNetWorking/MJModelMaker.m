//
//  MJModelMaker.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/17.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "MJModelMaker.h"
#import "MJExtension.h"
#import "GCStatus.h"

@implementation MJModelMaker

+ (id)makeModelWithJSON:(NSDictionary *)json class:(Class)modelClass status:(__autoreleasing id *)status{
    NSLog(@"*********%@",json);
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        id model = [modelClass mj_objectWithKeyValues:json];
        return model;
    }
    else if ([json isKindOfClass:[NSArray class]]){
        NSArray *array = [modelClass mj_objectArrayWithKeyValuesArray:json];
        return array;
    }else if([json isKindOfClass:[NSString class]]){
        NSDictionary *dict = @{@"resultStr":json};
        id model = [modelClass mj_objectWithKeyValues:dict];
        return model;
    }
    
    return nil;
}

@end
