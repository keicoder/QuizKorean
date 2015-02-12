//
//  PopAnimationClearButton.m
//  QuizKorean
//
//  Created by jun on 2/12/15.
//  Copyright (c) 2015 jun. All rights reserved.
//


#define kNormalTextColor [UIColor colorWithRed:0.084 green:0.469 blue:0.715 alpha:1.000]
#define kHightlightTextColor [UIColor colorWithRed:0.072 green:0.284 blue:0.410 alpha:1.000]


#import "PopAnimationClearButton.h"
#import <pop/POP.h>


@implementation PopAnimationClearButton
{
	CGFloat _duration;
}


#pragma mark - Init

- (id)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	
	if (self) {
		
		_duration = 0.2f;
	}
	
	return self;
}


#pragma mark - Handle touches with a nice pop animations

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	POPSpringAnimation *scale = [self pop_animationForKey:@"scale"];
	POPSpringAnimation *rotate = [self.layer pop_animationForKey:@"rotate"];
	
	CGFloat size = 1.2f;
	
	if (scale) {
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
	} else {
		scale = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
		scale.springBounciness = 20;
		scale.springSpeed = 18.0f;
		[self pop_addAnimation:scale forKey:@"scale"];
	}
	
	CGFloat value = 6;
	if (rotate) {
		rotate.toValue = @(M_PI/value);
	} else {
		rotate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
		rotate.toValue = @(M_PI/value);
		rotate.springBounciness = 20;
		rotate.springSpeed = 18.0f;
		[self.layer pop_addAnimation:rotate forKey:@"rotate"];
	}
	
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	POPSpringAnimation *scale = [self pop_animationForKey:@"scale"];
	POPSpringAnimation *rotate = [self pop_animationForKey:@"rotate"];
	
	CGFloat size = 1.0f;
	
	if (scale) {
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
	} else {
		scale = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
		scale.toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
		scale.springBounciness = 20;
		scale.springSpeed = 18.0f;
		[self pop_addAnimation:scale forKey:@"scale"];
	}
	
	if (rotate) {
		rotate.toValue = @(0);
	} else {
		rotate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
		rotate.toValue = @(0);
		rotate.springBounciness = 20;
		rotate.springSpeed = 18.0f;
		[self.layer pop_addAnimation:rotate forKey:@"rotate"];
	}
	
	[super touchesEnded:touches withEvent:event];
}


@end
