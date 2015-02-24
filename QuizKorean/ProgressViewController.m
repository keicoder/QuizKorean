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

@interface ProgressViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smileyImageView;

@end


@implementation ProgressViewController
{
    GradientView *_gradientView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
    [self addTapGuesture];
    [self updateLabel];
}


- (void)updateLabel
{
    self.aboutLabel.text = @"서울 열린 데이터 광장의 ‘우리말 문제’ Open API를 활용하여 우리말 맞춤법, 띄어쓰기, 외래어 표기법, 표준어 규정 등 한글정보를 문제 풀이 식으로 학습할 수 있는 앱입니다.\n\n앱에 대한 문의는 트위터 @hyun2012나, lovejun.soft@gmail.com으로 보내주세요.\n\nlovejunsoft 2014";
}


#pragma mark - Present In ParentView Controller

- (void)presentInParentViewController:(UIViewController *)parentViewController
{
    _gradientView = [[GradientView alloc] initWithFrame:parentViewController.view.bounds];
    [parentViewController.view addSubview:_gradientView];
    
    self.view.frame = parentViewController.view.bounds;
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.duration = 0.4;
    bounceAnimation.delegate = self;
    
    bounceAnimation.values = @[ @0.8, @1.2, @0.9, @1.0 ];
    bounceAnimation.keyTimes = @[ @0.0, @0.334, @0.666, @1.0 ];
    
    bounceAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @0.0f;
    fadeAnimation.toValue = @1.0f;
    fadeAnimation.duration = 0.2;
    [_gradientView.layer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self didMoveToParentViewController:self.parentViewController];
}


- (void)dismissFromParentViewController
{
    [self willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:0.3 animations:^
     {
         CGRect rect = self.view.bounds;
         rect.origin.y += rect.size.height;
         self.view.frame = rect;
         _gradientView.alpha = 0.0f;
     }
                     completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
         [self removeFromParentViewController];
         
         [_gradientView removeFromSuperview];
     }];
}


#pragma mark - Button and Touch Action

- (IBAction)dismissButtonTapped:(id)sender
{
    [self dismissFromParentViewController];
}


- (void)addTapGuesture
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissButtonTapped:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:gestureRecognizer];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self.view);
}


#pragma mark - Configure UI

- (void)configureUI
{
    self.view.tintColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:1.0f];
    self.view.backgroundColor = [UIColor clearColor];
    self.containerView.backgroundColor = [UIColor colorWithRed:0.05 green:0.32 blue:0.41 alpha:1];
    self.containerView.layer.cornerRadius = 10.0f;
    
    UIImage *smiley = [UIImage imageForChangingColor:@"smiley" color:[UIColor whiteColor]];
    self.smileyImageView.image = smiley;
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}


@end