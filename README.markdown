# vim-foldit  
A small plugin to align all the open-fold markers  


## Requirements


## Installation
I highly recommend using Pathogen or Vundler to do the dirty work for you. If
for some reason, you do not want to use any of these excellent plugins, then
unzip it to your ~/.vim directory. You know how it goes...  

So, once that's done, out of the box, the followings mappings are defined by
default

````
  zjj : Align all folds  
````
This will allow the use of default behavior of m to set marks and, if the line
already contains the mark, it'll be unset.  
The default behavior of `]'`, `['`, ``]` `` and ``[` `` is supported and enhanced by
wrapping around when beginning or end of file is reached.  
  

## Customisation
The defaults not to your liking bub? Have no fear; use the following
variables to set things just the way you want it  

`g:FoldItDefaultMappings` ( Default : 1 )  
Will use the default mappings specified below.  

`g:FoldItPadding` ( Default : 0 )  
Specify extra padding to be added. By default alignment happens on the next
tabstop  

`g:FoldItIncAllLines` ( Default : 0 )
Specify if all lines should be considered while aligning markers. If set to
1, the markers will be present outside then length of the longest line.  

```
  <Plug>FIT_JustifyFolds : Align all folds
```
  
## ToDo:
* Provide Customisation based upon existing settings of softtab, expandtab etc.  
* Think of things to add here : /  
