//
//  NVRepostCell.m
//  45. APIWithoutAccessToken
//
//  Created by Admin on 03.09.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NVRepostCell.h"
#import "NVAttachmentCell.h"
#import "NVWallHeaderCell.h"
#import "NVWallPost.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation NVRepostCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithWallPost:(NVWallPost*) wallPost andParentRect:(UITableView*) parentTableView
{
    self = [super init];
    if (self) {
        self.attachmentCells=[NSMutableDictionary new];
        self.wallPost=wallPost;
        self.parentTableView=parentTableView;
        UITableView* tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(parentTableView.bounds), 600) style:UITableViewStylePlain];
        
        self.tableView=tableView;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.scrollEnabled = NO;
        [self.tableView reloadData];
        self.tableView.frame=CGRectMake(0, 0, CGRectGetWidth(parentTableView.bounds), CGRectGetHeight(self.tableRect));
        NSLog(@"height in viewdidload %@",NSStringFromCGRect(self.tableView.frame));
        [self addSubview:self.tableView];
        
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //NSLog(@" numberOfSectionsInTableView %ld",[self.arrayOfWallPosts count]);
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@" numberOfRowsInSection %ld",[self.wallPost.arrayOfData count]);
    for (NSString* obj in self.wallPost.arrayOfDataNames){
        NSLog(@"name: %@",obj);
    }
    return [self.wallPost.arrayOfData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NVWallPost* wallPost=self.wallPost;
    
    if ([[wallPost.arrayOfDataNames objectAtIndex:indexPath.row] isEqualToString:@"author"]) {
        static NSString* identifier = @"headerCell";
        NVWallHeaderCell* cell=[self.parentTableView dequeueReusableCellWithIdentifier:identifier];
        
        
        cell.labelDate.text=wallPost.dateOfPost;
        cell.labelUser.text=[NSString stringWithFormat:@"%@ %@",wallPost.author.firstName,wallPost.author.lastName];
        NSURL* url=wallPost.author.photo50;
        NSURLRequest* request=[NSURLRequest requestWithURL:url];
        __weak NVWallHeaderCell* weakCell=cell;
        
        [cell.imageViewUser setImageWithURLRequest:request placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               [weakCell.imageViewUser setImage:image];
                                               [weakCell layoutSubviews];
                                               
                                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                               
                                           }];
        
        return cell;
    } else if ([[wallPost.arrayOfDataNames objectAtIndex:indexPath.row] isEqualToString:@"text"]) {
        static NSString* identifier2 = @"textCell";
        UITableViewCell* cell=[self.parentTableView dequeueReusableCellWithIdentifier:identifier2];
        cell.textLabel.numberOfLines=0;
        cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
        cell.textLabel.text=wallPost.text;
        //NSLog(@"wallPost %@",wallPost.text);
        
        return cell;
    } else if ([[wallPost.arrayOfDataNames objectAtIndex:indexPath.row] isEqualToString:@"attachments"]) {
        //NVAttachmentCell* cell=[[NVAttachmentCell alloc]initWithAttachments:wallPost.attachments andParentRect:self.tableView.bounds];
        //NSLog(@"index path %ld %ld",(long)indexPath.section,(long)indexPath.row);
        
        NVAttachmentCell* cell=[self.attachmentCells objectForKey:indexPath];
        return cell;
    }
    
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight=0;
    NVWallPost* wallPost=self.wallPost;
    
    
    if ([[wallPost.arrayOfDataNames objectAtIndex:indexPath.row] isEqualToString:@"attachments"]){
        NVAttachmentCell* cell=nil;
        if ([self.attachmentCells objectForKey:indexPath]) {
            cell=[self.attachmentCells objectForKey:indexPath];
        } else {
            cell=[[NVAttachmentCell alloc]initWithAttachments:wallPost.attachments andParentRect:self.tableView.bounds];
            [self.attachmentCells setObject:cell forKey:[self keyForIndexPath:indexPath]];
        }
       
        rowHeight=CGRectGetMinY(cell.lastFrame);
        
    } else {
        rowHeight=50.f;
    }
    
    self.tableRect=CGRectMake(0, 0, CGRectGetWidth(self.parentTableView.bounds), CGRectGetHeight(self.tableRect)+rowHeight);
    //NSLog(@"height inside%f",CGRectGetHeight(self.tableRect));
    
    return rowHeight;
    
}
- (NSIndexPath *)keyForIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath class] == [NSIndexPath class]) {
        return indexPath;
    }
    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
}
@end