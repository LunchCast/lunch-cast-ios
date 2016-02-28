#import <Foundation/Foundation.h>

@protocol DataObjects <NSObject>

-(NSString *)createCode;
-(NSString *)updateCode;
-(NSString *)deleteCode;
-(NSString *)basicFindCode;
-(NSString *)findFirstCode;
-(NSString *)findLastCode;
-(NSString *)findWithSortCode:(NSArray *)fields;
-(NSString *)findWithReladed:(NSArray *)fields;
-(void)setValuesForProperties;
-(void)updateValuesForProperties;
@end