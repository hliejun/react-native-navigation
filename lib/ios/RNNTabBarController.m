#import "RNNTabBarController.h"
#import "RNNUtils.h"

@implementation RNNTabBarController {
	NSUInteger _currentTabIndex;
}

- (id<UITabBarControllerDelegate>)delegate {
	return self;
}

- (void)viewDidLayoutSubviews {
	[self.presenter viewDidLayoutSubviews];
}

- (UIViewController *)getCurrentChild {
	return self.selectedViewController;
}

- (CGFloat)getTopBarHeight {
    for(UIViewController * child in [self childViewControllers]) {
        CGFloat childTopBarHeight = [child getTopBarHeight];
        if (childTopBarHeight > 0) return childTopBarHeight;
    }
    return [super getTopBarHeight];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return self.selectedViewController.supportedInterfaceOrientations;
}

- (void)setSelectedIndexByComponentID:(NSString *)componentID {
	for (id child in self.childViewControllers) {
		UIViewController<RNNLayoutProtocol>* vc = child;

		if ([vc conformsToProtocol:@protocol(RNNLayoutProtocol)] && [vc.layoutInfo.componentId isEqualToString:componentID]) {
			[self setSelectedIndex:[self.childViewControllers indexOfObject:child]];
		}
	}
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
	_currentTabIndex = selectedIndex;
	[super setSelectedIndex:selectedIndex];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return self.selectedViewController.preferredStatusBarStyle;
}

#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	[self.eventEmitter sendBottomTabSelected:@(tabBarController.selectedIndex) unselected:@(_currentTabIndex)];
	_currentTabIndex = tabBarController.selectedIndex;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
 	// Recursively reset scrolls on old view before changing tabs
	// Credit: https://github.com/minhloi/react-native-navigation/commit/108e9b3b2d489916c92d3e9a6b0d461759915ea1
	[RNNUtils stopDescendentScrollViews: tabBarController.selectedViewController.view];
	return YES;
}

@end
