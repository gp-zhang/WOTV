//
//  CircleControll.h
//  CircleControll
//
//  Created by 幸芳 on 13-12-16.
//
//

#import <UIKit/UIKit.h>
typedef enum{
    ControlStateDown,
    ControlStateContinue,
    ControlStateUp
}ControlState;
@protocol CircleControllDelegate;
@interface CircleControll : UIControl
{
    NSMutableArray *ShapLayers;
    CAShapeLayer *selectedLayer;
    CGColorRef LastColor;
    NSMutableArray *images;
    dispatch_source_t timer;
    NSDate *supdate;
    NSDate *subdate;
    id _delegate;
}
@property (nonatomic,assign)CGFloat radius;
@property (nonatomic,strong)id<CircleControllDelegate> delegate;

- (id)initWithRadius:(CGFloat )radiu Center:(CGPoint) center;

@end
@protocol CircleControllDelegate

- (void)ItemDidSelectedWithindex:(int )index State:(ControlState) state;
//- (void)ItemDidendSelectedWithindex:(int )index;

@end