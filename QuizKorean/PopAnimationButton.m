//
//  PopAnimationButton.m
//  FetchingCitydata
//
//  Created by jun on 2/10/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "PopAnimationButton.h"
#import <pop/POP.h>


@implementation PopAnimationButton

#pragma mark - Handle touches with a nice interaction animations

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	POPSpringAnimation *scale = [self pop_animationForKey:@"scale"];
	POPSpringAnimation *rotate = [self.layer pop_animationForKey:@"rotate"];
	
	CGFloat size = 0.88;
	
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
		rotate.toValue = @(M_PI/6);
	} else {
		rotate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
		rotate.toValue = @(M_PI/6);
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
