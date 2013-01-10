#import <UIKit/UIKit.h>

@interface DSMenuButton : UIView

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIControl *control;


-(id)initWithRadius:(CGFloat)radius center:(CGPoint)center;

- (void)startRotation;
- (void)stopRotation;

@end
