//
//  MenuViewController.m
//  QuizKorean
//
//  Created by jun on 2/10/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#define debug 1


#import "MenuViewController.h"
#import "QuizViewController.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"
#import "PopView.h"
#import "UIImage+ChangeColor.h"


@interface MenuViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet PopView *startView;
@property (weak, nonatomic) IBOutlet PopView *settingsView;
@property (weak, nonatomic) IBOutlet PopView *aboutView;

@end


@implementation MenuViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	[self configureUI];
    [self addTapGestureOnTheView:self.startView];
    [self addTapGestureOnTheView:self.settingsView];
    [self addTapGestureOnTheView:self.aboutView];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	[self changeViewsAlphaToZero];
	[self changelogoImageViewsAlphaToOpaque];
}


-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self moveViewsOutOfTheView];
}


#pragma mark - Animation

- (void)moveViewsOutOfTheView
{
    CGFloat originX = 2;
    
    CGRect startViewFrame = self.startView.frame;
    startViewFrame.origin.x -= self.view.bounds.size.width/originX;
    self.startView.frame = startViewFrame;
    
    CGRect settingsViewFrame = self.settingsView.frame;
    settingsViewFrame.origin.x -= self.view.bounds.size.width/originX;
    self.settingsView.frame = settingsViewFrame;
    
    CGRect aboutViewFrame = self.aboutView.frame;
    aboutViewFrame.origin.x -= self.view.bounds.size.width/originX;
    self.aboutView.frame = aboutViewFrame;
    
    [self performSelector:@selector(moveViewsInTheViewWithAnimation) withObject:nil afterDelay:0.1];
}


- (void)moveViewsInTheViewWithAnimation
{
	CGFloat alpha = 1.0;
	
	CGFloat duration = 0.2;
	CGFloat initialDelay = 0.0;
	CGFloat additionalDelay = 0.0;
	NSUInteger options = UIViewAnimationOptionCurveEaseIn; //from slow to fast
	
	[UIView animateWithDuration:duration delay:initialDelay options: options animations:^{
		
		self.startView.alpha = alpha;
		self.startView.frame = CGRectMake(self.view.bounds.size.width/2 - self.startView.bounds.size.width/2, self.startView.frame.origin.y, self.startView.bounds.size.width, self.startView.bounds.size.height);
		
	} completion:^(BOOL finished) {
		
		[UIView animateWithDuration:duration delay:additionalDelay options: options animations:^{
			
			self.settingsView.alpha = alpha;
			self.settingsView.frame = CGRectMake(self.view.bounds.size.width/2 - self.settingsView.bounds.size.width/2, self.settingsView.frame.origin.y, self.settingsView.bounds.size.width, self.settingsView.bounds.size.height);
			
		} completion:^(BOOL finished) {
			
			[UIView animateWithDuration:duration delay:additionalDelay options: options animations:^{
				
				self.aboutView.alpha = alpha;
				self.aboutView.frame = CGRectMake(self.view.bounds.size.width/2 - self.aboutView.bounds.size.width/2, self.aboutView.frame.origin.y, self.aboutView.bounds.size.width, self.aboutView.bounds.size.height);
				
			} completion:^(BOOL finished) {
				
			}];
		}];
	}];
}


#pragma mark - Tap gesture on the View

- (void)addTapGestureOnTheView:(UIView *)aView
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureViewTapped:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    
    [aView addGestureRecognizer:gestureRecognizer];
}


- (void)gestureViewTapped:(UITouch *)touch
{
    if ([touch.view isEqual:(UIView *)self.startView]) {
        
        NSLog(@"self.startView Tapped");
        QuizViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
        [self presentViewController:controller animated:YES completion:^{ }];
    
    } else if ([touch.view isEqual:(UIView *)self.settingsView]) {
        
        NSLog(@"self.settingsView Tapped");
        SettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        [self presentViewController:controller animated:YES completion:^{ }];
        
    } else if ([touch.view isEqual:(UIView *)self.aboutView]) {
        
        NSLog(@"self.aboutView Tapped");
        AboutViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        controller.view.frame = self.view.bounds;
        [controller presentInParentViewController:self];
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.startView || touch.view == self.settingsView || touch.view == self.aboutView) {
        
        return YES;
    }
    
    return NO;
}


#pragma mark - View's Alpha

- (void)changeViewsAlphaToZero
{
    CGFloat alpha = 0.0;
    self.logoImageView.alpha = alpha;
    self.startView.alpha = alpha;
    self.settingsView.alpha = alpha;
    self.aboutView.alpha = alpha;
}


- (void)changelogoImageViewsAlphaToOpaque
{
    CGFloat labelAnimationDuration = 2.0;
    
    [UIView animateWithDuration:labelAnimationDuration delay:0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGFloat alpha = 1.0;
        self.logoImageView.alpha = alpha;
        
    } completion:^(BOOL finished) { }];
}


#pragma mark - Configure UI

- (void)configureUI
{
    float cornerRadius;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        cornerRadius = 35;
    } else {
        cornerRadius = self.startView.bounds.size.height/2;
    }
    
    self.startView.layer.cornerRadius = cornerRadius;
    self.settingsView.layer.cornerRadius = cornerRadius;
    self.aboutView.layer.cornerRadius = cornerRadius;
    
    self.startView.cornerRadius = cornerRadius;
    self.settingsView.cornerRadius = cornerRadius;
    self.aboutView.cornerRadius = cornerRadius;
    
    
    //Color
    UIColor *colorNormal1 = [UIColor colorWithRed:0.72 green:0.93 blue:1 alpha:1];
    UIColor *colorNormal2 = [UIColor colorWithRed:0.52 green:0.85 blue:0.98 alpha:1];
    UIColor *colorNormal3 = [UIColor colorWithRed:0.2 green:0.69 blue:0.86 alpha:1];
    UIColor *colorHighlight = [UIColor colorWithRed:0.6 green:0.83 blue:0.84 alpha:1];
    
    self.startView.backgroundColor = colorNormal1;
    self.settingsView.backgroundColor = colorNormal2;
    self.aboutView.backgroundColor = colorNormal3;
    
    self.startView.backgroundColorNormal = colorNormal1;
    self.startView.backgroundColorHighlight = colorHighlight;
    self.settingsView.backgroundColorNormal = colorNormal2;
    self.settingsView.backgroundColorHighlight = colorHighlight;
    self.aboutView.backgroundColorNormal = colorNormal3;
    self.aboutView.backgroundColorHighlight = colorHighlight;
    
    
    //Image View
    UIColor *color = [UIColor colorWithRed:0 green:0.83 blue:0.95 alpha:1];
    UIImage *image = [UIImage imageForChangingColor:@"handHeart" color:color];
    self.logoImageView.backgroundColor = [UIColor clearColor];
    self.logoImageView.image = image;
}


#pragma mark - Dealloc

- (void)dealloc
{
	NSLog(@"dealloc %@", self);
}


@end