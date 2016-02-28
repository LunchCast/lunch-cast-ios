#import "DataObjects.h"


@class Meal;
                
@class Order;
                
@class BackendlessUser;
                

@interface OrderItem : NSObject<DataObjects>

@property (nonatomic, strong) NSDate *created;

@property (nonatomic, strong) NSString *objectId;

@property (nonatomic, strong) NSNumber *quantity;

@property (nonatomic, strong) NSString *ownerId;

@property (nonatomic, strong) NSDate *updated;

@property (nonatomic, strong) Meal *meal;
@property (nonatomic, strong) Order *order_id;
@property (nonatomic, strong) BackendlessUser *orderer;
@end
                    