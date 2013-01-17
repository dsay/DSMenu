#import "DSProgressView.h"
#import <QuartzCore/QuartzCore.h>
@implementation DSProgressView

-(void)step
{
    [self performSelector:@selector(setNeedsDisplay) withObject:self afterDelay:0.045];
}

- (void)drawRect:(CGRect)rect
{

    static float steps = 0;

    steps += 0.09;
 
    CGFloat radius;
    if (rect.size.width < rect.size.height) 
        radius = rect.size.width / 2;
    else
        radius = rect.size.height / 2;
    
    CGRect bounds = self.bounds;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, rect);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 6.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    int countLine = 7;
    radius = radius/countLine;
    
    for (int i = 1; i < countLine; i ++)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, bounds.size.width / 2.f, bounds.size.height / 2.f);
    
        int clockwise = 1;
        
        if (i % 2) 
            clockwise = 1;
        else
            clockwise= -1;
        
        CGContextRotateCTM(context, clockwise * M_PI_2 * steps*i*(0.5));
        
        CGContextAddArc(context, 0, 0, radius * i, 0, M_PI * 3/4, 0);
        
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
    [self step];

}


@end
