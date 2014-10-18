#import "XMLElement.h"

@implementation XMLElement
- (NSMutableArray *) subElements
{
    if (_subElements == nil)
    {
        _subElements = [[NSMutableArray alloc] init];
    }
    return _subElements;
}
@end