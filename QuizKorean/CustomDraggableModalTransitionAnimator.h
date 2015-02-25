//
//  CustomDraggableModalTransitionAnimator.h
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef NS_ENUM(NSUInteger, ModalTransitonDirection)
{
    ModalTransitonDirectionBottom,
    ModalTransitonDirectionLeft,
    ModalTransitonDirectionRight,
};

@interface DetectScrollViewEndGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, weak) UIScrollView *scrollview;

@end


@interface CustomDraggableModalTransitionAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign, getter=isDragable) BOOL dragable;
@property BOOL bounces;
@property ModalTransitonDirection direction;
@property CGFloat behindViewScale;
@property CGFloat behindViewAlpha;
@property CGFloat transitionDuration;

- (id)initWithModalViewController:(UIViewController *)modalViewController;
- (void)setContentScrollView:(UIScrollView *)scrollView;

@end
