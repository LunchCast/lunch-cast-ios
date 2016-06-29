#import "DataObjects.h"



@interface Meal : NSObject<DataObjects>

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *ownerId;

@property (nonatomic, strong) NSDate *created;

@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSDate *updated;

@property (nonatomic, strong) NSString *objectId;

@property (nonatomic, strong) NSString *mealDescription;

@property (nonatomic, strong) NSString *name;

@end
                    