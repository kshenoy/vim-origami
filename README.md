#vim-origami

Plugin to satisfy all your folding needs  
 * Justify all the open-fold markers  
 * Create new open/close foldmarkers conveniently  


##Screenshots
![vim-origami_unaligned]()  
The before ... foldmarkers strewn all over the place  
  
![vim-origami_aligned]()  
The after ... all the foldmarkers aligned neatly in a column  
  
![vim-origami_staggered]()  
Staggered alignment visually showing the heirarchy  
  
![vim-origami_column]()  
Force the alignment to happen on a particular column  

##Installation
I highly recommend using a plugin manager to do the dirty work for you.
If for some reason, you do not want to use any of them then unzip it to your ~/.vim directory  
  
So, once that's done, out of the box, the followings mappings are defined by default:  


##Usage
````
  <leader>zax  Align all folds of level 'x'  
  <leader>zox  Insert a start foldmarker of level 'x' at the end of line  
  <leader>zcx  Insert an end  foldmarker of level 'x' at the end of line  
  <leader>zOx  Insert a start foldmarker of level 'x' enclosed in comments at the end of line  
  <leader>zCx  Insert an end  foldmarker of level 'x' enclosed in comments at the end of line  
  <leader>ze   Delete a foldmarker present on the line  

  <leader>zaa  Align all the folds
  <leader>zoo  Insert an unnumbered open foldmarker
  <leader>zcc  Insert an unnumbered close foldmarker
  <leader>zOO  Insert a commented unnumbered open foldmarker
  <leader>zCC  Insert a commented unnumbered close foldmarker
````
where 'x' is a number from 0-9. 0 refers to unnumbered folds
