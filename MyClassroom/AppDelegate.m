//
//  AppDelegate.m
//  MyClassroom
//
//  Created by Dmitry on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize fvc;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.fvc = (FudgeViewController*)self.window.rootViewController;

    //Default settings
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (![prefs objectForKey:@"currentClass"])
	{
		[prefs setObject:[NSNumber numberWithInt:0] forKey:@"currentClass"];
	}
    
    if (![prefs objectForKey:@"studentLocations"] && ![prefs objectForKey:@"deskLocations"])
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSArray array]];
        
        [prefs setObject:data forKey:@"studentLocations"];
        [prefs setObject:data forKey:@"deskLocations"];
        
        [prefs synchronize];
    }
    
    if (![prefs objectForKey:@"classes"])
    {
        NSMutableArray *defaultClasses = [NSMutableArray arrayWithObject:[NSMutableArray array]];
        
        for (int i=0; i<100; i++)
            [[defaultClasses objectAtIndex:0] addObject:[Student defaultStudent]];
                
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:defaultClasses];
        
        [prefs setObject:data forKey:@"classes"];
        [prefs synchronize];
    }
    
    if (![prefs objectForKey:@"periodNames"])
    {
        NSMutableArray *names = [NSMutableArray arrayWithObject:@"Default"];
        
        [prefs setObject:names forKey:@"periodNames"];
        [prefs synchronize];
    }
    
    if (![prefs objectForKey:@"showNames"])
    {
        [prefs setObject:[NSNumber numberWithBool:TRUE] forKey:@"showNames"];
        [prefs synchronize];
    }
    
    if (![prefs objectForKey:@"showNames"])
    {
        [prefs setObject:[NSNumber numberWithBool:TRUE] forKey:@"emptyMessage"];
        [prefs synchronize];
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
        KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
        vc.mode = KKPasscodeModeEnter;
        vc.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(),^ {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                nav.navigationBar.barStyle = UIBarStyleBlack;
                nav.navigationBar.opaque = NO;
            
            [self.fvc presentModalViewController:nav animated:YES];
        });
        
    }
}

- (void)shouldEraseApplicationData:(KKPasscodeViewController*)viewController 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have entered an incorrect passcode too many times. All account data in this app has been deleted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = 1;
    [alert show];
}

- (void)didPasscodeEnteredIncorrectly:(KKPasscodeViewController*)viewController 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have entered an incorrect passcode too many times." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = 2;
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) //too many incorrect - quitting
      exit(0);
  
    else if (alertView.tag == 1) // too many incorrect - erasing
    {
        [[KKPasscodeLock sharedLock] setDefaultSettings];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:[NSNumber numberWithInt:0] forKey:@"currentClass"];

        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSArray array]];
        [prefs setObject:data forKey:@"studentLocations"];
        [prefs setObject:data forKey:@"deskLocations"];
        

        NSMutableArray *defaultClasses = [NSMutableArray arrayWithObject:[NSMutableArray array]];
        for (int i=0; i<100; i++) [[defaultClasses objectAtIndex:0] addObject:[Student defaultStudent]];
        data = [NSKeyedArchiver archivedDataWithRootObject:defaultClasses];
        [prefs setObject:data forKey:@"classes"];


        NSMutableArray *names = [NSMutableArray arrayWithObject:@"Default"];
        [prefs setObject:names forKey:@"periodNames"];


        [prefs setObject:[NSNumber numberWithBool:TRUE] forKey:@"showNames"];
        [prefs setObject:[NSNumber numberWithBool:TRUE] forKey:@"emptyMessage"];
        
        [prefs synchronize];
        
        exit(0);

    }
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
