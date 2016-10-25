# Mark
Xcode extension for automatic generation of //MARK: - comments.

### Why? 
If you would like to organize your code with //MARK: - comments, this will save you some time.
Mark automatically generates comments from any class, struct, protocol or extension declaration in the current file.

### Installation Guide (Xcode 8 / OSX 10.11+)

- close Xcode
- (*OSX 10.11 only*) `sudo /usr/libexec/xpccachectl`
- download the [Mark app]
- unzip and copy to Applications folder
- run (right click + open)
- ` -> System Preferences... -> Extensions -> All -> Enable Mark`
- open Xcode
- select a Swift source file
- check if `Editor -> Mark` is there 
- (/^▽^)/

### Usage

To populate comments in the entire file go to 'Editor -> Mark -> Mark All'.
![mark_all.gif](/Resources/mark_all.gif)

To generate comments from selection, select text and go to 'Editor -> Mark -> Mark Selected'.
![mark_selected.gif](/Resources/mark_selected.gif)

To insert an emty mark simply go to 'Editor -> Mark -> Mark Selected'.
![mark_empty.gif](/Resources/mark_empty.gif)

### Supported languages
- Swift

### License

MIT, see LICENSE
