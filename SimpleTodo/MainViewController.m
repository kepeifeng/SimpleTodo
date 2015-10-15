//
//  MainViewController.m
//  SimpleTodo
//
//  Created by Kent on 10/13/15.
//  Copyright © 2015 Kent. All rights reserved.
//

#import "MainViewController.h"
#import "STTask.h"
#import "NSFileManager+Utility.h"
#import "STTaskCell.h"



@interface MainViewController ()<NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>

@end

@implementation MainViewController{
    NSTableView * _tableView;
    NSMutableArray * _items;
    NSString * _dataPath;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    NSString * folderUrl = [[NSFileManager defaultManager] supportFolderPath];
    _dataPath = [folderUrl stringByAppendingPathComponent:@"task_data"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:_dataPath]) {
        _items = [[NSKeyedUnarchiver unarchiveObjectWithFile:_dataPath] mutableCopy];
    }
    
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    

    
    NSView * contentView = [[AKView alloc] initWithFrame:NSMakeRect(10, 10, CGRectGetWidth(self.view.bounds) - 10 * 2, CGRectGetHeight(self.view.bounds) - 10 * 2)];
    [self.view addSubview:contentView];
    
    NSTextField * textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentView.bounds), 20)];
    textField.bezeled = YES;
    textField.bezelStyle = NSTextFieldRoundedBezel;
    textField.delegate = self;
    [textField.cell setSendsActionOnEndEditing:NO];
    [textField setTarget:self];
    [textField setAction:@selector(textFieldReturnHandle:)];

    [contentView addSubview:textField];
    
    CGRect scrollViewFrame = contentView.bounds;
    scrollViewFrame.origin.y = CGRectGetMaxY(textField.frame) + 5;
    scrollViewFrame.size.height -= CGRectGetMaxY(textField.frame) + 5;
    
    NSScrollView * scrolView = [[NSScrollView alloc] initWithFrame:scrollViewFrame];
    [contentView addSubview:scrolView];
    
    _tableView = [[NSTableView alloc] initWithFrame:scrolView.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.intercellSpacing = CGSizeMake(0, 0);//remove space
    _tableView.headerView = nil;
    _tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    
    
    
    scrolView.documentView = _tableView;
    
    NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier:@"ColumnTitle"];
    column.width = CGRectGetWidth(_tableView.bounds);
    
    [_tableView addTableColumn:column];
    
}

-(void)viewDidAppear{
    [super viewDidAppear];
    
    [_tableView reloadData];
}
-(void)viewDidLayout{
    [super viewDidLayout];
}

-(void)loadView{

//    [super loadView];
    NSView * view = [[AKView alloc] initWithFrame:(NSMakeRect(0, 0, 400, 400))];
    self.view = view;
}

-(void)textFieldReturnHandle:(NSTextField *)sender{
    NSLog(@"%@", sender.stringValue);
    NSString * text = sender.stringValue;
    if(text.length == 0){
        return;
    }
    
    STTask * task = [[STTask alloc] init];
    task.title = text;
    
    [_items insertObject:task atIndex:0];
    [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:(NSTableViewAnimationSlideRight)];
    
    
    [self save];
    
    sender.stringValue = @"";
}


-(void)save{

    [NSKeyedArchiver archiveRootObject:_items toFile:_dataPath];
    
}

-(void)checkBoxClicked:(NSButton *)sender{

    CGPoint point = [sender convertPoint:CGPointZero toView:_tableView];
    NSInteger row = [_tableView rowAtPoint:point];
    STTask * task = [_items objectAtIndex:row];
    task.done = (sender.state == NSOnState);
    [self save];
}

#pragma mark - Table View Delegate

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{


    return _items.count;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{

//    return 60.0;
    STTask * task = [_items objectAtIndex:row];
    
    return [STTaskCell cellSizeForTask:task width:CGRectGetWidth(_tableView.bounds)].height;
}



-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{

    STTaskCell * taskCell = [tableView makeViewWithIdentifier:@"TextCell" owner:self];

    STTask * task = [_items objectAtIndex:row];
    
    if (!taskCell) {
        taskCell = [[STTaskCell alloc] initWithFrame:(NSMakeRect(0,0, CGRectGetWidth(tableView.bounds), 60))];
        taskCell.identifier = @"TextCell";
        [taskCell.checkBox setTarget:self];
        [taskCell.checkBox setAction:@selector(checkBoxClicked:)];
        
    }
//    textFiled.backgroundColor = [NSColor redColor];

//    CGSize size = [STTaskCell cellSizeForTask:task width:CGRectGetWidth(tableView.bounds)];
//    taskCell.frame = NSMakeRect(0,0,CGRectGetWidth(tableView.bounds), size.height);
    taskCell.textField.stringValue = task.title;
    
//    taskCell.textField.backgroundColor = [NSColor redColor];

    return taskCell;
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(STTaskCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{

//    if (tableView.selectedRow == row) {
//        cell.textField.backgroundColor = [NSColor redColor];
//    }else{
//        cell.textField.backgroundColor = [NSColor clearColor];
//    }
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification{

    NSLog(@"row:%d", _tableView.selectedRow);
    
}
#pragma mark - Text Field Delegate

@end
