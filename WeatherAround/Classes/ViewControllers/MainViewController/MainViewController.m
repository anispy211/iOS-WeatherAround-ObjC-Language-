//
//  ViewController.m
//  WeatherAround
//
//  Created by Aniruddha Kadam on 19/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import "MainViewController.h"
#import "Defines.h"
#import "LocationManager.h"
#import "WeatherAPIModel.h"
#import "WetherInfoCell.h"
#import "CityWeatherDetailViewController.h"
#import "IconDownloader.h"
#import "CityModel.h"

#define REFRESH_HEADER_HEIGHT 72.0f


@interface MainViewController ()<LocationManagerDelegate,WeatherAPIModelDelegate>
{
    LocationManager * locationMgr;
    WeatherAPIModel * weatherAPIModel;
}
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

- (IBAction)addCityButtonAction:(id)sender;


@end

@implementation MainViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        
        cities = [[NSMutableArray alloc] init];
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if ([[Utility sharedInstance] isNetworkAvailable] == YES)
        
        
        if (__i386__)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Location Feature is disabled for simultor" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        [self configureCurrentUserLocation];
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Please check your network connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    weatherAPIModel = [[WeatherAPIModel alloc] initWithAPIKey:APIKEY];
    [weatherAPIModel setDelegate:self];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)configureCurrentUserLocation
{
    [WAAppDelegate showProgressHUD:@"Identifying Location.." forView:self.view];
    locationMgr = [LocationManager sharedSingleton];
    [locationMgr setDelegate:self];
    [locationMgr startLocationUpdate];
}




#pragma mark - LocationManagerDelegate

- (void)locationManagerDidUpdateToLocation:(CLLocation *)currentLocation
{
    
    [WAAppDelegate hideProgressHUDForView:self.view];
    [locationMgr stopLocationUpdate];
    
    CLLocationCoordinate2D coordinate = [currentLocation coordinate];
    [weatherAPIModel currentWeatherByCoordinate:coordinate];
    
    [WAAppDelegate showProgressHUD:@"Loading..." forView:self.view];
    
    
    
    
}

- (void)locationManagerDidLocateCityName:(NSString *)cityName
{
    [WAAppDelegate hideProgressHUDForView:self.view];
    
//    NSString * msg = [NSString stringWithFormat:@"Your location is identified as %@",cityName];
//    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alert show];
    
    [weatherAPIModel currentWeatherByCityName:[NSString stringWithFormat:@"%@",[cityName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    
    [WAAppDelegate showProgressHUD:@"Loading..." forView:self.view];
    


    
}

- (void)locationManagerDidFailWithError:(NSError *)error
{
    
    [WAAppDelegate hideProgressHUDForView:self.view];
    NSLog(@"%@",error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


#pragma mark UI Methods

- (void)disableUI
{
    [self.tableView setUserInteractionEnabled:NO];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (void)enableUI
{
    [self.tableView setUserInteractionEnabled:YES];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}


#pragma mark - Update Weather Mehtod  // Called every 1 minute

- (void)updateWeatherInfo
{
    
    if ([[Utility sharedInstance] isNetworkAvailable] == YES)
    {

        
        if ([cities count] == 0) {
            return;
        }
        
        [self disableUI];
       
        [weatherAPIModel currentWeatherforCities:cities];
        
        [WAAppDelegate showProgressHUD:@"Refreshing..." forView:self.view];

    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Please check your network connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}


#pragma mark - NetworkRequestDelegate

-(void)weatherAPIDidReturnValueForAllCities:(NSMutableArray *)cityArr
{
    if (cityArr) {
        
        [self replaceCityObjectOfMainCityArrayFrom:cityArr];
        
        [self.tableView reloadData];
        [WAAppDelegate hideProgressHUDForView:self.view];
        isLoading = NO;

    }
    
        [self enableUI];
}


- (void)replaceCityObjectOfMainCityArrayFrom:(NSArray *)responeArray
{
    
    
    for (CityModel * cityModel in responeArray)
    {
     
    // cityModel.idString
    NSArray * filteredArray;
    
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.cityName == %@",cityModel.cityName];
    filteredArray = [cities filteredArrayUsingPredicate:bPredicate];
    if ([filteredArray count] > 0) {
        NSInteger index = [cities indexOfObject:[filteredArray objectAtIndex:0]];
        [cities replaceObjectAtIndex:index withObject:cityModel];
    }
    else
        [cities addObject:[responeArray lastObject]];
        
    }

    
}

-(void)weatherAPIDidReturnValu:(NSArray *)dataArray
{
    NSLog(@"Data Count %d",dataArray.count);
    
    [WAAppDelegate hideProgressHUDForView:self.view];
    
    if ([cities count] > 0)
        [self replaceCityObjectOfMainCityArrayFrom:dataArray];
    else
    {
        [cities addObject:[dataArray lastObject]];
    }
    
    [self.tableView reloadData];
    
    
    [[Utility sharedInstance] setCurrentCityList:cities];
    
    [self enableUI];

    
}



-(void)weatherAPIDidReturnValuWithError:(NSString *)error
{
    NSLog(@"Error: %@",error);
    
    [WAAppDelegate hideProgressHUDForView:self.view];
    
    NSString * msg = [NSString stringWithFormat:@"%@",error];
    
    [self enableUI];

    
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:msg message:@"Please enter correct city name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlert show];
    
}



#pragma mark - UITableView Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cities count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if ([cities count]>0)
    {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    }
    else
    {
        [self.tableView setEditing:NO];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    
    
    return 1;
}

#pragma mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identifier = @"MainCell";
    
    WetherInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell)
    {
        
        CityModel * infoModel = [cities objectAtIndex:indexPath.row];
        cell.cityNameLbl.text = [NSString stringWithFormat:@"%@ , %@",infoModel.cityName,infoModel.countryName];
        cell.Datelbl.text = infoModel.wehtherDesc;
        cell.tempLbl.text = infoModel.currentTemp;
        
        
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:[[[Utility sharedInstance] dataStoragePath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",infoModel.wehtherIconName]].path] && cell.iconImgView.image == nil)
        {
            
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:infoModel forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.iconImgView.image = nil;
        }
        else
        {
            
            NSString * imgPath = [NSString stringWithFormat:@"%@",
                                  [[[Utility sharedInstance] dataStoragePath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",infoModel.wehtherIconName]].path];
            
            UIImage * image= [UIImage imageWithContentsOfFile:imgPath];
            cell.iconImgView.image = image;
            
            
        }
        
    }
    
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [cities removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView endUpdates];
        [tableView reloadData];
        
        
    }
}

#pragma mark - Scroll View Delegates

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{ if (isLoading) {
    // Update the content inset, good for section headers
    if (scrollView.contentOffset.y > 0)
        self.tableView.contentInset = UIEdgeInsetsZero;
    else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
        self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (isDragging && scrollView.contentOffset.y < 0) {
    // Update the arrow direction and label
    [UIView animateWithDuration:0.25 animations:^{
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            //refreshLabel.text = self.textRelease;
           // [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else {
            // User is scrolling somewhere within the header
          //  refreshLabel.text = self.textPull;
            //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
    }];
}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self updateWeatherInfo];
    }

}




#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(CityModel *)infoModel forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.iconName = infoModel.wehtherIconName;
        [iconDownloader setCompletionHandler:^{
            
            WetherInfoCell *cell = (WetherInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            
            NSString * imgPath = [NSString stringWithFormat:@"%@",
                                  [[[Utility sharedInstance] dataStoragePath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",infoModel.wehtherIconName]].path];
            UIImage * image= [UIImage imageWithContentsOfFile:imgPath];
            cell.iconImgView.image = image;
            
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}


#pragma mark - Segue method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PushDetailView"])
    {
        // Get reference to the destination view controller
        CityWeatherDetailViewController *vc = [segue destinationViewController];
        // Pass any objects to the view controller here, like...
        [vc setCityModel:[cities objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
    }
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString * str = [alertView textFieldAtIndex:0].text;
        if ([str isEqualToString:@""])
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter city name and then press OK" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        else
        {
            
            if ([[Utility sharedInstance] isNetworkAvailable] == YES)
                [self addWeatherForCityName:[NSString stringWithFormat:@"%@",[str stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
            else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Please check your network connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            
        }
        
    }
}



#pragma mark - UIButton Actions

- (IBAction)addCityButtonAction:(id)sender
{
    
    UIAlertView * inputAlert = [[UIAlertView alloc] initWithTitle:@"Enter City Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [inputAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[inputAlert textFieldAtIndex:0] setTextAlignment:NSTextAlignmentCenter];
    [inputAlert show];
}

- (IBAction)edtitButtonAction:(id)sender
{
    UIBarButtonItem *tmpButton = sender;
    
    if ([tmpButton.title isEqualToString:@"Edit"])
    {
        [self.tableView setEditing:YES];
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    else
    {
        [self.tableView setEditing:NO];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    
}


- (void)addWeatherForCityName:(NSString *)name
{
    weatherAPIModel = [[WeatherAPIModel alloc] initWithAPIKey:APIKEY];
    [weatherAPIModel setDelegate:self];
    [weatherAPIModel currentWeatherByCityName:name];
    [WAAppDelegate showProgressHUD:@"Loading..." forView:self.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
}

@end
