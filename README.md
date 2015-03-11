For some time now, I've been wanting to clean up the code and finally got around to it.  
However, I also ended up removing some features that I felt were not useful in a bid to keep things simple.  
I also have changed the default maps in order to get rid of ugly leader maps and now the commands accept a count instead of accepting it as an input.  
If you prefer to use the earlier version, you can download it from [here](https://github.com/kshenoy/vim-origami/archive/stable_055e333.zip)

#vim-origami

Plugin to satisfy all your folding needs  
 * Justify all the open-fold markers  
 * Create new open/close foldmarkers conveniently  

If you like the plugin, show some love by rating it at [vim.org](http://www.vim.org/scripts/script.php?script_id=4613) and spreading the word.

##Screenshots
###### Before: foldmarkers strewn all over the place  
![vim-origami_unaligned](https://github.com/kshenoy/vim-origami/blob/images/vim-origami_1.png?raw=true)  
  
###### After: all the foldmarkers aligned neatly in a column  
![vim-origami_aligned](https://github.com/kshenoy/vim-origami/blob/images/vim-origami_2.png?raw=true)  

###### Staggered alignment visually showing the heirarchy  
![vim-origami_staggered](https://github.com/kshenoy/vim-origami/blob/images/vim-origami_3.png?raw=true)  

###### Force the alignment to happen on a particular column  
![vim-origami_column](https://github.com/kshenoy/vim-origami/blob/images/vim-origami_4.png?raw=true)  

##Installation
I highly recommend using a plugin manager to do the dirty work for you.
If for some reason, you do not want to use any of them then unzip it to your ~/.vim directory  
  

##Usage
So, once that's done, out of the box, the followings mappings are defined by default:  
````
  `<count>Za`  Align all folds of level 'count'
         `ZA`  Align all folds
  `<count>ZF`  Insert a start foldmarker of level 'count' at the end of line and comment it
  `<count>Zf`  Insert a start foldmarker of level 'count' at the end of line but don't comment it
  `<count>ZC`  Insert an end  foldmarker of level 'count' at the end of line and comment it
  `<count>Zc`  Insert an end  foldmarker of level 'count' at the end of line but don't comment it
         `ZD`  Delete the foldmarker from the line
````
If no count is given, then the actions are performed on unnumbered folds
