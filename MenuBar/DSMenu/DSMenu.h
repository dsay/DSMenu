#import <UIKit/UIKit.h>

typedef enum
{
    DSMenuStartPositionCenter = 1,
    DSMenuStartPositionLeftButton,
    DSMenuStartPositionLeft,
    
}DSMenuStartPosition;

@protocol DSMenuDelegate <NSObject>  

- (void)pressOnButtonWithIndex:(NSInteger)index;

@end

@interface DSMenu : UIView

@property (nonatomic, strong) NSArray *backgroundImagesButtons;
@property (nonatomic, strong) UIImage *backgroundImageCenterButton;

- (id)initWithFrame:(CGRect)frame positionType:(DSMenuStartPosition)startPositionType;

@end
