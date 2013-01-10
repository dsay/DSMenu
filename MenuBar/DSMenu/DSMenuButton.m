#import "DSMenuButton.h"
#import <QuartzCore/QuartzCore.h>

#define kDurationAnimation  .35f

@interface DSMenuButton ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DSMenuButton

@synthesize backgroundImage = _backgroundImage;
@synthesize control = _control;

- (id)initWithRadius:(CGFloat)radius center:(CGPoint)center
{
    if (self = [super initWithFrame:CGRectMake(0, 0, radius * 2, radius *2)]) {
        self.center = center;
    }
    return self;
}

-(void)startRotation
{
    [self.timer invalidate];
    [self rotate];
    self.timer  = [NSTimer scheduledTimerWithTimeInterval:kDurationAnimation
                                                   target:self
                                                 selector:@selector(rotate)
                                                 userInfo:nil
                                                  repeats:YES];
}

-(void)stopRotation
{
    [self.timer invalidate];
}

-(UIControl *)control
{
    if (!_control) 
        _control = [[UIControl alloc] initWithFrame:self.bounds];
    
    return _control;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *imageView;
    
    if ([self viewWithTag:1]) {
        imageView = (UIImageView *)[self viewWithTag:1];
    }else{
        [self addSubview:self.control];
        
        imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.tag = 1;
        imageView.layer.cornerRadius = self.frame.size.width/2;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        imageView.layer.borderWidth = 1;
        
        [self addSubview:imageView];
    }
    self.backgroundColor = [UIColor clearColor];
    [imageView setImage:backgroundImage];
}

- (void)rotate
{
   
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = kDurationAnimation;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    [self.layer addAnimation:animation forKey:animation.keyPath];
}

@end
