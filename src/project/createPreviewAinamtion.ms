



d = (getfilenamepath (trimRight maxFilePath "\\/") )
animaticFolder = (getfilenamepath (trimRight d "\\/") )+"ANIMATIC"

 preview_name = animaticFolder+"//"+getFilenameFile(maxfilename)+".avi" 
 
 try(
 
	deleteFile preview_name
	 view_size = [renderWidth ,renderHeight]
	 anim_bmp = bitmap view_size.x view_size.y filename:preview_name
	 for t = animationrange.start to animationrange.end do
	 (
	  sliderTime = t
	  dib = gw.getViewportDib()
	  copy dib anim_bmp
	  save anim_bmp
	 )
	 close anim_bmp
	 gc()
	 ramplayer preview_name ""
	 
	 
 )catch(print "failed ")
 