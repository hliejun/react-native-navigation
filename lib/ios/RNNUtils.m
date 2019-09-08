#import "RNNUtils.h"

@implementation RNNUtils
+(double)getDoubleOrKey:(NSDictionary*)dict withKey:(NSString*)key withDefault:(double)defaultResult {
	if ([dict objectForKey:key]) {
		return [dict[key] doubleValue];
	} else {
		return defaultResult;
	}
}

+(BOOL)getBoolOrKey:(NSDictionary*)dict withKey:(NSString*)key withDefault:(BOOL)defaultResult {
	if ([dict objectForKey:key]) {
		return [dict[key] boolValue];
	} else {
		return defaultResult;
	}
}

+(id)getObjectOrKey:(NSDictionary*)dict withKey:(NSString*)key withDefault:(id)defaultResult {
	if ([dict objectForKey:key]) {
		return dict[key];
	} else {
		return defaultResult;
	}
}

+(NSNumber *)getCurrentTimestamp {
	return [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] * 1000];
}

// Recursively stop and reset y-axis scrolling given a parent view
// [Modified] Credit: https://github.com/minhloi/react-native-navigation/commit/108e9b3b2d489916c92d3e9a6b0d461759915ea1
+(void)stopDescendentScrollViews: (UIView*) view {
	// Handle scroll views only
	if([view isKindOfClass:[UIScrollView class]]) {
		UIScrollView* scrollView = (UIScrollView*) view;
		CGPoint offset = scrollView.contentOffset;
		CGFloat top = -scrollView.contentInset.top;
		
		// If overscrolled, reset to top (with inset if applicable)
		if (offset.y <= top) {
			[scrollView setContentOffset:CGPointMake(offset.x, top) animated:NO];
		}
		
		// Otherwise, preserve scroll position
		else {
			[scrollView setContentOffset:offset animated:NO];
		}
		
		// Signal end of scroll (if scroll delegate is available)
		if ([scrollView.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
			[[(UIScrollView*)view delegate] scrollViewDidEndDecelerating:(id)view];
		}
	}
	
	// If not a scroll view, recursively apply scroll reset strategy on subview tree(s)
	else {
		for (UIView *subview in view.subviews) {
			[self stopDescendentScrollViews:subview];
		}
	}
}

// Get raw root view controller
// Credit: https://github.com/minhloi/react-native-navigation/commit/108e9b3b2d489916c92d3e9a6b0d461759915ea1
+(UIViewController*) getTopViewController {
	return [self getTopViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

// Given root view controller, handle and get logical root by type
// Credit: https://github.com/minhloi/react-native-navigation/commit/108e9b3b2d489916c92d3e9a6b0d461759915ea1
+(UIViewController*) getTopViewController: (UIViewController*)rootViewController {
	if ([rootViewController isKindOfClass:[UITabBarController class]]) {
		UITabBarController* tabBarController = (UITabBarController*)rootViewController;
		return [self getTopViewController:tabBarController.selectedViewController];
	} else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
		UINavigationController* navigationController = (UINavigationController*)rootViewController;
		return [self getTopViewController:navigationController.visibleViewController];
	} else if (rootViewController.presentedViewController) {
		UIViewController* presentedViewController = rootViewController.presentedViewController;
		return [self getTopViewController:presentedViewController];
	} else {
		return rootViewController;
	}
}

@end
