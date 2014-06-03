

@class CityModel;


@interface IconDownloader : NSObject

@property (nonatomic, strong) NSString * iconName;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
