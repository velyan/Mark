# Mark
Xcode extension for automatic generation of MARK comments.

![mark_all.gif](/Resources/mark_all.gif)

### Why? 
If you would like to organize your code with MARK comments, this will save you some time.
Mark automatically generates comments from any class, struct, enum, protocol or extension declaration in the current file.

### Installation Guide (Xcode 8 / OSX 10.11+)

1. close Xcode
2. (*OSX 10.11 only*) `sudo /usr/libexec/xpccachectl`
3. download the [Mark app](https://github.com/velyan/Mark/releases/download/v1.0.0/Mark.zip)
4. unzip and copy to Applications folder
5. run (right click + open)
6. ` -> System Preferences... -> Extensions -> All -> Enable Mark`
7. open Xcode
8. select a Swift source file
9. check if `Editor -> Mark` is there 
10. (/^▽^)/

### Usage

- To populate comments in the entire file go to 'Editor -> Mark -> Mark All'.

- To generate comments from selection, select text and go to 'Editor -> Mark -> Mark Selected'.

![mark_selected.gif](/Resources/mark_selected.gif)

- To insert an emty mark simply go to 'Editor -> Mark -> Mark Selected'.

![mark_empty.gif](/Resources/mark_empty.gif)

### Supported languages
- Swift

### License

MIT, see LICENSE
