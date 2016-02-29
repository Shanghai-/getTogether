//
//  MapViewController.m
//  getTogether
//
//  Created by Brendan Walsh  on 9/18/14.
//  Copyright (c) 2014 pluvicInc. All rights reserved.
//

#import "MapViewController.h"
#import "UserDataSingleton.h"
#import "GTImageHandler.h"
#import "OtherUser.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController ()

@end

@implementation MapViewController {
    GMSMapView *mapView_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIImagePickerController
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] init];
    spinner.center = self.view.center;
    spinner.frame = CGRectMake(self.view.center.x, self.view.center.y, 250, 250);
    [spinner startAnimating];
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    
    // Create a GMSCameraPosition
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.786558
                                                            longitude:-73.978994
                                                                 zoom:15];
    
    //self.mapContainer.clipsToBounds = YES;
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height - 70) camera:camera];
    mapView_.myLocationEnabled = YES;
    [self.view addSubview:mapView_];
    
    /*GMSCameraPosition *actualpos = [GMSCameraPosition cameraWithLatitude:mapView_.myLocation.coordinate.latitude
                                                               longitude:mapView_.myLocation.coordinate.longitude
                                                                    zoom:15];
    [mapView_ setCamera:actualpos];*/
    
    UserDataSingleton *singleton = [UserDataSingleton getInstance];
    int uID = [[singleton getUserID] intValue];
    NSURL *sessionPartnersURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://walsh.browning.edu/getSessionPartners.php?userID=%i", uID]];
    /*NSURLConnection *usersConn = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:sessionPartnersURL] delegate:self];*/
    
    //Look up each user
    //Download their marker colors, avatar, and location
    //Create a marker with their colors and avatar
    //Place the marker at their location
    OtherUser *testuser = [[OtherUser alloc] init];
    testuser.username = @"llamalover12";
    testuser.firstname = @"Carl";
    testuser.lastname = @"Wheezer";
    testuser.userID = [NSNumber numberWithInt:1];
    testuser.isOnline = YES;
    testuser.isAvailable = YES;
    testuser.markerColor = [UIColor blueColor];
    testuser.latitude = [NSNumber numberWithFloat:40.7867804];
    testuser.longitude = [NSNumber numberWithFloat:-73.9794041];
    
    OtherUser *testuser2 = [[OtherUser alloc] init];
    testuser2.username = @"ectobiologist";
    testuser2.firstname = @"John";
    testuser2.lastname = @"Egbert";
    testuser2.userID = [NSNumber numberWithInt:2];
    testuser2.isOnline = YES;
    testuser2.isAvailable = YES;
    testuser2.markerColor = [UIColor yellowColor];
    testuser2.latitude = [NSNumber numberWithFloat:40.7786119];
    testuser2.longitude = [NSNumber numberWithFloat:-73.9816265];
    
    //NSArray *currentSessions = [NSArray arrayWithObjects:testuser, testuser2, nil];
    _users = [NSMutableArray arrayWithObjects:testuser, testuser2, nil];
    
    for (OtherUser *u in _users) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        NSURL *avatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://walsh.browning.edu/users/%i/avatar.png", [u.userID intValue]]];
        UIImage *avatarImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarURL]];
        if (avatarImg == nil) avatarImg = [UIImage imageNamed:@"defaultAvatar"];
        [marker setIcon:[GTImageHandler markerImageWithAvatar:avatarImg Color:u.markerColor]];
        marker.title = [u fullname];
        marker.snippet = [NSString stringWithFormat:@"@%@", u.username];
        marker.position = CLLocationCoordinate2DMake([u.latitude doubleValue], [u.longitude doubleValue]);
        marker.map = mapView_;
     }
    
    NSTimer *locationTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                              target:self
                                                            selector:@selector(pingLocations)
                                                            userInfo:nil repeats:YES];
    
    //NSString *urlString = [NSString stringWithFormat:@"http://walsh.browning.edu/users/%i/avatar.png", [[u userID] intValue]];
    
    // Creates a marker in the center of the map.
    /*GMSMarker *marker = [[GMSMarker alloc] init];
    [marker setIcon:[GTImageHandler markerImageWithAvatar:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://33.media.tumblr.com/4fc45640ef448b7fca7a72e04d34b1bc/tumblr_ndhurxfGZP1tysn5ko1_250.png"]]] Color:[UIColor blueColor]]];
    marker.position = CLLocationCoordinate2DMake(40.786558, -73.978994);
    marker.title = @"You";
    marker.map = mapView_;*/
    
    /*
    if (!error) {
        _users = [NSMutableArray arrayWithArray:(NSArray *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]];
        if (!error && _users) {
            //Send asynchronous request - sends location data, then downloads the new location data
            //Put it on a timer
            NSURL *getLocationsURL = [NSURL URLWithString:[NSString stringWithFormat:@"f"]];
        } else {
            NSLog(@"Error parsing JSON");
        }
    } else {
        NSLog(@"Connection error");
    }*/
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pingLocations {
    NSLog(@"Beginning ping...");
    //If connection is strong, send and receive data
    NSString *pingString = [self generateLocationPingString];
    NSLog(@"URL generator returned: %@", pingString);
    NSURL *locationPing = [[NSURL alloc] initWithString:pingString];
    NSLog(@"URL connection: %@", locationPing.description);
    //[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:locationPing] delegate:self];
    [[NSURLConnection alloc] initWithRequest:[[NSURLRequest alloc] initWithURL:locationPing] delegate:self];
}

- (NSString *)generateLocationPingString {
    UserDataSingleton *singleton = [UserDataSingleton getInstance];
    int uID = [[singleton getUserID] intValue];
    NSString *result = [NSString stringWithFormat:@"walsh.browning.edu/pingLocation.php?userID=%i&latitude=%f&longitude=%f",
                        uID, mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude];
    for (OtherUser *Partner in _users) {
        result = [result stringByAppendingString:[NSString stringWithFormat:@"&partners[]=%i", Partner.userID.intValue]];
    }
    return result;
}

/*-(NSString *) arrayToPHPString:(NSArray *)arr withVarName:(NSString *)base {
    NSLog(@"String creator invoked");
    NSString *resultString = [NSString string];
    for (int i=0; i < arr.count; i++) {
        NSLog(@"appending string...");
        [resultString stringByAppendingString:[NSString stringWithFormat:@"&%@[]=%@", base, [(NSNumber *)arr[i] description]]];
    }
    NSLog(resultString);
    return resultString;
}*/

#pragma mark - NSURLConnectionDelegate Methods

//Called when the server responds to the asynchronous data request.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
    NSLog(@"Response received!");
}

//Called when the asynchronous data request receives data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
    NSLog(@"Incoming data...");
}

//Called when the connection will cache the url or something???
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

//Called when the connection finishes loading all data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Connection finished!");
    
    NSError *err = [[NSError alloc] init];
    /*_users = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&err];
    NSLog([_users description]);*/
    _locations = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&err];
    NSLog(_locations.description);
}

//Called if the connection fails
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *badConnection = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"The connection to the server failed. Please try again later."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
    [badConnection show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
