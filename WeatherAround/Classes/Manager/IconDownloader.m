

#import "IconDownloader.h"
#import "CityModel.h"

#define kAppIconSize 48

@interface IconDownloader ()
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@end


@implementation IconDownloader

#pragma mark

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    NSString *url = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",_iconName];

    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    
    
    NSString * imgPath = [NSString stringWithFormat:@"%@",
                          [[[Utility sharedInstance] dataStoragePath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",_iconName]].path];
    
    [self.activeDownload writeToFile:imgPath atomically:YES];
    
    
     //writeToFile:imgPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    

    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
        
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}

@end

