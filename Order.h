#import "DataObjects.h"


@class Restaurant;
                
@class BackendlessUser;
                

@interface Order : NSObject<DataObjects>

@property (nonatomic, strong) NSString *ownerId;

@property (nonatomic, strong) NSString *order_time;

@property (nonatomic, strong) NSDate *updated;

@property (nonatomic, strong) NSString *objectId;

@property (nonatomic, strong) NSString *state;

@property (nonatomic, strong) NSDate *created;

@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) BackendlessUser *order_creator;
@end
                    