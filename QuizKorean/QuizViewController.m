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


#define kODD_COLOR [UIColor colorWithRed:0.05 green:0.32 blue:0.41 alpha:1]
#define kEVEN_COLOR [UIColor colorWithRed:0.000 green:0.277 blue:0.361 alpha:1.000]

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
	
	NSString *_soundEffect;
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
	
	CGFloat duration = 0.2f;
	CGFloat alpha = 0.0f;
	
	[UIView animateWithDuration:duration animations:^{
		
		self.questionLabel.alpha = alpha;
		self.answerLabel1.alpha = alpha;
		self.answerLabel2.alpha = alpha;
		self.answerLabel3.alpha = alpha;
		self.answerLabel4.alpha = alpha;
		
	}completion:^(BOOL finished) {
		
		[self.quiz fetchJSON];
	}];
	
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
		_quiz1 = self.quiz.quizArray[0];
		_quiz2 = self.quiz.quizArray[1];
		_quiz3 = self.quiz.quizArray[2];
		_quiz4 = self.quiz.quizArray[3];
		
		POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
		sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
		sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(4, 4)];
		sprintAnimation.springBounciness = 20.f;
		
		CGFloat duration = 0.2f;
		CGFloat alpha = 1.0f;
		
		[UIView animateWithDuration:duration animations:^{
			self.questionLabel.alpha = alpha;
			[self.questionLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
			self.questionLabel.text = _quiz1.question;
		}completion:^(BOOL finished) {
			[UIView animateWithDuration:duration animations:^{
				self.answerLabel1.alpha = alpha;
				self.answerLabel1.text = _quiz1.answer;
				NSLog (@"quiz1.correct: %@\n", _quiz1.correct);
			}completion:^(BOOL finished) {
				[UIView animateWithDuration:duration animations:^{
					self.answerLabel2.alpha = alpha;
					self.answerLabel2.text = _quiz2.answer;
					NSLog (@"quiz2.correct: %@\n", _quiz2.correct);
				}completion:^(BOOL finished) {
					[UIView animateWithDuration:duration animations:^{
						self.answerLabel3.alpha = alpha;
						self.answerLabel3.text = _quiz3.answer;
						NSLog (@"quiz3.correct: %@\n", _quiz3.correct);
					}completion:^(BOOL finished) {
						[UIView animateWithDuration:duration animations:^{
							self.answerLabel4.alpha = alpha;
							self.answerLabel4.text = _quiz4.answer;
							NSLog (@"quiz4.correct: %@\n", _quiz4.correct);
						}completion:^(BOOL finished) { }];
					}];
				}];
			}];
		}];
	}
}


#pragma mark - Button Action

- (IBAction)answerButtonPressed:(id)sender
{
	CGFloat duration = 0.2f;
	
	[UIView animateWithDuration:0.3 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
		[sender setBackgroundColor:[UIColor orangeColor]];
	} completion:^(BOOL finished) {
		
		if (sender == self.answerButton1) {
			[UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
				[sender setBackgroundColor:kODD_COLOR];
			} completion:^(BOOL finished) {
				[self inquireAnswer:sender];
			}];
		} else if (sender == self.answerButton2) {
			[UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
				[sender setBackgroundColor:kEVEN_COLOR];
			} completion:^(BOOL finished) {
				[self inquireAnswer:sender];
			}];
		} else if (sender == self.answerButton3) {
			[UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
				[sender setBackgroundColor:kODD_COLOR];
			} completion:^(BOOL finished) {
				[self inquireAnswer:sender];
			}];
		} else if (sender == self.answerButton4) {
			[UIView animateWithDuration:duration delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
				[sender setBackgroundColor:kEVEN_COLOR];
			} completion:^(BOOL finished) {
				[self inquireAnswer:sender];
			}];
		}
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
	sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
	sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(4, 4)];
	sprintAnimation.springBounciness = 20.f;
	
	//오답일 때
	//POP Shake Animation
	POPSpringAnimation *shakeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
	shakeAnimation.springBounciness = 20;
	shakeAnimation.velocity = @(3000);
	
	CGFloat delay = 1.3f;
	
	if (sender == self.answerButton1) {
		if ([_quiz1.correct isEqualToString:correct]) {
			[self.answerLabel1.layer pop_addAnimation:spinAnimation forKey:@"spinAnimation"];
			[self.answerLabel1 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self checkToPlaySoundEffect:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
		} else {
			[self.answerLabel1.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
		}
	} else if (sender == self.answerButton2) {
		if ([_quiz2.correct isEqualToString:correct]) {
			[self.answerLabel2.layer pop_addAnimation:spinAnimation forKey:@"spinAnimation"];
			[self.answerLabel2 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self checkToPlaySoundEffect:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
		} else {
			[self.answerLabel2.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
		}
	}
	else if (sender == self.answerButton3) {
		if ([_quiz3.correct isEqualToString:correct]) {
			[self.answerLabel3.layer pop_addAnimation:spinAnimation forKey:@"spinAnimation"];
			[self.answerLabel3 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self checkToPlaySoundEffect:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
		} else {
			[self.answerLabel3.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
		}
	}else if (sender == self.answerButton4) {
		if ([_quiz4.correct isEqualToString:correct]) {
			[self.answerLabel4.layer pop_addAnimation:spinAnimation forKey:@"spinAnimation"];
			[self.answerLabel4 pop_addAnimation:sprintAnimation forKey:@"sprintAnimation"];
			[self checkToPlaySoundEffect:sender];
			[self performSelector:@selector(fetchJSONData) withObject:nil afterDelay:delay];
		} else {
			[self.answerLabel4.layer pop_addAnimation:shakeAnimation forKey:@"shakeAnimation"];
		}
	}
}


#pragma mark - Get the stored NSUserDefaults data and check to play SoundEffect

- (void)checkToPlaySoundEffect:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	_soundEffect = [defaults objectForKey:@"_soundEffect"];
	NSLog (@"_soundEffect: %@\n", _soundEffect);
	
	if (_soundEffect == nil) {
		_soundEffect = @"효과음 > 켜짐";
		[self playCorrectSound:sender];
	} else if ([_soundEffect isEqualToString: @"효과음 > 켜짐"]) {
		[self playCorrectSound:sender];
	} else if ([_soundEffect isEqualToString: @"효과음 > 꺼짐"]) {
		NSLog(@"No SoundEffect");
	}
	
	NSLog (@"_soundEffect: %@\n", _soundEffect);
}


- (void)playCorrectSound:(id)sender
{
	NSString *correctPath = [[NSBundle mainBundle] pathForResource:@"correct" ofType:@"caf"];
	NSURL *correctURL = [NSURL fileURLWithPath:correctPath];
	SystemSoundID correctSoundID;
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)correctURL, &correctSoundID);
	AudioServicesPlaySystemSound(correctSoundID);
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


#pragma mark - ConfigureUI

- (void)configureUI
{
	NSString *blank = @"";
	
	//Text
	[self.answerButton1 setTitle:blank forState:UIControlStateNormal];
	[self.answerButton2 setTitle:blank forState:UIControlStateNormal];
	[self.answerButton3 setTitle:blank forState:UIControlStateNormal];
	[self.answerButton4 setTitle:blank forState:UIControlStateNormal];
	self.questionLabel.text = blank;
	self.answerLabel1.text = blank;
	self.answerLabel2.text = blank;
	self.answerLabel3.text = blank;
	self.answerLabel4.text = blank;
	
	//Color
	UIColor *whiteColor = [UIColor whiteColor];
	UIColor *clearColor = [UIColor clearColor];
	UIColor *deepBlue = [UIColor colorWithRed:0.044 green:0.132 blue:0.247 alpha:1.000];
	UIColor *lightRed = [UIColor colorWithRed:0.993 green:0.391 blue:0.279 alpha:1.000];
	
	//View
	self.view.backgroundColor = whiteColor;
	self.questionContainerView.backgroundColor = whiteColor;
	self.answerContainerView.backgroundColor = whiteColor;
	self.infoView.backgroundColor = whiteColor;
	self.questionScrollView.backgroundColor = whiteColor;
	
	//Label
	self.questionLabel.textColor = deepBlue;
	self.answerLabel1.backgroundColor = clearColor;
	self.answerLabel2.backgroundColor = clearColor;
	self.answerLabel3.backgroundColor = clearColor;
	self.answerLabel4.backgroundColor = clearColor;
	
	//Button
	self.answerButton1.backgroundColor = kODD_COLOR;
	self.answerButton2.backgroundColor = kEVEN_COLOR;
	self.answerButton3.backgroundColor = kODD_COLOR;
	self.answerButton4.backgroundColor = kEVEN_COLOR;
	
	UIImage *menuImageNormal = [UIImage imageForChangingColor:@"menu" color:deepBlue];
	UIImage *menuImageHighlight = [UIImage imageForChangingColor:@"menu" color:lightRed];
	[self.menuButton setImage:menuImageNormal forState:UIControlStateNormal];
	[self.menuButton setImage:menuImageHighlight forState:UIControlStateHighlighted];
	
	UIImage *settingsImageNormal = [UIImage imageForChangingColor:@"settings" color:deepBlue];
	UIImage *settingsImageHighlight = [UIImage imageForChangingColor:@"settings" color:lightRed];
	[self.settingsButton setImage:settingsImageNormal forState:UIControlStateNormal];
	[self.settingsButton setImage:settingsImageHighlight forState:UIControlStateHighlighted];
}


#pragma mark - Dealloc

- (void)dealloc
{
	NSLog(@"dealloc %@", self);
}

@end
