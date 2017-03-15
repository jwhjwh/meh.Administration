

#import "LVModel.h"

@implementation LVModel


+ (instancetype)modalWith:(NSString *)name call:(NSString*)Call no:(NSString *)ID_No image:(NSString *)image time:(NSString*)time roleld:(NSString*)roleld{
    LVModel *model = [[self alloc] init];
    model.name = name;
    model.Call = Call;
    model.ID_No = ID_No;
    model.image=image;
    model.time=time;
    model.roleld=roleld;
    return model;
}

@end
