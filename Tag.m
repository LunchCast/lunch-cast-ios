#import "BackendlessEntity.h"
#import "Tag.h"

#import "Backendless.h"


@implementation Tag

-(NSString *)createCode
{
  NSString *result = @"Tag *tag = [Tag new];\n"
                      "tag.name = [backendless randomString:MIN(25,36)];\n"
                      "[backendless.persistenceService save:tag response:^(Tag *result) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";
  return result;
}

-(NSString *)updateCode
{
  NSString *result = @"[backendless.persistenceService first:[Tag class]\n"
                      "response:^(BackendlessEntity *result) {\n"
                      "result.name = [backendless randomString:MIN(25,36)];\n"
                      "[backendless.persistenceService save:tag response:^(Tag *result) {\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n"
                      "} error:^(Fault *fault) {\n"
                      "}];\n";

  return result;
}

-(NSString *)deleteCode
{
  NSString *result = @"[backendless.persistenceService first:[Tag class]\n"
                      "response:^(BackendlessEntity *result) {\n"
                      "[backendless.persistenceService remove:[Tag class]\n"
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
                        "[backendless.persistenceService find:[Tag class]\n"
                        "dataQuery:[BackendlessDataQuery query]\n"
                        "response:^(BackendlessCollection *collection){\n"
                        "}\n"
                        "error:^(Fault *fault) {\n"
                        "}];";
  return result;
}

-(NSString *)findFirstCode
{
  NSString *result = @"[backendless.persistenceService first:[Tag class] response:^(Tag *first) {"
                      "} error:^(Fault *fault) {"
                      "}];";
  return result;
}

-(NSString *)findLastCode
{
  NSString *result = @"[backendless.persistenceService last:[Tag class] response:^(Tag *first) {"
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
                      "[backendless.persistenceService find:[Tag class] dataQuery:query response:^(BackendlessCollection *collection) {\n"
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
                      "[backendless.persistenceService find:[Tag class] dataQuery:query response:^(BackendlessCollection *collection) {\n"
                      "} error:^(Fault *Fault) {\n"
                      "}];", sort];
  return result;
}

-(void)setValuesForProperties
{
  self.name = [backendless randomString:MIN(25,36)];
}
-(void)updateValuesForProperties
{
  self.name = [backendless randomString:MIN(25,36)];
}
@end