#import "DataObjects.h"



@interface UserSubscription : NSObject<DataObjects>

@property (nonatomic, strong) NSDate *created;

@property (nonatomic, strong) NSString *objectId;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *ownerId;

@property (nonatomic, strong) NSDate *updated;

@property (nonatomic, strong) NSMutableArray *tags;
@end
                    