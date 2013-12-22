This has undergone significant changes, hopefully for the better.  
If you prefer to use the earlier version, you can download it from [here](https://github.com/kshenoy/vim-origami/archive/stable_03997ef.zip)

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
  <leader>zax  Align all folds of level 'x'  
  <leader>zox  Insert a start foldmarker of level 'x' at the end of line  
  <leader>zcx  Insert an end  foldmarker of level 'x' at the end of line  
  <leader>zOx  Insert a start foldmarker of level 'x' enclosed in comments at the end of line  
  <leader>zCx  Insert an end  foldmarker of level 'x' enclosed in comments at the end of line  
  <leader>zd   Delete a foldmarker present on the line  

  <leader>zaa  Align all the folds
  <leader>zoo  Insert an unnumbered open foldmarker
  <leader>zcc  Insert an unnumbered close foldmarker
  <leader>zOO  Insert a commented unnumbered open foldmarker
  <leader>zCC  Insert a commented unnumbered close foldmarker
````
where 'x' is a number from 0-9. 0 refers to unnumbered folds
