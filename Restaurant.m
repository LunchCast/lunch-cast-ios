#import "BackendlessEntity.h"
#import "Restaurant.h"

#import "Backendless.h"

#import "Tag.h"

#import "Meal.h"


@implementation Restaurant

-(NSString *)createCode
{
  NSString *result = @"Restaurant *restaurant = [Restaurant new];\n"
                      "restaurant.address = [backendless randomString:MIN(25,36)];\n"
                      "restaurant.name = [backendless randomString:MIN(25,36)];\n"
                      "restaurant.telefon = [backendless randomString:MIN(25,36)];\n"
                      "restaurant.eta = @((int)rand()%10000);\n"
                    "restaurant.tags = [NSMutableArray arrayWithObjects:[Tag new], [Tag new], nil];\n"
                    "[backendless.persistenceService save:restaurant response:^(tags *result) {\n"
                    "restaurant.meals = [NSMutableArray arrayWithObjects:[Meal new], [Meal new], nil];\n"
                    "[backendless.persistenceService save:restaurant response:^(meals *result) {\n"
                      "[backendless.persistenceService save:restaurant response:^(Restaurant *result) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";
  return result;
}

-(NSString *)updateCode
{
  NSString *result = @"[backendless.persistenceService first:[Restaurant class]\n"
                      "response:^(BackendlessEntity *result) {\n"
                      "result.address = [backendless randomString:MIN(25,36)];\n"
                      "result.name = [backendless randomString:MIN(25,36)];\n"
                      "result.telefon = [backendless randomString:MIN(25,36)];\n"
                      "result.eta = @((int)rand()%10000);\n"
                      "[backendless.persistenceService save:restaurant response:^(Restaurant *result) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";

  return result;
}

-(NSString *)deleteCode
{
  NSString *result = @"[backendless.persistenceService first:[Restaurant class]\n"
                      "response:^(BackendlessEntity *result) {\n"
                      "[backendless.persistenceService remove:[Restaurant class]\n"
                      "sid:result.objectId\n"
                      "response:^(NSNumber *success) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";
  return result;
}

-(NSString *)basicFindCode
{
    NSString *result = @"QueryOptions *queryOptions = [QueryOptions query];\n"
                        "queryOptions.relationsDepth = @1;\n"
                        "BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];\n"
                        "dataQuery.queryOptions = queryOptions;\n"
                        "[backendless.persistenceService find:[Restaurant class]\n"
                        "dataQuery:[BackendlessDataQuery query]\n"
                        "response:^(BackendlessCollection *collection){\n"
                        "}\n"
                        "error:^(Fault *fault) {\n"
                        "}];";
  return result;
}

-(NSString *)findFirstCode
{
  NSString *result = @"[backendless.persistenceService first:[Restaurant class] response:^(Restaurant *first) {"
                      "} error:^(Fault *fault) {"
                      "}];";
  return result;
}

-(NSString *)findLastCode
{
  NSString *result = @"[backendless.persistenceService last:[Restaurant class] response:^(Restaurant *first) {"
                      "} error:^(Fault *fault) {"
                      "}];";
  return result;
}

-(NSString *)findWithSortCode:(NSArray *)fields
{
  NSString *sort = [fields componentsJoinedByString:@"\", @\""];
  NSString *result =[NSString stringWithFormat:
                     @"BackendlessDataQuery *query = [BackendlessDataQuery query];\n"
                      "query.queryOptions = [QueryOptions query];\n"
                      "query.queryOptions.sortBy = @[@\"%@\"];\n"
                      "[backendless.persistenceService find:[Restaurant class] dataQuery:query response:^(BackendlessCollection *collection) {\n"
                      "} error:^(Fault *Fault) {\n"
                      "}];", sort];
  return result;
}
-(NSString *)findWithReladed:(NSArray *)fields
{
  NSString *sort = [fields componentsJoinedByString:@"\", @\""];
  NSString *result =[NSString stringWithFormat:
                     @"BackendlessDataQuery *query = [BackendlessDataQuery query];\n"
                      "query.queryOptions = [QueryOptions query];\n"
                      "query.queryOptions.related = @[@\"%@\"];\n"
                      "[backendless.persistenceService find:[Restaurant class] dataQuery:query response:^(BackendlessCollection *collection) {\n"
                      "} error:^(Fault *Fault) {\n"
                      "}];", sort];
  return result;
}

-(void)setValuesForProperties
{
  self.address = [backendless randomString:MIN(25,36)];
  self.name = [backendless randomString:MIN(25,36)];
  self.telefon = [backendless randomString:MIN(25,36)];
  self.eta = @((int)rand()%10000);
  self.tags = [NSMutableArray arrayWithObjects:[Tag new], [Tag new], nil];
  self.meals = [NSMutableArray arrayWithObjects:[Meal new], [Meal new], nil];
}
-(void)updateValuesForProperties
{
  self.address = [backendless randomString:MIN(25,36)];
  self.name = [backendless randomString:MIN(25,36)];
  self.telefon = [backendless randomString:MIN(25,36)];
  self.eta = @((int)rand()%10000);
}
@end