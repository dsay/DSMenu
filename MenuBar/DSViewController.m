//
//  DSViewController.m
//  MenuBar
//
//  Created by Dima on 1/8/13.
//  Copyright (c) 2013 Dima Sai. All rights reserved.
//

#import "DSViewController.h"
#import "DSMenu.h"

@interface DSViewController ()
@property (nonatomic, strong) DSMenu *button;
@end

@implementation DSViewController
@synthesize button;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *array = @[ [UIImage imageNamed:@"MumsnetIcon114"],
    [UIImage imageNamed:@"icon"],
    [UIImage imageNamed:@"Icon57"],
    [UIImage imageNamed:@"Icon_iPad"],
    [UIImage imageNamed:@"veronica144x144"],
    [UIImage imageNamed:@"icon"] ,
    [UIImage imageNamed:@"Icon57"],
    [UIImage imageNamed:@"Icon_iPad"],
    [UIImage imageNamed:@"veronica144x144"],
    [UIImage imageNamed:@"icon"]
    ];
    
    DSMenu * menucenter = [[DSMenu alloc] initWithFrame:CGRectMake(120, 110, 200, 200) positionType:DSMenuStartPositionCenter];
    
    menucenter.backgroundImagesButtons = array;
    
    menucenter.backgroundImageCenterButton = [UIImage imageNamed:@"Default-Icon"];
    
    [self.view addSubview:menucenter];
    
     
    DSMenu * menuleftbutton = [[DSMenu alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 210, 200, 200) positionType:DSMenuStartPositionLeftButton];
    
    menuleftbutton.backgroundImagesButtons = array;
    
    menuleftbutton.backgroundImageCenterButton = [UIImage imageNamed:@"Default-Icon"];
    
    [self.view addSubview:menuleftbutton];
    
    DSMenu * menuleft= [[DSMenu alloc] initWithFrame:CGRectMake(20, 210, 200, 200) positionType:DSMenuStartPositionLeft];
    
    menuleft.backgroundImagesButtons = array;
    
    menuleft.backgroundImageCenterButton = [UIImage imageNamed:@"Default-Icon"];
    
    [self.view addSubview:menuleft];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)stop:(id)sender
{
  
}
- (IBAction)start:(id)sender
{
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
