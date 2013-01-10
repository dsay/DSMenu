#import "DSMenu.h"
#import "DSMenuButton.h"

#define kScaleFactor 10
#define kDurationAnimation .35f

#define kArcLengthStartPositionCenter 360
#define kArcLengthStartPositionleftButton 120
#define kArcLengthStartPositionleft 220

#define kMaxCountOfElementsPositionCenter 12
#define kMaxCountOfElementsPositionleftButton 4
#define kMaxCountOfElementsPositionleft 6

@interface DSMenu ()

@property (nonatomic, weak) id<DSMenuDelegate> delegate;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat radiusButton;
@property (nonatomic, assign) CGFloat radiusRotation;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) BOOL isOpenMenu;
@property (nonatomic, strong) DSMenuButton *centerButton;
@property (nonatomic, strong) NSMutableArray *menuButtonsArray;
@property (nonatomic, assign) CGFloat arclength;
@property (nonatomic, assign) CGFloat maxCountOfElements;
@end

@implementation DSMenu


@synthesize centerButton = _centerButton;
@synthesize menuButtonsArray = _menuButtonsArray;

@synthesize delegate;
@synthesize startPoint;
@synthesize radiusRotation;
@synthesize radiusButton;
@synthesize backgroundImagesButtons;
@synthesize backgroundImageCenterButton;
@synthesize isAnimation;
@synthesize isOpenMenu;
@synthesize arclength;
@synthesize maxCountOfElements;

- (id)initWithFrame:(CGRect)frame positionType:(DSMenuStartPosition)startPositionType
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUp];
        
        CGFloat width = frame.size.width;
        switch (startPositionType) {
            case DSMenuStartPositionCenter:
            {
                CGPoint start = CGPointMake(width / 2, width / 2);
                self.startPoint = start;
                self.arclength = kArcLengthStartPositionCenter;
                self.maxCountOfElements = kMaxCountOfElementsPositionCenter;
            }
                break;
            case DSMenuStartPositionLeftButton:
            {
                CGPoint start = CGPointMake(self.radiusButton, width - self.radiusButton);
                self.startPoint = start;
                self.arclength = kArcLengthStartPositionleftButton;
                self.maxCountOfElements = kMaxCountOfElementsPositionleftButton;
            }
                break;
            case DSMenuStartPositionLeft:
            {
                CGPoint start = CGPointMake(self.radiusButton, width / 2);
                self.startPoint = start;
                self.arclength = kArcLengthStartPositionleft;
                self.maxCountOfElements = kMaxCountOfElementsPositionleft;
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    self.radiusButton = self.bounds.size.width / kScaleFactor;
    self.radiusRotation = self.frame.size.width / 2 - self.radiusButton;
    self.isAnimation = NO;
    self.isOpenMenu = NO;
}


- (void)setBackgroundImageCenterButton:(UIImage *)_backgroundImageCenterButton
{
    self.centerButton.backgroundImage = _backgroundImageCenterButton;
}

- (void)setBackgroundImagesButtons:(NSArray *)_backgroundImagesButtons
{
    [_backgroundImagesButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (maxCountOfElements <= idx)
            return ;
        {        
            UIImage *image = (UIImage *)obj;
            
            DSMenuButton *button = [self creatButtonWithImage:image];
            button.control.tag = idx;
            [self sendSubviewToBack:button];
            [self.menuButtonsArray addObject:button];
        }
    }];
}

- (CGPoint)pointOfIndex:(NSInteger)index radius:(CGFloat)radius
{
    int countOfPoint = self.menuButtonsArray.count;

    float alfa = self.arclength / countOfPoint * index ;
    
    float x = cosf(alfa / 180 * M_PI - M_PI_2) * radius + self.startPoint.x;
    float y = sinf(alfa / 180 * M_PI - M_PI_2) * radius + self.startPoint.y;
    
    return  CGPointMake(x, y);
}

- (void)onCenterButton
{
    if (!isAnimation)
    {
        if (!isOpenMenu)
            [self openMenu];
        else
            [self closeMenu];
    }
}

- (void)openMenu
{
    isAnimation = YES;
    isOpenMenu = YES;
    
    [self.centerButton startRotation];
    [self.menuButtonsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        DSMenuButton *button = (DSMenuButton *)obj;
        button.hidden = NO;
        [button startRotation];
        float delay = kDurationAnimation / self.menuButtonsArray.count;
        
        [UIView animateWithDuration:kDurationAnimation delay:delay * idx options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            button.center = [self pointOfIndex:idx radius:self.radiusRotation + radiusButton];
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:kDurationAnimation/2 animations:^{
                button.center = [self pointOfIndex:idx radius:self.radiusRotation ];
                [button stopRotation];
                
                if (idx == self.menuButtonsArray.count-1)
                {
                    [self.centerButton stopRotation];
                    isAnimation = NO;
                }
            }];
            
        }];
        
    }];
}

- (void)closeMenu
{
    isAnimation = YES;
    isOpenMenu = NO;
    
    [self.centerButton startRotation];
    [self.menuButtonsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        DSMenuButton *button = (DSMenuButton *)obj;
        [button startRotation];
        
        float delay = kDurationAnimation / self.menuButtonsArray.count;
        
        [UIView animateWithDuration:kDurationAnimation delay:delay * idx options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            button.center = self.startPoint;
        } completion:^(BOOL finished) {

                [button stopRotation];
                button.hidden = YES;
                if (idx == self.menuButtonsArray.count-1)
                {
                    [self.centerButton stopRotation];
                    isAnimation = NO;
                }
        }];
        
    }];
}

- (void)onMenuButton:(UIControl *)control
{
    if ([self.delegate respondsToSelector:@selector(pressOnButtonWithIndex:)])
        [self.delegate pressOnButtonWithIndex:control.tag];
}

- (DSMenuButton *)centerButton
{
    if (!_centerButton) {
        _centerButton= [[DSMenuButton alloc] initWithRadius:radiusButton center:startPoint];

        [_centerButton.control addTarget:self action:@selector(onCenterButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_centerButton];
    }
    return _centerButton;
}

- (DSMenuButton *)creatButtonWithImage:(UIImage *)image
{
    DSMenuButton *button = [[DSMenuButton alloc] initWithRadius:radiusButton center:startPoint];

    button.hidden = YES;
    button.backgroundImage = image;
    [_centerButton.control addTarget:self action:@selector(onMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    return button;
}

-(NSMutableArray *)menuButtonsArray
{
    if (!_menuButtonsArray) 
        _menuButtonsArray = [NSMutableArray new];
    
    return _menuButtonsArray;
}

@end
