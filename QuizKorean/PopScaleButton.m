//
//  PopScaleButton.m
//  QuizKorean
//
//  Created by jun on 2/12/15.
//  Copyright (c) 2015 jun. All rights reserved.
//


#define kNormalBgColor [UIColor colorWithRed:0.227 green:0.414 blue:0.610 alpha:1.000]
#define khighlightBgColor [UIColor colorWithRed:0.044 green:0.132 blue:0.247 alpha:1.000]


#import "PopScaleButton.h"
#import "pop/POP.h"


@implementation PopScaleButton
{
	CGFloat _duration;
}


#pragma mark - Init

- (id)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	
	if (self) {
		
		_duration = 0.2f;
		
		[self setBackgroundColor:kNormalBgColor];
		self.backgroundColorNormal = kNormalBgColor;
	}
	
	return self;
}


#pragma mark - Handle touches with a nice pop animations

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	POPSpringAnimation *scale = [self pop_animationForKey:@"scale"];
	
	CGFloat size = 0.88f;
	
	if (scale) {
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
	} else {
		scale = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
		scale.springBounciness = 20;
		scale.springSpeed = 18.0f;
		[self pop_addAnimation:scale forKey:@"scale"];
	}
	
	[UIView animateWithDuration:_duration animations:^{
		[self setBackgroundColor:khighlightBgColor];
	}completion:^(BOOL finished) { }];
	
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	POPSpringAnimation *scale = [self pop_animationForKey:@"scale"];
	
	CGFloat size = 1.0;
	
	if (scale) {
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
	} else {
		scale = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
		scale.springBounciness = 20;
		scale.springSpeed = 18.0f;
		[self pop_addAnimation:scale forKey:@"scale"];
	}
	
	[UIView animateWithDuration:_duration animations:^{
		[self setBackgroundColor:self.backgroundColorNormal];
	}completion:^(BOOL finished) { }];
	
	[super touchesEnded:touches withEvent:event];
}


@end
