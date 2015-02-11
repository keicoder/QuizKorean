//
//  ViewController.m
//  QuizKorean
//
//  Created by jun on 2/10/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "QuizViewController.h"
#import "AFNetworking.h"
#import "Quiz.h"
#import "MenuViewController.h"
#import "POP.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+ChangeColor.h"
#import "SettingsViewController.h"


#define debug 1


@interface QuizViewController ()

@property (nonatomic, strong) Quiz *quiz;

@property (weak, nonatomic) IBOutlet UIView *questionContainerView;
@property (weak, nonatomic) IBOutlet UIView *answerContainerView;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIScrollView *questionScrollView;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel1;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel2;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel3;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel4;

@property (weak, nonatomic) IBOutlet UIButton *answerButton1;
@property (weak, nonatomic) IBOutlet UIButton *answerButton2;
@property (weak, nonatomic) IBOutlet UIButton *answerButton3;
@property (weak, nonatomic) IBOutlet UIButton *answerButton4;

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end


@implementation QuizViewController
{
	NSOperationQueue *_queue;
	
	Quiz *_quiz1;
	Quiz *_quiz2;
	Quiz *_quiz3;
	Quiz *_quiz4;
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self configureUI];
	[self addObserverForParseJSONDictionaryFinishedNotification];
	[self fetchJSONData];
}


#pragma mark - Fetch JSON Data

- (void)fetchJSONData
{
	self.quiz = [[Quiz alloc] init];
	[self.quiz fetchJSON];
}


#pragma mark - Listening Notification

- (void)addObserverForParseJSONDictionaryFinishedNotification
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveParseJSONDictionaryFinishedNotification:) name:@"ParseJSONDictionaryFinishedNotification" object:nil];
}


- (void)didReceiveParseJSONDictionaryFinishedNotification:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:@"ParseJSONDictionaryFinishedNotification"])
	{
		POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
		sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
		sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
		sprintAnimation.springBounciness = 20.f;
		[self.questionLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
		
		_quiz1 = self.quiz.quizArray[0];
		self.questionLabel.text = _quiz1.question;
		self.answerLabel1.text = _quiz1.answer;
		NSLog (@"quiz1.correct: %@\n", _quiz1.correct);
		
		_quiz2 = self.quiz.quizArray[1];
		self.answerLabel2.text = _quiz2.answer;
		NSLog (@"quiz2.correct: %@\n", _quiz2.correct);
		
		_quiz3 = self.quiz.quizArray[2];
		self.answerLabel3.text = _quiz3.answer;
		NSLog (@"quiz3.correct: %@\n", _quiz3.correct);
		
		_quiz4 = self.quiz.quizArray[3];
		self.answerLabel4.text = _quiz4.answer;
		NSLog (@"quiz4.correct: %@\n", _quiz4.correct);
	}
}


#pragma mark - Answer Button Action

- (IBAction)answerButtonPressed:(id)sender
{
	UIColor *highlightedColor = [UIColor colorWithRed:0.07 green:0.14 blue:0.26 alpha:1];
	UIColor *normalColor = [UIColor clearColor];
	
	CGFloat duration = 0.2f;
	[UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
		[sender setBackgroundColor:highlightedColor];
	} completion:^(BOOL finished) {
		
		[UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
			[sender setBackgroundColor:normalColor];
		} completion:^(BOOL finished) {
			
			[self inquireAnswer:sender];
		}];
	}];
}


- (void)inquireAnswer:(id)sender
{
	NSString *correct = @"정답";
	
	//정답일 때
	//POP Spin Animation
	POPSpringAnimation *spinAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
	spinAnimation.fromValue = @(M_PI / 4);
	spinAnimation.toValue = @(0);
	spinAnimation.springBounciness = 20;
	spinAnimation.velocity = @(10);
	
	//POP Sprint Animation
	POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.1, 1.1)];
	sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
	sprintAnimation.springBounciness = 20.f;
	
	//오답일 때
	//POP Shake Animation
	POPSpringAnimation *shakeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
	shakeAnimation.springBounciness = 20;
	shakeAnimation.velocity = @(3000);
	
	CGFloat delay = 1.0f;
	
	if (sender == self.answerButton1) {
		if ([_quiz1.correct isEqualToString:correct]) {
			[self.answerButton1.layer pop_addAnimation:spinAnimation forKey:@"spinAnimation"];
			[self.answerLabel1 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self playCorrectSound:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
		} else {
			[self.answerButton1.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
		}
	} else if (sender == self.answerButton2) {
		if ([_quiz2.correct isEqualToString:correct]) {
			[self.answerButton2.layer pop_addAnimation:spinAnimation forKey:@"spinAnimation"];
			[self.answerLabel2 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self playCorrectSound:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
		} else {
			[self.answerButton2.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
		}
	}
	else if (sender == self.answerButton3) {
		if ([_quiz3.correct isEqualToString:correct]) {
			[self.answerButton3.layer pop_addAnimation:spinAnimation forKey:@"spinAnimation"];
			[self.answerLabel3 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self playCorrectSound:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
		} else {
			[self.answerButton3.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
		}
	}else if (sender == self.answerButton4) {
		if ([_quiz4.correct isEqualToString:correct]) {
			[self.answerButton4.layer pop_addAnimation:spinAnimation forKey:@"spinAnimation"];
			[self.answerLabel4 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self playCorrectSound:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
		} else {
			[self.answerButton4.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
		}
	}
}



#pragma mark - Play Sound

- (void)playCorrectSound:(id)sender
{
	NSString *correctPath = [[NSBundle mainBundle] pathForResource:@"correct" ofType:@"caf"];
	NSURL *correctURL = [NSURL fileURLWithPath:correctPath];
	SystemSoundID correctSoundID;
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)correctURL, &correctSoundID);
	AudioServicesPlaySystemSound(correctSoundID);
}


#pragma mark - ConfigureUI

- (void)configureUI
{
	NSString *blank = @"";
	[self.answerButton1 setTitle:blank forState:UIControlStateNormal];
	[self.answerButton2 setTitle:blank forState:UIControlStateNormal];
	[self.answerButton3 setTitle:blank forState:UIControlStateNormal];
	[self.answerButton4 setTitle:blank forState:UIControlStateNormal];
	
	UIColor *whiteColor = [UIColor whiteColor];
	
	self.view.backgroundColor = [UIColor colorWithRed:0.11 green:0.67 blue:0.85 alpha:1];
	
	self.questionContainerView.backgroundColor = [UIColor clearColor];
	self.answerContainerView.backgroundColor = whiteColor;
	
	self.infoView.backgroundColor = [UIColor colorWithRed:0.548 green:0.828 blue:0.921 alpha:1.000];
	self.questionScrollView.backgroundColor = [UIColor colorWithRed:0.324 green:0.634 blue:0.737 alpha:1.000];
	
	
	
	UIColor *oddColor = [UIColor colorWithRed:0.05 green:0.32 blue:0.41 alpha:1];
	UIColor *evenColor = [UIColor colorWithRed:0.000 green:0.277 blue:0.361 alpha:1.000];
	self.answerButton1.backgroundColor = oddColor;
	self.answerButton2.backgroundColor = evenColor;
	self.answerButton3.backgroundColor = oddColor;
	self.answerButton4.backgroundColor = evenColor;
}


#pragma mark - Menu Button Action

- (IBAction)homeButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)settingsButtonTapped:(id)sender
{
	SettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
	[self showViewController:controller sender:sender];
}


#pragma mark - Dealloc

- (void)dealloc
{
	NSLog(@"dealloc %@", self);
}

@end
