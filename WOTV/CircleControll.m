//
//  CircleControll.m
//  CircleControll
//
//  Created by 幸芳 on 13-12-16.
//
//

#import "CircleControll.h"
#import <AudioToolbox/AudioToolbox.h>
#define PI 3.14159265358979323846


static inline float radians(double degrees) {
    return degrees * PI / 180;
}

//static CGPathRef CGPathCreateArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle)
//{
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, center.x, center.y);
//
//    CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
//    CGPathCloseSubpath(path);
//
//    return path;
//}
@implementation CircleControll
@synthesize radius,delegate=_delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}

- (id)initWithRadius:(CGFloat )radiu Center:(CGPoint) center
{
    self = [super init];
    if (self) {
        self.center=center;
        self.bounds=CGRectMake(0, 0, radiu*2, radiu*2);
        radius= radiu;
        self.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
        //        self.clipsToBounds=NO;
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    if (ShapLayers == nil) {
        ShapLayers = [[NSMutableArray alloc]initWithCapacity:0];
    }
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:self.radius];
    
    
    
    //    UIColor* fillColor = [UIColor redColor];
    //
    //    //定义一个渐变颜色，实现上面那个填充色的渐变
    //    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    //    NSArray* innerColorColors = [NSArray arrayWithObjects:
    //                                 (id)[UIColor whiteColor].CGColor,
    //                                 (id)fillColor.CGColor,
    //                                 (id)[UIColor blackColor].CGColor,nil];
    //    CGFloat innerColorLocations[] = {0,0.3,1};
    //    CGGradientRef innerColor =CGGradientCreateWithColors(colorSpace, (CFArrayRef)innerColorColors, innerColorLocations);
    //    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    CGContextClearRect(ctx, rect);
    //    CGContextSetAllowsAntialiasing(ctx, YES);
    //    CGContextSetShouldAntialias(ctx, YES);
    //    glEnable(2);
    //    glEnable(2);
    
    
    [ShapLayers removeAllObjects];
    for (CALayer *sublayer in self.layer.sublayers) {
        [sublayer removeFromSuperlayer];
    }
    
    
    CGPoint center = CGPointMake(self.radius, self.radius);
    float angle_start1 = radians(45);
    float angle_end1 = radians(135);
    //        drawArc(ctx, center, angle_start1, angle_end1, [UIColor yellowColor],self.radius);
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:center];
    [path1 addArcWithCenter:center radius:self.radius startAngle:angle_start1 endAngle:angle_end1 clockwise:YES];
    CAShapeLayer *shaplayer1 = [CAShapeLayer layer];
    [shaplayer1 setPath:path1.CGPath];
    [shaplayer1 setFillColor:[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1].CGColor];
    [shaplayer1 setFillColor:[UIColor clearColor].CGColor];
    
    [shaplayer1 setZPosition:center.x];
    [self.layer addSublayer:shaplayer1];
    [ShapLayers insertObject:shaplayer1 atIndex:0];
    
    
    float angle_start2 = angle_end1;
    float angle_end2 = radians(225);
    
    //    drawArc(ctx, center, angle_start2, angle_end2, [UIColor greenColor],self.radius);
    
    UIBezierPath * path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:center];
    [path2 addArcWithCenter:center radius:self.radius startAngle:angle_start2 endAngle:angle_end2 clockwise:YES];
    [[UIColor greenColor] set];
    //    [path2 fill];
    CAShapeLayer *shaplayer2 = [CAShapeLayer layer];
    [shaplayer2 setPath:path2.CGPath];
    [shaplayer2 setFillColor:[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1].CGColor];
    [shaplayer2 setFillColor:[UIColor clearColor].CGColor];
    [shaplayer2 setZPosition:center.x];
    [self.layer addSublayer:shaplayer2];
    [ShapLayers insertObject:shaplayer2 atIndex:1];
    
    
    float angle_start3 = angle_end2;
    float angle_end3 = radians(315);
    //    CGPathCreateArc(center, self.radius, angle_start3 , angle_end3);
    
    UIBezierPath * path3=[UIBezierPath bezierPath];
    [path3 moveToPoint:center];
    [path3 addArcWithCenter: center radius:self.radius startAngle:angle_start3 endAngle:angle_end3 clockwise:YES];
    CAShapeLayer *shaplayer3 = [CAShapeLayer layer];
    [shaplayer3 setPath:path3.CGPath];
    [shaplayer3 setFillColor:[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1].CGColor];
    [shaplayer3 setFillColor:[UIColor clearColor].CGColor];
    
    [shaplayer3 setZPosition:center.x];
    [self.layer addSublayer:shaplayer3];
    [ShapLayers insertObject:shaplayer3 atIndex:2];
    
    float angle_start4 = angle_end3;
    float angle_end4 = radians(405);
    UIBezierPath *path4 = [UIBezierPath bezierPath];
    [path4 moveToPoint:center];
    [path4 addArcWithCenter:center radius:self.radius startAngle:angle_start4 endAngle:angle_end4 clockwise:YES];
    CAShapeLayer *shaplayer4 = [CAShapeLayer layer];
    [shaplayer4 setPath:path4.CGPath];
    [shaplayer4 setFillColor:[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1].CGColor];
    [shaplayer4 setFillColor:[UIColor clearColor].CGColor];
    
    [shaplayer4 setZPosition:center.x];
    [self.layer addSublayer:shaplayer4];
    [ShapLayers insertObject:shaplayer4 atIndex:3];
    
    //path5  是中间圆心
    float angle_start5 = radians(0);
    float angle_end5 = radians(360);
    UIBezierPath *path5 = [UIBezierPath bezierPath];
    [path5 moveToPoint:center];
    [path5 addArcWithCenter:center radius:self.radius/3 startAngle:angle_start5 endAngle:angle_end5 clockwise:YES];
    [[UIColor blackColor] set];
    CAShapeLayer *shaplayer5 = [CAShapeLayer layer];
    [shaplayer5 setPath:path5.CGPath];
    [shaplayer5 setFillColor:[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1].CGColor];
    [shaplayer5 setFillColor:[UIColor clearColor].CGColor];
    [shaplayer5 setZPosition:center.x];
    [self.layer addSublayer:shaplayer5];
    //    [path5 fill];
    [ShapLayers insertObject:shaplayer5 atIndex:4];
    
    
    CATextLayer *textLayer1 = [CATextLayer layer];
    textLayer1.contentsScale = [[UIScreen mainScreen] scale];
    UIFont *uifont = [UIFont systemFontOfSize:30];
    CGFontRef font ;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        font = CGFontCreateCopyWithVariations((__bridge CGFontRef)(uifont), (__bridge CFDictionaryRef)(@{}));
    } else {
        font = CGFontCreateWithFontName((__bridge CFStringRef)[uifont fontName]);
    }
    if (font) {
        [textLayer1 setFont:font];
    }
    [textLayer1 setFontSize:30];
    [textLayer1 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [textLayer1 setAlignmentMode:kCAAlignmentCenter];
    [textLayer1 setBackgroundColor:[UIColor clearColor].CGColor];
    CGSize size = [@"OK" sizeWithFont:uifont];
    [CATransaction setDisableActions:YES];
    [textLayer1 setBounds:self.bounds];

    [textLayer1 setPosition:CGPointMake(self.center.x-size.width/2, self.center.y-size.height/2)];
    [textLayer1 setString:@"OK"];
    
//    [self.layer addSublayer:textLayer1];
    //
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    UIImage* mars = [UIImage imageNamed:@"CircleControl.png"];
    //
    //    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //    CGImageRef image = [mars CGImage];
    //
    //    CGContextTranslateCTM(context, 0.0, rect.size.height);
    //    CGContextScaleCTM(context, 1.0, -1.0);
    //    CGContextDrawImage(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height), image);
    
    if (images == nil) {
        images = [[NSMutableArray alloc]initWithCapacity:0];
    }
    [images removeAllObjects];
    
    UIImageView *imageViewbg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ControllBg.png"] highlightedImage:[UIImage imageNamed:@"ControllBg.png"]];
    imageViewbg.contentMode = UIViewContentModeScaleAspectFill;
    imageViewbg.autoresizingMask= UIViewAutoresizingNone;
    imageViewbg.frame = self.frame;
    imageViewbg.center = CGPointMake(149, 157);
    [self addSubview:imageViewbg];

    
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"control_down.png"] highlightedImage:[UIImage imageNamed:@"control_hdown.png"]];
    imageView1.contentMode = UIViewContentModeCenter;
    imageView1.center = CGPointMake(radius,self.frame.size.height-15);
    imageView1.bounds = CGRectMake(0, 0, 15, 15);
    [self addSubview:imageView1];
    [images insertObject:imageView1 atIndex:0];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"control_left.png"] highlightedImage:[UIImage imageNamed:@"control_hleft.png"]];
    imageView2.contentMode = UIViewContentModeCenter;
    
    imageView2.center = CGPointMake(15,radius );
    imageView2.bounds = CGRectMake(0, 0, 15, 15);
    [self addSubview:imageView2];
    [images insertObject:imageView2 atIndex:1];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"control_top.png"] highlightedImage:[UIImage imageNamed:@"control_htop.png"]];
    imageView3.contentMode = UIViewContentModeCenter;
    
    imageView3.center = CGPointMake(radius,15);
    imageView3.bounds = CGRectMake(0, 0, 15, 15);
    [self addSubview:imageView3];
    [images insertObject:imageView3 atIndex:2];
    
    
    UIImageView *imageView4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"control_right.png"] highlightedImage:[UIImage imageNamed:@"control_hright.png"]];
    imageView4.center = CGPointMake(radius*2 -15,radius);
    imageView4.contentMode = UIViewContentModeCenter;
    
    imageView4.bounds = CGRectMake(0, 0, 15, 15);
    [self addSubview:imageView4];
    [images insertObject:imageView4 atIndex:3];
    //    UIImageView* iv = [[UIImageView alloc] initWithImage:im];
    //    [self.window.rootViewController.view addSubview: iv];
    //    iv.center = self.window.center;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    if (selectedLayer) {
//        [self setHighlighted:NO];
//    }
    [self setHighlighted:NO];
    selectedLayer = nil;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self];
        CAShapeLayer *layer = [ShapLayers objectAtIndex:4];
        if (CGPathContainsPoint(layer.path, &transform, location, 0)) {
            return;
        }
        
        if (CGPathContainsPoint(selectedLayer.path, &transform, location, 0)) {
            return;
        }
//        else
//        {
//            [self setHighlighted:NO];
//            double delayInSeconds = 1.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                for (CAShapeLayer *shap in ShapLayers) {
//                    if (CGPathContainsPoint(shap.path, &transform, location, 0)) {
//                        NSLog(@"move");
//                        selectedLayer=shap;
//                        [self setHighlighted:YES];
//                        return;
//                        
//                    }
//                }
//            });
//            
//            return;
//        
//        }
        break;
    }
    [self setHighlighted:NO];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    for (UITouch *touch in touches) {
        //        (touch.tapCount==1)
        CGPoint location = [touch locationInView:self];
        
        CAShapeLayer *layer = [ShapLayers objectAtIndex:4];
        if (CGPathContainsPoint(layer.path, &transform, location, 0)) {
            selectedLayer=layer;
//            [self setHighlighted:YES];
            return;
        }
        
        for (CAShapeLayer *shap in ShapLayers) {
            if (CGPathContainsPoint(shap.path, &transform, location, 0)) {
                selectedLayer=shap;
//                [self setHighlighted:YES];
            }
        }
    }
    [self setHighlighted:YES];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    int index=[ShapLayers indexOfObject:selectedLayer];
    //    dispatch_source_t timer=dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    if (index>=0 && index<=4) {
        for (UIImageView *image in images) {
            image.highlighted=NO;
        }
        UIImageView *imageView ;

        if (index >=0 && index <=3) {
             imageView = [images objectAtIndex:index];

        }
        if (!highlighted) {
            imageView.highlighted=NO;
            dispatch_source_cancel(timer);
//            for (CAShapeLayer *shap in ShapLayers) {
//                [shap setFillColor:[UIColor clearColor].CGColor];
//            }
        }
        else
        {
            imageView.highlighted=YES;
        
            if (timer && dispatch_source_testcancel(timer)==0) {
                dispatch_source_cancel(timer);
            }
            if ([_delegate respondsToSelector:@selector(ItemDidSelectedWithindex: State:)]) {
                [self.delegate ItemDidSelectedWithindex:index State:ControlStateDown];
                supdate = [NSDate date];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                NSLog(@"down");
            }
            timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
//            [selectedLayer setFillColor:[UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:0.8].CGColor];
//            [selectedLayer fillColor];
            //    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 1ull*NSEC_PER_SEC);
            dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), 0.3 * NSEC_PER_SEC,0);
            dispatch_source_set_cancel_handler(timer, ^{
                if ([_delegate respondsToSelector:@selector(ItemDidSelectedWithindex:State:)]) {
                    double delayInSeconds = 0.3;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self.delegate ItemDidSelectedWithindex:index State:ControlStateUp];
                        NSLog(@"up");
                    });
                }
                dispatch_suspend(timer);
                selectedLayer=nil;
            });
            
            dispatch_source_set_event_handler(timer, ^{
                if ([_delegate respondsToSelector:@selector(ItemDidSelectedWithindex:State:)]) {
                    [self.delegate ItemDidSelectedWithindex:index State:ControlStateContinue];
                    NSLog(@"duration  %f",[[NSDate date] timeIntervalSinceReferenceDate] - [supdate timeIntervalSinceReferenceDate]);
                    supdate = [NSDate date];
                    NSLog(@"continue");
                }
                //        dispatch_source_cancel(timer);
            });
            //启动
                dispatch_resume(timer);
        }
    }
    
}

@end
