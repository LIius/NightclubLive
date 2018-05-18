//
//  NCAnnotation.h
//  NightclubLive
//
//  Created by RDP on 2017/3/22.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NCAnnotation : NSObject<MKAnnotation>
/** 定位地点 */
@property (nonatomic) CLLocationCoordinate2D coordinate;
/** 标题 */
@property (nonatomic, copy, nullable) NSString *title;
/** 附加文本 */
@property (nonatomic, copy, nullable) NSString *subtitle;

@end
