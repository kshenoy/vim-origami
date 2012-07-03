#vim-origami

Plugin to satisfy all your folding needs
 * Justify all the open-fold markers
 * Create new open-fold marker and justify it automatically

##Requirements

##Installation     
I highly recommend using Pathogen or Vundler to do the dirty work for you. If
for some reason, you do not want to use any of these excellent plugins, then
unzip it to your ~/.vim directory. You know how it goes...  

So, once that's done, out of the box, the followings mappings are defined by
default  

````
  ztt : Align all folds  
  zxt : When 'x' is a number from 1-9, align folds of that particular fold-level
        When 'x' is 0, align all unnumbered folds
  zxf : Create a new justified open-fold marker of fold-level 'x'
        When 'x' is 0, create new unnumbered open-fold marker
  zxF : Same as above, but also comments the marker. Requires NERDCommenter
````

##Customisation:    
The defaults not to your liking bub? Have no fear; use the following
variables to set things just the way you want it  

`g:OrigamiDefaultMappings` ( Default : 1 )  
Will use the default mappings specified below.  

`g:OrigamiPadding` ( Default : 0 )  
Specify extra padding to be added. By default alignment happens on the next tabstop.  
This behaves differently depending on whether `expandtab` is set or not. If yes, this specifies the number of spaces to insert and if not,  
it specifies the number of tabs to be inserted.

`g:OrigamiIncAllLines` ( Default : 0 )  
Specify if all lines should be considered while aligning markers or only those having the marker.  
If set to 1, the markers will be present outside the length of the longest line irrespective of if it has a fold-open marker or not.

`g:OrigamiSeparateLvls` ( Default : 0 )  
Align different fold-levels independently

`g:OrigamiFoldAtCol` ( Default : 0 )  
Force the markers to align at the specified column. If set to 0, will
auto-detect alignment position.


##ToDo:             
Dunno what to do : /
