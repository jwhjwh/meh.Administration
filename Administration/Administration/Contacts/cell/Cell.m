

#import "Cell.h"

@implementation Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        self.imageViweH = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.imageViweH.layer.cornerRadius = 20;
        self.imageViweH.layer.masksToBounds = YES;
        self.imageViweH.backgroundColor = [UIColor whiteColor];
        self.imageViweH.center = self.contentView.center;
        [self.contentView addSubview:self.imageViweH];
    }
    return self;
}

@end
