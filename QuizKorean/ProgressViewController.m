//
//  ProgressViewController.m
//  QuizKorean
//
//  Created by jun on 2015. 2. 24..
//  Copyright (c) 2015년 jun. All rights reserved.
//

#import "ProgressViewController.h"
#import "GradientView.h"
#import "UIImage+ChangeColor.h"
#import "PopView.h"

@interface ProgressViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet PopView *popView;

@end


@implementation ProgressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self addTapGuesture];
}


#pragma mark - Button and Touch Action

- (IBAction)dismissButtonTapped:(id)sender
{
	NSLog(@"self.popView did receive touch");
	[self dismissViewControllerAnimated:YES completion:^{
		NSLog(@"Progress view dismissed");
	}];
}


#pragma mark - Tap Guesture

- (void)addTapGuesture
{
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissButtonTapped:)];
	gestureRecognizer.cancelsTouchesInView = NO;
	gestureRecognizer.delegate = self;
	
	[self.popView addGestureRecognizer:gestureRecognizer];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	return (touch.view == self.popView);
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}


@end