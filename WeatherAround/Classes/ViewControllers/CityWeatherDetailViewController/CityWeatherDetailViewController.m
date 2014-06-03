//
//  CityWeatherDetailViewController.m
//  WeatherAround
//
//  Created by Aniruddhaon 14/05/14.
//  Copyright (c) 2014 Aniruddha kadam. All rights reserved.
//

#import "CityWeatherDetailViewController.h"
#import "WetherInfoCell.h"
#import "WetherInfoDataModal.h"
#import "WeatherAPIModel.h"
#import "IconDownloader.h"


@interface CityWeatherDetailViewController () <UITableViewDataSource,UITableViewDelegate,WeatherAPIModelDelegate>
{
    WeatherAPIModel * weatherAPIModel;
    
}

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;



@property (strong, nonatomic) IBOutlet UILabel *citnNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *weatherDescLbl;
@property (strong, nonatomic) IBOutlet UILabel *currentTempLbl;
@property (strong, nonatomic) IBOutlet UILabel *currentDayLbl;


@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *forecastArray;

@end

@implementation CityWeatherDetailViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weatherAPIModel = [[WeatherAPIModel alloc] initWithAPIKey:APIKEY];
    [weatherAPIModel setDelegate:self];
    
    if (_cityModel) {
        
        [self.citnNameLbl setText:_cityModel.cityName];
        [self.weatherDescLbl setText:_cityModel.wehtherDesc];
        [self.currentTempLbl setText:_cityModel.currentTemp];
        
        [self fetchForcastData];
        
    }
    
    [self setUILayout];
    
    
}

-(void)setUILayout
{
    [self.tableView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.tableView.layer setBorderWidth:1];
}

- (NSString *)getDayFromDate:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* component = [calender components:NSWeekdayCalendarUnit fromDate:[dateFormatter dateFromString:dateString]];
    
    int weekDay = [component weekday];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *weekdayString = [[formatter weekdaySymbols] objectAtIndex:weekDay - 1];
    return weekdayString;
}

- (void)fetchForcastData
{
    
    if ([[Utility sharedInstance] isNetworkAvailable] == YES)
    {
        
        [weatherAPIModel dailyForecastWeatherByCityName: [NSString stringWithFormat:@"%@",[_cityModel.cityName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] withCount:7];
        [WAAppDelegate showProgressHUD:nil forView:self.tableView];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Please check your network connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - WeatherAPIModelDelegate method


-(void)weatherAPIDidReturnValu:(NSArray *)dataArray
{
    NSLog(@"Response");
    
    _forecastArray = dataArray;
    
    [self.tableView setSeparatorColor:[UIColor whiteColor]];
    [self.tableView reloadData];
    [WAAppDelegate hideProgressHUDForView:self.tableView];
    
}

-(void)weatherAPIDidReturnValuWithError:(NSString *)error
{
    NSLog(@"%@",error);
    
    [WAAppDelegate hideProgressHUDForView:self.tableView];
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error retriving forecast detail" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
}


#pragma mark - UITableView Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_forecastArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

#pragma mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identifier = @"DetailCell";
    
    WetherInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell)
    {
        
        WetherInfoDataModal * infoModel = [_forecastArray objectAtIndex:indexPath.row];
        
        [cell.dayLbl setText:[self getDayFromDate:infoModel.wehtherDate]];
        [cell.minMaxTempLbl setText:[NSString stringWithFormat:@"%@ %@",infoModel.maxTemp,infoModel.minTemp]];
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:[[[Utility sharedInstance] dataStoragePath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",infoModel.weatherIcon]].path] && cell.iconImgView.image == nil)
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
                                  [[[Utility sharedInstance] dataStoragePath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",infoModel.weatherIcon]].path];
            
            UIImage * image= [UIImage imageWithContentsOfFile:imgPath];
            cell.iconImgView.image = image;
            
            
        }
        
        
    }
    
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundColor:[UIColor clearColor]];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    CityWeatherDetailViewController *itemDetail = [[CityWeatherDetailViewController alloc] init];
    //    [self.storyboard instantiateViewControllerWithIdentifier:@"WeatherDetailView"];
    //    [self.navigationController pushViewController:itemDetail animated:NO];
}


#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(WetherInfoDataModal *)infoModel forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.iconName = infoModel.weatherIcon;
        [iconDownloader setCompletionHandler:^{
            
            WetherInfoCell *cell = (WetherInfoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            
            NSString * imgPath = [NSString stringWithFormat:@"%@",
                                  [[[Utility sharedInstance] dataStoragePath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",infoModel.weatherIcon]].path];
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




- (void)dealloc
{
    [weatherAPIModel setDelegate:nil];
#if !__has_feature(objc_arc)
	
	[super dealloc];
#endif
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
