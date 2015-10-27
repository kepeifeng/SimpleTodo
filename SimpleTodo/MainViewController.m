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
#import "STTableView.h"



@interface MainViewController ()<NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, STTableViewDelegate>

@end

@implementation MainViewController{
    NSTableView * _tableView;
    NSMutableArray * _items;
    NSString * _dataPath;
    NSTextField * _textField;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
//    return;
    
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
    
    _textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(contentView.bounds), 20)];
    _textField.bezeled = YES;
    _textField.bezelStyle = NSTextFieldRoundedBezel;
    _textField.delegate = self;
    [_textField.cell setSendsActionOnEndEditing:NO];
    [_textField setTarget:self];
    [_textField setAction:@selector(textFieldReturnHandle:)];

    [contentView addSubview:_textField];
    
    CGRect scrollViewFrame = contentView.bounds;
    scrollViewFrame.origin.y = CGRectGetMaxY(_textField.frame) + 10;
    scrollViewFrame.size.height -= CGRectGetMaxY(_textField.frame) + 10;
    
    NSScrollView * scrolView = [[NSScrollView alloc] initWithFrame:scrollViewFrame];
    [contentView addSubview:scrolView];
    
    _tableView = [[STTableView alloc] initWithFrame:scrolView.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.intercellSpacing = CGSizeMake(0, 0);//remove space
    _tableView.headerView = nil;
    _tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    _tableView.allowsMultipleSelection = YES;
    
    _tableView.wantsLayer = YES;
    _tableView.layer.cornerRadius = 3.0f;
    _tableView.layer.masksToBounds = YES;
    
    
    scrolView.documentView = _tableView;
    
    NSTableColumn * column = [[NSTableColumn alloc] initWithIdentifier:@"ColumnTitle"];
    column.width = CGRectGetWidth(_tableView.bounds);
    
    [_tableView addTableColumn:column];
    
}

-(void)viewDidAppear{
    [super viewDidAppear];
    
    [_tableView reloadData];
//    [_textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:1];
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
    [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NSTableViewAnimationSlideDown];
    
    
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
    

    NSInteger oldIndex = [_items indexOfObject:task];

    NSInteger newIndex = 0;
    if (task.done) {
        [_items removeObjectAtIndex:oldIndex];
        [_items addObject:task];
        newIndex = _items.count - 1;
    }else{
        [_items removeObjectAtIndex:oldIndex];
        [_items insertObject:task atIndex:0];
        newIndex = 0;
    }
    
    task.updateDate = [NSDate date];
//    CGRect rect = [_tableView rectOfRow:oldIndex];
    
    STTaskCell * taskCell = [_tableView viewAtColumn:0 row:oldIndex makeIfNecessary:NO];
    if (taskCell) {
        taskCell.actived = !task.done;
    }
    
    if (oldIndex != newIndex) {
        [_tableView moveRowAtIndex:oldIndex toIndex:newIndex];
    }
    

    
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
    taskCell.checkBox.state = (task.done)?NSOnState:NSOffState;
    
    
    taskCell.highlighted = [tableView.selectedRowIndexes containsIndex:row];
    taskCell.actived = !task.done;
    return taskCell;
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(STTaskCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{

//    if (tableView.selectedRow == row) {
//        cell.textField.backgroundColor = [NSColor redColor];
//    }else{
//        cell.textField.backgroundColor = [NSColor clearColor];
//    }
}



-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{

    NSLog(@"shouldSelectRow:%d",row);
    return YES;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification{

    NSRange visibleRange = [_tableView rowsInRect:_tableView.visibleRect];
    [_tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndexesInRange:visibleRange] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    NSLog(@"row:%@", _tableView.selectedRowIndexes);
    
}

-(void)tableView:(NSTableView *)tableView keyPressed:(NSString *)keys modifierFlags:(NSEventModifierFlags)modifierFlags{

    unichar key = [keys characterAtIndex:keys.length-1];
    if (key == NSDeleteCharacter) {
        [self deleteSelectedRow];
    }else if(key == 'c' && (modifierFlags & NSCommandKeyMask) == NSCommandKeyMask){
//        NSLog(@"Copy");
        [self copySelectedRow];
        
    }
}

-(void)deleteSelectedRow{

    NSIndexSet  *indexSet = _tableView.selectedRowIndexes;
    [_items removeObjectsAtIndexes:indexSet];
    [_tableView removeRowsAtIndexes:indexSet withAnimation:(NSTableViewAnimationSlideUp)];
    [self save];
}

-(void)copySelectedRow{

    NSIndexSet * indexSet = [_tableView selectedRowIndexes];
    NSMutableArray * stringArray = [[NSMutableArray alloc] initWithCapacity:indexSet.count];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        STTask * task = _items[idx];
        if(task.title.length){
            [stringArray addObject:task.title];
        }
    }];
    
    NSString * result = [stringArray componentsJoinedByString:@"\n"];
    [[NSPasteboard generalPasteboard] declareTypes:@[NSPasteboardTypeString] owner:self];
    [[NSPasteboard generalPasteboard] setString:result forType:NSPasteboardTypeString];
    
    
    
}
#pragma mark - Text Field Delegate

@end
